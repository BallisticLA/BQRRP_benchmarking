function[] = hqrrp_speed_comparisons_block_size(filename_Intel, filename_AMD, rows, cols, num_thread_nums, num_block_sizes, num_iters, num_algs, show_labels)
    
    Data_in_Intel = readfile(filename_Intel, 7);
    Data_in_AMD = readfile(filename_AMD, 7);

    plot_position = 1;
    y_lim = [500, 1700, 4200, 4600];

    % Vertically stacking 65k adn 64k data
    % Horizontally stacking Intel and AMD machines
    tiledlayout(num_thread_nums, 3,"TileSpacing","compact")
    for i = 1:num_thread_nums
        nexttile
        process_and_plot(Data_in_Intel(((i-1)*num_block_sizes*num_iters+1):(i*num_block_sizes*num_iters),:), num_block_sizes, num_iters, num_algs, rows, cols, plot_position, show_labels, y_lim(1, i));
        plot_position = plot_position + 1;
        nexttile
        process_and_plot(Data_in_AMD(((i-1)*num_block_sizes*num_iters+1):(i*num_block_sizes*num_iters),:), num_block_sizes, num_iters, num_algs, rows, cols, plot_position, show_labels, y_lim(1, i));
        plot_position = plot_position + 1;
        nexttile
        % Below ensures that the legend is places at a reasonable distance
        % from the second subplot in the figure.
        if plot_position == 3
            plot(nan, nan, '-d', 'Color', 'magenta', "MarkerSize", 15,'LineWidth', 1.8) % HQRRP_BASIC
            hold on
            plot(nan, nan, '  ', 'Color', 'red', "MarkerSize", 15,'LineWidth', 1.8)     % GEQRF
            hold on
            plot(nan, nan, '  ', 'Color', 'blue', "MarkerSize", 15,'LineWidth', 1.8)    % GEQP3
            lgd=legend({'HQRRP', 'GEQRF', 'GEQP3'}, 'NumColumns', 2);
            lgd.FontSize = 20;
            legend('Location','northwest');
        end
        % Hiding the phantom axis.
        axis off
    end
end


function[] = process_and_plot(Data_in, num_block_sizes, num_iters, num_algs, rows, cols, plot_position, show_labels, y_lim)

    Data_in = data_preprocessing_best(Data_in, num_block_sizes, num_iters, num_algs);

    geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
    for i = 1:num_block_sizes
        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW> % HQRRP_BASIC
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 6) / 10^6); %#ok<AGROW> % GEQRF
        Data_out(i, 3) = geqrf_gflop / (Data_in(i, 7) / 10^6); %#ok<AGROW> % GEQP3
    end

    % Making usre there's no variation in GEQRF and GEQP3
    %Data_out_GEQRF = Data_out(:, 6);
    %Data_out_GEQRF = Data_out_GEQRF(~isinf(Data_out_GEQRF));
    %Data_out(:, 6) = max(Data_out_GEQRF) * ones(size(Data_out, 6), 1);
    %Data_out(:, 6) = max(Data_out(:, 6)) * ones(size(Data_out, 6), 1);
    %Data_out(:, 7) = min(Data_out(:, 7)) * ones(size(Data_out, 7), 1);

    
    x = [5, 10, 25, 50, 125, 250, 500, 1000, 2000, 4000, 8000];
    markersize = 15;
    loglog(x, Data_out(:, 1), '-d', 'Color', 'magenta', "MarkerSize", markersize,'LineWidth', 1.8) % HQRRP_BASIC
    hold on
    loglog(x, Data_out(:, 2), '  ', 'Color', 'red', "MarkerSize", markersize,'LineWidth', 1.8)     % GEQRF
    hold on
    loglog(x, Data_out(:, 3), '  ', 'Color', 'blue', "MarkerSize", markersize,'LineWidth', 1.8)    % GEQP3

    xlim_padding = 0.1;
    xlim([x(1)*(1-xlim_padding), x(end)*(1+xlim_padding)]);
    ylim([10 y_lim]);
    yticks([0, 5, 10 50, 150, 500, 1500, 3800]);
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
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
                xlabel('dim', 'FontSize', 20); 
            case 8
                xlabel('dim', 'FontSize', 20); 
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
            xticks([5, 10, 25, 50, 125, 250, 500, 1000, 2000, 4000, 8000]);
            xticklabels({'5', '', '25', '', '125', '', '500', '', '2000', '', '8000'})
        case 8
            xticks([5, 10, 25, 50, 125, 250, 500, 1000, 2000, 4000, 8000]);
            xticklabels({'5', '', '25', '', '125', '', '500', '', '2000', '', '8000'})
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