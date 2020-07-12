# Adept-Viper-Drawing-Robot

This project is the text-removed programs within my ACE-powered robot controller. The language is eV+ and NOT assembly, but this was the closest program for importing types

by: Matthew Daniel
emial: mrd89@cornell.edu


##functionality
This program will connect the robot to a connected serial port. Once connected, the program waits for the communication to send 2 comma seperated numbers and places them in a circular buffer. The other program interperates this and draws between each of the points sent to the controller.