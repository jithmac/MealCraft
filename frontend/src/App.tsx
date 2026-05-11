import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { Sparkles, Utensils } from 'lucide-react'
import { ControlCenter } from '@/components/mealcraft/control-center'
import { MealStage } from '@/components/mealcraft/meal-stage'
import { MoodTracker } from '@/components/mealcraft/mood-tracker'
import { QuickOrder } from '@/components/mealcraft/quick-order'
import { StrongAvocado, ChefHat } from '@/components/mealcraft/food-characters'

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
  breakfast: { name: string; calories: number; cost: number; macros: { protein: number; carbs: number; fat: number } }
  lunch: { name: string; calories: number; cost: number; macros: { protein: number; carbs: number; fat: number } }
  dinner: { name: string; calories: number; cost: number; macros: { protein: number; carbs: number; fat: number } }
}

const defaultPreferences: UserPreferences = {
  age: 25,
  weight: 70,
  height: 170,
  gender: 'male',
  activityLevel: 'moderate',
  budget: 10000,
  dietaryRestrictions: [],
}

const sampleMealPlan: MealPlan = {
  breakfast: { name: 'Avocado Toast with Eggs', calories: 450, cost: 1500, macros: { protein: 20, carbs: 45, fat: 22 } },
  lunch: { name: 'Mediterranean Quinoa Bowl', calories: 620, cost: 2500, macros: { protein: 25, carbs: 70, fat: 28 } },
  dinner: { name: 'Grilled Salmon with Vegetables', calories: 580, cost: 3500, macros: { protein: 42, carbs: 30, fat: 34 } },
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
  const [hasGenerated, setHasGenerated] = useState(false)
  const [healthScore, setHealthScore] = useState(78)
  const [error, setError] = useState<string | null>(null)

  const recommendedCalories = calculateTDEE(preferences)
  const isLowBudget = preferences.budget < 5000

  const handleGenerate = async () => {
    setIsGenerating(true)
    setError(null)

    try {
      const response = await fetch('http://localhost:8080/api/mealplan/generate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          age: preferences.age,
          weight: preferences.weight,
          height: preferences.height,
          gender: preferences.gender,
          activityLevel: preferences.activityLevel,
          budget: preferences.budget,
          dietaryRestrictions: preferences.dietaryRestrictions,
        }),
      })

      if (!response.ok) {
        const errData = await response.json().catch(() => null)
        throw new Error(errData?.message || `Server error: ${response.status}`)
      }

      const data = await response.json()

      // Map the backend response to the frontend MealPlan shape
      setMealPlan({
        breakfast: {
          name: data.breakfast?.name || 'No breakfast found',
          calories: data.breakfast?.calories || 0,
          cost: data.breakfast?.cost || 0,
          macros: { protein: 20, carbs: 45, fat: 22 }, // Prolog doesn't return macros yet
        },
        lunch: {
          name: data.lunch?.name || 'No lunch found',
          calories: data.lunch?.calories || 0,
          cost: data.lunch?.cost || 0,
          macros: { protein: 25, carbs: 70, fat: 28 },
        },
        dinner: {
          name: data.dinner?.name || 'No dinner found',
          calories: data.dinner?.calories || 0,
          cost: data.dinner?.cost || 0,
          macros: { protein: 42, carbs: 30, fat: 34 },
        },
      })

      setHasGenerated(true)
      setHealthScore(Math.min(100, healthScore + Math.floor(Math.random() * 10)))
    } catch (err: any) {
      console.error('Meal plan generation failed:', err)
      setError(err.message || 'Failed to generate meal plan. Is the backend running?')
    } finally {
      setIsGenerating(false)
    }
  }

  return (
    <div className="h-screen w-screen p-4 md:p-6">
      {/* Error Banner */}
      <AnimatePresence>
        {error && (
          <motion.div
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
            className="fixed top-4 left-1/2 -translate-x-1/2 z-50 px-6 py-3 bg-destructive/90 text-destructive-foreground rounded-2xl shadow-lg backdrop-blur-sm max-w-lg text-sm font-medium"
          >
            {error}
            <button onClick={() => setError(null)} className="ml-3 underline opacity-80 hover:opacity-100">Dismiss</button>
          </motion.div>
        )}
      </AnimatePresence>
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
          layout
          className={`${hasGenerated ? 'lg:col-span-3' : 'lg:col-span-5'} lg:row-span-1`}
          initial={{ x: -50, opacity: 0 }}
          animate={{ x: 0, opacity: 1 }}
          transition={{ type: 'spring', stiffness: 300, damping: 30 }}
        >
          <div className="h-full flex flex-col bg-card/70 backdrop-blur-xl rounded-[2rem] border border-border/50 shadow-xl p-6 overflow-hidden">
            <div className="flex items-center gap-3 mb-6 shrink-0">
              <div className="w-10 h-10 rounded-2xl bg-primary/20 flex items-center justify-center">
                <Utensils className="w-5 h-5 text-primary" />
              </div>
              <div>
                <h1 className="font-fredoka text-xl font-semibold text-foreground">MealCraft</h1>
                <p className="text-xs text-muted-foreground">AI Smart Planner</p>
              </div>
            </div>
            
            <div className="flex-1 min-h-0">
              <ControlCenter 
                preferences={preferences}
                onPreferencesChange={setPreferences}
                recommendedCalories={recommendedCalories}
                onGenerate={handleGenerate}
                isGenerating={isGenerating}
                isShrunk={hasGenerated}
                onEdit={() => setHasGenerated(false)}
              />
            </div>
          </div>
        </motion.div>

        {/* Center Column - Meal Stage */}
        <motion.div 
          layout
          className={`${hasGenerated ? 'lg:col-span-6' : 'lg:col-span-4'} lg:row-span-1`}
          initial={{ y: 50, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ type: 'spring', stiffness: 300, damping: 30 }}
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
              </div>

              <MealStage 
                mealPlan={mealPlan}
                isGenerating={isGenerating}
                recommendedCalories={recommendedCalories}
                isShrunk={!hasGenerated}
              />
            </div>
          </div>
        </motion.div>

        {/* Right Column - Mood + Quick Order */}
        <motion.div 
          layout
          className="lg:col-span-3 lg:row-span-1 flex flex-col gap-4 md:gap-6"
          initial={{ x: 50, opacity: 0 }}
          animate={{ x: 0, opacity: 1 }}
          transition={{ type: 'spring', stiffness: 300, damping: 30 }}
        >
          {/* Mood Tracker */}
          <div className="flex-1 bg-card/70 backdrop-blur-xl rounded-[2rem] border border-border/50 shadow-xl p-6 overflow-hidden">
            <MoodTracker healthScore={healthScore} />
          </div>

          {/* Quick Order */}
          <div className="flex-1 bg-card/70 backdrop-blur-xl rounded-[2rem] border border-border/50 shadow-xl p-6 overflow-hidden relative">
            <QuickOrder mealPlan={mealPlan} budget={preferences.budget} />
          </div>
        </motion.div>
      </div>
    </div>
  )
}
