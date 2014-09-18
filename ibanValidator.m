static NSString* const Letters = @"ABCDEFGHIJKLKMNOPQRSTUVWXYZ";
static NSString* const Decimals = @"0123456789";
static NSString* const LettersAndDecimals = @"ABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789";


+(BOOL)isValidIBAN:(NSString *)iban
{
    iban = [[iban stringByReplacingOccurrencesOfString:@" " withString:@""] uppercaseString];
    NSCharacterSet *invalidChars = [[NSCharacterSet characterSetWithCharactersInString:LettersAndDecimals] invertedSet];
    
    if ([iban rangeOfCharacterFromSet:invalidChars].location != NSNotFound)
    {
        return NO;
    }
    
    int checkDigit = [iban substringWithRange:NSMakeRange(2, 2)].intValue;
    iban = [NSString stringWithFormat:@"%@%@",[iban substringWithRange:NSMakeRange(4, iban.length - 4)], [iban substringWithRange:NSMakeRange(0, 4)]] ;
    
    for (int i = 0; i < iban.length; i++) {
        unichar c = [iban characterAtIndex:i];
        if (c >= 'A' && c <= 'Z') {
            iban = [NSString stringWithFormat:@"%@%d%@", [iban substringWithRange:NSMakeRange(0, i)], (c - 'A' + 10),[iban substringWithRange:NSMakeRange(i+1, iban.length - i - 1)]];
        }

    }
    iban = [[iban substringWithRange:NSMakeRange(0, iban.length - 2)] stringByAppendingString:@"00"];

    while(true)
    {
        int iMin = (int)MIN(iban.length, 9);
        NSString* strPart = [iban substringWithRange:NSMakeRange(0, iMin)];
        int decnumber = strPart.intValue;
        if(decnumber < 97 || iban.length < 3)
            break;
        int del = decnumber % 97;
        iban =  [NSString stringWithFormat:@"%d%@", del, [iban substringFromIndex:iMin]];
    }
    int check = 98 - iban.intValue;
    
    return checkDigit == check;
}
