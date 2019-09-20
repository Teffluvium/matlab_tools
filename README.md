If you would like Matlab to dynamically upate your path at startup do the following:
- Update your Matlab shortcut to start in the directory where you saved the Matlab_Tools repository.
- Copy the **startup.m.template** file and save it as **startup.m**.
- Edit the `basepath` variable in **startup.m** to match the location where you saved the Matlab_Tools repository.
    - Ex.: `basePath = 'C:\Your\Path\Here\';`