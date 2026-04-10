// ============================================================
// BOOKLINK - Shared App Utilities
// Fast session cache + helpers used across all pages
// ============================================================

// Cache session in memory to avoid repeated async calls
window._blSession = null;

async function getSession() {
    if (window._blSession) return window._blSession;
    const { data: { session } } = await sb.auth.getSession();
    window._blSession = session;
    return session;
}

function setUserLocals(user) {
    localStorage.setItem('userName', user.user_metadata?.full_name || user.email.split('@')[0]);
    localStorage.setItem('userEmail', user.email);
    localStorage.setItem('userId', user.id);
}

function updateNavUser() {
    const name = localStorage.getItem('userName')?.split(' ')[0] || 'Guest';
    const el = document.getElementById('userDisplay');
    const av = document.getElementById('userAvatar');
    if (el) el.textContent = name;
    if (av) av.textContent = name.charAt(0).toUpperCase();
}

function setActiveNav(page) {
    const map = { home: 'navHome', books: 'navBooks', 'post-book': 'navPostBook', profile: 'navProfile' };
    Object.values(map).forEach(id => document.getElementById(id)?.classList.remove('active'));
    if (map[page]) document.getElementById(map[page])?.classList.add('active');
}

async function logout() {
    if (!confirm('Are you sure you want to logout?')) return;
    await sb.auth.signOut();
    localStorage.clear();
    window._blSession = null;
    window.location.href = 'index.html';
}

// Show skeleton loader
function showSkeleton(containerId, count = 6) {
    const el = document.getElementById(containerId);
    if (!el) return;
    el.innerHTML = Array(count).fill(`
        <div class="animate-pulse bg-white rounded-xl overflow-hidden shadow">
            <div class="h-40 bg-gray-200"></div>
            <div class="p-3 space-y-2">
                <div class="h-3 bg-gray-200 rounded w-3/4"></div>
                <div class="h-3 bg-gray-200 rounded w-1/2"></div>
                <div class="h-3 bg-gray-200 rounded w-1/3"></div>
            </div>
        </div>`).join('');
}

// Toast notification
function showToast(msg, type = 'success') {
    const colors = { success: '#10b981', error: '#ef4444', info: '#3b82f6' };
    const toast = document.createElement('div');
    toast.style.cssText = `position:fixed;top:20px;right:20px;z-index:9999;padding:12px 20px;border-radius:10px;color:white;font-size:14px;font-weight:600;background:${colors[type]||colors.success};box-shadow:0 4px 20px rgba(0,0,0,0.2);animation:slideIn .3s ease`;
    toast.textContent = msg;
    document.body.appendChild(toast);
    setTimeout(() => toast.remove(), 3000);
}

// Add toast animation
const style = document.createElement('style');
style.textContent = `@keyframes slideIn{from{opacity:0;transform:translateX(100px)}to{opacity:1;transform:translateX(0)}}`;
document.head.appendChild(style);
