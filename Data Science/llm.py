import os
from langchain import FewShotPromptTemplate
from langchain import PromptTemplate
from langchain.memory import ConversationBufferMemory
from langchain.chains import LLMChain
from langchain.chat_models import ChatOpenAI
import pandas as pd 

#from system import openaiapikey
os.environ['OPENAI_API_KEY']='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'#openaiapikey

chat = ChatOpenAI(model='gpt-3.5-turbo',temperature=0)

data=pd.read_csv("C:\\Users\\advea\\Downloads\\Dataset2 - Copy.csv",header=0)

subcategory_counts = data['product_sub_catagory'].value_counts()
sorted_subcategories = subcategory_counts.index

top_subcategories = list(sorted_subcategories[:700])
top_subcategories=",".join(top_subcategories)

del data,subcategory_counts, sorted_subcategories


examples = [
    {
        "question":"What are some products I should buy if I'm already buying shoes",
        "answer":'''
        Socks,Shoe Polish,Insoles
        '''
    },
    {
        "question":"What are some products I should buy if I'm already buying laptops",
        "answer":'''
        Mouse,Laptop Case,Keyboard
        '''
    },
    {
        "question":"What are some products I should buy if I'm already buying school bags",
        "answer":'''
        Books,Pens,Pencils
        '''
    },
    {
        "question":"What are some products I should buy if I'm already buying beds",
        "answer":'''
        Blankets,Pillows,Bedsheet
        '''
    },
    {
        "question":"What are some products I should buy if I'm already buying toys",
        "answer":'''
        Chocolates,Arts and Craft,Board Games
        '''
    }
]

example_template = """
User: {question}
AI: {answer}
"""
example_prompt = PromptTemplate(
    input_variables=["question", "answer"],
    template=example_template
)

prefix = """ The assisstant is a world class recommender of products. The assisstant gives 3 most appropriate items most compatible with product in question
Here are some examples of excerpts between user and the assiatant. Give only 3 products as the output from:"""+top_subcategories

suffix = """
User: {question}
AI: """

few_shot_prompt_template = FewShotPromptTemplate(
    examples=examples,
    example_prompt=example_prompt,
    prefix=prefix,
    suffix=suffix,
    input_variables=["question"],
    example_separator="\n\n"
)

memory = ConversationBufferMemory(
    memory_key='chat_history',
    return_messages=True
)

chain = LLMChain(llm=chat, prompt=few_shot_prompt_template,verbose=True,memory=memory)


#Start of Flask Application

def ask(product):
    return chain.predict(question="What are some products I should buy if I'm already buying "+product)
    #output eg "prod1,prod2,prod3"

print(ask('laptop'))
#End of Flutter application