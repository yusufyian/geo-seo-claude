# ftmoon.com GEO 升级包

生成日期：2026-05-18

## 当前问题

GEO quick audit 显示 `https://www.ftmoon.com` 当前主要问题是 AI crawler 能访问站点，但初始 HTML 几乎没有可读取正文。首页没有 H1、内容块、JSON-LD、robots.txt、sitemap.xml 或 llms.txt，因此 AI 搜索系统难以理解、引用和推荐该站点。

## 文件结构

- `public/robots.txt`: 可部署到站点根目录的 crawler 指引文件
- `public/llms.txt`: 可部署到站点根目录的 AI 内容导航文件
- `public/sitemap.xml`: 第一版 sitemap，包含建议新增页面
- `schema/homepage-jsonld.json`: 首页 Organization、WebSite、Service、FAQPage JSON-LD
- `content/homepage-geo-copy.md`: 首页 GEO 改造文案
- `docs/implementation-checklist.md`: 开发上线清单和验收命令
- `docs/developer-snippets.md`: Next.js / HTML 接入示例

## 推荐执行顺序

1. 部署 `robots.txt`、`llms.txt`、`sitemap.xml`。
2. 将首页改为 SSR 或预渲染，确保 `curl https://www.ftmoon.com` 可看到正文。
3. 使用 `content/homepage-geo-copy.md` 重构首页内容。
4. 将 `schema/homepage-jsonld.json` 注入首页初始 HTML。
5. 新增 `/solutions`、`/product`、`/use-cases`、`/faq`、`/about`、`/contact`。
6. 上线后重新运行 GEO quick audit。

## 第一阶段验收标准

- `https://www.ftmoon.com/robots.txt` 返回 `200`
- `https://www.ftmoon.com/llms.txt` 返回 `200`
- `https://www.ftmoon.com/sitemap.xml` 返回 `200`
- 首页初始 HTML 有 `h1`
- 首页初始 HTML 有至少 800 字正文
- 首页初始 HTML 有 `application/ld+json`
- citability scorer 至少识别 5 个内容块

