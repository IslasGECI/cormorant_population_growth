#shellcheck shell=sh
Describe 'scripts in src/'

  Describe 'script calculate_cormorant_growth_rate'
    cleanup() { rm --force tests/cormorant_all_islets_growth_rates.csv; }
    setup() { mkdir --parents reports/figures; }
    BeforeAll 'cleanup' 'setup'
    AfterEach 'cleanup'

    It 'generates output file'
      checksum() { md5sum tests/cormorant_all_islets_growth_rates.csv | cut -d " " -f1; }
      When call src/calculate_cormorant_growth_rate --input tests/data_tests/cormorant_all_islets_clean_data_test.csv --output tests/cormorant_all_islets_growth_rates.csv --iterations 20
      The first line of stdout should equal "Number of bootstraping iterations 20"
      The file tests/cormorant_all_islets_growth_rates.csv should be exist
      The result of function checksum should eq "3bbd56343572f3708ebdb6613c11e450"
    End
  End

  Describe 'script query_burrows_quantity_data'
    cleanup() { rm --force tests/cormorant_all_islets_clean_data.csv; }
    BeforeAll 'cleanup'
    AfterEach 'cleanup'

    It 'generates output file'
      checksum() { md5sum tests/cormorant_all_islets_clean_data.csv | cut -d " " -f1; }
      When call src/query_burrows_quantity_data --input tests/data_tests/cormorant_all_islets_data_test.csv --output tests/cormorant_all_islets_clean_data.csv
      The file tests/cormorant_all_islets_clean_data.csv should be exist
      The result of function checksum should eq "da4a67958f82c746279b4076c7d629fc"
    End
  End
End