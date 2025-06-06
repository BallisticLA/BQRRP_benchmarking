function[] = bqrrp_subroutine_performance_apply_q(filename_Intel, filename_AMD, rows1, cols1, rows2, cols2, num_block_sizes, num_iters, num_algs, show_labels)
    
    Data_in_Intel = readfile(filename_Intel, 10);
    Data_in_AMD   = readfile(filename_AMD, 10);

    Data_in_Intel_65k = Data_in_Intel(1:3*num_block_sizes*num_iters,:);
    Data_in_Intel_64k = Data_in_Intel(3*num_block_sizes*num_iters+1:end,:);
    Data_in_AMD_65k   = Data_in_AMD(1:3*num_block_sizes*num_iters,:);
    Data_in_AMD_64k   = Data_in_AMD(3*num_block_sizes*num_iters+1:end,:);

    Data_in_Intel_65k = Data_in_Intel_65k((2 * num_block_sizes * num_iters + 1):end, :);
    Data_in_Intel_64k = Data_in_Intel_64k((2 * num_block_sizes * num_iters + 1):end, :);
    Data_in_AMD_65k   = Data_in_AMD_65k((2 * num_block_sizes * num_iters + 1):end, :);
    Data_in_AMD_64k   = Data_in_AMD_64k((2 * num_block_sizes * num_iters + 1):end, :);

    % Horizontally stacking Intel and AMD machines
    tiledlayout(2, 3,"TileSpacing","compact")
    nexttile
    process_and_plot(Data_in_Intel_65k, num_block_sizes, num_iters, num_algs, rows1, cols1, 1, show_labels, 2700);
    nexttile
    process_and_plot(Data_in_AMD_65k, num_block_sizes, num_iters, num_algs, rows1, cols1, 2, show_labels, 2700);
    nexttile
        % Phantom plot
        markersize = 15;
        plot(nan, nan, '-o', 'Color', 'black', "MarkerSize", markersize,'LineWidth', 1.8)
        hold on
        plot(nan, nan, '-d', 'Color', 'red', "MarkerSize", markersize,'LineWidth', 1.8)
        hold on
        plot(nan, nan, '-<', 'Color', 'red', "MarkerSize", markersize,'LineWidth', 1.8)
        hold on
        plot(nan, nan, '->', 'Color', 'red', "MarkerSize", markersize,'LineWidth', 1.8)
        hold on
        plot(nan, nan, '-^', 'Color', 'red', "MarkerSize", markersize,'LineWidth', 1.8)
        hold on
        plot(nan, nan, '-v', 'Color', 'red', "MarkerSize", markersize,'LineWidth', 1.8)
        hold on
        plot(nan, nan, '-*', 'Color', 'red', "MarkerSize", markersize,'LineWidth', 1.8)
        set(gca,'Yticklabel',[])
        lgd=legend({'ORMQR', 'GEMQRT n_{b}=256', 'GEMQRT n_{b}=512', 'GEMQRT n_{b}=1024', 'GEMQRT n_{b}=2048', 'GEMQRT n_{b}=4096', 'GEMQRT n_{b}=8192'}, 'NumColumns', 1);
        lgd.FontSize = 20;
        legend('Location','northwest'); 
        axis off
    nexttile
    process_and_plot(Data_in_Intel_64k, num_block_sizes, num_iters, num_algs, rows2, cols2, 3, show_labels, 3000);
    nexttile
    process_and_plot(Data_in_AMD_64k, num_block_sizes, num_iters, num_algs, rows2, cols2, 4, show_labels, 3000);


end

function[] = process_and_plot(Data_in, num_block_sizes, num_iters, num_algs, rows, cols, plot_position, show_labels, y_lim)

    % Trim off the first benchmark
    Data_in = data_preprocessing_best(Data_in, num_block_sizes, num_iters, num_algs);

    k = cols;        % Numer of elementary reflectors in Q
    m = rows;        % Numer of rows in the matrix that Q is applied to
    n = rows - cols; % Numer of columns in the matrix that Q is applied to

    for i = 1:num_block_sizes
        geqrf_tflop = (2*n*m*k - n*k^2 + n*k ) / 10^9;
        k = k * 2;
        n = rows - k;

        Data_out(i, 1)  = geqrf_tflop / (Data_in(i, 1)  / 10^6); %#ok<AGROW> % ORMQR
        Data_out(i, 2)  = geqrf_tflop / (Data_in(i, 2)  / 10^6); %#ok<AGROW  % GEMQRT NB 256
        Data_out(i, 3)  = geqrf_tflop / (Data_in(i, 3)  / 10^6); %#ok<AGROW  % GEMQRT NB 512
        Data_out(i, 4)  = geqrf_tflop / (Data_in(i, 4)  / 10^6); %#ok<AGROW  % GEMQRT NB 1024
        Data_out(i, 5)  = geqrf_tflop / (Data_in(i, 5)  / 10^6); %#ok<AGROW  % GEMQRT NB 2048
        Data_out(i, 6)  = geqrf_tflop / (Data_in(i, 6)  / 10^6); %#ok<AGROW  % GEMQRT NB 4096
        Data_out(i, 7)  = geqrf_tflop / (Data_in(i, 7)  / 10^6); %#ok<AGROW  % GEMQRT NB 8192
    end
    
    x = [256 512 1024 2048 4096 8192];
    markersize = 15;
    semilogx(x, Data_out(:, 1), '-o', 'Color', 'black', "MarkerSize", markersize,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 2), '-d', 'Color', 'red', "MarkerSize", markersize,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 3), '-<', 'Color', 'red', "MarkerSize", markersize,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 4), '->', 'Color', 'red', "MarkerSize", markersize,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 5), '-^', 'Color', 'red', "MarkerSize", markersize,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 6), '-v', 'Color', 'red', "MarkerSize", markersize,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 7), '-*', 'Color', 'red', "MarkerSize", markersize,'LineWidth', 1.8)

    xlim_padding = 0.1;
    xlim([200*(1-xlim_padding), x(end)*(1+xlim_padding)])
    ylim([0 y_lim]);
    if y_lim == 3000
        yticks([0 500 1000 1500 2000 2500 3000]);
    else 
        yticks([0 500 1000 1500 2000 2700 3000]);
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