import numpy as np
import pandas as pd

import matplotlib.pyplot as plt
import matplotlib.cm as cm

import tensorflow as tf

# settings
LEARNING_RATE = 1e-4
# set to 20000 on local environment to get 0.99 accuracy
TRAINING_ITERATIONS = 2500

DROPOUT = 0.5
BATCH_SIZE = 50

# set to 0 to train on all available data
VALIDATION_SIZE = 2000

# image number to output
IMAGE_TO_DISPLAY = 10

data = pd.read_csv('train.csv')

images = data.iloc[:,1:].values

# convert from [0:255] => [0.0:1.0]
images = np.multiply(images, 1.0 / 255.0)
print('images({0[0]},{0[1]})'.format(images.shape))
image_size = images.shape[1]
image_width = image_height = np.ceil(np.sqrt(image_size)).astype(np.uint8)
print ('image_width => {0}\nimage_height => {1}'.format(image_width,image_height))

labels_flat = data[[0]].values.ravel()
print('labels_flat({0})'.format(len(labels_flat)))
print ('labels_flat[{0}] => {1}'.format(IMAGE_TO_DISPLAY,labels_flat[IMAGE_TO_DISPLAY]))

labels_count = np.unique(labels_flat).shape[0]
print('labels_count => {0}'.format(labels_count))

def main():
	display(images[IMAGE_TO_DISPLAY])


def display(img):

	# (784) => (28,28)
	one_image = img.reshape(image_width,image_height)

	plt.axis('off')
	plt.imshow(one_image, cmap=cm.binary)

