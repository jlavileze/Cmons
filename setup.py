from distutils.core import setup
from disutils.extension import Extension
from Cython.Build import cythonize

try:
    from Cython.Distutils import build_ext
except ImportError:
    use_cython = False
else:
    use_cython = True

cmdclass = {}
ext_modules = []

if use_cython:
    ext_modules += [
        Extension("Cmons.NumberTheory", ["cython/NumberTheory.pyx"])
    ]
    cmdclass.update({'build_ext':build_ext})
else:
    ext_modules += [
        Extension("Cmons.NumberTheory", ["cython/NumberTheory"])


setup(name='Cmons',
      version='0.1.0',
      url='https://github.com/jlavileze/Cmons',
      author='Jose Avilez',
      packages='Cmons',
      cmdclass=cmdclass,
      ext_modules=ext_modules,
      classifiers=[
        'Programming Language :: Python :: 3.6'
      ]
)
