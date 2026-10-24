# 我的个人静态博客

基于 **Hugo + GitHub Pages + GitHub Actions** 的静态博客。用 Markdown 写作，推送到 GitHub 即自动部署。

## 目录结构

```
my-blog/
├── config.toml            # 站点配置（标题、菜单、评论等）
├── archetypes/default.md  # 新建文章的 front matter 模板
├── content/
│   ├── posts/             # ← 你日常只在这里写 .md
│   └── about.md           # 关于页
├── themes/PaperMod/       # 主题（git 子模块）
├── static/               # 图片等静态资源
├── .github/workflows/    # 自动部署流水线
├── sync.sh               # 一键发布脚本
└── README.md
```

## 一、本地环境准备

1. 安装 **Hugo（extended 版）**
   - 方式 A（推荐，无需 Homebrew）：下载官方安装包
     `https://github.com/gohugoio/hugo/releases/download/v0.168.0/hugo_extended_0.168.0_darwin-universal.pkg`
     双击安装即可（会装到 `/usr/local/bin/hugo`）。若提示“无法验证开发者”，在「系统设置 → 隐私与安全性」点“仍要打开”，或先执行：
     `xattr -d com.apple.quarantine ~/Downloads/hugo_extended_0.168.0_darwin-universal.pkg`
   - 方式 B（已有 Homebrew）：`brew install hugo`
   - 命令行一键安装法（下载后用 installer 安装）：
     ```bash
     curl -L -o ~/Downloads/hugo.pkg https://github.com/gohugoio/hugo/releases/download/v0.168.0/hugo_extended_0.168.0_darwin-universal.pkg
     sudo installer -pkg ~/Downloads/hugo.pkg -target /
     ```
   - 校验：`hugo version`（建议 ≥ 0.168.0，与 deploy.yml 中 HUGO_VERSION 一致）。
2. 安装 **MarkText**：https://marktext.github.io/website/ （写作编辑器，本项目用它写 .md）。
3. 安装 **Git**（macOS 一般自带）。

## 二、本地预览（写的时候看效果）

在项目根目录运行：

```bash
hugo server -D --navigateToUpdatedFiles
```

浏览器打开 **http://localhost:1313/ZL-blog/** ⚠️ 注意：因为 `baseURL` 带子路径 `/ZL-blog`，`hugo server` 会在该子路径下提供服务，访问 `http://localhost:1313` 根路径会显示 404，这是正常的。

在 MarkText 里保存 `.md`，页面会**自动热重载**。
> 注意：MarkText 自带的预览 ≠ 博客最终样式，以 `hugo server` 为准。

## 三、用 MarkText 写作

1. 打开 MarkText →「打开文件夹」→ 选择本项目的 `content/posts/`。
2. 新建文件 `YYYY-MM-DD-标题.md`，头部 front matter 可手写，或用命令生成：

   ```bash
   hugo new content posts/2026-10-24-我的文章.md
   ```

3. 正文用 Markdown 写，保存即写入仓库真实文件。

## 四、发布（手动同步）

写完确认 `draft: false` 后，在项目根目录运行：

```bash
./sync.sh "发布说明"
```

它会 `git add -A && commit && push`，GitHub Actions 自动构建部署，1–2 分钟后上线。

## 五、连接到你自己的 GitHub 仓库

1. 在 GitHub 新建仓库（命名为 `ZL-blog`；访问地址为 `https://ghost-cai.github.io/ZL-blog/`）。
2. 本项目已 `git init`（分支 main），添加远程并推送：

   ```bash
   git remote add origin https://github.com/ghost-cai/ZL-blog.git
   git push -u origin main
   ```

3. 仓库 **Settings → Pages → Source 选择 "GitHub Actions"**。
4. 推送后到 Actions 标签页看构建，成功后访问 `https://ghost-cai.github.io/ZL-blog/`。

## 六、开始之前要改的占位符

- `config.toml` 的 `baseURL`、GitHub 链接已填入 `ghost-cai`；评论（Giscus）默认关闭，想要时取消注释并到 giscus.app 生成参数。
- 想用自定义域名：在域名商加 CNAME 指向 `ghost-cai.github.io`，并在 Pages 设置里填写并开启 Enforce HTTPS（也可放 `static/CNAME`）。

## 七、常用命令速查

| 目的 | 命令 |
| --- | --- |
| 本地预览 | `hugo server -D` |
| 新建文章 | `hugo new content posts/标题.md` |
| 发布 | `./sync.sh "说明"` |
| 本地生成静态文件 | `hugo --minify` |

## 八、纯网页发布（零命令、零额外服务）

不想装工具、不想碰终端时，直接用 GitHub 网页就能写文章并发布。因为项目已配好 Actions，只要往仓库 `content/posts/` 里提交 `.md`，就会自动构建上线。

### 发布一篇新文章

1. 打开 `https://github.com/ghost-cai/ZL-blog` → 进入 `content/posts` 目录。
2. 点右上角 **Add file → Create new file**。
3. 文件名填：`2026-10-25-我的文章.md`（日期-标题，英文或拼音，空格用 `-`）。
4. 内容照下面的模板写（**`draft: false` 才会被发布**）：

   ```markdown
   ---
   title: "我的文章标题"
   date: 2026-10-25T20:00:00+08:00
   draft: false
   tags: ["随笔"]
   ---

   正文从这里开始，支持 **加粗**、列表、代码块、图片等 Markdown 语法。
   图片放在 `static/images/` 后，用 `![图](/images/xxx.png)` 引用。
   ```

5. 页面底部 **Commit changes** 直接提交到 `main` 分支。
6. 等约 1–2 分钟，去仓库 **Actions** 看构建变绿，访问 `https://ghost-cai.github.io/ZL-blog/` 即可看到。

### 编辑 / 删除已有文章

- 在 `content/posts` 里点开某篇 `.md` → 右上角铅笔图标 ✏️ 即可改，改完 Commit。
- 删除：进文件后点 **··· → Delete file**，再 Commit。

> 小提示：网页里没有实时预览，发文后去博客页面确认样式即可。需要更精致的写作体验再回到「用 MarkText 写作 + 本地预览」方案。
