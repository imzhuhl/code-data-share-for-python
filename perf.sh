#!/usr/bin/env bash

set -e

# This script is temperately used in internal CI,
# should be rewritten to Github Actions after open sourced.

pip install nox pyperf

rm -rf perf-3.9-raw.json perf-3.9-cds.json perf-3.10-raw.json perf-3.10-cds.json

nox -s test_import_third_party_perf

pyperf compare_to perf-3.9-raw.json perf-3.9-cds.json perf-3.10-raw.json perf-3.10-cds.json --table | tee perf.table

# Example output:
#+----------------------+--------------+------------------------+----------------------+------------------------+
#| Benchmark            | perf-3.9-raw | perf-3.9-cds           | perf-3.10-raw        | perf-3.10-cds          |
#+======================+==============+========================+======================+========================+
#| boto3                | 198 ms       | 168 ms: 1.18x faster   | not significant      | 167 ms: 1.19x faster   |
#+----------------------+--------------+------------------------+----------------------+------------------------+
#| requests             | 142 ms       | 123 ms: 1.15x faster   | 149 ms: 1.05x slower | 130 ms: 1.09x faster   |
#+----------------------+--------------+------------------------+----------------------+------------------------+
#| numpy                | 145 ms       | 125 ms: 1.16x faster   | 175 ms: 1.21x slower | 129 ms: 1.12x faster   |
#+----------------------+--------------+------------------------+----------------------+------------------------+
#| pyparsing            | 130 ms       | 125 ms: 1.04x faster   | 139 ms: 1.07x slower | not significant        |
#+----------------------+--------------+------------------------+----------------------+------------------------+
#| sqlalchemy           | 228 ms       | 210 ms: 1.09x faster   | 252 ms: 1.10x slower | 218 ms: 1.05x faster   |
#+----------------------+--------------+------------------------+----------------------+------------------------+
#| werkzeug             | 163 ms       | 150 ms: 1.09x faster   | not significant      | 148 ms: 1.10x faster   |
#+----------------------+--------------+------------------------+----------------------+------------------------+
#| aiohttp              | 224 ms       | 198 ms: 1.13x faster   | not significant      | 200 ms: 1.12x faster   |
#+----------------------+--------------+------------------------+----------------------+------------------------+
#| google-cloud-storage | 352 ms       | 322 ms: 1.09x faster   | 369 ms: 1.05x slower | 334 ms: 1.05x faster   |
#+----------------------+--------------+------------------------+----------------------+------------------------+
#| flask                | 232 ms       | 206 ms: 1.13x faster   | not significant      | 220 ms: 1.06x faster   |
#+----------------------+--------------+------------------------+----------------------+------------------------+
#| azure-core           | 195 ms       | 165 ms: 1.18x faster   | 201 ms: 1.03x slower | 173 ms: 1.13x faster   |
#+----------------------+--------------+------------------------+----------------------+------------------------+
#| jsonschema           | 137 ms       | 121 ms: 1.13x faster   | 150 ms: 1.10x slower | 131 ms: 1.05x faster   |
#+----------------------+--------------+------------------------+----------------------+------------------------+
#| scipy                | 152 ms       | 135 ms: 1.13x faster   | 169 ms: 1.11x slower | 139 ms: 1.10x faster   |
#+----------------------+--------------+------------------------+----------------------+------------------------+
#| seaborn              | 1.79 sec     | 1.66 sec: 1.08x faster | not significant      | 1.71 sec: 1.05x faster |
#+----------------------+--------------+------------------------+----------------------+------------------------+
#| azureml-core         | 1.12 sec     | 937 ms: 1.19x faster   | not significant      | 934 ms: 1.20x faster   |
#+----------------------+--------------+------------------------+----------------------+------------------------+
#| Geometric mean       | (ref)        | 1.13x faster           | 1.05x slower         | 1.09x faster           |
#+----------------------+--------------+------------------------+----------------------+------------------------+

nox -s pyperformance_looong

pyperf compare_to pyperformance-3.9-raw.json pyperformance-3.9-cds-site.json pyperformance-3.9-cds.json --table | tee pyperformance-3.9.table
pyperf compare_to pyperformance-3.10-raw.json pyperformance-3.10-cds-site.json pyperformance-3.10-cds.json --table | tee pyperformance-3.10.table

# Example output:
#+-------------------------+---------+-----------------------+------------------------+
#| Benchmark               | raw     | cds-site              | cds                    |
#+=========================+=========+=======================+========================+
#| 2to3                    | 564 ms  | not significant       | 608 ms: 1.08x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| chameleon               | 15.4 ms | 18.2 ms: 1.18x slower | not significant        |
#+-------------------------+---------+-----------------------+------------------------+
#| crypto_pyaes            | 160 ms  | 164 ms: 1.02x slower  | 187 ms: 1.17x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| deltablue               | 11.6 ms | not significant       | 11.0 ms: 1.06x faster  |
#+-------------------------+---------+-----------------------+------------------------+
#| django_template         | 75.8 ms | not significant       | 81.9 ms: 1.08x slower  |
#+-------------------------+---------+-----------------------+------------------------+
#| dulwich_log             | 114 ms  | 119 ms: 1.04x slower  | 129 ms: 1.14x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| fannkuch                | 704 ms  | 717 ms: 1.02x slower  | not significant        |
#+-------------------------+---------+-----------------------+------------------------+
#| float                   | 198 ms  | not significant       | 214 ms: 1.08x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| genshi_text             | 51.3 ms | 47.0 ms: 1.09x faster | not significant        |
#+-------------------------+---------+-----------------------+------------------------+
#| hexiom                  | 14.0 ms | not significant       | 15.3 ms: 1.09x slower  |
#+-------------------------+---------+-----------------------+------------------------+
#| html5lib                | 141 ms  | not significant       | 185 ms: 1.31x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| json_dumps              | 19.3 ms | 20.3 ms: 1.05x slower | not significant        |
#+-------------------------+---------+-----------------------+------------------------+
#| logging_format          | 12.9 us | not significant       | 16.8 us: 1.30x slower  |
#+-------------------------+---------+-----------------------+------------------------+
#| logging_silent          | 305 ns  | 280 ns: 1.09x faster  | 346 ns: 1.14x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| logging_simple          | 12.5 us | not significant       | 15.4 us: 1.23x slower  |
#+-------------------------+---------+-----------------------+------------------------+
#| nbody                   | 210 ms  | not significant       | 218 ms: 1.04x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| nqueens                 | 152 ms  | 142 ms: 1.07x faster  | 143 ms: 1.07x faster   |
#+-------------------------+---------+-----------------------+------------------------+
#| pathlib                 | 30.9 ms | not significant       | 37.1 ms: 1.20x slower  |
#+-------------------------+---------+-----------------------+------------------------+
#| pickle                  | 15.4 us | 17.0 us: 1.11x slower | 14.9 us: 1.03x faster  |
#+-------------------------+---------+-----------------------+------------------------+
#| pickle_dict             | 35.5 us | 34.7 us: 1.02x faster | 34.9 us: 1.02x faster  |
#+-------------------------+---------+-----------------------+------------------------+
#| pickle_list             | 5.91 us | 6.44 us: 1.09x slower | not significant        |
#+-------------------------+---------+-----------------------+------------------------+
#| pickle_pure_python      | 703 us  | not significant       | 841 us: 1.20x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| python_startup          | 15.9 ms | 17.6 ms: 1.11x slower | 21.8 ms: 1.37x slower  |
#+-------------------------+---------+-----------------------+------------------------+
#| raytrace                | 749 ms  | 731 ms: 1.02x faster  | 737 ms: 1.02x faster   |
#+-------------------------+---------+-----------------------+------------------------+
#| regex_compile           | 260 ms  | not significant       | 305 ms: 1.17x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| regex_dna               | 297 ms  | 312 ms: 1.05x slower  | not significant        |
#+-------------------------+---------+-----------------------+------------------------+
#| regex_effbot            | 4.96 ms | 4.51 ms: 1.10x faster | 4.44 ms: 1.12x faster  |
#+-------------------------+---------+-----------------------+------------------------+
#| scimark_fft             | 521 ms  | 542 ms: 1.04x slower  | not significant        |
#+-------------------------+---------+-----------------------+------------------------+
#| scimark_monte_carlo     | 173 ms  | 160 ms: 1.08x faster  | 159 ms: 1.09x faster   |
#+-------------------------+---------+-----------------------+------------------------+
#| scimark_sor             | 293 ms  | 320 ms: 1.09x slower  | 330 ms: 1.12x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| scimark_sparse_mat_mult | 8.08 ms | not significant       | 6.77 ms: 1.19x faster  |
#+-------------------------+---------+-----------------------+------------------------+
#| sqlalchemy_declarative  | 258 ms  | not significant       | 313 ms: 1.21x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| sqlalchemy_imperative   | 35.3 ms | not significant       | 51.2 ms: 1.45x slower  |
#+-------------------------+---------+-----------------------+------------------------+
#| sqlite_synth            | 4.87 us | 5.41 us: 1.11x slower | 4.48 us: 1.09x faster  |
#+-------------------------+---------+-----------------------+------------------------+
#| sympy_expand            | 819 ms  | not significant       | 1.02 sec: 1.24x slower |
#+-------------------------+---------+-----------------------+------------------------+
#| sympy_integrate         | 38.8 ms | 43.2 ms: 1.11x slower | 43.5 ms: 1.12x slower  |
#+-------------------------+---------+-----------------------+------------------------+
#| sympy_sum               | 295 ms  | not significant       | 333 ms: 1.13x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| sympy_str               | 509 ms  | not significant       | 556 ms: 1.09x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| telco                   | 9.34 ms | not significant       | 10.3 ms: 1.10x slower  |
#+-------------------------+---------+-----------------------+------------------------+
#| tornado_http            | 261 ms  | not significant       | 334 ms: 1.28x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| unpickle                | 22.1 us | 19.9 us: 1.11x faster | 19.0 us: 1.16x faster  |
#+-------------------------+---------+-----------------------+------------------------+
#| unpickle_pure_python    | 485 us  | 473 us: 1.03x faster  | 583 us: 1.20x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| xml_etree_generate      | 134 ms  | 140 ms: 1.05x slower  | 146 ms: 1.09x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| xml_etree_process       | 109 ms  | 113 ms: 1.03x slower  | 116 ms: 1.06x slower   |
#+-------------------------+---------+-----------------------+------------------------+
#| Geometric mean          | (ref)   | 1.01x slower          | 1.06x slower           |
#+-------------------------+---------+-----------------------+------------------------+
#
#Benchmark hidden because not significant (17): chaos, genshi_xml, go, json_loads, mako, meteor_contest, pidigits, pyflate, python_startup_no_site, regex_v8, richards, scimark_lu, spectral_norm, unpack_sequence, unpickle_list, xml_etree_parse, xml_etree_iterparse
