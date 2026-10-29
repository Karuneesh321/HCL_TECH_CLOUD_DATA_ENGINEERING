import csv
import os
import tempfile

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, coalesce, lit, try_to_timestamp

os.environ["PYSPARK_PYTHON"] = "python"
os.environ["PYSPARK_DRIVER_PYTHON"] = "python"

csv_data = [
    ("TXN001", "C001", "2026-10-01", "Laptop", "1", "75000.0"),
    ("TXN002", "C002", "2026-10-02", "Mouse", "2", "1500.0"),
    ("TXN001", "C001", "2026-10-01", "Laptop", "1", "75000.0"),
    ("TXN003", "C003", None, "Keyboard", "1", "3500.0"),
    ("TXN004", "C004", "2026/10/04", "Monitor", None, "15000.0"),
    ("TXN005", "C005", "2026-10-05", "Headphones", "3", None),
    ("TXN006", "C006", "invalid-date", "USB Cable", "5", "500.0")
]

columns = ["TransactionID", "CustomerID", "TransactionDate", "Product", "Quantity", "UnitPrice"]

with tempfile.TemporaryDirectory(prefix="q8_spark_") as temp_dir:
    csv_path = os.path.join(temp_dir, "transactions.csv")
    with open(csv_path, "w", newline="", encoding="utf-8") as csv_file:
        writer = csv.writer(csv_file)
        writer.writerow(columns)
        writer.writerows(csv_data)

    spark = SparkSession.builder.appName("Q8").getOrCreate()
    spark.sparkContext.setLogLevel("WARN")

    try:
        df = spark.read.option("header", "true").csv(csv_path)
        df.show()

        cleaned_df = df.dropDuplicates(["TransactionID"])
        cleaned_df.show()

        cleaned_df = cleaned_df.withColumn("Quantity", coalesce(col("Quantity").cast("int"), lit(1))) \
                               .withColumn("UnitPrice", coalesce(col("UnitPrice").cast("double"), lit(0.0)))
        cleaned_df.show()

        cleaned_df = cleaned_df.withColumn(
            "TransactionDate",
            coalesce(
                try_to_timestamp(col("TransactionDate"), lit("yyyy-MM-dd")).cast("date"),
                try_to_timestamp(col("TransactionDate"), lit("yyyy/MM/dd")).cast("date"),
            ),
        )
        cleaned_df.show()

        cleaned_df = cleaned_df.withColumn("Revenue", col("Quantity") * col("UnitPrice"))
        cleaned_df.show()

        cleaned_df.groupBy("Product").sum("Revenue").withColumnRenamed("sum(Revenue)", "TotalRevenue").orderBy(col("TotalRevenue").desc()).show()
    finally:
        spark.stop()
