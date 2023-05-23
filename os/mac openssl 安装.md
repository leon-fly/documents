---
date: "2022-07-13"
draft: false
lastmod: "2022-07-13"
publishdate: "2022-07-13"
tags:
- os
- mac
title: mac openssl 1.0安装
---

# mac openssl 1.0安装

mac M1 芯片

```
curl -LO https://gist.github.com/minacle/e9dedb8c17025a23a453f8f30eced3da/raw/908b944b3fe2e9f348fbe8b8800daebd87b5966c/openssl@1.0.rb
curl -LO https://gist.github.com/minacle/e9dedb8c17025a23a453f8f30eced3da/raw/908b944b3fe2e9f348fbe8b8800daebd87b5966c/chntpw.rb
brew install --formula --build-from-source ./openssl@1.0.rb
brew install --formula --build-from-source ./chntpw.rb
```

[参考](https://github.com/sidneys/homebrew-homebrew/issues/2)
