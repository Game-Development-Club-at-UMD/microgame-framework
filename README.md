# Contributing Guide

This guide walks you through forking this repo, working on it locally in Godot,
and submitting your changes back as a pull request, all using GitHub Desktop.

## Before You Start

Make sure you have installed:

- [GitHub Desktop](https://desktop.github.com/)
- [Godot](https://godotengine.org/download) (latest version)
- A [GitHub account](https://github.com/join), signed into GitHub Desktop
  (File > Options > Accounts on Windows, GitHub Desktop > Settings > Accounts on
  Mac)

## Step 1: Fork the Repo

1. Open this repo's page on GitHub in your browser.
2. Click the **Fork** button in the top right corner.
3. This creates your own copy of the repo under your GitHub account (e.g.
   `github.com/YOUR-USERNAME/repo-name`).

You now have your own fork. All of your work will happen here, not on the
original repo.

## Step 2: Clone Your Fork Locally

Forking only creates a copy on GitHub's servers. You need to clone your fork
onto your own computer to actually work on it.

1. On your forked repo's GitHub page, click the green **Code** button, then
   click **Open with GitHub Desktop**.
2. GitHub Desktop will open and show a **Clone a repository** window with your
   fork already filled in.
3. Choose a **Local Path** on your computer (this is the folder your project
   files will live in), then click **Clone**.

Your fork is now downloaded to that folder. From now on, all your local work
happens inside it.

## Step 3: Open the Project in Godot

1. Open Godot.
2. Click **Import**.
3. Navigate to the local folder GitHub Desktop just cloned your fork into, and
   select the `project.godot` file inside it.
4. Click **Import & Edit**.

The project will open in the Godot editor, pointed at your local clone. Any
changes you make in the editor are saved to files inside that folder.

## Step 4: Create a Branch

Before making changes, create a new branch instead of working directly on
`main`. This keeps your changes organized and makes your pull request easier to
review.

1. In GitHub Desktop, click **Current Branch** in the top toolbar.
2. Click **New Branch**.
3. Give it a short, descriptive name, e.g. `fix-player-jump` or `add-enemy-ai`.
4. Click **Create Branch**.

GitHub Desktop will automatically switch you to this new branch.

## Step 5: Make Your Changes and Commit

Work on the project in Godot as normal. As you save files, switch back to GitHub
Desktop and you'll see your changes listed on the left under **Changes**.

1. Review the list of changed files. Uncheck anything you don't want to include
   in this commit.
2. At the bottom left, write a **Summary** describing what you changed, and an
   optional longer description.
3. Click **Commit to your-branch-name**.

You can repeat this as many times as you like while you work.

## Step 6: Push Your Branch to Your Fork

Once you're ready to share your work, push your branch up to your fork on
GitHub.

1. In GitHub Desktop, click **Push origin** in the top toolbar.
2. This uploads your branch and commits to your fork on GitHub, not the original
   repo.

## Step 7: Open a Pull Request Back to the Original Repo

Making changes on your fork does not reflect on the original souce repo. To get
your changes merged into the original project, you need to open a pull request
between your fork and the
[original repo](https://github.com/Game-Development-Club-at-UMD/microgame-framework).

1. In GitHub Desktop, after pushing, click **Create Pull Request** in the top
   toolbar. This opens a new PR page on GitHub in your browser.
2. At the top of the PR page are two dropdowns. This is the part that trips
   people up, so check both carefully:
   - **Base repository** (left side): this must be set to the original repo, not
     your fork, on branch `main`. This is the destination, where your changes
     will end up if merged.
   - **Head repository** (right side): this should already be set to your fork,
     on the branch you just pushed. This is the source, where your changes are
     coming from.
3. If GitHub Desktop opened the comparison against the wrong repo or branch, use
   the dropdowns to correct them before continuing. You should see a green
   **Able to merge** message once the base and head are set correctly and your
   branch has real differences from `main`.
4. Scroll down to confirm the diff shown is actually your intended changes.
5. Write a clear title and description explaining what you changed and why.
6. Click **Create pull request**.

Your pull request now exists on the original repo, not your fork. A maintainer
will review it there, may leave comments or request changes, and will merge it
into the original repo once it's ready. Note that merging does not update your
fork automatically, if you plan to keep contributing after this PR is merged,
you'll want to sync your fork with the original repo before starting new work
(GitHub Desktop's **Fetch origin** / **repository sync** options handle this).

## Notes on the .gitignore

This repo's `.gitignore` already excludes Godot-specific files that shouldn't be
committed, such as the `.godot/` cache folder and import artifacts. You
generally don't need to touch these files or add them manually. If Godot
generates new files in your working folder that aren't showing up in GitHub
Desktop's **Changes** list, that's expected, they're being ignored on purpose.
