# Demos

基本规则：

1. 你需要一个page作为出发点
2. 一个page可以包含多个section
3. 一个section可以包含
  * 多个嵌套的section
  * 多个cards
4. card可以是：
  - [x] Markdown
  - [ ] Julia
  - [ ] URL

流程：将`docs/demos`处理完后保存到`docs/src/democards`里

```text
docs
├── build
├── demos
├── make.jl
└── src
    ├── democards # generated
    └── index.md
```
