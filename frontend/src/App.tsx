import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { Sparkles, Utensils } from 'lucide-react'
import { ControlCenter } from '@/components/mealcraft/control-center'
import { MealStage } from '@/components/mealcraft/meal-stage'
import { MoodTracker } from '@/components/mealcraft/mood-tracker'
import { QuickOrder } from '@/components/mealcraft/quick-order'
import { StrongAvocado, BudgetCoin, ChefHat } from '@/components/mealcraft/food-characters'
import { toast } from 'sonner'

export interface UserPreferences {
  age: number
  weight: number
  height: number
  gender: 'male' | 'female'
  activityLevel: 'sedentary' | 'light' | 'moderate' | 'active' | 'very-active'
  budget: number
  dietaryRestrictions: string[]
}

export interface MealPlan {
  breakfast: { name: string; calories: number; cost: number }
  lunch: { name: string; calories: number; cost: number }
  dinner: { name: string; calories: number; cost: number }
}

const defaultPreferences: UserPreferences = {
  age: 25,
  weight: 70,
  height: 170,
  gender: 'male',
  activityLevel: 'moderate',
  budget: 2500,
  dietaryRestrictions: [],
}

const sampleMealPlan: MealPlan = {
  breakfast: { name: 'Avocado Toast with Eggs', calories: 450, cost: 800 },
  lunch: { name: 'Mediterranean Quinoa Bowl', calories: 620, cost: 1200 },
  dinner: { name: 'Grilled Salmon with Vegetables', calories: 580, cost: 1800 },
}

function calculateBMR(prefs: UserPreferences): number {
  // Harris-Benedict Equation
  if (prefs.gender === 'male') {
    return 88.362 + (13.397 * prefs.weight) + (4.799 * prefs.height) - (5.677 * prefs.age)
  }
  return 447.593 + (9.247 * prefs.weight) + (3.098 * prefs.height) - (4.330 * prefs.age)
}

function calculateTDEE(prefs: UserPreferences): number {
  const bmr = calculateBMR(prefs)
  const multipliers = {
    'sedentary': 1.2,
    'light': 1.375,
    'moderate': 1.55,
    'active': 1.725,
    'very-active': 1.9,
  }
  return Math.round(bmr * multipliers[prefs.activityLevel])
}

export default function App() {
  const [preferences, setPreferences] = useState<UserPreferences>(defaultPreferences)
  const [mealPlan, setMealPlan] = useState<MealPlan>(sampleMealPlan)
  const [isGenerating, setIsGenerating] = useState(false)
  const [healthScore, setHealthScore] = useState(78)

  const recommendedCalories = calculateTDEE(preferences)
  const isLowBudget = preferences.budget < 3000

  const handleGenerate = async () => {
    setIsGenerating(true)
    try {
      const response = await fetch('http://localhost:8080/api/mealplan/generate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(preferences)
      })

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}))
        throw new Error(errorData.message || 'Failed to generate meal plan')
      }

      // Artificial delay so the floating ChefHat animation has time to show
      await new Promise(resolve => setTimeout(resolve, 1500))

      const newPlan = await response.json()
      setMealPlan(newPlan)
      setHealthScore(Math.min(100, healthScore + Math.floor(Math.random() * 10)))
      toast.success('Meal plan generated successfully!')
    } catch (error) {
      console.error(error)
      toast.error(error instanceof Error ? error.message : 'Failed to generate meal plan. Try adjusting your preferences.')
    } finally {
      setIsGenerating(false)
    }
  }

  return (
    <div className="h-screen w-screen p-4 md:p-6">
      {/* Floating Characters Layer */}
      <div className="fixed inset-0 pointer-events-none z-10">
        <AnimatePresence>
          {isGenerating && (
            <motion.div
              initial={{ x: -100, opacity: 0 }}
              animate={{ x: '100vw', opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 3, ease: 'easeInOut' }}
              className="absolute top-1/2 -translate-y-1/2"
            >
              <ChefHat isActive />
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      {/* Main Bento Grid */}
      <div className="h-full grid grid-cols-1 lg:grid-cols-12 grid-rows-[auto_1fr_auto] lg:grid-rows-1 gap-4 md:gap-6 max-w-[1800px] mx-auto">
        {/* Left Column - Control Center */}
        <motion.div 
          className="lg:col-span-3 lg:row-span-1"
          initial={{ x: -50, opacity: 0 }}
          animate={{ x: 0, opacity: 1 }}
          transition={{ duration: 0.5 }}
        >
          <div className="h-full bg-card/70 backdrop-blur-xl rounded-[2rem] border border-border/50 shadow-xl p-6 overflow-hidden">
            <div className="flex items-center gap-3 mb-6">
              <div className="w-10 h-10 rounded-2xl bg-primary/20 flex items-center justify-center">
                <Utensils className="w-5 h-5 text-primary" />
              </div>
              <div>
                <h1 className="font-fredoka text-xl font-semibold text-foreground">MealCraft</h1>
                <p className="text-xs text-muted-foreground">AI Smart Planner</p>
              </div>
            </div>
            
            <ControlCenter 
              preferences={preferences}
              onPreferencesChange={setPreferences}
              recommendedCalories={recommendedCalories}
              onGenerate={handleGenerate}
              isGenerating={isGenerating}
            />

            {/* Reactive Avocado */}
            <div className="mt-6 flex justify-center">
              <StrongAvocado calorieGoal={recommendedCalories} />
            </div>
          </div>
        </motion.div>

        {/* Center Column - Meal Stage */}
        <motion.div 
          className="lg:col-span-6 lg:row-span-1"
          initial={{ y: 50, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ duration: 0.5, delay: 0.1 }}
        >
          <div className="h-full bg-card/60 backdrop-blur-xl rounded-[2rem] border border-border/50 shadow-xl p-6 relative overflow-hidden">
            {/* Decorative gradient */}
            <div className="absolute inset-0 bg-gradient-to-br from-primary/5 via-transparent to-accent/5 pointer-events-none" />
            
            <div className="relative z-10 h-full flex flex-col">
              <div className="flex items-center justify-between mb-4">
                <div>
                  <h2 className="font-fredoka text-2xl font-semibold text-foreground">{"Today's Menu"}</h2>
                  <p className="text-sm text-muted-foreground">Personalized for your goals</p>
                </div>
                <motion.button
                  onClick={handleGenerate}
                  disabled={isGenerating}
                  className="flex items-center gap-2 px-4 py-2 bg-primary text-primary-foreground rounded-2xl font-medium text-sm shadow-lg disabled:opacity-50"
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                >
                  <Sparkles className="w-4 h-4" />
                  {isGenerating ? 'Crafting...' : 'Generate'}
                </motion.button>
              </div>

              <MealStage 
                mealPlan={mealPlan}
                isGenerating={isGenerating}
                recommendedCalories={recommendedCalories}
              />
            </div>
          </div>
        </motion.div>

        {/* Right Column - Mood + Quick Order */}
        <motion.div 
          className="lg:col-span-3 lg:row-span-1 flex flex-col gap-4 md:gap-6"
          initial={{ x: 50, opacity: 0 }}
          animate={{ x: 0, opacity: 1 }}
          transition={{ duration: 0.5, delay: 0.2 }}
        >
          {/* Mood Tracker */}
          <div className="flex-1 bg-card/70 backdrop-blur-xl rounded-[2rem] border border-border/50 shadow-xl p-6 overflow-hidden">
            <MoodTracker healthScore={healthScore} />
          </div>

          {/* Quick Order */}
          <div className="flex-1 bg-card/70 backdrop-blur-xl rounded-[2rem] border border-border/50 shadow-xl p-6 overflow-hidden relative">
            <QuickOrder mealPlan={mealPlan} budget={preferences.budget} />
            
            {/* Budget Characters */}
            <AnimatePresence>
              {isLowBudget && (
                <motion.div
                  initial={{ scale: 0, opacity: 0 }}
                  animate={{ scale: 1, opacity: 1 }}
                  exit={{ scale: 0, opacity: 0 }}
                  className="absolute bottom-4 right-4"
                >
                  <BudgetCoin isLowBudget />
                </motion.div>
              )}
            </AnimatePresence>
          </div>
        </motion.div>
      </div>
    </div>
  )
}
