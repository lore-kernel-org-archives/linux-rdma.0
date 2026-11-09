Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794248517;
	b=LnzgFHFNQa93IZN0uDhb97CkS3AK6BZKBvhOQjNwdrc1VkFeIQDlAX6KsYJ/NSjIi/Lh
	 cfp35XOQ78XDVLIWgL0ELMNChTMYFkVlQqljyWsi3V3AFyoEfbDRlyWgsT4ZbpLxAgKll
	 nRHWvWcOWwerbhD1BqDR+Xp4GELaKh8TmMSM0S2Z+P5b02/mjX3hUHkBTg3EBfNOLpDQl
	 /5psuuTkBwlP/wdEgfS/0g0EF4X/H5ihPAhy+rGol1y9M64MyeFyBcbyfDFqemLYGsTBi
	 AQrwuQTjI1BZ0obsqQD3Hpx7N5mScg1KIuR7/NXRzcdDtDTqzuSie7nAyOro7SafPzA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794248517;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ZaR8SaGdhadUkF2SI+dRP82Z39rJt70X4U4ibnL8ODQ=;
	b=XmVg9cIEKchDmmJwvbY+jH2H1ayzpdvTRqrF8PmywLRmW8PBXefQOXVp2M0uhvbptc6B
	 Y9tAs5q7rWJynDXqw+Mikps2JYGJvplg0+SYYj1nl4Ytw8ixdNlSHt0B0Z2ZcF+23ECcW
	 72LrU/MlHjQMPBQvErCKtih/HGrPCcHNkfNwCm23DxJsb3kAlWmrMX4d6Uf9Yzjd3Hd9U
	 iLePjE5YbPlTsuqGJtkhNgr385knMKXn7tvbi0ZRLY79ycvFuuOaR+aS6dKB8kGxYAJCQ
	 HFZfH8Q/lfxpiIWDTJE+EY2lA/gGvd/hmcb4lfN2i2wEBF6Is3X6nuIJ1GpGhKFb+4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pC4YBeU6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.20
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011020.outbound.protection.outlook.com [52.101.57.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E040606A31C;
	Mon,  9 Nov 2026 18:21:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E040606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pC4YBeU6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EF23cfPVUdZps5ot3wEaBNwXdzcJjSZOY0RM1iQhZ7rJYMWbIdPGYcEMy+f5xnyeDOwXo3QZ70eIC6nvnCqTfsQU+VS3BfOsCXEmQy4vAjav1IM/FjYgAsAmaEZTAu+WRHaemtFqMPfCOD2bL2PtAeEvWQZpflNqEGi27HUZfOqCxi6U6VGzm+4s+NvDF1GpGUUiWFuIKgwuOCAymdrG8Dkx60E4b5Xen+J+qvizkgUGGYz1FQo7pp502ZiuypmZ/Jw7KukrwUVWFIoCeAvDHlVpjp7Kel0yaFwEZ3Of/dCQ42IQlI/H66L/10L5SkVFVTVmMA2eR4hItemPdH8lOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaR8SaGdhadUkF2SI+dRP82Z39rJt70X4U4ibnL8ODQ=;
 b=m29nL5qaR5nZ5nVymwBPHxuLOv57By/w4Zve2A2grA6pKPuf8rA0dSullTGO3cXEDGfXv9eQj29hnHZbTm1CKREdfEQ4C2M5ZRM3lR0cTrnbZklhUzvgaw798iwIaB2Yfiz94flcYb5e+1YpFFEnhtATUqM8oaI2m0M0O16HtrX75Z7GGpV2klrdab2U/iIWHkP3Ff+n6D86J8Zp4rCnaNEDV3oC4PI4apkcisVu7fmNEBvdGM63/DqaA6zgG10qIBMI2NGEyGtkr1IdqcJ2l+3rWOVYiTzFUCchng6iAvWYa0tiIhru+l2YDs0GiBXodE6vUqdtfkvmlr4n6brCng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZaR8SaGdhadUkF2SI+dRP82Z39rJt70X4U4ibnL8ODQ=;
 b=pC4YBeU6Dw1dtqkIUggIuIgxDerSCe5rCDv1UKinlPOK5pMVKOqbsntl8K9JsaT2LGmjaNJrtNGlV+BYQHQ5p+yI736mM8mlRqbJW4ViPqO2/EuhQ3BR6znG/zu7rMeqE1u68tUpfde030p23twp+hK8LwyCvgcyKAYLhmSwbco3HNltTGyIC41l1DrByNQAx+DhTZROEF9HzmslN6CnW8701ALJm89p2FwVOks+fl48WkISdvxPAJAcnJCOl9YX3o2L/lqeU/D94RETsiX3Dl5eDGd27UsYn1kXjryyqNsRVMQiCzjAWcUps52kt9HbYJsd/jVH3aDjgywdXPpuyQ==
Received: from MN0PR05CA0029.namprd05.prod.outlook.com (2603:10b6:208:52c::23)
 by MW4PR12MB7144.namprd12.prod.outlook.com (2603:10b6:303:21b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 18:21:46 +0000
Received: from BN2PEPF0000A895.namprd04.prod.outlook.com
 (2603:10b6:208:52c:cafe::1c) by MN0PR05CA0029.outlook.office365.com
 (2603:10b6:208:52c::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.7 via Frontend Transport; Mon, 9
 Nov 2026 18:21:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A895.mail.protection.outlook.com (10.167.248.187) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 18:21:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 10:21:16 -0800
Received: from [10.221.197.41] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 10:21:08 -0800
Message-ID: <fa8bdce6-6f89-4de0-b81b-149ac20802a4@nvidia.com>
Date: Mon, 9 Nov 2026 20:21:04 +0200
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 05/15] net/mlx5: LAG, decouple iteration
 end-of-walk from MLX5_MAX_PORTS
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni
	<pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-6-tariqt@nvidia.com>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <20261103171009.563034-6-tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A895:EE_|MW4PR12MB7144:EE_
X-MS-Office365-Filtering-Correlation-Id: be4e88e4-5dd3-4a29-dc07-08df3e8e4eec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|36860700016|82310400026|4143699003|56012099006|261021123027099003|261021121427099003|261022075727099003|261022105027099003|261009223027099003|261028144727099003|261026140227099003|261026121527099003|11063799006|261102123227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	+Mr9Os8+lLosNuv/sYBD231YX+TQe/n6sw4OrwjrFAfP9z7Ag1hPeHGmvrWGUNOppp2BXEVfz0toisrvAx12EFaDXNB+nilr46OwCdzP8d9v/bDX0jp7XApZiqBrEU0zX7V7JmZPt4nD4f5ViT2PCL6+G9/MeqNOoKffpXR/65AeJIGPTJpO8ELaGc9ef52tlyDQO4huBeLHVeUBgLUmhv8P/rlRiGLWVH3UlRXaLxv5jfZE7u/7r6fajduyW2oRFpkFIV7QGa3ZMMqfzF2YvzvWND7ob/zZPdPAFOF7AFHlVKO9ACAR1RcCL+aYzc9WcAk3jMhv5eW2kK/ReaIoxv9dccRxtUj07/266Q5g3Ki2bJhiLeMenXeuRrkLDyrc7uKptbf8TGC1oN1Oyy2xVXMA1Yq0lf0I+5VoSgC6/wg2bf4EWvfOefLyW/qzha/qcFydLltRkOejl4Cqn2+dBpI6w8WAumVdhFWe0yPa8c/43bqK5Iv8CcZ4VVzifQvCUdMpAQ5JYtFvJ3wZ9zq/aE+a9l8idZTFhShnuokjdX66TLkZmGPh4zBFRwHDz6flRkrgzmsXr485pvNNf4QuuCtNCLlwSKXz8Z99vwvrDBDegHpiYVuY91yJewzgecFrze0p/d6iJzBgjQ/lJ2Oz+JV7IoWZgGZZlXaGC3FSu5uO2jVE7aj0sg0NNTFoAfLPAfOBzqQaqSZRzikguYENBA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(36860700016)(82310400026)(4143699003)(56012099006)(261021123027099003)(261021121427099003)(261022075727099003)(261022105027099003)(261009223027099003)(261028144727099003)(261026140227099003)(261026121527099003)(11063799006)(261102123227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SJyLZpJatfQxSj2v16Lkkp+LW8jY317NQMXZqGuRZv94797RE4tasV2sb6awqb+4CnWP7mA81+NBCcAU0ASWfrlhNWHK/YQ9oacZacF3feqXOBPufMRlZrRZ8/VTCL6HHsKi+W1yfyTKKklVaDUdikW8lSwLRuhtoQ4BY5UNce6f+BNR85GmQwcnGabhSL5SsO+b99olYg2SemXHJjUOIdjH+FMnC7VceOKP6NmkTpCBNi2ij5e/W1+MZQ1oOQnXgIg1I6ozU4sd1TJXych6D2znoLfMZuLOSnfUAmUETPrf5VG5BqKYdqTAAVuh+WpnXh75jaQmrB+tMQ9DY+UqHRz08UEqn8szwLcLISct9GQUDwzWOdZMfuo3iWvVwtFHIB7PcLstv5XRtfv34GZfrcUvFvIdC0LLiuviWOldM79FaagoyvrapSYAK0JDV7vx
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 18:21:43.8591
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be4e88e4-5dd3-4a29-dc07-08df3e8e4eec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A895.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7144



On 03/11/2026 19:09, Tariq Toukan wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> The LAG xarray iterators returned MLX5_MAX_PORTS as their end-of-walk
> sentinel, and the open-coded callers compared the current index against
> MLX5_MAX_PORTS to detect the end of iteration. This ties iteration to a
> compile-time maximum rather than to the actual number of LAG members.
> 
> Add ldev->max_funcs, and use it as the loop bound. Update the open-coded
> callers accordingly. When a member is added at an xarray index >=
> ldev->max_funcs, increase max_funcs.
> In addition, remove the xa_alloc() limit of MLX5_MAX_PORTS.
> 
> No functional change; this only removes the dependency on
> MLX5_MAX_PORTS.
> 
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>   .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 22 +++++++++++--------
>   .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  3 ++-
>   .../ethernet/mellanox/mlx5/core/lag/mpesw.c   |  2 +-
>   .../mellanox/mlx5/core/lag/shared_fdb.c       |  2 +-
>   4 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index b2ac5c671ae6..73bce918cddb 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -395,6 +395,7 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
>   		mlx5_core_err(dev, "Failed to init multipath lag err=%d\n",
>   			      err);
>   
> +	ldev->max_funcs = ldev->ports;
>   	return ldev;
>   
>   err_wq:
> @@ -1284,7 +1285,7 @@ static void mlx5_lag_assert_locked_transition(struct mlx5_lag *ldev, u32 filter)
>   	lockdep_assert_held(&ldev->lock);
>   
>   	i = mlx5_get_next_lag_func(ldev, 0, filter);
> -	if (i < MLX5_MAX_PORTS) {
> +	if (i < ldev->max_funcs) {
>   		pf = mlx5_lag_pf(ldev, i);
>   		if (filter == MLX5_LAG_FILTER_PORTS ||
>   		    filter == MLX5_LAG_FILTER_ALL)
> @@ -1831,7 +1832,7 @@ struct mlx5_devcom_comp_dev *mlx5_lag_get_devcom_comp(struct mlx5_lag *ldev)
>   	filter = ldev->virt_lag ? MLX5_LAG_FILTER_ALL :
>   		MLX5_LAG_FILTER_PORTS;
>   	i = mlx5_get_next_lag_func(ldev, 0, filter);
> -	if (i < MLX5_MAX_PORTS) {
> +	if (i < ldev->max_funcs) {
>   		pf = mlx5_lag_pf(ldev, i);
>   		devcom = pf->dev->priv.hca_devcom_comp;
>   	}
> @@ -2095,7 +2096,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
>   				break;
>   			}
>   		}
> -		if (i < MLX5_MAX_PORTS) {
> +		if (i < ldev->ports) {
>   			if (netif_is_bond_master(upper)) {
>   				slave = bond_slave_get_rcu(ndev_tmp);
>   				if (slave)
> @@ -2360,13 +2361,16 @@ int mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
>   	if (!pf)
>   		return -ENOMEM;
>   
> -	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, MLX5_MAX_PORTS - 1),
> +	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, U8_MAX - 1),
>   		       GFP_KERNEL);
>   	if (err) {
>   		kfree(pf);
>   		return err;
>   	}
>   
> +	/* max_funcs is the iteration ceiling; grow it, never shrink. */
> +	if (idx >= ldev->max_funcs)
> +		ldev->max_funcs = idx + 1;
>   	pf->idx = idx;
>   	pf->dev = dev;

answers to net-dev sashiko

Sashiko (Medium):
Is this store safe against readers that only hold lag_lock?
max_funcs is written here with a plain store, under ldev->lock only. The
store happens after xa_alloc() has already published pf, but before
pf->dev is set. mlx5_lag_get_next_peer_mdev(), mlx5_lag_get_slave_port()
and mlx5_lag_query_cong_counters() read it while holding only lag_lock.
Each walk reads max_funcs more than once:
- in mlx5_get_next_lag_func(), to produce the sentinel
- again in the mlx5_lag_for_each() condition
- and once more in mlx5_lag_get_next_peer_mdev(), after the loop
Suppose an add grows max_funcs from M to M + 1 between those reads. The
stale sentinel M then passes the tmp < (ldev)->max_funcs check. The body
runs on slot M, which holds the new pf, and pf->dev is not set yet.
Could mlx5_lag_get_next_peer_mdev() return a NULL peer here?
On weakly ordered CPUs, can the max_funcs store also become visible before
the xarray slot store? A reader could then see max_funcs == M + 1 while
mlx5_lag_pf(ldev, M) returns NULL. In that case this code in
mlx5_lag_get_next_peer_mdev() would dereference a NULL pf:
     pf = mlx5_lag_pf(ldev, idx);
     if (pf->dev != dev)
Before this patch, the sentinel and the comparison used the same constant,
so they could not disagree.
The later commit "net/mlx5: LAG, do not add a device to an already-active
LAG" narrows the window for callers that only walk while LAG is active.
These readers do not check for an active LAG themselves, though.

[SD] all the readers above running only while LAG is active, and
mlx5_lag_query_cong_counters() and mlx5_lag_get_slave_port() check
whether lag is active explicitly before walking over the lag


>   	pf->group_id = group_id;
> @@ -2395,7 +2399,7 @@ void mlx5_ldev_remove_mdev(struct mlx5_lag *ldev,
>   		if (pf->dev == dev)
>   			break;
>   	}
> -	if (i >= MLX5_MAX_PORTS)
> +	if (i >= ldev->max_funcs)
>   		return;
>   
>   	if (pf->port_change_nb.nb.notifier_call)
> @@ -2608,7 +2612,7 @@ int mlx5_get_next_lag_func(struct mlx5_lag *ldev, int start_idx, u32 filter)
>   					 MLX5_LAG_XA_MARK_PORT, start_idx)
>   			if (pf->dev)
>   				return idx;
> -		return MLX5_MAX_PORTS;
> +		return ldev->max_funcs;
>   	}
>   
>   	xa_for_each_start(&ldev->pfs, idx, pf, start_idx) {
> @@ -2618,7 +2622,7 @@ int mlx5_get_next_lag_func(struct mlx5_lag *ldev, int start_idx, u32 filter)
>   		    filter == pf->group_id)
>   			return idx;
>   	}
> -	return MLX5_MAX_PORTS;
> +	return ldev->max_funcs;
>   }
>   
>   bool mlx5_lag_is_roce(struct mlx5_core_dev *dev)
> @@ -2868,7 +2872,7 @@ struct mlx5_core_dev *mlx5_lag_get_next_peer_mdev(struct mlx5_core_dev *dev, int
>   	if (!ldev)
>   		goto unlock;
>   
> -	if (*i == MLX5_MAX_PORTS)
> +	if (*i == ldev->max_funcs)
>   		goto unlock;
>   	mlx5_lag_for_each(idx, *i, ldev, mlx5_lag_get_filter(ldev, dev)) {
>   		pf = mlx5_lag_pf(ldev, idx);
> @@ -2876,7 +2880,7 @@ struct mlx5_core_dev *mlx5_lag_get_next_peer_mdev(struct mlx5_core_dev *dev, int
>   			break;
>   	}
>   
> -	if (idx == MLX5_MAX_PORTS) {
> +	if (idx == ldev->max_funcs) {
>   		*i = idx;
>   		goto unlock;
>   	}
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
> index 872cc769297c..479d9f42ff3f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
> @@ -83,6 +83,7 @@ struct mlx5_lag {
>   	unsigned long		  mode_flags;
>   	unsigned long		  state_flags;
>   	u8			  ports;
> +	u8			  max_funcs;
>   	u8			  buckets;
>   	bool			  virt_lag;
>   	int			  mode_changes_in_progress;
> @@ -298,7 +299,7 @@ static inline bool mlx5_lag_is_supported(struct mlx5_core_dev *dev)
>   #define mlx5_lag_for_each(i, start_index, ldev, filter) \
>   	for (int tmp = start_index; \
>   	     tmp = mlx5_get_next_lag_func(ldev, tmp, filter), \
> -	     i = tmp, tmp < MLX5_MAX_PORTS; tmp++)
> +	     i = tmp, tmp < (ldev)->max_funcs; tmp++)
>   
>   #define mlx5_lag_for_each_reverse(i, start_index, end_index, ldev, filter) \
>   	for (int tmp = start_index, tmp1 = end_index; \
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> index b65ad9a26f71..56faa1d498c7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> @@ -223,7 +223,7 @@ void mlx5_mpesw_sd_devcoms_unlock(struct mlx5_lag *ldev)
>   	struct mlx5_devcom_comp_dev *sd_devcom;
>   	int i;
>   
> -	mlx5_ldev_for_each_reverse(i, MLX5_MAX_PORTS, 0, ldev) {
> +	mlx5_ldev_for_each_reverse(i, ldev->max_funcs, 0, ldev) {
>   		sd_devcom = mlx5_sd_get_devcom(mlx5_lag_pf(ldev, i)->dev);
>   		if (sd_devcom)
>   			mlx5_devcom_comp_unlock(sd_devcom);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
> index 7c7e6c832a93..29048b0c2797 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
> @@ -71,7 +71,7 @@ static int mlx5_lag_create_single_fdb_filter(struct mlx5_lag *ldev, u32 filter)
>   
>   		err = mlx5_eswitch_offloads_single_fdb_add_one(master_esw,
>   							       slave_esw,
> -							       ldev->ports);
> +							       ldev->max_funcs);


Sashiko (Medium):
The commit message says:
     No functional change; this only removes the dependency on
     MLX5_MAX_PORTS.
Is that accurate? This hunk changes the max_slaves argument from
ldev->ports to ldev->max_funcs, and that argument sizes the master's
egress ACL. A later commit in the series, "net/mlx5: E-switch, drop
master egress rule under a SW vport LAG", calls this value the ACL size.
So the size of the hardware flow table changes whenever max_funcs !=
ports.

[SD] Only the ACL size changes, and only for SD, where more PFs than
ports join the ldev and max_funcs > ports. The rules installed are the
same as before, so there is no functional change.


The patch also changes behaviour in two other places:
- The xa_alloc() limit in mlx5_ldev_add_mdev() now accepts a 9th member.
- The found check in mlx5_handle_changeupper_event() now uses
   i < ldev->ports instead of the max_funcs sentinel.
Could the commit message describe these changes?

[SD] The xa_alloc() change is already in the commit message ("remove the
xa_alloc() limit of MLX5_MAX_PORTS"), and the cover letter explains why
it can't let in a 9th member.
mlx5_handle_changeupper_event() runs only for a PF LAG without SD: the
netdev notifier is registered only when !mlx5_sd_is_supported(). There
each LAG port is one PF at an xarray index below ldev->ports
(num_lag_ports), so "i < ldev->ports" is true in exactly the same cases
as the old end-of-walk check.


>   		if (err)
>   			goto err;
>   	}

