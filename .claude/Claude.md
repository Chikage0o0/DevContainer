## 语言规范

- 所有对话和文档都使用简体中文
- 所有代码使用中文注释
- 文档使用 markdown 格式

## 命名规范

### 命名主要要求（动词 + 名词 固定搭配）

- 函数/方法：使用「动词+名词」模式，表达动作和对象（Python 使用 snake_case，JS/TS 使用 camelCase）。
  - 示例（Python）：`get_user`、`create_order`、`delete_cache`
  - 示例（JS/TS） ：`getUser`、`createOrder`、`deleteCache`
- 布尔值变量：以 `is` / `has` / `can` 开头，后跟名词或形容词（例如 `is_active`、`has_errors`、`can_retry`）。
- 变量/属性：使用名词或名词短语；集合类型使用复数（例如 `users`, `order_items`）。
- 类/类型：使用名词或名词短语的 PascalCase（例如 `UserManager`, `OrderService`）。
- 常量：使用 UPPER_SNAKE_CASE（例如 `MAX_RETRIES`、`DEFAULT_TIMEOUT_MS`）。
- 事件/回调：使用 `handle` 或 `on` 前缀（例如 `handle_click`, `onUserCreated`）。
- REST/HTTP 路径：在 URL 中用名词表示资源，HTTP 方法表示动作（例如 `GET /users`、`POST /users`）。

> 规则要点：函数/方法总以动词开头、变量/类以名词为主，布尔前缀统一，集合使用复数。

### 命名建议（按语言）

- Python
  - 变量、函数使用 snake_case，例如 `get_user_info`。
  - 类使用 PascalCase，例如 `UserManager`。
  - 常量使用 UPPER_SNAKE_CASE，例如 `MAX_RETRIES`。
- JavaScript / TypeScript
  - 变量与函数使用 camelCase，例如 `getUserInfo`。
  - 类使用 PascalCase，例如 `UserManager`。
  - 常量使用 UPPER_SNAKE_CASE 或 `const`，例如 `MAX_RETRIES`。
- Shell / 脚本
  - 变量使用小写并用下划线分隔，例如 `user_name`。

## 代码风格与格式化

- 使用自动化格式化工具（如 Prettier、Black、gofmt 等）统一风格。
- 配置并运行静态检查器（如 ESLint、pylint、golangci-lint 等），确保无明显错误和风格问题。

## 注释与文档

- 所有注释使用简体中文，代码注释应准确描述「为什么」而非「怎么做」。
- 函数与类必须包含 docstring/注释，说明用途、参数与返回值。

### 注释标签

- 使用 `TODO:`、`FIXME:` 添加未来需处理的项。
- 对安全相关的代码块要写明风险、输入限制与防御措施。
