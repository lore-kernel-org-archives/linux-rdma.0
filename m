Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011005.outbound.protection.outlook.com [52.101.62.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6DE3812DB;
	Tue,  6 Oct 2026 07:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791270623; cv=fail; b=Os1GO5uqHTzuyA3Bn93jxAkehiKthsXjZUtROHmykEx4dnWQI7vNVfhMchjORb4breJnk1biHJrpT4uDF9kOFB8YkoEHlM8GrLIy/vVmNuO7Eczn4B67YSTKbKCeJga4qWpETpSfeDLQq2jqHv0UCSAgDd/PST4w6ow6Mmqa0z0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791270623; c=relaxed/simple;
	bh=+QDhmsyj3+0WtY8TTSZmCVSA9tp/9ocdsePOkSrTbmA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HR/Z14sTRJ94vnYiYKrM3+6XbRPZ8VzGO2LUVTAhlE1WzD0kW7s2jGsvh6i2bXnfvG3Ae4pFGnJ4HugwRz44Y0wrC+ALOr094E3IU0wKo2R+zHOaaXY0ovXvB1odPTRvF6VemXtuTSg/YJkDDNLjbq6Iu8PF/SHpnhSLOg1Bs8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c7CMF83J; arc=fail smtp.client-ip=52.101.62.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c7CMF83J"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CjMz0MmvEYNE72+CN++iu0zyM4q2erm1ts9URgR/dBGD0DjqYnQKiXkAsajkhpQFMJrlBlrTlnIUwrgzvEMVO3UXzq1gzle2P9q20UVv2bEWVQbxNMK0EJPqMBjZxJyxkYneIL+0BEiIEk/vPMAiH0c3O/bM8SMmPSYxOC/PYuOmk90o/eJDgJM9xguo2awDucbntu/4rTVB7HWMftl2m/yn9KIBcnjJXuvbW6Z08QVYfGoPHyyoa+q8UD9UVRkR5Qg2uFJreZRo5mgM0DNZ85MPM3wjX0Wfky03s6ZVdk+WVdQv+LiB9qaBP0AT0+DZJzQO1u3WLNlAROLhEtoYGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RSQl191BaWKFM14g/kf8B8QHqjYmbPSbBYM/ZPn6eX4=;
 b=KyNEDd8bBpB1d8J4JFBG7SW143Wu92SXAzBZPUl2ThK0h330h4s2xsql6dSMZvWdcQs8fFJZZHqqG5TKiN+6OThq+jNBzg6r0IL2fiN9/lwMV9KD+S0OfhVAFUYtOKtyk22xLmLsDrVzQ+wRTAbSUNL6wj0UfXJaG7joMVurRmvOoDxaXzCVaYRcn0wqCA3Pgo87j3gS3eWldzXec0JhFbbaK0yiZYX5mDp6jJgD69p/J1vmDVKXq+uj2ixzVcZSzxMrhgp/uijjj4MRTuKp/lkgLV7LtyCbU/verpj0jBBka0ysd2zUksBGBGJ3zFx4Jtop3Umvkz0My+rrGlccvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSQl191BaWKFM14g/kf8B8QHqjYmbPSbBYM/ZPn6eX4=;
 b=c7CMF83JnpoXyEonHBMtnYl5MTW/MaPoibSOOF0YPAVKtf/Q3uKlOlCQmFFZmI3W3lInKyQd56OtwdwtdNS5iP1SSCL0fU56wpAoIb+a5ZQDUOAeTPBySa95fdDBMVCSVL28l8WOBGGjcNltYjW8IConQyFxyJsrfpeb7uf55Q0VT+orjYvhp+3sRZTXJ4Y1qAHa0bFrXtTpfooyG7CEoDrbAfMWvPd96GNnrZ6hzBBctDiEp4wJlk7xYMYOI8Dlsg1NbB5CQAZyXKv7Zga/op/blnq9clTMi4Sb7nuS8p0Qx4qpFqjhyi0/6SnRb9+8fMWrlL/w+hGHAgTkDiJMTA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7090.namprd12.prod.outlook.com (2603:10b6:806:2d5::16)
 by DS7PR12MB8323.namprd12.prod.outlook.com (2603:10b6:8:da::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.18; Tue, 6 Oct 2026 07:10:10 +0000
Received: from SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc]) by SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc%3]) with mapi id 15.21.0472.015; Tue, 6 Oct 2026
 07:10:10 +0000
Message-ID: <dd8747e3-5502-44dd-a64b-8d2ad5fae1ea@nvidia.com>
Date: Tue, 6 Oct 2026 10:10:06 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net/mlx5: allocate dma pool structs on the pool's NUMA
 node
To: Seongjun Hong <hsj0512@snu.ac.kr>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261005-net-mlx5-numa-allocate-pool-page-v1-1-01f4283932b4@snu.ac.kr>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261005-net-mlx5-numa-allocate-pool-page-v1-1-01f4283932b4@snu.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0243.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f5::11) To SA0PR12MB7090.namprd12.prod.outlook.com
 (2603:10b6:806:2d5::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7090:EE_|DS7PR12MB8323:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fe5e287-0f42-4791-e7c5-08df2378dc03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|921020|22082099003|18002099003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	CHgbYmW8d8QqTaf6KsS3s7rAvF2C6ihJKtre7p2+lPx1nlsnasm6Sciz7+vpz2D3pawxq8a6FBqgVtgc2Y3Sq61D0X6oRfto55pUue6VxNJdmAh6wykVkuREMQKHtsHeDzuCzKBsNlRUd8NJEWvMciPwwH0bOGLyVKhGW63j5UYgrmvOywYMFid3RavpvIYzEjRkbzDtKn8rj/e82vt715Ppl5rmaT0+xyOI6Kz1yAMA0qLAlJaxqiOz7agXqG4KMIpDI+CL3QH7vg7/xT3TY0V8MWbu7vNPziuVsje3kRZdQhacrDjbRIbdIdi4JG0RAhcbz97D+JJba+SS09utCOZeOmWMVs6oGkLEL6G6AQTF4aqArV7XjTT3s0RPiI/YNmEqS8HrAC0rj/TrQzSnvpLcvCFJ98KXxggtJg3ncNQvrQ+MKzbzMiSmO8eltiQ5o0iwdFi3uxpF2SHtPv+i09G/WYDvlhD0ugETz/nCF2WQpQsOq6AtdsqwxAXNinR3AgWhhV/ogiL8/qHhQPWG8ZpIj1BXbj7OVBlZYF4nWqBOKAN7uw736CL3MhiPvKSeaUdSG45/odbuZvosO0JEIQIo+7siWgBHgVD0ZXkD4iqJnva/ZSEHAEXyBvmOGYsHeTXbiwBQNeVrr7plAaquEDBVHzhd5VnH0+lEQ/3Zx5eGKiF0TCV/uSjn7Ihm5UGzcyUlUqvVDAQC1bBEC/GPeQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7090.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(921020)(22082099003)(18002099003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TnlKU3N4T0hoUmJraC9majBoYXI3VGxsSEowejNPa3MyNmZjRW50VEp2VHJF?=
 =?utf-8?B?NDhHTTMvWkpwVEtubW55UmRGdHBobUlkRktwbytURTRENHlQdGw5eFZ1WEZa?=
 =?utf-8?B?ZFl2M3lwK09jaGFZRUxSaDNnWjBUSWt3OXJDUHNwK2dzUFF3NTd0Rk0vNy96?=
 =?utf-8?B?aG0raUNjd3lGS0prQmdGWW1LOENLMVpReU1iWGNTNUZ2WkpPQnF5aHRVVEE1?=
 =?utf-8?B?bGZsM1ZjTjlreXJqcjdRMG5tNnZGRVREb3JVWjh0ZWVLc2xidVd2R3NEOTBz?=
 =?utf-8?B?RFM4ZE5SUVRGbGtod3NFb0h1SjkyQWxXdDlvemN4YVh1LzBDSnpXTnBJRm4y?=
 =?utf-8?B?VnVia0Q4TGRiLzZ2QjU3L2Z0cHhCWlljcWtUN2RxTlBsTENZL2dNYWJhWVVZ?=
 =?utf-8?B?Z29YeWhpczRablRIQU51M2ZuNXY0RjhueU1CNWVzaTdKTlNlWWVQOEdoVDFS?=
 =?utf-8?B?RitrQm5IL2pKUGJ0SUQrR25OMmJvbk9pUy9zYmJHRGJaeEpKVjdzMUlwTHA3?=
 =?utf-8?B?OHdzQTNkOENqV1hxa1RzT3Nma3pLTnZ5WWVRZHZRVEJuZU4vOEhGRExiNE1V?=
 =?utf-8?B?U3g2WUw4RFIvMEdWeDNkWjhuR2dQSkVsREVOSzQ4cFUzcjZoc1NoMEMzakxD?=
 =?utf-8?B?R1Z1N3BhV1U2RkVXQ2UvK01WeVNtSXpMbkdTeTh5OWpYYVVEWUlLQ2xjMHFo?=
 =?utf-8?B?L2xpSlhnRzRZZ0NTcFJoampKd2xFU0c3NDZiQ24rV1NBdG45eTdqT1o0djlJ?=
 =?utf-8?B?cjRLQ2YyNHNHWGd5Y2xablVHcDk3blMxQjFGT1g0VTJnMHVuM0NnZWgzVWdj?=
 =?utf-8?B?UkY5SjhVdDRkckxTdzYyOGtBZmZremdacnJPb3duWDgwMlhFVHF1MVFkZFB4?=
 =?utf-8?B?MnNCT09lWDcxM3VQMTRUV2NYVHdwMFlwbzh3dVZDTUhaYXpxWFQxWjVXbSsr?=
 =?utf-8?B?MlVqUFJXdTNsekpndVRUeVY1NUo0WFRoOUcycjAvRXJ0N3BtQWQ1dk52ZjY0?=
 =?utf-8?B?bUNvWTU3bmlBUWJtM3Z2eVpaY1VQUjVOZ1A3RUZNNzNaUWJyZDRIVVpKaURC?=
 =?utf-8?B?NkNvWUdDK0xRT2RGZ2xtUDhUMUt2MFFPUE1uSGVrdGVhRkxkVU1rcGgvbjFU?=
 =?utf-8?B?bHVZMC8veGtDR3JsQUFwNnVlMWZWTk1VZ05ERXpkZWdmSVlra1kxSDFLSGxC?=
 =?utf-8?B?M0taVDYrZFdGTjVUTWJhY243Q1RYZ3p2NmZvUmE3a3VkREZMa3RMdjZBOUY3?=
 =?utf-8?B?SW4rdWpHdDVVNHJoY3ZQLzBrTWUvNGI0Z1RzUGFpZmZzTGUxbTQ0TW5aRUQx?=
 =?utf-8?B?b1Y0b3V4TDlibDVhRkpENUxTbjJ3QWtuZEZFcHFueHl6UXJQN3FWVk1yNHRo?=
 =?utf-8?B?NW5PNXVpOEg4aUNlYWRKdi9CSWVqZUE5TWY0eXJaR1d5cGRuT0UrcStoQUt5?=
 =?utf-8?B?U0VXN1Y2V3ZkVVFqK3VuZHJhNmJCMUdXSlFydUpZTUJ2TEFWN0RyeE1JZVpY?=
 =?utf-8?B?L0FJbktEbnZEQTJDTlRSdVltQVRZc0hkaGRBUHk1YWNPNjNzMTJwL00vYUVp?=
 =?utf-8?B?Sk9Wdk1TT1poS3ZFL0ZIZ3JFZG03WDZnRkNrUmc5WnpkMFIwaDNhb3lwc09G?=
 =?utf-8?B?Z3lwc29xenduSjhGUitmMTRWdStsV01LUE9tcDJsaHJINCtRTkpIc0Z2eHQy?=
 =?utf-8?B?UWZBeW41QUg1aEZ0c3YyQXFtL0NoRUlLSEMxY3JZMnRRTndRdXZnVXlaazFq?=
 =?utf-8?B?MnpBaGxGRitvdzdGRHRnaTRSeUgyZzQ2MDV6eDIzUFRYS0FVVkdOV2ZTMVVk?=
 =?utf-8?B?QVJwNW02dFR0SVN5VFNTbzdycmpDbVNkbHdyb1I1K1lwK3QxanFZemhsQkVy?=
 =?utf-8?B?bnRyUVI2Q0Q2enFXSzY1Wms4aFB0bXlNaEsrbEptaFFPOVFST3QwNVpnU3Na?=
 =?utf-8?B?eGFCMExIQm5UdFFDWnJSb3pQOXRRZGtSaXlhRVNBSW1wTENVL3hDaEp5WkFt?=
 =?utf-8?B?WEkyaTN0QjBCRE1lRUY1d3dNamRQNW9ycWJmdjRPMk5JdDVKaElEbVB3ME5P?=
 =?utf-8?B?eUdkVmlVd3BybnozZ1VVVWRmYnlPd2JNc01KNHh1TTNkT3czb3RqWHY5bFIv?=
 =?utf-8?B?RC9rc003Y2U5Zm9EMUFDTUN0UjdjakpZZEFqTmJDV2ZESmluczBJamFna3dt?=
 =?utf-8?B?OVlkNTBCNER5TFlZT2t0amt0WUcyTmtDdS83c0ZiN3Z1aHdoL081VUMydC9T?=
 =?utf-8?B?NkQvbGxodGVoVjc5a1NueGFDQTdSbUNlYk1Da2tGYUJnUkpyWTI5RW55NEho?=
 =?utf-8?B?LzRqaG0vVVBQek5KcEJ5QkNBc3g4TnFVRnN5b04vaDFlMlRVWk51UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fe5e287-0f42-4791-e7c5-08df2378dc03
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7090.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 07:10:10.6786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CtvUT31DyV9sTFXzVmXPHUyhj8QICSbKSZNeax7vYPgmGn/935WgUdZi22fKM1rrM5ZeF1kg82onfI/9xmAWcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8323



On 05/10/2026 16:46, Seongjun Hong wrote:
> The mlx5 DMA pool structs (mlx5_dma_pool, mlx5_dma_pool_page and its
> block bitmap, and mlx5_frag_buf_node_pools) are allocated without a
> node hint, so they land on the node of whichever CPU happens to create
> or fill the pool, whiile 

nit: typo

> the DMA pages they describe are allocated on
> the pool's node.
> 
> The pool, page and bitmap are dereferenced on every block allocation
> and free. Allocate them on the pool's NUMA node as well, so that all
> of a pool's state lives on one node.
> 

Thanks for the patch.

That is true, but these structs are only used from the control path.
That is once per WQ/CQ/EQ or doorbell record at open/close, not per packet.

I doubt we can measure any benefit, so it's just a matter of consistency 
with the other fields access in data-path.

The API kzalloc_node falls back if node is offline, so it's safe.

No strong motivation, but we can accept it.
Please fix the typo and emphasize that these are control-path objects.

> Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>
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

