import os
import pandas as pd
import numpy as np
from surprise.model_selection import cross_validate, train_test_split, KFold
from surprise import Reader, Dataset, SVD, accuracy
from collections import defaultdict
from heapq import nlargest
from sklearn.metrics.pairwise import pairwise_distances

dataset=pd.read_csv('/kaggle/input/recommendations/transaction_dataset.csv')
print(dataset.head())
reader = Reader(rating_scale=(1, 5))

data = Dataset.load_from_df(dataset[[ 'user_id','pid', 'rating']], reader)

kf = KFold(n_splits=10)
kf.split(data)
svd = SVD(n_factors=500,n_epochs=20, lr_all=0.005, reg_all=0.02)
result=cross_validate(svd, data, measures=['RMSE', 'MAE'])

trainset = data.build_full_trainset()
svd.fit(trainset)

user_items = defaultdict(list)
i=1
for user_id, pid, rating in dataset[['user_id', 'pid', 'rating']].values:
    #if(i%5000==0): print(i)
    i+=1
    user_items[user_id].append((pid, rating))


'''FLASK SECTION'''
# Define a function to generate recommendations for a given user
def get_top_n_recommendations(model, user_id, n=5):
    unrated_items = []
    for item in trainset.all_items():
        if item not in user_items[user_id]:
            unrated_items.append(item)
    
    predictions = []
    for item_id in unrated_items:
        predicted_rating = model.predict(user_id, item_id).est
        predictions.append((item_id, predicted_rating))
    
    top_n_recommendations = sorted(predictions, key=lambda x: x[1], reverse=True)[:n]
    top_n_recommendations= [str(product) for product,rating in top_n_recommendations]
    return ",".join(top_n_recommendations)
    #id1,id2,id3


'''END OF FLASK'''
'''
target_user_id = ' ZXMJ'  # Replace with the user ID you want to generate recommendations for
recommendations = get_top_n_recommendations(svd, target_user_id, n=5)

print("Top 5 recommended products for user", target_user_id)
for item_id, predicted_rating in recommendations:
    print("Product ID:", item_id, "Predicted Rating:", predicted_rating)

'''


