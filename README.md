### A New Multicast Grouping Scheme on Handover

#### This code is for the research "Mobility-Enabled Dynamic Grouping for Multicast Broadcast Service".

1. **To run the code:**
   - Execute `main.m`.
   - To use it, type the following command:
     ```matlab
     main(mode, UE_num, time, pptimer, MRN, groupsize, RM, outage, handover)
     ```

2. **Parameters:**
   - `UE_num`: Number of UEs
   - `time`: Simulation time (unit: seconds)
   - `pptimer`: TTT (time to trigger)
   - `MRN`: Maximum removal number
   - `groupsize`: Average size of the group
   - `RM`: Removal margin
   - `outage`: Threshold of outage users
   - `handover`: Handover margin

   - Note: `RM` and `MRN` are only used for our designed method. You can set arbitrary values for these parameters when using other schemes.

3. **Simulation support:**
   - The simulation supports several different schemes:
     - CQI grouping
     - Group partition method
     - Unicast
     - Broadcast
     - Our proposed method

4. **Before executing the simulation code:**
   - Run `generate_fading.m` to generate random fading maps.
   - **Note:** The size of the fading data may be large.
