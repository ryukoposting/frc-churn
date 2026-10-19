# FRC Churn Rate

It’s easy to find stats about how many FRC teams there are. It’s also easy to
find stats about how many of them went away during the pandemic. But, where were
those teams concentrated? Besides the pandemic, how many teams exist on a
knife’s edge, managing to participate some years but not others? My research
attempts to answer these questions by calculating **churn rate.**

This repository contains the scripts that I use to generate churn rate data that
I post to [Chief Delphi] annually.

The bulk of the logic is written in Ruby. Chart generation relies on the
[gruff] gem.

The scripts are not meant to serve as a model of good programming practice. They
aren't. Rather, they are shared here for transparency. The scripts provide a
verifiable source of truth on how churn rate is calculated.

[Chief Delphi]: https://www.chiefdelphi.com
[gruff]: https://github.com/topfunky/gruff

# What is churn rate?

For the purposes of this research, here are the exact meanings assigned to some
terms:

- active team: Any team participating in the current season.
- veteran team: A team that is participating in the current season, AND
  participated in the previous season.
- rookie team: A team that is participating in the current season, AND has NOT
  participated in ANY prior season.
- returning team: A team that is participating in the current season, AND did
  NOT participate in the previous season, AND is NOT a rookie team.
- dormant team: A team that DID participate in the previous season, BUT is NOT
  participating in the current season.

Using the definitions above, this is the formula for churn rate for a given year:

```
100 * [number of returning teams + number of dormant teams]
-----------------------------------------------------------
   [number of active teams from the previous season]
```

Using the previous year’s active team count as the denominator might seem odd,
but it’s the right thing to do. Churn rate is intended to calculate the turnover
of teams *from* the prior season *into* the current one. If you use the current
season's number of active teams in the denominator, it is possible for a region
to have churn rate exceeding 100%, which is an unintuitive result. This actually
happened in the Canadian Pacific region, when more teams went dormant in 2021 than
actually participated in the 2021 season.

## Experience and Young Teams

- experience: The number of seasons in which a team has participated.
- young team: An active team with 3 prior seasons of experience or less.

Note the difference between "experience" as defined above, and a team's *age*.
If a team was established 5 years ago, but has only participated in 3 seasons,
it still has only 3 seasons of experience. Thus, it still qualifies as a "young
team" under the definition above, despite being 5 years old.

# Selected Regions and Eligibility

I calculate churn rate for several regions, which vary greatly in geographic
size, team count, and all manner of socioeconomic factors. Also, some regions
overlap with each other. **One should be careful when trying to directly compare
churn between regions.**

In these scripts, a region becomes eligible for churn rate calculation *after*
the region has accumulated 100 team-years of experience. For example, if a
region has 20 teams that each play for 5 seasons, that region would become
eligible for churn rate calculation in its sixth year. The experience of teams
that go dormant still counts towards a region's experience for the purposes of
this calculation.

# Handling of edge cases

Edge cases and exceptions abound. The two most important edge cases to consider
for this purpose are renumbered teams, and sibling teams. Both of these exceptions
are handled in `constants.rb`.

## Renumbered Teams

When there is a new team that is provably a continuation of the same
organization previously represented by another team number, AND the previous
team number has gone dormant, this team is considered to be "renumbered."
The churn rate calculation considers the two different team numbers to be
part of the same program.

Examples of renumbered teams that the churn rate scripts consider:

- Team 2949 permanently renumbered as team 2451 starting in 2013.
- Team 2725 temporarily renumbered as team 10458 in 2025.

## Sibling Teams

When a team meets FIRST's definition of a sibling team, that team is also
considered a sibling within churn calculations. In short, sibling teams are
treated as part of the same program for the purposes of churn rate calculations.
Nearly 80 different sibling teams are currently considered within
`constants.rb`.

Sibling teams count as an active team in churn rate calculations. If a sibling
team goes dormant or returns, it does *not* count as a dormant or returning team,
as long as at least one of the siblings remains active.

Sibling teams count towards a region's total experience for the purpose of
[region eligibility](#selected-regions-and-eligibility)

Sibling teams do *not* contribute to a team's experience for the purpose of
[young team calculations](#experience-and-young-teams). If a pair of rookie
teams are siblings, their total experience accrued is 1.

# To-do list:

1. Redesign team fetching to only include teams that participated in at least
   one official FIRST event that season. The current approach includes teams
   that may have participated in as few as one off season event, and no FIRST
   sanctioned tournaments.
