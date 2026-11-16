Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794825118;
	b=dHNHu3aJTms4TEbHvNUhU+krUaVyCqLT3nF4zSOAD36usAb4aXx7/kn5Nv/Ng2+6tR+B
	 Qs0mScGCsAPQOtSs5PufFUkGj2iwPnrp5pLVadTh2qxVSEyFOs7fd5bJJds+YdXp35FQ/
	 3bv/D4Xa2C5iP1uW8glQCa09119vYi0lybiHwzgduY8nDdZHi5aJCpriC61Hlewb3GqdG
	 lW2Z5/9L256hPClT1t1J1A56M6T06Zz1HrAPNz53deqOCUaF0PDcGTnsfMcbu/kuMsRBj
	 kj7JG6HGNxrlb2Vn0JiGQfPzvifOCkCe8GioTeSm6Qvc85RAXf/j2/wyXsM5Wh857VA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794825118;
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
	bh=uMbdgFWZqiP6sM579QWOI6y+X6hpsxU/b+lzbKT8bYU=;
	b=FtfhjMb9Vj8evN67Q9JBzMqQcR5bPEwLS3NNpm8ju5hPVZkeUO4AQHJJrj6pFE1+kocg
	 LOP1dbtuUzAMbXWGTSe4CqBIfw/2SR4oW+2fbg4nlVrXmC+Qojg1VgZwKMCfR1KjLmFpQ
	 RM8mHR6o4RzzDsfadBN7RHvKlUHh3+EYuO+seZmvXPbRF82MnRoQJLjj0TWIaFqY8a8fs
	 LcMtr/dYyooFnPkpj7Pcria6wz9PF+v4t/GGgLKvnyio90bAVwlzaZ+5SaWs3dv/vuSBQ
	 ScPI1XoV0v0imC/SughvEmQYD8MbMBtBk2kAi8mjqdJXYSPyakhOeztA142QH43bSNg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pa1RzhaA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.41
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012041.outbound.protection.outlook.com [52.101.48.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801ED606A33A;
	Mon, 16 Nov 2026 10:31:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 801ED606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pa1RzhaA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j+xU1n9DkhIhsJlMnDvPVr/PvclZjm9h1+gjNXjJf7D8gvVG5xaNvSQjm54BNTrxyTVc+GWKznUs4Cn6J10qZuu2X0mhY7rP4BWMwVd+nx9h8Tke2NqN+T3pvhwUCN8ijeZF4yKDp3enB1ns0r7QjV2saZZR5cXwfb53s2Qu4uYhqJZeYPjKaNqB/1YWqSL5UbRe+0cp+7FnvQBMYSqAk+uf/FRMtvyJlu71lPrg8Pj3R2Xo1zro9TXypFsQQEyOB7Au10RNaNc9gYFS5Y1Fe8VI7SJLWN6S7pTZQwjnIyWHr7WgiZRZPPS6RysTWGsKfu7SHaBuPEeBlU8Tty06ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uMbdgFWZqiP6sM579QWOI6y+X6hpsxU/b+lzbKT8bYU=;
 b=cCrTS/f6RAdOka8cPPtOY6SI5Om4KeMy0YPbVClK0EAvSo3nJuf6Pmgmpj2+W139IdgCqU325PAysVzSpnT1ZicM6HhiYEWncSFGoakISU0dguciQ8JWCc42cshJZTRCn+oNsQbwxmu7yMxACbjNCXVB5ZjK2D5tLBE6OADmIup/ZLe9DF6uhnizmNn9KXovry6kI0vFjklYhqL30GGrKs0LpvTOcOxNj74iOsOpH39bnN54iAo36meieEb/tF3NOuoGOttwXxTSa7tF+Qki7WmH5cr3fcBQP0CkHo8P6uEFB/a7KO22SkkbrlexDlSUosoeJCwUO9Z1UN6DtNYwSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMbdgFWZqiP6sM579QWOI6y+X6hpsxU/b+lzbKT8bYU=;
 b=pa1RzhaAFRWXfiqJ0epbMl11cSDjaMW2AVOdO64DhHmW0C9xyK+ishseK1HMi9vl58TFFY0L/9AefiID5xiFv33mfQlyuJ3wSUjQRAGlE/9TENVLA5rc8k+eRo9ATXeXqDTazkpTBtkUHXhbhRcG7ZV3fq7Lx7yecHmYtVmOoatABkyq7Cg/0mRpetE3JqjqF0yQFlXTAlAs5b8RYrBhl+nb77TCHyiW+FDdu7BBjev8OUCtJ6a/qRKJLkUTFMIMIXg8J9gvFJ3Jo+eCjbq2onPyIZi0mTXKxgb9TY/KtJ6BUafL50nXPJ8Vdiun3IJlzGpAGsSaOY1Vmqr/BMc9Gg==
Received: from PH5P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:34a::8)
 by PH0PR12MB7862.namprd12.prod.outlook.com (2603:10b6:510:26d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Mon, 16 Nov
 2026 10:31:50 +0000
Received: from PH4PEPF0000B60D.namprd21.prod.outlook.com
 (2603:10b6:510:34a:cafe::3d) by PH5P220CA0001.outlook.office365.com
 (2603:10b6:510:34a::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Mon,
 16 Nov 2026 10:31:50 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 PH4PEPF0000B60D.mail.protection.outlook.com (10.167.243.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Mon, 16 Nov 2026 10:31:49 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 02:31:35 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 16 Nov 2026 02:31:34 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Mon, 16 Nov 2026 02:31:29 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Uri Dar <udar@nvidia.com>
Subject: [PATCH net-next V2 10/10] net/mlx5: LAG, do not add a device to an already-active virt LAG
Date: Mon, 16 Nov 2026 12:30:10 +0200
Message-ID: <20261116103010.1129666-11-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261116103010.1129666-1-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH4PEPF0000B60D:EE_|PH0PR12MB7862:EE_
X-MS-Office365-Filtering-Correlation-Id: 91e13adf-98b3-47d4-d582-08df43ccd2e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|376014|23010399003|18002099003|22082099003|6133799003|11063799006|10067099003|56012099006|261026140227099003|261026121527099003|261102123227099003|261022105027099003|261021121427099003|261028144727099003|261022075727099003|5023799004|261022113327099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	HEkca6e/UL6aJgFyqpDhmMP86xwFwzbj/zyELbJipiZzUyAr+0kIP/54p3r0R+ueRTYxqw5D1/ph9ZPB19Glubhd4imyIeKoib7E/lMJvdzsvPlIy5W7pz/VFPuJXmWxZGEDCJNid5Ie5JbeSicGORWhEFWONghLlF9mDLU44aunK4tIbbgk83Ih7wgDeLNzl3lTFz+N+KD9bPV6JR3wJe66F0D6GgMYLB4Bz9FhsUgr48pyy3wPI/vOQTtlkyV9/vVbQCl/uSF2B62KbpWtHaGnd3qRBh88P4No6GIamvqNRa+Li27zaVEYyClUiIQG+S1IzNQEpAMfQxnLk0GKZ4/vlBHcnMBQtWrJkFrDNv7+7jqDy4fh8iaqDj8muE31EygmJkaUBtq9WF0h75n7ERPOl8ygJiOXuzjl4H2vHAqP/u54hgVaInP2pytVkOeARKiz4DUtzanWrDB6RrVIV1a6/2NFL9jDXHvEgoPFaa4lyWf1NGqwhszLwem0AfjIIMLwTykwDSzSOUEPdud/i5BaofMWz9+66ibrDO+xlCAI8fH6FIEnM/IUCnVkKLyFyvqijocEO3aDzji6JweLr3FGO8u7NoIVZKJULYdll4z2G3h1ip2hRHqboO+w39LUXr4oNBDvgKnv6Qm6sErBqtNdN8i/M/jbYGfz+76sJ68y/pzFebZSb6BvrGaiizVb64OYEfOoCXnd4Ns+Lm8qUA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(376014)(23010399003)(18002099003)(22082099003)(6133799003)(11063799006)(10067099003)(56012099006)(261026140227099003)(261026121527099003)(261102123227099003)(261022105027099003)(261021121427099003)(261028144727099003)(261022075727099003)(5023799004)(261022113327099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	q6IR9sNLs+Yek0sjo6TFmwrqBFfVNLfx9s/9Q75DLNjQTD8k9QD0cXmGgI79h+iu4EkPoWE4Ov9W6AW1rJAKHMdIAdp7QSI7j1osdvO9Z1qpp8DoBYPdyYwdopUqiz71hEaFNTlMEoFKJtPqICpiG+QM7R2ZJ+Nh/wNpioMVvhlj4BdRpHNg0W8uP809qsBrLkup8Y+DO04ZLpAyKGTtGZoozkr2ZFZWPJ03qi3RS8v51j5cCNd+flZn6TyxqUX2VuLKllPjoMxWod5PVqGGdrDJAUNMMnCBJ8StW12SuwMrhsVF5TsANUha21vLY4UQxe2w6V0RKJxUmaAK7fJLXdfAGROrjL6onSZ5kFjIoqTyVPhlx8zYs7LPCOS7UjD+YN4GDXbWwe7ZMXwLCvIgWv9izbfPdgQuQhqShweRSCL+dSu8gnASDPg7sL6g5bYV
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 10:31:49.9768
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e13adf-98b3-47d4-d582-08df43ccd2e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH4PEPF0000B60D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7862

From: Shay Drory <shayd@nvidia.com>

mlx5_ldev_add_mdev() would add a newly probed device to the LAG even
when the LAG is already active, mutating membership while getters may be
iterating it and while the active mapping assumes a fixed member set.

A LAG of VFs/SFs is the only one whose members come independently of
its activation. Reject the join of a virt LAG capable function when the
group's virt LAG is active. The device stays out of the LAG until it
is reprobed and the LAG is disabled.

The other join paths cannot reach an active LAG. A LAG of PFs is
activated only once all the PFs of the card are members, so there is no
further PF that could join it, and SD secondaries join at load, before
MPESW can be enabled. Hence the check is limited to virt LAG capable
functions, and it is a no-op for existing configurations.

In addition, do not register the eswitch devcom component of such a
device, so it does not pair with the eswitches of the LAG members.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c        | 9 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h        | 5 +++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 474784131091..1323114ce7f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3572,6 +3572,10 @@ void mlx5_esw_offloads_devcom_init(struct mlx5_eswitch *esw,
 	xa_init(&esw->offloads.peer_flows);
 	mutex_init(&esw->offloads.peer_mutex);
 
+	/* do not pair a virt LAG capable VF/SF that is not part of a LAG */
+	if (!mlx5_core_is_pf(esw->dev) && mlx5_virt_lag_nonmember(esw->dev))
+		return;
+
 	if (!MLX5_CAP_ESW(esw->dev, merged_eswitch))
 		return;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 3e88b3f51612..abcab76fced0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -2448,6 +2448,11 @@ static int __mlx5_lag_dev_add_mdev(struct mlx5_core_dev *dev)
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
@@ -2536,6 +2541,10 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
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
index 330f5ab83a18..61afccba68ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -271,6 +271,11 @@ static inline void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev) {}
 static inline void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev) {}
 #endif
 
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

