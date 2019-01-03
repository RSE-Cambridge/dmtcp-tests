#include <iostream>
#include <chrono>
#include <thread>

int main(int argc, char *argv[])
{
    using namespace std::this_thread;
    using namespace std::chrono; 
        
    for (int i=0; i<120; i++)
    {
        sleep_for(seconds(1));
    
        std::cout << "Count: " << i << std::endl;
    }
}