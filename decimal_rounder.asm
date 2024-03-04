#####################################################################
# Programmer: Jacob St Lawrence
# Last Modified: 04.07.2023
#####################################################################
# Functional Description:
# This program prompts the user to input a decimal value with at
# least 5 decimal places and a precision value between 1 and 4.
# It then rounds the decimal value to the number of decimal places
# per the selected precision value and displays the result.
#####################################################################
# Pseudocode:
#
# main:
#	print numberPrompt
#	cin >> f0
#	f2 = f0 * 10000
#	f4 = round f2
#	f6 = float(f4)
#	if (f2 == f6)
#		branch to decimalError
#	else cout << f0
#
# setPrecision:
#	print precPrompt
#	cin >> s0
#	if s0 == 1; branch to prec1
#	elif s0 == 2; branch to prec2
#	elif s0 == 3; branch to prec3
#	elif s0 == 4; branch to prec4
#	else; branch to precisionError
#
# prec1:
#	print precOut1
#	f2 = f0 * 10
#	f4 = round f2
#	f6 = float(f4)
#	f8 = f6 / 10
#	branch to results
#
# prec2:
#	print precOut2
#	f2 = f0 * 100
#	f4 = round f2
#	f6 = float(f4)
#	f8 = f6 / 100
#	branch to results
#
# prec3:
#	print precOut2
#	f2 = f0 * 1000
#	f4 = round f2
#	f6 = float(f4)
#	f8 = f6 / 1000
#	branch to results
#
# prec4:
#	print precOut2
#	f2 = f0 * 10000
#	f4 = round f2
#	f6 = float(f4)
#	f8 = f6 / 10000
#	branch to results
#
# decimalError:
#	print decError
#	branch to main
#
# precisionError:
#	print precError
#	branch to setPrecision
#
# results:
#	cout << outHeader1 << f0 << outHeader2 << s0 << colon << f8
#	print bye
#	terminate program
#
#####################################################################
# Register Usage:
# $s0: Precision Selection
# $f0: Input Floating Point Value
# $f2: Multiplied Floating Point Value
# $f4: Multiplied & Rounded Value (word)
# $f6: Multiplied & Rounded Value (float)
# $f8: Rounded Floating Point
# $f10: Multiplier
#####################################################################

		.data
numberPrompt:	.asciiz "Please enter a decimal number with at least 5 decimal places: "
numberOut:	.asciiz "The original number entered was: "
precPrompt:	.asciiz "\nPlease enter a precision value between between 1 and 4: "
precOut1:	.asciiz "You selected to set the precision to 1 decimal place.\n"
precOut2:	.asciiz "You selected to set the precision to 2 decimal places.\n"
precOut3: 	.asciiz "You selected to set the precision to 3 decimal places.\n"
precOut4:	.asciiz "You selected to set the precision to 4 decimal places.\n"
outHeader1:	.asciiz	"Original Number: "
outHeader2:	.asciiz	"\nPrecision - "
colon:		.asciiz	": "
decError:	.asciiz	"Input does not contain at least 5 decimal places. Try again.\n"
precError:	.asciiz "Input is not between 1 and 4. Please try again"
bye:		.asciiz "\nGoodbye!"
times10:	.float	10.0
times100:	.float	100.0
times1000:	.float	1000.0
times10000:	.float	10000.0

		.text

main:		li		$v0, 4			# system call code to print string
		la		$a0, numberPrompt	# load address of numberPrompt string into argument to print
		syscall					# print numberPrompt string

		li		$v0, 6			# system call code to read floating point
		syscall					# read floating point

		l.s		$f10, times10000	# load the address for the float 10000.0 into f10 for multiplier
		mul.s		$f2, $f0, $f10		# multiply input floating point by 10000.0 to remove 4 decimal places

		round.w.s 	$f4, $f2		# round resulting product to word
		cvt.s.w 	$f6, $f4		# convert word to equivalent floating point

		c.eq.s		$f2, $f6		# check if product and rounded product are equal
		bc1t 		decimalError		# if equal, branch to decimal_error


		li		$v0, 4			# system call code to print string
		la		$a0, numberOut		# load address of numberOut string into argument to print
		syscall					# print numberOut string

		li		$v0, 2			# system call code to print floating point
		mov.s 		$f12, $f0		# move user input floating point into argument for printing
		syscall					# print user input floating point

# prompt for precision selection and branch to block for specified precision or error
setPrecision:	li		$v0, 4			# system call code to print string
		la		$a0, precPrompt		# load address of precPrompt string into argument to print
		syscall					# print precPrompt string

		li		$v0, 5			# system call code to read integer
		syscall					# read integer
		move		$s0, $v0		# move user input integer into s0

		beq		$s0, 1, prec1		# if 1 was selected, branch to prec1
		beq		$s0, 2, prec2		# if 2 was selected, branch to prec2
		beq		$s0, 3, prec3		# if 3 was selected, branch to prec3
		beq		$s0, 4, prec4		# if 4 was selected, branch to prec4

		b		precisionError		# if none of the values 1-4 were selected, branch to precisionError

# round to 1 decimal place by multiplying by 10, rounding, then dividing by 10
prec1:		li		$v0, 4			# system call code to print string
		la		$a0, precOut1		# load address of precOut1 string into argument for printing
		syscall					# print precOut1 string

		l.s		$f10, times10		# load 10.0 into multiplier
		mul.s		$f2, $f0, $f10		# multiply input floating point by 10.0 and place in f2

		round.w.s	$f4, $f2		# round f2 and place resulting word in f4
		cvt.s.w		$f6, $f4		# convert rounded value back into floating point and place in f6

		div.s		$f8, $f6, $f10		# divide rounded value by 10.0

		b		results			# branch to results

# round to 2 decimal places by multiplying by 100, rounding, then dividing by 100
prec2:		li		$v0, 4			# system call code to print string
		la		$a0, precOut2		# load address of precOut1 string into argument for printing
		syscall					# print precOut1 string

		l.s		$f10, times100		# load 100.0 into multiplier
		mul.s		$f2, $f0, $f10		# multiply input floating point by 100.0 and place in f2

		round.w.s	$f4, $f2		# round f2 and place resulting word in f4
		cvt.s.w		$f6, $f4		# convert rounded value back into floating point and place in f6

		div.s		$f8, $f6, $f10		# divide rounded value by 100.0
		b		results			# branch to resultss

# round to 3 decimal places by multiplying by 1000, rounding, then dividing by 1000
prec3:		li		$v0, 4			# system call code to print string
		la		$a0, precOut3		# load address of precOut1 string into argument for printing
		syscall					# print precOut1 string

		l.s		$f10, times1000		# load 1000.0 into multiplier
		mul.s		$f2, $f0, $f10		# multiply input floating point by 1000.0 and place in f2

		round.w.s	$f4, $f2		# round f2 and place resulting word in f4
		cvt.s.w		$f6, $f4		# convert rounded value back into floating point and place in f6

		div.s		$f8, $f6, $f10		# divide rounded value by 1000.0
		b		results			# branch to results

# round to 4 decimal places by multiplying by 10000, rounding, then dividing by 10000
prec4:		li		$v0, 4			# system call code to print string
		la		$a0, precOut4		# load address of precOut1 string into argument for printing
		syscall					# print precOut1 string

		l.s		$f10, times10000	# load 10000.0 into multiplier
		mul.s		$f2, $f0, $f10		# multiply input floating point by 10000.0 and place in f2

		round.w.s	$f4, $f2		# round f2 and place resulting word in f4
		cvt.s.w		$f6, $f4		# convert rounded value back into floating point and place in f6

		div.s		$f8, $f6, $f10		# divide rounded value by 10000.0
		b		results			# branch to results

# if float input did not have at least 5 decimal places, print error message and branch back to main to try again
decimalError:	li		$v0, 4			# system call code to print string
		la		$a0, decError		# load address of decError string into argument to print
		syscall					# print decError string
		b		main			# branch to main to try again

# if precision selection was not between 1 and 4. print error message and branch back to setPrecision to try again
precisionError:	li		$v0, 4			# system call code to print string
		la		$a0, precError		# load address of precError string into argument to print
		syscall					# print precError string
		b		setPrecision		# brnach to setPrecision to try again

# display results and terminate program
results:	li		$v0, 4			# system call code to print string
		la		$a0, outHeader1		# load address of outHeader1 string into argument to print
		syscall					# print outHeader1 string

		li		$v0, 2			# system call code to print floating point
		mov.s		$f12, $f0		# move input floating point into argument to print
		syscall					# print input floating point

		li		$v0, 4			# system call code to print string
		la		$a0, outHeader2		# load address of outHeader2 string into argument to print
		syscall					# print outHeader2 string

		li		$v0, 1			# system call code to print integer
		move		$a0, $s0		# move precision integer into argument to print
		syscall					# print precision integer

		li		$v0, 4			# system call code to print string
		la		$a0, colon		# load address of colon string into argument to print
		syscall					# print colon string

		li		$v0, 2			# system call code to print floating point
		mov.s		$f12, $f8		# move rounded floating point into argument to print
		syscall					# print rounded floating point

		li		$v0, 4			# system call code to print string
		la		$a0, bye		# load address of bye string into argument to print
		syscall					# print bye string

		li		$v0, 10			# system call code to terminate program
		syscall					# terminate program

							# END OF PROGRAM
