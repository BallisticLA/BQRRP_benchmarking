function[] = hqrrp_sanity_check(filename_0, filename_1, filename_2, filename_3, num_mat_sizes, num_thread_nums, num_iters, num_algs, show_labels)
    Data_in_0 = readfile(filename_0, 7);
    Data_in_1 = readfile(filename_1, 7);
    Data_in_2 = readfile(filename_2, 7);
    Data_in_3 = readfile(filename_3, 7);

    % Plot controls
    num_plot_rows = 2;
    num_plot_cols = 4;

    tiledlayout(num_plot_rows, num_plot_cols, "TileSpacing", "compact");
    process_and_plot(Data_in_0, num_thread_nums, num_mat_sizes, num_iters, num_algs, 1, show_labels, num_plot_rows, num_plot_cols);
    process_and_plot(Data_in_1, num_thread_nums, num_mat_sizes, num_iters, num_algs, 2, show_labels, num_plot_rows, num_plot_cols);
    process_and_plot(Data_in_2, num_thread_nums, num_mat_sizes, num_iters, num_algs, 3, show_labels, num_plot_rows, num_plot_cols);
    process_and_plot(Data_in_3, num_thread_nums, num_mat_sizes, num_iters, num_algs, 4, show_labels, num_plot_rows, num_plot_cols);
end


function[] = process_and_plot(Data_in, num_thread_nums, num_mat_sizes, num_iters, num_algs, plot_num, show_labels, num_plot_rows, num_plot_cols)

    Data_out          = [];
    Data_in_processed = [];
    dim = 1000;
    marker_array = {'-o', '-s', '-^', '-v', '-d', '-p', '-*', '-x', '-+'};
    color_array = {'b', 'r', 'g', 'm', 'c', 'k', 'y', [0.5, 0.5, 0.5], [1, 0.647, 0]};

    for j = 1:num_thread_nums
        % Row block defines timing results for matrices of size 1k ... 10k
        % for a single number of threads used, assuming a single iteration
        % per each run (since the data that is vewed in row block format 
        % has already been proessed to inlude only the "best" iteration).
        rb_start = num_mat_sizes*(j-1)+1;
        rb_end   = num_mat_sizes*j;
        Data_in_processed(rb_start:rb_end,:) = data_preprocessing_best(Data_in((num_iters*num_mat_sizes*(j-1)+1):(num_iters*num_mat_sizes*j),:), num_mat_sizes, num_iters, num_algs); %#ok<AGROW>
    
        for i = 0:num_mat_sizes-1
            geqrf_gflop = (2 * dim * dim^2 - (2 / 3) * dim^3 + dim * dim + dim^2 + (14 / 3) * dim) / 10^9;
            gemm_gflop = (2 * dim^3) / 10^9; 
            Data_out(rb_start+i,1) = geqrf_gflop ./ (Data_in_processed(rb_start+i, 1) ./ 10^6); %#ok<AGROW> % HQRRP GFLOPS
            Data_out(rb_start+i,2) = gemm_gflop ./ (Data_in_processed(rb_start+i, 2) ./ 10^6); %#ok<AGROW> % GEMM GFLOPS
            dim = dim + 1000;
        end
        dim = 1000;
    end
    x = [1000 2000 3000 4000 5000 6000 7000 8000 9000 10000];
    markersize = 15;

    nexttile(plot_num)
    for j = 1:num_thread_nums
        rb_start = num_mat_sizes*(j-1)+1;
        rb_end   = num_mat_sizes*j;
        semilogy(x, Data_out(rb_start:rb_end, 1), marker_array{j}, 'Color', color_array{j}, "MarkerSize", markersize,'LineWidth', 1.8) % HQRRP GFLOPS
        hold on
    end
    plot_config(plot_num, 2, 100, [1 5 10 25 50 100 150 250], show_labels, num_plot_rows, num_plot_cols);

    if num_plot_cols == 4 && plot_num == 4
        lgd=legend({'1 thread', '4 threads', '16 threads', '64 threads', 'max threads'}, 'NumColumns', 1);
        lgd.FontSize = 20;
        legend('Location','northeastoutside');
    end
    plot_num = plot_num + num_plot_cols;

    nexttile(plot_num)
    for j = 1:num_thread_nums
        rb_start = num_mat_sizes*(j-1)+1;
        rb_end   = num_mat_sizes*j;
        semilogy(x, Data_out(rb_start:rb_end, 2), marker_array{j}, 'Color', color_array{j}, "MarkerSize", markersize,'LineWidth', 1.8) % GEQP3 GFLOPS
        hold on
    end
    plot_config(plot_num, 50, 6000, [50 100 250 500 1000 2000 5000], show_labels, num_plot_rows, num_plot_cols);
    plot_num = plot_num + num_plot_cols;
end

function[] = plot_config(plot_num, y_min_lim, y_max_lim, y_ticks, show_labels, num_plot_rows, num_plot_cols)
    ylim([y_min_lim y_max_lim]);
    xlim_padding = 0.1;
    xlim([0, 10000*(1+xlim_padding)])
    xticks([2000 4000 6000 8000 10000]);
    yticks(y_ticks);
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    grid on

    if show_labels
        switch plot_num
            case 1
                ylabel('HQRRP GFLOP/s', 'FontSize', 20);
                title('Sky Lake', 'FontSize', 20);
            case 2
                title('Cascade Lake', 'FontSize', 20);
            case 3
                title('Ice Lake', 'FontSize', 20);
            case 4
                title('Sapphire Rapids', 'FontSize', 20);
            case 5
                ylabel('GEMM GFLOP/s', 'FontSize', 20);
                xlabel('dim', 'FontSize', 20);
            case 6
                xlabel('dim', 'FontSize', 20);
            case 7
                xlabel('dim', 'FontSize', 20);
            case 8
                xlabel('dim', 'FontSize', 20);
        end
    end
    switch plot_num
        case 1
            set(gca,'Xticklabel',[])
        case 2
            set(gca,'Yticklabel',[])
            set(gca,'Xticklabel',[])
        case 3
            set(gca,'Yticklabel',[])
            set(gca,'Xticklabel',[])
        case 4
            set(gca,'Yticklabel',[])
            set(gca,'Xticklabel',[])
        case 6
            set(gca,'Yticklabel',[])
        case 7
            set(gca,'Yticklabel',[])
        case 8
            set(gca,'Yticklabel',[])
    end
end

function[Data_out] = data_preprocessing_best(Data_in, num_col_sizes, num_iters, num_algs)
    
    Data_out = [];

    i = 1;
    for k = 1:num_algs
        Data_out_col = [];
        while i < num_col_sizes * num_iters
            best_speed = intmax;
            best_speed_idx = i;
            for j = 1:num_iters
                if Data_in(i, k) < best_speed
                    best_speed = Data_in(i, k);
                    best_speed_idx = i;
                end
                i = i + 1;
            end
            Data_out_col = [Data_out_col; Data_in(best_speed_idx, k)]; %#ok<AGROW>
        end
        i = 1;
        Data_out = [Data_out, Data_out_col]; %#ok<AGROW>
    end
end

function[Data_out] = data_preprocessing_average(Data_in, num_col_sizes, num_iters, num_algs)
    
    Data_out = [];

    i = 1;
    for k = 1:num_algs
        Data_out_col = [];
        while i < num_col_sizes * num_iters
            avg_speed = 0;
            for j = 1:num_iters
                avg_speed = avg_speed + Data_in(i, k);
                i = i + 1;
            end
            Data_out_col = [Data_out_col; avg_speed / num_iters]; %#ok<AGROW>
        end
        i = 1;
        Data_out = [Data_out, Data_out_col]; %#ok<AGROW>
    end
end