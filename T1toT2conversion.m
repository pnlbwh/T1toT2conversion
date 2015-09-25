% Author: Madhura Baxi, mbaxi@bwh.harvard.edu

function T1toT2conversion(t1, t2Out)

%T1_path = strcat(subj_path,'T1.nrrd');
%T2_path = strcat(subj_path,'T2.nrrd');
%T_heq_path = strcat(subj_path,'T_heq.nrrd');
T1_path=t1;
T2_path=t2Out;

T_heq_path=[tempname,'.nrrd'];

system(sprintf('unu 2op max 0.01 %s -o %s',T1_path,T2_path));
system(sprintf('unu 1op r -i %s -o %s',T2_path,T2_path));
system(sprintf('unu 2op x %s 255 -o %s',T2_path,T2_path));
system(sprintf('unu 1op log2 -i %s -o %s',T2_path,T2_path));

T2_minmax = evalc('system(sprintf(''unu minmax %s'',T2_path))');
size_minmax = size(T2_minmax);
for r = 6:size_minmax(2)
    if T2_minmax(r) == 'm'
        position = r-2;
        break
    end
end
clear size_minmax;
min = T2_minmax(6:position);
min = -str2num(min);
system(sprintf('unu 2op + %s %f -o %s',T2_path,min,T2_path));

system(sprintf('unu heq -b 1000 -i %s -o %s',T2_path,T_heq_path));

T_heq_minmax = evalc('system(sprintf(''unu minmax %s'',T_heq_path))');
size_minmax = size(T_heq_minmax);
for p = 6:size_minmax(2)
    if T_heq_minmax(p) == 'm'
        start_position = p+5;
        break
    end
end

for m = start_position:size_minmax(2)
    if T_heq_minmax(m) == 'a'
        end_position = m-3;
        break
    end
end
max = T_heq_minmax(start_position:end_position);
max = str2num(max);    
scale_factor = 10000/max;
system(sprintf('unu 2op x %s %f -o %s',T_heq_path,scale_factor,T2_path));

system(sprintf('rm %s',T_heq_path)); 

close;
exit
