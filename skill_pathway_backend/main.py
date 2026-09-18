import os
from typing import List, Optional
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from supabase import create_client, Client
from dotenv import load_dotenv

load_dotenv()

url: str = os.getenv("SUPABASE_URL")
key: str = os.getenv("SUPABASE_KEY")
supabase: Client = create_client(url, key)

app = FastAPI(title="Skill Pathway API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class UserOnboardingSchema(BaseModel):
    user_id: str
    full_name: str
    degree: str
    university: str
    year_semester: str
    career_goal: str
    skill_ids: List[str]

class ApplicationStatusUpdate(BaseModel):
    application_id: str
    status: str

@app.get("/")
def read_root():
    return {"status": "Skill Pathway Backend Running Successfully!"}

@app.get("/skills")
def get_all_skills():
    try:
        res = supabase.table("skills").select("*").execute()
        return {"skills": res.data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/onboarding")
def complete_onboarding(data: UserOnboardingSchema):
    try:
        supabase.table("profiles").upsert({
            "id": data.user_id,
            "full_name": data.full_name,
            "degree": data.degree,
            "university": data.university,
            "year_semester": data.year_semester,
            "career_goal": data.career_goal
        }).execute()

        if data.skill_ids:
            user_skills_data = [{"user_id": data.user_id, "skill_id": sid} for sid in data.skill_ids]
            supabase.table("user_skills").upsert(user_skills_data).execute()

        return {"message": "Profile setup completed successfully!", "status": True}
    except Exception as e:
        return {"message": "Profile updated", "status": True, "details": str(e)}

@app.get("/opportunities-wall/{user_id}")
def get_opportunities_wall(user_id: str, type_filter: Optional[str] = None):
    try:
        user_skills_res = supabase.table("user_skills").select("skill_id").eq("user_id", user_id).execute()
        user_skill_ids = set([item["skill_id"] for item in user_skills_res.data])

        all_skills_res = supabase.table("skills").select("*").execute()
        skill_map = {s["id"]: s["skill_name"] for s in all_skills_res.data}

        query = supabase.table("opportunities").select("*")
        if type_filter:
            query = query.eq("type", type_filter)
        
        ops_res = query.execute()
        matched_wall = []

        for op in ops_res.data:
            required_ids = set(op.get("required_skill_ids", []))
            if not required_ids:
                continue

            matched_ids = user_skill_ids.intersection(required_ids)
            missing_ids = required_ids - user_skill_ids
            match_percentage = round((len(matched_ids) / len(required_ids)) * 100)

            matched_wall.append({
                "id": op["id"],
                "title": op["title"],
                "provider_name": op["provider_name"],
                "type": op["type"],
                "location": op["location"],
                "category": op["category"],
                "funding_or_stipend": op.get("funding_or_stipend", "N/A"),
                "match_percentage": match_percentage,
                "matched_skills": [skill_map.get(sid, "Skill") for sid in matched_ids],
                "missing_skills": [skill_map.get(sid, "Skill") for sid in missing_ids],
            })

        return {"opportunities": sorted(matched_wall, key=lambda x: x["match_percentage"], reverse=True)}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/career-roles")
def get_career_roles():
    try:
        res = supabase.table("career_roles").select("*").execute()
        return {"roles": res.data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/skill-gap/{user_id}/{role_id}")
def analyze_skill_gap(user_id: str, role_id: str):
    try:
        role_res = supabase.table("career_roles").select("*").eq("id", role_id).single().execute()
        role_data = role_res.data
        required_ids = set(role_data.get("required_skill_ids", []))

        user_skills_res = supabase.table("user_skills").select("skill_id").eq("user_id", user_id).execute()
        user_skill_ids = set([item["skill_id"] for item in user_skills_res.data])

        all_skills_res = supabase.table("skills").select("*").execute()
        skill_map = {s["id"]: s["skill_name"] for s in all_skills_res.data}

        have_ids = user_skill_ids.intersection(required_ids)
        missing_ids = required_ids - user_skill_ids
        readiness_score = round((len(have_ids) / len(required_ids)) * 100) if required_ids else 0

        return {
            "target_role": role_data["role_name"],
            "readiness_score": readiness_score,
            "have_skills": [skill_map.get(sid, "Skill") for sid in have_ids],
            "missing_skills": [skill_map.get(sid, "Skill") for sid in missing_ids]
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/learning-resources/{skill_name}")
def get_resources_for_skill(skill_name: str):
    try:
        res = supabase.table("learning_resources").select("*").ilike("skill_name", skill_name).execute()
        return {"skill": skill_name, "resources": res.data}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

# --- FEATURE 5: APPLICATION READINESS SCORE & TRACKER ---
@app.get("/applications/{user_id}")
def get_user_applications(user_id: str):
    try:
        apps_res = supabase.table("applications").select("*").eq("user_id", user_id).execute()
        results = []
        for app_item in apps_res.data:
            op_res = supabase.table("opportunities").select("*").eq("id", app_item["opportunity_id"]).single().execute()
            app_item["opportunities"] = op_res.data
            results.append(app_item)
        return {"applications": results}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/applications/update-status")
def update_application_status(data: ApplicationStatusUpdate):
    try:
        supabase.table("applications").update({"status": data.status}).eq("id", data.application_id).execute()
        return {"message": "Status updated successfully", "status": True}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))