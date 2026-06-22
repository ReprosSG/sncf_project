from pyspark.sql import SparkSession
from databricks.sdk.runtime import dbutils

spark = SparkSession.builder.getOrCreate()

storage_account_name = "stsncfdataremy"
secret_scope_name = "azure-vault"
secret_key_name = "datalake-access-key"

print("Récupération de la clé d'accès depuis la key vault...")

storage_account_key = dbutils.secrets.get(scope=secret_scope_name, key=secret_key_name)

spark.conf.set(f"fs.azure.account.key.{storage_account_name}.dfs.core.windows.net",storage_account_key)
print("Connexion etablie avec Datalake.")

path_bronze = f"abfss://datalake@{storage_account_name}.dfs.core.windows.net/1-bronze/sncf_historique/regularite-mensuelle-tgv-aqst.csv"
print(f"Voici le chemin du fichier {path_bronze}")
print("En atttente de l'analyse du fichier CSV...")