#include <iostream>
#include <unordered_map>
#include <fstream>
#include <sstream>
#include <string>
#include <cstring>
#include <vector>

using namespace std;
using ull = unsigned long long;

// struct Bitfield
// {
//     ull b : 36;
// };

ull mask_bitfield(ull n, string mask)
{
    for (int i = 0; i < 36; i++)
    {
        char m = mask[35 - i];
        switch (m)
        {
        case 'X':
            break;
        case '0':
            n &= ~(1ULL << i);
            break;
        case '1':
            n |= 1ULL << i;
            break;
        }
    }
    return n;
}

std::vector<ull> all_bitfields(ull address, std::string mask)
{
    ull zeros_mask = (1ULL << 37) - 1;
    ull ones_mask = 0;
    for (int i = 0; i < 36; i++)
        if (mask[36 - i - 1] == '1')
            ones_mask += 1ULL << i;
        else if (mask[36 - i - 1] == 'X')
            zeros_mask ^= 1ULL << i;

    std::vector<ull> addresses;
    addresses.push_back((address | ones_mask) & zeros_mask);
    for (int i = 0; i < 36; i++)
        if (mask[36 - i - 1] == 'X')
            for (ull j = 0, size{addresses.size()}; j < size; j++)
                addresses.push_back(addresses[j] | (1ULL << i));

    return addresses;
}

int main()
{
    ifstream infile("input.txt");

    string line;
    string mask;
    unordered_map<ull, ull> comp_mem, comp_mem2;
    while (getline(infile, line))
    {
        istringstream iss(line);

        const char *delim = " = ";
        char *token = strtok(const_cast<char *>(line.c_str()), delim);

        if (strcmp(token, "mask") == 0)
        {
            token = strtok(NULL, delim);
            mask = string(token);
        }
        else
        {
            // Copy memory address to parse
            char addr_string[20];
            strncpy(addr_string, token + strlen("mem["), strlen(token) - 1);
            addr_string[strlen(token) - 1] = '\0';

            ull addr;
            sscanf(addr_string, "%llu", &addr);

            // Get next delim token and merge the bitfield to existing one
            token = strtok(NULL, delim);
            ull in_bf;
            sscanf(token, "%llu", &in_bf);

            // Part 1
            comp_mem[addr] = mask_bitfield(in_bf, mask);

            // Part 2
            const auto &addresses = all_bitfields(addr, mask);
            for (const auto &ad : addresses)
                comp_mem2[ad] = in_bf;
        }
    }

    ull sum = 0;
    for (const auto &item : comp_mem)
        sum += item.second;

    cout << sum << '\n';

    sum = 0;
    for (const auto &item : comp_mem2)
        sum += item.second;

    cout << sum << '\n';
}
