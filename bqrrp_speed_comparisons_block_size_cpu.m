function[] = bqrrp_speed_comparisons_block_size_cpu(filename_Intel, filename_AMD, rows1, cols1, rows2, cols2, num_block_sizes, num_iters, num_algs, show_labels)
    Data_in_Intel = readfile(filename_Intel, 7);
    Data_in_AMD = readfile(filename_AMD, 7);

    % Vertically stacking 65k adn 64k data
    % Horizontally stacking Intel and AMD machines
    tiledlayout(2, 3,"TileSpacing","compact")
    nexttile
    process_and_plot(Data_in_Intel(1:num_block_sizes*num_iters,:), num_block_sizes, num_iters, num_algs, rows1, cols1, 1, show_labels, 6500);
    nexttile
    process_and_plot(Data_in_AMD(1:num_block_sizes*num_iters,:), num_block_sizes, num_iters, num_algs, rows1, cols1, 2, show_labels, 6500);
    nexttile
        % Phantom plot
        markersize = 15;
        loglog(nan, nan, '->', 'Color', 'black', "MarkerSize", markersize,'LineWidth', 1.8)   
        hold on
        loglog(nan, nan, '-<', 'Color', '#EDB120', "MarkerSize", markersize,'LineWidth', 1.8) 
        hold on
        loglog(nan, nan, '-d', 'Color', 'magenta', "MarkerSize", markersize,'LineWidth', 1.8) 
        hold on
        loglog(nan, nan, '  ', 'Color', 'red', "MarkerSize", markersize,'LineWidth', 1.8)    
        hold on
        loglog(nan, nan, '  ', 'Color', 'blue', "MarkerSize", markersize,'LineWidth', 1.8)  
        set(gca,'Yticklabel',[])
        lgd=legend({'BQRRP\_CQR', 'BQRRP\_HQR', 'HQRRP', 'GEQRF', 'GEQP3'}, 'NumColumns', 2);
        lgd.FontSize = 20;
        legend('Location','northwest'); 
        axis off
    nexttile
    process_and_plot(Data_in_Intel(num_block_sizes*num_iters+1:end,:), num_block_sizes, num_iters, num_algs, rows2, cols2, 3, show_labels, 7000);
    nexttile
    process_and_plot(Data_in_AMD(num_block_sizes*num_iters+1:end,:), num_block_sizes, num_iters, num_algs, rows2, cols2, 4, show_labels, 6500);
end


function[] = process_and_plot(Data_in, num_block_sizes, num_iters, num_algs, rows, cols, plot_position, show_labels, y_lim)

    Data_in = data_preprocessing_best(Data_in, num_block_sizes, num_iters, num_algs);

    geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
    for i = 1:num_block_sizes
        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 1) / 10^6); %#ok<AGROW> % BQRRP_CQR
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % BQRRP_HQR
        Data_out(i, 3) = geqrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW> % HQRRP_BASIC
        Data_out(i, 4) = geqrf_gflop / (Data_in(i, 4) / 10^6); %#ok<AGROW> % HQRRP_CQR
        Data_out(i, 5) = geqrf_gflop / (Data_in(i, 5) / 10^6); %#ok<AGROW> % HQRRP_HQR
        Data_out(i, 6) = geqrf_gflop / (Data_in(i, 6) / 10^6); %#ok<AGROW> % GEQRF
        Data_out(i, 7) = geqrf_gflop / (Data_in(i, 7) / 10^6); %#ok<AGROW> % GEQP3
    end

    % Making usre there's no variation in GEQRF and GEQP3
    Data_out_GEQRF = Data_out(:, 6);
    Data_out_GEQRF = Data_out_GEQRF(~isinf(Data_out_GEQRF));
    Data_out(:, 6) = max(Data_out_GEQRF) * ones(size(Data_out, 6), 1);
    Data_out(:, 6) = max(Data_out(:, 6)) * ones(size(Data_out, 6), 1);
    Data_out(:, 7) = min(Data_out(:, 7)) * ones(size(Data_out, 7), 1);

    
    if mod(rows, 10)
        x = [256 512 1024 2048 4096 8192];
    else
        x = [250 500 1000 2000 4000 8000];
    end
    markersize = 15;
    loglog(x, Data_out(:, 1), '->', 'Color', 'black', "MarkerSize", markersize,'LineWidth', 1.8)   % BQRRP_CQR
    hold on
    loglog(x, Data_out(:, 2), '-<', 'Color', '#EDB120', "MarkerSize", markersize,'LineWidth', 1.8)   % BQRRP_HQR
    hold on
    loglog(x, Data_out(:, 3), '-d', 'Color', 'magenta', "MarkerSize", markersize,'LineWidth', 1.8) % HQRRP_BASIC
    %hold on
    %semilogx(x, Data_out(:, 4), '->', 'Color', 'magenta', "MarkerSize", markersize,'LineWidth', 1.8) % HQRRP_CQR
    %hold on
    %semilogx(x, Data_out(:, 5), '-<', 'Color', 'magenta', "MarkerSize", markersize,'LineWidth', 1.8) % HQRRP_HQR
    hold on
    loglog(x, Data_out(:, 6), '  ', 'Color', 'red', "MarkerSize", markersize,'LineWidth', 1.8)     % GEQRF
    hold on
    loglog(x, Data_out(:, 7), '  ', 'Color', 'blue', "MarkerSize", markersize,'LineWidth', 1.8)    % GEQP3

    xlim_padding = 0.1;
    xlim([200*(1-xlim_padding), x(end)*(1+xlim_padding)])
    ylim([10 y_lim]);
    yticks([10, 100, 1000, 2500, 6500]);
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    grid on

    if show_labels 
        switch plot_position
            case 1
                title('Intel CPU', 'FontSize', 20);
                ylabel('dim = 65,536; GigaFLOP/s', 'FontSize', 20);
            case 2
                title('AMD CPU', 'FontSize', 20);
            case 3
                ylabel('dim = 64,000; GigaFLOP/s', 'FontSize', 20); 
                xlabel('block size', 'FontSize', 20); 
            case 4
                xlabel('block size', 'FontSize', 20); 
        end
    end
    switch plot_position
        case 1
            %xticks([512 2048 8192]);
            xticks([256 1024 4096]);
        case 2
            set(gca,'Yticklabel',[])
            %xticks([512 2048 8192]);
            xticks([256 1024 4096]);
        case 3
            %xticks([500 2000 8000]);
            xticks([250 1000 4000]);
        case 4
            set(gca,'Yticklabel',[])
            %xticks([500 2000 8000]);
            xticks([250 1000 4000]);
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