#OpeRNtion Code

op = {
    'SUM': '',
    'SUMI': '',
    'RST': '',
    'RSTI': '',
    'MOV': '',
    'MOVI': '',
    'COM': '',
    'COMI': '',
    'GEM': '',
    'CDM': '',
    'SI': '',
    'SIQ': '',
    'SME': '',
    'SMA': '',
    'SMEI': '',
    'SMAI': ''  
}

# Functions
functions = {
    'RR': {
        'SUM': '',
        'SUMI': '',
        'RST': '',
        'MOV': '',
        'COM': ''
    },
    'RK': {
        'SUMI': '',
        'RSTI': '',
        'MOVI': '',
        'COMI': '',
        'MOVI': ''
    },
    'MM': {
        'GEM': '',
        'CDM': ''
    },
    'IC': {
        'RI': '',
        'RIQ': '',
        'RMQ': ''
    }
}

class Compiler:
    def __compileInstruction(self, instruction):
        if instruction['type'] == 'RR':
            opCode = op[instruction['I']]
            rd = bin(int(instruction['RD'][1:]))[2:]
            rn = bin(int(instruction['RN'][1:]))[2:]
            rm = bin(int(instruction['RM'][1:]))[2:]

            return f'{opCode}-{functions["RR"][instruction["I"]]}-{"0"*(4 - len(rd)) + rd}-{"0"*(4 - len(rn)) + rn}-' +\
                   f'{"0"*(4 - len(rm)) + rm}'

        elif instruction['type'] == 'RK':
            opCode = op[instruction['I']]
            rd = bin(int(instruction['RD'][1:]))[2:]
            rn = bin(int(instruction['RN'][1:]))[2:]
            k = '0'*4

            return f'{opCode}-{functions["RK"][instruction["I"]]}-{"0"*(4 - len(rd)) + rd}-{"0"*(4 - len(rn)) + rn}-' +\
                   f'{"0"*(4 - len(k)) + k}'

        elif instruction['type'] == 'MM':
            opCode = op[instruction['I']]
            rd = bin(int(instruction['RD'][1:]))[2:]
            rn = bin(int(instruction['RN'][1:]))[2:]
            k = '0'*6

            return f'{opCode}-{functions["MM"][instruction["I"]]}-{("0"*(4 - len(rd)) + rd)}-{"0"*(4 - len(rn)) + rn}-' +\
                   f'{"0"*(6 - len(k)) + k}'

        else:
            opCode = op[instruction['I']]
            flag = bin(int(instruction['flag'], 16))[2:]

            return f'{opCode}--{functions["MM"][instruction["I"]]}-{("0"*(12 - len(flag)) + flag)}'

    def compile(self, lines: list):
        output = []
        dump = []

        for line in lines:
            compiledLine = self.__compileInstruction(line)
            dump.append(compiledLine)
            hexLine = hex(int(compiledLine.replace('-', ''), 2))[2:].upper()
            hexLine = (8 - len(hexLine))*'0' + hexLine
            output.append(hexLine)

        with open('tools/.temp/compile.txt', 'w') as file:
            file.write("\n".join(output))
        
        with open('tools/.temp/dump.txt', 'w') as file:
            file.write("\n".join(dump))

        return output