import { useState } from "react"
import { motion, AnimatePresence } from "framer-motion"
import { HappyToast, SaladBowl, HappySteak } from "./food-characters"
import { Coffee, Sun, Moon, Flame, PieChart as PieChartIcon, Utensils } from "lucide-react"
import { PieChart, Pie, Cell, ResponsiveContainer, Tooltip } from "recharts"

interface Macros {
  protein: number;
  carbs: number;
  fat: number;
}

interface MealPlan {
  breakfast: { name: string; calories: number; cost: number; macros?: Macros }
  lunch: { name: string; calories: number; cost: number; macros?: Macros }
  dinner: { name: string; calories: number; cost: number; macros?: Macros }
}

interface MealStageProps {
  mealPlan: MealPlan
  isGenerating: boolean
  recommendedCalories: number
  isShrunk?: boolean
}

const MACRO_COLORS = ['#3b82f6', '#f59e0b', '#10b981']; // Protein, Carbs, Fat

function NutritionChart({ macros }: { macros: Macros }) {
  const data = [
    { name: 'Protein', value: macros.protein },
    { name: 'Carbs', value: macros.carbs },
    { name: 'Fat', value: macros.fat },
  ];

  return (
    <div className="w-full mt-3 pt-3 border-t border-border/30">
      <p className="text-xs font-semibold text-center text-muted-foreground mb-2">Nutrition Breakdown</p>
      <div className="h-32 w-full">
        <ResponsiveContainer width="100%" height="100%">
          <PieChart>
            <Pie
              data={data}
              cx="50%"
              cy="50%"
              innerRadius={25}
              outerRadius={45}
              paddingAngle={2}
              dataKey="value"
              stroke="none"
            >
              {data.map((entry, index) => (
                <Cell key={`cell-${index}`} fill={MACRO_COLORS[index % MACRO_COLORS.length]} />
              ))}
            </Pie>
            <Tooltip 
              contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
              itemStyle={{ fontSize: '12px' }}
            />
          </PieChart>
        </ResponsiveContainer>
      </div>
      <div className="flex justify-center gap-3 text-[10px] mt-2">
        <span className="flex items-center gap-1 font-medium"><div className="w-2 h-2 rounded-full bg-blue-500"></div> Pro</span>
        <span className="flex items-center gap-1 font-medium"><div className="w-2 h-2 rounded-full bg-amber-500"></div> Carb</span>
        <span className="flex items-center gap-1 font-medium"><div className="w-2 h-2 rounded-full bg-emerald-500"></div> Fat</span>
      </div>
    </div>
  )
}

function MealCard({ 
  title, 
  icon: Icon, 
  iconBg, 
  iconColor, 
  meal, 
  character, 
  isGenerating, 
  emoji 
}: { 
  title: string; 
  icon: any; 
  iconBg: string; 
  iconColor: string; 
  meal: { name: string; calories: number; cost: number; macros?: Macros }; 
  character: any; 
  isGenerating: boolean; 
  emoji: string;
}) {
  const [showNutrition, setShowNutrition] = useState(false)
  const fallbackMacros: Macros = { protein: 20, carbs: 40, fat: 15 }

  return (
    <motion.div
      layout
      className="p-4 rounded-3xl bg-card/50 backdrop-blur-sm border border-border/30 shadow-lg flex flex-col relative overflow-hidden"
    >
      <div className="flex items-center justify-between mb-2">
        <div className="flex items-center gap-2">
          <div className={`p-2 rounded-xl ${iconBg}`}>
            <Icon className={`w-4 h-4 ${iconColor}`} />
          </div>
          <span className="font-semibold text-sm">{title}</span>
        </div>
        <motion.button
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
          onClick={() => setShowNutrition(!showNutrition)}
          className="p-1.5 rounded-full bg-secondary text-secondary-foreground hover:bg-secondary/80 transition-colors"
          title="Nutrition Breakdown"
        >
          <PieChartIcon className="w-4 h-4" />
        </motion.button>
      </div>
      
      <motion.div layout className="flex-1 flex justify-center items-center py-2 h-24">
        <AnimatePresence mode="wait">
          {isGenerating ? (
            <motion.div
              key="loading"
              initial={{ opacity: 0, rotate: 0 }}
              animate={{ opacity: 1, rotate: 360 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
              className="text-3xl"
            >
              {emoji}
            </motion.div>
          ) : (
            <motion.div
              key="character"
              initial={{ opacity: 0, scale: 0.5 }}
              animate={{ opacity: 1, scale: 0.7 }}
              exit={{ opacity: 0, scale: 0.5 }}
              className="origin-center"
            >
              {character}
            </motion.div>
          )}
        </AnimatePresence>
      </motion.div>
      
      <motion.div layout className="mt-auto bg-background/50 p-3 rounded-2xl border border-border/20">
        <p className="text-[15px] leading-tight font-semibold text-foreground mb-3">{meal.name}</p>
        <div className="flex justify-between items-center">
          <span className="text-xs font-medium px-2 py-1 bg-accent/10 text-accent rounded-lg flex items-center gap-1">
            <Flame className="w-3 h-3" />
            {meal.calories} kcal
          </span>
          <span className="text-sm font-bold text-primary">Rs. {meal.cost}</span>
        </div>
      </motion.div>

      <AnimatePresence>
        {showNutrition && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: 'auto', opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            className="overflow-hidden"
          >
            <NutritionChart macros={meal.macros || fallbackMacros} />
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  )
}

export function MealStage({ mealPlan, isGenerating, recommendedCalories, isShrunk }: MealStageProps) {
  if (isShrunk) {
    return (
      <div className="flex-1 flex flex-col items-center justify-center h-full p-4">
        <motion.div 
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 0.9 }}
          className="text-center p-8 bg-card/40 backdrop-blur-sm border border-border/20 rounded-[2rem] max-w-sm shadow-sm"
        >
          <div className="w-16 h-16 rounded-3xl bg-accent/10 flex items-center justify-center mx-auto mb-5">
            <Utensils className="w-8 h-8 text-accent" />
          </div>
          <h3 className="font-fredoka text-xl font-semibold mb-3">Ready for your Menu</h3>
          <p className="text-sm text-muted-foreground leading-relaxed">
            Set your goals and preferences in the Control Center, then click generate to craft your perfect day of eating!
          </p>
        </motion.div>
      </div>
    )
  }

  const totalCalories = mealPlan.breakfast.calories + mealPlan.lunch.calories + mealPlan.dinner.calories
  const totalCost = mealPlan.breakfast.cost + mealPlan.lunch.cost + mealPlan.dinner.cost
  
  return (
    <div className="flex-1 flex flex-col h-full overflow-y-auto pr-2 custom-scrollbar">
      {/* Stats Bar */}
      <div className="flex items-center justify-between mb-4 p-4 rounded-2xl bg-card/40 backdrop-blur-sm border border-border/20">
        <div className="flex items-center gap-2">
          <div className="p-1.5 rounded-lg bg-accent/10">
            <Flame className="w-5 h-5 text-accent" />
          </div>
          <div>
            <div className="text-xs text-muted-foreground font-medium">Daily Calories</div>
            <div className="flex items-baseline gap-1">
              <span className="text-lg font-bold">{totalCalories}</span>
              <span className="text-xs text-muted-foreground">/ {recommendedCalories}</span>
            </div>
          </div>
        </div>
        <div className="text-right">
          <div className="text-xs text-muted-foreground font-medium">Total Cost</div>
          <div className="text-lg font-bold text-primary">Rs. {totalCost.toFixed(2)}</div>
        </div>
      </div>

      {/* Meal Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 pb-4">
        <MealCard 
          title="Breakfast"
          icon={Coffee}
          iconBg="bg-amber-100 dark:bg-amber-900/30"
          iconColor="text-amber-600 dark:text-amber-400"
          meal={mealPlan.breakfast}
          character={<HappyToast />}
          isGenerating={isGenerating}
          emoji="🍳"
        />
        <MealCard 
          title="Lunch"
          icon={Sun}
          iconBg="bg-orange-100 dark:bg-orange-900/30"
          iconColor="text-orange-600 dark:text-orange-400"
          meal={mealPlan.lunch}
          character={<SaladBowl />}
          isGenerating={isGenerating}
          emoji="🥗"
        />
        <MealCard 
          title="Dinner"
          icon={Moon}
          iconBg="bg-indigo-100 dark:bg-indigo-900/30"
          iconColor="text-indigo-600 dark:text-indigo-400"
          meal={mealPlan.dinner}
          character={<HappySteak />}
          isGenerating={isGenerating}
          emoji="🍖"
        />
      </div>
    </div>
  )
}
