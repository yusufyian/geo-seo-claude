# ftmoon.com GEO 实施清单

## 1. 立即上线文件

将以下文件部署到网站根目录：

- `public/robots.txt` -> `https://www.ftmoon.com/robots.txt`
- `public/llms.txt` -> `https://www.ftmoon.com/llms.txt`
- `public/sitemap.xml` -> `https://www.ftmoon.com/sitemap.xml`

上线后验证：

```bash
curl -I https://www.ftmoon.com/robots.txt
curl -I https://www.ftmoon.com/llms.txt
curl -I https://www.ftmoon.com/sitemap.xml
```

预期结果均为 `200 OK`。

## 2. 首页 HTML 必须服务端可见

当前 audit 显示首页初始 HTML 只有极少文本，疑似客户端渲染。需要确保 `curl https://www.ftmoon.com` 能看到：

- `h1`: 申达链 FTMoon 企业级区块链应用解决方案平台
- 至少 800-1200 字正文
- 首页导航链接
- FAQ 内容
- JSON-LD Schema

验收命令：

```bash
curl -s https://www.ftmoon.com | wc -w
curl -s https://www.ftmoon.com | grep -i "application/ld+json"
curl -s https://www.ftmoon.com | grep "申达链是什么"
```

## 3. Head 标签

首页 `<head>` 至少包含：

```html
<meta charset="utf-8" />
<title>申达链 FTMoon - 企业级区块链应用解决方案平台</title>
<meta name="description" content="申达链 FTMoon 面向企业和机构提供区块链应用解决方案，支持可信存证、数据协同、智能合约、链上追溯和多方业务协作，帮助企业构建可验证、可审计、可追溯的数字化信任基础。" />
<link rel="canonical" href="https://www.ftmoon.com/" />
```

## 4. JSON-LD

将 `schema/homepage-jsonld.json` 以如下形式加入首页 HTML：

```html
<script type="application/ld+json">
{...}
</script>
```

注意事项：

- 必须出现在初始 HTML 中，不要只靠客户端 JS 注入。
- 上线后用 Google Rich Results Test 和 Schema Markup Validator 检查。
- 如果有 logo、社媒、公司全称、地址、客服电话，补进 `Organization`。

## 5. 建议新增页面

第一批页面：

- `/solutions`
- `/product`
- `/use-cases`
- `/faq`
- `/about`
- `/contact`

每页要求：

- 唯一 `title`
- 唯一 `meta description`
- 一个 `h1`
- 3-6 个 `h2`
- 600 字以上可抓取正文
- 至少 3 个内部链接
- 对应 sitemap 条目

## 6. Nginx 安全头建议

可加入 Nginx server block：

```nginx
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-Frame-Options "SAMEORIGIN" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Permissions-Policy "geolocation=(), microphone=(), camera=()" always;
```

如站点存在第三方脚本，再单独设计 Content-Security-Policy。

## 7. 重新审计标准

完成以上改造后，重新运行：

```bash
python3 scripts/fetch_page.py https://www.ftmoon.com full
python3 scripts/citability_scorer.py https://www.ftmoon.com
python3 scripts/llmstxt_generator.py https://www.ftmoon.com validate
```

阶段性目标：

- 首页 `word_count` >= 800
- `has_ssr_content` = true
- `structured_data` >= 1
- `llms_txt.exists` = true
- `robots.exists` = true
- citability 至少出现 5 个内容块

