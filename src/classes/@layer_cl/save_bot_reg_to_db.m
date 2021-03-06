function [bot_ver_new,reg_ver_new]=save_bot_reg_to_db(layer_obj,varargin)

% input parser
p = inputParser;
addRequired(p,'layer_obj',@(obj) isa(obj,'layer_cl'));
addParameter(p,'bot',1);
addParameter(p,'reg',1);
parse(p,layer_obj,varargin{:});

[path_xml,reg_file_str,bot_file_str]=layer_obj.create_files_str();
bot_ver_new=0;
reg_ver_new=0;

max_bot_ver=0;
max_reg_ver=0;
for ib=1:length(bot_file_str)
    dbfile=fullfile(path_xml{ib},'bot_reg.db');
    if exist(dbfile,'file')==0
        initialize_reg_bot_db(dbfile)
    end
    dbconn=sqlite(dbfile,'connect');
    if p.Results.bot>0
        bot_ver = dbconn.fetch(sprintf('select Version from bottom where Filename is "%s"',bot_file_str{ib}));
        if ~isempty(bot_ver)
            max_bot_ver=nanmax([max_bot_ver nanmax(cell2mat(bot_ver))]);
        end
    end
    
    if p.Results.reg>0
        reg_ver = dbconn.fetch(sprintf('select Version from region where Filename is "%s"',reg_file_str{ib}));
        if ~isempty(reg_ver)
            max_reg_ver=nanmax([max_reg_ver nanmax(cell2mat(reg_ver))]);
        end
    end
    
    close(dbconn);
    
end

for ifile=1:length(reg_file_str)
    if exist(path_xml{ifile},'dir')==0
        mkdir(path_xml{ifile});
    end
    xml_reg_file=fullfile(path_xml{ifile},reg_file_str{ifile});
    xml_bot_file=fullfile(path_xml{ifile},bot_file_str{ifile});
    
    dbfile=fullfile(path_xml{ifile},'bot_reg.db');
    
    dbconn=sqlite(dbfile,'connect');
    
    
    if exist(xml_bot_file,'file')==2&&p.Results.bot>0
        xml_str_bot=fileread(xml_bot_file);
        bot_ver_new=max_bot_ver+1;
        fprintf('Saving Bottom to database as version %.0f for file %s\n',max_bot_ver+1,bot_file_str{ifile});
        dbconn.insert('bottom',{'Filename' 'Bot_XML' 'Version'},{bot_file_str{ifile} xml_str_bot bot_ver_new});
    end
    
    
    if exist(xml_reg_file,'file')==2&&p.Results.reg>0
        xml_str_reg=fileread(xml_reg_file);
        reg_ver_new=max_reg_ver+1;
        fprintf('Saving Regions to database as version %.0f for file %s\n',reg_ver_new,reg_file_str{ifile});
        dbconn.insert('region',{'Filename' 'Reg_XML' 'Version'},{reg_file_str{ifile} xml_str_reg reg_ver_new});   
    end
    
    
    close(dbconn)
end
end