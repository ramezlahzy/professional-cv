# Professional CV Makefile
# Builds a one-page professional CV from LaTeX source

# Configuration
MAIN_TEX = main.tex
PDF_OUTPUT = main.pdf
CV_NAME = Ramez_Nashaat_CV.pdf
LATEX_CMD = pdflatex
LATEX_FLAGS = -interaction=nonstopmode -halt-on-error

# Colors for terminal output
GREEN = \033[0;32m
RED = \033[0;31m
BLUE = \033[0;34m
NC = \033[0m # No Color

.PHONY: all clean help open test check-deps

# Default target
all: $(CV_NAME)

# Build the CV PDF
$(CV_NAME): $(MAIN_TEX) resume.cls
	@echo "$(BLUE)🔨 Building professional CV...$(NC)"
	@echo "$(BLUE)📄 Running first LaTeX pass...$(NC)"
	@$(LATEX_CMD) $(LATEX_FLAGS) $(MAIN_TEX)
	@echo "$(BLUE)📄 Running second LaTeX pass for cross-references...$(NC)"
	@$(LATEX_CMD) $(LATEX_FLAGS) $(MAIN_TEX)
	@if [ -f $(PDF_OUTPUT) ]; then \
		mv $(PDF_OUTPUT) $(CV_NAME); \
		echo "$(GREEN)✅ CV successfully generated: $(CV_NAME)$(NC)"; \
		ls -lh $(CV_NAME); \
	else \
		echo "$(RED)❌ PDF generation failed$(NC)"; \
		exit 1; \
	fi
	@$(MAKE) clean-aux

# Clean auxiliary files but keep PDF
clean-aux:
	@echo "$(BLUE)🧹 Cleaning auxiliary files...$(NC)"
	@rm -f *.aux *.log *.out *.toc *.fdb_latexmk *.fls *.synctex.gz

# Clean all generated files
clean: clean-aux
	@echo "$(BLUE)🧹 Cleaning all generated files...$(NC)"
	@rm -f $(PDF_OUTPUT) $(CV_NAME)

# Open the generated PDF
open: $(CV_NAME)
	@echo "$(BLUE)📖 Opening CV...$(NC)"
	@open $(CV_NAME)

# Test build (check LaTeX syntax without full compilation)
test:
	@echo "$(BLUE)🧪 Testing LaTeX syntax...$(NC)"
	@$(LATEX_CMD) -draftmode -interaction=nonstopmode $(MAIN_TEX) > /dev/null 2>&1 && \
		echo "$(GREEN)✅ LaTeX syntax is valid$(NC)" || \
		echo "$(RED)❌ LaTeX syntax errors detected$(NC)"

# Show help
help:
	@echo "📋 Professional CV Makefile"
	@echo "=========================="
	@echo "Available targets:"
	@echo "  all (default) - Build the professional CV PDF"
	@echo "  clean         - Remove all generated files"
	@echo "  clean-aux     - Remove auxiliary files only"
	@echo "  open          - Build and open the CV"
	@echo "  test          - Test LaTeX syntax"
	@echo "  help          - Show this help message"
	@echo ""
	@echo "📁 Output: $(CV_NAME)"
	@echo "🔗 GitHub: https://github.com/ramezlahzy/professional-cv"

# Check dependencies
check-deps:
	@echo "$(BLUE)🔍 Checking dependencies...$(NC)"
	@command -v $(LATEX_CMD) >/dev/null 2>&1 || { \
		echo "$(RED)❌ pdflatex not found. Install LaTeX distribution.$(NC)"; \
		echo "$(BLUE)💡 Install with: brew install --cask mactex$(NC)"; \
		exit 1; \
	}
	@echo "$(GREEN)✅ All dependencies found$(NC)"
