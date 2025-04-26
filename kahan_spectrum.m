function[] = kahan_spectrum(filename, dim, show_labels)

    Data_in    = readfile(filename, 4);

    semilogy( Data_in(1, 1:dim), '', 'Color', 'black', "MarkerSize", 1.8,'LineWidth', 2.0)

        ax = gca;
        ax.XAxis.FontSize = 20;
        ax.YAxis.FontSize = 20;
        grid on 
        xlim([0 dim]);
        %ylim([10^-15 y_lim]);
    if show_labels
        ylabel('sigma_i', 'FontSize', 20);
        xlabel('i', 'FontSize', 20);
        title('Spectrum of Kahan Matrix', 'FontSize', 20); 
    end
end