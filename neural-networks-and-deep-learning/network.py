import numpy as np
class Network(object):

	def __init__(self, sizes):
		self.num_layers = len(sizes)
		self.sizes = sizes
		self.biasis = [np.random.rand(y, 1) for y in sizes[1:]]
		self.weights = [np.random.rand(y, x) for x,y in zip(sizes[:-1], sizes[1:])]

	def feedforward(self, a):
		for b, w in zip(self.biasis, self.weights):
			sigmoid(np.dot(w, a) + b)

	def SGD(self, training_data, epochs, batch_size, eta, test_data=None):
		pass


def sigmoid(z):
	return 1.0/(1.0+np.exp(-z))


