# Online Retail Analysis — SQL Business Insights

## 1. Data Quality Findings

### Business Objective

Assess the reliability of the Online Retail dataset before using it to draw conclusions about sales performance, customer behavior, and product trends.

### Key Findings

| Data Quality Check | Finding | Business Significance |
|---|---|---|
| Dataset size | 541,909 transaction records | Provides the initial scope of the analysis. |
| Exact duplicate rows | 5,268 duplicate rows identified in the duplicate-checking workflow | Duplicates can inflate transaction counts, quantities, and sales if not handled appropriately. |
| Missing product descriptions | 1,454 records | Missing descriptions make product interpretation and reporting more difficult. |
| Missing Customer IDs | A substantial number of records have no CustomerID | Customer-level metrics, including repeat purchasing and customer segmentation, cannot include unidentified customers reliably. |
| Cancellation invoices | Invoice numbers beginning with `C` indicate cancellations; counts differed across checks | Cancellation records must be handled consistently when calculating sales and order metrics. |
| Negative quantities and prices | Negative quantities and zero or negative unit prices were investigated | These records may represent returns, cancellations, corrections, or unusual transactions and require context before exclusion. |
| Repeated invoice–product combinations | Investigated separately from exact duplicate rows | Multiple records sharing an invoice number and stock code are not automatically duplicates. |

### Business Interpretation

Data quality affects the reliability of every later analysis. Duplicate rows may inflate totals, missing customer identifiers limit customer behavior analysis, and cancellation or adjustment records can change sales and quantity metrics.

Therefore, transaction filters and calculation rules should be documented and applied consistently across reports.

### Recommended Actions

- Preserve the original dataset and document any cleaning steps.
- Distinguish exact duplicate rows from legitimate repeated invoice–product combinations.
- Separate cancellation invoices from ordinary transaction records when the business question requires it.
- Investigate negative quantities and unusual prices rather than automatically deleting them.
- Report the number and percentage of records excluded from each analysis.
- Use consistent definitions for sales, orders, customers, and cancellations across Excel and SQL.

### Limitations and Validation Notes

- Missing CustomerID counts differed between checks. The count should be validated using a consistent dataset scope and filter before reporting one definitive figure.
- Cancellation counts also differed across checks. The exact count depends on the records and conditions being examined.
- Excluding invoice numbers beginning with `C` does not fully reconcile cancellations against their original invoices.
- Negative quantities do not necessarily represent customer returns.
- Data quality findings describe the dataset and analysis workflow; they do not, by themselves, establish the cause of an anomaly.


## 2. Sales Performance Insights

### Business Objective

Understand sales performance across countries and time periods to identify important markets and changes in business activity.

### Key Findings

#### 2.1 Sales by Country

The United Kingdom dominates the sales results. Among the other countries, the Netherlands, EIRE, Germany, and France are important markets by sales value.

Selected SQL results for sales excluding cancellation invoice rows:

| Country | Sales |
|---|---:|
| United Kingdom | £8,187,806.36 |
| Netherlands | £284,661.54 |
| EIRE | £263,276.82 |
| Germany | £221,698.21 |
| France | £197,389.05 |

**Business interpretation:** The UK is the primary market in this dataset. International markets should also be evaluated by customer count, average customer spend, and repeat purchasing—not only total sales.

#### 2.2 Monthly Sales Trends

November 2011 recorded the highest monthly sales in the analysis, at approximately £1.51 million, excluding cancellation invoice rows.

December 2011 recorded approximately £638,792.68 under the same general sales approach. However, the dataset ends on December 9, 2011, so December represents only a partial month.

**Business interpretation:** Sales increased substantially during the autumn months, with September, October, and November showing strong results. Further data would be needed to establish whether this pattern repeats annually.

#### 2.3 Sales Calculation and Cancellations

Sales were calculated at transaction-line level using:

`Sales = Quantity × UnitPrice`

Many SQL sales queries exclude invoice numbers beginning with `C`. This removes cancellation invoice rows from those calculations, but it does not fully reconcile cancellations against their original invoices.

**Business interpretation:** Sales excluding cancellation invoice rows should not automatically be described as fully reconciled net sales. Returns, adjustments, and other negative transactions require separate investigation.

### Recommended Business Actions

- Monitor monthly sales to identify strong and weak periods.
- Evaluate international markets using sales, customer reach, average spend, and repeat-purchase behavior.
- Investigate the autumn sales increase using additional years of data if available.
- Maintain consistent definitions for sales and cancellations across Excel, SQL, and future Power BI reports.
- Avoid direct comparisons between complete months and the partial month of December 2011.

### Limitations

- The dataset covers approximately one year, which is insufficient to establish reliable recurring annual seasonality.
- December 2011 is incomplete.
- Excluding cancellation invoice rows does not fully reconcile original transactions and their cancellations.
- Country-level results depend on the transaction filters and country normalization used in each query.


## 3. Customer Analysis Insights

### Business Objective

Understand customer purchasing behavior, repeat purchasing, revenue concentration, and customer value to identify opportunities for customer retention and business growth.

### Key Findings

#### 3.1 Customer Revenue Concentration

The advanced SQL analysis found that a relatively small group of identified customers contributed a large share of customer revenue.

| Customer Group | Share of Customer Revenue |
|---|---:|
| Top 1% of customers | 32.00% |
| Top 5% of customers | 50.38% |
| Top 10% of customers | 61.38% |
| Top 20% of customers | 74.62% |

**Business interpretation:** Revenue depends heavily on a relatively small group of customers. Losing a few high-value customers could have a meaningful impact on sales.

#### 3.2 Repeat Purchasing

Among 4,339 identified customers with eligible non-cancelled purchases, 2,845 made purchases across multiple invoices.

- Repeat customers: 2,845
- One-time customers: 1,494
- Repeat-customer percentage: 65.57%

**Business interpretation:** Repeat purchasing was common among identified customers in this historical dataset. The business could investigate which products and customer groups are associated with repeat purchases.

#### 3.3 Customer Value Segmentation

The advanced SQL analysis grouped identified customers according to their spending and purchasing frequency.

| Customer Segment | Customers | Percentage |
|---|---:|---:|
| High Value, Frequent | 2,024 | 46.65% |
| Lower Value, Infrequent | 1,348 | 31.07% |
| Lower Value, Frequent | 821 | 18.92% |
| High Value, Infrequent | 146 | 3.36% |

**Business interpretation:** The segments represent different purchasing patterns. High-value, frequent customers may be important for retention, while frequent but lower-value customers may present opportunities to increase average spend.

#### 3.4 Inactive Customers

Using December 9, 2011, as the dataset reference date, 1,449 of 4,339 identified customers had no eligible purchase during the preceding 90 days.

- Customers inactive for more than 90 days: 1,449
- Percentage of identified customers: 33.39%
- Historical sales associated with these customers: approximately £1.04 million

**Business interpretation:** This group may be useful for historical re-engagement analysis. However, these customers should be described as inactive relative to the end of the dataset, not as currently inactive.

#### 3.5 New versus Returning Customer Revenue

The monthly SQL analysis separated revenue from newly acquired identified customers and returning identified customers.

Returning customers contributed substantial revenue in many months, particularly during the later months of 2011.

**Business interpretation:** Returning customers were an important source of revenue in the observed period. Tracking new and returning customer revenue separately can help evaluate customer acquisition and retention performance.

### Recommended Business Actions

- Monitor revenue concentration to understand dependence on high-value customers.
- Track repeat-purchase rates using a consistent customer and invoice definition.
- Develop different retention approaches for high-value, frequent customers and other segments.
- Investigate historical inactivity to identify possible customer re-engagement opportunities.
- Compare new and returning customer revenue over time.
- Validate customer-level findings against the treatment of missing CustomerIDs and cancellation records.

### Limitations

- Customer analysis excludes transactions without an identified CustomerID.
- Sales calculations often exclude cancellation invoice rows but do not fully reconcile cancellations against original invoices.
- Inactivity is measured relative to December 9, 2011, and does not describe present-day customer activity.
- Customer segments depend on the spending and frequency thresholds used in the SQL query.
- These findings describe historical patterns and do not establish that a particular retention action will cause revenue to increase.


## 4. Product Analysis Insights

### Business Objective

Identify products that contribute strongly to sales, attract many customers, encourage repeat purchases, and frequently appear together in the same invoice.

### Key Findings

#### 4.1 Top Products by Sales

The SQL analysis identified the following high-sales products, excluding cancellation invoice rows.

| Product | Sales |
|---|---:|
| DOTCOM POSTAGE | £206,248.77 |
| REGENCY CAKESTAND 3 TIER | £174,484.74 |
| PAPER CRAFT, LITTLE BIRDIE | £168,469.60 |
| WHITE HANGING HEART T-LIGHT HOLDER | £106,292.77 |
| PARTY BUNTING | £99,504.33 |

**Business interpretation:** Product sales rankings help identify major contributors to recorded sales value. However, postage and other service codes should be distinguished from merchandise when evaluating retail product performance.

**Important caveat:** PAPER CRAFT, LITTLE BIRDIE had a recorded sale of £168,469.60 that was followed by a cancellation for the same quantity and value. It should not be interpreted as an unconditionally retained sale.

#### 4.2 Product Sales and Customer Reach

The product analysis compared sales value with the number of identified customers purchasing each product.

- The median product sales value was approximately £650.39.
- The median identified customer reach was 33 customers.
- DOTCOM POSTAGE had high recorded sales but was associated with only one identified customer in this analysis.

**Business interpretation:** High sales value does not always mean broad customer demand. Comparing revenue with customer reach can help distinguish products bought by many customers from products whose sales depend on a small number of buyers.

#### 4.3 Repeat Product Purchasing

The SQL analysis calculated repeat purchasing at product level by comparing customers who purchased a product more than once with the customers who purchased it.

Examples of products with relatively high repeat-purchase rates included several lunch bags and postage-related codes.

**Business interpretation:** Products with repeat purchasing may be useful for understanding customer preferences and identifying products that encourage recurring orders. Service codes should be separated from physical merchandise when drawing product-specific conclusions.

#### 4.4 Frequently Purchased Together

The frequently-bought-together analysis identified product pairs appearing on the same invoice.

| Product Pair | Invoices Containing Both |
|---|---:|
| Jumbo Bag Pink Polkadot + Jumbo Bag Red Retrospot | 825 |
| Green Regency Teacup and Saucer + Roses Regency Teacup and Saucer | 768 |
| Jumbo Storage Bag Suki + Jumbo Bag Red Retrospot | 724 |
| Jumbo Shopper Vintage Red Paisley + Jumbo Bag Red Retrospot | 680 |
| Lunch Bag Red Retrospot + Lunch Bag Suki Design | 655 |

**Business interpretation:** Frequently co-purchased products may be candidates for product bundles, cross-selling suggestions, or related-product recommendations. Co-occurrence alone does not prove that bundling would increase sales.

### Recommended Business Actions

- Separate merchandise from postage, fees, and other service codes when ranking retail products.
- Compare product sales, customer reach, invoice count, and repeat purchasing together.
- Investigate large transactions and subsequent cancellations before highlighting products as top performers.
- Consider testing related-product recommendations for frequently co-purchased items.
- Check stock-code descriptions for inconsistencies before grouping or comparing products.

### Limitations

- Many sales rankings exclude cancellation invoice rows without fully reconciling them against original invoices.
- Product results may be split when one stock code has multiple descriptions.
- Repeat-purchase rates depend on the customer identification and invoice filters used.
- Frequently purchased together means the products occurred on the same invoice; it does not establish causation or prove customer intent.


## 5. Time and Seasonal Analysis Insights

### Business Objective

Analyze monthly and quarterly sales trends to understand changes in business performance over time and identify periods that may require further investigation.

### Key Findings

#### 5.1 Quarterly Sales Trends

The SQL analysis calculated quarterly sales excluding cancellation invoice rows.

| Period | Sales | Orders |
|---|---:|---:|
| Q4 2010 | £823,746.14 | 1,699 |
| Q1 2011 | £1,932,635.81 | 4,055 |
| Q2 2011 | £2,070,084.54 | 5,035 |
| Q3 2011 | £2,514,825.62 | 5,110 |
| Q4 2011 | £3,303,268.31 | 6,165 |

**Business interpretation:** Recorded quarterly sales increased through the observed quarters of 2011. However, Q4 2010 contains only December, while Q4 2011 ends on December 9. These periods are incomplete and should not be treated as directly comparable full quarters.

#### 5.2 Monthly Sales Performance

November 2011 had the highest monthly sales, at approximately £1.51 million. October was second at approximately £1.15 million, followed by September at approximately £1.06 million.

December 2011 recorded approximately £638,792.68, but the data ends on December 9.

**Business interpretation:** Sales were particularly strong during September–November 2011. Further investigation could examine order volume, customer activity, product mix, and possible holiday-related demand.

#### 5.3 Month-over-Month Changes

The largest recorded month-over-month percentage increase occurred in September 2011, at approximately 43.63%. November increased by approximately 30.69% compared with October.

December 2011 showed a decline of approximately 57.68% compared with November, but December includes only the first nine days of the month.

**Business interpretation:** The observed increases in September and November identify useful periods for further investigation. The December decline should not be interpreted as a complete-month performance decline.

#### 5.4 Quarterly Growth

The SQL analysis reported the following quarterly changes:

- Q1 2011: approximately +134.62% compared with Q4 2010.
- Q2 2011: approximately +7.11% compared with Q1 2011.
- Q3 2011: approximately +21.48% compared with Q2 2011.
- Q4 2011: approximately +31.35% compared with Q3 2011.

**Business interpretation:** Q2 and Q3 comparisons indicate increases in recorded quarterly sales. Q1's increase is affected by the limited December 2010 baseline, and Q4 2011 is incomplete.

### Recommended Business Actions

- Monitor monthly sales and order counts to identify significant changes.
- Investigate the strong September–November period by product, country, and customer segment.
- Use complete comparable periods for growth calculations.
- Avoid making firm seasonal conclusions from a dataset covering approximately one year.
- If additional years become available, compare the same months across years to test whether the observed patterns repeat.

### Limitations

- The dataset spans December 1, 2010, to December 9, 2011.
- December 2011 is incomplete, and Q4 2010 contains only December.
- Month-over-month and quarter-over-quarter percentages are sensitive to incomplete periods.
- Sales exclude cancellation invoice rows in the relevant queries and do not fully reconcile cancellations against original invoices.
- The analysis identifies historical trends but does not establish their causes or prove recurring seasonality.


## 6. Advanced Business Analysis Insights

### 6.1 Customer Revenue Concentration

A relatively small group of customers contributes a large share of total customer revenue.

| Customer Group | Share of Customer Revenue |
|---|---:|
| Top 1% of customers | 32.00% |
| Top 5% of customers | 50.38% |
| Top 10% of customers | 61.38% |
| Top 20% of customers | 74.62% |

**Business insight:** Customer revenue is concentrated among a relatively small number of customers. Maintaining strong relationships with high-value customers may help protect revenue.

### 6.2 Customer Value Segmentation

Customers were grouped according to their spending and purchase frequency.

| Customer Segment | Customers | Share of Customers | Historical Sales |
|---|---:|---:|---:|
| High Value, Frequent | 2,024 | 46.65% | £7,949,819.71 |
| Lower Value, Infrequent | 1,348 | 31.07% | £352,016.03 |
| Lower Value, Frequent | 821 | 18.92% | £345,276.46 |
| High Value, Infrequent | 146 | 3.36% | £264,295.70 |

**Business insights:**
- High Value, Frequent customers contribute the largest amount of historical sales.
- Lower Value, Infrequent customers may be candidates for targeted engagement campaigns.
- High Value, Infrequent customers may deserve attention because their historical spending is high despite less frequent purchasing.

These segments describe historical behavior; they do not guarantee future customer activity.

### 6.3 Customer Inactivity

Using December 9, 2011, as the dataset reference date, 1,449 of 4,339 identified customers (33.39%) had not purchased for more than 90 days.

Their historical sales totaled £1,035,270.41.

**Business insight:** This group could be investigated for potential re-engagement opportunities. However, the result describes inactivity relative to the end of this historical dataset, not current customer inactivity.

### 6.4 Customer Performance by Country

Selected country-level results from the advanced customer analysis:

| Country | Identified Customers | Historical Sales | Average Spend per Customer | Repeat Customer Rate |
|---|---:|---:|---:|---:|
| United Kingdom | 3,921 | £7,308,391.55 | £1,863.91 | 65.54% |
| Netherlands | 9 | £285,446.34 | £31,716.26 | 55.56% |
| EIRE | 3 | £265,545.90 | £88,515.30 | 100.00% |
| Germany | 94 | £228,867.14 | £2,434.76 | 72.34% |
| France | 87 | £209,024.05 | £2,402.58 | 67.82% |
| Australia | 9 | £138,521.31 | £15,391.26 | 100.00% |

**Business insights:**
- The United Kingdom has the largest identified customer base and the highest total sales in this analysis.
- Some countries show high average customer spending, but the customer counts are small.
- Repeat customer rates should be interpreted alongside the number of identified customers.

**Important:** These figures come from the advanced customer analysis query and its filters. They should not be directly mixed with country sales figures from other SQL queries that use different calculation scopes.

### 6.5 Customer Concentration Within Countries

In the Netherlands, the highest-spending customer contributed approximately 98.16% of the country's sales in this analysis. In Australia, the top customer contributed approximately 90.18%.

**Business insight:** These markets show substantial dependence on individual customers in the analyzed data. Losing one major customer could have a significant effect on sales in these markets.

### 6.6 Frequently Purchased Together

The most frequent product combinations included:

| Product Combination | Invoices Containing Both |
|---|---:|
| Jumbo Bag Pink Polkadot + Jumbo Bag Red Retrospot | 825 |
| Green Regency Teacup and Saucer + Roses Regency Teacup and Saucer | 768 |
| Jumbo Storage Bag Suki + Jumbo Bag Red Retrospot | 724 |
| Jumbo Shopper Vintage Red Paisley + Jumbo Bag Red Retrospot | 680 |
| Lunch Bag Red Retrospot + Lunch Bag Suki Design | 655 |

**Business insight:** These combinations may help guide product bundling, cross-selling, and product placement ideas. Co-occurrence does not by itself prove that bundling will increase sales.

### 6.7 Overall Business Recommendations

1. **Protect high-value customer relationships:** Monitor spending and purchase frequency among major customers.
2. **Test customer re-engagement campaigns:** Investigate historically inactive customers and measure the results of any campaign.
3. **Evaluate international market concentration:** Consider customer concentration and sample size before making country-level expansion decisions.
4. **Explore product combinations:** Test bundles or recommendations based on frequently purchased-together products.
5. **Use consistent calculation rules:** Confirm filters, cancellation handling, and customer identification before comparing results across queries.

### 6.8 Limitations

- The dataset covers December 1, 2010, through December 9, 2011.
- Customer analysis excludes transactions without an identified CustomerID where customer-level calculations require that identifier.
- Excluding cancellation invoice rows does not fully reconcile every cancellation against its original invoice.
- Historical inactivity is measured relative to the end of the dataset and should not be treated as current inactivity.
- Country-level metrics can vary between queries because of different filters and calculation scopes.
- Observed relationships and patterns are descriptive and do not establish causation.
