function[] = bqrrp_speed_comparisons_block_size_gpu(filename, rows, cols, num_block_sizes, num_mat_sizes, show_labels)
    Data_in = readfile(filename, 6);
    % Create tiled layout
    t = tiledlayout(ceil(num_mat_sizes/2), 2, "TileSpacing", "loose");
    plot_position = 1;
    % Store plot handles from the first subplot for legend
    legend_handles = [];
    for i = 1:num_mat_sizes
        if i < num_mat_sizes
            nexttile(t, i);
        else
            nexttile(t, i, [1 2]);
        end
        % Get plot handles from this call
        h = process_and_plot(Data_in(num_block_sizes*(i-1)+1:num_block_sizes*i,:), num_block_sizes, rows, cols, plot_position, show_labels);
        if plot_position == 1
            legend_handles = h; % Store only from first tile
        end
        rows = rows * 2;
        cols = cols * 2;
        plot_position = plot_position + 1;
    end
    lgd = legend(legend_handles, {'BQRRP\_HQR\_GPU', 'BQRRP\_CQR\_GPU', 'GEQRF\_GPU'}, 'NumColumns', 3);
    lgd.FontSize = 20;
    lgd.Layout.Tile = 'north';
end

function[h_out] = process_and_plot(Data_in, num_block_sizes, rows, cols, plot_position, show_labels)
    geqrf_tflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^12;

    for i = 1:num_block_sizes
        % The input data is in microseconds, we need TFLOP/s
        Data_out(i, 1) = geqrf_tflop / (Data_in(i, 1) / 10^6); %#ok<AGROW> % BQRRP_HQR
        Data_out(i, 2) = geqrf_tflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % BQRRP_CQR
        Data_out(i, 3) = geqrf_tflop / (Data_in(i, 3) / 10^6); %#ok<AGROW> % GEQRF
    end 

    % Making sure there's no variation in GEQRF
    Data_out(:, 3) = min(Data_out(:, 3)) * ones(size(Data_out, 3), 1);

    x = [32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 512, ...
         640, 768, 896, 1024, 1152, 1280, 1408, 1536, 1664, 1792, 1920, 2048];

    h1 = plot(x, Data_out(:, 1), '-<', 'Color', '#EDB120', 'MarkerSize', 18, 'LineWidth', 1.8); hold on
    h2 = plot(x, Data_out(:, 2), '->', 'Color', 'black',   'MarkerSize', 18, 'LineWidth', 1.8); hold on
    h3 = plot(x, Data_out(:, 3), '-',  'Color', 'blue',    'MarkerSize', 18, 'LineWidth', 1.8); hold on

    h_out = [h1, h2, h3];

    xlim([32 2048]);
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    grid on

    if show_labels 
        switch plot_position
            case 1
                title('NVIDIA GPU', 'FontSize', 20);
                ylabel('dim = 2048; TeraFLOP/s', 'FontSize', 20);
            case 2
                ylabel('dim = 4096; TeraFLOP/s', 'FontSize', 20);
            case 3
                ylabel('dim = 8192; TeraFLOP/s', 'FontSize', 20);
            case 4
                ylabel('dim = 16384; TeraFLOP/s', 'FontSize', 20);
            case 5
                ylabel('dim = 32768; TeraFLOP/s', 'FontSize', 20);
                xlabel('block size', 'FontSize', 20); 
        end
    end

    if plot_position ~= 5
        set(gca, 'XTickLabel', []);
    else
        xticks([32, 256, 512, 1024, 2048]);
    end
end
