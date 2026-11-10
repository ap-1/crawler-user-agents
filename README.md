# crawler-user-agents

Detect crawlers and bots by `User-Agent` using the patterns from [monperrus/crawler-user-agents](https://github.com/monperrus/crawler-user-agents).

## Usage

```rust
let user_agent = "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)";

assert!(crawler_user_agents::is_crawler(user_agent));

for crawler in crawler_user_agents::matching_crawlers(user_agent) {
    println!("{} {:?}", crawler.pattern, crawler.tags);
}
```

## License

Licensed under either of

- [Apache License, Version 2.0](LICENSE-APACHE-2.0)
- [MIT License](LICENSE-MIT)

at your option.

The crawler list in `data/crawler-user-agents.json` comes from [monperrus/crawler-user-agents](https://github.com/monperrus/crawler-user-agents) and is licensed under the [MIT License](data/LICENSE).
