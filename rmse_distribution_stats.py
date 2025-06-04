import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.gridspec import GridSpec

# read data
rmse_n1_easy = pd.read_csv("/home/lab605/rmse_n1_easy.txt", header=None, names=["RMSE"])
rmse_n8_easy = pd.read_csv("/home/lab605/rmse_n8_easy.txt", header=None, names=["RMSE"])
rmse_n1_hard = pd.read_csv("/home/lab605/rmse_n1_hard.txt", header=None, names=["RMSE"])
rmse_n8_hard = pd.read_csv("/home/lab605/rmse_n8_hard.txt", header=None, names=["RMSE"])

# statistics function
def get_stats_df(df1, df2, label1="n=1", label2="n=8"):
    stats1 = df1["RMSE"].agg(["mean", "std", "min", "max"]).round(3)
    stats2 = df2["RMSE"].agg(["mean", "std", "min", "max"]).round(3)
    stats_df = pd.DataFrame({label1: stats1, label2: stats2})
    stats_df.index = ['μ (avg)', 'σ (std)', 'min', 'max']
    return stats_df

# ---------- EASY ----------
sns.set(style="whitegrid")
fig = plt.figure(figsize=(12, 6))
gs = GridSpec(1, 2, width_ratios=[3, 1]) 

ax0 = fig.add_subplot(gs[0])
sns.kdeplot(rmse_n1_easy["RMSE"], label="n=1", fill=True, linewidth=2, ax=ax0)
sns.kdeplot(rmse_n8_easy["RMSE"], label="n=8", fill=True, linewidth=2, ax=ax0)
ax0.set_title("RMSE Distribution - Easy")
ax0.set_xlabel("RMSE")
ax0.set_ylabel("Density")
ax0.legend(title="Setting")

ax1 = fig.add_subplot(gs[1])
ax1.axis("off")
table_data = get_stats_df(rmse_n1_easy, rmse_n8_easy)
table = ax1.table(cellText=table_data.values,
                  rowLabels=table_data.index,
                  colLabels=table_data.columns,
                  cellLoc='center',
                  loc='center')
table.scale(1.2, 2)  

plt.tight_layout()
plt.show()

# ---------- HARD ----------
fig = plt.figure(figsize=(12, 6))
gs = GridSpec(1, 2, width_ratios=[3, 1])

ax0 = fig.add_subplot(gs[0])
sns.kdeplot(rmse_n1_hard["RMSE"], label="n=1", fill=True, linewidth=2, ax=ax0)
sns.kdeplot(rmse_n8_hard["RMSE"], label="n=8", fill=True, linewidth=2, ax=ax0)
ax0.set_title("RMSE Distribution - Hard")
ax0.set_xlabel("RMSE")
ax0.set_ylabel("Density")
ax0.set_xlim(0, 2)
ax0.legend(title="Setting")

ax1 = fig.add_subplot(gs[1])
ax1.axis("off")
table_data = get_stats_df(rmse_n1_hard, rmse_n8_hard)
table = ax1.table(cellText=table_data.values,
                  rowLabels=table_data.index,
                  colLabels=table_data.columns,
                  cellLoc='center',
                  loc='center')
table.scale(1.2, 2)

plt.tight_layout()
plt.show()

