Act as a Senior Equity Analyst and Quantitative Portfolio Manager. Analyze my stock portfolio and screen candidate stocks using fundamental financial ratios from Groww’s core framework (P/E, ROE, P/B, Dividend Yield, D/E). 

### INPUT DATA
1. CURRENT PORTFOLIO: [Paste stock tickers, buy price, quantity, and industry]
2. CANDIDATE / WATCHLIST STOCKS: [Paste stock tickers or universe to screen]

---

### CORE SCREENING CRITERIA & BUY NUMBERS
Evaluate each stock against the following strict benchmark thresholds:

1. Price-to-Earnings (P/E) Ratio:
   - BUY TRIGGER: P/E < Industry Average P/E (or 15–25% below 5-year historical sector median).
   - EXCLUDE: P/E > 25% above sector benchmark.

2. Return on Equity (ROE):
   - BUY TRIGGER: ROE > 15% consistently over the last 3–5 years.
   - EXCLUDE: ROE driven artificially high by extreme debt/leverage.

3. Price-to-Book (P/B) Ratio:
   - BUY TRIGGER: P/B < 1.0 to 3.0 (must be lower than sector average).
   - EXCLUDE: P/B < 1.0 on distressed/failing companies (value traps).

4. Debt-to-Equity (D/E) Ratio:
   - BUY TRIGGER: D/E < 1.0 (ideally < 0.5 for non-financial sectors).
   - EXCLUDE: D/E > 1.5 (unless stable utility/infrastructure asset).

5. Dividend Yield:
   - BUY TRIGGER: Dividend Yield > 2%–4% (or higher than 10-year Government Bond Yield for income strategies).

---

### REQUIRED OUTPUT FORMAT

#### SECTION 1: Portfolio Health Check & Risk Assessment
- Analyze overall portfolio risk, sectoral concentration, and debt exposure.
- Identify overvalued holdings or value traps based on the ratio thresholds.

#### SECTION 2: Stock Screener & Buy Strategy
For each screened stock, display a table:
| Stock Ticker | Sector | P/E vs Industry | ROE (%) | P/B | D/E | Div Yield (%) | Decision (BUY / HOLD / AVOID) |
|---|---|---|---|---|---|---|---|

#### SECTION 3: Actionable Trade Execution
1. Strong Buy Picks: Stocks meeting at least 4 out of 5 BUY triggers.
2. Rebalance Suggestions: High D/E or overvalued P/E stocks to trim/sell.
3. Target Buy Allocation: Suggested portfolio % allocation per stock.