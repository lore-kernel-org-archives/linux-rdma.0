Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793726002;
	b=vBlM0U4o6b+r8pe07viR+0ZyTbEJxj1xJo27z0ghzrDKsTTrozpEBvVPdmUybPEr4K3i
	 wjYrIGz/RWRBoc5B6dQO1I0QcdmW6ER/gJ4MG23PRDx5ISF43x45XOiSBfC5qsiMsjsRt
	 jao+h7DmcblFXdhZwxe9iAycsIP+BdhQ/Xzd8r1JRXnh8IOh8ujvRhmXWMmXQCbTbLgRM
	 PbH/kmJoXCXCZhx9mEOSRt4UmNGTPH+MDajnEtfmFZ+29vq6UH2f0PY+aF3ag+pogc5CJ
	 CPld86ewie5PVR9fMLSjyhywNqd9P8cuc5Jp5yGs0LxLXA0tSFwKqFWFdmCTl33tOsA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793726002;
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
	bh=LJHC9n2yFL7PojpPyN2fYye+1HkLZtN1TXsktHdr4Wk=;
	b=PALxi/OuG9TFdwyeQfeUCdEkiqkcs4das3P03bSJCukon5j+Wc7oynLu/pfDBKqTT4ZR
	 u8yTnEdoMxqwTljVSpZ3eSd/C8As1svSOpP4doICHRuwej/bz+bshZNADqzzioqSI5X/z
	 cnz7qwvJdksO/9CODIcMLm1hWPxwQasHnt4WNOPmX3BOWewykM/x30ymhiNzfGdjNFjPv
	 D3Sm52Th41i+mKHracsBiQTKnyaA3UqMKKDopPJuSdxJ1Cra3VT8JmD6tLzG74NyKexWM
	 lKjKVwqnxDTd6CPbtnjrnSlfDqCi+QP1XrGZokOfU1JBHhBn4/gBuOjOlO4EjFTjhwA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=E1NwsZz9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.33
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012033.outbound.protection.outlook.com [52.101.43.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D523E606EEAC;
	Tue,  3 Nov 2026 17:13:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D523E606EEAC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=E1NwsZz9
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RhVHxP5pPqZJ2+6Sg8iU/5GrZUanSNclFfDoyrnSRuutpVs9qakhUfnin3P6g3AYAzfiQSc0imCSNU704ItXVhrD8tXzDuKH98CZxqDDOeau+Yfx4re5q9igYbIzNo+Bu2Fu5LhoEHC1B1nk/PrSt71mnsGT/WaVtqahBC91aqJLviVdKNoF0OQ+3m5RRH52KBM8u/uU7XiBOEmNrTgkJlU39Wm2Tg32baRDrW3GojyhK74wTMbDWgU4rLwyW6uyyuvM4W4OY3dK1K3uyLGbPjdsl1zlX9rZeaxoLvaHd0pEpqFw4vhvE9Q+znTD5sYVRBSlzQt2hRLhQdZAal7IDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJHC9n2yFL7PojpPyN2fYye+1HkLZtN1TXsktHdr4Wk=;
 b=jjUbUUr3VASYgEC7p+T7MJS0KI2mkk3htxXYdPBDWG1LuJEzEClrVXniFrpvyuGGPUS7in3yE2qXop4xoOUY47EkUD13tw3WOM5DimcWo6aflwlVp6vWWYTdBzXHNtGmiYvazRX2BZBv9tPxU7bQ8j/YHClckC0dQMI5OXmb91GrpAzvjrWD6Q230w7C349DYcMeNyKyBDOGpzzC7uclSOQi58ROkDgVEwLwb9m2fELM09dhDrxiLs8gfuoC6VuUEY0Y4Knml0lGObF8cglKnVfWbLcjwX4Z2v1y2BvGpCOsMf4CT5zQjYgTSkFz1tzpAsyQUFF7/hmLVz+HrV+FMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJHC9n2yFL7PojpPyN2fYye+1HkLZtN1TXsktHdr4Wk=;
 b=E1NwsZz9VALx2c3gqdUjG9XdI3Z+M1G2fjAEftNDdGLBl+qLdShy0iR40D3wA1JBfhqjfCF5JsrtbQGblGrqQ294GeBX1naWf4JRyjhPbA6pE4Gea110p2xqx++rNqwuPj8nCIzmJ+stYJJQiNVhJQ4vlIO/UBigjMNQXb6L1+s2DSB3r3NBtkLgBiStgIGCeQNIBRX4v2tPzhVbQCQv7BcRicsrI/QLDdPTXretbv7cETeAMLtxkEfnSOAmXfLmi0wo1EFGfiqQkFzS+OmqgD2UjSIEiHFvQsi/DF2i6edV89QdacQSi4ur61Z6lyj3bmFr82OFK64NS1gzRVb8PQ==
Received: from DM6PR02CA0109.namprd02.prod.outlook.com (2603:10b6:5:1b4::11)
 by CHBPR12MB780315.namprd12.prod.outlook.com (2603:10b6:610:36a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 17:13:16 +0000
Received: from DM3PEPF000265B2.namprd02.prod.outlook.com
 (2603:10b6:5:1b4:cafe::5a) by DM6PR02CA0109.outlook.office365.com
 (2603:10b6:5:1b4::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 17:13:16 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM3PEPF000265B2.mail.protection.outlook.com (10.167.23.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 17:13:15 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 09:12:41 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:12:40 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 09:12:35 -0800
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
Subject: [PATCH net-next 10/15] net/mlx5: LAG, do not add a device to an already-active LAG
Date: Tue, 3 Nov 2026 19:10:04 +0200
Message-ID: <20261103171009.563034-11-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM3PEPF000265B2:EE_|CHBPR12MB780315:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b01a038-e366-4fab-a522-08df39cdbfc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|5023799004|11063799006|261022113327099003|56012099006|261009223027099003|261022105027099003|261102123227099003|261021121427099003|261022075727099003|261026121527099003|261028144727099003|261026140227099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	UEALRnLG3/2yQSArYf/bQcVgwPuLw3o8uzLWnqXaVaQeNZBy7nOXTNRXjwObHCOiiPVc/0s/ITlMhTXx1XdP0gnphPt1u5HeDe1yAponkky9gQHZSH1xXo8P7Nb7PBHLYKCS9GC3PddiAgLvHq7grkG5pdtjDOsWo84RxD7qnuVd4yfXHesObiCtHtyP0ma3XBDGrp9xXkgJFFG1MmlG8N2j6rfEyp3f3CBlvaPUtg79tLLkY3tt6QVTaaoD1d87rwutvcrhGPGMdXKL4G2deBO3twDGbwrjSlWWQ9x+EuJyArfWH5kQ8zH3Ba4Xy7LfnBJrDr5ukPt8saZoocjv+pBjlCNqLrPRhKAZ51GpHaY1SHrMaxiV3MP6dazLaM1Jqbe15QXWMtuNQjCdI8yLnHcSxPHYd3N60LgCfH/eU7VNrmpft/MWBRyzGg4JcW2wfPgICTaaiZi6AWtNrh9BcPEiilPC0XkgBcilPbwcYHwYwT07ZhxESj899duiUHy6Nv+vH7ZSmKlPxpAwXDCXneoOst7z7vGamMsCjNf30Sc7y9TgPpFYb3lvgqZ9T+ZmB9fpTy8GZ1hu6oC5HBhMq4+//9fsT6AVBoEEyGpd5m3dfM/cwUA8HOTtwvIBuIfyTNjjagl8rR0GDb6H4+af0jR8V2hOd6WPuLsoE+ru1/Iu7om/GcZzMO42tLM7KV/TcK1Ke7gdkeQUJzKTbZc6OA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(5023799004)(11063799006)(261022113327099003)(56012099006)(261009223027099003)(261022105027099003)(261102123227099003)(261021121427099003)(261022075727099003)(261026121527099003)(261028144727099003)(261026140227099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oureSJ7OKDiE4biymP7Ep465kpo0OnjbmvVZ5JrMJbCbGd6aHw7NQOKLPvAZWcErGmRtKZ3c1C7STQHpTEy4MzVmf2nrcdg6ajuYUA9lo+qAnF0lhtZyvUaAcXMdGpsH0iKUxlzXWFLo61dvmC+RQOA91l3221z2tC7rE4ZCPxkaT0RffXtDeLtQLyrcqGFQj3vl0ku8zoXTwzG31WUvj7HKdd5wPVwpvkpiz2IqE4+kmcZq8BedcPrfSiLNHIXQSbrdg4wdMS5xinOkSTNVm8Q+PXjiAWqSP/S1N5w5SfR2Ib9yH7xXFtGO55ONV4VtXf2WJk0Srb1tW8kl2ZyJZWzknYeEnYMaUzmGqeOUIfWOdlzBpdSRtkp6sA+WjV4xDbEOF8KfpcMNkELi9aMfDRe0Qn1uIYAf3qiVfKu7y53CVSNbu3ZAbchEWD1WmYVz
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:13:15.7221
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b01a038-e366-4fab-a522-08df39cdbfc8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265B2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHBPR12MB780315

From: Shay Drory <shayd@nvidia.com>

mlx5_ldev_add_mdev() would add a newly probed device to the LAG even
when the LAG is already active, mutating membership while getters may be
iterating it and while the active mapping assumes a fixed member set.

Reject the join when the group's LAG is active:
__mlx5_lag_dev_add_mdev() returns -EOPNOTSUPP, and mlx5_lag_add_mdev()
treats that as terminal - unregister the HCA devcom component and leave
the device standalone, rather than the -EAGAIN retry used for the
bounded mode-change window.
The device stays out of the LAG until it is reprobed.

This keeps LAG membership stable while active. It is a no-op for
existing configurations, where no device is added to a LAG once it is
active.

In addition, do not register the eswitch devcom component of such a
device, so it does not pair with the eswitches of the LAG members.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c        | 9 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h        | 5 +++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index c712848b202d..70e6dd9561a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3573,6 +3573,10 @@ void mlx5_esw_offloads_devcom_init(struct mlx5_eswitch *esw,
 	xa_init(&esw->offloads.peer_flows);
 	mutex_init(&esw->offloads.peer_mutex);
 
+	/* do not pair a virt LAG capable VF/SF that is not part of a LAG */
+	if (!mlx5_core_is_pf(esw->dev) && mlx5_virt_lag_nonmember(esw->dev))
+		return;
+
 	if (!MLX5_CAP_ESW(esw->dev, merged_eswitch))
 		return;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 9bc4a929cef3..d73bac8441f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -2449,6 +2449,11 @@ static int __mlx5_lag_dev_add_mdev(struct mlx5_core_dev *dev)
 		mutex_unlock(&ldev->lock);
 		return -EAGAIN;
 	}
+
+	if (mlx5_virt_lag_is_supported(dev) && __mlx5_lag_is_active(ldev)) {
+		mutex_unlock(&ldev->lock);
+		return -EOPNOTSUPP;
+	}
 	mlx5_ldev_get(ldev);
 	err = mlx5_ldev_add_mdev(ldev, dev, 0);
 	if (err) {
@@ -2537,6 +2542,10 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
 	err = __mlx5_lag_dev_add_mdev(dev);
 	mlx5_devcom_comp_unlock(dev->priv.hca_devcom_comp);
 
+	if (err == -EOPNOTSUPP) {
+		mlx5_lag_unregister_hca_devcom_comp(dev);
+		return;
+	}
 	if (err) {
 		msleep(100);
 		goto recheck;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index cbe380ae8bf9..385c767e24ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -280,6 +280,11 @@ static inline bool mlx5_virt_lag_is_supported(const struct mlx5_core_dev *dev)
 	return true;
 }
 
+static inline bool mlx5_virt_lag_nonmember(struct mlx5_core_dev *dev)
+{
+	return mlx5_virt_lag_is_supported(dev) && !mlx5_lag_dev(dev);
+}
+
 static inline bool mlx5_lag_is_supported(struct mlx5_core_dev *dev)
 {
 	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
-- 
2.44.0

