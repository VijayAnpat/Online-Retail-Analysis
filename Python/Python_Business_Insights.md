# Python Business Insights

## 1. Sales Analysis

### Key Metrics

| Metric | Result |
|---|---:|
| Eligible sales records | 527,387 |
| Eligible transaction revenue | 10,631,048.74 |
| Unique invoices | 22,061 |
| Analysis period | December 2010 – December 2011 |

### Monthly Sales Performance

- **November 2011** recorded the highest monthly revenue of **1,503,866.78**.
- **February 2011** recorded the lowest monthly revenue of **522,545.56**.
- Revenue increased significantly during September, October, and November 2011.
- December 2011 recorded revenue of **637,790.33**, but this month contains data only up to December 9. Therefore, it should not be directly compared with complete months.

### Average Revenue per Invoice

- December 2011 recorded the highest average revenue per invoice at **733.94**. However, this is based on a partial month.
- April 2011 recorded the lowest average revenue per invoice at **357.03**.

### Business Insights

1. November 2011 was the strongest month in terms of revenue.
2. February 2011 was the weakest complete month in terms of revenue.
3. Revenue increased considerably during the final quarter of the available data, particularly from September to November.
4. The partial December 2011 data should be treated carefully when comparing monthly performance.

### Data Handling

- Cancelled invoices were excluded.
- Bad debt adjustment records were excluded.
- Postage and other transaction line items were retained in overall transaction revenue.
- Revenue figures represent eligible transaction revenue, not revenue from physical merchandise alone.

## 2. Customer Analysis

### Key Metrics

| Metric | Result |
|---|---:|
| Identified customers | 4,339 |
| Customer transaction records | 392,732 |
| Customer revenue | 8,887,208.89 |
| Repeat customers | 2,845 |
| One-time customers | 1,494 |
| Repeat purchase rate | 65.57% |
| Average invoices per customer | 4.27 |
| Maximum invoices by one customer | 210 |
| Top 10 customers' revenue contribution | 17.31% |

### Customer Purchase Behaviour

- Out of 4,339 identified customers, **2,845 were repeat customers** and **1,494 were one-time customers**.
- The repeat purchase rate was **65.57%**.
- Customers placed an average of **4.27 invoices**.
- One customer placed a maximum of **210 invoices**.
- The top 10 customers contributed **17.31%** of identified-customer revenue.

### RFM Customer Segmentation

RFM analysis segments customers using:
- **Recency:** How recently a customer purchased.
- **Frequency:** How often a customer purchased.
- **Monetary:** How much a customer spent.

| Customer Segment | Customers | Revenue |
|---|---:|---:|
| Champions | 943 | 5,738,885.38 |
| Loyal Customers | 793 | 1,380,299.23 |
| Big Spenders | 74 | 579,254.75 |
| Hibernating | 1,059 | 386,873.24 |
| Potential Loyalists | 458 | 269,227.13 |
| At Risk | 357 | 227,322.35 |
| Others | 655 | 305,346.81 |
| **Total** | **4,339** | **8,887,208.89** |

### Business Insights

1. Approximately 65.57% of identified customers made repeat purchases, indicating a substantial returning-customer base.
2. Champions generated the highest revenue among the RFM segments.
3. Hibernating customers formed the largest segment, with 1,059 customers.
4. The 357 At Risk customers represent a potential opportunity for targeted re-engagement campaigns.
5. The top 10 customers contributed 17.31% of identified-customer revenue, showing that revenue is not dependent only on a small group of customers.

### Data Handling and Limitations

- Customers with missing CustomerID were excluded from customer-level analysis.
- Recency was calculated using December 9, 2011, at 12:50 as the reference date.
- RFM segments were created using rule-based scoring and thresholds. These segments are analytical groupings, not universal customer classifications.
- Hibernating and At Risk classifications indicate purchasing patterns in the available data; they do not prove that customers have permanently churned.



## 3. Product Analysis

### Key Metrics

| Metric | Result |
|---|---:|
| Product transaction records | 525,933 |
| Unique products | 3,942 |
| Eligible transaction revenue | 10,631,048.74 |

### Top Products by Revenue

| Product | Revenue |
|---|---:|
| DOTCOM POSTAGE | 206,248.77 |
| REGENCY CAKESTAND 3 TIER | 174,156.54 |
| PAPER CRAFT LITTLE BIRDIE | 168,469.60 |
| WHITE HANGING HEART T-LIGHT HOLDER | 104,284.24 |
| PARTY BUNTING | 99,445.23 |
| JUMBO BAG RED RETROSPOT | 94,159.81 |
| MEDIUM CERAMIC TOP STORAGE JAR | 81,700.92 |
| POSTAGE | 78,101.88 |
| Manual | 77,750.27 |
| RABBIT NIGHT LIGHT | 66,870.03 |

### Top Products by Quantity Sold

| Product | Quantity Sold |
|---|---:|
| PAPER CRAFT LITTLE BIRDIE | 80,995 |
| MEDIUM CERAMIC TOP STORAGE JAR | 78,033 |
| WORLD WAR 2 GLIDERS | 54,951 |
| JUMBO BAG RED RETROSPOT | 48,375 |
| WHITE HANGING HEART T-LIGHT HOLDER | 37,584 |
| POPCORN HOLDER | 36,749 |
| PACK OF 72 RETROSPOT CAKE CASES | 36,396 |
| ASSORTED COLOUR BIRD ORNAMENT | 36,362 |
| RABBIT NIGHT LIGHT | 30,739 |
| MINI PAINT SET VINTAGE | 26,633 |

### Most Frequently Purchased Products

The following products appeared in the highest number of unique invoices:

| Product | Invoice Count |
|---|---:|
| WHITE HANGING HEART T-LIGHT HOLDER | 2,193 |
| JUMBO BAG RED RETROSPOT | 2,092 |
| REGENCY CAKESTAND 3 TIER | 1,989 |
| PARTY BUNTING | 1,686 |
| LUNCH BAG RED RETROSPOT | 1,564 |
| ASSORTED COLOUR BIRD ORNAMENT | 1,455 |
| SET OF 3 CAKE TINS PANTRY DESIGN | 1,385 |
| PACK OF 72 RETROSPOT CAKE CASES | 1,320 |
| LUNCH BAG BLACK SKULL | 1,273 |
| NATURAL SLATE HEART CHALKBOARD | 1,249 |

### Top 10 Products by Revenue Contribution

| Product | Revenue Contribution |
|---|---:|
| DOTCOM POSTAGE | 1.94% |
| REGENCY CAKESTAND 3 TIER | 1.64% |
| PAPER CRAFT LITTLE BIRDIE | 1.58% |
| WHITE HANGING HEART T-LIGHT HOLDER | 0.98% |
| PARTY BUNTING | 0.94% |
| JUMBO BAG RED RETROSPOT | 0.89% |
| MEDIUM CERAMIC TOP STORAGE JAR | 0.77% |
| POSTAGE | 0.73% |
| Manual | 0.73% |
| RABBIT NIGHT LIGHT | 0.63% |

### Business Insights

1. DOTCOM POSTAGE generated the highest revenue among all product transaction lines.
2. REGENCY CAKESTAND 3 TIER was the highest-revenue physical product in the analysis.
3. PAPER CRAFT LITTLE BIRDIE recorded the highest quantity sold, with 80,995 units. However, these sales appeared in only one invoice, so this result should be investigated before drawing broader conclusions.
4. WHITE HANGING HEART T-LIGHT HOLDER appeared in the highest number of invoices, indicating strong purchase frequency.
5. MEDIUM CERAMIC TOP STORAGE JAR had high sales quantity and appeared in 247 invoices.
6. The top 10 product transaction lines contributed approximately 10.84% of total eligible transaction revenue.

### Data Handling and Limitations

- Cancelled invoices and bad debt adjustment records were excluded.
- Product records with missing StockCode or Description were excluded.
- Only positive quantities were considered when ranking products by quantity sold.
- Postage, DOTCOM POSTAGE, and Manual are transaction lines, not physical merchandise. They should be excluded when analyzing physical product performance.
- High quantity from a single invoice, such as PAPER CRAFT LITTLE BIRDIE, should be investigated rather than treated as evidence of consistent customer demand.

## 4. Overall Business Recommendations

Based on the sales, customer, and product analysis, the following actions could help the business improve performance.

### 1. Improve Sales Performance

- Investigate the factors behind the strong revenue performance in September, October, and November 2011.
- Study February's lower revenue to identify possible seasonal or operational factors.
- Monitor monthly revenue and average revenue per invoice to identify changes in sales performance.

### 2. Improve Customer Retention

- Develop targeted re-engagement campaigns for Hibernating and At Risk customers.
- Reward Champions and Loyal Customers through loyalty offers and exclusive promotions.
- Encourage one-time customers to make repeat purchases through follow-up campaigns.

### 3. Improve Product Performance

- Monitor frequently purchased products and maintain sufficient inventory.
- Investigate products with unusually high quantities from a single invoice.
- Evaluate the performance of high-revenue products and identify opportunities for cross-selling.
- Separate physical merchandise from postage and manual transaction lines when evaluating product performance.

### 4. Use Customer Segmentation

- Use RFM segments to create targeted marketing campaigns.
- Focus on retaining high-value customers.
- Monitor changes in customer recency, frequency, and monetary value over time.

### Conclusion

The analysis provides useful insights into sales trends, customer purchasing behaviour, and product performance.

The business can use these findings to improve customer retention, identify sales opportunities, and make better product and marketing decisions.

The next phase of the project will use Power BI to present the most important findings through an interactive business dashboard.