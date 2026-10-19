# 10 teams for 10 years, 25 teams for 4 years, ...
MIN_REGION_EXPERIENCE = 100
MAX_YOUNG_TEAM_EXPERIENCE = 3

# Consider these teams as part of another program, starting
# from the given year
#
# Starting and stopping your sister team does not contribute
# to churn rate.
#
# This can also be used to handle teams whose numbers changed.
# See 2949 and 2725 as examples.
#
# Format: old_team_key => [new_team_key, first year of association, last year of association]
SAME_PROGRAM_TEAMS = {
  'frc5' => ['frc6914', 2019, 2019],      # lol wut
  'frc70' => ['frc494', 1998, nil],
  'frc112' => ['frc111', 2022, nil],
  'frc193' => ['frc11', 2013, nil],
  'frc216' => ['frc288', 2009, nil],
  'frc244' => ['frc288', 2011, nil],
  'frc297' => ['frc302', 2015, nil],
  'frc325' => ['frc144', 2020, nil],
  'frc328' => ['frc135', 2023, nil],
  'frc424' => ['frc340', 2007, 2009],
  'frc427' => ['frc321', 2024, nil],
  'frc429' => ['frc177', 2025, nil],
  'frc430' => ['frc11', 2025, nil],
  'frc470' => ['frc66', 2000, 2018],
  'frc749' => ['frc955', 2024, nil],
  'frc757' => ['frc935', 2025, nil],
  'frc900' => ['frc9000', 2023, nil],
  'frc1119' => ['frc1153', 2024, nil],
  'frc1220' => ['frc1732', 2025, nil],
  'frc1285' => ['frc1241', 2014, nil],
  'frc1745' => ['frc8874', 2022, nil],
  'frc1819' => ['frc1561', 2024, nil],
  'frc1822' => ['frc1977', 2024, nil],
  'frc1844' => ['frc1540', 2024, nil],
  'frc1914' => ['frc1923', 2022, 2022],
  'frc2095' => ['frc2234', 2015, nil],
  'frc2265' => ['frc1155', 2007, nil],
  'frc2687' => ['frc2468', 2019, nil],
  'frc2689' => ['frc2468', 2022, nil],
  'frc2716' => ['frc3015', 2020, nil],
  'frc2949' => ['frc2451', 2010, nil],    # 2949 renumbered as 2451
  'frc3166' => ['frc3245', 2015, nil],
  'frc4391' => ['frc8425', 2020, nil],
  'frc4422' => ['frc4381', 2023, nil],
  'frc4423' => ['frc4143', 2024, nil],
  'frc4652' => ['frc4653', 2013, nil],
  'frc4766' => ['frc4522', 2022, nil],
  'frc4861' => ['frc4795', 2024, nil],
  'frc4863' => ['frc4645', 2025, nil],
  'frc5568' => ['frc5454', 2015, 2015],  # https://www.chiefdelphi.com/t/looking-for-a-list-of-sibling-teams/492462/75
  'frc5805' => ['frc3020', 2016, nil],
  'frc6243' => ['frc5892', 2025, nil],
  'frc6244' => ['frc6045', 2025, nil],
  'frc6861' => ['frc2832', 2018, nil],
  'frc6941' => ['frc10541', 2025, nil],
  'frc7174' => ['frc8427', 2018, nil],
  'frc7917' => ['frc7525', 2025, nil],
  'frc8423' => ['frc1023', 2020, nil],
  'frc8424' => ['frc3655', 2020, nil],
  'frc8430' => ['frc8116', 2024, nil],
  'frc8431' => ['frc8103', 2025, nil],
  'frc8503' => ['frc4253', 2021, nil],
  'frc8515' => ['frc3847', 2021, nil],
  'frc8532' => ['frc4125', 2021, nil],
  'frc8613' => ['frc4613', 2021, nil],
  'frc9105' => ['frc5411', 2023, nil],
  'frc9127' => ['frc7476', 2023, nil],
  'frc9210' => ['frc9209', 2023, nil],
  'frc9212' => ['frc5239', 2023, nil],
  'frc9271' => ['frc5199', 2023, nil],
  'frc9316' => ['frc1810', 2023, nil],
  'frc9425' => ['frc8802', 2024, nil],
  'frc9492' => ['frc5411', 2023, nil],
  'frc9554' => ['frc5484', 2024, nil],
  'frc9558' => ['frc818', 2024, nil],
  'frc9566' => ['frc3875', 2024, nil],
  'frc9567' => ['frc2811', 2024, nil],
  'frc9572' => ['frc5907', 2024, nil],
  'frc9584' => ['frc971', 2024, nil],
  'frc9752' => ['frc9128', 2024, nil],
  'frc9790' => ['frc9491', 2025, nil],
  'frc10118' => ['frc118', 2025, nil],
  'frc10287' => ['frc8802', 2025, nil],
  'frc10340' => ['frc9128', 2025, nil],
  'frc10349' => ['frc51', 2025, nil],
  'frc10458' => ['frc2725', 2025, 2025],    # 2725 used a new number for one season
  'frc10473' => ['frc4237', 2025, nil],
  'frc10505' => ['frc3602', 2025, nil],
  'frc10606' => ['frc910', 2025, nil],
  'frc10666' => ['frc3452', 2025, nil],
  # 'frc8380' => ['frc10672', 2020, nil],   # need more info on this one to know if it counts
}
