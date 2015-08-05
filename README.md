# PROPOSED_ALG
Proposed Algorithm on Quality-Constrained NN System (Approximate Synapses)

Run MLP_sim.m

This will run greedy algorithm to set precision ratio for low-power operation on quality-constrained NN system.
It uses pre-trained data from APPRX_TEST.
Training was done with multiple bit-precisions (32bit, 28bit, ..., 16bit) to show the impact of training bit-width on testing of NN system.
There are three test benchs: 1) MNIST, 2) LETTER, 3) CNAE-9.
