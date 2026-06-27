// lib/l10n/app_localizations.dart

enum AppLanguage {
  english,
  hindi,
  tamil,
  telugu,
  kannada,
  marathi,
}

extension AppLanguageX on AppLanguage {
  String get displayName => switch (this) {
        AppLanguage.english  => 'English',
        AppLanguage.hindi    => 'हिन्दी',
        AppLanguage.tamil    => 'தமிழ்',
        AppLanguage.telugu   => 'తెలుగు',
        AppLanguage.kannada  => 'ಕನ್ನಡ',
        AppLanguage.marathi  => 'मराठी',
      };

  String get flagEmoji => switch (this) {
        AppLanguage.english  => '🇬🇧',
        AppLanguage.hindi    => '🇮🇳',
        AppLanguage.tamil    => '🇮🇳',
        AppLanguage.telugu   => '🇮🇳',
        AppLanguage.kannada  => '🇮🇳',
        AppLanguage.marathi  => '🇮🇳',
      };

  String get code => switch (this) {
        AppLanguage.english  => 'en',
        AppLanguage.hindi    => 'hi',
        AppLanguage.tamil    => 'ta',
        AppLanguage.telugu   => 'te',
        AppLanguage.kannada  => 'kn',
        AppLanguage.marathi  => 'mr',
      };
}

abstract class AppLocalizations {
  // ── App ─────────────────────────────────────────────────────
  String get appName;

  // ── Auth – Login ─────────────────────────────────────────────
  String get welcomeBack;
  String get signInToAccount;
  String get emailAddress;
  String get password;
  String get signIn;
  String get emailRequired;
  String get enterValidEmail;
  String get passwordRequired;
  String get atLeast6Chars;
  String get invalidCredentials;
  String get newToFarmsetu;
  String get createAccount;
  String get demoHint;

  // ── Auth – Register ──────────────────────────────────────────
  String get fullName;
  String get nameRequired;
  String get confirmPassword;
  String get passwordsNoMatch;
  String get minimum6Chars;
  String get joinFarmsetu;
  String get alreadyHaveAccount;
  String get signInLink;
  String get registrationFailed;

  // ── Bottom Nav ───────────────────────────────────────────────
  String get navHome;
  String get navFarms;
  String get navCart;
  String get navProfile;

  // ── Home ─────────────────────────────────────────────────────
  String get hello;
  String get findFreshProduce;
  String get searchHint;
  String get featuredFarms;
  String get allProducts;
  String get searchResults;
  String get items;
  String get noProductsFound;
  String get tryDifferentSearch;
  String get reviews;
  String get allFarms;

  // ── Profile Tab ──────────────────────────────────────────────
  String get myOrders;
  String get savedProducts;
  String get deliveryAddress;
  String get notifications;
  String get helpSupport;
  String get signOut;
  String get language;
  String get selectLanguage;
  String get settings;
  String get settingsLanguage;
  String get settingsAppearance;
  String get settingsAccount;
  String get settingsAbout;
  String get settingsVersion;
  String get settingsDarkMode;
  String get settingsNotifications;
  String get settingsPrivacyPolicy;
  String get settingsTerms;

  // ── Cart ─────────────────────────────────────────────────────
  String get myCart;
  String get clearAll;
  String get clearCartTitle;
  String get allItemsRemoved;
  String get cancel;
  String get clear;
  String get orderPlaced;
  String get orderPlacedMsg;
  String get done;
  String get placeOrder;
  String get subtotal;
  String get deliveryFee;
  String get total;
  String get yourCartEmpty;
  String get addProductsToStart;
  String subtotalWithCount(int count);

  // ── Product Detail ───────────────────────────────────────────
  String get aboutProduct;
  String get fromTheFarm;
  String get organic;
  String get addToCart;
  String get viewCart;
  String addedToCart(String name, int qty);
  String get addToCartBtn;

  // ── Vendor / Farm ────────────────────────────────────────────
  String get aboutFarm;
  String get specialisesIn;
  String get rating;
  String get reviewsLabel;
  String get productsLabel;
  String get active;
  String get byOwner;
  String get verified;

  // ── General ──────────────────────────────────────────────────
  String get user;
  String itemsCount(int n);

  // ── Categories ───────────────────────────────────────────────
  String get catAll;
  String get catVegetables;
  String get catFruits;
  String get catDairy;
  String get catGrains;
  String get catHoney;

  // ── Product Names ─────────────────────────────────────────────
  String get prodHeirloomTomatoes;
  String get prodBabySpinach;
  String get prodOrganicStrawberries;
  String get prodFreeRangeEggs;
  String get prodPaneer;
  String get prodRawForestHoney;
  String get prodFreshCarrots;
  String get prodWholeWheatAtta;

  // ── Farmer Registration ───────────────────────────────────────
  String get phone;
  String get email;
  String get farmName;
  String get location;
  String get category;
  String get bio;
  String get aadhaarNumber;
  String get passbookNumber;
  String get declaration;
  String get submitApplication;
  String get next;
  String get back;

  // Helper: translate product name by ID
  String productName(String id) => switch (id) {
  'p1' => prodHeirloomTomatoes,
  'p2' => prodBabySpinach,
  'p3' => prodOrganicStrawberries,
  'p4' => prodFreeRangeEggs,
  'p5' => prodPaneer,
  'p6' => prodRawForestHoney,
  'p7' => prodFreshCarrots,
  'p8' => prodWholeWheatAtta,
  _    => id,   // ← this returns the raw UUID for Firestore products
};

  // Helper: translate category display name
  String categoryName(String key) => switch (key) {
    'All'        => catAll,
    'Vegetables' => catVegetables,
    'Fruits'     => catFruits,
    'Dairy'      => catDairy,
    'Grains'     => catGrains,
    'Honey'      => catHoney,
    _            => key,
  };

  // ── Factory ──────────────────────────────────────────────────
  static AppLocalizations of(AppLanguage lang) => switch (lang) {
        AppLanguage.english  => _English(),
        AppLanguage.hindi    => _Hindi(),
        AppLanguage.tamil    => _Tamil(),
        AppLanguage.telugu   => _Telugu(),
        AppLanguage.kannada  => _Kannada(),
        AppLanguage.marathi  => _Marathi(),
      };
}

// ═════════════════════════════════════════════════════════════
// ENGLISH
// ═════════════════════════════════════════════════════════════
class _English extends AppLocalizations {
  @override String get appName            => 'Farmsetu';
  @override String get welcomeBack        => 'Welcome back';
  @override String get signInToAccount    => 'Sign in to your account';
  @override String get emailAddress       => 'Email address';
  @override String get password           => 'Password';
  @override String get signIn             => 'Sign In';
  @override String get emailRequired      => 'Email is required';
  @override String get enterValidEmail    => 'Enter a valid email';
  @override String get passwordRequired   => 'Password is required';
  @override String get atLeast6Chars      => 'At least 6 characters required';
  @override String get invalidCredentials => 'Invalid credentials. Please try again.';
  @override String get newToFarmsetu      => 'New to Farmsetu? ';
  @override String get createAccount      => 'Create account';
  @override String get demoHint           => 'Demo: any email + 6+ character password';
  @override String get fullName           => 'Full name';
  @override String get nameRequired       => 'Name is required';
  @override String get confirmPassword    => 'Confirm password';
  @override String get passwordsNoMatch   => 'Passwords do not match';
  @override String get minimum6Chars      => 'Minimum 6 characters';
  @override String get joinFarmsetu       => 'Join Farmsetu and shop farm-fresh.';
  @override String get alreadyHaveAccount => 'Already have an account? ';
  @override String get signInLink         => 'Sign in';
  @override String get registrationFailed => 'Registration failed. Try again.';
  @override String get navHome            => 'Home';
  @override String get navFarms           => 'Farms';
  @override String get navCart            => 'Cart';
  @override String get navProfile         => 'Profile';
  @override String get hello              => 'Hello, ';
  @override String get findFreshProduce   => 'Find fresh produce';
  @override String get searchHint         => 'Search products, farms…';
  @override String get featuredFarms      => 'Featured Farms';
  @override String get allProducts        => 'All Products';
  @override String get searchResults      => 'Search Results';
  @override String get items              => 'items';
  @override String get noProductsFound    => 'No products found';
  @override String get tryDifferentSearch => 'Try a different category or search term';
  @override String get reviews            => 'reviews';
  @override String get allFarms           => 'All Farms';
  @override String get myOrders           => 'My Orders';
  @override String get savedProducts      => 'Saved Products';
  @override String get deliveryAddress    => 'Delivery Address';
  @override String get notifications      => 'Notifications';
  @override String get helpSupport        => 'Help & Support';
  @override String get signOut            => 'Sign Out';
  @override String get language           => 'Language';
  @override String get selectLanguage     => 'Select Language';
  @override String get settings           => 'Settings';
  @override String get settingsLanguage   => 'Language';
  @override String get settingsAppearance => 'Appearance';
  @override String get settingsAccount    => 'Account';
  @override String get settingsAbout      => 'About';
  @override String get settingsVersion    => 'Version 1.0.0';
  @override String get settingsDarkMode   => 'Dark Mode';
  @override String get settingsNotifications => 'Push Notifications';
  @override String get settingsPrivacyPolicy => 'Privacy Policy';
  @override String get settingsTerms      => 'Terms of Service';
  @override String get myCart             => 'My Cart';
  @override String get clearAll           => 'Clear all';
  @override String get clearCartTitle     => 'Clear cart?';
  @override String get allItemsRemoved    => 'All items will be removed.';
  @override String get cancel             => 'Cancel';
  @override String get clear              => 'Clear';
  @override String get orderPlaced        => 'Order Placed!';
  @override String get orderPlacedMsg     => 'Your order has been placed successfully.\n(Demo — no real payment processed.)';
  @override String get done               => 'Done';
  @override String get placeOrder         => 'Place Order';
  @override String get subtotal           => 'Subtotal';
  @override String get deliveryFee        => 'Delivery fee';
  @override String get total              => 'Total';
  @override String get yourCartEmpty      => 'Your cart is empty';
  @override String get addProductsToStart => 'Add products to get started';
  @override String subtotalWithCount(int n) => 'Subtotal ($n items)';
  @override String get aboutProduct       => 'About this product';
  @override String get fromTheFarm        => 'From the farm';
  @override String get organic            => 'Organic';
  @override String get addToCart          => 'Add to Cart';
  @override String get viewCart           => 'View Cart';
  @override String addedToCart(String name, int qty) => '$qty × $name added to cart';
  @override String get addToCartBtn       => 'Add to Cart  — ';
  @override String get aboutFarm          => 'About the Farm';
  @override String get specialisesIn      => 'Specialises in';
  @override String get rating             => 'Rating';
  @override String get reviewsLabel       => 'Reviews';
  @override String get productsLabel      => 'Products';
  @override String get active             => 'Active';
  @override String get byOwner            => 'by ';
  @override String get verified           => 'Verified';
  @override String get user               => 'User';
  @override String itemsCount(int n)      => '$n items';
  @override String get catAll             => 'All';
  @override String get catVegetables      => 'Vegetables';
  @override String get catFruits          => 'Fruits';
  @override String get catDairy           => 'Dairy';
  @override String get catGrains          => 'Grains';
  @override String get catHoney           => 'Honey';
  @override String get prodHeirloomTomatoes    => 'Heirloom Tomatoes';
  @override String get prodBabySpinach         => 'Baby Spinach';
  @override String get prodOrganicStrawberries => 'Organic Strawberries';
  @override String get prodFreeRangeEggs       => 'Free-Range Eggs';
  @override String get prodPaneer              => 'Paneer';
  @override String get prodRawForestHoney      => 'Raw Forest Honey';
  @override String get prodFreshCarrots        => 'Fresh Carrots';
  @override String get prodWholeWheatAtta      => 'Whole Wheat Atta';
  // ── Farmer Registration ──────────────────────────────────────
  @override String get phone              => 'Phone Number';
  @override String get email              => 'Email Address';
  @override String get farmName           => 'Farm Name';
  @override String get location           => 'Location / Village';
  @override String get category           => 'Primary Category';
  @override String get bio                => 'About your farm';
  @override String get aadhaarNumber      => 'Aadhaar Number';
  @override String get passbookNumber     => 'Farm Passbook Number';
  @override String get declaration        => 'I declare that all information and documents submitted are genuine and I authorise Farmsetu and Government authorities to verify them.';
  @override String get submitApplication  => 'Submit Registration';
  @override String get next               => 'Next';
  @override String get back               => 'Back';
}

// ═════════════════════════════════════════════════════════════
// HINDI
// ═════════════════════════════════════════════════════════════
class _Hindi extends AppLocalizations {
  @override String get appName            => 'Farmsetu';
  @override String get welcomeBack        => 'वापस स्वागत है';
  @override String get signInToAccount    => 'अपने खाते में साइन इन करें';
  @override String get emailAddress       => 'ईमेल पता';
  @override String get password           => 'पासवर्ड';
  @override String get signIn             => 'साइन इन';
  @override String get emailRequired      => 'ईमेल आवश्यक है';
  @override String get enterValidEmail    => 'मान्य ईमेल दर्ज करें';
  @override String get passwordRequired   => 'पासवर्ड आवश्यक है';
  @override String get atLeast6Chars      => 'कम से कम 6 अक्षर आवश्यक हैं';
  @override String get invalidCredentials => 'अमान्य क्रेडेंशियल। पुनः प्रयास करें।';
  @override String get newToFarmsetu      => 'Farmsetu में नए हैं? ';
  @override String get createAccount      => 'खाता बनाएं';
  @override String get demoHint           => 'डेमो: कोई भी ईमेल + 6+ अक्षर का पासवर्ड';
  @override String get fullName           => 'पूरा नाम';
  @override String get nameRequired       => 'नाम आवश्यक है';
  @override String get confirmPassword    => 'पासवर्ड की पुष्टि करें';
  @override String get passwordsNoMatch   => 'पासवर्ड मेल नहीं खाते';
  @override String get minimum6Chars      => 'न्यूनतम 6 अक्षर';
  @override String get joinFarmsetu       => 'Farmsetu से जुड़ें और ताज़ा उत्पाद खरीदें।';
  @override String get alreadyHaveAccount => 'पहले से खाता है? ';
  @override String get signInLink         => 'साइन इन';
  @override String get registrationFailed => 'पंजीकरण विफल। पुनः प्रयास करें।';
  @override String get navHome            => 'होम';
  @override String get navFarms           => 'खेत';
  @override String get navCart            => 'कार्ट';
  @override String get navProfile         => 'प्रोफ़ाइल';
  @override String get hello              => 'नमस्ते, ';
  @override String get findFreshProduce   => 'ताज़ा उत्पाद खोजें';
  @override String get searchHint         => 'उत्पाद, खेत खोजें…';
  @override String get featuredFarms      => 'विशेष खेत';
  @override String get allProducts        => 'सभी उत्पाद';
  @override String get searchResults      => 'खोज परिणाम';
  @override String get items              => 'आइटम';
  @override String get noProductsFound    => 'कोई उत्पाद नहीं मिला';
  @override String get tryDifferentSearch => 'कोई अन्य श्रेणी या खोज शब्द आज़माएं';
  @override String get reviews            => 'समीक्षाएं';
  @override String get allFarms           => 'सभी खेत';
  @override String get myOrders           => 'मेरे ऑर्डर';
  @override String get savedProducts      => 'सहेजे गए उत्पाद';
  @override String get deliveryAddress    => 'डिलीवरी पता';
  @override String get notifications      => 'सूचनाएं';
  @override String get helpSupport        => 'सहायता और समर्थन';
  @override String get signOut            => 'साइन आउट';
  @override String get language           => 'भाषा';
  @override String get selectLanguage     => 'भाषा चुनें';
  @override String get settings           => 'सेटिंग्स';
  @override String get settingsLanguage   => 'भाषा';
  @override String get settingsAppearance => 'रूपरेखा';
  @override String get settingsAccount    => 'खाता';
  @override String get settingsAbout      => 'के बारे में';
  @override String get settingsVersion    => 'संस्करण 1.0.0';
  @override String get settingsDarkMode   => 'डार्क मोड';
  @override String get settingsNotifications => 'पुश नोटिफिकेशन';
  @override String get settingsPrivacyPolicy => 'गोपनीयता नीति';
  @override String get settingsTerms      => 'सेवा की शर्तें';
  @override String get myCart             => 'मेरी कार्ट';
  @override String get clearAll           => 'सब हटाएं';
  @override String get clearCartTitle     => 'कार्ट साफ़ करें?';
  @override String get allItemsRemoved    => 'सभी आइटम हटा दिए जाएंगे।';
  @override String get cancel             => 'रद्द करें';
  @override String get clear              => 'हटाएं';
  @override String get orderPlaced        => 'ऑर्डर दिया गया!';
  @override String get orderPlacedMsg     => 'आपका ऑर्डर सफलतापूर्वक दिया गया है।\n(डेमो — कोई वास्तविक भुगतान नहीं।)';
  @override String get done               => 'हो गया';
  @override String get placeOrder         => 'ऑर्डर दें';
  @override String get subtotal           => 'उप-कुल';
  @override String get deliveryFee        => 'डिलीवरी शुल्क';
  @override String get total              => 'कुल';
  @override String get yourCartEmpty      => 'आपकी कार्ट खाली है';
  @override String get addProductsToStart => 'शुरू करने के लिए उत्पाद जोड़ें';
  @override String subtotalWithCount(int n) => 'उप-कुल ($n आइटम)';
  @override String get aboutProduct       => 'इस उत्पाद के बारे में';
  @override String get fromTheFarm        => 'खेत से';
  @override String get organic            => 'जैविक';
  @override String get addToCart          => 'कार्ट में जोड़ें';
  @override String get viewCart           => 'कार्ट देखें';
  @override String addedToCart(String name, int qty) => '$qty × $name कार्ट में जोड़ा गया';
  @override String get addToCartBtn       => 'कार्ट में जोड़ें  — ';
  @override String get aboutFarm          => 'खेत के बारे में';
  @override String get specialisesIn      => 'विशेषज्ञता';
  @override String get rating             => 'रेटिंग';
  @override String get reviewsLabel       => 'समीक्षाएं';
  @override String get productsLabel      => 'उत्पाद';
  @override String get active             => 'सक्रिय';
  @override String get byOwner            => 'द्वारा ';
  @override String get verified           => 'सत्यापित';
  @override String get user               => 'उपयोगकर्ता';
  @override String itemsCount(int n)      => '$n आइटम';
  @override String get catAll             => 'सभी';
  @override String get catVegetables      => 'सब्जियाँ';
  @override String get catFruits          => 'फल';
  @override String get catDairy           => 'डेयरी';
  @override String get catGrains          => 'अनाज';
  @override String get catHoney           => 'शहद';
  @override String get prodHeirloomTomatoes    => 'देसी टमाटर';
  @override String get prodBabySpinach         => 'पालक';
  @override String get prodOrganicStrawberries => 'जैविक स्ट्रॉबेरी';
  @override String get prodFreeRangeEggs       => 'देसी अंडे';
  @override String get prodPaneer              => 'पनीर';
  @override String get prodRawForestHoney      => 'कच्चा जंगली शहद';
  @override String get prodFreshCarrots        => 'ताजी गाजर';
  @override String get prodWholeWheatAtta      => 'गेहूं का आटा';
  // ── Farmer Registration ──────────────────────────────────────
  @override String get phone              => 'फोन नंबर';
  @override String get email              => 'ईमेल पता';
  @override String get farmName           => 'खेत का नाम';
  @override String get location           => 'स्थान / गाँव';
  @override String get category           => 'मुख्य श्रेणी';
  @override String get bio                => 'अपने खेत के बारे में';
  @override String get aadhaarNumber      => 'आधार संख्या';
  @override String get passbookNumber     => 'फार्म पासबुक नंबर';
  @override String get declaration        => 'मैं घोषणा करता/करती हूँ कि सभी जानकारी और दस्तावेज़ सत्य हैं और मैं Farmsetu और सरकारी अधिकारियों को उन्हें सत्यापित करने की अनुमति देता/देती हूँ।';
  @override String get submitApplication  => 'पंजीकरण जमा करें';
  @override String get next               => 'अगला';
  @override String get back               => 'वापस';
}

// ═════════════════════════════════════════════════════════════
// TAMIL
// ═════════════════════════════════════════════════════════════
class _Tamil extends AppLocalizations {
  @override String get appName            => 'Farmsetu';
  @override String get welcomeBack        => 'மீண்டும் வரவேற்கிறோம்';
  @override String get signInToAccount    => 'உங்கள் கணக்கில் உள்நுழைக';
  @override String get emailAddress       => 'மின்னஞ்சல் முகவரி';
  @override String get password           => 'கடவுச்சொல்';
  @override String get signIn             => 'உள்நுழை';
  @override String get emailRequired      => 'மின்னஞ்சல் தேவை';
  @override String get enterValidEmail    => 'சரியான மின்னஞ்சல் உள்ளிடவும்';
  @override String get passwordRequired   => 'கடவுச்சொல் தேவை';
  @override String get atLeast6Chars      => 'குறைந்தது 6 எழுத்துகள் தேவை';
  @override String get invalidCredentials => 'தவறான நற்சான்றிதழ்கள். மீண்டும் முயற்சிக்கவும்.';
  @override String get newToFarmsetu      => 'Farmsetu-ல் புதியவரா? ';
  @override String get createAccount      => 'கணக்கு உருவாக்கு';
  @override String get demoHint           => 'டெமோ: எந்த மின்னஞ்சலும் + 6+ எழுத்துகள்';
  @override String get fullName           => 'முழு பெயர்';
  @override String get nameRequired       => 'பெயர் தேவை';
  @override String get confirmPassword    => 'கடவுச்சொல்லை உறுதிப்படுத்தவும்';
  @override String get passwordsNoMatch   => 'கடவுச்சொற்கள் பொருந்தவில்லை';
  @override String get minimum6Chars      => 'குறைந்தது 6 எழுத்துகள்';
  @override String get joinFarmsetu       => 'Farmsetu-ல் சேர்ந்து புதிய பண்ணை பொருட்கள் வாங்கவும்.';
  @override String get alreadyHaveAccount => 'ஏற்கனவே கணக்கு உள்ளதா? ';
  @override String get signInLink         => 'உள்நுழை';
  @override String get registrationFailed => 'பதிவு தோல்வியடைந்தது. மீண்டும் முயற்சிக்கவும்.';
  @override String get navHome            => 'முகப்பு';
  @override String get navFarms           => 'பண்ணைகள்';
  @override String get navCart            => 'கார்ட்';
  @override String get navProfile         => 'சுயவிவரம்';
  @override String get hello              => 'வணக்கம், ';
  @override String get findFreshProduce   => 'புதிய பொருட்கள் தேடுக';
  @override String get searchHint         => 'பொருட்கள், பண்ணைகள் தேடுங்கள்…';
  @override String get featuredFarms      => 'சிறப்பு பண்ணைகள்';
  @override String get allProducts        => 'அனைத்து பொருட்கள்';
  @override String get searchResults      => 'தேடல் முடிவுகள்';
  @override String get items              => 'பொருட்கள்';
  @override String get noProductsFound    => 'பொருட்கள் கிடைக்கவில்லை';
  @override String get tryDifferentSearch => 'வேறு வகை அல்லது தேடல் சொல்லை முயற்சிக்கவும்';
  @override String get reviews            => 'மதிப்புரைகள்';
  @override String get allFarms           => 'அனைத்து பண்ணைகள்';
  @override String get myOrders           => 'என் ஆர்டர்கள்';
  @override String get savedProducts      => 'சேமித்த பொருட்கள்';
  @override String get deliveryAddress    => 'டெலிவரி முகவரி';
  @override String get notifications      => 'அறிவிப்புகள்';
  @override String get helpSupport        => 'உதவி & ஆதரவு';
  @override String get signOut            => 'வெளியேறு';
  @override String get language           => 'மொழி';
  @override String get selectLanguage     => 'மொழி தேர்வு செய்யவும்';
  @override String get settings           => 'அமைப்புகள்';
  @override String get settingsLanguage   => 'மொழி';
  @override String get settingsAppearance => 'தோற்றம்';
  @override String get settingsAccount    => 'கணக்கு';
  @override String get settingsAbout      => 'பற்றி';
  @override String get settingsVersion    => 'பதிப்பு 1.0.0';
  @override String get settingsDarkMode   => 'இருண்ட பயன்முறை';
  @override String get settingsNotifications => 'புஷ் அறிவிப்புகள்';
  @override String get settingsPrivacyPolicy => 'தனியுரிமை கொள்கை';
  @override String get settingsTerms      => 'சேவை விதிமுறைகள்';
  @override String get myCart             => 'என் கார்ட்';
  @override String get clearAll           => 'அனைத்தையும் நீக்கு';
  @override String get clearCartTitle     => 'கார்ட் அழிக்கவும்?';
  @override String get allItemsRemoved    => 'அனைத்து பொருட்களும் நீக்கப்படும்.';
  @override String get cancel             => 'ரத்து செய்';
  @override String get clear              => 'அழி';
  @override String get orderPlaced        => 'ஆர்டர் வைக்கப்பட்டது!';
  @override String get orderPlacedMsg     => 'உங்கள் ஆர்டர் வெற்றிகரமாக வைக்கப்பட்டது.\n(டெமோ — உண்மையான பணம் செலுத்தப்படவில்லை.)';
  @override String get done               => 'முடிந்தது';
  @override String get placeOrder         => 'ஆர்டர் செய்';
  @override String get subtotal           => 'துணை மொத்தம்';
  @override String get deliveryFee        => 'டெலிவரி கட்டணம்';
  @override String get total              => 'மொத்தம்';
  @override String get yourCartEmpty      => 'உங்கள் கார்ட் காலியாக உள்ளது';
  @override String get addProductsToStart => 'தொடங்க பொருட்கள் சேர்க்கவும்';
  @override String subtotalWithCount(int n) => 'துணை மொத்தம் ($n பொருட்கள்)';
  @override String get aboutProduct       => 'இந்த பொருளைப் பற்றி';
  @override String get fromTheFarm        => 'பண்ணையிலிருந்து';
  @override String get organic            => 'இயற்கை';
  @override String get addToCart          => 'கார்ட்டில் சேர்';
  @override String get viewCart           => 'கார்ட் பார்';
  @override String addedToCart(String name, int qty) => '$qty × $name கார்ட்டில் சேர்க்கப்பட்டது';
  @override String get addToCartBtn       => 'கார்ட்டில் சேர்  — ';
  @override String get aboutFarm          => 'பண்ணையைப் பற்றி';
  @override String get specialisesIn      => 'சிறப்பு பொருட்கள்';
  @override String get rating             => 'மதிப்பீடு';
  @override String get reviewsLabel       => 'மதிப்புரைகள்';
  @override String get productsLabel      => 'பொருட்கள்';
  @override String get active             => 'செயலில்';
  @override String get byOwner            => 'ஆல் ';
  @override String get verified           => 'சரிபார்க்கப்பட்டது';
  @override String get user               => 'பயனர்';
  @override String itemsCount(int n)      => '$n பொருட்கள்';
  @override String get catAll             => 'அனைத்தும்';
  @override String get catVegetables      => 'காய்கறிகள்';
  @override String get catFruits          => 'பழங்கள்';
  @override String get catDairy           => 'பால் பொருட்கள்';
  @override String get catGrains          => 'தானியங்கள்';
  @override String get catHoney           => 'தேன்';
  @override String get prodHeirloomTomatoes    => 'நாட்டு தக்காளி';
  @override String get prodBabySpinach         => 'பசலைக்கீரை';
  @override String get prodOrganicStrawberries => 'இயற்கை ஸ்ட்ராபெர்ரி';
  @override String get prodFreeRangeEggs       => 'நாட்டு கோழி முட்டை';
  @override String get prodPaneer              => 'பனீர்';
  @override String get prodRawForestHoney      => 'காட்டு தேன்';
  @override String get prodFreshCarrots        => 'புதிய கேரட்';
  @override String get prodWholeWheatAtta      => 'கோதுமை மாவு';
  // ── Farmer Registration ──────────────────────────────────────
  @override String get phone              => 'தொலைபேசி எண்';
  @override String get email              => 'மின்னஞ்சல் முகவரி';
  @override String get farmName           => 'பண்ணை பெயர்';
  @override String get location           => 'இடம் / கிராமம்';
  @override String get category           => 'முதன்மை வகை';
  @override String get bio                => 'உங்கள் பண்ணையைப் பற்றி';
  @override String get aadhaarNumber      => 'ஆதார் எண்';
  @override String get passbookNumber     => 'பண்ணை பாஸ்புக் எண்';
  @override String get declaration        => 'சமர்ப்பிக்கப்பட்ட அனைத்து தகவல்களும் ஆவணங்களும் உண்மையானவை என்று நான் அறிவிக்கிறேன், மேலும் Farmsetu மற்றும் அரசு அதிகாரிகளை சரிபார்க்க அதிகாரமளிக்கிறேன்.';
  @override String get submitApplication  => 'பதிவை சமர்ப்பிக்கவும்';
  @override String get next               => 'அடுத்து';
  @override String get back               => 'திரும்பு';
}

// ═════════════════════════════════════════════════════════════
// TELUGU
// ═════════════════════════════════════════════════════════════
class _Telugu extends AppLocalizations {
  @override String get appName            => 'Farmsetu';
  @override String get welcomeBack        => 'తిరిగి స్వాగతం';
  @override String get signInToAccount    => 'మీ ఖాతాలో సైన్ ఇన్ చేయండి';
  @override String get emailAddress       => 'ఇమెయిల్ చిరునామా';
  @override String get password           => 'పాస్‌వర్డ్';
  @override String get signIn             => 'సైన్ ఇన్';
  @override String get emailRequired      => 'ఇమెయిల్ అవసరం';
  @override String get enterValidEmail    => 'చెల్లుబాటు అయ్యే ఇమెయిల్ నమోదు చేయండి';
  @override String get passwordRequired   => 'పాస్‌వర్డ్ అవసరం';
  @override String get atLeast6Chars      => 'కనీసం 6 అక్షరాలు అవసరం';
  @override String get invalidCredentials => 'తప్పు వివరాలు. మళ్ళీ ప్రయత్నించండి.';
  @override String get newToFarmsetu      => 'Farmsetu కి కొత్తవారా? ';
  @override String get createAccount      => 'ఖాతా సృష్టించు';
  @override String get demoHint           => 'డెమో: ఏదైనా ఇమెయిల్ + 6+ అక్షరాల పాస్‌వర్డ్';
  @override String get fullName           => 'పూర్తి పేరు';
  @override String get nameRequired       => 'పేరు అవసరం';
  @override String get confirmPassword    => 'పాస్‌వర్డ్ నిర్ధారించు';
  @override String get passwordsNoMatch   => 'పాస్‌వర్డ్‌లు సరిపోలడం లేదు';
  @override String get minimum6Chars      => 'కనీసం 6 అక్షరాలు';
  @override String get joinFarmsetu       => 'Farmsetu లో చేరండి మరియు తాజా పొలం ఉత్పత్తులు కొనండి.';
  @override String get alreadyHaveAccount => 'ఇప్పటికే ఖాతా ఉందా? ';
  @override String get signInLink         => 'సైన్ ఇన్';
  @override String get registrationFailed => 'నమోదు విఫలమైంది. మళ్ళీ ప్రయత్నించండి.';
  @override String get navHome            => 'హోమ్';
  @override String get navFarms           => 'పొలాలు';
  @override String get navCart            => 'కార్ట్';
  @override String get navProfile         => 'ప్రొఫైల్';
  @override String get hello              => 'నమస్కారం, ';
  @override String get findFreshProduce   => 'తాజా ఉత్పత్తులు వెతకండి';
  @override String get searchHint         => 'ఉత్పత్తులు, పొలాలు వెతకండి…';
  @override String get featuredFarms      => 'ప్రత్యేక పొలాలు';
  @override String get allProducts        => 'అన్ని ఉత్పత్తులు';
  @override String get searchResults      => 'వెతుకు ఫలితాలు';
  @override String get items              => 'వస్తువులు';
  @override String get noProductsFound    => 'ఉత్పత్తులు దొరకలేదు';
  @override String get tryDifferentSearch => 'వేరే వర్గం లేదా పదం ప్రయత్నించండి';
  @override String get reviews            => 'సమీక్షలు';
  @override String get allFarms           => 'అన్ని పొలాలు';
  @override String get myOrders           => 'నా ఆర్డర్లు';
  @override String get savedProducts      => 'సేవ్ చేసిన ఉత్పత్తులు';
  @override String get deliveryAddress    => 'డెలివరీ చిరునామా';
  @override String get notifications      => 'నోటిఫికేషన్లు';
  @override String get helpSupport        => 'సహాయం & మద్దతు';
  @override String get signOut            => 'సైన్ అవుట్';
  @override String get language           => 'భాష';
  @override String get selectLanguage     => 'భాష ఎంచుకోండి';
  @override String get settings           => 'సెట్టింగులు';
  @override String get settingsLanguage   => 'భాష';
  @override String get settingsAppearance => 'రూపాన్ని';
  @override String get settingsAccount    => 'ఖాతా';
  @override String get settingsAbout      => 'గురించి';
  @override String get settingsVersion    => 'వెర్షన్ 1.0.0';
  @override String get settingsDarkMode   => 'డార్క్ మోడ్';
  @override String get settingsNotifications => 'పుష్ నోటిఫికేషన్లు';
  @override String get settingsPrivacyPolicy => 'గోప్యతా విధానం';
  @override String get settingsTerms      => 'సేవా నిబంధనలు';
  @override String get myCart             => 'నా కార్ట్';
  @override String get clearAll           => 'అన్నీ తొలగించు';
  @override String get clearCartTitle     => 'కార్ట్ క్లియర్ చేయాలా?';
  @override String get allItemsRemoved    => 'అన్ని వస్తువులు తొలగించబడతాయి.';
  @override String get cancel             => 'రద్దు';
  @override String get clear              => 'తొలగించు';
  @override String get orderPlaced        => 'ఆర్డర్ ఇవ్వబడింది!';
  @override String get orderPlacedMsg     => 'మీ ఆర్డర్ విజయవంతంగా ఇవ్వబడింది.\n(డెమో — నిజమైన చెల్లింపు లేదు.)';
  @override String get done               => 'పూర్తయింది';
  @override String get placeOrder         => 'ఆర్డర్ ఇవ్వండి';
  @override String get subtotal           => 'ఉప మొత్తం';
  @override String get deliveryFee        => 'డెలివరీ రుసుము';
  @override String get total              => 'మొత్తం';
  @override String get yourCartEmpty      => 'మీ కార్ట్ ఖాళీగా ఉంది';
  @override String get addProductsToStart => 'ప్రారంభించడానికి ఉత్పత్తులు జోడించండి';
  @override String subtotalWithCount(int n) => 'ఉప మొత్తం ($n వస్తువులు)';
  @override String get aboutProduct       => 'ఈ ఉత్పత్తి గురించి';
  @override String get fromTheFarm        => 'పొలం నుండి';
  @override String get organic            => 'సేంద్రీయ';
  @override String get addToCart          => 'కార్ట్‌లో చేర్చు';
  @override String get viewCart           => 'కార్ట్ చూడు';
  @override String addedToCart(String name, int qty) => '$qty × $name కార్ట్‌లో జోడించబడింది';
  @override String get addToCartBtn       => 'కార్ట్‌లో చేర్చు  — ';
  @override String get aboutFarm          => 'పొలం గురించి';
  @override String get specialisesIn      => 'ప్రత్యేకత';
  @override String get rating             => 'రేటింగ్';
  @override String get reviewsLabel       => 'సమీక్షలు';
  @override String get productsLabel      => 'ఉత్పత్తులు';
  @override String get active             => 'చురుకైన';
  @override String get byOwner            => 'ద్వారా ';
  @override String get verified           => 'ధృవీకరించబడింది';
  @override String get user               => 'వినియోగదారు';
  @override String itemsCount(int n)      => '$n వస్తువులు';
  @override String get catAll             => 'అన్నీ';
  @override String get catVegetables      => 'కూరగాయలు';
  @override String get catFruits          => 'పండ్లు';
  @override String get catDairy           => 'పాల పదార్థాలు';
  @override String get catGrains          => 'ధాన్యాలు';
  @override String get catHoney           => 'తేనె';
  @override String get prodHeirloomTomatoes    => 'దేశీ టొమాటో';
  @override String get prodBabySpinach         => 'పాలకూర';
  @override String get prodOrganicStrawberries => 'సేంద్రీయ స్ట్రాబెర్రీ';
  @override String get prodFreeRangeEggs       => 'నాటు కోడి గుడ్లు';
  @override String get prodPaneer              => 'పనీర్';
  @override String get prodRawForestHoney      => 'అడవి తేనె';
  @override String get prodFreshCarrots        => 'తాజా క్యారెట్';
  @override String get prodWholeWheatAtta      => 'గోధుమ పిండి';
  // ── Farmer Registration ──────────────────────────────────────
  @override String get phone              => 'ఫోన్ నంబర్';
  @override String get email              => 'ఇమెయిల్ చిరునామా';
  @override String get farmName           => 'వ్యవసాయ పేరు';
  @override String get location           => 'స్థానం / గ్రామం';
  @override String get category           => 'ప్రాథమిక వర్గం';
  @override String get bio                => 'మీ వ్యవసాయం గురించి';
  @override String get aadhaarNumber      => 'ఆధార్ నంబర్';
  @override String get passbookNumber     => 'వ్యవసాయ పాస్‌బుక్ నంబర్';
  @override String get declaration        => 'సమర్పించిన అన్ని సమాచారం మరియు పత్రాలు నిజమైనవని నేను ప్రకటిస్తున్నాను మరియు Farmsetu మరియు ప్రభుత్వ అధికారులను వాటిని ధృవీకరించడానికి అధికారం ఇస్తున్నాను.';
  @override String get submitApplication  => 'నమోదును సమర్పించండి';
  @override String get next               => 'తదుపరి';
  @override String get back               => 'వెనుక';
}

// ═════════════════════════════════════════════════════════════
// KANNADA
// ═════════════════════════════════════════════════════════════
class _Kannada extends AppLocalizations {
  @override String get appName            => 'Farmsetu';
  @override String get welcomeBack        => 'ಮತ್ತೆ ಸ್ವಾಗತ';
  @override String get signInToAccount    => 'ನಿಮ್ಮ ಖಾತೆಗೆ ಸೈನ್ ಇನ್ ಮಾಡಿ';
  @override String get emailAddress       => 'ಇಮೇಲ್ ವಿಳಾಸ';
  @override String get password           => 'ಪಾಸ್‌ವರ್ಡ್';
  @override String get signIn             => 'ಸೈನ್ ಇನ್';
  @override String get emailRequired      => 'ಇಮೇಲ್ ಅಗತ್ಯವಿದೆ';
  @override String get enterValidEmail    => 'ಮಾನ್ಯ ಇಮೇಲ್ ನಮೂದಿಸಿ';
  @override String get passwordRequired   => 'ಪಾಸ್‌ವರ್ಡ್ ಅಗತ್ಯವಿದೆ';
  @override String get atLeast6Chars      => 'ಕನಿಷ್ಠ 6 ಅಕ್ಷರಗಳು ಬೇಕು';
  @override String get invalidCredentials => 'ತಪ್ಪಾದ ರುಜುವಾತುಗಳು. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';
  @override String get newToFarmsetu      => 'Farmsetu ಗೆ ಹೊಸಬರೇ? ';
  @override String get createAccount      => 'ಖಾತೆ ರಚಿಸಿ';
  @override String get demoHint           => 'ಡೆಮೋ: ಯಾವುದೇ ಇಮೇಲ್ + 6+ ಅಕ್ಷರಗಳ ಪಾಸ್‌ವರ್ಡ್';
  @override String get fullName           => 'ಪೂರ್ಣ ಹೆಸರು';
  @override String get nameRequired       => 'ಹೆಸರು ಅಗತ್ಯವಿದೆ';
  @override String get confirmPassword    => 'ಪಾಸ್‌ವರ್ಡ್ ದೃಢೀಕರಿಸಿ';
  @override String get passwordsNoMatch   => 'ಪಾಸ್‌ವರ್ಡ್‌ಗಳು ಹೊಂದಿಕೆಯಾಗುತ್ತಿಲ್ಲ';
  @override String get minimum6Chars      => 'ಕನಿಷ್ಠ 6 ಅಕ್ಷರಗಳು';
  @override String get joinFarmsetu       => 'Farmsetu ಸೇರಿ ಮತ್ತು ತಾಜಾ ಉತ್ಪನ್ನಗಳನ್ನು ಖರೀದಿಸಿ.';
  @override String get alreadyHaveAccount => 'ಈಗಾಗಲೇ ಖಾತೆ ಇದೆಯೇ? ';
  @override String get signInLink         => 'ಸೈನ್ ಇನ್';
  @override String get registrationFailed => 'ನೋಂದಣಿ ವಿಫಲವಾಗಿದೆ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';
  @override String get navHome            => 'ಮನೆ';
  @override String get navFarms           => 'ಹೊಲಗಳು';
  @override String get navCart            => 'ಕಾರ್ಟ್';
  @override String get navProfile         => 'ಪ್ರೊಫೈಲ್';
  @override String get hello              => 'ನಮಸ್ಕಾರ, ';
  @override String get findFreshProduce   => 'ತಾಜಾ ಉತ್ಪನ್ನಗಳನ್ನು ಹುಡುಕಿ';
  @override String get searchHint         => 'ಉತ್ಪನ್ನಗಳು, ಹೊಲಗಳು ಹುಡುಕಿ…';
  @override String get featuredFarms      => 'ವಿಶೇಷ ಹೊಲಗಳು';
  @override String get allProducts        => 'ಎಲ್ಲಾ ಉತ್ಪನ್ನಗಳು';
  @override String get searchResults      => 'ಹುಡುಕಾಟ ಫಲಿತಾಂಶಗಳು';
  @override String get items              => 'ವಸ್ತುಗಳು';
  @override String get noProductsFound    => 'ಉತ್ಪನ್ನಗಳು ಸಿಗಲಿಲ್ಲ';
  @override String get tryDifferentSearch => 'ಬೇರೆ ವರ್ಗ ಅಥವಾ ಪದ ಪ್ರಯತ್ನಿಸಿ';
  @override String get reviews            => 'ವಿಮರ್ಶೆಗಳು';
  @override String get allFarms           => 'ಎಲ್ಲಾ ಹೊಲಗಳು';
  @override String get myOrders           => 'ನನ್ನ ಆದೇಶಗಳು';
  @override String get savedProducts      => 'ಉಳಿಸಿದ ಉತ್ಪನ್ನಗಳು';
  @override String get deliveryAddress    => 'ಡೆಲಿವರಿ ವಿಳಾಸ';
  @override String get notifications      => 'ಅಧಿಸೂಚನೆಗಳು';
  @override String get helpSupport        => 'ಸಹಾಯ & ಬೆಂಬಲ';
  @override String get signOut            => 'ಸೈನ್ ಔಟ್';
  @override String get language           => 'ಭಾಷೆ';
  @override String get selectLanguage     => 'ಭಾಷೆ ಆಯ್ಕೆಮಾಡಿ';
  @override String get settings           => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';
  @override String get settingsLanguage   => 'ಭಾಷೆ';
  @override String get settingsAppearance => 'ನೋಟ';
  @override String get settingsAccount    => 'ಖಾತೆ';
  @override String get settingsAbout      => 'ಬಗ್ಗೆ';
  @override String get settingsVersion    => 'ಆವೃತ್ತಿ 1.0.0';
  @override String get settingsDarkMode   => 'ಡಾರ್ಕ್ ಮೋಡ್';
  @override String get settingsNotifications => 'ಪುಶ್ ಅಧಿಸೂಚನೆಗಳು';
  @override String get settingsPrivacyPolicy => 'ಗೌಪ್ಯತಾ ನೀತಿ';
  @override String get settingsTerms      => 'ಸೇವಾ ನಿಯಮಗಳು';
  @override String get myCart             => 'ನನ್ನ ಕಾರ್ಟ್';
  @override String get clearAll           => 'ಎಲ್ಲಾ ತೆಗೆ';
  @override String get clearCartTitle     => 'ಕಾರ್ಟ್ ತೆಗೆಯಲೇ?';
  @override String get allItemsRemoved    => 'ಎಲ್ಲಾ ವಸ್ತುಗಳನ್ನು ತೆಗೆಯಲಾಗುತ್ತದೆ.';
  @override String get cancel             => 'ರದ್ದು';
  @override String get clear              => 'ತೆಗೆ';
  @override String get orderPlaced        => 'ಆದೇಶ ನೀಡಲಾಗಿದೆ!';
  @override String get orderPlacedMsg     => 'ನಿಮ್ಮ ಆದೇಶ ಯಶಸ್ವಿಯಾಗಿ ನೀಡಲಾಗಿದೆ.\n(ಡೆಮೋ — ನಿಜವಾದ ಪಾವತಿ ಇಲ್ಲ.)';
  @override String get done               => 'ಮುಗಿಯಿತು';
  @override String get placeOrder         => 'ಆದೇಶ ನೀಡಿ';
  @override String get subtotal           => 'ಉಪ ಮೊತ್ತ';
  @override String get deliveryFee        => 'ಡೆಲಿವರಿ ಶುಲ್ಕ';
  @override String get total              => 'ಒಟ್ಟು';
  @override String get yourCartEmpty      => 'ನಿಮ್ಮ ಕಾರ್ಟ್ ಖಾಲಿ ಇದೆ';
  @override String get addProductsToStart => 'ಪ್ರಾರಂಭಿಸಲು ಉತ್ಪನ್ನಗಳನ್ನು ಸೇರಿಸಿ';
  @override String subtotalWithCount(int n) => 'ಉಪ ಮೊತ್ತ ($n ವಸ್ತುಗಳು)';
  @override String get aboutProduct       => 'ಈ ಉತ್ಪನ್ನದ ಬಗ್ಗೆ';
  @override String get fromTheFarm        => 'ಹೊಲದಿಂದ';
  @override String get organic            => 'ಸಾವಯವ';
  @override String get addToCart          => 'ಕಾರ್ಟ್‌ಗೆ ಸೇರಿಸಿ';
  @override String get viewCart           => 'ಕಾರ್ಟ್ ನೋಡಿ';
  @override String addedToCart(String name, int qty) => '$qty × $name ಕಾರ್ಟ್‌ಗೆ ಸೇರಿಸಲಾಗಿದೆ';
  @override String get addToCartBtn       => 'ಕಾರ್ಟ್‌ಗೆ ಸೇರಿಸಿ  — ';
  @override String get aboutFarm          => 'ಹೊಲದ ಬಗ್ಗೆ';
  @override String get specialisesIn      => 'ವಿಶೇಷತೆ';
  @override String get rating             => 'ರೇಟಿಂಗ್';
  @override String get reviewsLabel       => 'ವಿಮರ್ಶೆಗಳು';
  @override String get productsLabel      => 'ಉತ್ಪನ್ನಗಳು';
  @override String get active             => 'ಸಕ್ರಿಯ';
  @override String get byOwner            => 'ಇಂದ ';
  @override String get verified           => 'ಪರಿಶೀಲಿಸಲಾಗಿದೆ';
  @override String get user               => 'ಬಳಕೆದಾರ';
  @override String itemsCount(int n)      => '$n ವಸ್ತುಗಳು';
  @override String get catAll             => 'ಎಲ್ಲಾ';
  @override String get catVegetables      => 'ತರಕಾರಿಗಳು';
  @override String get catFruits          => 'ಹಣ್ಣುಗಳು';
  @override String get catDairy           => 'ಹಾಲಿನ ಉತ್ಪನ್ನಗಳು';
  @override String get catGrains          => 'ಧಾನ್ಯಗಳು';
  @override String get catHoney           => 'ಜೇನುತುಪ್ಪ';
  @override String get prodHeirloomTomatoes    => 'ದೇಶಿ ಟೊಮ್ಯಾಟೊ';
  @override String get prodBabySpinach         => 'ಪಾಲಕ್';
  @override String get prodOrganicStrawberries => 'ಸಾವಯವ ಸ್ಟ್ರಾಬೆರಿ';
  @override String get prodFreeRangeEggs       => 'ನಾಟಿ ಕೋಳಿ ಮೊಟ್ಟೆ';
  @override String get prodPaneer              => 'ಪನೀರ್';
  @override String get prodRawForestHoney      => 'ಕಾಡಿನ ಜೇನು';
  @override String get prodFreshCarrots        => 'ತಾಜಾ ಕ್ಯಾರೆಟ್';
  @override String get prodWholeWheatAtta      => 'ಗೋಧಿ ಹಿಟ್ಟು';
  // ── Farmer Registration ──────────────────────────────────────
  @override String get phone              => 'ಫೋನ್ ಸಂಖ್ಯೆ';
  @override String get email              => 'ಇಮೇಲ್ ವಿಳಾಸ';
  @override String get farmName           => 'ಫಾರ್ಮ್ ಹೆಸರು';
  @override String get location           => 'ಸ್ಥಳ / ಗ್ರಾಮ';
  @override String get category           => 'ಪ್ರಾಥಮಿಕ ವರ್ಗ';
  @override String get bio                => 'ನಿಮ್ಮ ಫಾರ್ಮ್ ಬಗ್ಗೆ';
  @override String get aadhaarNumber      => 'ಆಧಾರ್ ಸಂಖ್ಯೆ';
  @override String get passbookNumber     => 'ಫಾರ್ಮ್ ಪಾಸ್‌ಬುಕ್ ಸಂಖ್ಯೆ';
  @override String get declaration        => 'ಸಲ್ಲಿಸಿದ ಎಲ್ಲಾ ಮಾಹಿತಿ ಮತ್ತು ದಾಖಲೆಗಳು ನಿಜವಾದವು ಎಂದು ನಾನು ಘೋಷಿಸುತ್ತೇನೆ ಮತ್ತು Farmsetu ಮತ್ತು ಸರ್ಕಾರಿ ಅಧಿಕಾರಿಗಳಿಗೆ ಅವುಗಳನ್ನು ಪರಿಶೀಲಿಸಲು ಅಧಿಕಾರ ನೀಡುತ್ತೇನೆ.';
  @override String get submitApplication  => 'ನೋಂದಣಿ ಸಲ್ಲಿಸಿ';
  @override String get next               => 'ಮುಂದೆ';
  @override String get back               => 'ಹಿಂದೆ';
}

// ═════════════════════════════════════════════════════════════
// MARATHI
// ═════════════════════════════════════════════════════════════
class _Marathi extends AppLocalizations {
  @override String get appName            => 'Farmsetu';
  @override String get welcomeBack        => 'पुन्हा स्वागत आहे';
  @override String get signInToAccount    => 'आपल्या खात्यात साइन इन करा';
  @override String get emailAddress       => 'ईमेल पत्ता';
  @override String get password           => 'पासवर्ड';
  @override String get signIn             => 'साइन इन';
  @override String get emailRequired      => 'ईमेल आवश्यक आहे';
  @override String get enterValidEmail    => 'वैध ईमेल प्रविष्ट करा';
  @override String get passwordRequired   => 'पासवर्ड आवश्यक आहे';
  @override String get atLeast6Chars      => 'किमान 6 अक्षरे आवश्यक आहेत';
  @override String get invalidCredentials => 'चुकीची माहिती. पुन्हा प्रयत्न करा.';
  @override String get newToFarmsetu      => 'Farmsetu वर नवीन आहात? ';
  @override String get createAccount      => 'खाते तयार करा';
  @override String get demoHint           => 'डेमो: कोणताही ईमेल + 6+ अक्षरे';
  @override String get fullName           => 'पूर्ण नाव';
  @override String get nameRequired       => 'नाव आवश्यक आहे';
  @override String get confirmPassword    => 'पासवर्ड पुष्टी करा';
  @override String get passwordsNoMatch   => 'पासवर्ड जुळत नाहीत';
  @override String get minimum6Chars      => 'किमान 6 अक्षरे';
  @override String get joinFarmsetu       => 'Farmsetu मध्ये सामील व्हा आणि ताजे उत्पादन खरेदी करा.';
  @override String get alreadyHaveAccount => 'आधीच खाते आहे? ';
  @override String get signInLink         => 'साइन इन';
  @override String get registrationFailed => 'नोंदणी अयशस्वी. पुन्हा प्रयत्न करा.';
  @override String get navHome            => 'होम';
  @override String get navFarms           => 'शेते';
  @override String get navCart            => 'कार्ट';
  @override String get navProfile         => 'प्रोफाइल';
  @override String get hello              => 'नमस्कार, ';
  @override String get findFreshProduce   => 'ताजे उत्पादन शोधा';
  @override String get searchHint         => 'उत्पादने, शेते शोधा…';
  @override String get featuredFarms      => 'विशेष शेते';
  @override String get allProducts        => 'सर्व उत्पादने';
  @override String get searchResults      => 'शोध निकाल';
  @override String get items              => 'वस्तू';
  @override String get noProductsFound    => 'उत्पादने सापडली नाहीत';
  @override String get tryDifferentSearch => 'वेगळी श्रेणी किंवा शोध शब्द वापरा';
  @override String get reviews            => 'पुनरावलोकने';
  @override String get allFarms           => 'सर्व शेते';
  @override String get myOrders           => 'माझे ऑर्डर';
  @override String get savedProducts      => 'जतन केलेली उत्पादने';
  @override String get deliveryAddress    => 'डिलिव्हरी पत्ता';
  @override String get notifications      => 'सूचना';
  @override String get helpSupport        => 'मदत आणि समर्थन';
  @override String get signOut            => 'साइन आउट';
  @override String get language           => 'भाषा';
  @override String get selectLanguage     => 'भाषा निवडा';
  @override String get settings           => 'सेटिंग्ज';
  @override String get settingsLanguage   => 'भाषा';
  @override String get settingsAppearance => 'स्वरूप';
  @override String get settingsAccount    => 'खाते';
  @override String get settingsAbout      => 'बद्दल';
  @override String get settingsVersion    => 'आवृत्ती 1.0.0';
  @override String get settingsDarkMode   => 'डार्क मोड';
  @override String get settingsNotifications => 'पुश नोटिफिकेशन';
  @override String get settingsPrivacyPolicy => 'गोपनीयता धोरण';
  @override String get settingsTerms      => 'सेवा अटी';
  @override String get myCart             => 'माझी कार्ट';
  @override String get clearAll           => 'सर्व काढा';
  @override String get clearCartTitle     => 'कार्ट रिकामी करायची?';
  @override String get allItemsRemoved    => 'सर्व वस्तू काढल्या जातील.';
  @override String get cancel             => 'रद्द करा';
  @override String get clear              => 'काढा';
  @override String get orderPlaced        => 'ऑर्डर दिला गेला!';
  @override String get orderPlacedMsg     => 'तुमचा ऑर्डर यशस्वीरित्या दिला गेला.\n(डेमो — खरी देयक नाही.)';
  @override String get done               => 'झाले';
  @override String get placeOrder         => 'ऑर्डर द्या';
  @override String get subtotal           => 'उप-एकूण';
  @override String get deliveryFee        => 'डिलिव्हरी शुल्क';
  @override String get total              => 'एकूण';
  @override String get yourCartEmpty      => 'तुमची कार्ट रिकामी आहे';
  @override String get addProductsToStart => 'सुरू करण्यासाठी उत्पादने जोडा';
  @override String subtotalWithCount(int n) => 'उप-एकूण ($n वस्तू)';
  @override String get aboutProduct       => 'या उत्पादनाबद्दल';
  @override String get fromTheFarm        => 'शेतातून';
  @override String get organic            => 'सेंद्रिय';
  @override String get addToCart          => 'कार्टमध्ये जोडा';
  @override String get viewCart           => 'कार्ट पहा';
  @override String addedToCart(String name, int qty) => '$qty × $name कार्टमध्ये जोडले';
  @override String get addToCartBtn       => 'कार्टमध्ये जोडा  — ';
  @override String get aboutFarm          => 'शेताबद्दल';
  @override String get specialisesIn      => 'विशेषता';
  @override String get rating             => 'रेटिंग';
  @override String get reviewsLabel       => 'पुनरावलोकने';
  @override String get productsLabel      => 'उत्पादने';
  @override String get active             => 'सक्रिय';
  @override String get byOwner            => 'द्वारा ';
  @override String get verified           => 'सत्यापित';
  @override String get user               => 'वापरकर्ता';
  @override String itemsCount(int n)      => '$n वस्तू';
  @override String get catAll             => 'सर्व';
  @override String get catVegetables      => 'भाज्या';
  @override String get catFruits          => 'फळे';
  @override String get catDairy           => 'दुग्धजन्य';
  @override String get catGrains          => 'धान्य';
  @override String get catHoney           => 'मध';
  @override String get prodHeirloomTomatoes    => 'देशी टोमॅटो';
  @override String get prodBabySpinach         => 'पालक';
  @override String get prodOrganicStrawberries => 'सेंद्रिय स्ट्रॉबेरी';
  @override String get prodFreeRangeEggs       => 'देशी अंडी';
  @override String get prodPaneer              => 'पनीर';
  @override String get prodRawForestHoney      => 'जंगली मध';
  @override String get prodFreshCarrots        => 'ताजी गाजर';
  @override String get prodWholeWheatAtta      => 'गव्हाचे पीठ';
  // ── Farmer Registration ──────────────────────────────────────
  @override String get phone              => 'फोन नंबर';
  @override String get email              => 'ईमेल पत्ता';
  @override String get farmName           => 'शेताचे नाव';
  @override String get location           => 'ठिकाण / गाव';
  @override String get category           => 'मुख्य श्रेणी';
  @override String get bio                => 'तुमच्या शेताबद्दल';
  @override String get aadhaarNumber      => 'आधार क्रमांक';
  @override String get passbookNumber     => 'शेत पासबुक क्रमांक';
  @override String get declaration        => 'मी घोषित करतो/करते की सादर केलेली सर्व माहिती आणि कागदपत्रे सत्य आहेत आणि मी Farmsetu आणि सरकारी अधिकाऱ्यांना ती तपासण्याचा अधिकार देतो/देते.';
  @override String get submitApplication  => 'नोंदणी सादर करा';
  @override String get next               => 'पुढे';
  @override String get back               => 'मागे';
}