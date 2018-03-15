from libc.math cimport sqrt, floor, log
import numpy as np

def sieve_of_eratosthenes(int upper_limit):
    '''
    sieve_of_eratosthenes consumes an integer, upper_limit, and yields an iterator
    containing all primes under upper_limit

    Parameters
    ==========

    upper_limit (int): Upper limit of sieve

    Yields
    ======

    A generator containing indexed primes under upper_limit
    '''
    # Initialise list of primes
    prime_list = [True] * upper_limit
    prime_list[0] = False
    prime_list[1] = False

    for (n, isprime) in enumerate(prime_list):
        if isprime:
            yield n
            for n in range(n*n, upper_limit, n):
                prime_list[n] = False


def nth_fibonacci(int n):
    '''nth_fibonacci consumes a positive integer n and returns the nth Fibonacci
    number, where f_0 = 0 and f_1 = 1

    Parameters
    ==========

    n (int): the index of the desired Fibonacci number

    Returns
    =======

    The n-th Fibonacci number.
    '''
    cdef float sqrt_5 = 5 ** 0.5
    cdef float phi = (1 + sqrt_5) / 2
    cdef float psi = (1 - sqrt_5) / 2
    return int((phi ** n - psi ** n) / sqrt_5)


def generalised_fibonacci(int upper_limit, int f0 = 0, int f1 = 1):
    '''generalised_fibonacci returns all the elements of the recurrence f_n = f_{n-1} + f_{n-2}
    given base numbers f0 and f1 up to upper_limit

    Parameters
    ==========

    upper_limit (int): The upper limit of the recurrence
    f0 (int) = First number in the sequence
    f1 (int) = Second number in the sequence

    Returns
    =======

    Returns a list containing all the numbers in the sequence
    '''
    cdef int fn = f0 + f1
    fib_numbers = [f0, f1, fn]
    while fn < upper_limit:
        fib_numbers.append(fn)
        fn = f0 + f1
        f0 = f1
        f1 = fn
    return fib_numbers


def collatz_sequence(int seed):
    '''collatz_sequence consumes a seed integer and returns its Collatz sequence, following the rule:
    f(n) = n/2 if n = 0 (mod 2)
    f(n) = 3n+1 if n = 1 (mod 2)

    Parameters
    ==========

    seed (int): The starting point of the sequence

    Returns
    =======

    A list containing the Collatz sequence corresponding to the seed until it terminates at 1
    (assuming the Collatz conjecture, all sequences terminate at 1).
    '''
    seq = [seed]
    while seed > 1:
        if seed % 2 == 0:
            seed = seed // 2
            seq.append(seed)
        else:
            seed = 3 * seed + 1
            seq.append(seed)
    return seq


def is_palindrome(int x):
    '''
    Consumes an integer, x, and determines whether it is a palindrome.

    Parameters
    ==========

    x (int): An integer whose palindrome status is to be determined

    Returns
    =======

    A boolean indicating whether x is a palindrome.
    '''
    cdef:
        int y = x % 10
        int z = x
    x //= 10
    while x != 0:
        y = y * 10 + x % 10
        x //= 10
    return y == z

def totient(int n):
    '''Totient consumes an integer n and returns phi(n), where phi is the Euler
    totient function. The totient function computes the number of integers k
    less than n such that gcd(n,k) = 1.

    Parameters
    ==========

    n (int): argument for the totient function

    Returns
    =======

    phi(n) as an integer

    '''
    cdef:
        int result = n
        double upper_lim_prime = floor(sqrt(n)) + 2
    for p in sieve_of_eratosthenes(upper_lim_prime):
        if n % p == 0:
            while n % p == 0:
                n //= p
            result -= result // p
    if n > 1:
        result -= result // n
    return result

def simpson(f, float a, float b, int n):
  """Approximates the definite integral of f from a to b by the
  composite Simpson's rule, using n subintervals (with n even)"""

  if n % 2:
      raise ValueError("n must be even (received n=%d)" % n)

  cdef:
      float h = (b - a) / n
      float s = f(a) + f(b)
      int i,j

  for i in range(1, n, 2):
      s += 4 * f(a + i * h)
  for j in range(2, n-1, 2):
      s += 2 * f(a + i * h)

  return s * h / 3


def logarithmic_integral(int b, int n):
    ''' Returns the value of the integral 1/(log(t)) from 2 to b using
    Simpson's rule with n subintervals.
    '''
    def integrand(float t):
        return 1 / log(t)
    return simpson(integrand, 2, b, n)


def totient_sieve(int n):
    cdef:
        array.array a = array.array('i', np.zeros(n+1, dtype = np.int8))
        int[:] phi = a
        int i, p, j
    for i in range(1,n+1):
        phi[i] = i
    for p in range(2,n+1):
        if phi[p] == p:
            phi[p] = p-1
            for j in range(2*p, n+1, p):
                phi[j] = (phi[j]//p) * (p-1)
    return phi
