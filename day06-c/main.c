#include <stdio.h>
#include <limits.h>

#define CHAR_IDX 97

unsigned long countSetBits(unsigned long n)
{
    unsigned long count = 0;
    while (n)
    {
        count += n & 1;
        n >>= 1;
    }
    return count;
}

int main()
{
    FILE *filePointer;
    // 26 characters, 1 newline, 1 terminating
    int bufferLength = 28;
    char buffer[bufferLength];

    filePointer = fopen("input.txt", "r");

    unsigned long sum = 0;
    unsigned long all_bitfield = ULONG_MAX;
    while (fgets(buffer, bufferLength, filePointer))
    {
        if (buffer[0] == '\n')
        {
            // Line break clear group and increment sum
            sum += countSetBits(all_bitfield);
            all_bitfield = ULONG_MAX;
            continue;
        }

        unsigned long bitfield = 0;
        for (unsigned int i = 0; i < bufferLength; i++)
        {
            char c = buffer[i];
            if (c == '\n' || c == '\0')
            {
                break;
            }

            // Set bit at character index (CHAR_IDX subtract doesn't matter, but aligns)
            bitfield |= 1 << ((unsigned long)(c) - CHAR_IDX);
        }

        // Keep only votes that all others have also voted for
        all_bitfield &= bitfield;
    }

    // Sum last bits set, no line break at EOF
    sum += countSetBits(all_bitfield);

    printf("SUM %lu", sum);

    fclose(filePointer);
    return 0;
}