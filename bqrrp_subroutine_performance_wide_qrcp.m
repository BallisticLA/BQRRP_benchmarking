function[] = bqrrp_subroutine_performance_wide_qrcp(filename_Intel, filename_AMD, rows1, cols1, rows2, cols2, num_block_sizes, num_iters, num_algs, show_labels)

    Data_in_Intel = readfile(filename_Intel, 10);
    Data_in_AMD   = readfile(filename_AMD, 10);

    Data_in_Intel_65k = Data_in_Intel(1:3*num_block_sizes*num_iters,:);
    Data_in_Intel_64k = Data_in_Intel(3*num_block_sizes*num_iters+1:end,:);
    Data_in_AMD_65k   = Data_in_AMD(1:3*num_block_sizes*num_iters,:);
    Data_in_AMD_64k   = Data_in_AMD(3*num_block_sizes*num_iters+1:end,:);

    Data_in_Intel_65k = Data_in_Intel_65k(1:num_block_sizes*num_iters,:);
    Data_in_Intel_64k = Data_in_Intel_64k(1:num_block_sizes*num_iters,:);
    Data_in_AMD_65k   = Data_in_AMD_65k(1:num_block_sizes*num_iters,:);
    Data_in_AMD_64k   = Data_in_AMD_64k(1:num_block_sizes*num_iters,:);

    % Horizontally stacking Intel and AMD machines
    tiledlayout(2, 3,"TileSpacing","compact")
    nexttile
    process_and_plot(Data_in_Intel_65k, num_block_sizes, num_iters, num_algs, rows1, cols1, 1, show_labels, 1500);
    nexttile
    process_and_plot(Data_in_AMD_65k, num_block_sizes, num_iters, num_algs, rows1, cols1, 2, show_labels, 1500);
    nexttile
        % Phantom plot
        markersize = 15;
        plot(nan, nan, '-s', 'Color', 'blue', "MarkerSize", markersize,'LineWidth', 1.8);
        hold on
        plot(nan, nan, '->', 'Color', 'black', "MarkerSize", markersize,'LineWidth', 1.8);
        set(gca,'Yticklabel',[])
        lgd=legend({'GEQP3', 'LUQR'}, 'NumColumns', 2);
        lgd.FontSize = 20;
        legend('Location','northwest'); 
        axis off
    nexttile
    process_and_plot(Data_in_Intel_64k, num_block_sizes, num_iters, num_algs, rows2, cols2, 3, show_labels, 2500);
    nexttile
    process_and_plot(Data_in_AMD_64k, num_block_sizes, num_iters, num_algs, rows2, cols2, 4, show_labels, 2500);

end


function[] = process_and_plot(Data_in, num_block_sizes, num_iters, num_algs, rows, cols, plot_position, show_labels, y_lim)

    Data_in = data_preprocessing_best(Data_in, num_block_sizes, num_iters, num_algs);

    for i = 1:num_block_sizes
        geqrf_gflop = (2 * cols * rows^2 - (2 / 3) * rows^3 + 3 * cols * rows - rows^2 + (14 / 3) * cols) / 10^9;
        rows = rows * 2;

        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 1) / 10^6); %#ok<AGROW> % QP3
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % LUQR
    end

    x = [256 512 1024 2048 4096 8192];
    markersize = 15;
    loglog(x, Data_out(:, 1), '-s', 'Color', 'blue', "MarkerSize", markersize,'LineWidth', 1.8) % QP3
    hold on
    loglog(x, Data_out(:, 2), '->', 'Color', 'black', "MarkerSize", markersize,'LineWidth', 1.8)  % LUQR
    xticks([512 2048 8192]);
    xlim_padding = 0.1;
    xlim([200*(1-xlim_padding), x(end)*(1+xlim_padding)])
    ylim([1 y_lim]);
    if y_lim == 2500
        yticks([2 10 50 250 700 2500]);
    else
        yticks([2 10 50 250 700 1500]);
    end
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