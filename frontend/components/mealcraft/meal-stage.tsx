import { useState } from "react"
import { motion, AnimatePresence } from "framer-motion"
import { HappyToast, SaladBowl, HappySteak } from "./food-characters"
import { Coffee, Sun, Moon, Flame, PieChart as PieChartIcon, Utensils } from "lucide-react"
import { PieChart, Pie, Cell, ResponsiveContainer, Tooltip } from "recharts"

import { MealPlan, Meal, FoodItem } from "@/App"

interface MealStageProps {
  mealPlan: MealPlan
  isGenerating: boolean
  recommendedCalories: number
  isShrunk?: boolean
}

const MACRO_COLORS = ['#3b82f6', '#f59e0b', '#10b981']; // Protein, Carbs, Fat

function NutritionChart({ protein, carbs, fat }: { protein: number; carbs: number; fat: number }) {
  const data = [
    { name: 'Protein', value: protein },
    { name: 'Carbs', value: carbs },
    { name: 'Fat', value: fat },
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
  meal: Meal;
  character: any;
  isGenerating: boolean;
  emoji: string;
}) {
  const [showNutrition, setShowNutrition] = useState(false)

  return (
    <motion.div
      layout
      className="p-5 rounded-3xl bg-card/50 backdrop-blur-sm border border-border/30 shadow-lg flex flex-col relative overflow-hidden min-h-[500px]"
    >
      <div className="flex items-center justify-between mb-3">
        <div className="flex items-center gap-3">
          <div className={`p-3 rounded-2xl ${iconBg}`}>
            <Icon className={`w-6 h-6 ${iconColor}`} />
          </div>
          <span className="font-semibold text-xl">{title}</span>
        </div>
        <motion.button
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
          onClick={() => setShowNutrition(!showNutrition)}
          className="p-2.5 rounded-full bg-secondary text-secondary-foreground hover:bg-secondary/80 transition-colors"
          title="Nutrition Breakdown"
        >
          <PieChartIcon className="w-5 h-5" />
        </motion.button>
      </div>

      <div className="flex-1 flex justify-center items-center py-4 h-40 overflow-visible">
        {isGenerating ? (
          <motion.div
            animate={{ rotate: 360 }}
            transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
            className="text-8xl"
          >
            {emoji}
          </motion.div>
        ) : (
          <div className="scale-[2.2] origin-center pointer-events-auto">
            {character}
          </div>
        )}
      </div>

      <motion.div layout className="mt-auto bg-background/50 p-5 rounded-2xl border border-border/20">
        <p className="text-2xl leading-tight font-semibold text-foreground mb-4">{meal.name}</p>
        <div className="flex justify-between items-center mb-3">
          <span className="text-base font-medium px-3 py-1.5 bg-accent/10 text-accent rounded-xl flex items-center gap-2">
            <Flame className="w-5 h-5" />
            {meal.calories} kcal
          </span>
        </div>

        {/* Items List */}
        {meal.items && meal.items.length > 0 && (
          <div className="space-y-2.5 mt-3 max-h-48 overflow-y-auto custom-scrollbar pr-2">
            {meal.items.map((item, idx) => (
              <div key={idx} className="flex justify-between items-start text-base border-b border-border/30 pb-2.5 last:border-0 last:pb-0">
                <div className="font-medium text-foreground">{item.name}</div>
                <div className="text-right text-muted-foreground whitespace-nowrap ml-3">
                  {item.quantity} serving(s)<br />
                  <span className="text-sm">{item.amount} g/ml</span>
                </div>
              </div>
            ))}
          </div>
        )}
      </motion.div>

      <AnimatePresence>
        {showNutrition && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: 'auto', opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            className="overflow-hidden"
          >
            <NutritionChart protein={meal.protein || 0} carbs={meal.carbs || 0} fat={meal.fat || 0} />
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

  const totalCalories = mealPlan.totalCals > 0 ? mealPlan.totalCals : (mealPlan.breakfast.calories + mealPlan.lunch.calories + mealPlan.dinner.calories)

  return (
    <div className="flex-1 flex flex-col h-full overflow-y-auto pr-2 custom-scrollbar">
      {/* Stats Bar */}
      <div className="flex items-center justify-between mb-6 p-6 rounded-3xl bg-card/40 backdrop-blur-sm border border-border/20">
        <div className="flex items-center gap-4">
          <div className="p-3 rounded-2xl bg-accent/10">
            <Flame className="w-8 h-8 text-accent" />
          </div>
          <div>
            <div className="text-base text-muted-foreground font-medium">Daily Calories</div>
            <div className="flex items-baseline gap-2">
              <span className="text-3xl font-bold">{totalCalories}</span>
              <span className="text-base text-muted-foreground">/ {recommendedCalories}</span>
            </div>
          </div>
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
