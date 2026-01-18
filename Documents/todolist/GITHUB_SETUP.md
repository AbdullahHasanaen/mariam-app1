# تعليمات رفع تطبيق مريم على GitHub

## الخطوات المطلوبة:

### 1. إنشاء مستودع جديد على GitHub

1. افتح [GitHub](https://github.com) وسجّل الدخول
2. انقر على زر "+" في أعلى الصفحة واختر "New repository"
3. أدخل اسم المستودع: `mariam-app` أو `تطبيق-مريم` (أو أي اسم تريده)
4. اختر "Private" أو "Public" حسب رغبتك
5. **لا تختر** "Initialize this repository with a README" (لأن لدينا ملفات بالفعل)
6. انقر "Create repository"

### 2. تهيئة Git في المشروع

افتح Terminal وانتقل إلى مجلد المشروع:

```bash
cd /Users/abdullahhasanaen/Documents/todolist
```

قم بتنفيذ الأوامر التالية:

```bash
# تهيئة مستودع git (إذا لم يكن موجوداً)
git init

# إضافة جميع الملفات
git add .

# إنشاء commit أولي
git commit -m "Initial commit: تطبيق مريم - Task Reminder & Fitness Coach"

# ربط المشروع بمستودع GitHub (استبدل YOUR_USERNAME و REPO_NAME)
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git

# أو إذا كنت تستخدم SSH:
# git remote add origin git@github.com:YOUR_USERNAME/REPO_NAME.git

# تغيير اسم الفرع إلى main (إذا لزم الأمر)
git branch -M main

# رفع الملفات إلى GitHub
git push -u origin main
```

### 3. مثال كامل:

```bash
cd /Users/abdullahhasanaen/Documents/todolist
git init
git add .
git commit -m "Initial commit: تطبيق مريم - تطبيق iOS لتنظيم المهام واللياقة البدنية"
git remote add origin https://github.com/YOUR_USERNAME/mariam-app.git
git branch -M main
git push -u origin main
```

### 4. إذا واجهت مشكلة في المصادقة:

إذا طُلب منك اسم المستخدم وكلمة المرور:

**للحصول على Personal Access Token:**
1. اذهب إلى GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. انقر "Generate new token"
3. اختر الصلاحيات: `repo` (Full control of private repositories)
4. انسخ الرمز واستخدمه ككلمة مرور عند الدفع

**أو استخدم SSH:**
```bash
# توليد مفتاح SSH (إذا لم يكن موجوداً)
ssh-keygen -t ed25519 -C "your_email@example.com"

# ثم أضف المفتاح العام إلى GitHub:
# Settings → SSH and GPG keys → New SSH key
```

### 5. معلومات إضافية للمستودع:

**اسم المستودع المقترح:** `mariam-app` أو `mariam` أو `تطبيق-مريم`

**الوصف المقترح:**
```
تطبيق iOS لتنظيم المهام واللياقة البدنية - Flutter offline-first app with Task Reminder and Personal Fitness Coach
```

**المواضيع (Topics) المقترحة:**
- flutter
- ios
- offline-first
- task-manager
- fitness-app
- sqlite
- localization

---

**ملاحظة:** استبدل `YOUR_USERNAME` و `REPO_NAME` بمعلوماتك الفعلية من GitHub.
