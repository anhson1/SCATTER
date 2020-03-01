function filename = get_single_file_by_mask(directory, filemask)

fname_mask = [ directory '/' filemask ];
files = dir(fname_mask);
if ( isempty(files) )
    error('TSTAR:BAD_FILES', [ '"' fname_mask '": files not found' ])
end
if ( length(files) > 1 )
    error('TSTAR:BAD_FILES', [ '"' fname_mask '": more than one file found' ])
end
filename = [ directory '/' files.name ];

