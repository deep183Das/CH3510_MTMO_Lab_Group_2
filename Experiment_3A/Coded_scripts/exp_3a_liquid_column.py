import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


# ---- given data ---- #
W_bed = 300  # g
D_p = 0.380  # cm
C_OD, C_ID = 6, 5 # cm
rho_w = 0.99567   # g/cm^3 @ 30 deg C
rho_ccl4 = 1.58   # g/cm^3 @ 30 deg C (not needed though)

# to calculate the density of 1 glass bead from the measured data in lab
rho_p = np.sum([60.075/24.0, 60.95/25.0])/2.0


# ---- practical observations ---- #
# cm of CCl4 [P diff : practical, forward/backward, total]
del_Ppft = [1.1, 3.4, 6.1, 11.1, 18.1, 19.4, 19.4, 19.4, 18.8, 18.7, 18.3]
del_Ppbt = [18.3, 18.8, 19.1, 19.1, 19.5, 18.6, 15.1, 11.0, 4.3, 1.1]

# Height of bed (cm)
H_f = [10.0, 10.0, 10.0, 10.0, 10.0, 10.4, 11.0, 11.5, 12.0, 13.0, 13.5]
H_b = [13.0, 12.0, 11.5, 10.5, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0]

# Volume (ml) equivalent to cm^3
V_f = [[300.0, 280.0, 190.0], [300.0, 340.0, 320.0], [330.0, 310.0, 300.0], [420.0, 420.0, 420.0],
       [390.0, 390.0, 420.0], [550.0, 500.0, 500.0], [510.0, 510.0, 510.0], 
       [460.0, 500.0, 450.0], [470.0, 470.0, 510.0], [600.0, 630.0], [620.0, 600.0, 610.0]]
V_b = [[600.0, 600.0], [580.0, 600.0], [500.0, 500.0],
       [470.0, 490.0], [380.0, 390.0], [380.0, 400.0], 
       [300.0, 300.0], [200.0, 230.0], [200.0, 210.0, 210.0], [300.0, 280.0, 190.0]]

# Time (s)
T_f = [[18.03, 16.71, 11.33], [9.00, 10.01, 9.90], [6.56, 6.59, 6.26], 
       [6.31, 5.85, 5.81], [4.52, 4.53, 4.98], [5.77, 5.35, 5.42], [4.73, 4.71, 4.72],
       [3.69, 4.17, 3.66], [3.51, 3.39, 3.51], [3.76, 3.87], [3.41, 3.54, 3.46]]
T_b = [[3.54, 3.50], [4.00, 4.20], [3.91, 3.87], [4.50, 4.81], [3.85, 4.24],  
       [4.54, 4.85], [4.17, 4.24], [3.14, 3.77], [6.18, 6.89, 6.79], [18.03, 16.71, 11.33]]


# ---- Calculations ---- #
# 1. Volume flow rate (ml/s or cm^3/s)
def vol_flow_rate(V, T):
    avg_flow = 0
    for i in range(len(V)):
        avg_flow += V[i]/T[i]
    return avg_flow / len(V)

F_f = [vol_flow_rate(V_f[i], T_f[i]) for i in range(len(V_f))]
F_b = [vol_flow_rate(V_b[i], T_b[i]) for i in range(len(V_b))]
# print(len(F_f), len(F_b))
# print(F_f[0])


# 2. Superficial Velocity = F / A_column (cm/s)
A = np.pi*(C_ID/2)**2       # area of the column
V_sp_f = [(F_f[i]/A) for i in range(len(F_f))]  # forward
V_sp_b = [(F_b[i]/A) for i in range(len(F_b))]  # backward


# 3. Volume occupied by bed particles in total
V = (4/3)*np.pi*(D_p/2)**3  # volume of 1 glass bead (cm^3)
m_one_glass_bead = V*rho_p  # g
m_bed_glass_bead = W_bed    # g
# number of glass beads in the bed
N_glass_beads = np.ceil(m_bed_glass_bead / m_one_glass_bead)
# print(N_glass_beads)
V_glass_beads = N_glass_beads*V  # total volume occupied by bed particles (cm^3)


# 4. Calculation of bed porosity (void porosity or epsilon) [practical forward/backward]
epsilon_pf = [(1 - (V_glass_beads/(H_f[i]*A))) for i in range(len(H_f))]
# print(list(zip(epsilon_f, H_f)))
epsilon_pb = [(1 - (V_glass_beads/(H_b[i]*A))) for i in range(len(H_b))]


# # 5. Theoretical pressure differece values for fluidized bed
# # cm of CCl4 [P diff : theoretical, forward/backward, total]
# del_Ptft = [((1 - epsilon_f[i])*(rho_p - rho_w)*H_f[i])/rho_ccl4 for i in range(len(H_f))]
# del_Ptbt = [((1 - epsilon_b[i])*(rho_p - rho_w)*H_b[i])/rho_ccl4 for i in range(len(H_b))]
# print(list(zip(del_Ppft, del_Ptft)))
''' Not Possible to do this, as we are using the same data to calculate two related things. So del_p will be 
    constant. Instead I can back-calculate the ɛ value and check with the practically obtained value.
'''

# 6. Theoretical ɛ value.
g = 981.4  # cm/s^2
epsilon_tf = [(1 - (del_Ppft[i]/((rho_p - rho_w)*H_f[i]*g))) for i in range(len(H_f))]
epsilon_tb = [(1 - (del_Ppbt[i]/((rho_p - rho_w)*H_b[i]*g))) for i in range(len(H_b))]
# print(list(zip(epsilon_pf, epsilon_tf)))
# print(list(zip(epsilon_pb, epsilon_tb)))


# 7. minimum fluidization velocity
y = (np.max(del_Ppft) + np.max(del_Ppbt))/2.0
x = (V_sp_f[np.argmax(del_Ppft)] + V_sp_b[np.argmax(del_Ppbt)])/2.0



# ---- Generating plots ---- #
# plot-1 : pressure drop(y) vs superficial velocity(x)
plt.figure(1)
plt.plot(V_sp_f, del_Ppft, label='forward')
plt.scatter(V_sp_f, del_Ppft, s=7, c='r')

plt.plot(V_sp_b, del_Ppbt, label='backward')
plt.scatter(V_sp_b, del_Ppbt, s=7, c='r')

y_val = np.array(np.linspace(0, y, 200))
x_val = np.array([x]*200)
plt.plot(x_val, y_val, '--')
plt.text(5.0, 0.5, r'$V_f$ : Minimum Fluidization Velocity')
plt.ylim([0, np.max(y_val) + 2])
plt.xlabel('Superficial Velocity (cm/s)')
plt.ylabel(r'Pressure Drop (cm of $CCl_4$)')
plt.title('Change of pressure with superficial veloity')
plt.grid(alpha=0.4)
plt.legend(loc='best')
plt.savefig('fig_p_drop_vs_vel_sp.png', bbox_inches='tight')
plt.show()


# plot-2 : bed height(y) vs superficial velocity(x)
plt.figure(2)
plt.plot(V_sp_f, H_f, label='forward')
plt.scatter(V_sp_f, H_f, s=7, c='r')

plt.plot(V_sp_b, H_b, label='backward')
plt.scatter(V_sp_b, H_b, s=7, c='r')

plt.xlabel('Superficial Velocity (cm/s)')
plt.ylabel('Bed Height (cm)')
plt.title('Bed height vs Superficial velocity')
plt.grid(alpha=0.4)
plt.legend(loc='best')
plt.savefig('fig_bed_vs_vel_sp.png', bbox_inches='tight')
plt.show()


# plot-3 : theoretical ɛ(x) vs practical ɛ(y)
plt.figure(3)
plt.plot(epsilon_tf, epsilon_pf, label='forward')
plt.scatter(epsilon_tf, epsilon_pf, s=7, c='r')

plt.plot(epsilon_tb, epsilon_pb, label='backward')
plt.scatter(epsilon_tb, epsilon_pb, s=7, c='r')

plt.xlabel(r'$\epsilon_{\text{theoretical}}$')
plt.ylabel(r'$\epsilon_{\text{practical}}$')
plt.title('Practical & Theoretical Values of Porosity of bed')
plt.grid(alpha=0.4)
plt.legend(loc='best')
plt.savefig('fig_epsilon.png', bbox_inches='tight')
plt.show()



# ---- creating CSV files ---- #
column_values = [r'Volume Flow rate ($cm^3/s$)', 'Superficial Velocity (cm/s)', 'Bed Porosity']
df_f = pd.DataFrame(list(zip(F_f, V_sp_f, epsilon_pf)), columns=column_values)
df_f.to_csv("data_forward.csv")

df_b = pd.DataFrame(list(zip(F_b, V_sp_b, epsilon_pb)), columns=column_values)
df_b.to_csv("data_backward.csv")