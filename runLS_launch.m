clear all
close all
fprintf(1,'Running ls_wholeUS1\n');
%configCluster
%c = parcluster;
%c.AdditionalProperties.AccountName = 'personal';
my_job = batch('runLS_script','Profile', 'local', 'Pool', 70, 'CaptureDiary',true);
wait(my_job);
diary(my_job);
load(my_job);
fprintf(1,'its done\n');
delete(my_job)
clear my_job

