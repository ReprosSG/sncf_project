from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate()

storage_account_name = "stsncfdataremy"
path_bronze = f"abfss://datalake@{storage_account_name}.dfs.core.windows.net/1-bronze/sncf_historique/regularite-mensuelle-tgv-aqst.csv"

print(f"Tentative de lecture directe du fichier : {path_bronze}")

df = spark.read.format("csv") \
    .option("header", "true") \
    .option("sep", ";") \
    .load(path_bronze)

print("Le calcul Serverless a réussi à lire le Data Lake.")

df.show(5)