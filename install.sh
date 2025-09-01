#!/bin/sh

REPO_URL="https://github.com/whiteleaf7/narou.git"
COMMIT_ID="27fb741fd561e2f26aba9fdf9d9b7b4384792be4"

# PR を fetch して squash merge する関数
merge_pr() {
    PR_NUMBER="$1"

    if [ -z "$PR_NUMBER" ]; then
        echo "Usage: merge_pr <PR_NUMBER>"
        return 1
    fi

    # fetch
    git fetch origin pull/"$PR_NUMBER"/head:pr-"$PR_NUMBER"
    if [ $? -ne 0 ]; then
        echo "Failed to fetch PR #$PR_NUMBER"
        return 1
    fi

    # squash merge
    git merge --squash pr-"$PR_NUMBER"
    if [ $? -ne 0 ]; then
        echo "Failed to merge PR #$PR_NUMBER"
        return 1
    fi

    echo "PR #$PR_NUMBER has been squashed into current branch"
}


# リポジトリを clone
git clone $REPO_URL
cd narou
git checkout $COMMIT_ID

# プルリクエストを取り込み
merge_pr 444
merge_pr 446

# gem パッケージを作る
gem build narou.gemspec

# ローカルにインストール
gem install narou-*.gem
