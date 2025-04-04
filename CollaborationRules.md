# Collaboration Rules | ABC Programming Language

## 1. Branching Strategy

We will only use **two branches** to keep things simple (and avoid f*cking up the project):

`main` -> The stable branch development containing tested and working code.
`development` -> The working branch where all changes are made before merging into main.

All work should be done in `development` first, then merged into `main` when it' stable.

---

## 2. Process for Uploading Changes

### 2.1 Clone the Repository (First-Time Setup)

if you haven't cloned the repo yet, run:

```
git clone https://github.com/CrisMedL/ABC-ProgrammingLanguage.git
cd ABC-ProgrammingLanguage
```

Make sure you're working inside the clone folder.

### 2.2 Pull Latest Changes Before Working

Before making any changes, always update your local copy:

```
git checkout development  # Switch to the development branch
git pull origin development  # Get the latest changes

```

### 2.3 Make Changes Locally

Edit or add your files as needed. Once done, check which files were modified:

`git status`

### 2.4 Stage, Commit, and Push Changes

After confirming your changes, and and commit them:

```
git add .
git commit -m "Describe your changes here"
git push origin development
 ```

 ### 2.5 Merging  `development` into `main`.

Once the work is tested and stable, we merge `development` into `main`:


```
git checkout main
git pull origin main  # Ensure main is up to date
git merge development  # Merge latest development work
git push origin main  # Push the updated main branch
git checkout development  # Switch back to development
```