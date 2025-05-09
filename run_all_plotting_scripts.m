

CPU_path_1        = "benchmark-output-bqrrp-paper/SapphireRapids/";
CPU_path_2        = "benchmark-output-bqrrp-paper/Zen4c/";
GPU_path          = "benchmark-output-bqrrp-paper/A100/";
benchmarking_date = "";

show_lables = 1;

figure('Name', 'Figure 19: BQRRP performance varying block size small inputs');
filename1 = CPU_path_1 + "BQRRP_speed_comparisons_block_size_small/" + benchmarking_date + "_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt";
filename2 = CPU_path_2 + "BQRRP_speed_comparisons_block_size_small/" + benchmarking_date + "_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt";
bqrrp_speed_comparisons_block_size_cpu_small_data(filename1, filename2, 1000, 1000, 3, 8, 3, 7, show_lables);

filename1 = CPU_path_1 + "BQRRP_speed_comparisons_mat_size_rectangular/" + benchmarking_date + "_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
filename2 = CPU_path_2 + "BQRRP_speed_comparisons_mat_size_rectangular/" + benchmarking_date + "_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
bqrrp_speed_comparisons_mat_size_rectangle_cpu(filename1, filename2, 8000, 4000, 4, 3, 7, show_lables);

figure('Name', 'Figure 16: HQRRP runtime breakdown');
filename1 = CPU_path_1 + "HQRRP_runtime_breakdown/" + benchmarking_date + "_HQRRP_runtime_breakdown_num_info_lines_7.txt";
filename2 = CPU_path_2 + "HQRRP_runtime_breakdown/" + benchmarking_date + "_HQRRP_runtime_breakdown_num_info_lines_7.txt";
hqrrp_runtime_breakdown(filename1, filename2, 5, 11, 3, 1)

figure('Name', 'Figure 15: HQRRP performance varying block size');
filename1 = CPU_path_1 + "HQRRP_speed_comparisons_block_size/" + benchmarking_date + "_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt";
filename2 = CPU_path_2 + "HQRRP_speed_comparisons_block_size/" + benchmarking_date + "_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt";
hqrrp_speed_comparisons_block_size(filename1, filename2, 32000, 32000, 5, 11, 3, 7, show_lables);

figure('Name', 'Figure 14: HQRRP plot remake FLOPS');
filename1 = CPU_path_1 + "HQRRP_plot_remake/" + benchmarking_date + "_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
filename2 = CPU_path_2 + "HQRRP_plot_remake/" + benchmarking_date + "_AOCL_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
filename3 = CPU_path_2 + "HQRRP_plot_remake/" + benchmarking_date + "_MKL_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
hqrrp_plot_remake_flops(filename1, filename2, filename3, 10, 5, 20, 7, show_lables);

figure('Name', 'Figure 12-13: BQRRP performance varying block size GPU');
filename = GPU_path + "BQRRP_speed_comparisons_block_size_gpu/" + benchmarking_date + "_BQRRP_GPU_speed_comparisons_block_size_num_info_lines_6.txt";
bqrrp_speed_comparisons_block_size_gpu(filename, 2^11, 2^11, 28, 5, show_lables);

figure('Name', 'Figure 11: BQRRP performance varying mat size');
filename1 = CPU_path_1 + "BQRRP_speed_comparisons_mat_size/" + benchmarking_date + "_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
filename2 = CPU_path_2 + "BQRRP_speed_comparisons_mat_size/" + benchmarking_date + "_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
bqrrp_speed_comparisons_mat_size_cpu(filename1, filename2, 8000, 8000, 3, 5, 3, 7, show_lables);

figure('Name', 'Figure 10: BQRRP performance varying block size');
filename1 = CPU_path_1 + "BQRRP_speed_comparisons_block_size/" + benchmarking_date + "_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt";
filename2 = CPU_path_2 + "BQRRP_speed_comparisons_block_size/" + benchmarking_date + "_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt";
bqrrp_speed_comparisons_block_size_cpu(filename1, filename2, 2^16, 2^16, 64000, 64000, 6, 3, 7, show_lables);
%}
figure('Name', 'Figure 9: BQRRP pivot quality');
filename1 = CPU_path_1 + "BQRRP_pivot_quality/" + benchmarking_date + "_BQRRP_pivot_quality_metric_1_num_info_lines_6.txt";
filename2 = CPU_path_1 + "BQRRP_pivot_quality/" + benchmarking_date + "_BQRRP_pivot_quality_metric_2_num_info_lines_6.txt";
bqrrp_pivot_quality(filename1, filename2, 16384, show_lables);

figure('Name', 'Figure 8: Spectrum of Kahan matrix');
filename = CPU_path_1 + "BQRRP_pivot_quality/" + benchmarking_date + "_Kahan_spectrum_num_info_lines_4.txt";
kahan_spectrum(filename, 16384, show_lables);

figure('Name', 'Figure 7: BQRRP runtime breakdown GPU');
filename1 = GPU_path + "BQRRP_runtime_breakdown_gpu/" + benchmarking_date + "_BQRRP_GPU_runtime_breakdown_cholqr_num_info_lines_6.txt";
filename2 = GPU_path + "BQRRP_runtime_breakdown_gpu/" + benchmarking_date + "_BQRRP_GPU_runtime_breakdown_qrf_num_info_lines_6.txt";
bqrrp_runtime_breakdown_gpu(filename1, filename2, show_lables);

figure('Name', 'Figure 6: BQRRP runtime breakdown CPU');
filename1 = CPU_path_1 + "BQRRP_runtime_breakdown/" + benchmarking_date + "_BQRRP_runtime_breakdown_num_info_lines_7.txt";
filename2 = CPU_path_2 + "BQRRP_runtime_breakdown/" + benchmarking_date + "_BQRRP_runtime_breakdown_num_info_lines_7.txt";
bqrrp_runtime_breakdown_cpu(filename1, filename2, 6, 3, show_lables);

figure('Name', 'Figure 4: apply q trans subroutine performance');
filename1 = CPU_path_1 + "BQRRP_subroutines_speed/" + benchmarking_date + "_BQRRP_subroutines_speed_num_info_lines_10.txt";
filename2 = CPU_path_2 + "BQRRP_subroutines_speed/" + benchmarking_date + "_BQRRP_subroutines_speed_num_info_lines_10.txt";
bqrrp_subroutine_performance_apply_q(filename1, filename2, 2^16, 256, 64000, 250, 6, 3, 7, show_lables);

figure('Name', 'Figure 3: tall qr subroutine performance');
filename1 = CPU_path_1 + "BQRRP_subroutines_speed/" + benchmarking_date + "_BQRRP_subroutines_speed_num_info_lines_10.txt";
filename2 = CPU_path_2 + "BQRRP_subroutines_speed/" + benchmarking_date + "_BQRRP_subroutines_speed_num_info_lines_10.txt";
bqrrp_subroutine_performance_tall_qr(filename1, filename2, 2^16, 256, 64000, 250, 6, 3, 12, show_lables);

figure('Name', 'Figure 2: wide qrcp subroutine performance');
filename1 = CPU_path_1 + "BQRRP_subroutines_speed/" + benchmarking_date + "_BQRRP_subroutines_speed_num_info_lines_10.txt";
filename2 = CPU_path_2 + "BQRRP_subroutines_speed/" + benchmarking_date + "_BQRRP_subroutines_speed_num_info_lines_10.txt";
bqrrp_subroutine_performance_wide_qrcp(filename1, filename2, 256, 2^16, 250, 64000, 6, 3, 2, show_lables);

figure('Name', 'Figure 1: HQRRP plot remake performance ratios');
filename1 = CPU_path_1 + "HQRRP_plot_remake/" + benchmarking_date + "_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
filename2 = CPU_path_2 + "HQRRP_plot_remake/" + benchmarking_date + "_MKL_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
hqrrp_plot_remake_ratios(filename1, filename2, 10, 5, 20, 7, show_lables);
