Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010020.outbound.protection.outlook.com [52.101.201.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BB21A0BF3;
	Mon,  7 Sep 2026 08:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788770283; cv=fail; b=fN0tmQceEkM+0A7NilM/fJYV/XGVuWfF54Q9V6/eB5l/wx8uR7ILGwmTqfRtzk/gqmXgP59etwWE2yskTHDEkyFHdurXIX0AbfC15gtEmeq2k+iEZxVjE6nCCV/qHh/4qEWnTd/Bzn2laUuGPpZwHqHFVY63EDFSfwNCSLmUGCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788770283; c=relaxed/simple;
	bh=mjXvHfPQhzDA8zGRm5SbTUjDCKVjPgKJPXtuIHcUxmE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q6KaU1RUS7ukyQllT678cEF37Kgc9P6fR2xMw5EsiE9DmuH5enixSwif9qLxmPaMtX6yLdOqz7GGXacmSe1xei+aGMOCBfElxPk2EKoAGFpJPy4+LOA9g+xrnVBx6q/j8orkgP/FoFQW7mw+QglLX4WLjo83B4iuIRDMkIeL1Yc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LO50LkJO; arc=fail smtp.client-ip=52.101.201.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LO50LkJO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CZ9638pJIeSaLMkq5lJlQ2+toX4NRJXSp0s5xsph/f08tGXj1PuPm4+cMl/nz6Hpb/je16wUtip6FH1zn5vCkgxdEp+Qsqd1gghQge+k/V1UOK1DYTdDXZrBAC6J54uWAv9M9Zq/S+aJKsF9Y7GV42erASo6kWohL8UZ5umPotL+52pUsEGGbMaQ6OzD4nhhLwdLNSLyQERRuWln5Dr2823hxdgWt/x3pHPWRYkTF3H5QQ63Jri3xBasmdjff7XXTZniAufrJs6xdLo5iBFARtmdvI5ugodxJg8G/FuzSyXZv60S4pqKz0YR8QCxSv0j199fGL017h7veqKNlSKOtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gt0gZnnYZ5Ln3T4MKtVJu/qSJ055gXR9mu/etKeRFKs=;
 b=fAw5Ie7v230NZjg/eMgWak0A9ZC8qk5ylq78Oqvt/VbcII9HJ5VJB9XwYuscT9EHALg1K5WFMNZcUCrdBBc1HslvUa5aEez9aKNwOEg2MWBEL7lR7FdKYbyGKGanj0cxcD7bxMODLA/s35/FMC7J/jzqhQc4j7TO0lxpzQMb9uVAO4kDa2HGA0Tv9w/Cjr8B/wrdak5WYZnVMcKRD4l/zlipfse1ZSygV40YxFD85uTVprlmgkpSYPmJrTklayEjeAouM3iDCCeAskusuFCylj5Kah+qPaAkxf2L4k2/pt/w09T3OTty7gtIYwKGyBsXBiKisU5eLNqBS8Qz/4mhKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gt0gZnnYZ5Ln3T4MKtVJu/qSJ055gXR9mu/etKeRFKs=;
 b=LO50LkJOnR/JuRLVnFrxWCNsyC33z6fCo42pQHu4iFbbyhKQQ3sUBi+GrvDM/bisuDqB5nT7oHdsW/zuoxo8d2/7Z/TaD7Wi7ZqRLLqHvE6ByKB+lJcsW4cSvaBpxHXVsHW3b223zLqvkjBOkxGCXEUC5DNHXZdrxdvlz/+hTtK21WotqTHCqw1kDn5OIQf3QbLEfsBDQzSOj92B2zvlmOfhXuGvvrFTckuD0BRp5NxZYN+b3965D8dsTilnQdNwgWedWTvkjjhYbDvYJuAAosq0BReI/Iyw26xK7RHq+wXROb3XyiHUn7pt73riauqibLIVYmkkfJhWkenE9PeDaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20)
 by PH7PR12MB6737.namprd12.prod.outlook.com (2603:10b6:510:1a8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 08:37:58 +0000
Received: from MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e]) by MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e%5]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 08:37:58 +0000
Message-ID: <50a5ecce-11ad-4710-ae3f-70770abd8dc0@nvidia.com>
Date: Mon, 7 Sep 2026 11:37:52 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 08/14] net/mlx4: Remove obsolete 32-bit DMA mask
 fallback
To: Ruizhe Zhou <zhouruizhe@resnics.com>, Tariq Toukan <tariqt@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20260903084339.870562-1-zhouruizhe@resnics.com>
 <20260903084339.870562-9-zhouruizhe@resnics.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20260903084339.870562-9-zhouruizhe@resnics.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::19) To MW6PR12MB7086.namprd12.prod.outlook.com
 (2603:10b6:303:238::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB7086:EE_|PH7PR12MB6737:EE_
X-MS-Office365-Filtering-Correlation-Id: b701a9d3-e3ba-4a70-aa1f-08df0cbb51b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|10067099003|6133799003|56012099006|22082099003|18002099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	6k0sEVujb8lQQCUtTuQtHsSPqKfL6SSBIJFxpoT814VJsrhP9cH0pddl1D7zT7Dn73IfZqJGUjIBKURQe0lkcj7Q2BXtcG9O2sUdt52aaxj8qbBw32yqxmOr761pB6361Bo0J06cbr0H2RFyntN+YaTm+1F5iRpZ1H1DvOEwRL8WwEVG7imqeY97/savJUQaC0kHqh22xSwd8m3xZdZGiRyM0dRyyh4lo175sbpisR1/HPz+6os4CgXMN9fz0cdiFGzDDoGEISW9OYkh+HfwcgFk3b+i9ZMOdNy6VtOs5ZtT2AoFSFflhPnZmM/C+kNQW5A68X2W+g/Z31zJ7OfXgirirzLCMjNdY6xZEBqzfPQ/G2Kw2n7/y6SPrJAnIPoiulFWjbNn/G9ouDUiJsPiV/xFPAcOfyOJJMy/j0OtY0CAQbpm7zqamvAxFBLKtHUMIvKSszoBbEGmRzSQbphJHfg/KCF5zE2R9ADXclVif8R2sZIlwt+QpYrJyJ3Y/7Nw90rE/Zn1cXEmxzhM2zoJDF2atxYFFgwCnTeRHk53i0dkQdGXL9UNIgQqm2t2evHsC66hj6pcvFrO1diox+tC71ugdNCx2nf8sGDMueQSo7hCE5anCtUqsbltNzcY4HgQaNKZsselvW9zqRVu3veyYCaOJnVbj58BAVvSlHFdGfc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB7086.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(10067099003)(6133799003)(56012099006)(22082099003)(18002099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VnlIVEhEZG90Wmx0bDBkZ3o1MlREZnhxMEJheWh3dEVVSk91NnhWWTZNazlX?=
 =?utf-8?B?ZjkvOWY1cnh3cC9Fb2IyNDFwaFRhM2R0TVJoSjJGMVQ2a2c2UzNxYTR3QzFq?=
 =?utf-8?B?blBJaFlxZkoyb0xDaHo4NzhINlFta3N4OThSRjBBdFYyUzl2c3NXTm9uWG9G?=
 =?utf-8?B?Ny9yVEk3OS9seUczUXdVOUNZbXZaZlg4WXRscUhaSnA4VTk4QThWZU9xQjl0?=
 =?utf-8?B?cWptalVjdU5ndjVEeUVuQlJ6c0MyclBLb0dLZlo3c0ZUOHVrb1JsSzRVa3Ni?=
 =?utf-8?B?RSt0QmNTRkRwSE1ubFFwcXl5UTJnWmZVUzUxMkxUNjZwQkFrUjd3K1pkSkc2?=
 =?utf-8?B?bFhzL2pxT2FRS0ZZeksybkJTdUVGckVCNEdXOE9aam1oRXVwQ3BBTkdQZTE4?=
 =?utf-8?B?UzYrM1ZEK21UZWlpSGFWSFdBY0ZNZnhCVVUvWWNSdklMZExCSG1FS0F6ZWdk?=
 =?utf-8?B?T0Vxci9mN2VaV2p1bjZmNC9YYW9wcWI0RW9mb3NSWkNuNWYxcGVlR1pyaGUy?=
 =?utf-8?B?YmtabVpaeE9pWGlIQUxaVW14eXBxa1c3d2RxN0pGK0o1T29ZV1ZqZG1RYjVG?=
 =?utf-8?B?eCtqdWdUM1BoRHNkek1oMFBkbXJaZUllckczTlQ5cVg1T2NCc1RqdTNmT2V4?=
 =?utf-8?B?TjZkczc0ck1QZjAvZ2Qyb2JDcUx6RzkzSHpTZUFaU0ZwTm1hNnEzK3lMUjM3?=
 =?utf-8?B?bGNnNjlEb0Zlb1crd3hUYlJGU1VvVXNlTGxoTjludER0eFU4REpsbzl5Wi9v?=
 =?utf-8?B?Zjk1QUozSkxGdkVMZWpvc093N2M5eUV1dk1kU2hPbkdCamhYM1BVNDl4Ympn?=
 =?utf-8?B?b0NYc1RqTThrazFJYlZRYVVKN0U1ZG40VlJ4d094aDNrK2d5NFYwWkxwcGdZ?=
 =?utf-8?B?bnpkOG02WDNlazJLQXREdUM3ZCtOSUtObHNERW1pKzAybTBoYzUrZHZKUUo4?=
 =?utf-8?B?Uzlpdy9WOUoxeGkyb1REcTZ0dlRPRUpuZ2xDbnhsVEl5bXRwcG1kblpxeFVx?=
 =?utf-8?B?UE9ka0xEQlNpWk9LUnNsblBwNE9IaXpRYWg4Kzd4WU92eGhlUTh6QjdFeEk2?=
 =?utf-8?B?VUc4eEtxMnRRNUkxZHI1UWsxU0ZvV3ZSZWROamJFT0piSFV0Y1BYenNqWFRM?=
 =?utf-8?B?Sjk4NUNMZ015MHdBcXdqUm5GT3ppYm5GVVRnOVVjKzFlNnVDdzdzNWFsWnpx?=
 =?utf-8?B?K2E4aS9teHZ0d3BIL2hEYlMyZ3o4SjVXMmJkWUgzZ1NlbkF0dm83WXQ3TUVK?=
 =?utf-8?B?NVNnOWd3OENyMjdmRit0eFBvQktRN1l2WTROMHZPZXFycmFKaXVGeVB3TTA3?=
 =?utf-8?B?LzJvenF1Z21QQzRVMWpCNi9DM3BaYXJXOXMzaWdnQ20zUmFhV2tUUDRwRmQ1?=
 =?utf-8?B?UXpFaHZpVDlveFNMdW9YMndZWXNIeDNrclZsVllqY2hkeEdyVGZOZmdkWm1H?=
 =?utf-8?B?SUVhSUZtc3V0VWw2TDh1K1FJRVFEUkpldUVVWEdlSG1HOGxERitUQUUzTTkv?=
 =?utf-8?B?TmFKMWgvblVVRDAwcTRBK01kbGhmMEFtN3hFSmc0RGF5dkE2VytUZVduUUor?=
 =?utf-8?B?cjM2TDJlV3d1bWludE0zc3NLUmlGdmp3Qm5IdUVjVmlSV1NIeTF3eWM5WW5Z?=
 =?utf-8?B?cHk2eHE3NVRQZEJNdnB4c1hqQ2hPc2J4cThZSFpxYXkyTXNvalNxaVNuYkx0?=
 =?utf-8?B?VjlpVHBmRExKUnNkUGt2R0tONzF6VTVFbDA5dlUvTDIxdkttNXllWko5SXI5?=
 =?utf-8?B?Zk5YdjhyNm4zMDQ4Ylc4cEtOK0RmSllMOEpGQk1JdFBzanVLblZsdHErY3NZ?=
 =?utf-8?B?Y0hMNXFlZExmQnRrc1lleVR3dXhqNExLVVlPaVpNR3V1MHUvOU1kNE85dXl4?=
 =?utf-8?B?YlhaUEIwSEF0R05ETGMwUlIwaHFTb1FOUlBiNGllMWtwNkQyV09QSFRyc0tz?=
 =?utf-8?B?ZFlzK3h4NmFwQUhQejUzdmxUTm9qb00zNnFUaElzdDNHTHl5ZmU1MnJPUDAw?=
 =?utf-8?B?NEhHLzFmSm4rSDJCVzJmWUhNaGNTUko3dkFvZ29OeW9vaVFkWDF5WDBBWTkw?=
 =?utf-8?B?WCswV0U2QmgyOHpTblNHdzR5b2l4NmdwZXFER1I1ZjBCU29sTUFvQ2V2V1VB?=
 =?utf-8?B?QnExdkp2TU1SeXVTazFKbXBsVTBUNEpMa2V4bEVXaEhOa3hlL3ZucjhGOG9x?=
 =?utf-8?B?YThIM0tkR1U2MmJZUm5nc3AzU2ZuekJFc1plNFRRRmxPOENLelhqamVTL3Jy?=
 =?utf-8?B?Q2JRbWhXbGVXbFhQWmdZUWgvYjk2QytUVFlSclh5YlUreUs5V0F0NC9EQ0ZB?=
 =?utf-8?B?c0FlMXk3QjJmZTFxTWFsYi9RKzZDZU9ORlFScGJCVWVPSVVoQlEvQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b701a9d3-e3ba-4a70-aa1f-08df0cbb51b8
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB7086.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 08:37:58.2155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fKCGlnBoENPVDDSaqRvlzujIF/JgmqOQqw+I6yn7+z64fExDPV7kFzcwIyPSC0LArs92DQG827kJ35RJldhkyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6737



On 03/09/2026 11:43, Ruizhe Zhou wrote:
> The DMA API guarantees support for masks of 32 bits or wider and
> explicitly identifies retrying a 32-bit mask after a 64-bit request as
> incorrect:
> https://docs.kernel.org/core-api/dma-api-howto.html#dma-addressing-capabilities
> 
> Remove the obsolete fallback while retaining the error check so that a
> genuine DMA setup failure is still reported and aborts initialization.
> 

You also switched dev_warn into dev_err.
Patch LGTM.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

> Signed-off-by: Ruizhe Zhou <zhouruizhe@resnics.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/main.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> index c851daa5da9f..036135df23bf 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> @@ -3863,12 +3863,8 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
>   
>   	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
>   	if (err) {
> -		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI DMA mask\n");
> -		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> -		if (err) {
> -			dev_err(&pdev->dev, "Can't set PCI DMA mask, aborting\n");
> -			goto err_release_regions;
> -		}
> +		dev_err(&pdev->dev, "Can't set PCI DMA mask, aborting\n");
> +		goto err_release_regions;


>   	}
>   
>   	/* Allow large DMA segments, up to the firmware limit of 1 GB */

