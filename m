Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.23
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794249109;
	b=pDXJCFI4FpAqBd6vkb7c0Te5IP4H/5A0UXbLk6cZmY5uzYtjobBca5hgHT0X3z9CnueP
	 oVC9AShUu4psvV0hauapEOuyBKfVNsqRvfuI9JlxZtWoZzd+C8d9AHqpCyFejrhQBLE68
	 cY1d5GMgAR/Bd/eaUJyS24lK9T3Y8/GxO3Wo+a3xyo/ptL0Ns1iLK98tNf7lE2GCRsJ+x
	 IirZk6bk2DlgZK1IQfQbpzindAEmBjYnB0A6q+Ybmh74pWMoJVsBFn6x2M7ReTvca3ciF
	 evLB/FRLyiBM7UEYY4U5TmmpsWmfX+vDH5K7Txe+bJ8768LR/LGWGMbPVQrSepWyTig==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794249109;
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
	bh=Phq5SwoDigGOZkjtYLB7SD/VZKgvUkSAOzM8080ST5A=;
	b=cuEld83ippj6P9PzZaRrxNuxGNPwr8bhXi6ui8+pQBOtvlWjmjps+LMkvEEBb36jPYJ9
	 u8GgAGHWw10IWgnQcCRI3dUYPzwi+RlXIckvDrxCr8jHJjTV0FfS/8eoWxiZu3xYM5Wxs
	 uXDOH+kLYHgc2qkmDSXPi85p3eiUZah0FM3FvnFd43nOP7jlNjG8WaG+FMWOCW3E3xJDO
	 0AXJzMGzsWqGz9wjVWqi9dvQcpHWimAhdXBSSl4NhbZMbtkQLtzIK2nXOsGCMeq7rzpqp
	 eml2tzhh6BC61Oi+ItypxphyeCcoTiB5kQzJyAifVygFxe+SWod2fiSDV87K5kQVd7A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZoEeYRxk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.23
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013023.outbound.protection.outlook.com [40.93.196.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A095606A32A;
	Mon,  9 Nov 2026 18:31:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A095606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZoEeYRxk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ajMSLLt3O+/Ea6xpk+xUx3D55wcUZa4xzwyomM1R+zJpY6MSnwszWq/jZQ8TXNnKRo03+K2VAwb/SUELssuTWTCt8oQ0/Yma8wKTFFChPTiThI4AYOxDjFgaEgYBQw4JjQiDbjDdG5+oWfsOJkhP1lKnK5f7YpzuFW1RJI7WsuPFTT/8McgtxomMKK3z7Quxqjd2vMC9C34DTSUhzE9KGpHdIPsMUzgrGgu0OTpO15U6Yj+kpwBv4lL228MDJxcqupXlBbJJ8BsJoOtKuDae9+gjnHlEdECamJIf17yTxfiTquj7FncJtEm7kxIUZkVS8jLNYgYAtUVBM0lulrs8Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Phq5SwoDigGOZkjtYLB7SD/VZKgvUkSAOzM8080ST5A=;
 b=yYMc7/9RoeruMI8/DO+vffVwpC23Rk3y/Dc7F2GfpVQR457UL52B0oJlYqhM8TCrmZKg/p5zAm1dB0CIm2yYQVdni4UIFoVjuR6057HMbzna5I3MzGvKi3CWGxDYDCyIkCQvbKExhov0xo9wMbGouOcVASLMErJ+aoR/NiYqRO2VUrgZtwJNOBBVra4Uzc7dtrTnlyYuYPJaC8hjleqHgNDLQMciqysMf9pOBunGqZCtkWuiX3vn0Nj+SvQWba2d5tHqJ2DtDYLaxZf0WTvtmu/wI9Xb421f9rELsd9IVXezUFFrN6xiY4XMf1/ern0Oi79LElrRQxgDu48YxAy5fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Phq5SwoDigGOZkjtYLB7SD/VZKgvUkSAOzM8080ST5A=;
 b=ZoEeYRxkxW+gSFLuNJwqKVjRKcEbgTMhAu4gB7DwXO4ettwggz62qzAAxAKC4DeqU+ri/2Luz6uNzVtV2ockSy4MZgO/IEb7QFWxi3LZTDujbuSBmDuOOQngd4qtaYJ7De2+WaNddVfeXdfp56Fpm/e2oYYMTCL0Cp29+ik18EIxGO/nY8UWzg88W7waL1M7iMzhMvfmHcFNRFNYkDC97D1nkCJbK/yBgW6N6+IOtQWbr29xZGt14Y4ds1qRUnH5RS9HPmzQ5sY2RgrmbDhzGZrrpCM4pE3D2/dgNKkHc72njVeok2648xRbVy+Vb0bfUbjUTvmdibTPKgzF0SWeYw==
Received: from MN2PR01CA0052.prod.exchangelabs.com (2603:10b6:208:23f::21) by
 IA4PR12MB187965.namprd12.prod.outlook.com (2603:10b6:207:105::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 18:31:45 +0000
Received: from BN3PEPF00022BC8.namprd05.prod.outlook.com
 (2603:10b6:208:23f:cafe::9f) by MN2PR01CA0052.outlook.office365.com
 (2603:10b6:208:23f::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Mon, 9
 Nov 2026 18:31:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF00022BC8.mail.protection.outlook.com (10.167.248.214) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 18:31:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 10:31:13 -0800
Received: from [10.221.197.41] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 10:31:04 -0800
Message-ID: <8a521a4d-2b05-4c9a-a8d7-ddd0ea465f81@nvidia.com>
Date: Mon, 9 Nov 2026 20:31:01 +0200
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
Subject: Re: [PATCH net-next 10/15] net/mlx5: LAG, do not add a device to an
 already-active LAG
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
 <20261103171009.563034-11-tariqt@nvidia.com>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <20261103171009.563034-11-tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC8:EE_|IA4PR12MB187965:EE_
X-MS-Office365-Filtering-Correlation-Id: 97ffab8a-7450-40ac-d079-08df3e8fb548
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|5023799004|11063799006|4143699003|261022105027099003|56012099006|261021121427099003|261022075727099003|261022113327099003|261026140227099003|261028144727099003|261026121527099003|261009223027099003|261102123227099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	x6FDnAfVmKUNRX1D/wmLjXQ1wV6vH3m587uSwNr2L7Eu7GYO1/WBse+6/mogBLiR40W5zfEZ84u60y64/Mbh3ymbRW/rNALqss/hyCk7i5UvHv6bddY74fA/pdyP19eUujBTtEmhtEvXAInXZmx6XBkQlRmVS7SillFvrBFfdv0qhXChix2qvU6/2PxWXY9iIdbUjQasQAhkK69CziIn3n9FrM3MEBy/61hagdulpvZDvEzntI5tiB7RJKPyELjg5+UhPWVlZn+ot1ft4EmGFgIbQcA9dOglnBGmjjL6ir3WrvfjZk6VmQNRs98gdOZj60vUtzA4D/1GZAqlC1QQxB31rcVz4yj+IocyCJTppthmTzQbSiAQ/MNoTl3kxDwRRmlCdnxcyPp2/Odycq9EH3l1C7sXMC/mxfiMvLmcm3sedLtt+iPWWYxXL+BQfqBHsB+evmcB3vbLHYxJ2u88W9R/IpGmGDUZakKUEDsprhEnj7G4s8Cc+JWsac2tTwZlYhwnzzPXTZfsa13JcnSP1eQKfqkpNV8ODhB9h8oYL/jPCSSV9xKqO2zC4c/JY/e3XWAxR0lHUggDW5bcjum/xlvrS7eKui0g4fp6+jlCii5QPP40dCbIkbXWO2jttRA8cGNceaFo30woxTD72WdaGQSw3dIuQnZL7wGh9HJFH4bar02JrfPZnpg/VrVt0KYZknVfd/jRD/eC24FoVsaulA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(5023799004)(11063799006)(4143699003)(261022105027099003)(56012099006)(261021121427099003)(261022075727099003)(261022113327099003)(261026140227099003)(261028144727099003)(261026121527099003)(261009223027099003)(261102123227099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	H4+JgnNJ4fMq5zMyL/DcXpZOY1ftZeTnhPS20uu/S2RoXjU74c9vsPhYFe4EVYHqdXwJ6UOQSNuC4slXASDx5vYgdnsI5eclm2d1OFaHXyZeK85Pa5Jorf57yiGK9DhNtw0llFMNCkIgAniCq50agVQdRV+R+bJlBvNZfcAe7JAE7I4mG+0Jm2Ve/5n1CYlV3ptbdKR9uCc2LPAU/2M7aJhpCxwmuKcqmp0a09nGMmmooU2zpDyhLB5r7YwO2V8ihMv+dd2O4XwZXlE2e2V4WlPJbXBBNXWg166liSct7Ql9IqHtLKiANJy2uXa56kE+CoZTiGfuKkuyvP8hUoBXIbsDZa/gHGLTgGyrlk+0vwHgka9ds+liowaKFwpe9GrMTFE9KgzAvvURLKgW9SeowMM1Kh68h3UI5BDbDfpCoRJTFOWdPOvoU9cvSWlfyLQc
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 18:31:45.0629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ffab8a-7450-40ac-d079-08df3e8fb548
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB187965



On 03/11/2026 19:10, Tariq Toukan wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> mlx5_ldev_add_mdev() would add a newly probed device to the LAG even
> when the LAG is already active, mutating membership while getters may be
> iterating it and while the active mapping assumes a fixed member set.
> 
> Reject the join when the group's LAG is active:
> __mlx5_lag_dev_add_mdev() returns -EOPNOTSUPP, and mlx5_lag_add_mdev()
> treats that as terminal - unregister the HCA devcom component and leave
> the device standalone, rather than the -EAGAIN retry used for the
> bounded mode-change window.
> The device stays out of the LAG until it is reprobed.
> 
> This keeps LAG membership stable while active. It is a no-op for
> existing configurations, where no device is added to a LAG once it is
> active.
> 

answers to net-dev sashiko

Sashiko (Low):
This isn't a bug, but the commit message describes a broader rule than
the code implements. The subject says "do not add a device to an
already-active LAG", and the body says:
   "Reject the join when the group's LAG is active"
   "This keeps LAG membership stable while active."
The check here only fires when mlx5_virt_lag_is_supported(dev) is true,
which means multi_uplink_eswitch and lag_master are set and
num_lag_ports < 2. A device that is not virt LAG capable can still join
an active ldev through this path.
sd_lag_init() in lib/sd.c, the other caller of mlx5_ldev_add_mdev(),
also adds SD secondaries to the primary's ldev without checking
__mlx5_lag_is_active():
     err = mlx5_ldev_add_mdev(ldev, pos, sd->group_id);
Could the commit message say that the rejection applies only to virt
LAG capable functions, or explain why the other join paths are safe?

[SD] The other join paths are safe. A LAG of PFs is activated only
once all the PFs of the card are members, so there is no further PF that
could join it, and SD secondaries join at load, before MPESW can be
enabled. A LAG of VFs/SFs is the only one whose members come and go
independently of the activation, which is why the check is for virt LAG
capable functions only.

In case of v2, The commit message will be fixed.


> In addition, do not register the eswitch devcom component of such a
> device, so it does not pair with the eswitches of the LAG members.
> 
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>   .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 4 ++++
>   drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c        | 9 +++++++++
>   drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h        | 5 +++++
>   3 files changed, 18 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index c712848b202d..70e6dd9561a6 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -3573,6 +3573,10 @@ void mlx5_esw_offloads_devcom_init(struct mlx5_eswitch *esw,
>   	xa_init(&esw->offloads.peer_flows);
>   	mutex_init(&esw->offloads.peer_mutex);
>   
> +	/* do not pair a virt LAG capable VF/SF that is not part of a LAG */
> +	if (!mlx5_core_is_pf(esw->dev) && mlx5_virt_lag_nonmember(esw->dev))
> +		return;
> +
>   	if (!MLX5_CAP_ESW(esw->dev, merged_eswitch))
>   		return;
>   
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 9bc4a929cef3..d73bac8441f7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -2449,6 +2449,11 @@ static int __mlx5_lag_dev_add_mdev(struct mlx5_core_dev *dev)
>   		mutex_unlock(&ldev->lock);
>   		return -EAGAIN;
>   	}
> +
> +	if (mlx5_virt_lag_is_supported(dev) && __mlx5_lag_is_active(ldev)) {
> +		mutex_unlock(&ldev->lock);
> +		return -EOPNOTSUPP;
> +	}
>   	mlx5_ldev_get(ldev);
>   	err = mlx5_ldev_add_mdev(ldev, dev, 0);
>   	if (err) {
> @@ -2537,6 +2542,10 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
>   	err = __mlx5_lag_dev_add_mdev(dev);
>   	mlx5_devcom_comp_unlock(dev->priv.hca_devcom_comp);
>   
> +	if (err == -EOPNOTSUPP) {
> +		mlx5_lag_unregister_hca_devcom_comp(dev);
> +		return;
> +	}
>   	if (err) {
>   		msleep(100);
>   		goto recheck;


Sashiko (Medium):
After this change only -EOPNOTSUPP is final. Every other error from
__mlx5_lag_dev_add_mdev() is retried with no limit. Can this loop
forever on an error that waiting will not clear?
__mlx5_lag_dev_add_mdev() returns the mlx5_ldev_add_mdev() error
unchanged, and mlx5_ldev_add_mdev() does:
     err = xa_alloc(&ldev->fns, &idx, fn, XA_LIMIT(0, U8_MAX - 1),
                GFP_KERNEL);
     if (err) {
         kfree(fn);
         return err;
     }
xa_alloc() returns -EBUSY once all 255 slots are in use. Two earlier
commits in this series make that reachable:
   "net/mlx5: LAG, decouple iteration end-of-walk from MLX5_MAX_PORTS"
   raised the limit from MLX5_MAX_PORTS - 1.
   "net/mlx5: LAG, enable LAG over functions that do not represent a
   physical port" lets virt LAG capable VFs and SFs join.
mlx5_sw_guid_sf() and mlx5_sw_guid_vf() return a constant marker. So
all such SFs (and likewise all such VFs) on the same HW share one
devcom key, and they end up in the same ldev when they share a netns.
With 255 members already present and the LAG inactive, the next probe
would see:
   mlx5_load()
     mlx5_lag_add_mdev()
       __mlx5_lag_dev_add_mdev()
         mlx5_ldev_add_mdev()
           xa_alloc() returns -EBUSY
       msleep(100); goto recheck;
Membership does not change while it waits, so mlx5_load() would never
return. Because the thread sleeps in 100ms steps, the hung task detector
would not report it, and unbinding that device would block behind the
probe thread. The final state of the series still has this loop.
It is not clear whether firmware actually exposes that many virt LAG
capable functions in one group. Would it make sense to retry only on
-EAGAIN and give up on other errors?

[SD] This is pre-existing: mlx5_lag_add_mdev() retried every error
before this series as well. for example future HW can return -EBUSY.
The fix will be sent as a separate patch.


> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
> index cbe380ae8bf9..385c767e24ae 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
> @@ -280,6 +280,11 @@ static inline bool mlx5_virt_lag_is_supported(const struct mlx5_core_dev *dev)
>   	return true;
>   }
>   
> +static inline bool mlx5_virt_lag_nonmember(struct mlx5_core_dev *dev)
> +{
> +	return mlx5_virt_lag_is_supported(dev) && !mlx5_lag_dev(dev);
> +}
> +
>   static inline bool mlx5_lag_is_supported(struct mlx5_core_dev *dev)
>   {
>   	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||

