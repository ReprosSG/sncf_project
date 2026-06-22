from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate()

table_name = "default.regularite_mensuelle_tgv_aqst"

print(f"Lecture directe de la table catalogue : {table_name}")

df = spark.read.table(table_name)

print("Le moteur Serverless a chargé les données SNCF depuis le catalogue !")


df.show(5)