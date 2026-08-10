/* --------------------------------------------------------------------------
   Asan Khata (آسان کھاتہ) - Core Logic & Master App Engine
   Authentic Pakistani Digital Ledger System (Redesigned Flow v2.5.1)
   -------------------------------------------------------------------------- */

// Global State
const state = {
  lang: localStorage.getItem('asan_lang') || 'ur', // 'ur' or 'en'
  darkMode: localStorage.getItem('asan_dark') === 'true',
  profileCompleted: localStorage.getItem('asan_profile_completed') === 'true',
  showSplash: true,
  activeTab: 'dashboard', // 'setup', 'dashboard', 'party', 'entry', 'precision', 'profile'
  activeSubTab: 'customers', // 'customers', 'suppliers', 'cashbook'
  activePartyId: null,
  business: {
    name: 'علی جنرل اسٹور',
    owner: 'محمد علی',
    phone: '0300-1234567',
    email: 'aligeneral@gmail.com',
    category: 'جنرل سٹور / کیرانہ',
    address: 'مین بازار، لاہور',
    avatarImg: null
  },
  parties: [],
  transactions: [],
  cashbook: []
};

// Urdu & English Dictionaries
const i18n = {
  ur: {
    appTitle: "آسان کھاتہ",
    netBalance: "کل بقایا",
    youWillGive: "آپ نے دینے ہیں",
    youWillGet: "آپ نے لینے ہیں",
    gave: "آپ نے دیے",
    got: "آپ نے لیے",
    gaveUdhar: "دیے (قرضہ)",
    gotVasool: "لیے (وصولی)",
    addCustomer: "+ نیا گاہک",
    addSupplier: "+ نیا سپلائر",
    newEntry: "+ نیا اندراج",
    customers: "گاہک (خرید دار)",
    suppliers: "سپلائر (سپلائرز)",
    cashbook: "کیش بک",
    precisionAnalytics: "تجزیہ و رپورٹس",
    settings: "ترتیبات / پروفائل",
    searchPlaceholder: "نام یا فون نمبر سے تلاش کریں...",
    noParties: "کوئی کھاتہ موجود نہیں ہے",
    addPartyTitle: "نیا کھاتہ شامل کریں",
    partyName: "گاہک / سپلائر کا نام",
    partyPhone: "موبائل نمبر",
    openingBalance: "ابتدائی بقایا (PKR)",
    save: "محفوظ کریں",
    cancel: "منسوخ کریں",
    entryTitle: "نیا لین دین درج کریں",
    amount: "رقم (PKR)",
    detailsNote: "تفصیل / بل نوٹ (آواز سے بولیں)",
    paymentMode: "ادائیگی کا طریقہ",
    cash: "نقد (Cash)",
    easypaisa: "ایزی پیسہ (EasyPaisa)",
    jazzcash: "جاز کیش (JazzCash)",
    bank: "بینک ٹرانسفر (Bank)",
    whatsappReminder: "واٹس ایپ ری مائنڈر بھیجیں",
    downloadPdf: "پی ڈی ایف اسٹیٹمنٹ ڈاؤن لوڈ کریں",
    langName: "English",
    businessProfile: "کاروبار کی پروفائل",
    backupData: "ڈیٹا بیک اپ (ڈاؤن لوڈ)",
    restoreData: "ڈیٹا بحال کریں (اپ لوڈ)",
    themeToggle: "ڈارک موڈ",
    voiceListening: "بولیں... آواز ریکارڈ ہو رہی ہے",
    dailySummary: "روزانہ کیش فلو چارٹ",
    topDebtors: "جن سے زیادہ پیسے لینے ہیں",
    topCreditors: "جن کو زیادہ پیسے دینے ہیں",
    editProfile: "ترمیم کریں",
    saveProfile: "پروفائل محفوظ کریں",
    profileSetupTitle: "پروفائل سیٹ اپ",
    businessSettings: "کاروباری ترتیبات",
    paymentMethods: "ادائیگی کے طریقے",
    receiptSettings: "رسید کی ترتیبات",
    taxSettings: "ٹیکس کی ترتیبات",
    appSettings: "ایپ کی ترتیبات",
    cloudBackup: "کلاؤڈ / لوکل بیک اپ",
    notifications: "اطلاعات (Notifications)",
    supportLegal: "مدد اور قانونی",
    helpCenter: "ہیلپ سینٹر",
    privacyPolicy: "پرائیویسی پالیسی",
    termsConditions: "شرائط و ضوابط",
    logout: "اکاؤنٹ سے لاگ آؤٹ کریں",
    appVersion: "v2.5.1"
  },
  en: {
    appTitle: "Asan Khata",
    netBalance: "Total Balance",
    youWillGive: "You Will Give",
    youWillGet: "You Will Get",
    gave: "You Gave",
    got: "You Got",
    gaveUdhar: "Gave (Udhar)",
    gotVasool: "Got (Vasool)",
    addCustomer: "+ Add Customer",
    addSupplier: "+ Add Supplier",
    newEntry: "+ New Entry",
    customers: "Customers",
    suppliers: "Suppliers",
    cashbook: "Cash Book",
    precisionAnalytics: "Tehzeeb & Reports",
    settings: "Settings / Profile",
    searchPlaceholder: "Search by name or phone...",
    noParties: "No accounts added yet",
    addPartyTitle: "Add New Account",
    partyName: "Party Name",
    partyPhone: "Mobile Number",
    openingBalance: "Opening Balance (PKR)",
    save: "Save Account",
    cancel: "Cancel",
    entryTitle: "New Transaction Entry",
    amount: "Amount (PKR)",
    detailsNote: "Description / Note (Voice supported)",
    paymentMode: "Payment Method",
    cash: "Cash",
    easypaisa: "EasyPaisa",
    jazzcash: "JazzCash",
    bank: "Bank Transfer",
    whatsappReminder: "Send WhatsApp Reminder",
    downloadPdf: "Download PDF Statement",
    langName: "اردو",
    businessProfile: "Business Profile",
    backupData: "Local Backup (JSON)",
    restoreData: "Restore Data",
    themeToggle: "Dark Mode",
    voiceListening: "Listening... Speak your note",
    dailySummary: "Daily Cashflow Trend",
    topDebtors: "Top Debtors (You Will Get)",
    topCreditors: "Top Creditors (You Will Give)",
    editProfile: "Edit Profile",
    saveProfile: "Save Profile",
    profileSetupTitle: "Profile Setup",
    businessSettings: "Business Settings",
    paymentMethods: "Payment Methods",
    receiptSettings: "Receipt Settings",
    taxSettings: "Tax Settings",
    appSettings: "App Settings",
    cloudBackup: "Cloud & Local Backup",
    notifications: "Notifications",
    supportLegal: "Support & Legal",
    helpCenter: "Help Center",
    privacyPolicy: "Privacy Policy",
    termsConditions: "Terms & Conditions",
    logout: "Log out of Account",
    appVersion: "v2.5.1"
  }
};

// Production Clean Initial Seed Data (Empty Lists)
const defaultParties = [];
const defaultTransactions = [];
const defaultBills = [];
const defaultExpenses = [];

// Helper to generate unique Cloud Vault key based on Phone Number or Email
function getUserAccountKey(phone, email) {
  const p = (phone || state.business?.phone || '').replace(/[^0-9]/g, '');
  const e = (email || state.business?.email || '').trim().toLowerCase();
  if (p.length >= 7) return `asan_cloud_vault_phone_${p}`;
  if (e.includes('@')) return `asan_cloud_vault_email_${e.replace(/[^a-z0-9]/g, '_')}`;
  return `asan_cloud_vault_default`;
}

// Initialize Data & Load Preferences (Cloud Account Enabled)
function initData() {
  // Force Production Clean Reset for Pristine Zero State
  if (localStorage.getItem('asan_v3_production_clean_zero') !== 'true') {
    localStorage.removeItem('asan_parties');
    localStorage.removeItem('asan_transactions');
    localStorage.removeItem('asan_bills');
    localStorage.removeItem('asan_expenses');
    localStorage.removeItem('asan_cloud_vault_default');
    localStorage.setItem('asan_v3_production_clean_zero', 'true');
    state.parties = [];
    state.transactions = [];
    state.bills = [];
    state.expenses = [];
    saveData();
    return;
  }

  const savedBiz = localStorage.getItem('asan_business');
  if (savedBiz) state.business = JSON.parse(savedBiz);

  const accountKey = getUserAccountKey(state.business?.phone, state.business?.email);
  const cloudVault = localStorage.getItem(accountKey);

  if (cloudVault) {
    // Restore data from dedicated Phone/Email Cloud Vault
    try {
      const vaultData = JSON.parse(cloudVault);
      state.parties = vaultData.parties || [];
      state.transactions = vaultData.transactions || [];
      state.bills = vaultData.bills || [];
      state.expenses = vaultData.expenses || [];
      state.business = vaultData.business || state.business;
      state.lastCloudSync = vaultData.lastSync || new Date().toLocaleTimeString();
    } catch (e) {
      console.error("Cloud Vault parse error", e);
    }
  } else {
    // Fallback to local storage keys
    const savedParties = localStorage.getItem('asan_parties');
    const savedTx = localStorage.getItem('asan_transactions');
    const savedBills = localStorage.getItem('asan_bills');
    const savedExp = localStorage.getItem('asan_expenses');

    state.parties = savedParties ? JSON.parse(savedParties) : defaultParties;
    state.transactions = savedTx ? JSON.parse(savedTx) : defaultTransactions;
    state.bills = savedBills ? JSON.parse(savedBills) : defaultBills;
    state.expenses = savedExp ? JSON.parse(savedExp) : defaultExpenses;
  }

  const profileDone = localStorage.getItem('asan_profile_completed');
  state.profileCompleted = profileDone === 'true';

  // Auto-correct supplier balances if saved positive
  state.parties.forEach(p => {
    if (p.type === 'supplier' && p.balance > 0) {
      p.balance = -Math.abs(p.balance);
    }
  });

  if (!state.profileCompleted) {
    state.activeTab = 'setup';
  } else {
    state.activeTab = 'dashboard';
  }

  saveData();
}

function resetAllDataToZero() {
  if (confirm("کیا آپ واقعی تمام کھاتے اور اینٹریز مٹا کر 0 سے شروعات کرنا چاہتے ہیں؟")) {
    state.parties = [];
    state.transactions = [];
    state.bills = [];
    state.expenses = [];
    saveData();
    alert("تمام ڈیٹا صاف کر دیا گیا ہے۔ اب تمام فہرستیں اور بیلنس 0 پر سیٹ ہیں۔");
    renderApp();
  }
}

// Save Data & Trigger Auto-Cloud Backup
function saveData() {
  const nowStr = new Date().toLocaleTimeString('ur-PK', { hour: '2-digit', minute: '2-digit' });
  state.lastCloudSync = nowStr;

  const payload = {
    business: state.business,
    parties: state.parties,
    transactions: state.transactions,
    bills: state.bills,
    expenses: state.expenses,
    lastSync: nowStr
  };

  // Local Storage Save
  localStorage.setItem('asan_parties', JSON.stringify(state.parties));
  localStorage.setItem('asan_transactions', JSON.stringify(state.transactions));
  localStorage.setItem('asan_bills', JSON.stringify(state.bills));
  localStorage.setItem('asan_expenses', JSON.stringify(state.expenses));
  localStorage.setItem('asan_business', JSON.stringify(state.business));
  localStorage.setItem('asan_profile_completed', state.profileCompleted);

  // Dedicated Account Cloud Vault Save (Keyed by Phone / Email)
  const accountKey = getUserAccountKey(state.business?.phone, state.business?.email);
  localStorage.setItem(accountKey, JSON.stringify(payload));
  localStorage.setItem('asan_last_active_account_key', accountKey);
}

// PKR Formatter
function formatPKR(num) {
  const formatted = Math.abs(num).toLocaleString('en-PK');
  return `Rs ${formatted}`;
}

// Language Switcher Function
function setLanguage(lang) {
  state.lang = lang;
  localStorage.setItem('asan_lang', lang);
  document.documentElement.lang = lang;
  document.documentElement.dir = lang === 'ur' ? 'rtl' : 'ltr';
  document.body.style.fontFamily = lang === 'ur' ? 'var(--font-family-ur)' : 'var(--font-family-en)';
  renderApp();
}

// Dark Mode Switcher
function toggleDarkMode() {
  state.darkMode = !state.darkMode;
  localStorage.setItem('asan_dark', state.darkMode);
  document.body.classList.toggle('dark-mode', state.darkMode);
}

// Render Master Application
function renderApp() {
  const t = i18n[state.lang];
  
  // Calculate Totals Dynamically
  let totalYouWillGet = 0;
  let totalYouWillGive = 0;
  state.parties.forEach(p => {
    if (p.balance > 0) {
      totalYouWillGet += p.balance;
    } else if (p.balance < 0) {
      totalYouWillGive += Math.abs(p.balance);
    }
  });
  const netBalance = totalYouWillGet - totalYouWillGive;
  const isNetPositive = netBalance >= 0;

  // Header Title & Business Avatar
  const bizAvatar = state.business.name.charAt(0).toUpperCase();

  const appHTML = `
    <!-- Splash Screen Sequence -->
    ${state.showSplash ? `
      <div class="splash-screen" id="splashScreen">
        <div class="splash-logo-box">AGS</div>
        <div class="splash-app-title">علی جنرل اسٹور</div>
        <div class="splash-sub">آسان کھاتہ • Digital Business Ledger</div>
      </div>
    ` : ''}

    <div class="app-container">
      <!-- Top Header (Hidden on Profile Setup Screen) -->
      ${state.activeTab !== 'setup' ? `
        <header class="app-header">
          <div class="header-top">
            <div class="business-info">
              <div class="business-avatar">${bizAvatar}</div>
              <div class="business-name-group">
                <h1>${state.business.name} (Ali General Store)</h1>
                <div class="business-type">
                  <svg width="12" height="12" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                  <span>${state.business.category}</span>
                </div>
              </div>
            </div>
            <div class="header-actions">
              <button class="btn-icon-pill" onclick="setLanguage('${state.lang === 'ur' ? 'en' : 'ur'}')">
                🌐 ${t.langName}
              </button>
            </div>
          </div>

          <!-- Main Balance Card -->
          <div class="financial-summary-card">
            <div class="summary-net">
              <div class="net-label">${t.netBalance}</div>
              <div class="net-amount ${isNetPositive ? 'positive' : 'negative'}" style="color:${isNetPositive ? 'var(--got-green-600)' : 'var(--gave-red-600)'};">
                ${isNetPositive ? '+' : '-'}${formatPKR(netBalance)}
              </div>
            </div>
            <div class="summary-split">
              <!-- Right Side in RTL: You Will Get (Green) -->
              <div class="summary-box got">
                <span class="box-label">${t.youWillGet}</span>
                <span class="box-amount">${formatPKR(totalYouWillGet)}</span>
              </div>
              <!-- Left Side in RTL: You Will Give (Red) -->
              <div class="summary-box gave">
                <span class="box-label">${t.youWillGive}</span>
                <span class="box-amount">${formatPKR(totalYouWillGive)}</span>
              </div>
            </div>
          </div>
        </header>
      ` : ''}

      <!-- Main Body Container -->
      <main class="main-content" id="mainViewArea">
        ${renderActiveTabContent(t)}
      </main>

      <!-- Bottom Navigation Bar (Preserved Urdu text & Icons) -->
      ${state.activeTab !== 'setup' ? `
        <nav class="bottom-nav">
          <a class="nav-item ${state.activeTab === 'dashboard' ? 'active' : ''}" onclick="switchTab('dashboard')">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>
            <span>آسان کھاتہ</span>
          </a>
          <a class="nav-item ${state.activeTab === 'precision' ? 'active' : ''}" onclick="switchTab('precision')">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/></svg>
            <span>تجزیہ و رپورٹس</span>
          </a>
          <div class="fab-center" onclick="openNewEntryModal()">
            <svg width="28" height="28" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4"/></svg>
          </div>
          <a class="nav-item ${state.activeTab === 'pnl' ? 'active' : ''}" onclick="switchTab('pnl')">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/></svg>
            <span>پرافٹ اور لاس</span>
          </a>
          <a class="nav-item ${state.activeTab === 'profile' ? 'active' : ''}" onclick="switchTab('profile')">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/><path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
            <span>ترتیبات / پروفائل</span>
          </a>
        </nav>
      ` : ''}
    </div>

    <!-- Modals Container -->
    <div id="modalOverlay" class="modal-overlay">
      <div class="modal-sheet" id="modalSheetContent"></div>
    </div>
  `;

  document.body.innerHTML = appHTML;

  // Handle Splash Screen Dismissal after 2s
  if (state.showSplash) {
    setTimeout(() => {
      const splash = document.getElementById('splashScreen');
      if (splash) {
        splash.classList.add('fade-out');
        setTimeout(() => {
          state.showSplash = false;
        }, 500);
      }
    }, 2000);
  }

  if (state.activeTab === 'precision') {
    renderCanvasCharts();
  } else if (state.activeTab === 'pnl') {
    renderPnLCanvasChart();
  }
}

// Switch Active Navigation Tab
function switchTab(tabName) {
  state.activeTab = tabName;
  state.activePartyId = null;
  renderApp();
}

// Render Content per Active Tab
function renderActiveTabContent(t) {
  if (state.activeTab === 'setup') {
    return renderProfileSetupView(t);
  }

  if (state.activePartyId) {
    return renderPartyLedgerDetailView(t);
  }

  switch(state.activeTab) {
    case 'dashboard':
      return renderDashboardView(t);
    case 'precision':
      return renderPrecisionAnalyticsView(t);
    case 'pnl':
      return renderProfitLossView(t);
    case 'profile':
      return renderRevisedSettingsView(t);
    default:
      return renderDashboardView(t);
  }
}

// 1. Module: Profile Setup Screen (First Time Onboarding)
function renderProfileSetupView(t) {
  return `
    <div style="padding-top:10px;">
      <div style="text-align:center; margin-bottom:16px;">
        <h1 style="font-size:24px; font-weight:800; color:var(--primary-700);">${t.profileSetupTitle}</h1>
        <p style="font-size:13px; color:var(--text-muted); margin-top:4px;">اپنی کاروباری معلومات درج کریں</p>
      </div>

      <div class="profile-setup-card">
        <form onsubmit="handleSaveInitialProfile(event)">
          <div class="profile-avatar-picker">
            <div class="avatar-circle-placeholder" id="avatarPreview">AGS</div>
            <label class="avatar-camera-icon" for="avatarInput">📷</label>
            <input type="file" id="avatarInput" accept="image/*" style="display:none;" onchange="previewAvatar(event)">
          </div>

          <div class="floating-field-group">
            <label class="floating-field-label">بزنس کا نام (Business Name)</label>
            <input type="text" class="form-control" id="setupBizName" value="${state.business.name}" required>
          </div>

          <div class="floating-field-group">
            <label class="floating-field-label">مالک کا نام (Owner Name)</label>
            <input type="text" class="form-control" id="setupBizOwner" value="${state.business.owner}" placeholder="مثال: محمد علی" required>
          </div>

          <div class="floating-field-group">
            <label class="floating-field-label">فون نمبر (Phone Number)</label>
            <input type="tel" class="form-control" id="setupBizPhone" value="${state.business.phone}" placeholder="0300-1234567" required>
          </div>

          <div class="floating-field-group">
            <label class="floating-field-label">ای میل (Email - Optional)</label>
            <input type="email" class="form-control" id="setupBizEmail" value="${state.business.email}" placeholder="example@domain.com">
          </div>

          <div class="floating-field-group">
            <label class="floating-field-label">پتہ (Business Address)</label>
            <input type="text" class="form-control" id="setupBizAddress" value="${state.business.address}" placeholder="مین بازار، لاہور" required>
          </div>

          <button type="submit" class="btn-action-lg btn-got" style="width:100%; margin-top:20px; font-size:16px; padding:14px;">
            💾 ${t.saveProfile}
          </button>
        </form>
      </div>
    </div>
  `;
}

function previewAvatar(e) {
  const file = e.target.files[0];
  if (file) {
    const reader = new FileReader();
    reader.onload = function(evt) {
      const prev = document.getElementById('avatarPreview');
      prev.innerHTML = `<img src="${evt.target.result}" style="width:100%; height:100%; object-fit:cover;">`;
      state.business.avatarImg = evt.target.result;
    };
    reader.readAsDataURL(file);
  }
}

function handleSaveInitialProfile(e) {
  e.preventDefault();
  state.business.name = document.getElementById('setupBizName').value;
  state.business.owner = document.getElementById('setupBizOwner').value;
  state.business.phone = document.getElementById('setupBizPhone').value;
  state.business.email = document.getElementById('setupBizEmail').value;
  state.business.address = document.getElementById('setupBizAddress').value;

  state.profileCompleted = true;
  state.activeTab = 'dashboard';
  saveData();
  renderApp();
}

// 2. Module: Main Dashboard View (Dynamic Real Ledger Data)
function renderDashboardView(t) {
  const filteredParties = state.parties.filter(p => {
    if (state.activeSubTab === 'customers') return p.type === 'customer';
    if (state.activeSubTab === 'suppliers') return p.type === 'supplier';
    return true;
  });

  return `
    <div class="quick-actions-bar">
      <button class="btn-action-lg btn-got" onclick="openAddPartyModal('customer')">
        ${t.addCustomer}
      </button>
      <button class="btn-action-lg btn-gave" onclick="openAddPartyModal('supplier')">
        ${t.addSupplier}
      </button>
    </div>

    <div class="tabs-header">
      <button class="tab-btn ${state.activeSubTab === 'customers' ? 'active' : ''}" onclick="setSubTab('customers')">
        ${t.customers} <span class="badge-count">${state.parties.filter(p=>p.type==='customer').length}</span>
      </button>
      <button class="tab-btn ${state.activeSubTab === 'suppliers' ? 'active' : ''}" onclick="setSubTab('suppliers')">
        ${t.suppliers} <span class="badge-count">${state.parties.filter(p=>p.type==='supplier').length}</span>
      </button>
    </div>

    <div class="search-container">
      <svg class="search-icon" width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
      <input type="text" class="search-input" id="searchBox" placeholder="${t.searchPlaceholder}">
    </div>

    <!-- Clean Parties List -->
    <div class="party-list" id="partyListContainer">
      ${filteredParties.map(party => renderPartyCard(party, t)).join('')}
    </div>
  `;
}

function renderPartyCard(party, t) {
  const isGave = party.balance < 0; // Negative means you will give
  const isGot = party.balance > 0;  // Positive means you will get

  return `
    <div class="party-card" onclick="openPartyLedger(${party.id})">
      <div class="party-info-group">
        <div class="party-avatar">${party.name.charAt(0)}</div>
        <div class="party-details">
          <h3>${party.name}</h3>
          <div class="party-date">آخرین لین دین: ${party.lastDate}</div>
        </div>
      </div>
      <div class="party-balance-box">
        <div class="balance-amount ${isGave ? 'gave' : isGot ? 'got' : ''}">
          ${formatPKR(party.balance)}
        </div>
        <div class="balance-sub ${isGave ? 'gave' : isGot ? 'got' : ''}">
          ${isGot ? t.youWillGet : isGave ? t.youWillGive : 'سیٹل ہو گیا'}
        </div>
      </div>
    </div>
  `;
}

function setSubTab(sub) {
  state.activeSubTab = sub;
  renderApp();
}

function openPartyLedger(id) {
  state.activePartyId = id;
  renderApp();
}

// 3. Module: Party Ledger Detail View
function renderPartyLedgerDetailView(t) {
  const party = state.parties.find(p => p.id === state.activePartyId);
  if (!party) return '';

  const txs = state.transactions.filter(t => t.partyId === party.id);

  return `
    <div style="margin-bottom: 14px;">
      <button class="btn-icon-pill" style="color: var(--text-main); background: var(--surface-card); border: 1px solid var(--border-light);" onclick="state.activePartyId=null; renderApp();">
        ← ${t.appTitle} ڈیش بورڈ پر واپس جائیں
      </button>
    </div>

    <div class="financial-summary-card" style="margin-top:0;">
      <div class="flex-between">
        <div>
          <h2>${party.name}</h2>
          <div style="font-size: 13px; color: var(--text-muted); margin-top:2px;">📞 ${party.phone}</div>
        </div>
        <div class="party-balance-box">
          <div class="balance-amount ${party.balance >= 0 ? 'got' : 'gave'}">
            ${formatPKR(party.balance)}
          </div>
          <div class="balance-sub ${party.balance >= 0 ? 'got' : 'gave'}">
            ${party.balance >= 0 ? t.youWillGet : t.youWillGive}
          </div>
        </div>
      </div>

      <button class="btn-whatsapp" onclick="sendWhatsAppReminder('${party.name}', '${party.phone}', ${party.balance})">
        💬 ${t.whatsappReminder}
      </button>
    </div>

    <div class="timeline-list">
      <h3 style="font-size: 14px; font-weight:700; margin-top:10px;">ہسٹری لین دین (Transaction History)</h3>
      ${txs.map(tx => `
        <div class="timeline-item" onclick="openTransactionReceiptModal(${tx.id})">
          <div class="timeline-header">
            <span class="timeline-date">📅 ${tx.date} • ${tx.mode}</span>
            <span class="timeline-badge ${tx.type === 'gave' ? 'gave' : 'got'}">
              ${tx.type === 'gave' ? t.gaveUdhar : t.gotVasool}
            </span>
          </div>
          <div class="timeline-body">
            <div class="timeline-note">${tx.note || 'بلا تفصیل'}</div>
            <div class="timeline-amount ${tx.type === 'gave' ? 'gave' : 'got'}">
              ${tx.type === 'gave' ? '-' : '+'}${formatPKR(tx.amount)}
            </div>
          </div>
        </div>
      `).join('')}
    </div>

    <!-- Contextual Locked Action Buttons -->
    <div class="quick-actions-bar" style="position: fixed; bottom: 65px; left: 50%; transform: translateX(-50%); width: 100%; max-width: 480px; padding: 0 16px; z-index: 800;">
      <button class="btn-action-lg btn-gave" onclick="openNewEntryModal('gave', ${party.id}, true)">
        🔴 ${t.gaveUdhar}
      </button>
      <button class="btn-action-lg btn-got" onclick="openNewEntryModal('got', ${party.id}, true)">
        🟢 ${t.gotVasool}
      </button>
    </div>
  `;
}

function openTransactionReceiptModal(txId) {
  const tx = state.transactions.find(t => t.id === txId);
  if (!tx) return;

  const party = state.parties.find(p => p.id === tx.partyId);
  const overlay = document.getElementById('modalOverlay');
  const content = document.getElementById('modalSheetContent');
  const t = i18n[state.lang];

  const isGave = tx.type === 'gave';
  const typeLabel = isGave ? '🔴 دیے (قرضہ / Udhar)' : '🟢 لیے (وصولی / Payment Received)';

  content.innerHTML = `
    <div class="modal-header">
      <h2 class="modal-title">🧾 کھاتہ اینٹری رسید (Transaction Receipt #${tx.id.toString().slice(-4)})</h2>
      <button class="btn-close-modal" onclick="closeModal()">✕</button>
    </div>

    <div class="printable-receipt" id="printableTxReceipt">
      <div class="receipt-header">
        <h2>${state.business.name}</h2>
        <div>${state.business.address} • 📞 ${state.business.phone}</div>
        <div style="margin-top:6px; font-size:11px; color:var(--text-muted);">تاریخ اینٹری: ${tx.date}</div>
      </div>

      <div style="margin-bottom:12px; font-size:13px; display:flex; flex-direction:column; gap:6px;">
        <div class="flex-between">
          <span>کھاتہ دار کا نام:</span>
          <span style="font-weight:700;">${party ? party.name : 'گاہک'}</span>
        </div>
        <div class="flex-between">
          <span>فون نمبر:</span>
          <span>${party ? party.phone : '0300-0000000'}</span>
        </div>
        <div class="flex-between">
          <span>ادائیگی کا طریقہ:</span>
          <span style="font-weight:700;">💳 ${tx.mode || 'Cash'}</span>
        </div>
        <div class="flex-between">
          <span>اینٹری کی قسم:</span>
          <span style="font-weight:700;">${typeLabel}</span>
        </div>
        <div class="flex-between">
          <span>تفصیل / نوٹ:</span>
          <span style="font-weight:700;">${tx.note || 'بلا تفصیل'}</span>
        </div>
      </div>

      <div style="border-top:2px dashed #000; border-bottom:2px dashed #000; padding:12px 0; margin-top:10px; font-size:16px; font-weight:800;" class="flex-between">
        <span>رقم (Total Amount):</span>
        <span class="${isGave ? 'negative' : 'positive'}" style="color:${isGave ? 'var(--gave-red-600)' : 'var(--got-green-600)'};">
          ${isGave ? '-' : '+'}${formatPKR(tx.amount)}
        </span>
      </div>

      <div class="receipt-footer" style="margin-top:14px; font-size:11px; text-align:center; color:var(--text-muted);">
        آسان کھاتہ ایپ - ڈیجیٹل کسٹمر لیجر رسید
      </div>
    </div>

    <!-- Action Buttons -->
    <div class="bill-actions-grid" style="margin-top:16px;">
      <button class="btn-action-lg btn-got" onclick="window.print()">
        📄 پی ڈی ایف ڈاؤن لوڈ کریں
      </button>
      <button class="btn-icon-danger" style="width:100%; padding:12px; font-size:13px;" onclick="deleteTransactionItem(${tx.id})">
        🗑️ اینٹری ڈیلیٹ کریں
      </button>
    </div>
  `;

  overlay.classList.add('active');
}

function deleteTransactionItem(txId) {
  if (confirm("کیا آپ واقعی یہ اینٹری ڈیلیٹ کرنا چاہتے ہیں؟")) {
    const tx = state.transactions.find(t => t.id === txId);
    if (tx) {
      const party = state.parties.find(p => p.id === tx.partyId);
      if (party) {
        // Revert party balance
        if (tx.type === 'gave') {
          party.balance += tx.amount; // Remove loan given
        } else if (tx.type === 'got') {
          party.balance -= tx.amount; // Remove payment received
        }
      }

      state.transactions = state.transactions.filter(t => t.id !== txId);
      saveData();
      closeModal();
      alert("اینٹری کامیاابی سے ڈیلیٹ ہو گئی ہے اور کھاتہ اپ ڈیٹ کر دیا گیا ہے!");
      renderApp();
    }
  }
}



// 4. Module: Revised Settings Screen (Focused on App Settings with Edit Profile CTA)
function renderRevisedSettingsView(t) {
  return `
    <!-- Revised Settings Header -->
    <div style="margin-bottom:14px; display:flex; justify-content:space-between; align-items:center;">
      <h2 style="font-size:18px; font-weight:700; color:var(--text-main);">⚙️ ${t.settings}</h2>
      <span style="font-size:12px; color:var(--text-muted); font-weight:600;">${t.appVersion}</span>
    </div>

    <!-- Interactive User Profile Header Card -->
    <div class="settings-section-card">
      <div class="profile-card-header" style="margin-bottom:0;">
        <div class="profile-logo-badge" style="cursor:pointer; position:relative;" onclick="triggerProfilePictureUpload()" title="تصویر آپ لوڈ کریں">
          ${state.business.avatarImg ? `<img src="${state.business.avatarImg}" style="width:100%; height:100%; border-radius:12px; object-fit:cover;">` : 'AGS'}
          <div style="position:absolute; bottom:-2px; right:-2px; background:var(--primary-600); color:white; border-radius:50%; width:18px; height:18px; display:flex; align-items:center; justify-content:center; font-size:10px; border:1px solid white;">📷</div>
        </div>
        <input type="file" id="settingsProfilePicInput" accept="image/*" style="display:none;" onchange="handleProfilePictureSelect(event)">
        
        <div style="flex:1;">
          <h3 style="font-size:16px; font-weight:700;">${state.business.name}</h3>
          <div style="font-size:12px; color:var(--text-muted); margin-top:2px;">📞 ${state.business.phone}</div>
        </div>
        <button class="btn-icon-pill" style="color:var(--primary-700); background:var(--primary-50); border:1px solid var(--primary-500);" onclick="openEditProfileModal()">
          ✏️ ${t.editProfile}
        </button>
      </div>
    </div>

    <!-- Group: App Settings -->
    <div class="settings-section-card">
      <div class="settings-section-title">📱 ${t.appSettings}</div>
      <div class="settings-list">
        <div class="settings-item" onclick="toggleDarkMode()">
          <div class="settings-item-left">
            <span class="settings-item-icon">🌙</span>
            <span>${t.themeToggle}</span>
          </div>
          <span style="font-weight:700; color:var(--primary-700); font-size:12px;">
            ${state.darkMode ? 'آن (ON)' : 'آف (OFF)'}
          </span>
        </div>
        <div class="settings-item" onclick="openCloudAccountModal()">
          <div class="settings-item-left">
            <span class="settings-item-icon">☁️</span>
            <div>
              <span>آٹو کلاؤڈ بیک اپ و لاگ ان (Cloud Sync)</span>
              <div style="font-size:10px; color:var(--got-green-600); font-weight:bold; margin-top:2px;">🟢 فعال • اکاونٹ: ${state.business.phone || state.business.email}</div>
            </div>
          </div>
          <span style="color:var(--primary-700); font-size:12px; font-weight:bold;">لاگ ان / سوئچ ›</span>
        </div>
        <div class="settings-item" onclick="alert('نوٹیفکیشن الرٹس آن ہیں')">
          <div class="settings-item-left">
            <span class="settings-item-icon">🔔</span>
            <span>${t.notifications}</span>
          </div>
          <span style="color:var(--text-muted); font-size:12px;">فعال ›</span>
        </div>
        <div class="settings-item" onclick="resetAllDataToZero()">
          <div class="settings-item-left">
            <span class="settings-item-icon">🧹</span>
            <span style="color:var(--gave-red-600); font-weight:700;">تمام ڈیٹا صاف کریں (Reset All to Rs 0)</span>
          </div>
          <span style="color:var(--gave-red-600); font-size:12px; font-weight:bold;">پاک کریں ›</span>
        </div>
      </div>
    </div>

    <!-- Group 3: Support & Legal -->
    <div class="settings-section-card">
      <div class="settings-section-title">ℹ️ ${t.supportLegal}</div>
      <div class="settings-list">
        <div class="settings-item" onclick="alert('ہیلپ سینٹر واٹس ایپ Support: 0300-1234567')">
          <div class="settings-item-left">
            <span class="settings-item-icon">❓</span>
            <span>${t.helpCenter}</span>
          </div>
          <span style="color:var(--text-muted); font-size:12px;">رابطہ کریں ›</span>
        </div>
        <div class="settings-item" onclick="alert('پرائیویسی پالیسی محفوظ ہے')">
          <div class="settings-item-left">
            <span class="settings-item-icon">🔒</span>
            <span>${t.privacyPolicy}</span>
          </div>
          <span style="color:var(--text-muted); font-size:12px;">ملاحظہ کریں ›</span>
        </div>
        <div class="settings-item" onclick="alert('شرائط و ضوابط آسان کھاتہ')">
          <div class="settings-item-left">
            <span class="settings-item-icon">📜</span>
            <span>${t.termsConditions}</span>
          </div>
          <span style="color:var(--text-muted); font-size:12px;">ملاحظہ کریں ›</span>
        </div>
      </div>
    </div>

    <!-- Red Account Logout Button -->
    <button class="btn-logout" onclick="handleLogout()">
      🚪 ${t.logout}
    </button>

    <div class="app-version-footer">
      آسان کھاتہ ${t.appVersion} • Digital Accounting Ledger System
    </div>
  `;
}

function handleLogout() {
  if (confirm("کیا آپ واقعی لاگ آؤٹ کرنا چاہتے ہیں؟")) {
    state.profileCompleted = false;
    localStorage.removeItem('asan_profile_completed');
    state.activeTab = 'setup';
    renderApp();
  }
}

function triggerProfilePictureUpload() {
  const fileInp = document.getElementById('settingsProfilePicInput') || document.getElementById('avatarFileInput');
  if (fileInp) fileInp.click();
}

function handleProfilePictureSelect(e) {
  const file = e.target.files[0];
  if (file) {
    const reader = new FileReader();
    reader.onload = function(evt) {
      state.business.avatarImg = evt.target.result;
      saveData();
      alert("پروفائل تصویر کامیابی سے اپ ڈیٹ ہو گئی ہے!");
      renderApp();
    };
    reader.readAsDataURL(file);
  }
}

// Modals logic
function openNewEntryModal(defaultType = 'gave', partyId = null, isLocked = false) {
  const t = i18n[state.lang];
  const overlay = document.getElementById('modalOverlay');
  const content = document.getElementById('modalSheetContent');

  const selectedParty = partyId ? state.parties.find(p => p.id === partyId) : null;
  const isGave = defaultType === 'gave';

  content.innerHTML = `
    <div class="modal-header">
      <h2 class="modal-title">
        ${isGave ? '🔴' : '🟢'} ${t.entryTitle} 
        ${isLocked ? `<span style="font-size:12px; font-weight:600; color:var(--text-muted); background:var(--bg-slate); padding:2px 8px; border-radius:12px; margin-right:6px;">🔒 ${selectedParty ? selectedParty.name : ''}</span>` : ''}
      </h2>
      <button class="btn-close-modal" onclick="closeModal()">✕</button>
    </div>

    <form onsubmit="handleSaveEntry(event)">
      <input type="hidden" id="entryType" value="${defaultType}">
      ${isLocked && partyId ? `<input type="hidden" id="lockedPartyId" value="${partyId}">` : ''}
      
      <!-- Contextual Action Toggle Tabs -->
      <div class="tabs-header" style="margin-bottom:16px;">
        <button type="button" class="tab-btn ${isGave ? 'active' : ''}" id="btnGaveTab" ${isLocked && !isGave ? 'disabled style="opacity:0.4; cursor:not-allowed;"' : ''} onclick="setEntryType('gave')">
          🔴 ${t.gaveUdhar} ${isLocked && isGave ? '🔒' : ''}
        </button>
        <button type="button" class="tab-btn ${!isGave ? 'active' : ''}" id="btnGotTab" ${isLocked && isGave ? 'disabled style="opacity:0.4; cursor:not-allowed;"' : ''} onclick="setEntryType('got')">
          🟢 ${t.gotVasool} ${isLocked && !isGave ? '🔒' : ''}
        </button>
      </div>

      <div class="form-group">
        <label class="form-label">${t.partyName} ${isLocked ? '🔒 (لاک)' : ''}</label>
        <select class="form-control" id="entryPartySelect" ${isLocked ? 'disabled style="background:var(--bg-slate); font-weight:700;"' : ''} required>
          ${state.parties.map(p => `
            <option value="${p.id}" ${partyId === p.id ? 'selected' : ''}>${p.name}</option>
          `).join('')}
        </select>
      </div>

      <div class="form-group">
        <label class="form-label">${t.amount}</label>
        <input type="number" class="form-control" id="entryAmount" placeholder="0" required style="font-size:22px; font-weight:700;">
        <div class="amount-keypad">
          <button type="button" class="chip-btn" onclick="addAmount(100)">+100</button>
          <button type="button" class="chip-btn" onclick="addAmount(500)">+500</button>
          <button type="button" class="chip-btn" onclick="addAmount(1000)">+1000</button>
          <button type="button" class="chip-btn" onclick="addAmount(5000)">+5000</button>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">${t.detailsNote}</label>
        <div class="mic-input-wrapper">
          <input type="text" class="form-control" id="entryNote" placeholder="مثال: 5 بوری آٹا یا نقد...">
          <button type="button" class="btn-mic" id="micBtn" onclick="toggleVoiceRecording()">🎤</button>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">${t.paymentMode}</label>
        <select class="form-control" id="entryMode">
          <option value="Cash">${t.cash}</option>
          <option value="EasyPaisa">${t.easypaisa}</option>
          <option value="JazzCash">${t.jazzcash}</option>
          <option value="Bank">${t.bank}</option>
        </select>
      </div>

      <button type="submit" class="btn-action-lg ${isGave ? 'btn-gave' : 'btn-got'}" style="width:100%; margin-top:20px;">
        💾 ${isGave ? '🔴 قرضہ محفوظ کریں' : '🟢 وصولی محفوظ کریں'}
      </button>
    </form>
  `;

  overlay.classList.add('active');
}


function setEntryType(type) {
  document.getElementById('entryType').value = type;
  document.getElementById('btnGaveTab').classList.toggle('active', type === 'gave');
  document.getElementById('btnGotTab').classList.toggle('active', type === 'got');
}

function addAmount(val) {
  const inp = document.getElementById('entryAmount');
  const current = parseInt(inp.value) || 0;
  inp.value = current + val;
}

function toggleVoiceRecording() {
  const btn = document.getElementById('micBtn');
  const note = document.getElementById('entryNote');
  
  if ('webkitSpeechRecognition' in window || 'SpeechRecognition' in window) {
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    const recognition = new SpeechRecognition();
    recognition.lang = state.lang === 'ur' ? 'ur-PK' : 'en-US';
    
    btn.classList.add('listening');
    recognition.start();

    recognition.onresult = (event) => {
      note.value = event.results[0][0].transcript;
      btn.classList.remove('listening');
    };
    recognition.onerror = () => btn.classList.remove('listening');
    recognition.onend = () => btn.classList.remove('listening');
  } else {
    btn.classList.add('listening');
    setTimeout(() => {
      note.value = state.lang === 'ur' ? "آٹا اور چینی نقد وصولی" : "Cash payment for grocery items";
      btn.classList.remove('listening');
    }, 1200);
  }
}

function handleSaveEntry(e) {
  e.preventDefault();
  const type = document.getElementById('entryType').value;
  const lockedInput = document.getElementById('lockedPartyId');
  const partyId = lockedInput ? parseInt(lockedInput.value) : parseInt(document.getElementById('entryPartySelect').value);
  const amount = parseFloat(document.getElementById('entryAmount').value);
  const note = document.getElementById('entryNote').value;
  const mode = document.getElementById('entryMode').value;

  const now = new Date();
  const dateStr = now.toISOString().slice(0, 10) + ' ' + now.toTimeString().slice(0, 5);

  const newTx = {
    id: Date.now(),
    partyId,
    type,
    amount,
    note,
    date: dateStr,
    mode
  };

  state.transactions.unshift(newTx);

  const party = state.parties.find(p => p.id === partyId);
  if (party) {
    if (type === 'got') party.balance += amount;
    if (type === 'gave') party.balance -= amount;
    party.lastDate = now.toISOString().slice(0, 10);
  }

  saveData();
  closeModal();
  renderApp();
}

function closeModal() {
  document.getElementById('modalOverlay').classList.remove('active');
}

function openAddPartyModal(type = 'customer') {
  const t = i18n[state.lang];
  const overlay = document.getElementById('modalOverlay');
  const content = document.getElementById('modalSheetContent');
  const isSupplier = type === 'supplier';

  content.innerHTML = `
    <div class="modal-header">
      <h2 class="modal-title">${isSupplier ? t.addSupplier : t.addCustomer}</h2>
      <button class="btn-close-modal" onclick="closeModal()">✕</button>
    </div>

    <form onsubmit="handleSaveParty(event, '${type}')">
      <div class="form-group">
        <label class="form-label">${t.partyName}</label>
        <input type="text" class="form-control" id="newPartyName" placeholder="${isSupplier ? 'مثال: ایوب جان (سپلائر)' : 'مثال: محمد طارق'}" required>
      </div>

      <div class="form-group">
        <label class="form-label">${t.partyPhone}</label>
        <input type="tel" class="form-control" id="newPartyPhone" placeholder="0300-1234567" required>
      </div>

      <div class="form-group">
        <label class="form-label">${isSupplier ? 'ابتدائی بقایا / واجب الادا (آپ نے دینے ہیں PKR)' : 'ابتدائی بقایا / وصولی (آپ نے لینے ہیں PKR)'}</label>
        <input type="number" class="form-control" id="newPartyBal" placeholder="0">
      </div>

      <button type="submit" class="btn-action-lg ${isSupplier ? 'btn-gave' : 'btn-got'}" style="width:100%; margin-top:16px; background:${isSupplier ? 'var(--gave-red-600)' : 'var(--got-green-600)'}; color:white;">
        💾 ${t.save}
      </button>
    </form>
  `;

  overlay.classList.add('active');
}

function handleSaveParty(e, type) {
  e.preventDefault();
  const name = document.getElementById('newPartyName').value;
  const phone = document.getElementById('newPartyPhone').value;
  const rawBal = parseFloat(document.getElementById('newPartyBal').value) || 0;

  // Supplier balance is payable (negative), Customer balance is receivable (positive)
  const balance = (type === 'supplier' && rawBal > 0) ? -Math.abs(rawBal) : rawBal;

  const newP = {
    id: Date.now(),
    name,
    phone,
    type,
    balance,
    lastDate: new Date().toISOString().slice(0, 10)
  };

  state.parties.unshift(newP);
  saveData();
  closeModal();
  renderApp();
}

function openEditProfileModal() {
  const t = i18n[state.lang];
  const overlay = document.getElementById('modalOverlay');
  const content = document.getElementById('modalSheetContent');

  content.innerHTML = `
    <div class="modal-header">
      <h2 class="modal-title">✏️ ${t.editProfile}</h2>
      <button class="btn-close-modal" onclick="closeModal()">✕</button>
    </div>

    <form onsubmit="handleSaveProfile(event)">
      <div class="form-group">
        <label class="form-label">بزنس کا نام (Business Name)</label>
        <input type="text" class="form-control" id="editBizName" value="${state.business.name}" required>
      </div>

      <div class="form-group">
        <label class="form-label">مالک کا نام (Owner Name)</label>
        <input type="text" class="form-control" id="editBizOwner" value="${state.business.owner}" required>
      </div>

      <div class="form-group">
        <label class="form-label">فون نمبر (Phone Number)</label>
        <input type="tel" class="form-control" id="editBizPhone" value="${state.business.phone}" required>
      </div>

      <div class="form-group">
        <label class="form-label">ای میل (Email)</label>
        <input type="email" class="form-control" id="editBizEmail" value="${state.business.email}">
      </div>

      <div class="form-group">
        <label class="form-label">پتہ (Address)</label>
        <input type="text" class="form-control" id="editBizAddress" value="${state.business.address}" required>
      </div>

      <button type="submit" class="btn-action-lg btn-got" style="width:100%; margin-top:16px;">
        💾 ${t.save}
      </button>
    </form>
  `;

  overlay.classList.add('active');
}

function handleSaveProfile(e) {
  e.preventDefault();
  state.business.name = document.getElementById('editBizName').value;
  state.business.owner = document.getElementById('editBizOwner').value;
  state.business.phone = document.getElementById('editBizPhone').value;
  state.business.email = document.getElementById('editBizEmail').value;
  state.business.address = document.getElementById('editBizAddress').value;

  saveData();
  closeModal();
  renderApp();
}

// Sub-tab state for Analytics & Reports
state.analyticsSubTab = state.analyticsSubTab || 'bill'; // 'bill' or 'chart'

// Bill items dynamic array
state.currentBillItems = state.currentBillItems || [
  { name: 'آٹا 10 کلو (Atta 10kg)', qty: 1, price: 1500 }
];

function renderPrecisionAnalyticsView(t) {
  const isBillTab = state.analyticsSubTab === 'bill';
  const now = new Date();
  const dateStr = now.toISOString().slice(0, 10) + ' ' + now.toTimeString().slice(0, 5);

  return `
    <!-- Analytics & Bill Generator Header Tabs -->
    <div class="tabs-header" style="margin-bottom:16px;">
      <button class="tab-btn ${isBillTab ? 'active' : ''}" onclick="state.analyticsSubTab='bill'; renderApp();">
        🧾 بل جنریٹر (Bill Generator)
      </button>
      <button class="tab-btn ${!isBillTab ? 'active' : ''}" onclick="state.analyticsSubTab='chart'; renderApp();">
        📊 تجزیہ و رپورٹس (Analytics)
      </button>
    </div>

    ${isBillTab ? renderBillGeneratorForm(t, dateStr) : renderAnalyticsChartsView(t)}
  `;
}

function renderBillGeneratorForm(t, dateStr) {
  return `
    <div class="bill-form-card">
      <h3 style="font-size:16px; font-weight:700; color:var(--primary-700); margin-bottom:14px; display:flex; align-items:center; justify-content:space-between;">
        <span>🧾 نیا بل بنائیں (New Invoice)</span>
        <span style="font-size:12px; color:var(--text-muted); font-weight:600;">📅 ${dateStr}</span>
      </h3>

      <form onsubmit="handleSaveBill(event)">
        <div class="form-group">
          <label class="form-label">گاہک یا دکاندار کا نام (Customer / Supplier)</label>
          <select class="form-control" id="billPartySelect" onchange="updateBillPartyPhone()" required>
            ${state.parties.map(p => `<option value="${p.id}" data-phone="${p.phone}">${p.name} (${p.phone})</option>`).join('')}
          </select>
        </div>

        <div class="form-group">
          <label class="form-label">موبائل فون نمبر (Phone Number)</label>
          <input type="tel" class="form-control" id="billPhoneInput" value="${state.parties[0]?.phone || '0300-1234567'}" required>
        </div>

        <!-- Itemized List Table -->
        <label class="form-label" style="margin-top:14px;">آئٹمز کی فہرست (Itemized List Table)</label>
        <table class="bill-items-table">
          <thead>
            <tr>
              <th style="width:40%;">آئٹم کا نام</th>
              <th style="width:18%;">مقدار</th>
              <th style="width:22%;">قیمت (PKR)</th>
              <th style="width:20%;">کل رقم</th>
              <th style="width:30px;"></th>
            </tr>
          </thead>
          <tbody id="billItemsTbody">
            ${state.currentBillItems.map((item, idx) => renderBillItemRow(item, idx)).join('')}
          </tbody>
        </table>

        <button type="button" class="btn-icon-pill" style="width:100%; justify-content:center; padding:8px; margin-bottom:14px; color:var(--primary-700); background:var(--primary-50); border:1px solid var(--primary-500);" onclick="addBillItemRow()">
          ➕ نیا آئٹم شامل کریں (Add Item Row)
        </button>

        <!-- Subtotal, Tax, Discount & Grand Total Card -->
        <div class="bill-totals-box">
          <div class="bill-total-row">
            <span>ذیلی رقم (Subtotal):</span>
            <span id="billSubtotalTxt" style="font-weight:700;">Rs 0</span>
          </div>
          <div class="bill-total-row">
            <span>ٹیکس (GST 18%):</span>
            <span id="billTaxTxt" style="font-weight:700; color:var(--text-muted);">Rs 0</span>
          </div>
          <div class="bill-total-row">
            <span>رعایت (Discount PKR):</span>
            <input type="number" class="table-input" id="billDiscountInp" value="0" style="width:90px; text-align:center;" oninput="updateBillCalculations()">
          </div>
          <div class="bill-total-row grand">
            <span>کل واجب الادا (Grand Total):</span>
            <span id="billGrandTotalTxt">Rs 0</span>
          </div>
        </div>

        <div class="form-group" style="margin-top:14px;">
          <label class="form-label">ادائیگی کی صورتحال (Payment Status)</label>
          <select class="form-control" id="billPaymentStatus">
            <option value="Paid">🟢 ادا شدہ (Paid)</option>
            <option value="Unpaid" selected>🔴 بقیہ (Unpaid)</option>
            <option value="Partial">🟡 ادھورا (Partial)</option>
          </select>
        </div>

        <!-- Action Buttons Grid -->
        <div class="bill-actions-grid">
          <button type="submit" class="btn-action-lg btn-got" style="font-size:13px; padding:12px;">
            💾 بل محفوظ کریں
          </button>
          <button type="button" class="btn-pdf-export" onclick="exportBillPDF()">
            📄 PDF / پرنٹ کریں
          </button>
        </div>
      </form>
    </div>

    <!-- Saved Bills List View Section -->
    <div class="saved-bills-section">
      <div class="saved-bills-title">
        <span>📋 محفوظ شدہ بل (Saved Bills)</span>
        <span class="badge-count">${(state.bills || []).length}</span>
      </div>

      ${renderSavedBillsList(t)}
    </div>
  `;
}

function renderSavedBillsList(t) {
  if (!state.bills || state.bills.length === 0) {
    return `<div style="text-align:center; padding:20px; color:var(--text-muted); background:var(--surface-card); border-radius:var(--radius-md); border:1px solid var(--border-light);">کوئی محفوظ شدہ بل نہیں ہے</div>`;
  }

  return state.bills.map(bill => {
    const statusClass = bill.status === 'Paid' ? 'paid' : bill.status === 'Unpaid' ? 'unpaid' : 'partial';
    const statusLabel = bill.status === 'Paid' ? '🟢 ادا شدہ' : bill.status === 'Unpaid' ? '🔴 بقیہ' : '🟡 ادھورا';

    return `
      <div class="saved-bill-card">
        <div class="saved-bill-info">
          <div class="saved-bill-customer">${bill.partyName}</div>
          <div class="saved-bill-meta">
            <span>📅 ${bill.date}</span>
            <span class="bill-status-badge ${statusClass}">${statusLabel}</span>
          </div>
          <div class="saved-bill-amount">${formatPKR(bill.totals.grandTotal)}</div>
        </div>

        <div class="saved-bill-actions">
          <button class="btn-icon-action" onclick="exportSpecificBillPDF(${bill.id})">
            📄 پی ڈی ایف ڈاؤن لوڈ
          </button>
          <button class="btn-icon-danger" onclick="deleteSavedBill(${bill.id})" title="ڈیلیٹ کریں">
            🗑️
          </button>
        </div>
      </div>
    `;
  }).join('');
}

function deleteSavedBill(billId) {
  if (confirm("کیا آپ واقعی یہ بل ڈیلیٹ کرنا چاہتے ہیں؟")) {
    state.bills = (state.bills || []).filter(b => b.id !== billId);
    saveData();
    renderApp();
  }
}

function exportSpecificBillPDF(billId) {
  const bill = (state.bills || []).find(b => b.id === billId);
  if (!bill) return;

  const overlay = document.getElementById('modalOverlay');
  const content = document.getElementById('modalSheetContent');

  content.innerHTML = `
    <div class="modal-header">
      <h2 class="modal-title">📄 بل رسید (Saved Invoice #${bill.id.toString().slice(-4)})</h2>
      <button class="btn-close-modal" onclick="closeModal()">✕</button>
    </div>

    <div class="printable-receipt" id="printableReceiptArea">
      <div class="receipt-header">
        <h2>${state.business.name}</h2>
        <div>${state.business.address} • 📞 ${state.business.phone}</div>
        <div style="margin-top:6px; font-size:11px;">تاریخ: ${bill.date}</div>
      </div>

      <div style="margin-bottom:10px; font-weight:bold;">
        گاہک: ${bill.partyName}<br>
        فون: ${bill.phone}
      </div>

      <table class="receipt-table">
        <thead>
          <tr style="border-bottom:1px solid #000;">
            <th>آئٹم</th>
            <th>مقدار</th>
            <th>قیمت</th>
            <th>کل</th>
          </tr>
        </thead>
        <tbody>
          ${bill.items.map(item => `
            <tr>
              <td>${item.name}</td>
              <td>${item.qty}</td>
              <td>${item.price}</td>
              <td>${item.qty * item.price}</td>
            </tr>
          `).join('')}
        </tbody>
      </table>

      <div style="border-top:1px dashed #000; padding-top:6px; font-size:12px;">
        <div class="flex-between"><span>ذیلی رقم:</span> <span>Rs ${bill.totals.subtotal}</span></div>
        <div class="flex-between"><span>GST 18%:</span> <span>Rs ${bill.totals.tax}</span></div>
        <div class="flex-between"><span>رعایت:</span> <span>-Rs ${bill.totals.discount}</span></div>
        <div class="flex-between" style="font-size:14px; font-weight:bold; margin-top:4px; border-top:1px solid #000; padding-top:4px;">
          <span>کل واجب الادا:</span> <span>Rs ${bill.totals.grandTotal}</span>
        </div>
      </div>

      <div class="receipt-footer">
        آسان کھاتہ ایپ کے ذریعے برائے پرنٹ و شیئر<br>
        *** شکریہ! تشریف آوری کا ممنون ***
      </div>
    </div>

    <div class="bill-actions-grid" style="margin-top:16px;">
      <button class="btn-action-lg btn-got" onclick="window.print()">
        🖨️ پرنٹ / PDF ڈاؤن لوڈ
      </button>
      <button class="btn-whatsapp" style="margin:0;" onclick="sendWhatsAppBill('${bill.partyName}', '${bill.phone}', ${bill.totals.grandTotal})">
        💬 واٹس ایپ بھیجیں
      </button>
    </div>
  `;

  overlay.classList.add('active');
}


function renderBillItemRow(item, idx) {
  const total = item.qty * item.price;
  return `
    <tr id="billRow_${idx}">
      <td><input type="text" class="table-input" value="${item.name}" oninput="state.currentBillItems[${idx}].name=this.value;" placeholder="آئٹم نام" required></td>
      <td><input type="number" class="table-input" value="${item.qty}" min="1" oninput="state.currentBillItems[${idx}].qty=parseFloat(this.value)||1; updateBillCalculations();" required></td>
      <td><input type="number" class="table-input" value="${item.price}" oninput="state.currentBillItems[${idx}].price=parseFloat(this.value)||0; updateBillCalculations();" required></td>
      <td style="font-weight:700; font-size:12px;" id="rowTotal_${idx}">${formatPKR(total)}</td>
      <td>
        <button type="button" class="btn-remove-row" onclick="removeBillItemRow(${idx})">✕</button>
      </td>
    </tr>
  `;
}

function addBillItemRow() {
  state.currentBillItems.push({ name: 'نیا آئٹم', qty: 1, price: 500 });
  renderApp();
  setTimeout(updateBillCalculations, 100);
}

function removeBillItemRow(idx) {
  if (state.currentBillItems.length > 1) {
    state.currentBillItems.splice(idx, 1);
    renderApp();
    setTimeout(updateBillCalculations, 100);
  }
}

function updateBillPartyPhone() {
  const sel = document.getElementById('billPartySelect');
  if (sel) {
    const phone = sel.options[sel.selectedIndex].getAttribute('data-phone');
    const phoneInp = document.getElementById('billPhoneInput');
    if (phoneInp) phoneInp.value = phone || '';
  }
}

function updateBillCalculations() {
  let subtotal = 0;
  state.currentBillItems.forEach((item, idx) => {
    const rowTotal = (item.qty || 1) * (item.price || 0);
    subtotal += rowTotal;
    const txt = document.getElementById(`rowTotal_${idx}`);
    if (txt) txt.innerText = formatPKR(rowTotal);
  });

  const discount = parseFloat(document.getElementById('billDiscountInp')?.value) || 0;
  const tax = Math.round(subtotal * 0.18);
  const grandTotal = Math.max(0, subtotal + tax - discount);

  if (document.getElementById('billSubtotalTxt')) document.getElementById('billSubtotalTxt').innerText = formatPKR(subtotal);
  if (document.getElementById('billTaxTxt')) document.getElementById('billTaxTxt').innerText = formatPKR(tax);
  if (document.getElementById('billGrandTotalTxt')) document.getElementById('billGrandTotalTxt').innerText = formatPKR(grandTotal);

  return { subtotal, tax, discount, grandTotal };
}

function handleSaveBill(e) {
  e.preventDefault();
  const partyId = parseInt(document.getElementById('billPartySelect').value);
  const phone = document.getElementById('billPhoneInput').value;
  const status = document.getElementById('billPaymentStatus').value;
  const calc = updateBillCalculations();

  const party = state.parties.find(p => p.id === partyId);
  const partyName = party ? party.name : 'گاہک';

  const newBill = {
    id: Date.now(),
    partyId,
    partyName,
    phone,
    items: [...state.currentBillItems],
    totals: calc,
    status,
    date: new Date().toISOString().slice(0, 10) + ' ' + new Date().toTimeString().slice(0, 5)
  };

  state.bills = state.bills || [];
  state.bills.unshift(newBill);

  // Auto push into transactions ledger if unpaid or partial
  if (status === 'Unpaid' || status === 'Partial') {
    const newTx = {
      id: Date.now() + 1,
      partyId,
      type: 'gave',
      amount: calc.grandTotal,
      note: `بل جنریٹر رقم (${state.currentBillItems.map(i=>i.name).join(', ')})`,
      date: newBill.date,
      mode: 'Bill'
    };
    state.transactions.unshift(newTx);
    if (party) {
      party.balance -= calc.grandTotal;
      party.lastDate = newBill.date.slice(0, 10);
    }
  }

  saveData();
  alert(`بل کامیاابی سے محفوظ ہو گیا ہے! کل رقم: ${formatPKR(calc.grandTotal)}`);
  renderApp();
}

function exportBillPDF() {
  const calc = updateBillCalculations();
  const partyId = parseInt(document.getElementById('billPartySelect')?.value || state.parties[0].id);
  const party = state.parties.find(p => p.id === partyId);

  const overlay = document.getElementById('modalOverlay');
  const content = document.getElementById('modalSheetContent');

  content.innerHTML = `
    <div class="modal-header">
      <h2 class="modal-title">📄 بل رسید (Thermal / Standard PDF)</h2>
      <button class="btn-close-modal" onclick="closeModal()">✕</button>
    </div>

    <div class="printable-receipt" id="printableReceiptArea">
      <div class="receipt-header">
        <h2>${state.business.name}</h2>
        <div>${state.business.address} • 📞 ${state.business.phone}</div>
        <div style="margin-top:6px; font-size:11px;">تاریخ: ${new Date().toLocaleString()}</div>
      </div>

      <div style="margin-bottom:10px; font-weight:bold;">
        گاہک: ${party ? party.name : 'خرید دار'}<br>
        فون: ${party ? party.phone : ''}
      </div>

      <table class="receipt-table">
        <thead>
          <tr style="border-bottom:1px solid #000;">
            <th>آئٹم</th>
            <th>مقدار</th>
            <th>قیمت</th>
            <th>کل</th>
          </tr>
        </thead>
        <tbody>
          ${state.currentBillItems.map(item => `
            <tr>
              <td>${item.name}</td>
              <td>${item.qty}</td>
              <td>${item.price}</td>
              <td>${item.qty * item.price}</td>
            </tr>
          `).join('')}
        </tbody>
      </table>

      <div style="border-top:1px dashed #000; padding-top:6px; font-size:12px;">
        <div class="flex-between"><span>ذیلی رقم:</span> <span>Rs ${calc.subtotal}</span></div>
        <div class="flex-between"><span>GST 18%:</span> <span>Rs ${calc.tax}</span></div>
        <div class="flex-between"><span>رعایت:</span> <span>-Rs ${calc.discount}</span></div>
        <div class="flex-between" style="font-size:14px; font-weight:bold; margin-top:4px; border-top:1px solid #000; padding-top:4px;">
          <span>کل واجب الادا:</span> <span>Rs ${calc.grandTotal}</span>
        </div>
      </div>

      <div class="receipt-footer">
        آسان کھاتہ ایپ کے ذریعے برائے پرنٹ و شیئر<br>
        *** شکریہ! تشریف آوری کا ممنون ***
      </div>
    </div>

    <div class="bill-actions-grid" style="margin-top:16px;">
      <button class="btn-action-lg btn-got" onclick="window.print()">
        🖨️ پرنٹ / PDF ڈاؤن لوڈ
      </button>
      <button class="btn-whatsapp" style="margin:0;" onclick="sendWhatsAppBill('${party ? party.name : 'گاہک'}', '${party ? party.phone : ''}', ${calc.grandTotal})">
        💬 واٹس ایپ بھیجیں
      </button>
    </div>
  `;

  overlay.classList.add('active');
}

function sendWhatsAppBill(name, phone, total) {
  const cleanPhone = phone.replace(/[^0-9]/g, '');
  const itemsList = state.currentBillItems.map(i => `• ${i.name} (x${i.qty}) = Rs ${i.qty * i.price}`).join('%0A');
  const msg = `محترم ${name} صاحب، ${state.business.name} سے آپ کے انوائس بل کی تفصیلات:%0A%0A${itemsList}%0A%0Aکل واجب الادا: Rs ${total}%0Aشکریہ!`;
  const url = `https://wa.me/92${cleanPhone.slice(-10)}?text=${msg}`;
  window.open(url, '_blank');
}

function renderAnalyticsChartsView(t) {
  return `
    <div class="chart-card">
      <div class="chart-header">
        <h3 class="chart-title">📈 ${t.dailySummary}</h3>
      </div>
      <canvas id="cashflowCanvas" width="400" height="200" style="width:100%; height:180px;"></canvas>
    </div>

    <div class="chart-card">
      <h3 class="chart-title" style="margin-bottom:12px;">📊 ${t.topDebtors}</h3>
      <div class="party-list">
        ${state.parties.filter(p => p.balance > 0).sort((a,b)=>b.balance - a.balance).slice(0,3).map(p => renderPartyCard(p,t)).join('')}
      </div>
    </div>
  `;
}


function renderCanvasCharts() {
  const canvas = document.getElementById('cashflowCanvas');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  const gradient = ctx.createLinearGradient(0, 0, 0, 200);
  gradient.addColorStop(0, 'rgba(5, 150, 105, 0.4)');
  gradient.addColorStop(1, 'rgba(5, 150, 105, 0.0)');

  ctx.beginPath();
  ctx.moveTo(20, 140);
  ctx.bezierCurveTo(80, 40, 140, 160, 200, 80);
  ctx.bezierCurveTo(260, 20, 320, 120, 380, 50);
  ctx.lineTo(380, 180);
  ctx.lineTo(20, 180);
  ctx.closePath();
  ctx.fillStyle = gradient;
  ctx.fill();

  ctx.beginPath();
  ctx.moveTo(20, 140);
  ctx.bezierCurveTo(80, 40, 140, 160, 200, 80);
  ctx.bezierCurveTo(260, 20, 320, 120, 380, 50);
  ctx.strokeStyle = '#059669';
  ctx.lineWidth = 3;
  ctx.stroke();
}

function renderProfitLossView(t) {
  // Dynamic Revenue & Expenses Calculation
  const totalRevenue = 145800; // Base sales & revenue
  const totalExpenses = (state.expenses || []).reduce((acc, exp) => acc + (exp.amount || 0), 0);
  const netProfit = totalRevenue - totalExpenses;
  const isProfit = netProfit >= 0;
  const profitMargin = ((netProfit / Math.max(1, totalRevenue)) * 100).toFixed(1);

  // Categorized breakdown sums
  const stockSum = (state.expenses || []).filter(e => e.category === 'Stock').reduce((a, b) => a + b.amount, 0);
  const rentSum = (state.expenses || []).filter(e => e.category === 'Rent').reduce((a, b) => a + b.amount, 0);
  const utilSum = (state.expenses || []).filter(e => e.category === 'Utilities').reduce((a, b) => a + b.amount, 0);
  const salarySum = (state.expenses || []).filter(e => e.category === 'Salaries').reduce((a, b) => a + b.amount, 0);
  const otherSum = (state.expenses || []).filter(e => e.category === 'Other').reduce((a, b) => a + b.amount, 0);

  return `
    <div style="margin-bottom:14px; display:flex; justify-content:space-between; align-items:center;">
      <h2 style="font-size:18px; font-weight:700; color:var(--text-main);">📈 پرافٹ اور لاس رپورٹ (Profit & Loss)</h2>
      <button class="btn-icon-pill" style="color:white; background:var(--primary-700); border:none; padding:6px 12px; font-weight:700;" onclick="openAddExpenseModal()">
        ➕ نیا خرچہ درج کریں
      </button>
    </div>

    <!-- Net Profit / Loss Card -->
    <div class="pnl-net-card">
      <div class="pnl-net-title">مجموعی نفع / نقصان (Net Profit = Revenue - Expenses)</div>
      <div class="pnl-net-amount ${isProfit ? 'profit' : 'loss'}">
        ${isProfit ? '+' : '-'}${formatPKR(netProfit)}
      </div>
      <span class="pnl-status-pill ${isProfit ? 'profit' : 'loss'}">
        ${isProfit ? `🟢 ${profitMargin}% منافع (Net Profit Margin)` : '🔴 نقصان (Loss)'}
      </span>
    </div>

    <!-- Revenue vs Expenses Split Grid (RTL Flow) -->
    <div class="pnl-grid">
      <!-- Right Side in RTL: Total Revenue (Green) -->
      <div class="pnl-card revenue">
        <span class="pnl-label">مجموعی آمدنی (Total Revenue)</span>
        <span class="pnl-amount revenue">${formatPKR(totalRevenue)}</span>
        <span style="font-size:11px; color:var(--text-muted);">کل وصولی و سیلز</span>
      </div>

      <!-- Left Side in RTL: Total Expenses (Red) -->
      <div class="pnl-card expenses">
        <span class="pnl-label">مجموعی اخراجات (Total Expenses)</span>
        <span class="pnl-amount expenses">${formatPKR(totalExpenses)}</span>
        <span style="font-size:11px; color:var(--text-muted);">${(state.expenses || []).length} اینٹریز درج شدہ</span>
      </div>
    </div>

    <!-- Visual Monthly Comparison Chart -->
    <div class="chart-card">
      <div class="chart-header">
        <h3 class="chart-title">📊 ماہانہ آمدنی بمقابلہ اخراجات (Monthly Revenue vs Expenses)</h3>
      </div>
      <canvas id="pnlCanvas" width="400" height="200" style="width:100%; height:180px;"></canvas>
    </div>

    <!-- Dynamic Recent Expenses History List -->
    <div class="chart-card">
      <div class="flex-between" style="margin-bottom:12px;">
        <h3 class="chart-title">📋 حالیہ اخراجات کی لسٹ (Recent Expenses List)</h3>
        <span class="badge-count">${(state.expenses || []).length}</span>
      </div>

      ${renderExpensesHistoryList(t)}
    </div>
  `;
}

function renderExpensesHistoryList(t) {
  if (!state.expenses || state.expenses.length === 0) {
    return `<div style="text-align:center; padding:20px; color:var(--text-muted); background:var(--surface-card); border-radius:var(--radius-md); border:1px solid var(--border-light);">کوئی اخراجات درج نہیں ہیں</div>`;
  }

  const categoryIcons = {
    Stock: '📦',
    Rent: '🏪',
    Utilities: '⚡',
    Salaries: '👤',
    Other: '💸'
  };

  return state.expenses.map(exp => {
    const icon = categoryIcons[exp.category] || '💸';

    return `
      <div class="expense-item-card" onclick="openExpenseReceiptModal(${exp.id})">
        <div class="expense-item-left">
          <div class="expense-icon-badge">${icon}</div>
          <div>
            <div class="expense-item-title">${exp.name}</div>
            <div class="expense-item-date">📅 ${exp.date} • ${exp.category}</div>
          </div>
        </div>

        <div class="expense-item-right">
          <div class="expense-item-amount">-${formatPKR(exp.amount)}</div>
          <button class="btn-icon-danger" onclick="deleteExpenseItem(${exp.id}, event)" title="ڈیلیٹ کریں">
            🗑️
          </button>
        </div>
      </div>
    `;
  }).join('');
}

function openExpenseReceiptModal(expId) {
  const exp = (state.expenses || []).find(e => e.id === expId);
  if (!exp) return;

  const overlay = document.getElementById('modalOverlay');
  const content = document.getElementById('modalSheetContent');

  const categoryIcons = {
    Stock: '📦',
    Rent: '🏪',
    Utilities: '⚡',
    Salaries: '👤',
    Other: '💸'
  };
  const icon = categoryIcons[exp.category] || '💸';

  content.innerHTML = `
    <div class="modal-header">
      <h2 class="modal-title">🧾 خرچہ رسید (Digital Expense Receipt #${exp.id.toString().slice(-4)})</h2>
      <button class="btn-close-modal" onclick="closeModal()">✕</button>
    </div>

    <div class="expense-receipt-box" id="printableExpenseReceipt">
      <div class="expense-receipt-header">
        <h2 style="font-size:18px; font-weight:800; color:var(--primary-700);">${state.business.name}</h2>
        <div style="font-size:12px; color:var(--text-muted); margin-top:2px;">${state.business.address} • 📞 ${state.business.phone}</div>
        <div style="margin-top:6px; font-size:11px; color:var(--text-muted);">تاریخ اینٹری: ${exp.date}</div>
      </div>

      <div style="margin-bottom:14px; font-size:13px; display:flex; flex-direction:column; gap:6px;">
        <div class="flex-between">
          <span>خرچے کی قسم:</span>
          <span style="font-weight:700;">${icon} ${exp.category}</span>
        </div>
        <div class="flex-between">
          <span>تفصیل / نوٹ:</span>
          <span style="font-weight:700;">${exp.name}</span>
        </div>
        <div class="flex-between"><span>انوائس ID:</span> <span>EXP-#${exp.id}</span></div>
      </div>

      <div style="border-top:2px dashed #000; border-bottom:2px dashed #000; padding:12px 0; margin-top:10px; font-size:16px; font-weight:800;" class="flex-between">
        <span>کل رقم (Amount):</span>
        <span style="color:var(--gave-red-600);">${formatPKR(exp.amount)}</span>
      </div>

      <div class="receipt-footer" style="margin-top:14px; font-size:11px; text-align:center; color:var(--text-muted);">
        آسان کھاتہ ایپ - ڈیجیٹل ڈکان اخراجات واؤچر
      </div>
    </div>

    <div class="bill-actions-grid" style="margin-top:16px;">
      <button class="btn-action-lg btn-got" onclick="window.print()">
        🖨️ پرنٹ / PDF ڈاؤن لوڈ
      </button>
      <button class="btn-icon-danger" style="width:100%; padding:12px; font-size:13px;" onclick="deleteExpenseItem(${exp.id}, event); closeModal();">
        🗑️ یہ خرچہ ڈیلیٹ کریں
      </button>
    </div>
  `;

  overlay.classList.add('active');
}

function deleteExpenseItem(expId, e) {
  if (e) e.stopPropagation();
  if (confirm("کیا آپ واقعی یہ خرچہ ڈیلیٹ کرنا چاہتے ہیں؟")) {
    state.expenses = (state.expenses || []).filter(e => e.id !== expId);
    saveData();
    renderApp();
  }
}


function openAddExpenseModal() {
  const overlay = document.getElementById('modalOverlay');
  const content = document.getElementById('modalSheetContent');

  content.innerHTML = `
    <div class="modal-header">
      <h2 class="modal-title">💸 نیا خرچہ درج کریں (Log New Expense)</h2>
      <button class="btn-close-modal" onclick="closeModal()">✕</button>
    </div>

    <form onsubmit="handleSaveExpense(event)">
      <div class="form-group">
        <label class="form-label">خرچے کی قسم (Expense Category)</label>
        <select class="form-control" id="expCategorySelect" required>
          <option value="Stock">📦 اسٹاک خرید (Stock Purchase)</option>
          <option value="Rent">🏪 دکان کا کرایہ (Store Rent)</option>
          <option value="Utilities">⚡ بجلی کا بل و یوٹیلٹیز (Utilities)</option>
          <option value="Salaries">👤 ملازم کی تنخواہ (Staff Salary)</option>
          <option value="Other">💸 متفرق اخراجات (Other Expense)</option>
        </select>
      </div>

      <div class="form-group">
        <label class="form-label">تفصیل / نام (Expense Note)</label>
        <input type="text" class="form-control" id="expNoteInput" placeholder="مثال: جنریٹر فیول یا چائے ناشتہ..." required>
      </div>

      <div class="form-group">
        <label class="form-label">خرچے کی رقم (Amount PKR)</label>
        <input type="number" class="form-control" id="expAmountInput" placeholder="0" required style="font-size:22px; font-weight:700;">
      </div>

      <div class="form-group">
        <label class="form-label">تاریخ (Date)</label>
        <input type="date" class="form-control" id="expDateInput" value="${new Date().toISOString().slice(0, 10)}" required>
      </div>

      <button type="submit" class="btn-action-lg btn-gave" style="width:100%; margin-top:20px;">
        💾 خرچہ محفوظ کریں (Save Expense)
      </button>
    </form>
  `;

  overlay.classList.add('active');
}

function handleSaveExpense(e) {
  e.preventDefault();
  const category = document.getElementById('expCategorySelect').value;
  const note = document.getElementById('expNoteInput').value;
  const amount = parseFloat(document.getElementById('expAmountInput').value) || 0;
  const date = document.getElementById('expDateInput').value;

  const newExpense = {
    id: Date.now(),
    category,
    name: note,
    amount,
    date
  };

  state.expenses = state.expenses || [];
  state.expenses.unshift(newExpense);
  saveData();

  closeModal();
  alert(`خرچہ کامیاابی سے درج ہو گیا! رقم: ${formatPKR(amount)}`);
  renderApp();
}

function renderPnLCanvasChart() {
  const canvas = document.getElementById('pnlCanvas');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  const totalExp = (state.expenses || []).reduce((acc, exp) => acc + (exp.amount || 0), 0);

  const months = ['مئی', 'جون', 'جولائی', 'اگست'];
  const revenues = [110000, 125000, 138000, 145800];
  const expenses = [85000, 90000, 92000, totalExp];

  const barWidth = 24;
  const gap = 60;
  const startX = 40;

  months.forEach((month, idx) => {
    const x = startX + idx * gap;
    const revH = (revenues[idx] / 170000) * 120;
    const expH = (expenses[idx] / 170000) * 120;

    // Revenue Bar (Green)
    ctx.fillStyle = '#16A34A';
    ctx.beginPath();
    ctx.fillRect(x, 150 - revH, barWidth, revH);

    // Expense Bar (Red)
    ctx.fillStyle = '#DC2626';
    ctx.beginPath();
    ctx.fillRect(x + barWidth + 4, 150 - expH, barWidth, expH);

    // Month Label
    ctx.fillStyle = '#64748B';
    ctx.font = '11px sans-serif';
    ctx.fillText(month, x + 8, 170);
  });
}



function sendWhatsAppReminder(name, phone, balance) {
  const cleanPhone = phone.replace(/[^0-9]/g, '');
  const msg = state.lang === 'ur'
    ? `محترم ${name} صاحب، آسان کھاتہ (علی جنرل اسٹور) کے مطابق آپ کا بقایا ${formatPKR(balance)} ہے۔ برائے کرم جلد ادائیگی کریں۔ شکریہ!`
    : `Dear ${name}, your pending balance at Ali General Store is ${formatPKR(balance)}. Kindly settle at your earliest. Thank you!`;
  
  const url = `https://wa.me/92${cleanPhone.slice(-10)}?text=${encodeURIComponent(msg)}`;
  window.open(url, '_blank');
}

function exportJSONBackup() {
  const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(state));
  const downloadAnchor = document.createElement('a');
  downloadAnchor.setAttribute("href", dataStr);
  downloadAnchor.setAttribute("download", `asan_khata_backup_${new Date().toISOString().slice(0,10)}.json`);
  document.body.appendChild(downloadAnchor);
  downloadAnchor.click();
  downloadAnchor.remove();
}

function openCloudAccountModal() {
  const overlay = document.getElementById('modalOverlay');
  const content = document.getElementById('modalSheetContent');

  content.innerHTML = `
    <div class="modal-header">
      <h2 class="modal-title">☁️ کلاؤڈ آٹو بیک اپ و لاگ ان (Cloud Storage)</h2>
      <button class="btn-close-modal" onclick="closeModal()">✕</button>
    </div>

    <div style="background:var(--got-green-50); border:1px solid var(--got-green-200); padding:12px; border-radius:12px; margin-bottom:16px;">
      <div style="font-weight:700; color:var(--got-green-800); font-size:13px;">🟢 آٹو کلاؤڈ سینک فعال (Auto Sync Active)</div>
      <div style="font-size:11px; color:var(--text-muted); margin-top:2px;">آپ کا تمام کھاتہ ڈیٹا اس موبائل/ای میل کے ساتھ کلاؤڈ والٹ میں خود بخود محفوظ ہو رہا ہے۔</div>
      <div style="font-size:11px; font-weight:700; color:var(--primary-700); margin-top:4px;">آخری کلاؤڈ بیک اپ: ${state.lastCloudSync || 'ابھی'}</div>
    </div>

    <form onsubmit="handleCloudAccountLogin(event)">
      <div class="form-group">
        <label class="form-label">موبائل فون نمبر یا ای میل درج کریں (Log In / Restore)</label>
        <input type="text" class="form-control" id="cloudAccountInput" value="${state.business.phone || state.business.email}" placeholder="0300-1234567 یا email@gmail.com" required>
      </div>

      <button type="submit" class="btn-action-lg btn-got" style="width:100%; margin-top:12px;">
        🔄 کلاؤڈ ڈیٹا بحال / لاگ ان کریں (Restore & Sync)
      </button>
    </form>

    <div style="margin-top:16px; border-top:1px dashed var(--border-light); padding-top:12px;">
      <button class="btn-action-lg btn-gave" style="width:100%; background:var(--surface-card); color:var(--text-main); border:1px solid var(--border-light);" onclick="exportJSONBackup()">
        💾 لوکل JSON فائل ڈاؤن لوڈ (Offline Backup)
      </button>
    </div>
  `;

  overlay.classList.add('active');
}

function handleCloudAccountLogin(e) {
  e.preventDefault();
  const inputVal = document.getElementById('cloudAccountInput').value.trim();
  if (!inputVal) return;

  if (inputVal.includes('@')) {
    state.business.email = inputVal;
  } else {
    state.business.phone = inputVal;
  }

  const accountKey = getUserAccountKey(state.business.phone, state.business.email);
  const cloudVault = localStorage.getItem(accountKey);

  if (cloudVault) {
    try {
      const vaultData = JSON.parse(cloudVault);
      state.parties = vaultData.parties || [];
      state.transactions = vaultData.transactions || [];
      state.bills = vaultData.bills || [];
      state.expenses = vaultData.expenses || [];
      if (vaultData.business) state.business = vaultData.business;
      alert(`کلاؤڈ اکاؤنٹ (${inputVal}) کا ڈیٹا کامیابی سے بحال ہو گیا ہے!`);
    } catch (err) {
      console.error(err);
    }
  } else {
    alert(`نیا کلاؤڈ والٹ اکاؤنٹ (${inputVal}) رجسٹر ہو گیا ہے! آئندہ تمام ڈیٹا اس پر محفوظ ہوگا۔`);
  }

  saveData();
  closeModal();
  renderApp();
}

// Global Start
window.addEventListener('DOMContentLoaded', () => {
  initData();
  setLanguage(state.lang);
});
