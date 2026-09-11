# AWS Project: S3 and Lambda Thumbnail Pipeline

Minimal but real image workflow with Floci and Terraform:

1. you upload an image to the source bucket;
2. S3 triggers Lambda;
3. Lambda generates a thumbnail and saves it to the destination bucket.

## Prerequisites

- Docker
- Terraform 1.5+
- AWS CLI

## Start Floci

```bash
docker compose up -d
```

## Apply Terraform

```bash
terraform init
terraform apply
```

## Test the S3 -> Lambda flow

<div style="margin: 1.5rem 0 1rem; padding: 1.25rem; border: 1px solid rgba(45,49,66,0.14); border-radius: 12px; background: #f5f5f5; overflow-x: auto;">
<div style="display: flex; align-items: center; gap: 0.65rem; margin-bottom: 0.45rem;">
	<img src="../icons/Architecture-Group-Icons_07312026/AWS-Cloud-logo_32.svg" alt="AWS cloud icon" style="width: 30px; height: 30px; display: block;" />
	<div style="font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.72rem; letter-spacing: 0.16em; text-transform: uppercase; color: #4f5d75;">AWS Architecture</div>
</div>
<div style="font-family: 'Instrument Serif', Georgia, serif; font-size: 1.85rem; line-height: 1.1; color: #2d3142; margin-bottom: 0.35rem;">S3 and Lambda Thumbnail Pipeline</div>
<div style="font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.72rem; letter-spacing: 0.14em; text-transform: uppercase; color: #4f5d75; margin-bottom: 1rem;">An original image enters S3, Lambda processes it, and the destination S3 bucket stores the thumbnail</div>

<table style="width: 100%; min-width: 860px; border-collapse: collapse; table-layout: fixed;">
	<tr>
		<td style="vertical-align: top; width: 38%; padding: 0;">
			<div style="background: #ffffff; border: 1px solid rgba(45,49,66,0.18); border-radius: 12px; padding: 0.95rem; min-height: 240px;">
				<div style="display: flex; justify-content: center; margin-bottom: 0.65rem;">
					<img src="../icons/Resource-Icons_07312026/Res_Storage/Res_Amazon-Simple-Storage-Service_Bucket-With-Objects_48.svg" alt="S3 bucket icon" style="width: 42px; height: 42px; display: block;" />
				</div>
				<div style="display: inline-block; font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.7rem; letter-spacing: 0.1em; color: #4f5d75; border: 1px solid rgba(79,93,117,0.35); border-radius: 4px; padding: 0.12rem 0.45rem; margin-bottom: 0.6rem;">S3</div>
				<div style="font-family: 'Geist', system-ui, sans-serif; font-size: 1.05rem; font-weight: 600; color: #2d3142; text-align: center; margin-bottom: 0.25rem;">S3 source bucket</div>
				<div style="font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.8rem; color: #4f5d75; text-align: center; margin-bottom: 0.75rem;">floci-s3-thumbnail-source</div>
				<div style="overflow: hidden; border-radius: 10px; border: 1px solid rgba(235,108,54,0.5); background: #ececec;">
					<img src="https://picsum.photos/seed/floci/220/132" alt="Original web image" style="display: block; width: 100%; height: 132px; object-fit: cover;" />
				</div>
				<div style="font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.7rem; color: #eb6c36; letter-spacing: 0.08em; margin-top: 0.55rem;">ORIGINAL</div>
				<div style="font-family: 'Geist', system-ui, sans-serif; font-size: 0.95rem; font-weight: 600; color: #2d3142;">Original image</div>
				<div style="font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.75rem; color: #4f5d75;">exemplo.jpg</div>
			</div>
		</td>
		<td style="vertical-align: middle; width: 24%; padding: 0 1rem; text-align: center; color: #4f5d75;">
				<div style="display: flex; justify-content: center; margin-bottom: 0.35rem;">
					<img src="../icons/Architecture-Service-Icons_07312026/Arch_Compute/64/Arch_AWS-Lambda_64.svg" alt="Lambda icon" style="width: 48px; height: 48px; display: block;" />
				</div>
			<div style="font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.75rem; letter-spacing: 0.08em; color: #eb6c36; text-align: center; margin-bottom: 0.5rem;">S3:ObjectCreated:Put</div>
			<div style="height: 1px; background: linear-gradient(90deg, transparent, #eb6c36 20%, #eb6c36 80%, transparent); position: relative; margin: 0.8rem 0;">
				<div style="position: absolute; right: -1px; top: -4px; width: 0; height: 0; border-left: 8px solid #eb6c36; border-top: 5px solid transparent; border-bottom: 5px solid transparent;"></div>
			</div>
			<div style="background: rgba(235,108,54,0.08); border: 1px solid #eb6c36; border-radius: 999px; padding: 0.35rem 0.7rem; font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.72rem; color: #eb6c36; display: inline-block;">AWS Lambda</div>
			<div style="font-family: 'Instrument Serif', Georgia, serif; font-size: 1.5rem; font-style: italic; color: #2d3142; line-height: 1; margin-top: 0.55rem;">Create thumbnail</div>
			<div style="font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.72rem; letter-spacing: 0.08em; color: #4f5d75; text-align: center; margin-top: 0.45rem;">Resize + PNG</div>
		</td>
		<td style="vertical-align: top; width: 38%; padding: 0;">
			<div style="background: #ffffff; border: 1px solid rgba(45,49,66,0.18); border-radius: 12px; padding: 0.95rem; min-height: 240px;">
				<div style="display: flex; justify-content: center; margin-bottom: 0.65rem;">
					<img src="../icons/Resource-Icons_07312026/Res_Storage/Res_Amazon-Simple-Storage-Service_Bucket-With-Objects_48.svg" alt="S3 bucket icon" style="width: 42px; height: 42px; display: block;" />
				</div>
				<div style="display: inline-block; font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.7rem; letter-spacing: 0.1em; color: #4f5d75; border: 1px solid rgba(79,93,117,0.35); border-radius: 4px; padding: 0.12rem 0.45rem; margin-bottom: 0.6rem;">S3</div>
				<div style="font-family: 'Geist', system-ui, sans-serif; font-size: 1.05rem; font-weight: 600; color: #2d3142; text-align: center; margin-bottom: 0.25rem;">S3 destination bucket</div>
				<div style="font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.8rem; color: #4f5d75; text-align: center; margin-bottom: 0.75rem;">floci-s3-thumbnail-destination</div>
				<div style="overflow: hidden; border-radius: 10px; border: 1px solid rgba(45,49,66,0.42); background: #ececec; width: 160px; margin: 0 auto;">
					<img src="https://picsum.photos/seed/floci/220/132" alt="Thumbnail image" style="display: block; width: 100%; height: 96px; object-fit: cover; filter: saturate(0.95);" />
				</div>
				<div style="font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.7rem; color: #4f5d75; letter-spacing: 0.08em; margin-top: 0.55rem; text-align: center;">THUMB</div>
				<div style="font-family: 'Geist', system-ui, sans-serif; font-size: 0.95rem; font-weight: 600; color: #2d3142; text-align: center;">Thumbnail image</div>
				<div style="font-family: 'Geist Mono', ui-monospace, monospace; font-size: 0.75rem; color: #4f5d75; text-align: center;">thumbnails/exemplo-thumbnail.png</div>
			</div>
		</td>
	</tr>
</table>

<div style="font-family: 'Geist', system-ui, sans-serif; font-size: 0.95rem; font-weight: 600; color: #2d3142; text-align: center; margin-top: 1rem;">AWS project: upload an original image to S3, Lambda generates the thumbnail, and the destination S3 bucket stores the result</div>
</div>

Download a public image from the web and upload it to the source bucket:

```bash
curl -L "https://upload.wikimedia.org/wikipedia/commons/3/3f/Fronalpstock_big.jpg" -o exemplo.jpg
aws --endpoint-url http://localhost:4566 s3 cp ./exemplo.jpg s3://floci-s3-thumbnail-source/exemplo.jpg
rm -f ./exemplo.jpg
```

Then check the result in the destination bucket:

```bash
aws --endpoint-url http://localhost:4566 s3 ls s3://floci-s3-thumbnail-destination/thumbnails/
aws --endpoint-url http://localhost:4566 s3 cp s3://floci-s3-thumbnail-destination/thumbnails/exemplo-thumbnail.png ./exemplo-thumbnail.png
rm -f ./exemplo-thumbnail.png
```

If you want to follow the execution, watch the Floci container logs:

```bash
docker compose logs -f floci
```

## Clean up

```bash
terraform destroy
docker compose down
```
