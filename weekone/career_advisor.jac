"""AI Career Path Advisor"""
import from byllm.llm { Model }

# Initialize Gemini model (uses GOOGLE_API_KEY from env)
glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=False);

"""Analyze skills and suggest career paths"""
def suggest_careers(skills: list, interests: list, experience: str) -> str by llm();

"""Provide learning roadmap for a career"""
def create_roadmap(career: str, current_skills: list) -> str by llm();

# ----------------------------
# Walker definition
# ----------------------------
walker CareerExplorer {
    has skills: list = [];
    has interests: list = [];
    has experience: str = "";
    has recommended_careers: list = [];
    has current_career: career_detail = None;
    
    can start with entry;
    can analyze_profile with entry;
    can explore_career with entry;
}

# ----------------------------
# Nodes
# ----------------------------
node career_hub {
    has description: str = "Career assessment center";
}

node career_detail {
    has career_name: str;
    has description: str = "No description available.";
    has required_skills: list = [];
    has growth_outlook: str = "";
}

# ----------------------------
# Entry point
# ----------------------------
with entry:__main__ {
    print("🤖 Welcome to AI Career Path Advisor!");
    
    user_skills = input("Enter your skills (comma-separated): ").split(",");
    user_interests = input("Enter your interests (comma-separated): ").split(",");
    user_experience = input("Current experience level (beginner/intermediate/advanced): ");
    
    root spawn CareerExplorer(
        skills=user_skills,
        interests=user_interests,
        experience=user_experience
    );
}

# ----------------------------
# Abilities
# ----------------------------
impl CareerExplorer.start {
    if not [root --> (`?career_hub)] {
        next = root ++> career_hub();
    } else {
        next = [root --> (`?career_hub)];
    }
    visit next;
}

impl CareerExplorer.analyze_profile {
    print("🔍 Analyzing your profile...");
    
    career_analysis = suggest_careers(
        self.skills, 
        self.interests, 
        self.experience
    );
    
    print("\n💡 Career Suggestions:");
    print(career_analysis);
    
    chosen_career = input("\nWhich career would you like to explore further? ");
    
    if chosen_career {
        self.current_career = career_detail(career_name=chosen_career);
        self.explore_career;
    }

}

impl CareerExplorer.explore_career {
    print("\n📊 Career: ", self.current_career.career_name);
    
    roadmap = create_roadmap(self.current_career.career_name, self.skills);
    
    print("\n🎯 Personalized Learning Roadmap:");
    print(roadmap);
    
    explore_more = input("\nWould you like to explore another career? (yes/no): ");
    if explore_more.lower() == "yes" {
        visit [--> career_hub];
    } else {
        print("🚀 Good luck on your career journey!");
        disengage;
    }
}