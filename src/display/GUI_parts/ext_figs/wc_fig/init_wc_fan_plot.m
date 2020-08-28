function init_wc_fan_plot(~,~)

esp3_obj = getappdata(groot,'esp3_obj');
[cmap,col_ax,col_lab,col_grid,col_bot,col_txt,col_tracks]=init_cmap(esp3_obj.curr_disp.Cmap);

if ~isappdata(esp3_obj.main_figure,'wc_fan')
    
    wc_fan.wc_fan_fig = new_echo_figure(esp3_obj.main_figure,...
        'Name','WC fan',...
        'tag','wc_fan',...
        'Color',col_ax,...
        'CloseRequestFcn',@rm_wc_fan_appdata);
    
    
    wc_fan.wc_axes = axes(wc_fan.wc_fan_fig,...
        'Units','normalized',...
        'outerposition',[0 0 1 0.95],...
        'Color',col_ax,...
        'GridColor',col_grid,...
        'MinorGridColor',col_grid,...
        'XColor',col_lab,...
        'YColor',col_lab,...
        'GridColor',col_grid,...
        'MinorGridColor',col_grid,...
        'XGrid','on',...
        'YGrid','on',...
        'FontSize',8,...
        'XLimMode','manual',...
        'YLimMode','manual',...
        'Box','on',...
        'SortMethod','childorder',...
        'GridLineStyle','--',...
        'MinorGridLineStyle',':',...
        'NextPlot','add',...
        'YDir','reverse',...
        'visible','on',...
        'ClippingStyle','rectangle',...
        'Interactions',[],...
        'DataAspectRatio',[1 1 1],...
        'Toolbar',[],...
        'CLim',esp3_obj.curr_disp.Cax,...
        'Colormap',cmap,...
        'Tag','wc');
    
    wc_fan.wc_axes.XAxisLocation='top';
    wc_fan.wc_axes.XAxis.TickLabelFormat='%.0fm';
    wc_fan.wc_axes.YAxis.TickLabelFormat='%.0fm';
    
    wc_fan.wc_cbar = colorbar(wc_fan.wc_axes,'southoutside','Color',col_lab);
    
    wc_fan.wc_axes_tt = uicontrol(wc_fan.wc_fan_fig,...
        'Units','normalized',...
        'Style','Text',...
        'position',[0 0.95 1 0.05],'BackgroundColor',col_ax,'ForegroundColor',col_lab);
    
    wc_fan.wc_gh = pcolor(wc_fan.wc_axes,ones(2,2));
    
    set(wc_fan.wc_gh,...
        'Facealpha','flat',...
        'FaceColor','flat',...
        'LineStyle','none');
    
    setappdata(esp3_obj.main_figure,'wc_fan',wc_fan);
end
update_wc_fig(1);

end

function rm_wc_fan_appdata(src,evt)

esp3_obj = getappdata(groot,'esp3_obj');
rmappdata(esp3_obj.main_figure,'wc_fan');

delete(src)

end