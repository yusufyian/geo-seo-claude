# 开发接入片段

## React / Vite 静态站点

如果当前是 Vite SPA，最直接的 GEO 修复是把首页改为预渲染或迁移到 SSR 框架。短期可以使用静态 `index.html` 放入核心正文，React 接管后保持内容不被清空。

关键原则：

- 不要只在 `#root` 里运行时渲染全部正文。
- 初始 HTML 中必须包含主要营销文案、FAQ、内部链接和 JSON-LD。
- 如果使用 React Helmet，确认最终生产 HTML 里已经有 head 标签，而不是仅浏览器运行后出现。

## Next.js 示例

```tsx
export const metadata = {
  title: "申达链 FTMoon - 企业级区块链应用解决方案平台",
  description:
    "申达链 FTMoon 面向企业和机构提供区块链应用解决方案，支持可信存证、数据协同、智能合约、链上追溯和多方业务协作，帮助企业构建可验证、可审计、可追溯的数字化信任基础。",
  alternates: {
    canonical: "https://www.ftmoon.com/",
  },
};

import schema from "../schema/homepage-jsonld.json";

export default function HomePage() {
  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }}
      />
      <main>
        <h1>申达链 FTMoon 企业级区块链应用解决方案平台</h1>
        <section>
          <h2>申达链是什么？</h2>
          <p>申达链 FTMoon 是一个企业级区块链应用解决方案平台...</p>
        </section>
      </main>
    </>
  );
}
```

## 普通 HTML 示例

```html
<!doctype html>
<html lang="zh-CN">
  <head>
    <meta charset="utf-8" />
    <title>申达链 FTMoon - 企业级区块链应用解决方案平台</title>
    <meta name="description" content="申达链 FTMoon 面向企业和机构提供区块链应用解决方案，支持可信存证、数据协同、智能合约、链上追溯和多方业务协作，帮助企业构建可验证、可审计、可追溯的数字化信任基础。" />
    <link rel="canonical" href="https://www.ftmoon.com/" />
    <script type="application/ld+json">
      {}
    </script>
  </head>
  <body>
    <main>
      <h1>申达链 FTMoon 企业级区块链应用解决方案平台</h1>
      <section>
        <h2>申达链是什么？</h2>
        <p>申达链 FTMoon 是一个企业级区块链应用解决方案平台，面向企业、机构和产业平台提供可信存证、数据协同、智能合约和链上追溯能力。</p>
      </section>
    </main>
  </body>
</html>
```

