Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793725965;
	b=d1F+cCYS1MU0AW60jWoYBZRWwu8rN/wI1XuMxbBs9jATU43wBPgl6+jF8ocEtgWd+1bs
	 JXJQBYEUwKEgPyyjbtV37bOVW/JzcwCUaucEnSD1ihb/TjfHqMlshD/S2I0Q0WvJkkvwu
	 8gq1SaqJJnJ1zX6lq5tNGD5ang98gFqpEWLCuAZqlQZEHASWVVT/p63ZhrNYuJGP+9i8J
	 KhRILGcpHiOn/l+5mpKJSFwBGKSetm/yeTOV1oZbGvLxkg8JLFg3L7ar9JDrkQY15pBlY
	 dTxZZr+7dOV3ksuzFaSILmSVdDmQdSrSiRlRah6Z6Er6nkSWnUos/FjctXFNC7u69og==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725965;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=6LLo0pZd0NKZKZMXUHRnq8SWmfPWZ9l12FaTTuAElbs=;
	b=WXC6mhxsc32aCo8F7Igj/CRBKiZZ28ZZ/ZVWounjJumi9iUBzuNAraT7YyeLa54tAotU
	 DFOpA80yv47JpzkrRkvPeUp8Fm6IwpfkKSdhd68zyOE22ZGvilDj15XApZMPuDkVA5zry
	 wo9v6jkLhWxmxH9ad1MEgAuoN8Tt5K7UwNt6QpNBt5BzRMlCKYEoavJ7BLhJBfFa9FdbJ
	 7X2q6AeZuDE+PFRvvOrfp/IBoZjNINTiCaszvrjcpdzHsW//WPmqLUOhgnyi9hFjcF1aM
	 dFVNjsIpL+WadAGRnfvjUwP3hZQVwtfe+GbJxR9ZfQrLtqTRlxZVVQme/khfbXz0yyA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WTSCNeta;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.58
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013058.outbound.protection.outlook.com [40.107.201.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE46606A33B;
	Tue,  3 Nov 2026 17:12:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDE46606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WTSCNeta
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ntBGN0sxUhijaVL74yCc2Lhte9GGpN71Rw+4E/H3L6LohmtXodaG+vBquyerdZObW7W6zIoSTTOgVnhlxUDCQB8SGUaewiTm7i+mFAwDZxwkroN5cnJRhSr/7Sxyo25pXU1j7BSZARAVkbyZKyO7ZOc4BhZFJCXExRmcfhKkuztOKChIb/XqMY80o0DgE/kUvIgC9uyiRAzNbs2x6jWAgeldTxM5gbQLKrcU5iokIpQU87pHhFOYaQDprZE1IhvuOgg4sYI57rqW23UYNxz6bVqxOaxnqDNDKGx/6tErWa0jrgevs+Bvpfwj8FH4XNq5Y1IQfCbCi6eejzG3yIpGJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6LLo0pZd0NKZKZMXUHRnq8SWmfPWZ9l12FaTTuAElbs=;
 b=EA7KQVeuR60nxTeQ2rH7SGehGJeJwHn3fH7Ico0rsM3vE1nkOI8P9vDiaccVMd9B6mLMfsPO+iT++mZVxuYVM14uHCy6FvbLaTgO3ktbbp8yEWVsAmkWBD0NLS4AZCDNnP9AQDKzBEvK3ECS2yyDvQYB4sEj49vA7zSFN/2zyPiRUhHwv8tzDqH47M53t3RBSUStrsd4Mi74f2b0HWGtPU9wM/p8pbE+6NsRLS5XMB7IfiPlMhO1VeJrpk/0kIycu8zlpn5OqaD0zbLuYItRNIaXpSbzethpiRZtmaehASGzV/B9S6mZ52HMzMTysZO1xm9/VIhoSlLEj4p5vDJ1RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LLo0pZd0NKZKZMXUHRnq8SWmfPWZ9l12FaTTuAElbs=;
 b=WTSCNetapo+GcgQc4BGeXewG+Y206FgYXUrsmFmyvoUaoWyM5V13IfaeUoDC1H3U8NHP21zp7E/8CtqXtE3E4+1kJ7AQCie6H+30ChpmDAjE+t6+Pc+hFTbfy2yp18VqP0vP8jouUAmdluCG1Tf5Z8ITuNDNlBISOEa8f2hUeld8xWRw0I4rI70OKfpF6Rg7Wd3R0EXH8TjWu4cTsSBaKYh5IyuXV9JJAYmg0gGFee4Vggxv5n9fkzQpPyyqS7qPwvCKJlUPQUWh9Gz2B4gjYkUo3ns0yr+aOdzP/KrQmSNC6qH0xo0Ryj0g/zQL0zxH7ARNKO9H176OcBDOHTjj6g==
Received: from DM6PR06CA0082.namprd06.prod.outlook.com (2603:10b6:5:336::15)
 by DS6PR12MB786665.namprd12.prod.outlook.com (2603:10b6:8:4c1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 17:12:39 +0000
Received: from DM3PEPF000265AD.namprd02.prod.outlook.com
 (2603:10b6:5:336:cafe::5e) by DM6PR06CA0082.outlook.office365.com
 (2603:10b6:5:336::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 17:12:39 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM3PEPF000265AD.mail.protection.outlook.com (10.167.23.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 17:12:38 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 09:12:17 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:12:14 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 09:12:09 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 05/15] net/mlx5: LAG, decouple iteration end-of-walk from MLX5_MAX_PORTS
Date: Tue, 3 Nov 2026 19:09:59 +0200
Message-ID: <20261103171009.563034-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261103171009.563034-1-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PEPF000265AD:EE_|DS6PR12MB786665:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fd8bd04-610b-424f-a7d9-08df39cda9d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|82310400026|36860700016|261021123027099003|11063799006|261009223027099003|261028144727099003|261022105027099003|261102123227099003|261021121427099003|261026140227099003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Dg+x2j94hSx/YU2PkXqTYHHqfmUfyEqnabcw5fW1nJOAM0Sn2V8wKLIf1/saSRJ6EYI4f0y+M/lQYfL7cTeGK0v4ecR8V66l0qdHtuCriQlKAN6byiQkfazpnh59XDl98Iqzw+sbhJNxiFyZsGzwoXV+ptSiZkgLIwUMA8KV/N7v9BKIGy3vdwtgDv4Wfb49fAeKra+Geb8azjIZzUgKSnWbGFSZfQnCrLdTXwQ50cLf7ZDI5RCxNOakp0fxB9s7nuiFCQZkycgV56QXAZrtfCuUyvdMC5EkLpgSbETNBDOr+BwuT0BDEKWuRUfU8LDDaDCe27pk/FT/kWmAl3HmmchK/f1qH1t7qk7YE9GUsbdilE6XL5w5v0Jb7XVaA5oN1OI394dGbJHkUIqwpSuXcZFO+xo63UkzJUvnKyAC71rM+GAqu8aFF+HCjgoG2heyuAqe2ox/JPIYqIT6ZK3vKd9W0ZJowhSZ06RLpJZ7VHNcQOFrJezM4M5ehQ4x0M92yJQRNLUlMNCltnVKvz/Tdup+GFOhh7vOsIVoMHfgGmPoxA5WL5ifFQSQkHlKSWSW6Dnr0qfm8V6CI9lMRD5mEGEgGUB3C8RsUPF08Q+YtpZHLjr4BdCReuN7bYEdeUKrQjBrkYSJhL3pw1wH4lACk7SqmnqLbIsfmyit+6rwjOwooMORLaZyslIFXDG/Qbl6pd3p8UIvXKANOtPLXihjeA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(82310400026)(36860700016)(261021123027099003)(11063799006)(261009223027099003)(261028144727099003)(261022105027099003)(261102123227099003)(261021121427099003)(261026140227099003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ch9ZoK/uwfycwzkT+Y1npQ9wR7g7QjQULbeVa/zV+V/B+7pPVuSbVbr3m57O0rxHj/IIof4krB4N8NBQwz5GKv9vJt2+OrR6hMQungqdeIW3GtmHgJ7nNDimlYLduy4SdEz4uyN8sna4F9jbsECPYPZkUPqh+0P211QOfNZ4vVXJKI8maZNRKrKqDHNZLDy4APEsUAL7HGI5eBFlnw6HvZuiPAceCXVjjC3RWR7B7R0sR2BjWjbjACySIsBwa8HKJXoKir7gYOcexujMuvCn+zlx/jbJkpDxRNOZOPPKznD5qpAT/9XA7S4yQnhCbM5H3QkQFzn4QMtdzM2mHDVoSRNW2N1FAAQNN5JOFpE8CUSFOMnRgG98Ik3WCJflMGFUYwyi3p1qvM6c1AxBV3HJ8vfpZnSGnB6epFQQJoQYIcAPwlF30lNKvVlx2lMRdHgo
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:12:38.8983
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd8bd04-610b-424f-a7d9-08df39cda9d5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265AD.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB786665

From: Shay Drory <shayd@nvidia.com>

The LAG xarray iterators returned MLX5_MAX_PORTS as their end-of-walk
sentinel, and the open-coded callers compared the current index against
MLX5_MAX_PORTS to detect the end of iteration. This ties iteration to a
compile-time maximum rather than to the actual number of LAG members.

Add ldev->max_funcs, and use it as the loop bound. Update the open-coded
callers accordingly. When a member is added at an xarray index >=
ldev->max_funcs, increase max_funcs.
In addition, remove the xa_alloc() limit of MLX5_MAX_PORTS.

No functional change; this only removes the dependency on
MLX5_MAX_PORTS.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 22 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  3 ++-
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   |  2 +-
 .../mellanox/mlx5/core/lag/shared_fdb.c       |  2 +-
 4 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index b2ac5c671ae6..73bce918cddb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -395,6 +395,7 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 		mlx5_core_err(dev, "Failed to init multipath lag err=%d\n",
 			      err);
 
+	ldev->max_funcs = ldev->ports;
 	return ldev;
 
 err_wq:
@@ -1284,7 +1285,7 @@ static void mlx5_lag_assert_locked_transition(struct mlx5_lag *ldev, u32 filter)
 	lockdep_assert_held(&ldev->lock);
 
 	i = mlx5_get_next_lag_func(ldev, 0, filter);
-	if (i < MLX5_MAX_PORTS) {
+	if (i < ldev->max_funcs) {
 		pf = mlx5_lag_pf(ldev, i);
 		if (filter == MLX5_LAG_FILTER_PORTS ||
 		    filter == MLX5_LAG_FILTER_ALL)
@@ -1831,7 +1832,7 @@ struct mlx5_devcom_comp_dev *mlx5_lag_get_devcom_comp(struct mlx5_lag *ldev)
 	filter = ldev->virt_lag ? MLX5_LAG_FILTER_ALL :
 		MLX5_LAG_FILTER_PORTS;
 	i = mlx5_get_next_lag_func(ldev, 0, filter);
-	if (i < MLX5_MAX_PORTS) {
+	if (i < ldev->max_funcs) {
 		pf = mlx5_lag_pf(ldev, i);
 		devcom = pf->dev->priv.hca_devcom_comp;
 	}
@@ -2095,7 +2096,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 				break;
 			}
 		}
-		if (i < MLX5_MAX_PORTS) {
+		if (i < ldev->ports) {
 			if (netif_is_bond_master(upper)) {
 				slave = bond_slave_get_rcu(ndev_tmp);
 				if (slave)
@@ -2360,13 +2361,16 @@ int mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
 	if (!pf)
 		return -ENOMEM;
 
-	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, MLX5_MAX_PORTS - 1),
+	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, U8_MAX - 1),
 		       GFP_KERNEL);
 	if (err) {
 		kfree(pf);
 		return err;
 	}
 
+	/* max_funcs is the iteration ceiling; grow it, never shrink. */
+	if (idx >= ldev->max_funcs)
+		ldev->max_funcs = idx + 1;
 	pf->idx = idx;
 	pf->dev = dev;
 	pf->group_id = group_id;
@@ -2395,7 +2399,7 @@ void mlx5_ldev_remove_mdev(struct mlx5_lag *ldev,
 		if (pf->dev == dev)
 			break;
 	}
-	if (i >= MLX5_MAX_PORTS)
+	if (i >= ldev->max_funcs)
 		return;
 
 	if (pf->port_change_nb.nb.notifier_call)
@@ -2608,7 +2612,7 @@ int mlx5_get_next_lag_func(struct mlx5_lag *ldev, int start_idx, u32 filter)
 					 MLX5_LAG_XA_MARK_PORT, start_idx)
 			if (pf->dev)
 				return idx;
-		return MLX5_MAX_PORTS;
+		return ldev->max_funcs;
 	}
 
 	xa_for_each_start(&ldev->pfs, idx, pf, start_idx) {
@@ -2618,7 +2622,7 @@ int mlx5_get_next_lag_func(struct mlx5_lag *ldev, int start_idx, u32 filter)
 		    filter == pf->group_id)
 			return idx;
 	}
-	return MLX5_MAX_PORTS;
+	return ldev->max_funcs;
 }
 
 bool mlx5_lag_is_roce(struct mlx5_core_dev *dev)
@@ -2868,7 +2872,7 @@ struct mlx5_core_dev *mlx5_lag_get_next_peer_mdev(struct mlx5_core_dev *dev, int
 	if (!ldev)
 		goto unlock;
 
-	if (*i == MLX5_MAX_PORTS)
+	if (*i == ldev->max_funcs)
 		goto unlock;
 	mlx5_lag_for_each(idx, *i, ldev, mlx5_lag_get_filter(ldev, dev)) {
 		pf = mlx5_lag_pf(ldev, idx);
@@ -2876,7 +2880,7 @@ struct mlx5_core_dev *mlx5_lag_get_next_peer_mdev(struct mlx5_core_dev *dev, int
 			break;
 	}
 
-	if (idx == MLX5_MAX_PORTS) {
+	if (idx == ldev->max_funcs) {
 		*i = idx;
 		goto unlock;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 872cc769297c..479d9f42ff3f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -83,6 +83,7 @@ struct mlx5_lag {
 	unsigned long		  mode_flags;
 	unsigned long		  state_flags;
 	u8			  ports;
+	u8			  max_funcs;
 	u8			  buckets;
 	bool			  virt_lag;
 	int			  mode_changes_in_progress;
@@ -298,7 +299,7 @@ static inline bool mlx5_lag_is_supported(struct mlx5_core_dev *dev)
 #define mlx5_lag_for_each(i, start_index, ldev, filter) \
 	for (int tmp = start_index; \
 	     tmp = mlx5_get_next_lag_func(ldev, tmp, filter), \
-	     i = tmp, tmp < MLX5_MAX_PORTS; tmp++)
+	     i = tmp, tmp < (ldev)->max_funcs; tmp++)
 
 #define mlx5_lag_for_each_reverse(i, start_index, end_index, ldev, filter) \
 	for (int tmp = start_index, tmp1 = end_index; \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index b65ad9a26f71..56faa1d498c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -223,7 +223,7 @@ void mlx5_mpesw_sd_devcoms_unlock(struct mlx5_lag *ldev)
 	struct mlx5_devcom_comp_dev *sd_devcom;
 	int i;
 
-	mlx5_ldev_for_each_reverse(i, MLX5_MAX_PORTS, 0, ldev) {
+	mlx5_ldev_for_each_reverse(i, ldev->max_funcs, 0, ldev) {
 		sd_devcom = mlx5_sd_get_devcom(mlx5_lag_pf(ldev, i)->dev);
 		if (sd_devcom)
 			mlx5_devcom_comp_unlock(sd_devcom);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
index 7c7e6c832a93..29048b0c2797 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
@@ -71,7 +71,7 @@ static int mlx5_lag_create_single_fdb_filter(struct mlx5_lag *ldev, u32 filter)
 
 		err = mlx5_eswitch_offloads_single_fdb_add_one(master_esw,
 							       slave_esw,
-							       ldev->ports);
+							       ldev->max_funcs);
 		if (err)
 			goto err;
 	}
-- 
2.44.0

