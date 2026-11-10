#![doc = include_str!("../README.md")]

use regex::RegexSet;
use serde::Deserialize;
use std::sync::LazyLock;

#[derive(Debug, Deserialize)]
#[non_exhaustive]
pub struct Crawler {
    pub pattern: String,
    pub description: String,
    pub url: Option<String>,
    pub tags: Vec<String>,
}

static CRAWLERS: LazyLock<Vec<Crawler>> = LazyLock::new(|| {
    serde_json::from_str(include_str!("../data/crawler-user-agents.json"))
        .expect("embedded crawler list is valid JSON")
});

static PATTERNS: LazyLock<RegexSet> = LazyLock::new(|| {
    RegexSet::new(CRAWLERS.iter().map(|crawler| &crawler.pattern))
        .expect("embedded crawler patterns compile")
});

/// Returns every crawler in the embedded list.
pub fn crawlers() -> &'static [Crawler] {
    &CRAWLERS
}

/// Returns whether `user_agent` matches any crawler pattern.
///
/// Matching is case-sensitive.
pub fn is_crawler(user_agent: &str) -> bool {
    PATTERNS.is_match(user_agent)
}

/// Returns the crawlers whose patterns match `user_agent`.
///
/// Matching is case-sensitive.
pub fn matching_crawlers(user_agent: &str) -> impl Iterator<Item = &'static Crawler> {
    PATTERNS
        .matches(user_agent)
        .into_iter()
        .map(|index| &CRAWLERS[index])
}
