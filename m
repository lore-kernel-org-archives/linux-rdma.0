Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010002.outbound.protection.outlook.com [40.93.198.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAC6EED8;
	Sun, 11 Oct 2026 07:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791705453; cv=fail; b=sm/fdqi3XURQOKjCPozbKcaZJW8l/4YIIiD2aacAjLFwb9pouI3rgxFz63Wv3dsTSmR2LujDErYfMMx/pYbB+zRYm1pkHvDHU6atqgyBrQV/4b/3MncqorCUZBEXgzd17eTW7hCpDG2rNbOJCKaKj4+1QM0fjrnW85OiLMOVXAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791705453; c=relaxed/simple;
	bh=pXb28Ss9sk3W3UmUgYuufFxd5RzYvJJQSN1fz1Euesc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YLbyK9t6VFzlYzcP6tR8wn0J85oWgfYvlh9vmj6/T6YFDa96yYRt0LZvWzv1ZG0KD89y6zLVa/2bH3HMtaQXYhHAFyVI+SVae5KC4UZl2oof9wbB2V1vl9aslkj+jkY6nxHuCifkcZZAhhovI9bIvwDvRkrjwf06bH5wg3enm/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JgDyb/Ma; arc=fail smtp.client-ip=40.93.198.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JgDyb/Ma"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hgsXHimBrWk5YFsyplslpNwZCqx0DtbHfk/wPk4GlZ2cjs0UGNSph80BAAlnvXPm4ea+/iTJ1S8X8U+s2Ivc9pzdD/GhPNkJoFV07OF8Fmrdb5sm2OiPEzNNTl+40U/p66jz8ERWG/i/NeNaZ010fcqMoDXQ0P1k3FaDH9MrwCMjxRaNTV137LFusc72LeqhDgZqdmZuunoJYCAGnKhKnR32h6i5C5UhkmXTcfIg/nXXdK/wX3buAHyK4/S7hhhskH/TmgHSO4oYi2Ei+KwemxetUJmuzvVFICiSpHz4X2P+Z1LU5+ui0npDtCOu+JevAzryksMzFnJkR9hhYV2Z6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=limX0KAxtPRd39A2YeQnqcHsaLy6ZxOlDSKBC6ZTlFE=;
 b=tJh8tzcVmHHUl7M42oSH8vhQzd6gf11rm64092nRX1MOYCAz7WFx2JP9smNLkonGG5iP0n4ux2kLnZpMLSBvyDpOxVYA5CIp6sk7B84/oRBlnKk2Gbfz1E0agCgtPmmi5AHeJGQEp4AqfFQiVosdpT2e8qiorzi8YJCsk8+yMJ0mV986xpakh0tO9/YVo+YSxtrhb2pUdjd8nAkj+dAmFUpH6ar24LRKUb3gUx43YrUYeR383t28XQIeI9snWy9srpdkvYajKhD9vfLNvnDthLgcOWHGwyOdm7l/+1aJ3uPxaCowH4DHfdL3aLa+AMU3Ec3iq63spzWTjFvSSJdD9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=corp.free.fr smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=limX0KAxtPRd39A2YeQnqcHsaLy6ZxOlDSKBC6ZTlFE=;
 b=JgDyb/Ma5jwgpWDEmyutCP6fuTMlCI2QAvjqWb3eswPI9iBt0De28rcXlXJTblR6UL/9pezTCEPX2wxBVxKNN8Zu8bU31hidEW1WxYN7iwifaYgdVTdFbM586H0WjUBcRYI87Enskc6bm9i2OQ68vCr/PE+DKSxKyb+u377tuVaZD85A9fGkZirl8lFumh2Cje8E3Hd9gzeAIsQToHPMTCHMaYKuNHcOgmiBmrtzFIZ2fUSFYArDCi9T+mZC7nUUagtGmSvisu11msnMZZsf8HtPTU8FcOB/yBW28YAVnhiZ+uPWgwE93bLHkHfI4RnYGcK7Kk9yF2uiZkJDzFtbdQ==
Received: from MW4PR04CA0101.namprd04.prod.outlook.com (2603:10b6:303:83::16)
 by SA5PPF530AE3851.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8c9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sun, 11 Oct
 2026 07:57:26 +0000
Received: from CO1PEPF000066E6.namprd05.prod.outlook.com
 (2603:10b6:303:83:cafe::3a) by MW4PR04CA0101.outlook.office365.com
 (2603:10b6:303:83::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Sun, 11
 Oct 2026 07:57:26 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000066E6.mail.protection.outlook.com (10.167.249.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Sun, 11 Oct 2026 07:57:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 00:57:08 -0700
Received: from [10.242.158.141] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 00:57:04 -0700
Message-ID: <22e85761-ba52-47c1-92bf-b4dd331fc069@nvidia.com>
Date: Sun, 11 Oct 2026 10:57:02 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 2/2] net/mlx5: HWS, fix modify header pool creation
 race
To: Alexandre Cassen <acassen@corp.free.fr>, Saeed Mahameed
	<saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>, <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <20261008204230.3222198-1-acassen@corp.free.fr>
 <20261008204230.3222198-3-acassen@corp.free.fr>
Content-Language: en-US
From: Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20261008204230.3222198-3-acassen@corp.free.fr>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066E6:EE_|SA5PPF530AE3851:EE_
X-MS-Office365-Filtering-Correlation-Id: 5db35d19-dec5-4a80-8c8b-08df276d49dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|376014|82310400026|10067099003|261009223027099003|11063799006|4143699003|18002099003|22082099003|56012099006|15866825006|41080700001;
X-Microsoft-Antispam-Message-Info:
	fR022H4O4pU+UEiDSUx5we1Z55+7PlV2YXVSJb0MSSR6ZC+RsGQrFh1eg1aoft0r+b2uPbMM7GeteY1WajBd28eY2DSwHY4kQ62tAHdgQJEWyfnIbcc2T7FjAq1qLXfDCE/WQtqZL4XqYhI5moTzh+E61hJcTns5+Df4bDpw/oUYXcJnv/A+I2OSYAsplu5A9zXMC2xfzFVU5UIiu/7aZ2A0lDeXLQuyaggpv2vS7bRPqhaPyNVvLjc1PC543AGJ0UKtA2eDJegQdTOWGpdUrOomFW1zrrqHR7GzL8bzEMJzoLYeVXv/Ow8yTiGUpD8sVNbcy3Qug0qyf6POVlN8sgE7UTK+T6oz/WMahZWAY2awB0XYdxXGPGfUCTDaqFxVQsD7bCss3XOT0mJTo9rfeGn7sgedhozESy7zSFEwX6vjtiVMHA+9ruWnULU6tLCyUGUTBwltcLzc9zjPFdnYXIx4Zu9sfgG7LO3JWl36Dm5n1cHGqlgkIS1soTxNRj4ll5iron5Q1FvORtuCOCneCJBCuwjcLRXlho6shaCH8eG21qNQljnjRU5y2BK5PjC1yktbFCkJGRnZfRz3R7ROkn2dir8Az6+97vm6nwyFUbEZy4ljgXug4cerJtdHRfaJj4CgwErqbjgmgqfXUEVIoQ9YGg9yAEfyUr+/f4fcDY5fnLk9XzHuJKMUbUmLVnbKVwNSEb2Icu9M4Ac8jhrbJQfzIl73dy8ysKt6i7273NruLBVLCHUQq+BvQrg+mBpcCma6XCsj9KjYohEsuMPIjP+yIVuqQ3IDpRQz4MkStvM=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(376014)(82310400026)(10067099003)(261009223027099003)(11063799006)(4143699003)(18002099003)(22082099003)(56012099006)(15866825006)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZSWL48JyTRlv+ZvgeKHel4UJsUbHQ5aI2IRlLKKkVGlRM30zfxaX2LMjOHFerHjeI2vlBtnCxqFq0vyTWb3n5H25ZtjWqboAm3wsWeO/WmH6DhefEM8fkdENgIIJ8CSXM506woFrw0iVQ/YoApnhluOLq21CKNRx+3YQrR98aHPPwfUsUP1BxUIm22FRgIbhpwonwKsRuFJyao1tBDUam6MuqLEenLItCz0ufvhmm2+R3xTkR0P2r1WYKziheny4WNFNAMJbFZyZIZ9Rs+haWIN973bi46VTMf1DE5Lca2pmcKcoSmW3oMTDkBY7Rufqc2B/jZSmgV86Tjqh4DiadU67/jtrO/fF9OorPJU4eNj7ug4w2gzKK7cL194wJjUmN+uze+6cmn8cKfpAz8YTOTn1tKEvvHBTQR+VnkDxtW9e8Pjl80ZZC0oiPnhQWzar
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 07:57:25.3150
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db35d19-dec5-4a80-8c8b-08df276d49dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066E6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF530AE3851



On 10/8/2026 11:42 PM, Alexandre Cassen wrote:
> 
> mlx5_cmd_hws_modify_header_alloc() creates a pool at the index after
> the last one if no pool matches the pattern. TC and CT allocate modify
> headers concurrently, meaning two callers can take the same index and
> the second call fails with -EBUSY.
> 
> Its error path also destroys the pool it just created although another
> caller may already use it. Keep such a pool since cleanup releases it.
> 
> Tested for regressions on ConnectX-7 with firmware 28.48.1000.
> 
> Fixes: b36315ca69cb ("net/mlx5: fs, add HWS modify header API function")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
> ---
>   .../mellanox/mlx5/core/steering/hws/fs_hws.c  | 21 +++++++++----------
>   .../mellanox/mlx5/core/steering/hws/fs_hws.h  |  1 +
>   2 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> index 66edb42268cb..b387016bb5aa 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> @@ -63,6 +63,7 @@ static int mlx5_fs_init_hws_actions_pool(struct mlx5_core_dev *dev,
>          xa_init(&hws_pool->el2tol3tnl_pools);
>          xa_init(&hws_pool->el2tol2tnl_pools);
>          xa_init(&hws_pool->mh_pools);
> +       mutex_init(&hws_pool->mh_pools_lock);
>          xa_init(&hws_pool->table_dests);
>          xa_init(&hws_pool->vport_dests);
>          xa_init(&hws_pool->vport_vhca_dests);
> @@ -111,6 +112,7 @@ static void mlx5_fs_cleanup_hws_actions_pool(struct mlx5_fs_hws_context *fs_ctx)
>          xa_for_each(&hws_pool->mh_pools, i, pool)
>                  mlx5_fs_destroy_mh_pool(pool, &hws_pool->mh_pools, i);
>          xa_destroy(&hws_pool->mh_pools);
> +       mutex_destroy(&hws_pool->mh_pools_lock);
>          xa_for_each(&hws_pool->el2tol2tnl_pools, i, pool)
>                  mlx5_fs_destroy_pr_pool(pool, &hws_pool->el2tol2tnl_pools, i);
>          xa_destroy(&hws_pool->el2tol2tnl_pools);
> @@ -1474,6 +1476,7 @@ static int mlx5_cmd_hws_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
>          pattern.sz = MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto) * num_actions;
>          pattern.data = modify_actions;
> 
> +       mutex_lock(&hws_pool->mh_pools_lock);

The lock covers more than it has to. The pattern lookup is a linear
scan over all pools with a word by word compare per pool, and it runs
on every rule insertion that needs a modify header allocation. Those 
scans run in parallel today. Taking the mutex around the whole lookup 
serializes them on a single namespace wide lock, while only the 
create-if-missing step needs serializing.

Please keep the lookup out of the lock and re-check under it only on a
miss, roughly:
	pool = mlx5_fs_find_mh_pool(hws_pool, &pattern, &cnt);
	if (!pool) {
		mutex_lock(&hws_pool->mh_pools_lock);
		pool = mlx5_fs_find_mh_pool(hws_pool, &pattern, &cnt);
		if (!pool)
			pool = mlx5_fs_create_mh_pool(ns->dev, &pattern,
						      &hws_pool->mh_pools,
						      cnt);
		mutex_unlock(&hws_pool->mh_pools_lock);
		if (IS_ERR(pool))
			return PTR_ERR(pool);
	}

Thanks, Moshe.

>          known_pattern = false;
>          xa_for_each(&hws_pool->mh_pools, i, pool) {
>                  if (mlx5_fs_hws_mh_pool_match(pool, &pattern)) {
> @@ -1483,17 +1486,16 @@ static int mlx5_cmd_hws_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
>                  cnt++;
>          }
> 
> -       if (!known_pattern) {
> +       if (!known_pattern)
>                  pool = mlx5_fs_create_mh_pool(ns->dev, &pattern,
>                                                &hws_pool->mh_pools, cnt);
> -               if (IS_ERR(pool))
> -                       return PTR_ERR(pool);
> -       }
> +       mutex_unlock(&hws_pool->mh_pools_lock);
> +       if (IS_ERR(pool))
> +               return PTR_ERR(pool);
> +
>          mh_data = mlx5_fs_hws_mh_pool_acquire_mh(pool);
> -       if (IS_ERR(mh_data)) {
> -               err = PTR_ERR(mh_data);
> -               goto destroy_pool;
> -       }
> +       if (IS_ERR(mh_data))
> +               return PTR_ERR(mh_data);
>          hws_action = mh_data->bulk->hws_action;
>          mh_data->data = kmemdup(pattern.data, pattern.sz, GFP_KERNEL);
>          if (!mh_data->data) {
> @@ -1509,9 +1511,6 @@ static int mlx5_cmd_hws_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
> 
>   release_mh:
>          mlx5_fs_hws_mh_pool_release_mh(pool, mh_data);
> -destroy_pool:
> -       if (!known_pattern)
> -               mlx5_fs_destroy_mh_pool(pool, &hws_pool->mh_pools, cnt);
>          return err;
>   }
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
> index 20cdacd8f12e..ee37e2e6d68a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
> @@ -19,6 +19,7 @@ struct mlx5_fs_hws_actions_pool {
>          struct xarray el2tol3tnl_pools;
>          struct xarray el2tol2tnl_pools;
>          struct xarray mh_pools;
> +       struct mutex mh_pools_lock; /* serializes pool lookup and creation */
>          struct xarray table_dests;
>          struct xarray vport_vhca_dests;
>          struct xarray vport_dests;
> --
> 2.43.0
> 

