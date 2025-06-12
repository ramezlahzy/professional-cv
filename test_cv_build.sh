#!/bin/bash

# =============================================================================
# Local CV Build Test Script
# =============================================================================
# This script tests the CV compilation locally before relying on GitHub Actions
# =============================================================================

echo "🔨 Testing Local CV Compilation"
echo "==============================="

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Check if we're in the CV directory
if [ ! -f "main.tex" ]; then
    print_error "main.tex not found. Please run this script from the professional-cv directory."
    exit 1
fi

print_info "Found main.tex file"

# Check if pdflatex is available (on macOS, might need MacTeX)
if command -v pdflatex >/dev/null 2>&1; then
    print_status "pdflatex is available"
    
    print_info "Compiling CV to PDF..."
    
    # Compile the LaTeX document
    if pdflatex -interaction=nonstopmode main.tex >/dev/null 2>&1; then
        print_status "First compilation successful"
        
        # Run a second time for cross-references
        if pdflatex -interaction=nonstopmode main.tex >/dev/null 2>&1; then
            print_status "Second compilation successful"
            
            if [ -f "main.pdf" ]; then
                # Rename to final name
                mv main.pdf Ramez_Nashaat_CV.pdf
                print_status "CV successfully compiled: Ramez_Nashaat_CV.pdf"
                
                # Show file size
                SIZE=$(ls -lh Ramez_Nashaat_CV.pdf | awk '{print $5}')
                print_info "PDF size: $SIZE"
                
                # Clean up auxiliary files
                rm -f *.aux *.log *.out *.fls *.fdb_latexmk
                print_info "Cleaned up auxiliary files"
                
                echo ""
                echo "🎉 SUCCESS! Your CV has been compiled successfully."
                echo "📄 File: Ramez_Nashaat_CV.pdf"
                echo "🔗 This confirms the GitHub Actions workflow should work too!"
                
            else
                print_error "PDF was not created despite successful compilation"
                exit 1
            fi
        else
            print_error "Second compilation failed"
            exit 1
        fi
    else
        print_error "LaTeX compilation failed"
        echo ""
        print_info "Showing LaTeX error log:"
        pdflatex -interaction=nonstopmode main.tex
        exit 1
    fi
else
    print_error "pdflatex not found"
    echo ""
    print_info "On macOS, install MacTeX: https://www.tug.org/mactex/"
    print_info "Or use Homebrew: brew install --cask mactex"
    echo ""
    print_info "The GitHub Actions workflow will still work as it installs LaTeX automatically."
    exit 1
fi
