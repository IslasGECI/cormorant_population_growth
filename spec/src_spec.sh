#shellcheck shell=sh
Describe 'script calculate_cormorant_growth_rate'
  cleanup() { rm --force tests/cormorant_all_islets_growth_rates.csv; }
  BeforeAll 'cleanup'
  AfterEach 'cleanup'

  It 'generates output file'
    When call src/calculate_cormorant_growth_rate --input tests/data_tests/cormorant_all_islets_clean_data_test.csv --output tests/cormorant_all_islets_growth_rates.csv
    The stdout should be present
    The file tests/cormorant_all_islets_growth_rates.csv should be exist
  End
End
