dict = {
    'SUM': '00000',
    'SUMI': '00100',
    'RST': '00001',
    'RSTI': '00101',
    'MOV': '000001110',
    'MOVI': '001001110',
    'COM': '00010',
    'COMI': '00110',
    'GEM': '01000',
    'CDM': '01001',
    'SI': '100000',
    'SIQ': '101001',
    'SME': '101010',
    'SMA': '101011',
    'SMEI': '101100',
    'SMAI': '101101',
    'R0': '0000',
    'R1': '0001',
    'R2': '0010',
    'R3': '0011',
    'R4': '0100',
    'R5': '0101',
    'R6': '0110',
    'R7': '0111',
    'R8': '1000',
    'R9': '1001',
    'R10': '1010',
    'R11': '1011',
    'R12': '1100',
    'R13': '1101',
    'R14': '1110',
    'R15': '1111',
    '#0': '0000',
    '#1': '0001',
    '#2': '0010',
    '#3': '0011',
    '#4': '0100',
    '#5': '0101',
    '#6': '0110',
    '#7': '0111',
    '#8': '1000',
    '#9': '1001',
    '#10': '1010',
    '#11': '1011',
    '#12': '1100',
    '#13': '1101',
    '#14': '1110',
    '#15': '1111',
    'XX': '1111'
}

def interpretador():
    codeList = []
    with open("code.txt",'r') as f:
        for line in f:
            data = line.replace(",","")
            print(data)
            data = data.split()
            if data[0] == "COM" or data[0] == "COMI":
                data.insert(2, "XX")
            codeList.append(data)
        print(codeList)
    
    with open("outCode.txt",'w') as f:
        for idx, instruction in enumerate(codeList):
            binLine = ''
            
            if len(instruction) > 1:
                print(instruction)
                print(len(instruction))
                
                if instruction[0] == "SI" or instruction[0] == "SIQ" or instruction[0] == "SME" or instruction[0] == "SMA" or instruction[0] == "SMEI" or instruction[0] == "SMAI":
                    binLine = dict[instruction[0]]
                    contLabel = 0
                    dist = 0
                    destIdx = codeList.index([instruction[1]]) + 1
                    print(destIdx)
                    getbinary = lambda x, n: format(x, 'b').zfill(n)
                    n = 0
                    i = idx
                    while n < 2:
                        print(i)
                        if len(codeList[i+1]) != 1:
                            n+=1
                        i+=1
                        
                            
                    print(i)
                    if i < destIdx:
                        print("i<destIdx")
                        n = i
                        while n < destIdx:
                            if len(codeList[n]) == 1:
                                contLabel+=1
                            n+=1
                        print(contLabel)
                        dist = destIdx-i-contLabel
                        binLine = binLine + getbinary(dist, 11)   
                    else:
                        print("i>destIdx")
                        n=1
                        while n >= destIdx:
                            if n>len(codeList)-1:
                                n-=1
                            else:
                                if len(codeList[n]) == 1:
                                    contLabel+=1
                            n-=1
                        dist = i - destIdx - contLabel
                        binLine = binLine + findTwoscomplement(getbinary(dist, 11))
                else:
                    for element in instruction:
                        binLine = binLine + dict[element]
                    
                binLine = binLine + ('\n')
                f.write(binLine)

# Function to find two's complement
def findTwoscomplement(str):
    n = len(str)
 
    # Traverse the string to get first
    # '1' from the last of string
    i = n - 1
    while(i >= 0):
        if (str[i] == '1'):
            break
 
        i -= 1
 
    # If there exists no '1' concatenate 1
    # at the starting of string
    if (i == -1):
        return '1'+str
 
    # Continue traversal after the
    # position of first '1'
    k = i - 1
    while(k >= 0):
         
        # Just flip the values
        if (str[k] == '1'):
            str = list(str)
            str[k] = '0'
            str = ''.join(str)
        else:
            str = list(str)
            str[k] = '1'
            str = ''.join(str)
 
        k -= 1
 
    # return the modified string
    return str

interpretador()