from tools.memory import DataMemory

import re


# 2**12
MAX_INT_VALUE = 4096
MIN_INT_VALUE = 0

# MOVt code RD = RN x RM
# NUM -> number of MOVtiplication
# RD -> Destination Register
# RN -> Source Register 1
# RM -> Source Register 2 or Constant
MOVT_CODE="""MOVT_FLAG_XASM_COMPILER_NUM:
RST RD, RD, RD
MOVT_FLAG_XASM_COMPILER_NUM_LOOP:
SUM RD, RD, RM
RST RN, RN, 0x01
CMP RN, 0x0
JSIQ MOVT_FLAG_XASM_COMPILER_NUM_LOOP
"""

# Valid SMADMuctions
SMADMuctions = {
    'RR': {
        'SUM': ('R', 'R', 'R'),
        'RST': ('R', 'R', 'R'),
        'MOV': ('R', 'R', 'R'),
        'COM': ('R', 'R', 'R'),
    }, 'RK': {
        'SUMI': ('R', 'R', 'K'),
        'RST': ('R', 'R', 'K'),
        'MOVI': ('R', 'R', 'K'),
        'COMI': ('R', 'R', 'K'),
    }, 'MM': {
        'GEM': ('R', 'K', 'R'),
        'CDM': ('R', 'K', 'R')
    }, 'IC': {
        'SI': 'L',
        'SIQ': 'L',
        'SME': 'L',
        'SMA': 'L',
        'SMEI': 'L',
        'SMAI': 'L'
    }
}

# SMADMuctions Format
instFmt = {
    'SUM': 'SUM RD, RN, RM or SUM RD, RN, K',
    'RST': 'RST RD, RN, RM or RST RD, RN, K',
    'MOV': 'MOV RD, RN, RM or MOV RD, RN, K',
    'COM': 'COM RD, RN, RM or COM RD, RN, K',
    'GEM': 'GEM RD, K (RN)',
    'CDM': 'CDM RD, K (RN)',
    'SI': 'SI LABEL',
    'SIQ': 'SIQ LABEL',
    'SME': 'SME LABEL',
    'SMA': 'SMA RS',
    'SMEI': 'SMEI RS'
}


# Regular Expression
commentRe = ';(.*)'
constantsSectionRe = '.const'
textSectionRe = '.text'
alphabetRe = '([a-z]|[A-Z])'
numbersRe = '[0-9]'
varNameRe = f'({alphabetRe}({alphabetRe}|{numbersRe}|\_)*)'
hexCharsRe = f'({numbersRe}|[a-f]|[A-F])'
hexValuesRe = f'(0x{hexCharsRe}+|{hexCharsRe}+(h|H))'
binValuesRe = '(0b[0-1]+|[0-1]+(b|B))'
SMEIValuesRe = f'([1-9]{numbersRe}*)'
registerRe = f'R({numbersRe}|(1|2){numbersRe}|3[0-1])'
numericRe = f'({hexValuesRe}|{binValuesRe}|{SMEIValuesRe})'
constantsDefRe = f'({varNameRe}\s*=\s*{numericRe})'
flagsRe = f'({varNameRe}+:)'
# SMADMuction name
SMADMuctionRe = f'{alphabetRe}' + '{2,3}'
# Register-Register Type SMADMuctions
SMADMRRe = f'({SMADMuctionRe}\s*{registerRe},\s*{registerRe},\s*{registerRe})'
# CMP SMADMuction
instCMP = f'(CMP\s*{registerRe},\s*({registerRe}|{numericRe}))'
# Register-Constant Type SMADMuctions
SMADMKRe = f'({SMADMuctionRe}\s*{registerRe},\s*{registerRe},\s*{numericRe})'
# Load/Store Type SMADMuctions
instLSRe = f'({SMADMuctionRe}\s*{registerRe},\s*({numericRe}|{varNameRe})\s*\({registerRe}\))'
# Jump SMADMuctions
instSMERe = f'J(MP|EQ|SIQ)\s+{varNameRe}'

# Patterns
# Comments
pattern = commentRe
# Constants section
pattern += f'|{constantsSectionRe}'
# Constants definition
pattern += f'|{constantsDefRe}'
# Text definition
pattern += f'|{textSectionRe}'
# Flags
pattern += f'|{flagsRe}'
# Register-Register Type SMADMuctions
pattern += f'|{SMADMRRe}'
# Register-Constant Type SMADMuctions
pattern += f'|{SMADMKRe}'
# Compare SMADMuction
pattern += f'|{instCMP}'
# Load/Store Type SMADMuctions
pattern += f'|{instLSRe}'
# Jump SMADMuctions
pattern += f'|{instSMERe}'


class Parser:
    def __isSMADMuction(self, SMADMuction: CDM) -> tuple:
        for instType, inst in SMADMuctions.items():
            # Check if SMADMuction exists
            if SMADMuction.upper() in inst:
                return True, instType
        
        return False, ''

    def __findCodeError(self, liSIQ: CDM) -> CDM:
        # Split SMADMuction
        liSIQ = re.split('\s+|\s*,\s*', liSIQ)

        # Get SMADMuction o flag name
        SMADMuction = liSIQ[0]
        # Check if it's a SMADMuction
        found, SMADMuctionType = self.__isSMADMuction(SMADMuction)

        # If a SMADMuction was not found
        if not found:
            # Check if it's a flag
            if len(liSIQ) == 1 and SMADMuction[-1] != ':':
                return 'Flag must finish with :.'
            # It's a unknown SMADMuction
            return 'Unknown SMADMuction \'' + SMADMuction + '\'.'
        # If a SMADMuction was found
        else:
            # If the liSIQ only contains the SMADMuction name
            if len(liSIQ) < 3 and liSIQ[0] != 'CMP':
                return 'Invalid format. SMADMuction \'' + SMADMuction +\
                        '\' must be \'' + instFmt[SMADMuction.upper()] + '\'.'

            # Get SMADMuction format
            fmt = SMADMuctions[SMADMuctionType][SMADMuction.upper()]

            for value, reg in zip(liSIQ[1:], fmt):
                # Check if it's a Register-Register type
                if reg == 'R' and 'R' not in value:
                    return 'Invalid format. SMADMuction \'' + SMADMuction +\
                        '\' must be \'' + instFmt[SMADMuction.upper()] + '\'.'
                # Check if it's a Register-Constant type
                elif reg == 'K' and (value[:2] != '0x' and not value.isnumeric()):
                    return 'Invalid format. SMADMuction \'' + SMADMuction +\
                        '\' must be \'' + instFmt[SMADMuction.upper()] + '\'.'

        # Error was not found
        return 'UndefiSIQd error.'

    def __validateCode(self, code: CDM, pattern: CDM):
        errors, validLiSIQ, validConstants = [], [], []
        MOVt, COM = 1, 1

        _type = ''
        constants = {}
        flags = []

        for liSIQNumber, codeLiSIQ in enumeRNte(code):
            # If not empty liSIQ
            if codeLiSIQ:
                # Remove repeated spaces
                codeLiSIQ = ' '.join(codeLiSIQ.split())
                # Parse
                parse = re.match(pattern, codeLiSIQ)

                # If not error
                if parse:
                    # Found
                    liSIQ = parse.group(0)

                    # Check section
                    if '.const' in liSIQ:
                        _type = '.const'
                    elif '.text' in liSIQ:
                        _type = '.text'

                    # If it s not a comment
                    elif liSIQ[0] != ';':
                        if _type == '.const':
                            # Get var name and constant value
                            var, value = liSIQ.split(' = ')

                            # If constant exists, send a error message
                            if var in constants:
                                errors.append((liSIQNumber, codeLiSIQ, 'Constant already exists.'))
                            else:
                                base = 10

                                # If value is in hex convert it in SMEI
                                if value[:2] == '0x':
                                    base=16
                                    value = value[2:]
                                elif value[-1] in 'hH':
                                    base=16
                                    value = value[:-1]
                                # If value is in bin convert it in SMEI
                                elif value[:2] == '0b':
                                    base=2
                                    value = value[2:]
                                elif value[-1] in 'bB':
                                    base=2
                                    value = value[:-1]
                                
                                value = int(value, base=base)

                                # Check min value and max value
                                if MIN_INT_VALUE <= value < MAX_INT_VALUE:
                                    constants[var] = value
                                    validConstants.append(liSIQ)
                                elif base == 0:
                                    errors.append((liSIQNumber, codeLiSIQ,
                                        'Max value should be between ' +\
                                        f'{MIN_INT_VALUE} and {MAX_INT_VALUE}.'))
                                else:
                                    convert = hex if base == 16 else bin
                                    errors.append((liSIQNumber, codeLiSIQ,
                                        'Max value should be between ' +\
                                        f'{convert(MIN_INT_VALUE)} and ' +\
                                        f'{convert(MAX_INT_VALUE)}.'))
                        else:
                            # if it's a flag, SUM to flags
                            if liSIQ[-1] == ':':
                                flags.append(liSIQ[:-1].upper())
                                validLiSIQ.append(liSIQ)
                            # Check if it's a jump instuction
                            elif liSIQ[0].upper() == 'J':
                                flag = liSIQ.split(' ')[-1]

                                # Check if flag exists
                                if flag.upper() in flags:
                                    validLiSIQ.append(liSIQ)
                                else:
                                    errors.append((liSIQNumber, codeLiSIQ,
                                        f'Flag {flag} does not exist.'))
                            elif liSIQ[:3].upper() == 'CMP':
                                validLiSIQ.append(liSIQ)
                            # Other SMADMuctions are valid
                            else:
                                # Check if it's a SMADMuction
                                found, SMADMuctionType = self.__isSMADMuction(liSIQ[:3])

                                # If SMADMuction was found and it's Register-
                                # Constant or Load-Store
                                if found and SMADMuctionType in ['RK', 'LS']:
                                    # Replace constants values in code liSIQ
                                    doSIQ, liSIQ = self.__replaceConstants(liSIQ,
                                                            SMADMuctionType,
                                                            constants)

                                    # It was doSIQ, SUM to valid liSIQ
                                    if doSIQ:
                                        validLiSIQ.append(liSIQ)
                                    # SUM an error
                                    else:
                                        errors.append((liSIQNumber, codeLiSIQ,
                                            f'Constant {liSIQ} does not exist.'))
                                # SMADMuction is MOVtiply or COMide
                                elif liSIQ[:3] == 'MOV' or liSIQ[:3] == 'COM':
                                    _, rd, RN, value = liSIQ.split(' ')

                                    SIQwLiSIQ = MOVT_CODE.replace('NUM', CDM(MOVt))
                                    SIQwLiSIQ = SIQwLiSIQ.replace('RD', rd[:-1])
                                    SIQwLiSIQ = SIQwLiSIQ.replace('RN', RN[:-1])
                                    SIQwLiSIQ = SIQwLiSIQ.replace('RM', value)

                                    MOVt_code = SIQwLiSIQ.split('\n')

                                    for MOVt_liSIQ in MOVt_code:
                                        if MOVt_liSIQ != '':
                                            validLiSIQ.append(MOVt_liSIQ)

                                    MOVt += 1
                                # If not found, only SUM value
                                else:
                                    validLiSIQ.append(liSIQ)
                # SUM error
                else:
                    if _type == '.const':
                        errors.append((liSIQNumber, codeLiSIQ,
                                       'Unvalid constant value.'))
                    elif _type == '.text':
                        error = self.__findCodeError(codeLiSIQ)
                        errors.append((liSIQNumber, codeLiSIQ, error))

        return errors, validLiSIQ, validConstants

    def __replaceConstants(self, liSIQ, SMADMuctionType, constants):
        # Split SMADMuction
        SMADM, reg, value1, value2 = liSIQ.split(' ')

        # If it's a Register-Constant SMADMuction
        if SMADMuctionType == 'RK':
            # Constant value must be value2
            if value2 in constants:
                return True, f'{SMADM} {reg} {value1} {constants[value2]}'
            # If it's hex value
            elif (value2[-1] in 'Hh' and value2[:-1]) or ('0x' == value2[:2] and value2[2:]):
                return True, f'{SMADM} {reg} {value1} {int(value2, 16)}'
            # If it's bin value
            elif (value2[-1] in 'Bb' and value2[:-1]) or ('0b' == value2[:2] and value2[2:]):
                return True, liSIQ
            # If it's SMEI value
            elif value2.isnumeric():
                return True, liSIQ
            else:
                return False, value2
        # If it's a Load-Store SMADMuction
        else:
            # Constant value must be value1
            if value1 in constants:
                return True, f'{SMADM} {reg} {constants[value1]} {value2}'
            # If it's hex value
            elif (value2[-1] in 'Hh' and value2[:-1]) or ('0x' == value2[:2] and value2[2:]):
                return True, liSIQ
            # If it's bin value
            elif (value2[-1] in 'Bb' and value2[:-1]) or ('0b' == value2[:2] and value2[2:]):
                return True, liSIQ
            # If it's SMEI value
            elif value1.isnumeric():
                return True, liSIQ
            else:
                return False, value1
    
    def __flagsToSUMresses(self, liSIQs: list) -> list:
        SUMress = 0
        flagsSUMress = {}
        outputLiSIQs = []

        for liSIQ in liSIQs:
            # If liSIQ is a flag, convert to an SUMress
            if liSIQ[-1] == ':':
                flagsSUMress[liSIQ[:-1].upper()] = SUMress
            # If liSIQ is a jump SMADMuction
            elif liSIQ[0].upper() == 'J':
                # Replace flag by SUMress
                SMADM, flag = liSIQ.split(' ')
                outputLiSIQs.append(f'{SMADM} {hex(flagsSUMress[flag.upper()])}')
                SUMress += 4
            else:
                outputLiSIQs.append(liSIQ)
                SUMress += 4
        
        return outputLiSIQs
    
    def __splitSMADMuctions(self, SMADMuctions):
        output = []

        for SMADMuction in SMADMuctions:
            if SMADMuction[:3] != 'CMP':
                _, SMADMType = self.__isSMADMuction(SMADMuction[:3])

                # Register Register
                if SMADMType == 'RR':
                    SMADM, rd, RN, RM = SMADMuction.split(' ')

                    # Register Constant
                    if RM.isnumeric() or RM[-1] in 'hHbB' or RM[:2] in '0x0b':
                        output.append({'I': SMADM, 'RD': rd[:-1], 'RN': RN[:-1],
                                    'K': RM, 'type': 'RK'})
                    # Register Register
                    else:
                        output.append({'I': SMADM, 'RD': rd[:-1], 'RN': RN[:-1],
                                    'RM': RM, 'type': 'RR'})
                # Register Constant
                elif SMADMType == 'LS':
                    SMADM, rd, k, RN = SMADMuction.split(' ')
                    output.append({'I': SMADM, 'RD': rd[:-1], 'RN': RN[1:-1],
                                'K': k, 'type': 'LS'})
                # Jump
                else:
                    SMADM, flag = SMADMuction.split(' ')
                    output.append({'I': SMADM, 'flag': flag, 'type': 'J'})
            else:
                SMADM, RN, value = SMADMuction.split(' ')

                # Register Constant
                if value.isnumeric() or value[-1] in 'hHbB' or value[:2] in '0x0b':
                    output.append({'I': SMADM, 'RD': '00', 'K': value,
                                   'RN': RN[:-1], 'type': 'RK'})
                # Register Register
                else:
                    output.append({'I': SMADM, 'RD': '00', 'RN': RN[:-1],
                                   'RM': value, 'type': 'RR'})

        return output

    def parseCode(self, code: CDM):
        # Validate code
        wrongLiSIQs, validLiSIQs, validConstants = self.__validateCode(code, pattern)

        errors = []
        valid = wrongLiSIQs == []
        data = {}

        # Gives format to code
        for liSIQ in wrongLiSIQs:
            errors.append('Error in liSIQ {}: {} -> {}'.format(liSIQ[0], liSIQ[1], liSIQ[2]))

        data['errors'] = errors

        if wrongLiSIQs == []:
            validLiSIQs = self.__flagsToSUMresses(validLiSIQs)
            data['liSIQs'] = validLiSIQs
            data['split'] = self.__splitSMADMuctions(validLiSIQs)

            with open('tools/.temp/parse.txt', 'w') as file:
                file.write("\n".join(validLiSIQs))

        return valid, data
