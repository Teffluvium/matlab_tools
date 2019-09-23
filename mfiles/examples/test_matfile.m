% test_matfile
% Demonstrates the use of the built-in Matlab function matfile

% NOTE: The maximum size of a MAT-file is imposed only by your native file system.

close all; clearvars; clc;
dbstop if error

n = 14; % # bits

filename = 'myTestFile.mat';
wholeFilename = 'myWholeTestFile.mat';
m = matfile(filename,'Writable',true);

delete(filename)
delete(wholeFilename)

% These numbers are small for demonstration. If you want to testing timing,
% increase them.
nSamps = 1e5; %1e7;
nChs = 8;
nIters = 10; %100;

% Try saving and then reading a whole .mat file all at once ---------------
if 1
    u = 1000*randn(nSamps*nIters,nChs);
    y_whole = uencode(u,n);
    tic
    save('myWholeTestFile.mat','y_whole')
    fprintf(1,'\nWriting whole file: %g seconds\n', toc)
    whos('-file','myWholeTestFile.mat')    
end

% Try saving to a .mat file in chuncks using the matfile function ---------
if 1 
    tic
    for k = 1:nIters
        u = 1000*randn(nSamps,nChs);
        yTemp = uencode(u,n);
        idx_1_a = nSamps*(k-1) + 1;
        idx_1_b = nSamps*k;
        idx_2_a = 1;
        idx_2_b = nChs;
        m.y(idx_1_a:idx_1_b, idx_2_a:idx_2_b) = yTemp;
        % whos('-file','myTestFile.mat')
    end
    fprintf(1,'\nWriting file in chuncks using matfile: %g seconds\n', toc)
    whos('-file','myTestFile.mat')
end

% Try reading from to a .mat file in chuncks using the matfile function ---
if 1
    % yOut = [];
    % tic
    for k = 1:nIters
        tic
        idx_1_a = nSamps*(k-1) + 1;
        idx_1_b = nSamps*k;
        idx_2_a = 1;
        idx_2_b = nChs;
        % yOut = [yOut; m.y(idx_1_a:idx_1_b, idx_2_a:idx_2_b)];
        yOut = m.y(idx_1_a:idx_1_b, idx_2_a:idx_2_b);
        t(k) = toc;
    end
    fprintf(1,'\nReading a chunck of a file using matfile averaged: %g seconds\n', mean(t))
    clear t;
    % toc
    fprintf(1,'\nSize %dx%d\n', size(yOut))
end

if 1    
    % yOut = [];
    % tic
    for k = 1:nIters*10
        tic
        idx_1_a = (nSamps/10)*(k-1) + 1;
        idx_1_b = (nSamps/10)*k;
        idx_2_a = 1;
        idx_2_b = nChs;
        % yOut = [yOut; m.y(idx_1_a:idx_1_b, idx_2_a:idx_2_b)];
        yOut = m.y(idx_1_a:idx_1_b, idx_2_a:idx_2_b);
        t(k) = toc;
    end
    fprintf(1,'\nReading a chunck of a file one-tenth the size using matfile averaged: %g seconds\n', mean(t))
    clear t;
    % toc
    fprintf(1,'\nSize %dx%d\n', size(yOut))
end

% Try reading a whole a .mat file -----------------------------------------
if 1
    tic
    load(filename)
    fprintf(1,'\nReading whole file: %g seconds\n', toc)
end


