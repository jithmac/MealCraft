import { useState } from "react"
import { motion, AnimatePresence } from "framer-motion"
import { ShoppingCart, Plus, Minus, CreditCard, Sparkles } from "lucide-react"
import { Button } from "@/components/ui/button"

interface MealPlan {
  breakfast: { name: string; calories: number; cost: number }
  lunch: { name: string; calories: number; cost: number }
  dinner: { name: string; calories: number; cost: number }
}

interface QuickOrderProps {
  mealPlan: MealPlan
  budget: number
}

interface CartItem {
  id: string
  name: string
  price: number
  quantity: number
}

export function QuickOrder({ mealPlan, budget }: QuickOrderProps) {
  const [cart, setCart] = useState<CartItem[]>([
    { id: "1", name: mealPlan.breakfast.name, price: mealPlan.breakfast.cost, quantity: 1 },
    { id: "2", name: mealPlan.lunch.name, price: mealPlan.lunch.cost, quantity: 1 },
    { id: "3", name: mealPlan.dinner.name, price: mealPlan.dinner.cost, quantity: 1 },
  ])
  
  const [isCheckingOut, setIsCheckingOut] = useState(false)

  const updateQuantity = (id: string, delta: number) => {
    setCart(prev => 
      prev.map(item => 
        item.id === id 
          ? { ...item, quantity: Math.max(0, item.quantity + delta) }
          : item
      ).filter(item => item.quantity > 0)
    )
  }

  const total = cart.reduce((sum, item) => sum + item.price * item.quantity, 0)
  const isOverBudget = total > budget

  const handleCheckout = () => {
    setIsCheckingOut(true)
    setTimeout(() => setIsCheckingOut(false), 2000)
  }

  return (
    <div className="h-full flex flex-col">
      {/* Header */}
      <div className="flex items-center justify-between mb-3">
        <h3 className="font-fredoka text-lg font-semibold text-foreground flex items-center gap-2">
          <ShoppingCart className="w-5 h-5 text-primary" />
          Quick Order
        </h3>
        <span className="text-xs px-2 py-1 rounded-full bg-primary/10 text-primary font-medium">
          {cart.length} items
        </span>
      </div>

      {/* Cart Items */}
      <div className="flex-1 space-y-2 overflow-y-auto pr-1 custom-scrollbar">
        <AnimatePresence>
          {cart.map((item) => (
            <motion.div
              key={item.id}
              layout
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: 20, height: 0 }}
              className="flex items-center gap-2 p-2 rounded-xl bg-card/40 hover:bg-card/60 transition-colors"
            >
              <div className="flex-1 min-w-0">
                <p className="text-xs font-medium text-foreground truncate">{item.name}</p>
                <p className="text-xs text-muted-foreground">Rs. {item.price.toFixed(2)}</p>
              </div>
              <div className="flex items-center gap-1">
                <motion.button
                  whileTap={{ scale: 0.9 }}
                  onClick={() => updateQuantity(item.id, -1)}
                  className="w-6 h-6 rounded-full bg-muted flex items-center justify-center hover:bg-muted/80 transition-colors"
                >
                  <Minus className="w-3 h-3" />
                </motion.button>
                <span className="w-6 text-center text-sm font-medium">{item.quantity}</span>
                <motion.button
                  whileTap={{ scale: 0.9 }}
                  onClick={() => updateQuantity(item.id, 1)}
                  className="w-6 h-6 rounded-full bg-primary/20 flex items-center justify-center hover:bg-primary/30 transition-colors"
                >
                  <Plus className="w-3 h-3" />
                </motion.button>
              </div>
            </motion.div>
          ))}
        </AnimatePresence>
        
        {cart.length === 0 && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            className="flex flex-col items-center justify-center h-full text-muted-foreground"
          >
            <ShoppingCart className="w-8 h-8 mb-2 opacity-50" />
            <p className="text-sm">Cart is empty</p>
          </motion.div>
        )}
      </div>

      {/* Total & Checkout */}
      <div className="pt-3 mt-2 border-t border-border/30 space-y-2">
        <div className="flex justify-between items-center">
          <span className="text-sm text-muted-foreground">Total</span>
          <motion.span 
            key={total}
            initial={{ scale: 1.2 }}
            animate={{ scale: 1 }}
            className={`text-xl font-bold font-fredoka ${isOverBudget ? 'text-destructive' : 'text-foreground'}`}
          >
            Rs. {total.toFixed(2)}
          </motion.span>
        </div>
        
        {isOverBudget && (
          <p className="text-xs text-destructive text-center">Over weekly budget!</p>
        )}
        
        <Button
          onClick={handleCheckout}
          disabled={cart.length === 0 || isCheckingOut}
          className="w-full rounded-xl bg-primary hover:bg-primary/90 text-primary-foreground font-semibold relative overflow-hidden"
        >
          <AnimatePresence mode="wait">
            {isCheckingOut ? (
              <motion.span
                key="checking"
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -20 }}
                className="flex items-center gap-2"
              >
                <Sparkles className="w-4 h-4 animate-pulse" />
                Processing...
              </motion.span>
            ) : (
              <motion.span
                key="checkout"
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -20 }}
                className="flex items-center gap-2"
              >
                <CreditCard className="w-4 h-4" />
                Checkout
              </motion.span>
            )}
          </AnimatePresence>
        </Button>
      </div>
    </div>
  )
}
