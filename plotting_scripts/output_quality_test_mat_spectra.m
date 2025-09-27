function[] = output_quality_test_mat_spectra(filename1, filename2, filename3, show_labels)
    Data_in_1 = readfile(filename1, 0);
    Data_in_2 = readfile(filename2, 0);
    Data_in_3 = readfile(filename3, 0);


    plot_spectra(Data_in_1, Data_in_2, Data_in_3, show_labels, 1);
    
end

function[] = plot_spectra(Data_in_1, Data_in_2, Data_in_3, show_labels, plot_position)

    plotting_interval = 1;
    x = 1:plotting_interval:size(Data_in_1, 2);
    semilogy(x, Data_in_1(1, 1:plotting_interval:end), '', 'Color', 'black', "MarkerSize", 15,'LineWidth', 5.0)   
    hold on;
    semilogy(x, Data_in_2(1, 1:plotting_interval:end), '', 'Color', 'red', "MarkerSize", 15,'LineWidth', 5.0)   
    hold on;
    semilogy(x, Data_in_3(1, 1:plotting_interval:end), '', 'Color', 'blue', "MarkerSize", 15,'LineWidth', 5.0)  
    
    grid on
    %xlabel('k', 'FontSize', 20);
    %ylabel('sigma[k]', 'FontSize', 20);
    lgd = legend('Polynomial', 'Step', 'Spiked');
    lgd.FontSize = 20;
    legend('Location','northeastoutside');
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    xticks([0 4000 8000 12000 16000]);
    ylim([10^-10 10^11]);

    xlabel('i', 'FontSize', 20);
    ylabel('sigma_i', 'FontSize', 20);
end

        
