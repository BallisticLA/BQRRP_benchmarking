

CPU_path_1        = "benchmark-output-bqrrp-paper/SapphireRapids/";
CPU_path_2        = "benchmark-output-bqrrp-paper/Zen4c/";
GPU_path          = "benchmark-output-bqrrp-paper/A100/";
fig_path          = "output_figures/";
benchmarking_date = "";

show_lables = 0;

figure('Name', 'fig_18_bqrrp_performance_varying_mat_size_wide_and_tall', 'NumberTitle', 'off');
filename1 = CPU_path_1 + "BQRRP_speed_comparisons_mat_size_rectangular/" + benchmarking_date + "_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
filename2 = CPU_path_2 + "BQRRP_speed_comparisons_mat_size_rectangular/" + benchmarking_date + "_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
bqrrp_speed_comparisons_mat_size_rectangle_cpu(filename1, filename2, 8000, 4000, 4, 3, 7, show_lables);
fig_save(gcf, fig_path, 12, 8);

figure('Name', 'fig_16_bqrrp_performance_varying_block_size_small_inputs', 'NumberTitle', 'off');
filename1 = CPU_path_1 + "BQRRP_speed_comparisons_block_size_small/" + benchmarking_date + "_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt";
filename2 = CPU_path_2 + "BQRRP_speed_comparisons_block_size_small/" + benchmarking_date + "_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt";
bqrrp_speed_comparisons_block_size_cpu_small_data(filename1, filename2, 1000, 1000, 3, 8, 3, 7, show_lables);
fig_save(gcf, fig_path, 12.5, 10.5);
figure('Name', 'fig_15_hqrrp_runtime_breakdown', 'NumberTitle', 'off');
filename1 = CPU_path_1 + "HQRRP_runtime_breakdown/" + benchmarking_date + "_HQRRP_runtime_breakdown_num_info_lines_7.txt";
filename2 = CPU_path_2 + "HQRRP_runtime_breakdown/" + benchmarking_date + "_HQRRP_runtime_breakdown_num_info_lines_7.txt";
hqrrp_runtime_breakdown(filename1, filename2, 4, 11, 3, show_lables)
fig_save(gcf, fig_path, 11.5, 11.5);

figure('Name', 'fig_14_hqrrp_performance_varying_block_size');
filename1 = CPU_path_1 + "HQRRP_speed_comparisons_block_size/" + benchmarking_date + "_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt";
filename2 = CPU_path_2 + "HQRRP_speed_comparisons_block_size/" + benchmarking_date + "_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt";
hqrrp_speed_comparisons_block_size(filename1, filename2, 32000, 32000, 4, 11, 3, 7, show_lables);
fig_save(gcf, fig_path, 11.5, 11.5);

figure('Name', 'fig_13_hqrrp_plot_remake_flops', 'NumberTitle', 'off');
filename1 = CPU_path_1 + "HQRRP_plot_remake/" + benchmarking_date + "_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
filename2 = CPU_path_2 + "HQRRP_plot_remake/" + benchmarking_date + "_AOCL_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
filename3 = CPU_path_2 + "HQRRP_plot_remake/" + benchmarking_date + "_MKL_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
hqrrp_plot_remake_flops(filename1, filename2, filename3, 10, 5, 20, 7, show_lables);
fig_save(gcf, fig_path, 14, 14);

figure('Name', 'fig_12_bqrrp_performance_varying_block_size_gpu', 'NumberTitle', 'off');
filename = GPU_path + "BQRRP_speed_comparisons_block_size_gpu/" + benchmarking_date + "_BQRRP_GPU_speed_comparisons_block_size_num_info_lines_6.txt";
bqrrp_speed_comparisons_block_size_gpu(filename, 2^11, 2^11, 28, 5, show_lables);
fig_save(gcf, fig_path, 11.5, 11.5);

figure('Name', 'fig_11_bqrrp_performance_varying_mat_size', 'NumberTitle', 'off');
filename1 = CPU_path_1 + "BQRRP_speed_comparisons_mat_size/" + benchmarking_date + "_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
filename2 = CPU_path_2 + "BQRRP_speed_comparisons_mat_size/" + benchmarking_date + "_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
bqrrp_speed_comparisons_mat_size_cpu(filename1, filename2, 8000, 8000, 3, 4, 3, 7, show_lables);
fig_save(gcf, fig_path, 12, 11.5);

figure('Name', 'fig_10_bqrrp_performance_varying_block_size', 'NumberTitle', 'off');
filename1 = CPU_path_1 + "BQRRP_speed_comparisons_block_size/" + benchmarking_date + "_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt";
filename2 = CPU_path_2 + "BQRRP_speed_comparisons_block_size/" + benchmarking_date + "_BQRRP_speed_comparisons_block_size_num_info_lines_7.txt";
bqrrp_speed_comparisons_block_size_cpu(filename1, filename2, 2^16, 2^16, 64000, 64000, 6, 3, 7, show_lables);
fig_save(gcf, fig_path, 12.5, 10);

figure('Name', 'fig_9_bqrrp_pivot_quality', 'NumberTitle', 'off');
filename1 = CPU_path_1 + "BQRRP_pivot_quality/" + benchmarking_date + "_BQRRP_pivot_quality_metric_1_num_info_lines_6.txt";
filename2 = CPU_path_1 + "BQRRP_pivot_quality/" + benchmarking_date + "_BQRRP_pivot_quality_metric_2_num_info_lines_6.txt";
bqrrp_pivot_quality(filename1, filename2, 16384, show_lables);
fig_save(gcf, fig_path, 11.5, 10);

figure('Name', 'fig_8_spectrum_of_kahan_matrix', 'NumberTitle', 'off');
filename = CPU_path_1 + "BQRRP_pivot_quality/" + benchmarking_date + "_Kahan_spectrum_num_info_lines_4.txt";
kahan_spectrum(filename, 16384, show_lables);
fig_save(gcf, fig_path, 6, 5.5);

figure('Name', 'fig_7_bqrrp_runtime_breakdown_gpu', 'NumberTitle', 'off');
filename1 = GPU_path + "BQRRP_runtime_breakdown_gpu/" + benchmarking_date + "_BQRRP_GPU_runtime_breakdown_cholqr_num_info_lines_6.txt";
filename2 = GPU_path + "BQRRP_runtime_breakdown_gpu/" + benchmarking_date + "_BQRRP_GPU_runtime_breakdown_qrf_num_info_lines_6.txt";
bqrrp_runtime_breakdown_gpu(filename1, filename2, show_lables);
fig_save(gcf, fig_path, 8.5, 10);

figure('Name', 'fig_6_bqrrp_runtime_breakdown_cpu', 'NumberTitle', 'off');
filename1 = CPU_path_1 + "BQRRP_runtime_breakdown/" + benchmarking_date + "_BQRRP_runtime_breakdown_num_info_lines_7.txt";
filename2 = CPU_path_2 + "BQRRP_runtime_breakdown/" + benchmarking_date + "_BQRRP_runtime_breakdown_num_info_lines_7.txt";
bqrrp_runtime_breakdown_cpu(filename1, filename2, 6, 3, show_lables);
fig_save(gcf, fig_path, 11.5, 10);

figure('Name', 'fig_4_apply_q_trans_subroutine_performance', 'NumberTitle', 'off');
filename1 = CPU_path_1 + "BQRRP_subroutines_speed/" + benchmarking_date + "_BQRRP_subroutines_speed_num_info_lines_10.txt";
filename2 = CPU_path_2 + "BQRRP_subroutines_speed/" + benchmarking_date + "_BQRRP_subroutines_speed_num_info_lines_10.txt";
bqrrp_subroutine_performance_apply_q(filename1, filename2, 2^16, 256, 64000, 250, 6, 3, 7, show_lables);
fig_save(gcf, fig_path, 11.5, 10);

figure('Name', 'fig_3_tall_qr_subroutine_performance', 'NumberTitle', 'off');
filename1 = CPU_path_1 + "BQRRP_subroutines_speed/" + benchmarking_date + "_BQRRP_subroutines_speed_num_info_lines_10.txt";
filename2 = CPU_path_2 + "BQRRP_subroutines_speed/" + benchmarking_date + "_BQRRP_subroutines_speed_num_info_lines_10.txt";
bqrrp_subroutine_performance_tall_qr(filename1, filename2, 2^16, 256, 64000, 250, 6, 3, 12, show_lables);
fig_save(gcf, fig_path, 13, 10);

figure('Name', 'fig_2_wide_qrcp_subroutine_performance', 'NumberTitle', 'off');
filename1 = CPU_path_1 + "BQRRP_subroutines_speed/" + benchmarking_date + "_BQRRP_subroutines_speed_num_info_lines_10.txt";
filename2 = CPU_path_2 + "BQRRP_subroutines_speed/" + benchmarking_date + "_BQRRP_subroutines_speed_num_info_lines_10.txt";
bqrrp_subroutine_performance_wide_qrcp(filename1, filename2, 256, 2^16, 250, 64000, 6, 3, 2, show_lables);
fig_save(gcf, fig_path, 11.5, 10);

figure('Name', 'fig_1_hqrrp_plot_remake_performance_ratios', 'NumberTitle', 'off');
filename1 = CPU_path_1 + "HQRRP_plot_remake/" + benchmarking_date + "_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
filename2 = CPU_path_2 + "HQRRP_plot_remake/" + benchmarking_date + "_MKL_BQRRP_speed_comparisons_mat_size_num_info_lines_7.txt";
hqrrp_plot_remake_ratios(filename1, filename2, 10, 5, 20, 7, show_lables);
fig_save(gcf, fig_path, 12, 10);
