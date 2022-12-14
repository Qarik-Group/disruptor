#include <iostream>
#include <lzma.h>

int main() {
  std::cout << "Hey there!\n";
  #ifndef WITH_CUDA
  std::cout << "I'm missing my cuda\n";
  #endif
  return 0;
}
