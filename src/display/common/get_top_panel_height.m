function [height_char,col_w]=get_top_panel_height(nb)
gui_fmt=init_gui_fmt_struct();
def_str='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz 0123456789()';
tmp= uicontrol('Style','text','units','pixels','String',def_str,'visible','off','FontSize',gui_fmt.txtStyle.fontsize);
h=get(tmp,'Extent');

col_w = (2*gui_fmt.x_sep+gui_fmt.txt_w+gui_fmt.box_w)*nanmax(h(3)/numel(def_str),7);
height_char=(gui_fmt.y_sep*(nb+3)+gui_fmt.txt_h *nb)*nanmax(h(4),18);

delete(tmp);

end