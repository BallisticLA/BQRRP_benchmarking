% A small script for saving PDF figures with specified width/height
% properties.
function[] = fig_save(fig, fig_path, width, height)

set(fig, 'Units', 'inches');
fig.Position = [1, 1, width, height]; 
set(fig, 'PaperUnits', 'inches');
set(fig, 'PaperPosition', [0, 0, width, height]);
set(fig, 'PaperSize', [width, height]);

filename = fullfile(fig_path, [fig.Name, '.pdf']);
exportgraphics(fig, filename, 'ContentType','image', 'Resolution',300);
end