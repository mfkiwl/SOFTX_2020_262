% 
% CREATE TABLE t_deployment
% (
% 	deployment_pkey			SERIAL PRIMARY KEY,
% 
% 	-- Deployment platform type (see ICES mission_platform)
% 	deployment_type_key		INT,		-- Describe type of deployment platform that is hosting the acoustic instrumentation. See the lookup table t_deployment_type (ICES mission_platform)
% 	-- Deployment link to ship if deployment_type_key refers to ship
% 	deployment_ship_key	    INT,		-- ID of ship used in cruise
% 
% 	
% 	-- Basic info on cruise/deployment
% 	deployment_name			TEXT, 		-- Formal name of deployment as recorded by deployment documentation or institutional data centre (No ICES attribute for this normally, but inspired from cruise_name)
% 	deployment_id			TEXT, 		-- Deployment ID where one exists (ICES mooring_code/ICES cruise_id)
% 	deployment_description		TEXT,		-- Free text field to describe the deployment (ICES mooring_description/ICES cruise_description)
% 	deployment_area_description	TEXT,		-- List main areas of operation (ICES mooring_site_name/ICES cruise_area_description)
% 	deployment_operator		TEXT,		-- Name of organisation which operates the deployment (ICES mooring_operator)
% 	deployment_summary_report	TEXT,		-- Published or web-based references that links to the deployment report (No ICES attribute for this normally, but inspired from cruise_summary_report)
% 	deployment_start_date		TIMESTAMP, 	-- Start date of deployment (ICES mooring_deployment_date/ICES cruise_start_date)                
% 	deployment_end_date		TIMESTAMP,	-- End date of deployment (ICES mooring_retrieval_date/ICES cruise_end_date)
% 
% 	-- ICES geographic info on cruise/deployment
% 	deployment_northlimit		FLOAT,		-- The constant coordinate for the northernmost face or edge (ICES mooring_northlimit)
% 	deployment_eastlimit		FLOAT,		-- The constant coordinate for the easternmost face or edge (ICES mooring_eastlimit)
% 	deployment_southlimit		FLOAT,		-- The constant coordinate for the southernmost face or edge (ICES mooring_southlimit)
% 	deployment_westlimit		FLOAT,		-- The constant coordinate for the westernmost face or edge (ICES mooring_westlimit)
% 	deployment_uplimit		FLOAT,		-- The constant coordinate for the uppermost face or edge in the vertical, z, dimension (ICES mooring_uplimit)
% 	deployment_downlimit		FLOAT,		-- The constant coordinate for the lowermost face or edge in the vertical, z, dimension (ICES mooring_downlimit)
% 	deployment_units		TEXT, 		-- The units of unlabelled numeric values of deployment_northlimit, deployment_eastlimit, deployment_southlimit, deployment_westlimit (ICES mooring_units)
% 	deployment_zunits		TEXT,		-- The units of unlabelled numeric values of deployment_uplimit, deployment_downlimit (ICES mooring_zunits)
% 	deployment_projection		TEXT,		-- The name of the projection used with any parameters required (ICES mooring_projection)
% 
%        -- Additional specific ICES requirements for deployment
% 	deployment_start_port		TEXT,		-- Commonly used name for the port where cruise started (ICES deployment_start_port)
% 	deployment_end_port			TEXT,		-- Commonly used name for the port where cruise ended (ICES deployment_end_port)
% 	deployment_start_BODC_code		TEXT,		-- Name of port from where cruise started (ICES deployment_start_BODC_code)
% 	deployment_end_BODC_code		TEXT,		-- Name of port from where cruise ended (ICES deployment_end_BODC_code)                                                                                                                                                                                                                                                                                                       	
% 	deployment_comments		TEXT,		-- Free text field for relevant information not captured by other attributes (ICES mooring_comments)
% 
% 	FOREIGN KEY (deployment_type_key) REFERENCES t_deployment_type(deployment_type_pkey)
% 	FOREIGN KEY (deployment_ship_key) REFERENCES t_ship(ship_pkey)
% );
% COMMENT ON TABLE t_deployment is 'Deployment (ship, towbody, AOS, mooring, drifting buoy, glider, etc.) from which acoustic data were collected.';

function deployment_pkey=add_deployment_struct_to_t_deployment(ac_db_filename,varargin)

p = inputParser;

addRequired(p,'ac_db_filename',@(x) ischar(x)||isa(x,'database.jdbc.connection'));
addParameter(p,'deployment_struct',init_deployment_struct(),@isstruct);

parse(p,ac_db_filename,varargin{:});

struct_in=p.Results.deployment_struct;


struct_in.deployment_start_date=cellfun(@(x) datestr(x,'yyyy-mm-dd HH:MM:SS.FFF'),num2cell(struct_in.deployment_start_date),'un',0);
struct_in.deployment_end_date=cellfun(@(x) datestr(x,'yyyy-mm-dd HH:MM:SS.FFF'),num2cell(struct_in.deployment_end_date),'un',0);

fields=fieldnames(struct_in);

for ifi=1:numel(fields)
    if ischar(struct_in.(fields{ifi}))
        struct_in.(fields{ifi})={struct_in.(fields{ifi})};
    else
        struct_in.(fields{ifi})=struct_in.(fields{ifi});
    end
end

% t=struct2table(struct_in);
% 
% dbconn=connect_to_db(ac_db_filename);  
% dbconn.insert('t_deployment',fieldnames(struct_in),t);
% 
% dbconn.close();
rm_fields={'deployment_comments' 'deployment_northlimit' 'deployment_eastlimit' 'deployment_southlimit' 'deployment_westlimit' 'deployment_uplimit' 'deployment_downlimit'};
for i=1:numel(rm_fields)
    if isfield(struct_in,rm_fields{i})
        struct_in_minus_key=rmfield(struct_in,rm_fields{i});
    end
end

deployment_pkey=insert_data_controlled(ac_db_filename,'t_deployment',struct_in,struct_in_minus_key,'deployment_pkey');

end