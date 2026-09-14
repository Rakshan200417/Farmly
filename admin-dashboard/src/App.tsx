import React, { useState } from 'react';
import { 
  LayoutDashboard, 
  Users, 
  CheckSquare, 
  TrendingUp, 
  Leaf, 
  Megaphone, 
  HelpCircle, 
  LogOut, 
  Search, 
  Bell, 
  Settings, 
  Plus, 
  ShieldCheck, 
  AlertTriangle,
  ArrowUpRight,
  ArrowDownRight,
  Filter,
  Check,
  X
} from 'lucide-react';

export default function App() {
  const [activeTab, setActiveTab] = useState<'dashboard' | 'users' | 'moderation' | 'prices' | 'disease' | 'announcements'>('dashboard');
  const [searchQuery, setSearchQuery] = useState('');

  // Sample User Accounts
  const [usersList, setUsersList] = useState([
    { id: '1', name: 'Suneth Perera', role: 'Farmer', district: 'Anuradhapura', phone: '+94 77 123 4567', status: 'Verified', date: 'Oct 12, 2026' },
    { id: '2', name: 'Nimal Jayasuriya', role: 'Farmer', district: 'Kurunegala', phone: '+94 71 888 2345', status: 'Pending', date: 'Oct 14, 2026' },
    { id: '3', name: 'Priyashantha Wholesale', role: 'Buyer', district: 'Colombo', phone: '+94 71 987 6543', status: 'Verified', date: 'Oct 10, 2026' },
    { id: '4', name: 'Perera Agri Inputs & Seeds', role: 'Shop', district: 'Matale (Dambulla)', phone: '+94 76 555 1234', status: 'Verified', date: 'Oct 08, 2026' },
    { id: '5', name: 'Rohan Wickrama', role: 'Farmer', district: 'Polonnaruwa', phone: '+94 77 444 8910', status: 'Pending', date: 'Oct 14, 2026' },
  ]);

  // Sample Price Index
  const [pricesList, setPricesList] = useState([
    { id: '1', crop: 'Paddy (Rice) — Samba', market: 'Dambulla Centre', price: 110.0, trend: '+5%', status: 'Active' },
    { id: '2', crop: 'Red Onion', market: 'Dambulla Centre', price: 240.0, trend: '-2%', status: 'Active' },
    { id: '3', crop: 'Big Onion', market: 'Dambulla Centre', price: 185.0, trend: '+1%', status: 'Active' },
    { id: '4', crop: 'Roma Tomato', market: 'Dambulla Centre', price: 320.0, trend: '+12%', status: 'Active' },
    { id: '5', crop: 'Green Chili (Kochchi)', market: 'Dambulla Centre', price: 650.0, trend: '-4%', status: 'Active' },
    { id: '6', crop: 'Carrot (Nuwara Eliya)', market: 'Keppetipola Centre', price: 450.0, trend: '+8%', status: 'Active' },
  ]);

  // Sample Flagged Listings
  const [flaggedListings, setFlaggedListings] = useState([
    { id: 'L-4928', crop: 'Imported Red Onion', farmer: 'Nimal J.', price: 'Rs. 950/kg', reason: 'Unusually inflated price report', date: '2h ago' },
    { id: 'L-5102', crop: 'Chemical Pesticide Residue Suspected', farmer: 'Private Trader', price: 'Rs. 150/kg', reason: 'User report regarding unapproved chemical claim', date: '5h ago' },
  ]);

  // Announcement state
  const [announcements, setAnnouncements] = useState([
    { id: 'A-1', title: 'Bacterial Leaf Blight Warning', region: 'Anuradhapura, Polonnaruwa', date: 'Today, 9:00 AM', reach: '4,280 Farmers' },
    { id: 'A-2', title: 'Dambulla Dedicated Economic Centre Opening Hours', region: 'Central Province', date: 'Yesterday', reach: '2,150 Users' },
  ]);
  const [newAlertTitle, setNewAlertTitle] = useState('');
  const [newAlertMsg, setNewAlertMsg] = useState('');

  const toggleUserVerification = (id: string) => {
    setUsersList(prev => prev.map(u => u.id === id ? { ...u, status: u.status === 'Verified' ? 'Pending' : 'Verified' } : u));
  };

  const approveListing = (id: string) => {
    setFlaggedListings(prev => prev.filter(l => l.id !== id));
  };

  const handleCreateAnnouncement = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newAlertTitle) return;
    setAnnouncements(prev => [
      { id: `A-${Date.now()}`, title: newAlertTitle, region: 'All Districts', date: 'Just now', reach: '5,100 Farmers' },
      ...prev
    ]);
    setNewAlertTitle('');
    setNewAlertMsg('');
  };

  return (
    <div style={{ display: 'flex', minHeight: '100vh', backgroundColor: 'var(--bg-color)' }}>
      {/* Sidebar matching Admin Dashboard_ Overview.png */}
      <aside style={{
        width: '260px',
        backgroundColor: '#FFFFFF',
        borderRight: '1px solid var(--border-color)',
        display: 'flex',
        flexDirection: 'column',
        position: 'sticky',
        top: 0,
        height: '100vh',
      }}>
        {/* Brand Header */}
        <div style={{ padding: '24px 20px', display: 'flex', alignItems: 'center', gap: '12px' }}>
          <div style={{
            width: '38px',
            height: '38px',
            backgroundColor: '#E8F5E9',
            borderRadius: '50%',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}>
            <Leaf size={22} color="var(--primary-green)" />
          </div>
          <div>
            <h2 style={{ fontSize: '17px', fontWeight: 'bold', color: 'var(--primary-green)', lineHeight: 1.1 }}>Farmly Admin</h2>
            <span style={{ fontSize: '11px', color: 'var(--text-secondary)' }}>Sri Lanka Agricultural Hub</span>
          </div>
        </div>

        {/* Navigation Items */}
        <nav style={{ flex: 1, padding: '10px 14px', display: 'flex', flexDirection: 'column', gap: '4px' }}>
          <button
            onClick={() => setActiveTab('dashboard')}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              padding: '12px 16px',
              borderRadius: '8px',
              border: 'none',
              backgroundColor: activeTab === 'dashboard' ? 'var(--secondary-amber)' : 'transparent',
              color: activeTab === 'dashboard' ? '#2B2B2B' : 'var(--text-secondary)',
              fontWeight: activeTab === 'dashboard' ? '700' : '500',
              fontSize: '14px',
              textAlign: 'left',
              width: '100%',
              transition: 'background-color 0.2s',
            }}
          >
            <LayoutDashboard size={18} />
            Dashboard
          </button>

          <button
            onClick={() => setActiveTab('users')}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              padding: '12px 16px',
              borderRadius: '8px',
              border: 'none',
              backgroundColor: activeTab === 'users' ? 'var(--secondary-amber)' : 'transparent',
              color: activeTab === 'users' ? '#2B2B2B' : 'var(--text-secondary)',
              fontWeight: activeTab === 'users' ? '700' : '500',
              fontSize: '14px',
              textAlign: 'left',
              width: '100%',
            }}
          >
            <Users size={18} />
            User Management
          </button>

          <button
            onClick={() => setActiveTab('moderation')}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              padding: '12px 16px',
              borderRadius: '8px',
              border: 'none',
              backgroundColor: activeTab === 'moderation' ? 'var(--secondary-amber)' : 'transparent',
              color: activeTab === 'moderation' ? '#2B2B2B' : 'var(--text-secondary)',
              fontWeight: activeTab === 'moderation' ? '700' : '500',
              fontSize: '14px',
              textAlign: 'left',
              width: '100%',
            }}
          >
            <CheckSquare size={18} />
            Listings Moderation
            {flaggedListings.length > 0 && (
              <span style={{
                marginLeft: 'auto',
                backgroundColor: 'var(--alert-red)',
                color: 'white',
                fontSize: '11px',
                borderRadius: '12px',
                padding: '2px 7px',
                fontWeight: 'bold',
              }}>
                {flaggedListings.length}
              </span>
            )}
          </button>

          <button
            onClick={() => setActiveTab('prices')}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              padding: '12px 16px',
              borderRadius: '8px',
              border: 'none',
              backgroundColor: activeTab === 'prices' ? 'var(--secondary-amber)' : 'transparent',
              color: activeTab === 'prices' ? '#2B2B2B' : 'var(--text-secondary)',
              fontWeight: activeTab === 'prices' ? '700' : '500',
              fontSize: '14px',
              textAlign: 'left',
              width: '100%',
            }}
          >
            <TrendingUp size={18} />
            Price Indices
          </button>

          <button
            onClick={() => setActiveTab('disease')}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              padding: '12px 16px',
              borderRadius: '8px',
              border: 'none',
              backgroundColor: activeTab === 'disease' ? 'var(--secondary-amber)' : 'transparent',
              color: activeTab === 'disease' ? '#2B2B2B' : 'var(--text-secondary)',
              fontWeight: activeTab === 'disease' ? '700' : '500',
              fontSize: '14px',
              textAlign: 'left',
              width: '100%',
            }}
          >
            <Leaf size={18} />
            Disease Mapping
          </button>

          <button
            onClick={() => setActiveTab('announcements')}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              padding: '12px 16px',
              borderRadius: '8px',
              border: 'none',
              backgroundColor: activeTab === 'announcements' ? 'var(--secondary-amber)' : 'transparent',
              color: activeTab === 'announcements' ? '#2B2B2B' : 'var(--text-secondary)',
              fontWeight: activeTab === 'announcements' ? '700' : '500',
              fontSize: '14px',
              textAlign: 'left',
              width: '100%',
            }}
          >
            <Megaphone size={18} />
            Announcements
          </button>
        </nav>

        {/* Sidebar Footer */}
        <div style={{ padding: '16px 14px', borderTop: '1px solid var(--border-color)', display: 'flex', flexDirection: 'column', gap: '6px' }}>
          <button style={{
            display: 'flex',
            alignItems: 'center',
            gap: '10px',
            padding: '10px 14px',
            backgroundColor: 'transparent',
            border: 'none',
            color: 'var(--text-secondary)',
            fontSize: '13px',
          }}>
            <HelpCircle size={16} /> Help Center
          </button>
          <button style={{
            display: 'flex',
            alignItems: 'center',
            gap: '10px',
            padding: '10px 14px',
            backgroundColor: 'transparent',
            border: 'none',
            color: 'var(--alert-red)',
            fontSize: '13px',
            fontWeight: '600',
          }}>
            <LogOut size={16} /> Logout
          </button>
        </div>
      </aside>

      {/* Main Content Area */}
      <main style={{ flex: 1, display: 'flex', flexDirection: 'column', minWidth: 0 }}>
        {/* Top Navbar */}
        <header style={{
          height: '70px',
          backgroundColor: '#FFFFFF',
          borderBottom: '1px solid var(--border-color)',
          padding: '0 32px',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
        }}>
          {/* Search Bar */}
          <div style={{
            display: 'flex',
            alignItems: 'center',
            backgroundColor: 'var(--bg-color)',
            borderRadius: '24px',
            padding: '8px 16px',
            width: '380px',
            border: '1px solid var(--border-color)',
          }}>
            <Search size={18} color="var(--text-secondary)" />
            <input
              type="text"
              placeholder="Search marketplace, users, crops..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              style={{
                border: 'none',
                backgroundColor: 'transparent',
                outline: 'none',
                marginLeft: '10px',
                width: '100%',
                fontSize: '14px',
              }}
            />
          </div>

          {/* Action Icons & Admin Profile */}
          <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
            <button style={{ background: 'none', border: 'none', position: 'relative', padding: '6px' }}>
              <Bell size={20} color="var(--text-primary)" />
              <span style={{
                position: 'absolute',
                top: '4px',
                right: '4px',
                width: '8px',
                height: '8px',
                backgroundColor: 'var(--alert-red)',
                borderRadius: '50%',
              }} />
            </button>
            <button style={{ background: 'none', border: 'none', padding: '6px' }}>
              <Settings size={20} color="var(--text-primary)" />
            </button>
            <div style={{ display: 'flex', alignItems: 'center', gap: '10px', marginLeft: '8px' }}>
              <img
                src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100"
                alt="Admin"
                style={{ width: '36px', height: '36px', borderRadius: '50%', objectFit: 'cover' }}
              />
              <div>
                <p style={{ fontSize: '13px', fontWeight: 'bold' }}>Dr. A. Senanayake</p>
                <p style={{ fontSize: '11px', color: 'var(--text-secondary)' }}>System Overseer</p>
              </div>
            </div>
          </div>
        </header>

        {/* Dynamic Screen Content */}
        <div style={{ padding: '32px', flex: 1, overflowY: 'auto' }}>
          {activeTab === 'dashboard' && (
            <div>
              {/* Page Title */}
              <div style={{ marginBottom: '24px' }}>
                <h1 style={{ fontSize: '26px', fontWeight: 'bold', color: 'var(--text-primary)' }}>Dashboard Overview</h1>
                <p style={{ fontSize: '14px', color: 'var(--text-secondary)' }}>Real-time agricultural market insights for Sri Lanka hub.</p>
              </div>

              {/* 3 Metrics Cards */}
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '20px', marginBottom: '28px' }}>
                {/* Total Users */}
                <div style={{
                  backgroundColor: '#FFFFFF',
                  padding: '20px',
                  borderRadius: '12px',
                  border: '1px solid var(--border-color)',
                }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                    <div>
                      <span style={{ fontSize: '11px', fontWeight: 'bold', color: 'var(--text-secondary)', textTransform: 'uppercase' }}>Total Users</span>
                      <h3 style={{ fontSize: '28px', fontWeight: 'bold', margin: '6px 0' }}>12,450</h3>
                      <span style={{ fontSize: '12px', color: 'var(--primary-green)', fontWeight: '600', display: 'flex', alignItems: 'center' }}>
                        <ArrowUpRight size={14} /> +12% this month
                      </span>
                    </div>
                    <div style={{ backgroundColor: '#E8F5E9', padding: '10px', borderRadius: '8px' }}>
                      <Users size={22} color="var(--primary-green)" />
                    </div>
                  </div>
                </div>

                {/* Active Listings */}
                <div style={{
                  backgroundColor: '#FFFFFF',
                  padding: '20px',
                  borderRadius: '12px',
                  border: '1px solid var(--border-color)',
                }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                    <div>
                      <span style={{ fontSize: '11px', fontWeight: 'bold', color: 'var(--text-secondary)', textTransform: 'uppercase' }}>Active Listings</span>
                      <h3 style={{ fontSize: '28px', fontWeight: 'bold', margin: '6px 0' }}>3,892</h3>
                      <span style={{ fontSize: '12px', color: 'var(--primary-green)', fontWeight: '600', display: 'flex', alignItems: 'center' }}>
                        <ArrowUpRight size={14} /> +5.2% this week
                      </span>
                    </div>
                    <div style={{ backgroundColor: '#FFF8E1', padding: '10px', borderRadius: '8px' }}>
                      <CheckSquare size={22} color="var(--secondary-amber)" />
                    </div>
                  </div>
                </div>

                {/* Market Volume */}
                <div style={{
                  backgroundColor: '#FFFFFF',
                  padding: '20px',
                  borderRadius: '12px',
                  border: '1px solid var(--border-color)',
                }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                    <div>
                      <span style={{ fontSize: '11px', fontWeight: 'bold', color: 'var(--text-secondary)', textTransform: 'uppercase' }}>Market Volume (Today)</span>
                      <h3 style={{ fontSize: '28px', fontWeight: 'bold', margin: '6px 0' }}>LKR 4.2M</h3>
                      <span style={{ fontSize: '12px', color: 'var(--alert-red)', fontWeight: '600', display: 'flex', alignItems: 'center' }}>
                        <ArrowDownRight size={14} /> -1.5% vs yesterday
                      </span>
                    </div>
                    <div style={{ backgroundColor: '#E0F2F1', padding: '10px', borderRadius: '8px' }}>
                      <TrendingUp size={22} color="var(--accent-teal)" />
                    </div>
                  </div>
                </div>
              </div>

              {/* Middle Section: Trends Chart & Quick Actions */}
              <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: '20px', marginBottom: '28px' }}>
                {/* Market Trends Card */}
                <div style={{
                  backgroundColor: '#FFFFFF',
                  padding: '22px',
                  borderRadius: '12px',
                  border: '1px solid var(--border-color)',
                }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
                    <h3 style={{ fontSize: '16px', fontWeight: 'bold' }}>Market Trends (30 Days)</h3>
                    <div style={{ display: 'flex', gap: '8px' }}>
                      <span style={{ fontSize: '11px', padding: '4px 10px', borderRadius: '12px', backgroundColor: '#E8F5E9', color: 'var(--primary-green)', fontWeight: 'bold' }}>Rice</span>
                      <span style={{ fontSize: '11px', padding: '4px 10px', borderRadius: '12px', backgroundColor: '#FFF8E1', color: 'var(--secondary-amber)', fontWeight: 'bold' }}>Chilies</span>
                    </div>
                  </div>

                  {/* SVG Chart Preview */}
                  <div style={{ height: '220px', backgroundColor: '#FAF9F6', borderRadius: '8px', position: 'relative', overflow: 'hidden' }}>
                    <svg viewBox="0 0 600 200" style={{ width: '100%', height: '100%' }}>
                      {/* Grid lines */}
                      <line x1="0" y1="50" x2="600" y2="50" stroke="#E4E2DA" strokeDasharray="4" />
                      <line x1="0" y1="100" x2="600" y2="100" stroke="#E4E2DA" strokeDasharray="4" />
                      <line x1="0" y1="150" x2="600" y2="150" stroke="#E4E2DA" strokeDasharray="4" />
                      
                      {/* Rice curve (Green) */}
                      <path d="M 0 160 Q 150 140, 300 80 T 600 50" fill="none" stroke="var(--primary-green)" strokeWidth="3.5" />
                      {/* Chilies curve (Amber) */}
                      <path d="M 0 170 Q 200 60, 400 90 T 600 130" fill="none" stroke="var(--secondary-amber)" strokeWidth="3.5" />
                    </svg>
                    <div style={{
                      position: 'absolute',
                      top: '50%',
                      left: '50%',
                      transform: 'translate(-50%, -50%)',
                      backgroundColor: 'white',
                      padding: '6px 14px',
                      borderRadius: '8px',
                      border: '1px solid var(--border-color)',
                      fontSize: '12px',
                      fontWeight: 'bold',
                    }}>
                      HARTI Sri Lanka Price Index
                    </div>
                  </div>
                </div>

                {/* Quick Actions (Dark Green Card matching wireframe) */}
                <div style={{
                  backgroundColor: '#1E4620',
                  color: 'white',
                  padding: '24px',
                  borderRadius: '12px',
                  display: 'flex',
                  flexDirection: 'column',
                  justifyContent: 'space-between',
                }}>
                  <div>
                    <h3 style={{ fontSize: '18px', fontWeight: 'bold', marginBottom: '18px' }}>Quick Actions</h3>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                      <button
                        onClick={() => setActiveTab('prices')}
                        style={{
                          backgroundColor: 'rgba(255,255,255,0.15)',
                          color: 'white',
                          border: 'none',
                          padding: '12px 14px',
                          borderRadius: '8px',
                          fontSize: '13px',
                          fontWeight: '600',
                          textAlign: 'left',
                          display: 'flex',
                          alignItems: 'center',
                          gap: '10px',
                        }}
                      >
                        <TrendingUp size={16} /> Add Price Index
                      </button>

                      <button
                        onClick={() => setActiveTab('users')}
                        style={{
                          backgroundColor: 'rgba(255,255,255,0.15)',
                          color: 'white',
                          border: 'none',
                          padding: '12px 14px',
                          borderRadius: '8px',
                          fontSize: '13px',
                          fontWeight: '600',
                          textAlign: 'left',
                          display: 'flex',
                          alignItems: 'center',
                          gap: '10px',
                        }}
                      >
                        <ShieldCheck size={16} /> Verify Farmer Profile
                      </button>

                      <button
                        onClick={() => setActiveTab('announcements')}
                        style={{
                          backgroundColor: 'rgba(255,255,255,0.15)',
                          color: 'white',
                          border: 'none',
                          padding: '12px 14px',
                          borderRadius: '8px',
                          fontSize: '13px',
                          fontWeight: '600',
                          textAlign: 'left',
                          display: 'flex',
                          alignItems: 'center',
                          gap: '10px',
                        }}
                      >
                        <Megaphone size={16} /> Broadcast Outbreak Alert
                      </button>
                    </div>
                  </div>

                  <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginTop: '20px', fontSize: '12px', opacity: 0.9 }}>
                    <span style={{ width: '8px', height: '8px', backgroundColor: '#7CB342', borderRadius: '50%' }} />
                    System Status: Online (All services normal)
                  </div>
                </div>
              </div>

              {/* Bottom Section: Recent Activities Feed */}
              <div style={{
                backgroundColor: '#FFFFFF',
                padding: '24px',
                borderRadius: '12px',
                border: '1px solid var(--border-color)',
              }}>
                <h3 style={{ fontSize: '16px', fontWeight: 'bold', marginBottom: '16px' }}>Recent Platform Activities</h3>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
                  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                      <div style={{ backgroundColor: '#FFF8E1', padding: '8px', borderRadius: '50%' }}>
                        <Users size={16} color="var(--secondary-amber)" />
                      </div>
                      <div>
                        <p style={{ fontSize: '13px', fontWeight: '600' }}>New Farmer registered: Nimal Perera</p>
                        <p style={{ fontSize: '11px', color: 'var(--text-secondary)' }}>Kurunegala District • Pending Verification</p>
                      </div>
                    </div>
                    <span style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>10m ago</span>
                  </div>

                  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                      <div style={{ backgroundColor: '#E0F2F1', padding: '8px', borderRadius: '50%' }}>
                        <TrendingUp size={16} color="var(--accent-teal)" />
                      </div>
                      <div>
                        <p style={{ fontSize: '13px', fontWeight: '600' }}>Price update for Samba Rice</p>
                        <p style={{ fontSize: '11px', color: 'var(--text-secondary)' }}>Increased by LKR 12.00/kg in Colombo wholesale market</p>
                      </div>
                    </div>
                    <span style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>1h ago</span>
                  </div>

                  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                      <div style={{ backgroundColor: '#FFEBEE', padding: '8px', borderRadius: '50%' }}>
                        <AlertTriangle size={16} color="var(--alert-red)" />
                      </div>
                      <div>
                        <p style={{ fontSize: '13px', fontWeight: '600' }}>New listing reported: Listing #4928</p>
                        <p style={{ fontSize: '11px', color: 'var(--text-secondary)' }}>Flagged for suspicious pricing anomaly</p>
                      </div>
                    </div>
                    <span style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>2h ago</span>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* User Management Screen */}
          {activeTab === 'users' && (
            <div>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
                <div>
                  <h1 style={{ fontSize: '26px', fontWeight: 'bold' }}>User Management</h1>
                  <p style={{ fontSize: '14px', color: 'var(--text-secondary)' }}>Verify, inspect, and moderate farmers, wholesale buyers, and agro shops.</p>
                </div>
              </div>

              <div style={{ backgroundColor: 'white', borderRadius: '12px', border: '1px solid var(--border-color)', overflow: 'hidden' }}>
                <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '13px' }}>
                  <thead style={{ backgroundColor: '#FAF9F6', borderBottom: '1px solid var(--border-color)' }}>
                    <tr>
                      <th style={{ padding: '14px 20px', fontWeight: 'bold' }}>Name</th>
                      <th style={{ padding: '14px 20px', fontWeight: 'bold' }}>Role</th>
                      <th style={{ padding: '14px 20px', fontWeight: 'bold' }}>District</th>
                      <th style={{ padding: '14px 20px', fontWeight: 'bold' }}>Phone</th>
                      <th style={{ padding: '14px 20px', fontWeight: 'bold' }}>Status</th>
                      <th style={{ padding: '14px 20px', fontWeight: 'bold' }}>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {usersList.map((user) => (
                      <tr key={user.id} style={{ borderBottom: '1px solid var(--border-color)' }}>
                        <td style={{ padding: '14px 20px', fontWeight: '600' }}>{user.name}</td>
                        <td style={{ padding: '14px 20px' }}>
                          <span style={{
                            padding: '3px 8px',
                            borderRadius: '10px',
                            fontSize: '11px',
                            fontWeight: 'bold',
                            backgroundColor: user.role === 'Farmer' ? '#E8F5E9' : user.role === 'Buyer' ? '#E0F2F1' : '#FFF8E1',
                            color: user.role === 'Farmer' ? 'var(--primary-green)' : user.role === 'Buyer' ? 'var(--accent-teal)' : 'var(--secondary-amber)',
                          }}>
                            {user.role}
                          </span>
                        </td>
                        <td style={{ padding: '14px 20px' }}>{user.district}</td>
                        <td style={{ padding: '14px 20px' }}>{user.phone}</td>
                        <td style={{ padding: '14px 20px' }}>
                          <span style={{
                            padding: '3px 8px',
                            borderRadius: '10px',
                            fontSize: '11px',
                            fontWeight: 'bold',
                            backgroundColor: user.status === 'Verified' ? '#E8F5E9' : '#FFF8E1',
                            color: user.status === 'Verified' ? 'var(--primary-green)' : '#D97706',
                          }}>
                            {user.status}
                          </span>
                        </td>
                        <td style={{ padding: '14px 20px' }}>
                          <button
                            onClick={() => toggleUserVerification(user.id)}
                            style={{
                              padding: '6px 12px',
                              borderRadius: '6px',
                              border: '1px solid var(--border-color)',
                              backgroundColor: user.status === 'Verified' ? '#FFF8E1' : '#E8F5E9',
                              color: user.status === 'Verified' ? '#D97706' : 'var(--primary-green)',
                              fontWeight: 'bold',
                              fontSize: '12px',
                            }}
                          >
                            {user.status === 'Verified' ? 'Suspend' : 'Verify'}
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* Listings Moderation Screen */}
          {activeTab === 'moderation' && (
            <div>
              <div style={{ marginBottom: '24px' }}>
                <h1 style={{ fontSize: '26px', fontWeight: 'bold' }}>Listings Moderation Queue</h1>
                <p style={{ fontSize: '14px', color: 'var(--text-secondary)' }}>Review produce listings flagged by automated anomaly filters or user complaints.</p>
              </div>

              {flaggedListings.length === 0 ? (
                <div style={{ backgroundColor: 'white', padding: '40px', borderRadius: '12px', textAlign: 'center', border: '1px solid var(--border-color)' }}>
                  <ShieldCheck size={48} color="var(--primary-green)" style={{ margin: '0 auto 12px' }} />
                  <h3 style={{ fontSize: '18px', fontWeight: 'bold' }}>Moderation Queue Clean</h3>
                  <p style={{ fontSize: '13px', color: 'var(--text-secondary)' }}>All user produce listings comply with platform agricultural standards.</p>
                </div>
              ) : (
                <div style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
                  {flaggedListings.map(listing => (
                    <div key={listing.id} style={{
                      backgroundColor: 'white',
                      padding: '20px',
                      borderRadius: '12px',
                      border: '1px solid var(--border-color)',
                      display: 'flex',
                      justifyContent: 'space-between',
                      alignItems: 'center',
                    }}>
                      <div>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                          <span style={{ fontSize: '12px', fontWeight: 'bold', color: 'var(--alert-red)' }}>{listing.id}</span>
                          <h3 style={{ fontSize: '16px', fontWeight: 'bold' }}>{listing.crop}</h3>
                          <span style={{ fontSize: '13px', color: 'var(--text-secondary)' }}>by {listing.farmer}</span>
                        </div>
                        <p style={{ fontSize: '13px', color: 'var(--alert-red)', fontWeight: '500', marginTop: '4px' }}>⚠️ Reason: {listing.reason}</p>
                        <span style={{ fontSize: '11px', color: 'var(--text-secondary)' }}>Reported: {listing.date}</span>
                      </div>

                      <div style={{ display: 'flex', gap: '10px' }}>
                        <button
                          onClick={() => approveListing(listing.id)}
                          style={{
                            padding: '8px 16px',
                            borderRadius: '6px',
                            border: 'none',
                            backgroundColor: 'var(--primary-green)',
                            color: 'white',
                            fontWeight: 'bold',
                            fontSize: '12px',
                            display: 'flex',
                            alignItems: 'center',
                            gap: '4px',
                          }}
                        >
                          <Check size={14} /> Approve Listing
                        </button>
                        <button
                          onClick={() => approveListing(listing.id)}
                          style={{
                            padding: '8px 16px',
                            borderRadius: '6px',
                            border: '1px solid var(--border-color)',
                            backgroundColor: '#FFEBEE',
                            color: 'var(--alert-red)',
                            fontWeight: 'bold',
                            fontSize: '12px',
                            display: 'flex',
                            alignItems: 'center',
                            gap: '4px',
                          }}
                        >
                          <X size={14} /> Remove
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          {/* Price Index Editor Screen */}
          {activeTab === 'prices' && (
            <div>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
                <div>
                  <h1 style={{ fontSize: '26px', fontWeight: 'bold' }}>Price Index Editor</h1>
                  <p style={{ fontSize: '14px', color: 'var(--text-secondary)' }}>Daily wholesale crop benchmarks from Dambulla, Pettah, and Keppetipola Economic Centres.</p>
                </div>
                <button style={{
                  padding: '10px 18px',
                  borderRadius: '8px',
                  border: 'none',
                  backgroundColor: 'var(--secondary-amber)',
                  color: 'var(--text-primary)',
                  fontWeight: 'bold',
                  fontSize: '13px',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '6px',
                }}>
                  <Plus size={16} /> Add Crop Price
                </button>
              </div>

              <div style={{ backgroundColor: 'white', borderRadius: '12px', border: '1px solid var(--border-color)', overflow: 'hidden' }}>
                <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '13px' }}>
                  <thead style={{ backgroundColor: '#FAF9F6', borderBottom: '1px solid var(--border-color)' }}>
                    <tr>
                      <th style={{ padding: '14px 20px', fontWeight: 'bold' }}>Crop Name</th>
                      <th style={{ padding: '14px 20px', fontWeight: 'bold' }}>Wholesale Market</th>
                      <th style={{ padding: '14px 20px', fontWeight: 'bold' }}>Current Rate (LKR/kg)</th>
                      <th style={{ padding: '14px 20px', fontWeight: 'bold' }}>7-Day Trend</th>
                      <th style={{ padding: '14px 20px', fontWeight: 'bold' }}>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    {pricesList.map((p) => (
                      <tr key={p.id} style={{ borderBottom: '1px solid var(--border-color)' }}>
                        <td style={{ padding: '14px 20px', fontWeight: 'bold' }}>{p.crop}</td>
                        <td style={{ padding: '14px 20px', color: 'var(--text-secondary)' }}>{p.market}</td>
                        <td style={{ padding: '14px 20px', fontWeight: 'bold', color: 'var(--accent-teal)' }}>Rs. {p.price.toFixed(2)}</td>
                        <td style={{ padding: '14px 20px', fontWeight: 'bold', color: p.trend.startsWith('+') ? 'var(--primary-green)' : 'var(--alert-red)' }}>
                          {p.trend}
                        </td>
                        <td style={{ padding: '14px 20px' }}>
                          <span style={{ padding: '3px 8px', borderRadius: '10px', fontSize: '11px', fontWeight: 'bold', backgroundColor: '#E8F5E9', color: 'var(--primary-green)' }}>
                            Published
                          </span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* Disease Mapping Screen */}
          {activeTab === 'disease' && (
            <div>
              <div style={{ marginBottom: '24px' }}>
                <h1 style={{ fontSize: '26px', fontWeight: 'bold' }}>Disease-Treatment Mapping</h1>
                <p style={{ fontSize: '14px', color: 'var(--text-secondary)' }}>Manage recommended organic & chemical treatments linked to AI diagnoses.</p>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '20px' }}>
                <div style={{ backgroundColor: 'white', padding: '22px', borderRadius: '12px', border: '1px solid var(--border-color)' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                    <div>
                      <span style={{ fontSize: '11px', fontWeight: 'bold', color: 'var(--primary-green)' }}>PADDY (RICE)</span>
                      <h3 style={{ fontSize: '18px', fontWeight: 'bold', marginTop: '2px' }}>Bacterial Leaf Blight</h3>
                      <p style={{ fontSize: '12px', fontStyle: 'italic', color: 'var(--text-secondary)' }}>Xanthomonas oryzae</p>
                    </div>
                    <span style={{ backgroundColor: 'var(--alert-red)', color: 'white', fontSize: '10px', fontWeight: 'bold', padding: '3px 8px', borderRadius: '10px' }}>SEVERE</span>
                  </div>
                  <div style={{ marginTop: '16px', fontSize: '13px' }}>
                    <p style={{ fontWeight: 'bold', color: 'var(--accent-teal)' }}>🌿 Organic Remedy:</p>
                    <p style={{ color: 'var(--text-secondary)', marginBottom: '10px' }}>Neem Seed Kernel Extract 5% (5ml/L water)</p>
                    <p style={{ fontWeight: 'bold', color: 'var(--secondary-amber)' }}>⚗️ Approved Chemical:</p>
                    <p style={{ color: 'var(--text-secondary)' }}>Streptomycin Sulphate + Tetracycline (1.5g per 10L)</p>
                  </div>
                </div>

                <div style={{ backgroundColor: 'white', padding: '22px', borderRadius: '12px', border: '1px solid var(--border-color)' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                    <div>
                      <span style={{ fontSize: '11px', fontWeight: 'bold', color: 'var(--primary-green)' }}>TOMATO</span>
                      <h3 style={{ fontSize: '18px', fontWeight: 'bold', marginTop: '2px' }}>Early Blight</h3>
                      <p style={{ fontSize: '12px', fontStyle: 'italic', color: 'var(--text-secondary)' }}>Alternaria solani</p>
                    </div>
                    <span style={{ backgroundColor: 'var(--secondary-amber)', color: 'var(--text-primary)', fontSize: '10px', fontWeight: 'bold', padding: '3px 8px', borderRadius: '10px' }}>MODERATE</span>
                  </div>
                  <div style={{ marginTop: '16px', fontSize: '13px' }}>
                    <p style={{ fontWeight: 'bold', color: 'var(--accent-teal)' }}>🌿 Organic Remedy:</p>
                    <p style={{ color: 'var(--text-secondary)', marginBottom: '10px' }}>Baking soda (5g/L) + Trichoderma root drench</p>
                    <p style={{ fontWeight: 'bold', color: 'var(--secondary-amber)' }}>⚗️ Approved Chemical:</p>
                    <p style={{ color: 'var(--text-secondary)' }}>Mancozeb 75 WP (2g/L water)</p>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* Announcements Screen matching Addition 3 in Development Guide */}
          {activeTab === 'announcements' && (
            <div>
              <div style={{ marginBottom: '24px' }}>
                <h1 style={{ fontSize: '26px', fontWeight: 'bold' }}>Regional Announcements & Weather Alerts</h1>
                <p style={{ fontSize: '14px', color: 'var(--text-secondary)' }}>Broadcast urgent alerts to farmers by province or target crop.</p>
              </div>

              {/* Form */}
              <form onSubmit={handleCreateAnnouncement} style={{
                backgroundColor: 'white',
                padding: '24px',
                borderRadius: '12px',
                border: '1px solid var(--border-color)',
                marginBottom: '28px',
              }}>
                <h3 style={{ fontSize: '16px', fontWeight: 'bold', marginBottom: '16px' }}>Compose New Regional Alert</h3>
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', marginBottom: '16px' }}>
                  <div>
                    <label style={{ display: 'block', fontSize: '12px', fontWeight: 'bold', marginBottom: '6px' }}>Alert Headline</label>
                    <input
                      type="text"
                      placeholder="e.g. Heavy rainfall alert for Kurunegala paddy farmers"
                      value={newAlertTitle}
                      onChange={(e) => setNewAlertTitle(e.target.value)}
                      style={{
                        width: '100%',
                        padding: '10px 14px',
                        borderRadius: '8px',
                        border: '1px solid var(--border-color)',
                        fontSize: '13px',
                      }}
                    />
                  </div>
                  <div>
                    <label style={{ display: 'block', fontSize: '12px', fontWeight: 'bold', marginBottom: '6px' }}>Target Province / District</label>
                    <select style={{
                      width: '100%',
                      padding: '10px 14px',
                      borderRadius: '8px',
                      border: '1px solid var(--border-color)',
                      fontSize: '13px',
                    }}>
                      <option>All Island (Sri Lanka)</option>
                      <option>North Central (Anuradhapura, Polonnaruwa)</option>
                      <option>Central (Kandy, Matale, Nuwara Eliya)</option>
                      <option>Western (Colombo, Gampaha, Kalutara)</option>
                    </select>
                  </div>
                </div>

                <div style={{ marginBottom: '16px' }}>
                  <label style={{ display: 'block', fontSize: '12px', fontWeight: 'bold', marginBottom: '6px' }}>Message Body</label>
                  <textarea
                    rows={3}
                    placeholder="Provide actionable guidance for farmers..."
                    value={newAlertMsg}
                    onChange={(e) => setNewAlertMsg(e.target.value)}
                    style={{
                      width: '100%',
                      padding: '10px 14px',
                      borderRadius: '8px',
                      border: '1px solid var(--border-color)',
                      fontSize: '13px',
                    }}
                  />
                </div>

                <button
                  type="submit"
                  style={{
                    padding: '10px 22px',
                    borderRadius: '8px',
                    border: 'none',
                    backgroundColor: 'var(--secondary-amber)',
                    color: 'var(--text-primary)',
                    fontWeight: 'bold',
                    fontSize: '13px',
                    display: 'flex',
                    alignItems: 'center',
                    gap: '6px',
                  }}
                >
                  <Megaphone size={16} /> Broadcast Alert
                </button>
              </form>

              {/* Past Announcements Log */}
              <div style={{ backgroundColor: 'white', borderRadius: '12px', border: '1px solid var(--border-color)', padding: '20px' }}>
                <h3 style={{ fontSize: '16px', fontWeight: 'bold', marginBottom: '14px' }}>Past Broadcast Logs</h3>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                  {announcements.map(a => (
                    <div key={a.id} style={{
                      padding: '14px',
                      borderRadius: '8px',
                      backgroundColor: 'var(--bg-color)',
                      display: 'flex',
                      justifyContent: 'space-between',
                      alignItems: 'center',
                    }}>
                      <div>
                        <h4 style={{ fontSize: '14px', fontWeight: 'bold' }}>{a.title}</h4>
                        <p style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>Region: {a.region} • {a.date}</p>
                      </div>
                      <span style={{ fontSize: '12px', fontWeight: 'bold', color: 'var(--primary-green)' }}>
                        Reach: {a.reach}
                      </span>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
