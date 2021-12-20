function results = preproc(data, fun, options)
%PREPROC Feed given data to function to calculate performance indices.
arguments
    data {istable}
    fun
    options.Keys {mustBeText}
    options.Vars {mustBeText}
end

[grps, gid] = findgroups(data(:, options.Keys));
[stats, labels] = splitapply(fun, data(:, options.Vars), grps);
results = [gid, array2table(stats, 'VariableNames', labels(1, :))];
