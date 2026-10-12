Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010017.outbound.protection.outlook.com [52.101.85.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F254BF947;
	Mon, 12 Oct 2026 18:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791828275; cv=fail; b=GhdeEcoArYv2copuvQI7hB3iYWg5IaLoKuPToCJGejUfmJtapDulqLBOfPOzQnCdNHIgQAyJf4m8KsJqoPldBX+dJvqJCkigYgxxt+AqOHBSHg5jlmuQrsi+CcrCOBemZc38t87tDr4mH/+X3aXdVOqPxdduts23w7aKCufHweA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791828275; c=relaxed/simple;
	bh=NTZtIOF7tlQXRZ9FXawlqbq2t/QZDWQ64U3iRHNbIFE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=TzQJ+NFniUr1AbM7CyHGQjfPD+Ina0XNgO6CC51FrPnDrO0UUcMCzEvTNGjF4/WJ/mx/m1CXUTVuPpyOAmz9pZZx1dYef/YYm4i3iG24NTuejaKY7w81lCN3UfZK4rMFMYIqzBdMqOBW7sd1Bn1heQdZTb0wy1ZRB5XG/0p3Z8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DdfHMd7E; arc=fail smtp.client-ip=52.101.85.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DdfHMd7E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lR0FUbh6omI2SNecqEufeokF4idt2hyIGHx9RcAXcBxYipJlcPVg0k9mF2DqEk7r76zvzRCRrbMA6YVZta1awx9gceyArF/rV7q1jj2L8Emu0zv9SdyA2oSfBJ33Q0LKuk+9jcKHJCSQAoJX+zRp6E3ohjPj4NeXfR/p4D6acwhnEkWTLxu+K7xlG1J9zcqSQXvKk8xyfiXd+IOZR6f8foYhhpCU1q9kV7BjaYBvPA3GQqEg9yl5G484t2SPeDDa7YNS/LqLPVfEHcGJOgOET7zYumAViTOzT7ioWJmpfg7pvEqvt6UG7TVh298mQkcN0rVBJ+IqWKAdpnQMhQcbbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Lm6vAm8+ntT6izqWMiYvnzJJdzXrnaCU2Hk36L3qtg=;
 b=IlB29vKbQG82h5KSPJsqdwH/srEQHVos5IpMWUOtCckms8SZpmoUNeIRY2kBDsGMDOlDSqif7+W5BP4gPUg9FOIEPNvbzlBk0ikPwXGtMEX4GAB2EiN/fWK5K8ZnB1QxoZuZ1YvW234Jd0BX1yqrZtZU+6VCcoU1bwE+kIZnkn3HpwjDCKKICYfXPDjB4vkoECjfmEMRH5J3brbcjV/4YOaJI/e6DIf6dZtqy737i2JMhqSAMyCkgwbXSTM18rN8rkRqHaZocZaz3xtLL+LoeixgpQxQGOboOIuE2VFs03ByfS381TaTH75KJQLse+Haphpiv6bjcX8LVuJsmj6Ycw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corp.free.fr smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Lm6vAm8+ntT6izqWMiYvnzJJdzXrnaCU2Hk36L3qtg=;
 b=DdfHMd7ErXL7cPo7iSduVPH7dJvxh4Yec2l9BQgFpLoG3wK0IY4mzYOCf5/0fRgT6CZPldyMrN99CjtspZ0WXvgqTvbieO6KiltNG0yoctxqevk5ez/iEHw/RQqT+Yg+YY3mpucFZdrzmW6jLJY5dmo6XmmkdXmA2HcBwW2LGPtW4H8uqEc1yRDMVGmmHf3rgLCahlQ1QkjxUMlyNLWZAM+fO53ng1KXlGUYnDCMQRgD0tXe9VMmHJ9NX9yGO14UOQ0lgm+W2BTcm0Yv4x/YU7tfOoUUtEbzMmJ843+a3sDnCfPIFdXnKDSNmD40haGf/hlSrlbsXfQxY8J5GYTd/A==
Received: from SJ0PR13CA0063.namprd13.prod.outlook.com (2603:10b6:a03:2c4::8)
 by DS0PR12MB7969.namprd12.prod.outlook.com (2603:10b6:8:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Mon, 12 Oct
 2026 18:04:24 +0000
Received: from SJ1PEPF000037A6.namprd04.prod.outlook.com
 (2603:10b6:a03:2c4:cafe::2a) by SJ0PR13CA0063.outlook.office365.com
 (2603:10b6:a03:2c4::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Mon, 12
 Oct 2026 18:04:23 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000037A6.mail.protection.outlook.com (10.167.244.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Mon, 12 Oct 2026 18:04:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 12 Oct
 2026 11:03:58 -0700
Received: from [10.221.200.227] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 12 Oct
 2026 11:03:54 -0700
Message-ID: <8a7eb7f1-dcc8-4ff3-a515-fed37fc37c9b@nvidia.com>
Date: Mon, 12 Oct 2026 21:03:51 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2 2/2] net/mlx5: HWS, fix modify header pool creation
 race
To: Alexandre Cassen <acassen@corp.free.fr>, Saeed Mahameed
	<saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>, <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <20261012100555.1317878-1-acassen@corp.free.fr>
 <20261012100555.1317878-3-acassen@corp.free.fr>
Content-Language: en-US
From: Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20261012100555.1317878-3-acassen@corp.free.fr>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037A6:EE_|DS0PR12MB7969:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e3c50f7-80c7-4486-eb34-08df288b3eb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|23010399003|82310400026|11063799006|261009223027099003|56012099006|4143699003|18002099003|22082099003|10067099003|41080700001|15866825006;
X-Microsoft-Antispam-Message-Info:
	9LwuKNT4e/rmCbN23XBiq2iaUKmevYCo5iuCW0W/hRwJiMuUJ53q9QPkcA1NVoXq6IdBpIWj+KRk+H+fsk6Nzr17LdNBNxma+UIVbEd9dRaACVhOcB4Ucnj18hAHwU7U+wgjD5Cj7Tp7PP1L9ZgnLz3QpVnI/pwDkrMJQVmjZdTKA2kj3+iGVadP6+3e0SACckzistly6rEQdKOQPqIjMIBvpEL9IPRlL3N2TvJNSjSNoIY+tXJn3dw5J7Uq17e7Zzm+TACUyAg65Cjw3UBH1uvhfk3aId+J48b7W+MOb0ei9C8y7stTKmMDpdNY1xqu/o44CFWtVh2O8j/7BYaBcn2BvdyML44TMCp5IK+UupVsK+ikwY7tQ4ZgOldLOAYyP+7f+oE6lzNkqgG9gLQkH2rpi31bKP89liFbPppkCkhYsVlNq5enX3PaJwIIGUmiTAzMzotIkFEtUKTNkTt7iqM46z8Ce8Y7InVqMGV95wjbLrQ+MCyz/95a2pDGv+IV2/LVV7+mY8sKNBXUNnz8i6Fcazgb7O5bX1i/kTv1Aas7G12mq/8Yf88pOO9j/js7nr/W39RzBdIvWnnNMybpMSljNrbQGLyv/vJ4vCqnZa5MEBDyweIHWfq83UpH8Pc0843h9R2pb05p+Vh1sm/nsIcv1Nt8bhtGC5IRdMRoLsD1AL8YXYsCOG108ME1yHresjMXZ3xuvH4zakh3AWvYI7Y8rkkCM9ImbFfjMERAL1ApDF6AWLZtCfusjIE7zIYMPl4HUXtPpaNzriB1GW3qxaJXSFqH4qby4Qil73w79c8=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(23010399003)(82310400026)(11063799006)(261009223027099003)(56012099006)(4143699003)(18002099003)(22082099003)(10067099003)(41080700001)(15866825006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XuqLGyBNyviMK7v+Xx95WQiuFJZQy8FFRwMvxL4XjLNsg9UegpbXxEXFmik+OY1hZu0gRQ6T4gktVraG6ujoLOWwyRrrxvJcptpS3PTz4BVivuVfvbjESILItb1PaPLy+KmeGA9hWjBCP/DX7o/km4Med7BOnMG7z5PoxcPD+bSa12A5uiEPnBxwoCsXCcnLM7UlFFOSwy7tkTMKPo5wXj0TgQ01byb5Cfayx6/le6mXrQEtzxaIw8GEU25dVu0E4bGTUXYQIznQRQarpusZHduYG+5Jrt0dGf3DWWkso1Gi1IlK+6s/5UWgmgcVrHrXkZ82tX4lRIPR6agsHtuEM2tefUN2F+UWMbGfj0BI2s+7usVjEzc2O6VTNVhU9BRDMnNQe7dFWoT3dH5JFCiImKYwVC/XmwNSaAEgWOCHjLvcod6BC+y+gTikXrG2QVYd
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2026 18:04:22.6095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e3c50f7-80c7-4486-eb34-08df288b3eb2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7969



On 10/12/2026 1:05 PM, Alexandre Cassen wrote:
> 
> mlx5_cmd_hws_modify_header_alloc() creates a pool at the index after
> the last one if no pool matches the pattern. TC and CT allocate modify
> headers concurrently, meaning two callers can take the same index and
> the second call fails with -EBUSY.
> 
> Its error path also destroys the pool it just created although another
> caller may already use it. Keep such a pool since cleanup releases it.
> 
> Pools now live until cleanup so the lookup needs no lock. A miss looks
> again under a mutex before creating the pool.
> 
> Tested for regressions on ConnectX-7 with firmware 28.48.1000.
> 
> Fixes: b36315ca69cb ("net/mlx5: fs, add HWS modify header API function")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Reviewed-by: Moshe Shemesh <moshe@nvidia.com>

Thanks.

> ---
>   .../mellanox/mlx5/core/steering/hws/fs_hws.c  | 53 +++++++++++--------
>   .../mellanox/mlx5/core/steering/hws/fs_hws.h  |  1 +
>   2 files changed, 33 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> index 66edb42268cb..11cced847186 100644
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
> @@ -1457,6 +1459,23 @@ mlx5_fs_destroy_mh_pool(struct mlx5_fs_pool *pool, struct xarray *mh_pools,
>          kfree(pool);
>   }
> 
> +static struct mlx5_fs_pool *
> +mlx5_fs_find_mh_pool(struct xarray *mh_pools,
> +                    struct mlx5hws_action_mh_pattern *pattern,
> +                    unsigned long *cnt)
> +{
> +       struct mlx5_fs_pool *pool;
> +       unsigned long i;
> +
> +       *cnt = 0;
> +       xa_for_each(mh_pools, i, pool) {
> +               if (mlx5_fs_hws_mh_pool_match(pool, pattern))
> +                       return pool;
> +               (*cnt)++;
> +       }
> +       return NULL;
> +}
> +
>   static int mlx5_cmd_hws_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
>                                              u8 namespace, u8 num_actions,
>                                              void *modify_actions,
> @@ -1467,33 +1486,28 @@ static int mlx5_cmd_hws_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
>          struct mlx5_fs_hws_mh *mh_data = NULL;
>          struct mlx5hws_action *hws_action;
>          struct mlx5_fs_pool *pool;
> -       unsigned long i, cnt = 0;
> -       bool known_pattern;
> +       unsigned long cnt;
>          int err;
> 
>          pattern.sz = MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto) * num_actions;
>          pattern.data = modify_actions;
> 
> -       known_pattern = false;
> -       xa_for_each(&hws_pool->mh_pools, i, pool) {
> -               if (mlx5_fs_hws_mh_pool_match(pool, &pattern)) {
> -                       known_pattern = true;
> -                       break;
> -               }
> -               cnt++;
> -       }
> -
> -       if (!known_pattern) {
> -               pool = mlx5_fs_create_mh_pool(ns->dev, &pattern,
> -                                             &hws_pool->mh_pools, cnt);
> +       pool = mlx5_fs_find_mh_pool(&hws_pool->mh_pools, &pattern, &cnt);
> +       if (!pool) {
> +               mutex_lock(&hws_pool->mh_pools_lock);
> +               pool = mlx5_fs_find_mh_pool(&hws_pool->mh_pools, &pattern,
> +                                           &cnt);
> +               if (!pool)
> +                       pool = mlx5_fs_create_mh_pool(ns->dev, &pattern,
> +                                                     &hws_pool->mh_pools, cnt);
> +               mutex_unlock(&hws_pool->mh_pools_lock);
>                  if (IS_ERR(pool))
>                          return PTR_ERR(pool);
>          }
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
> @@ -1509,9 +1523,6 @@ static int mlx5_cmd_hws_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
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
> index 20cdacd8f12e..cf068fb5bdbf 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
> @@ -19,6 +19,7 @@ struct mlx5_fs_hws_actions_pool {
>          struct xarray el2tol3tnl_pools;
>          struct xarray el2tol2tnl_pools;
>          struct xarray mh_pools;
> +       struct mutex mh_pools_lock; /* serializes pool creation */
>          struct xarray table_dests;
>          struct xarray vport_vhca_dests;
>          struct xarray vport_dests;
> --
> 2.43.0
> 

