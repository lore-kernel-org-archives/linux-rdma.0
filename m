Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011071.outbound.protection.outlook.com [52.101.52.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1E8369D5E;
	Sun, 11 Oct 2026 07:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791703666; cv=fail; b=r0lb5MyiaJPYZ2FQMHsjNPjBgXKG7Pqx1AhEvoa3ycSeu34vuTOM8gDJG8Dfpz/RPFehuxJ7QdndQzmMGouiZsM8PML5RSdKZWTS9wMzjHaQm+JhfDEUlcz2JTuLizwdZrgSt2K4DFFN3X9ds6ECVy9QoSME/WD+AgL1ypMuE/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791703666; c=relaxed/simple;
	bh=Wwb+ubSG68ZYd6HfkV8i0/IREiSetTACemh1QFbbAkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=LAJV67Pqh7HyTAaslcuaiVofPKONiBZLJqVF8462ZczWCBfrFG+Oxt8EGTLMAvwIkhBAUxXVWCtK+Vljk5rXa++lJLWO69NLz2v//eHwUC3FYvQcCiJM/v5V9Z2rGt6jt+17GcKgkCYx3P8EtpiuIU9wDrOmPYVaCJd/XT/BvPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ARqr6T4f; arc=fail smtp.client-ip=52.101.52.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ARqr6T4f"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pMa3Y1UUq99H0B7ONvJeHPcw2nkE1SGmGaeb/46CDovjGpaaJ5zFdpqEEjxqeFLRtIRqufez/xjDGSMLAtKAKqsBTDQGouaP+eK/fUQZDwrepDatBHuQd0nkVcSEu81AahwxLvQ8L7QhoxT/PLb+xyvzDtv3GGcPpPDymGFFqLTW39CD5XNwq+hGwWYEFmZkNvGDjlC17Q/fVjIfiK8IEgI48/AxZyE9zCTtjscjqG2xVCCh50iIJpL0q86rJHS946yc4iibkg/Rf9Svx039G1/4LnHi2JJTdw3pkDiPqCRzyaj+0s5PNoOWVndGVWVUslJwQmkYIoIiE8ludcY4Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Uv0IEEf7o7suutZS+YjwznCG+weuQys1fNSN+ytGQ8=;
 b=mtBD+5bEOwz1Mv+LRCQDiCeptfEpbsx3O+UT+doCbAFtUO1xgXeK3bMNooRemn9ttwZV0294/xa+zHGgh7oUORDJ3aaPLNyWEhLxK8jJHVjX5G/X+1cRNqxetf1TbstZZaYcer2lrrQihODqeG4aCScsws94+YRa9tmSNTBViptxA4rJwzU123h4SywCpRowbSFH2QxLicgg8GkD96JvphIRiCUfcB3o2JCJv5AIE/ejcqlAp1Dz4eN9uZyXULPrc9f7CeLfSsi04UKgJ47Sfxhxc/KDeJ5L/RK6RnGcYTYKCvzuGef3OrbDxyNe/9pN9fD5FdIo7phYwNBkS31L7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corp.free.fr smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Uv0IEEf7o7suutZS+YjwznCG+weuQys1fNSN+ytGQ8=;
 b=ARqr6T4fw0SMi21Kxbna81xtoZKZsFFeukZNDk5Oc3fii5I7vydDFjt4UQpbM3TbI/PP0OnDQQbzZ9yOC5m9GnwPP5R7wNtc6EA0wgVSk9q+FAL3B7tfEZXYMj5lcADPu+TcJRw+d5/9ovHSNghnlxgfqxSzAqj+Xiu5V8NdS/dvQhwt5gy2DzW7/P8GR3ucrPENOnJSNKfhRGqK20Wbgl9ExSkuOTbqy55gPY4DallVplnUzwrqVyc6aJOh9/JK1bct/r5Jv6yd14oDynTEmQya6FFj9K1Jk7qZbfjC++20jLtGe4UlU6SGlqYbGbVZvtJHhv5vLtpu4SaPPaM1sQ==
Received: from SJ0PR03CA0264.namprd03.prod.outlook.com (2603:10b6:a03:3a0::29)
 by LV8PR12MB9643.namprd12.prod.outlook.com (2603:10b6:408:297::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sun, 11 Oct
 2026 07:27:40 +0000
Received: from CO1PEPF0001886A.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::37) by SJ0PR03CA0264.outlook.office365.com
 (2603:10b6:a03:3a0::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Sun, 11
 Oct 2026 07:27:39 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF0001886A.mail.protection.outlook.com (10.167.249.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Sun, 11 Oct 2026 07:27:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 00:27:23 -0700
Received: from [10.242.158.141] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 00:27:19 -0700
Message-ID: <d6fd14d8-2135-49fb-aed4-423422b35b2c@nvidia.com>
Date: Sun, 11 Oct 2026 10:27:16 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/2] net/mlx5: HWS, fix reformat pool creation race
To: Alexandre Cassen <acassen@corp.free.fr>, Saeed Mahameed
	<saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>, <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <20261008204230.3222198-1-acassen@corp.free.fr>
 <20261008204230.3222198-2-acassen@corp.free.fr>
Content-Language: en-US
From: Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20261008204230.3222198-2-acassen@corp.free.fr>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF0001886A:EE_|LV8PR12MB9643:EE_
X-MS-Office365-Filtering-Correlation-Id: d5169de5-cdc3-48bd-8737-08df276920a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|82310400026|23010399003|1800799024|18002099003|10067099003|22082099003|261009223027099003|11063799006|4143699003|56012099006|15866825006|41080700001;
X-Microsoft-Antispam-Message-Info:
	3XbzsdTby8Br5aQq7pkKV2Q2feGIBJ102kLknaQBHrxCNqGClzjBj/12m3LD3OxpjlsfcKYFOizd7DwYDiPALhxKJghDuQcVtpxaCB78UPMBqU49PfSriqfqPgVEmGqgtUvp2VV11s6NLRuU4GJgxj8vFPYpqQpsubhDF7gQDE0D+4Zk9EkAUbVTuatA/EWj2r6PkbQVgGoUyQMUWevJxKv81uBIiaqyV4N2Geu1pD6hW2JerVi7h4V/xYwk0sROKNFWk1Bh3wWlhQABSsP8l/65J2ZgO2K8UKZHwn4lN2k6jLCzbVoPjUdlggx9DKUJuC6QLTVLkrDWwyW0+f8f9aa0Cg81F+fadQ9HGcuPqla+GCQmwOM0N4ctZItRTGyg55D2sJZhsp0FfXWcre30lZJgWn4WaRD0ZyGWODdMW14HyRnFOlbUu2Eaw4hu9a8qOeZICQkNhAxWne0527x4jhKl9vydjsk/nd96DSLP2eyIv+RKJA1apZX67kKuOF+1Gk2cv56xKSZJk0hLd7V88LREKXQC9nnT3e953O94laxvj779ZKgkyysxiHt01tYby+qZjPbp9Ov6U317XkdgF3YQCWf4ahl8f3WlPA1vFYT9kJ1/jdbrk4N6mG5Tlyap7IN2Nm/ipe6YpLhKKWJKePIJEyjk2zGsgsE53uw0nMZg3NMoLS5luUjJVilBhJQRETktARuopum2f3hGSBl8bid83S63lfz0eBuryh03ESdvtGZyq0cdZOdfXKF1ZgKbC1h9PD5p98xQqWsIcM5mZfTWc5uQcfPAYQS3i7rFJm0=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(82310400026)(23010399003)(1800799024)(18002099003)(10067099003)(22082099003)(261009223027099003)(11063799006)(4143699003)(56012099006)(15866825006)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	d7QchLAocMKOFhjPd91f76EgtFl3znvwUb7i6BGxPFea9AnzPIcnugIbefapqjwdpB0HdW1QdBJQqPxKMNUFBueQSdZ5g5PlRlMMEcvflwro+Evc8tHWFgxk8VQf0VGcqRRzVCD32MAA7C9pDKc9xm4dM3BUTqvpEm6Nwc+HWKM0REgdeJRzMzzJT0AxdNw5wu2T/FgOPmDi8kpRZtVQIerVCwZibb+lmTmKdH0ViqN1ZuOa6xlqUDCOpVpt59B7iKxcanurnSnxhJZ5MkjzN7MiA99RF9G9dV0VeIOEevkakP3guYe9NmynkcNeaWQvl7th4ZdeIl4pBOxItAOaZtTtlHlI9T+MvVZIn4ewZIpfPm4Tj+mklvYRqbpxPAycbqXPQBnm/FqmgVEtHcMwbv3/+UYDcoFJ+a/GMGrNi564MEjTgXbe8hQwiNfFk2lC
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 07:27:38.1371
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5169de5-cdc3-48bd-8737-08df276920a1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF0001886A.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9643



On 10/8/2026 11:42 PM, Alexandre Cassen wrote:
> 
> mlx5_fs_get_pr_encap_pool() inserts a new pool when the lookup misses.
> Two callers allocating the first reformat of a size at once both
> create one and the second fails with -EBUSY. TC serializes these
> allocations under encap_tbl_lock while RDMA flow actions on the FDB
> don't.
> 
> Sashiko AI review of an earlier series spotted this issue.
> 
> Tested for regressions on ConnectX-7 with firmware 28.48.1000.
> 
> Fixes: aecd9d1020e3 ("net/mlx5: fs, add HWS packet reformat API function")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Reviewed-by: Moshe Shemesh <moshe@nvidia.com>

Thanks.
> ---
>   .../mellanox/mlx5/core/steering/hws/fs_hws.c        | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> index 5a172c572a68..66edb42268cb 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> @@ -1228,7 +1228,7 @@ static struct mlx5_fs_pool *
>   mlx5_fs_get_pr_encap_pool(struct mlx5_core_dev *dev, struct xarray *pr_pools,
>                            enum mlx5hws_action_type reformat_type, size_t size)
>   {
> -       struct mlx5_fs_pool *pr_pool;
> +       struct mlx5_fs_pool *pr_pool, *old;
>          unsigned long index = size;
>          int err;
> 
> @@ -1242,13 +1242,14 @@ mlx5_fs_get_pr_encap_pool(struct mlx5_core_dev *dev, struct xarray *pr_pools,
>          err = mlx5_fs_hws_pr_pool_init(pr_pool, dev, size, reformat_type);
>          if (err)
>                  goto free_pr_pool;
> -       err = xa_insert(pr_pools, index, pr_pool, GFP_KERNEL);
> -       if (err)
> -               goto cleanup_pr_pool;
> -       return pr_pool;
> +       old = xa_cmpxchg(pr_pools, index, NULL, pr_pool, GFP_KERNEL);
> +       if (!old)
> +               return pr_pool;
> 
> -cleanup_pr_pool:
>          mlx5_fs_hws_pr_pool_cleanup(pr_pool);
> +       kfree(pr_pool);
> +       return xa_is_err(old) ? ERR_PTR(xa_err(old)) : old;
> +
>   free_pr_pool:
>          kfree(pr_pool);
>          return ERR_PTR(err);
> --
> 2.43.0
> 

