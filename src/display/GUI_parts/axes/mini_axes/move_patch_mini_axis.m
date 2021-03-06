function move_patch_mini_axis(src,evt,main_figure)

mini_axes_comp=getappdata(main_figure,'Mini_axes');
patch_obj=mini_axes_comp.patch_obj;
if isempty(patch_obj.Vertices)
    return;
end




ah=mini_axes_comp.mini_ax;

if evt.Button==1
    cp = ah.CurrentPoint;
    x_lim=get(ah,'xlim');
    y_lim=get(ah,'ylim');
    xinit=cp(1,1);
    yinit=cp(1,2);
    
    center_coord=[nanmean(patch_obj.Vertices(:,1)) nanmean(patch_obj.Vertices(:,2))];
    dx_patch=nanmax(patch_obj.Vertices(:,1))-nanmin(patch_obj.Vertices(:,1));
    dy_patch=nanmax(patch_obj.Vertices(:,2))-nanmin(patch_obj.Vertices(:,2));
    
    d_move=[xinit yinit]-center_coord;
    
    new_vert=patch_obj.Vertices+repmat(d_move,4,1);
    
    if any(new_vert(:,1)<x_lim(1))
        new_vert(:,1)=[x_lim(1) x_lim(1)+dx_patch x_lim(1)+dx_patch x_lim(1)];
    end
    
    if any(new_vert(:,1)>x_lim(2))
        new_vert(:,1)=[x_lim(2)-dx_patch x_lim(2) x_lim(2) x_lim(2)-dx_patch];
    end
    
    if any(new_vert(:,2)<y_lim(1))
        new_vert(:,2)=[y_lim(1) y_lim(1) y_lim(1)+dy_patch y_lim(1)+dy_patch];
    end
    
    if any(new_vert(:,2)>y_lim(2))
        new_vert(:,2)=[y_lim(2)-dy_patch y_lim(2)-dy_patch y_lim(2) y_lim(2)];
    end
    
    patch_obj.Vertices=new_vert;

    
    
    axes_panel_comp=getappdata(main_figure,'Axes_panel');
    main_axes=axes_panel_comp.main_axes;
    xlim=[nanmin(patch_obj.Vertices(:,1)) nanmax(patch_obj.Vertices(:,1))];
    ylim=[nanmin(patch_obj.Vertices(:,2)) nanmax(patch_obj.Vertices(:,2))];
    
    if diff(xlim)>0
        set(main_axes,'xlim',xlim);
    end
    if diff(ylim)>0
        set(main_axes,'ylim',ylim);
    end
    
end

