import json
import os
from pathlib import Path
from urllib.parse import unquote_plus

import boto3
from PIL import Image


S3 = boto3.client("s3")


def lambda_handler(event, context):
    print(json.dumps(event, indent=2, sort_keys=True))

    destination_bucket = os.environ["DESTINATION_BUCKET"]
    thumbnail_prefix = os.environ.get("THUMBNAIL_PREFIX", "thumbnails/")

    records = event.get("Records", [])
    processed = []

    for record in records:
        bucket = record["s3"]["bucket"]["name"]
        key = unquote_plus(record["s3"]["object"]["key"])

        source_path = Path(f"/tmp/{Path(key).name}")
        thumbnail_path = Path(f"/tmp/{Path(key).stem}-thumbnail.png")

        S3.download_file(bucket, key, str(source_path))

        with Image.open(source_path) as image:
            image = image.convert("RGBA")
            image.thumbnail((256, 256))
            image.save(thumbnail_path, format="PNG")

        destination_key = f"{thumbnail_prefix}{Path(key).stem}-thumbnail.png"
        S3.upload_file(
            str(thumbnail_path),
            destination_bucket,
            destination_key,
            ExtraArgs={"ContentType": "image/png"},
        )

        processed.append(
            {
                "source_bucket": bucket,
                "source_key": key,
                "destination_bucket": destination_bucket,
                "destination_key": destination_key,
            }
        )

    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "message": "Thumbnail created",
                "processed": processed,
            }
        ),
    }
