# ffgan's blog

[blog.ffgan.com](https://blog.ffgan.com/) 的源文件。文章在 `content/blog/`，版式在子模块 `themes/cela`。图片放在 `img.ffgan.com`，不进这个仓库。

本地构建需要 [Zola 0.23.4](https://www.getzola.org/documentation/getting-started/installation/)：

```bash
git submodule update --init
zola check --skip-external-links
zola build
zola serve
```

`zola serve` 默认在 <http://127.0.0.1:1111>。Cloudflare Pages 读取 `wrangler.toml` 里的 `ZOLA_VERSION`。
