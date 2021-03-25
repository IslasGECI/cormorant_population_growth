#shellcheck shell=sh
Describe 'scripts in src/'
  executable() { chmod +x src/*; }
  BeforeAll 'executable'

  Describe 'script calculate_cormorant_growth_rate'
    cleanup() { rm --force tests/cormorant_all_islets_growth_rates.csv; }
    setup() { mkdir --parents reports/figures; }
    BeforeAll 'cleanup' 'setup'
    AfterEach 'cleanup'

    It 'generates output file'
      When call src/calculate_cormorant_growth_rate --input tests/data_tests/cormorant_all_islets_clean_data_test.csv --output tests/cormorant_all_islets_growth_rates.csv
      The stdout should be present
      The file tests/cormorant_all_islets_growth_rates.csv should be exist
    End
  End

  Describe 'script query_burrows_quantity_data'
    cleanup() { rm --force tests/cormorant_all_islets_clean_data.csv; }
    BeforeAll 'cleanup'
    AfterEach 'cleanup'

    It 'generates output file'
      When call src/query_burrows_quantity_data --input tests/data_tests/cormorant_all_islets_data_test.csv --output tests/cormorant_all_islets_clean_data.csv
      The file tests/cormorant_all_islets_clean_data.csv should be exist
    End
  End
End