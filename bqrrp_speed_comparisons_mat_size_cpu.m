function[] = bqrrp_speed_comparisons_mat_size_cpu(filename_Intel, filename_AMD, rows, cols, num_mat_sizes, num_thread_nums, num_iters, num_algs, show_labels)

    Data_in_Intel = readfile(filename_Intel, 7);
    Data_in_AMD = readfile(filename_AMD, 7);

    y_lim = [500, 1600, 3800, 5000];
    plot_position = 1;

    %128 threads - 1 thread
    tiledlayout(num_thread_nums, 3,"TileSpacing", "compact")
    for i = 1:num_thread_nums
        nexttile
        process_and_plot(Data_in_Intel(num_mat_sizes*num_iters*(i-1)+1:num_mat_sizes*num_iters*i,:), num_mat_sizes, num_iters, num_algs, rows, cols, plot_position, show_labels, y_lim(:,i))
        plot_position = plot_position + 1;
        nexttile
        process_and_plot(Data_in_AMD(num_mat_sizes*num_iters*(i-1)+1:num_mat_sizes*num_iters*i,:), num_mat_sizes, num_iters, num_algs, rows, cols, plot_position, show_labels, y_lim(:,i))
        plot_position = plot_position + 1;
        nexttile
        % Below ensures that the legend is places at a reasonable distance
        % from the second subplot in the figure.
        if plot_position == 3
            plot(nan, nan, '->', 'Color', 'black', "MarkerSize", 15,'LineWidth', 1.8);   % BQRRP_CQR
            hold on
            plot(nan, nan, '-<', 'Color', '#EDB120', "MarkerSize", 15,'LineWidth', 1.8); % BQRRP_HQR
            hold on
            plot(nan, nan, '-d', 'Color', 'magenta', "MarkerSize", 15,'LineWidth', 1.8); % HQRRP_BASIC
            hold on
            plot(nan, nan, '-o', 'Color', 'red', "MarkerSize", 15,'LineWidth', 1.8);     % GEQRF
            hold on
            plot(nan, nan, '-s', 'Color', 'blue', "MarkerSize", 15,'LineWidth', 1.8);    % GEQP3
            lgd=legend({'BQRRP\_CQR', 'BQRRP\_HQR', 'HQRRP', 'GEQRF', 'GEQP3'}, 'NumColumns', 2);
            lgd.FontSize = 20;
            legend('Location','northwest');
        end
        % Hiding the phantom axis.
        axis off
    end
end

function[] = process_and_plot(Data_in, num_mat_sizes, num_iters, num_algs, rows, cols, plot_position, show_labels, y_lim)

    Data_in = data_preprocessing_best(Data_in, num_mat_sizes, num_iters, num_algs);

    for i = 1:num_mat_sizes
        geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 1) / 10^6); %#ok<AGROW> % BQRRP_CQR
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % BQRRP_HQR
        Data_out(i, 3) = geqrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW> % HQRRP_BASIC
        Data_out(i, 4) = geqrf_gflop / (Data_in(i, 4) / 10^6); %#ok<AGROW> % HQRRP_CQR
        Data_out(i, 5) = geqrf_gflop / (Data_in(i, 5) / 10^6); %#ok<AGROW> % HQRRP_HQR
        Data_out(i, 6) = geqrf_gflop / (Data_in(i, 6) / 10^6); %#ok<AGROW> % GEQRF
        Data_out(i, 7) = geqrf_gflop / (Data_in(i, 7) / 10^6); %#ok<AGROW> % GEQP3
        rows = rows * 2;
        cols = cols * 2;
    end

    x = [8000 16000 32000];

    markersize = 15;
    loglog(x, Data_out(:, 1), '->', 'Color', 'black', "MarkerSize", markersize,'LineWidth', 1.8);   % BQRRP_CQR
    hold on
    loglog(x, Data_out(:, 2), '-<', 'Color', '#EDB120', "MarkerSize", markersize,'LineWidth', 1.8);   % BQRRP_HQR
    hold on
    loglog(x, Data_out(:, 3), '-d', 'Color', 'magenta', "MarkerSize", markersize,'LineWidth', 1.8); % HQRRP_BASIC
    %hold on
    %loglog(x, Data_out(:, 4), '->', 'Color', 'magenta', "MarkerSize", markersize,'LineWidth', 1.8); % HQRRP_CQR
    %hold on
    %loglog(x, Data_out(:, 5), '-<', 'Color', 'magenta', "MarkerSize", markersize,'LineWidth', 1.8); % HQRRP_HQR
    hold on
    loglog(x, Data_out(:, 6), '-o', 'Color', 'red', "MarkerSize", markersize,'LineWidth', 1.8);     % GEQRF
    hold on
    loglog(x, Data_out(:, 7), '-s', 'Color', 'blue', "MarkerSize", markersize,'LineWidth', 1.8);    % GEQP3

    xlim_padding = 0.1;
    xlim([x(1)*(1-xlim_padding), x(end)*(1+xlim_padding)]);
    ylim([0.5*7 1.3*y_lim]);
    yticks([10, 50, 200, 500, 1500, 3800]);
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    ax.PlotBoxAspectRatio = [10,10,1];
    grid on
    
    if show_labels 
        switch plot_position
            case 1
                ylabel('threads=4;GigaFLOP/s', 'FontSize', 20);
                title('Intel CPU', 'FontSize', 20);
            case 2
                title('AMD CPU', 'FontSize', 20);
            case 3
                ylabel('threads=16;GigaFLOP/s', 'FontSize', 20);
            case 5
                ylabel('threads=64;GigaFLOP/s', 'FontSize', 20);
            case 7
                ylabel('threads=128;GigaFLOP/s', 'FontSize', 20);
                xlabel('block size', 'FontSize', 20); 
            case 8
                xlabel('block size', 'FontSize', 20); 
        end
    end

    if plot_position < 7
        set(gca,'Xticklabel',[])
    end
    if ~mod(plot_position, 2)
        set(gca,'Yticklabel',[])
    end
    switch plot_position 
        case 2
            set(gca,'Yticklabel',[])
        case 7
            xtickangle(45);
            xticks([8000 16000 32000]);
            xticklabels({'8000', '16000', '32000'})
        case 8
            xtickangle(45);
            xticks([8000 16000 32000]);
            xticklabels({'8000', '16000', '32000'})
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