export CXX  = nvcc -arch=compute_61 --default-stream=per-thread
export LDFLAGS= -lm
export CFLAGS = -O3 -std=c++11 -ccbin=g++ -Xcompiler -fPIC -Xcompiler -O3
SLIB = python-wrapper/arboretum_wrapper.so
OBJ = io.o param.o garden.o

all: $(OBJ) $(SLIB)

param.o: src/core/param.cpp src/core/param.h

garden.o: src/core/garden.cu src/core/garden.h param.o io.o

io.o: src/io/io.cu src/io/io.h src/core/objective.h

python-wrapper/arboretum_wrapper.so: python-wrapper/arboretum_wrapper.cpp python-wrapper/arboretum_wrapper.h io.o garden.o param.o

$(OBJ) :
	$(CXX) -c $(CFLAGS) -o $@ $(firstword $(filter %.cpp %.c %.cc %.cu, $^) )

$(SLIB) :
	$(CXX) $(CFLAGS) -shared -o $@ $(filter %.cpp %.o %.c %.a %.cc %.cu, $^) $(LDFLAGS)


clean:
	$(RM) -rf $(OBJ) $(SLIB) *.o  */*.o */*/*.o *~ */*~ */*/*~