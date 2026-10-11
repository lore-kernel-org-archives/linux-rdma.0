Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011036.outbound.protection.outlook.com [40.107.208.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D2335C6B7;
	Sun, 11 Oct 2026 06:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791701921; cv=fail; b=qjSYvNsn6oP+waWjiioR1RxwDuaEvpChtwG5LLOuwabmNPHvAJ5K3lwWKRHejV+rVxV5v4EJzrBjYXh4YMnEC8bKuQ73mxyWwRgZ27TrkaKSfGA0Ve8NRS3MlWgs8G7rU0QZWiqKgU837jTZjsg4+NW0AvhVhpIES6bG5RVQCF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791701921; c=relaxed/simple;
	bh=mvGFd0DtU0qlDk6eL0XKblDIlqawr6VQONUkcIKOvW8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Mh9ZFD0azJ+BOeD5XBI3wXgYN3OfFOX1RX4kiQplCdyPqadx3hm8uD9Uwou4uFlVETIkUhsWWwr2o44mfA6ZtwytcuhVkSEubGDF3ysr0iJK5GnZoG+e/GFld+adysaJaT4XjLq/fNBuNP8z2DyjxY9tS9tHdk0UicpoI9HSaXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZkZrpHQ5; arc=fail smtp.client-ip=40.107.208.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZkZrpHQ5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QkRStXE38K4KU1gGcBuaGLY0LtKuoTLrYKllx6vYdrYN7X76f8Z321zRmQFfTjrWRhEjYrEFRRZ26/xxcToO/1KmYXZFKcTChGpAzBG2Q0Ug7wsJozDtpdGE7Vr50QVbXDGVuMS7ajHJpFknnKisujm9GdEb9GyGxYnvabHe6zIZkicWPInNd0in174UpSYB2/cnlJJqm7IMo6nfJoj0P7BEVlSZbaNzOG0gkVc0TBWgF2B4KtU9nBeOZcndgFfZnF/Rz1C0yYMfCdeo3pqYkC3MTxBji32+te5iq3DgksTHCzhU47v07Zpi/Lgjj4fyshnTA5sWf77jehBwsH0UOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whba9PLoKbh+aPox4o8Cfcr04hpcQDsqLYOYD0etZGU=;
 b=SgRU9+Xvnf7bv9DyfSkdp1lVwEH2ZETD2w0nDd9cf3brkQ5KdWpw74O45Js3Vs+lDRj3rXeewwONQsYC3FoeVvH+ZxcsKBEOeXsr7dr5w5e1qKVA3wcj3mX5AAHx5dD9u1zcp1KTYcIufkB/sag+mGoW58huSTIn9taFkkDchfkHH98l65V5smEYibBhjFjk5SNfhyPbNDrRoOAkNMlp1GzR7pWtWeaBthm5FOVEDAewqPL7ETZSQFBUQY6xIviOLYkJAT9fvYIFQPN3AiqQQWE7lKXyk0VpuSpqsG1kOPTrSOucyovkiLP9qbfLlDa1upe6FV2r3JfX1PdF0PCecA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whba9PLoKbh+aPox4o8Cfcr04hpcQDsqLYOYD0etZGU=;
 b=ZkZrpHQ5mPaaCGEWGDvF/g/SqIvu6vDroRf5uhN/UZpCff6Cz6uUtqmtz6AVOcObYgjT/1JdJ+rjct1b5/JLSses9xrYwwLcYE+5GR/V8tVYqXYI+mKiAN8woYdTsLw94K+xdHQMfiI9pq9aRUTZmtgElsUutgPTR9XvURx+asn6GF7VGtfisvcF9OAZ+Mm8KGGHhy5k3eZJuYCAtYE+e2jBfLc4E71tQQwp9JWkkm4ehVao+/aiGymvhCId4UbLMjKO+ldUOPtD6Yjg76LhcZyZjslUyHEcHjoK4cxIDecy9nogIgGo0oqewU/DGiJHkLql//wCAR7VKxoZOVJYAg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7090.namprd12.prod.outlook.com (2603:10b6:806:2d5::16)
 by MN0PR12MB5930.namprd12.prod.outlook.com (2603:10b6:208:37d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Sun, 11 Oct
 2026 06:58:34 +0000
Received: from SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc]) by SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc%3]) with mapi id 15.21.0472.015; Sun, 11 Oct 2026
 06:58:34 +0000
Message-ID: <b690f858-5310-4959-a38f-2800455a6bb3@nvidia.com>
Date: Sun, 11 Oct 2026 09:58:31 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2] net/mlx5: allocate DMA pool structs on the
 pool's NUMA node
To: Seongjun Hong <hsj0512@snu.ac.kr>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261006-net-mlx5-numa-allocate-pool-page-v2-1-0dc4c2eb1376@snu.ac.kr>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261006-net-mlx5-numa-allocate-pool-page-v2-1-0dc4c2eb1376@snu.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0043.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::16) To SA0PR12MB7090.namprd12.prod.outlook.com
 (2603:10b6:806:2d5::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7090:EE_|MN0PR12MB5930:EE_
X-MS-Office365-Filtering-Correlation-Id: b63e9565-a226-4490-2d00-08df276510ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|261009223027099003|921020|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	XhhhvChmcp+b6WaL6SWveQUxXzDDpTMFWqad0pgc88ee563YKMiieo/XKcG402YWxzW4NmrMj50nvKcSH8b83RLgRcD543mnGN2foMer7b6YMHp3Pjs8uLQmuKhWc3UEfkLvhkS4s8R0iqzAHPukxxbhLCpll+pJLhjgCkWIzU4HGTklVrdWUkBcPMECccLzv0hv323bpiBFl400/2IBRfirvUOoUuIlzNPNBPOPaMzv/GJ5qabUWS2suRt1S2Fs4OCV64QRsN97VKC8wvAk5jxBBoKukVNGpSa5452HtUDOpR89/1CpUlaJEWKriVdiEdpDGxPPS44EI99DRZyi44kP7AX7qPkwkAcpNJ8dqgkKwu/eGypLbguK1mKzZxGFf74hiigIIALFez8FDR5v4yXcSDXViVGqf2F0BWsHUsCxYu4dkA/XLYhEj3VJb0hHOOP4Ie3K0yCFw/cp7e7oNVOuDl/AniVIgDfYiATf4E8cfxXU5vYSRXPKQ2lalTKX1OlaU0RSs6pMFk4C++B3tsQtdH8KvLsFFQaAvH/ZaEZWNhsE8Z/TPxDYFQ9Elbx43GxKjnQLjIykaJ0CFHNbusjS26yAy9dpqywpqaCHuEbIlYGgQyn0HKFflcleVdlKYp31bBPMjgs0QEMoRBcgPpx1LIsKhYocMwzZaftXYrg7H+zEn55tpmJyFEsgv1Rb0uglrOZiBzun/PlsiHPYqw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7090.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(261009223027099003)(921020)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d1pSRll6L2lDT2R2dGl5RVpWd2tiamF1V2FuWU4rWFV3ZXpxTzEzYkhKMXJ6?=
 =?utf-8?B?T2kzOGVWWU05MjRHUXYrNFZaTkY5UWdMUGNPWGE1WGhaODB3eUxwNTN1dUhz?=
 =?utf-8?B?dXA2VEk1Q05LekR4T1ByMHhyWm1hMWEreTZWN3o5T1cxeWVtR0g1bFhFM2ZH?=
 =?utf-8?B?R1NtamEzOEVnOExJcEU4aStBUGUwaytnMEw1dFpyWFRCRmdjNUQ4V04xdWYy?=
 =?utf-8?B?UzZPRzZJcE5qMkw3VGxFYU1IQTRFQTdZK3VBM1oraXVyZUlncnYweGttVUZN?=
 =?utf-8?B?L09TeWU4aVJraWZMYXA5UVFGai9HN3VpNHdvQTZWbG9vMnoxZ0xlT0pOWCtG?=
 =?utf-8?B?QUxldDd3VU5iS3VVTCtJNUtRd0M3TzVhM1JZbkJyQ3ZBQjYzVDhFbEZvTDlK?=
 =?utf-8?B?ZGticE1DblhpTnhYbEExclJibWFxN3ZCb29QMXJ5aERkUTM3eEc5YmpxZC9y?=
 =?utf-8?B?WWhmNlo3MmhDbDZBeGZyOXl4Z3REVmNFcnRrS29JYlFVTGhLQXkvL2d4N1pJ?=
 =?utf-8?B?dUlTRzV0UkJHcW8yYzJIRit2eEdTeEIwdmpYUHN6Ty9OblJxa0Y3NTJyYlZI?=
 =?utf-8?B?MUxlVzFHdldnQjFWWDhXYkprYXZYVnJLL2VacDFMT08zMkc5RC9KU1ByOHVO?=
 =?utf-8?B?NjVya2xLUjFvYmdsTnI3czdoanZlVkF3bjU3SXUrUjR0UGVhc0szbHF5NStB?=
 =?utf-8?B?R01lSjU1dnNPR2hzTHlnYisvLzFieGJraC9ZYkxzZVh3c0xFUC9TcUtrbjA3?=
 =?utf-8?B?bGRCM1lNQXNlT2pzb0lQcVMrR1RJWnMySmFidzUrNUhJSldoMThOUkhIbHhr?=
 =?utf-8?B?OU9lK2tnVHpDc2NqcmVKWXVhYU9Wak9TK1hWdHBrNVBybnBsaWl6QXh3Wkx6?=
 =?utf-8?B?aCt0VlFDZmZoaGVqVGh0dDgvODRocUJ1RkhhRkxlWWhEcXY1ZlM0YmF6cmE1?=
 =?utf-8?B?OUdZVG50NTZPZUJHaUhZazd6bE1XVzVBZEVYZTFDOWkyMDIvRGR6VHg3dFk0?=
 =?utf-8?B?OTErUmdwamo0NldvWlM1c0FKTGVmSEN0dHpZaHZpYVdvU3V0ZndkRU9lRS8w?=
 =?utf-8?B?TUVkLy9XYmJnSWEyZjNKUWFObk1UVU5SbWRZNit6WGw1TlhKV0JieTlLNmFP?=
 =?utf-8?B?SSt3WVhQQ3BTVFdwaCtwOGFJMWhGQzFpWWtLS29KSFZFR3hsTFAvemhmcTB0?=
 =?utf-8?B?VFpwSmUySVpNYUl3ZU1SbFROSHZYcjIrVUxmVlZaT0pHWldXUVhZd3p1b2NX?=
 =?utf-8?B?YzZ5alZ1U2FjTTh5NDdlZ0NpM1doNTd1YjY2S04yZGZFSWUydFpmaThDaGdO?=
 =?utf-8?B?V3BmZDd4Q2pjeERZNnI1K2Fvem14VzlTekFDMlJXQkI3djE5bEE3UXNTLytE?=
 =?utf-8?B?bWhxMG9tZ1BQTHRyYVZueCtZS2pCWHkvSDZ5OG5SMUZTb2FqTENZKzNIbThh?=
 =?utf-8?B?cFJlZVVRMEdUMFdVUGRJSmFoZWpUWGt4SlpPczdleXNDVUN3S3lPZ0FrUDJ1?=
 =?utf-8?B?YVA4MTN0bHJaOGxrNkxwVjJKaEUxaXVzbEJ4MGcrOUlBV1dyRm9Xekw4cDBX?=
 =?utf-8?B?ckxsQzMzcE4xdEE5NWl2czNXWUpIb3E0ckVkNFRPdVpMdUNaMG5SSEx3N0Ns?=
 =?utf-8?B?dy82VGRHam91bkxneDZBQnZNV0EyNHhJaUR4a29URzUwWlZwOUhQdkdSMUFy?=
 =?utf-8?B?RnNraWNObURyWlNqdVFLUGtzWTlYaS9KYld1T21Sc1h0MVRtTmoxWTlJUzRo?=
 =?utf-8?B?aFhWK2dNT1ZxekxKbGtndUNKa3c5NVhsZlJQN21UVy9HT2dsNEI5ampnYWZa?=
 =?utf-8?B?b2kycWt5Smx3OEZ4NGRnZng5dm1tUEFreFhLYTdIUm54UW15OWM2eElaQUlh?=
 =?utf-8?B?VXUrYysyVjAvYndUUFp5dDhIMVFJTXZDUm1jcGhxdUcxN1JVWEEwV2l5RzNu?=
 =?utf-8?B?Q3ZGMFF3V3FyUUdhbzljRWdzSTlPSE9JT2o5d29kQlhjMlN2UGloYmJaRjZl?=
 =?utf-8?B?VVFaYlZ5alp6MHBWWnI2K2F0Qkp2WjM2MWZNaGtMWlROVTRkelZFVmQ3aU9a?=
 =?utf-8?B?YlY5Q21iTHk3RjBPeURKUnhnaEI2NWRrTjUxeDhIZmZWVlNmdy9VQ3k2ZU12?=
 =?utf-8?B?dSt2TTZLSG5lRXBnV09jL0wyL2FkVnBhendTNlRFVER2Y3FoalVpMDhrVTk5?=
 =?utf-8?B?dTNXcHBmdThjaEkyc1NUOFJ3SC9nREVuajBuWVFTRm1NamZUWjEyUERlZzFE?=
 =?utf-8?B?MS9YK1AzRDkyazB4QXdiZ3lqdDZIMTNkSCtyYmN0WVBjdEJNR0VQV3J4VDc2?=
 =?utf-8?B?by9RV1BKTStOb0YySFVwYUV2VGdGT055WWQ5OFFUa3Q4UjJFUkRIQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b63e9565-a226-4490-2d00-08df276510ff
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7090.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 06:58:34.2781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aMHWWNFli2c1200OUuy0FbbTxY6lpYcP0y25kjaIs2XTLFM/+bN65CP74YCM+QvRXHZdN3MiqTYLyWmPW32eWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5930



On 06/10/2026 17:16, Seongjun Hong wrote:
> The mlx5 DMA pool structs (mlx5_dma_pool, mlx5_dma_pool_page and its
> block bitmap, and mlx5_frag_buf_node_pools) are allocated without a
> node hint, so they land on the node of whichever CPU happens to create
> or fill the pool, while the DMA pages they describe are allocated on
> the pool's node.
> 
> The pool, page and bitmap are dereferenced on every block allocation
> and free. Allocate them on the pool's NUMA node as well, so that all
> of a pool's state lives on one node.
> 
> These allocations happen on the control path, so the performance gain
> is expected to be small; the change is mainly for consistency.
> 
> Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks for your patch.

> ---
> Changes in v2:
> - fix typo and specify the structs are allocated on the control path
> - add a prefix net-next to the subject
> - Link to v1: https://lore.kernel.org/r/20261005-net-mlx5-numa-allocate-pool-page-v1-1-01f4283932b4@snu.ac.kr
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/alloc.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
> index a92cf545bdaf..dcd281c4691d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
> @@ -110,7 +110,7 @@ static struct mlx5_dma_pool *mlx5_dma_pool_create(struct mlx5_core_dev *dev,
>   {
>   	struct mlx5_dma_pool *pool;
>   
> -	pool = kzalloc_obj(*pool);
> +	pool = kzalloc_node(sizeof(*pool), GFP_KERNEL, node);
>   	if (!pool)
>   		return NULL;
>   
> @@ -127,19 +127,20 @@ mlx5_dma_pool_page_alloc(struct mlx5_dma_pool *pool)
>   {
>   	int blocks_per_page = BIT(PAGE_SHIFT - pool->block_shift);
>   	struct mlx5_dma_pool_page *page;
> +	int node = pool->node;
>   
> -	page = kzalloc_obj(*page);
> +	page = kzalloc_node(sizeof(*page), GFP_KERNEL, node);
>   	if (!page)
>   		goto err_out;
>   
>   	page->pool = pool;
> -	page->bitmap = bitmap_zalloc(blocks_per_page, GFP_KERNEL);
> +	page->bitmap = bitmap_zalloc_node(blocks_per_page, GFP_KERNEL, node);
>   	if (!page->bitmap)
>   		goto err_free_page;
>   
>   	bitmap_fill(page->bitmap, blocks_per_page);
>   	page->buf = mlx5_dma_zalloc_coherent_node(pool->dev, PAGE_SIZE,
> -						  &page->dma, pool->node);
> +						  &page->dma, node);
>   	if (!page->buf)
>   		goto err_free_bitmap;
>   
> @@ -278,7 +279,7 @@ mlx5_frag_buf_node_pools_create(struct mlx5_core_dev *dev, int node)
>   {
>   	struct mlx5_frag_buf_node_pools *node_pools;
>   
> -	node_pools = kzalloc_obj(*node_pools);
> +	node_pools = kzalloc_node(sizeof(*node_pools), GFP_KERNEL, node);
>   	if (!node_pools)
>   		return NULL;
>   
> 
> ---
> base-commit: 8b4e7209c842d8cb9516f1f5ef0a88aa2d8831a6
> change-id: 20261005-net-mlx5-numa-allocate-pool-page-2ee20a04147e
> 
> Best regards,

