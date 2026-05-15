import { useState, useEffect } from 'react'
import { motion } from 'framer-motion'
import { Lock, Utensils, ShoppingBag, LogOut, ArrowLeft, Plus, Trash, Edit } from 'lucide-react'

export function AdminPanel({ onBack }: { onBack: () => void }) {
  const [isLoggedIn, setIsLoggedIn] = useState(false)
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [activeTab, setActiveTab] = useState<'foods' | 'orders'>('foods')

  const [foods, setFoods] = useState<any[]>([])
  const [orders, setOrders] = useState<any[]>([])

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    try {
      const res = await fetch('http://localhost:8080/api/admin/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password })
      })
      const data = await res.json()
      if (data.success) {
        setIsLoggedIn(true)
        fetchData()
      } else {
        setError(data.message)
      }
    } catch (err) {
      setError('Connection failed')
    }
  }

  const fetchData = async () => {
    try {
      const fRes = await fetch('http://localhost:8080/api/admin/foods')
      setFoods(await fRes.json())
      const oRes = await fetch('http://localhost:8080/api/admin/orders')
      setOrders(await oRes.json())
    } catch (err) {
      console.error(err)
    }
  }

  const handleDeleteFood = async (id: number) => {
    if (!confirm('Are you sure?')) return
    await fetch(`http://localhost:8080/api/admin/foods/${id}`, { method: 'DELETE' })
    fetchData()
  }

  const handleDeleteOrder = async (id: number) => {
    if (!confirm('Are you sure?')) return
    await fetch(`http://localhost:8080/api/admin/orders/${id}`, { method: 'DELETE' })
    fetchData()
  }

  if (!isLoggedIn) {
    return (
      <div className="h-screen w-screen flex items-center justify-center bg-background/50 p-4">
        <button onClick={onBack} className="fixed top-6 left-6 flex items-center gap-2 text-muted-foreground hover:text-foreground">
          <ArrowLeft className="w-5 h-5" /> Back
        </button>
        <motion.div 
          initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }}
          className="bg-card p-8 rounded-[2rem] shadow-xl w-full max-w-sm border border-border/50"
        >
          <div className="flex flex-col items-center mb-8">
            <div className="w-12 h-12 bg-primary/20 rounded-2xl flex items-center justify-center mb-4">
              <Lock className="w-6 h-6 text-primary" />
            </div>
            <h2 className="text-2xl font-fredoka font-semibold">Admin Login</h2>
          </div>
          <form onSubmit={handleLogin} className="flex flex-col gap-4">
            <input 
              type="text" placeholder="Username" value={username} onChange={e => setUsername(e.target.value)}
              className="w-full bg-background border border-border rounded-xl px-4 py-3 outline-none focus:border-primary"
            />
            <input 
              type="password" placeholder="Password" value={password} onChange={e => setPassword(e.target.value)}
              className="w-full bg-background border border-border rounded-xl px-4 py-3 outline-none focus:border-primary"
            />
            {error && <p className="text-destructive text-sm">{error}</p>}
            <button type="submit" className="w-full bg-primary text-primary-foreground py-3 rounded-xl font-medium mt-2">
              Access Control Center
            </button>
          </form>
        </motion.div>
      </div>
    )
  }

  return (
    <div className="h-screen w-screen flex bg-background p-4 md:p-6 gap-6 overflow-hidden">
      {/* Sidebar */}
      <div className="w-64 bg-card/70 backdrop-blur-xl rounded-[2rem] border border-border/50 shadow-xl flex flex-col p-4 shrink-0">
        <div className="flex items-center gap-3 mb-8 px-2 mt-4">
          <div className="w-10 h-10 rounded-2xl bg-primary/20 flex items-center justify-center">
            <Lock className="w-5 h-5 text-primary" />
          </div>
          <div>
            <h1 className="font-fredoka text-xl font-semibold">Admin</h1>
            <p className="text-xs text-muted-foreground">Control Center</p>
          </div>
        </div>
        
        <div className="flex flex-col gap-2 flex-1">
          <button 
            onClick={() => setActiveTab('foods')}
            className={`flex items-center gap-3 px-4 py-3 rounded-xl transition-colors ${activeTab === 'foods' ? 'bg-primary/10 text-primary font-medium' : 'hover:bg-muted text-muted-foreground'}`}
          >
            <Utensils className="w-5 h-5" /> Knowledge Base
          </button>
          <button 
            onClick={() => setActiveTab('orders')}
            className={`flex items-center gap-3 px-4 py-3 rounded-xl transition-colors ${activeTab === 'orders' ? 'bg-primary/10 text-primary font-medium' : 'hover:bg-muted text-muted-foreground'}`}
          >
            <ShoppingBag className="w-5 h-5" /> Orders
          </button>
        </div>

        <button onClick={onBack} className="flex items-center gap-3 px-4 py-3 rounded-xl text-muted-foreground hover:bg-muted mt-auto mb-2">
          <ArrowLeft className="w-5 h-5" /> Back to App
        </button>
        <button onClick={() => setIsLoggedIn(false)} className="flex items-center gap-3 px-4 py-3 rounded-xl text-destructive hover:bg-destructive/10">
          <LogOut className="w-5 h-5" /> Logout
        </button>
      </div>

      {/* Main Content */}
      <div className="flex-1 bg-card/70 backdrop-blur-xl rounded-[2rem] border border-border/50 shadow-xl p-8 overflow-hidden flex flex-col">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-2xl font-fredoka font-semibold">
            {activeTab === 'foods' ? 'Food Knowledge Base' : 'Recent Orders'}
          </h2>
          {activeTab === 'foods' && (
            <button className="bg-primary text-primary-foreground px-4 py-2 rounded-xl flex items-center gap-2 font-medium">
              <Plus className="w-4 h-4" /> Add Food
            </button>
          )}
        </div>

        <div className="flex-1 overflow-auto pr-2 rounded-xl border border-border/50">
          <table className="w-full text-left text-sm">
            <thead className="bg-muted sticky top-0 z-10">
              {activeTab === 'foods' ? (
                <tr>
                  <th className="p-4 font-medium rounded-tl-xl">ID</th>
                  <th className="p-4 font-medium">Name</th>
                  <th className="p-4 font-medium">Category</th>
                  <th className="p-4 font-medium">Calories</th>
                  <th className="p-4 font-medium text-right rounded-tr-xl">Actions</th>
                </tr>
              ) : (
                <tr>
                  <th className="p-4 font-medium rounded-tl-xl">ID</th>
                  <th className="p-4 font-medium">Customer</th>
                  <th className="p-4 font-medium">Total</th>
                  <th className="p-4 font-medium">Status</th>
                  <th className="p-4 font-medium text-right rounded-tr-xl">Actions</th>
                </tr>
              )}
            </thead>
            <tbody className="divide-y divide-border/50 bg-background">
              {activeTab === 'foods' ? foods.map(food => (
                <tr key={food.foodId} className="hover:bg-muted/50 transition-colors">
                  <td className="p-4 text-muted-foreground">#{food.foodId}</td>
                  <td className="p-4 font-medium">{food.foodName}</td>
                  <td className="p-4"><span className="px-2 py-1 bg-secondary rounded-lg text-xs">{food.category}</span></td>
                  <td className="p-4">{food.calories} kcal</td>
                  <td className="p-4 text-right">
                    <button className="p-2 text-muted-foreground hover:text-primary transition-colors"><Edit className="w-4 h-4" /></button>
                    <button onClick={() => handleDeleteFood(food.foodId)} className="p-2 text-muted-foreground hover:text-destructive transition-colors"><Trash className="w-4 h-4" /></button>
                  </td>
                </tr>
              )) : orders.map(order => (
                <tr key={order.orderId} className="hover:bg-muted/50 transition-colors">
                  <td className="p-4 text-muted-foreground">#{order.orderId}</td>
                  <td className="p-4 font-medium">{order.customerName}</td>
                  <td className="p-4">Rs {order.totalAmount}</td>
                  <td className="p-4"><span className="px-2 py-1 bg-secondary rounded-lg text-xs capitalize">{order.orderStatus}</span></td>
                  <td className="p-4 text-right">
                    <button onClick={() => handleDeleteOrder(order.orderId)} className="p-2 text-muted-foreground hover:text-destructive transition-colors"><Trash className="w-4 h-4" /></button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          {(activeTab === 'foods' && foods.length === 0) || (activeTab === 'orders' && orders.length === 0) ? (
            <div className="p-8 text-center text-muted-foreground">No records found.</div>
          ) : null}
        </div>
      </div>
    </div>
  )
}
