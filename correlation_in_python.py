# this is a correlation analysis using python to show how corrlation between two numerical values is done 




import pandas as pd
import seaborn as sns
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
plt.style.use('ggplot')
from matplotlib.pyplot import figure 


matplotlib.rcParams['figure.figsize']=(12,8)  # adjust the configuration of tthe plots we will see 

# read in the data 

df=pd.read_csv(r'C:\Users\haona\Desktop\data anlayst project\python project\movies.csv')
# look at the data 

df = df.dropna()# dropping all null values 

# let's see if there is any missing data 

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}% '.format(col,pct_missing))

    # data types for our columns 

print(df.dtypes) 

#create a new column to create a correct year column 
df['yearcorrect'] = df['released'].str.extract(pat = '([0-9]{4})').astype(int)     


df= df.sort_values(by=['gross'],inplace=False,ascending=False)

# guess:  budget is a high correlation for gross 
# company might have a high correlation for gross 

#build a scatterplot with budget vs gross revunes 

plt.scatter(x=df['budget'],y=df['gross'])

plt.title('budget vs gross earnings ')
plt.xlabel('Budget ')

plt.ylabel('Gross earnings ')


print(df.head())
# plot budget vs gross using seaborn

sns.regplot(x='budget',y='gross',data=df,scatter_kws = {"color":"red"},   line_kws={"color":"blue"})

# start looking at correlation 
print(df.corr(method='pearson'))  # pearson, kendall , spearman 

# high correation between budget and gross 


correlation_matrix =df.corr(method='pearson') 

sns.heatmap(correlation_matrix,annot=True)


plt.title( 'correlation matrix for movies ')
plt.xlabel('movie features ')

plt.ylabel('movie features  ')
plt.show()


# look at company 
df_numerized =df

for col_name in df_numerized.columns: 
    if df_numerized[col_name].dtype=='object':
        df_numerized[col_name]=df_numerized[col_name].astype('category')
        df_numerized[col_name]=df_numerized[col_name].cat.codes


correlation_matrix =df.corr(method='pearson') 

sns.heatmap(correlation_matrix,annot=True)


plt.title( 'correlation matrix for movies ')
plt.xlabel('movie features ')

plt.ylabel('movie features  ')
plt.show()



correlation_mat = df_numerized.corr()
corr_pairs = correlation_mat.unstack()

sorted_pairs = corr_pairs.sort_values()
high_corr = sorted_pairs[(sorted_pairs)>0.5]

print(high_corr) # I am trying to look at those only with a high correlation 


# votes and budget have the highest correlation to gross earnings 
# company has low correlation 

# This program created a heat map for different columns within the movie data set look at what factors contribute most to gross earnings  