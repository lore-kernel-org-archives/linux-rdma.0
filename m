Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.31
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793725979;
	b=4q+KMBS3hKqu8BfltZVQ5/V65m52ZjaHKzv1dE+4SQB1nxB7Bp9DVlx4MgV5Jvtv5SHw
	 gRIdveXadcujh87n7pnVh0IKokZhRH5bsMiSdIfjEXAhbKsdHsJBU8uyiAldsp7CVYD4N
	 b492B4AvTt75Tm2vp17LdjZqyjREFEgSac5pHAx2dTGhpOCEHxEK2CLnDb638D8Fmsn+z
	 YaO7h3o2k4HYjRt50tU0FdSDVQrqZ9p6WpvylCoFHRSE6th4cIttH704ucOAJnKKj+Gw+
	 2yO8B8jJ1OuViMZfiFH+S4KJ8ZnfGnFUo+90oG3OyMBFWv60BcY9ZvUUSoeLQ+YMBVg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725979;
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
	bh=oPHV8by2ghHtBM3S5Jy+f1foY97nr/ukbVQf1ra4RTI=;
	b=34UdKMmv8HMZe6Mirlgep6jzUSU5/QJEnD85yiUuF/oVmz6dhxKtNRh19m6MYkzrECsk
	 IApVKOZpk2DMlJonPkK12+TeCJByropwjNHdGnWntA7xeDMp7sXSRVZT324ueq5btqwN2
	 6RILfeefmGI0vHIXZYV2l+kKU3EqonoySBQB5EDQCqWUTd7VFV9W/+F4lMrUfCDTR5vat
	 FyAHTB2+nVpJRn/UqBOcKhbIA1shDhq7GBT8im+AKK6qtBxsKC8897F07mDK/RgsomQ//
	 0nPPSUA7yZaKPzM1OUCGpJrVMB3XLyU0SGM9Q2W1ZvAFckZ9ErmWYgW6Jsj2vogcgog==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mD3Ev5kT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.31
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012031.outbound.protection.outlook.com [52.101.53.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FA5606A32E;
	Tue,  3 Nov 2026 17:12:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64FA5606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mD3Ev5kT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XeDslPv2cTNMG87YG6Zj7BgllpkO1Z65Fae+KZgPCRU5x/AWh9T0D21b2iu0at8pjwShIH4WWEvQpneSjAQJTTFa2x0ZADEFD0YgYhrkaWGJ4Seq6QB4bW+R1CODqHMejM6Mk20Z7wjq+5RobnX2XlcROS5EwHfmaNmuf2V4Olt1wmqBmrMfe4GV/ZeNYAz6MyeKWjdIK0roROpt4kD479sF4LoWT/lFXXSnkDKdw0wl86WDJ2bbg720/70ysDGD9uEZA+VblYrQkdolsziNPe2Wlle7zrxNVqQSCgkfmDbEepxjDKf/uFGnAsK1qrjdI/NxeM//yJKW0T8fd+ZXLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oPHV8by2ghHtBM3S5Jy+f1foY97nr/ukbVQf1ra4RTI=;
 b=Bm/LbtwTC5htnoxHmciRImiHO3wVpZyE5XSMChiOhQFAzGKH7kkF9ENfvV6i7EA2NA8KXS009w3/QyKqQ0QmYfSDC3IMyFLlTE+XNpZVB0G2XOqAEHn1i6JMkeHmmPs7uf5uHaluSGGLE3zuz4/58QwOGlxB82rEWe21x3rGbXB+UjrzF1Bk7U5jdvg8/clK4i2AYeC5V3pHL9Pl8mP25pGxRYit796llidJHph0D0aeZrVkRWkQaG1btv3hdJyDmptvwdW5YwOybbBHMf2O/V8b04bO7Wkf1Z0LehktiQLFlOrzhCP32L0NuKjNnTny8+u7iA7DoqwXwBeH6YzVZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPHV8by2ghHtBM3S5Jy+f1foY97nr/ukbVQf1ra4RTI=;
 b=mD3Ev5kTkSkIDFgvbvmdd0Spb8dCKWIbXEUZKNQuW+uZwAMC9C1VaOjERkTg+XtFVSBAejRdxtplCZQ5hBG5db0j+xSnX5Lj2fxLh2J/iVCvwA9bPClKZt2zF0VknqV5GVfrvtSx4FN81xe6ogzP769Ob6seTHgQRxaBmoF6fbVfrYCsZ6180NtYnl2Ad1TAE1hpc/IDLRCHaOJnWQVNK1/H3vWpDnbioSXaCaHJGcvXhRZiACWOkT2CCbXJMaGl0gCkOffiZFEqHmP8scKv6H+FpmPRrCZxc45LplQhz9TPKxWbI9kpWmZT5UKWgqHkpnI8aSYUpA84mx6+PqZOJA==
Received: from DS7PR03CA0294.namprd03.prod.outlook.com (2603:10b6:5:3ad::29)
 by CY8PR12MB7561.namprd12.prod.outlook.com (2603:10b6:930:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 17:12:49 +0000
Received: from DM3PEPF000265B4.namprd02.prod.outlook.com
 (2603:10b6:5:3ad:cafe::a4) by DS7PR03CA0294.outlook.office365.com
 (2603:10b6:5:3ad::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 17:12:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM3PEPF000265B4.mail.protection.outlook.com (10.167.23.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 17:12:48 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 09:12:20 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:12:19 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 09:12:15 -0800
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
Subject: [PATCH net-next 06/15] net/mlx5: LAG, rename PF naming to fn
Date: Tue, 3 Nov 2026 19:10:00 +0200
Message-ID: <20261103171009.563034-7-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM3PEPF000265B4:EE_|CY8PR12MB7561:EE_
X-MS-Office365-Filtering-Correlation-Id: db9801da-c7a5-4cfe-f258-08df39cdaf7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|36860700016|82310400026|261021123027099003|11063799006|261021135927099003|56012099006|261009220027099003|261009223027099003|261009221227099003|261009221727099003|261028144727099003|261021121427099003|261026140227099003|261026121527099003|261009223327099003|261022105027099003|10067099003|18002099003|22082099003|261102123227099003|6133799003|261102130727099003;
X-Microsoft-Antispam-Message-Info:
	CjL6xdAXhGhPvj9tTve3pH/XRW+8p/qAAKsOiAfdDSNDF5CFzN4bqEBEgjaydk3R2uUnJ0LGFZKRANzhIvsyUw26JVEVPo2Scif5E/031HJUECW+k/0KgWq8Sp7fvuX7FaqlwUimVuvkCNP0IPRlH3bkNhmCew0gc+qCa/elkPO2R48ri+8+5HKrT5NI8AcHimDMtY+S6b2Q8P/ymuANOaVHH2UDG2XS2y0x5o/DI7KKJ940P69g88iHX9Kj0mg9L2xibk+a69jLx9BOnboSfhogexQ1T1S6iTUBcZUnWqTI6S4+C3NJCMr4fv2bZYjxilxnlCJagM4UwLU0StRcMEpdj9BhEvGSOGpEhZhaD6+llLGmBo8S5eifwSlpSMTLsUC1BAO8giz/NQj2WOW8pKSJ10QD/ypvbv05p9wu/APeI5zrTGeaJk8ZGpLUSWtZCn+rS4NznEEWRuDvO0G5ZuT0OUKUS3vOXeNgdfaQNHd9ZNQmXKACaIBabJMsJFKPphxWsnuEYVVycZqzcFIVa1ziScpsFL9H870mXrKKtNkAVneyGkvR/2Ry3+Qr0DEcDtLt1rZLhr27cDIix6aLpl7yFqoUD7C1JFzQzf62su8401TLvb/e0olkZTtLH71eFQsTHKpvG0WyrLzUSo9mh+mbhrq80fUeC3yKh2WDKOqPrTsJ5mSn7PtwG8fk24b6Hw2Z9gxU+vfeAp2Kt7I4sg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(36860700016)(82310400026)(261021123027099003)(11063799006)(261021135927099003)(56012099006)(261009220027099003)(261009223027099003)(261009221227099003)(261009221727099003)(261028144727099003)(261021121427099003)(261026140227099003)(261026121527099003)(261009223327099003)(261022105027099003)(10067099003)(18002099003)(22082099003)(261102123227099003)(6133799003)(261102130727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Y5NRAoy8uRaJBOZQK1dGrcsDupwB2qKDMZ7RJr4VQCkyPh4Da7YYTLX/bMV5Y+nyMvFejCEIJkBAVW2VLqph3fM59KReso8VOsh5mZ6cpW8U2DDkfpzeYLvPF1l0Bs1Hz/Qfh8RwQroNZ5q8twdMXPRd//0RDWJs3tkzX57OH0P4XKQkXYb/HVBZic1zEVyQSBuzZTLtJ2AmLG3KWn+jgXREbO7GHE2LSN/8UMx/bzF++0tue1oCbW7rl6WeHnL5vqqCPNxuADInRRS/OFNwhDulf6xVmWmuPSIAakuYp72OtZWgyLniS3Cnykn4oR7k3IhUTO2Jd3qd4uTo0tcqbSjDLk4CK/7T8YqqTkQ3b8JqwX/+muDsHvAxVpeKKiF4RMSPOU3I1cxbPXvYuGyoqhQGTZJf7UDimLfpB74C2aIhUdF4+KS4hlFB35QIkzfI
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:12:48.3769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db9801da-c7a5-4cfe-f258-08df39cdaf7b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265B4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7561

From: Shay Drory <shayd@nvidia.com>

The LAG member bookkeeping is named after physical functions: the xarray
is ldev->pfs, the lookup helpers are mlx5_lag_pf(),
mlx5_lag_pf_by_dev(), mlx5_lag_pf_by_dev_idx() and
mlx5_lag_dev_get_master_pf(), and the local variables holding the result
are pf.

A later patch enables virt LAG, which means LAG members won't always be
physical functions.

Rename the xarray to ldev->fns, the helpers to mlx5_lag_fn*(), and the
locals to fn, so the naming matches struct lag_fn.

No functional change.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lag/debugfs.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 472 +++++++++---------
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  54 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mp.c  |  29 +-
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   |  42 +-
 .../mellanox/mlx5/core/lag/port_sel.c         |  25 +-
 .../mellanox/mlx5/core/lag/shared_fdb.c       |  44 +-
 .../net/ethernet/mellanox/mlx5/core/lib/sd.c  |  32 +-
 8 files changed, 354 insertions(+), 346 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
index b6125c7bd91b..116432cb7ce5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
@@ -154,7 +154,7 @@ static int members_show(struct seq_file *file, void *priv)
 	mutex_lock(&ldev->lock);
 	mlx5_ldev_for_each(i, 0, ldev)
 		seq_printf(file, "%s\n",
-			   dev_name(mlx5_lag_pf(ldev, i)->dev->device));
+			   dev_name(mlx5_lag_fn(ldev, i)->dev->device));
 	mutex_unlock(&ldev->lock);
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 73bce918cddb..1b065033a2a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -159,16 +159,16 @@ static int mlx5_cmd_modify_lag(struct mlx5_core_dev *dev, struct mlx5_lag *ldev,
 static u32 mlx5_lag_dev_group_id(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int i;
 
 	if (!ldev)
 		return 0;
 
 	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (pf->dev == dev)
-			return pf->sd_fdb_active ? pf->group_id : 0;
+		fn = mlx5_lag_fn(ldev, i);
+		if (fn->dev == dev)
+			return fn->sd_fdb_active ? fn->group_id : 0;
 	}
 	return 0;
 }
@@ -313,7 +313,7 @@ static void mlx5_do_bond_work(struct work_struct *work);
 static void mlx5_ldev_free(struct kref *ref)
 {
 	struct mlx5_lag *ldev = container_of(ref, struct mlx5_lag, ref);
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	struct net *net;
 	int i;
 
@@ -323,16 +323,16 @@ static void mlx5_ldev_free(struct kref *ref)
 	}
 
 	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (pf->port_change_nb.nb.notifier_call) {
-			struct mlx5_nb *nb = &pf->port_change_nb;
+		fn = mlx5_lag_fn(ldev, i);
+		if (fn->port_change_nb.nb.notifier_call) {
+			struct mlx5_nb *nb = &fn->port_change_nb;
 
-			mlx5_eq_notifier_unregister(pf->dev, nb);
+			mlx5_eq_notifier_unregister(fn->dev, nb);
 		}
-		xa_erase(&ldev->pfs, i);
-		kfree(pf);
+		xa_erase(&ldev->fns, i);
+		kfree(fn);
 	}
-	xa_destroy(&ldev->pfs);
+	xa_destroy(&ldev->fns);
 
 	mlx5_lag_mp_cleanup(ldev);
 	cancel_delayed_work_sync(&ldev->bond_work);
@@ -375,7 +375,7 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 
 	kref_init(&ldev->ref);
 	mutex_init(&ldev->lock);
-	xa_init_flags(&ldev->pfs, XA_FLAGS_ALLOC);
+	xa_init_flags(&ldev->fns, XA_FLAGS_ALLOC);
 	INIT_DELAYED_WORK(&ldev->bond_work, mlx5_do_bond_work);
 	INIT_WORK(&ldev->speed_update_work, mlx5_mpesw_speed_update_work);
 
@@ -395,7 +395,7 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 		mlx5_core_err(dev, "Failed to init multipath lag err=%d\n",
 			      err);
 
-	ldev->max_funcs = ldev->ports;
+	ldev->max_fns = ldev->ports;
 	return ldev;
 
 err_wq:
@@ -408,12 +408,12 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 int mlx5_lag_dev_get_netdev_idx(struct mlx5_lag *ldev,
 				struct net_device *ndev)
 {
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int i;
 
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (pf->netdev == ndev)
+		fn = mlx5_lag_fn(ldev, i);
+		if (fn->netdev == ndev)
 			return i;
 	}
 
@@ -428,7 +428,7 @@ static int mlx5_lag_get_master_idx(struct mlx5_lag *ldev)
 	if (!ldev)
 		return -ENOENT;
 
-	entry = xa_find(&ldev->pfs, &idx, U8_MAX, MLX5_LAG_XA_MARK_MASTER);
+	entry = xa_find(&ldev->fns, &idx, U8_MAX, MLX5_LAG_XA_MARK_MASTER);
 	if (!entry)
 		return -ENOENT;
 
@@ -470,11 +470,11 @@ int mlx5_lag_get_dev_index_by_seq(struct mlx5_lag *ldev, int seq)
  */
 static u32 mlx5_lag_get_filter(struct mlx5_lag *ldev, struct mlx5_core_dev *dev)
 {
-	struct lag_func *pf = mlx5_lag_pf_by_dev(ldev, dev);
+	struct lag_fn *fn = mlx5_lag_fn_by_dev(ldev, dev);
 
-	if (pf && pf->sd_fdb_active)
-		return pf->group_id;
-	if (pf && pf->group_id)
+	if (fn && fn->sd_fdb_active)
+		return fn->group_id;
+	if (fn && fn->group_id)
 		return MLX5_LAG_FILTER_ALL;
 	return MLX5_LAG_FILTER_PORTS;
 }
@@ -487,7 +487,7 @@ int mlx5_lag_get_dev_seq(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
 	int master_idx, i, num = 1;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	u32 filter;
 
 	if (!ldev)
@@ -498,15 +498,15 @@ int mlx5_lag_get_dev_seq(struct mlx5_core_dev *dev)
 	if (master_idx < 0)
 		return -ENOENT;
 
-	pf = mlx5_lag_pf(ldev, master_idx);
-	if (pf && pf->dev == dev)
+	fn = mlx5_lag_fn(ldev, master_idx);
+	if (fn && fn->dev == dev)
 		return 0;
 
 	mlx5_lag_for_each(i, 0, ldev, filter) {
 		if (i == master_idx)
 			continue;
-		pf = mlx5_lag_pf(ldev, i);
-		if (pf->dev == dev)
+		fn = mlx5_lag_fn(ldev, i);
+		if (fn->dev == dev)
 			return num;
 		num++;
 	}
@@ -544,7 +544,7 @@ static int mlx5_lag_get_dev_index_by_seq_group(struct mlx5_lag *ldev, int seq,
 	int i, num = 0;
 
 	mlx5_lag_for_each(i, 0, ldev, group_id) {
-		if (xa_get_mark(&ldev->pfs, i, MLX5_LAG_XA_MARK_PORT)) {
+		if (xa_get_mark(&ldev->fns, i, MLX5_LAG_XA_MARK_PORT)) {
 			if (seq == 0)
 				return i;
 			num++;
@@ -553,7 +553,7 @@ static int mlx5_lag_get_dev_index_by_seq_group(struct mlx5_lag *ldev, int seq,
 	}
 
 	mlx5_lag_for_each(i, 0, ldev, group_id) {
-		if (xa_get_mark(&ldev->pfs, i, MLX5_LAG_XA_MARK_PORT))
+		if (xa_get_mark(&ldev->fns, i, MLX5_LAG_XA_MARK_PORT))
 			continue;
 		if (num == seq)
 			return i;
@@ -584,14 +584,14 @@ int mlx5_lag_get_dev_index_by_seq_filter(struct mlx5_lag *ldev, int seq,
 static void mlx5_lag_mark_master(struct mlx5_lag *ldev)
 {
 	int lowest_dev_idx = INT_MAX;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int master_xa_idx = -1;
 	int dev_idx;
 	int i;
 
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		dev_idx = mlx5_get_dev_index(pf->dev);
+		fn = mlx5_lag_fn(ldev, i);
+		dev_idx = mlx5_get_dev_index(fn->dev);
 		if (dev_idx < lowest_dev_idx) {
 			lowest_dev_idx = dev_idx;
 			master_xa_idx = i;
@@ -599,7 +599,7 @@ static void mlx5_lag_mark_master(struct mlx5_lag *ldev)
 	}
 
 	if (master_xa_idx >= 0)
-		xa_set_mark(&ldev->pfs, master_xa_idx, MLX5_LAG_XA_MARK_MASTER);
+		xa_set_mark(&ldev->fns, master_xa_idx, MLX5_LAG_XA_MARK_MASTER);
 }
 
 static u64 mlx5_lag_member_tiebreak(struct mlx5_core_dev *dev)
@@ -617,15 +617,15 @@ void mlx5_virt_lag_mark_master(struct mlx5_lag *ldev)
 	u64 lowest_tiebreak = U64_MAX;
 	int lowest_dev_idx = INT_MAX;
 	int master_xa_idx = -1;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	u64 tiebreak;
 	int dev_idx;
 	int i;
 
 	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
-		pf = mlx5_lag_pf(ldev, i);
-		dev_idx = mlx5_get_dev_index(pf->dev);
-		tiebreak = mlx5_lag_member_tiebreak(pf->dev);
+		fn = mlx5_lag_fn(ldev, i);
+		dev_idx = mlx5_get_dev_index(fn->dev);
+		tiebreak = mlx5_lag_member_tiebreak(fn->dev);
 		if (dev_idx < lowest_dev_idx ||
 		    (dev_idx == lowest_dev_idx && tiebreak < lowest_tiebreak)) {
 			lowest_dev_idx = dev_idx;
@@ -635,7 +635,7 @@ void mlx5_virt_lag_mark_master(struct mlx5_lag *ldev)
 	}
 
 	if (master_xa_idx >= 0)
-		xa_set_mark(&ldev->pfs, master_xa_idx, MLX5_LAG_XA_MARK_MASTER);
+		xa_set_mark(&ldev->fns, master_xa_idx, MLX5_LAG_XA_MARK_MASTER);
 }
 
 void mlx5_lag_clear_master(struct mlx5_lag *ldev)
@@ -643,11 +643,11 @@ void mlx5_lag_clear_master(struct mlx5_lag *ldev)
 	unsigned long idx = 0;
 	void *entry;
 
-	entry = xa_find(&ldev->pfs, &idx, U8_MAX, MLX5_LAG_XA_MARK_MASTER);
+	entry = xa_find(&ldev->fns, &idx, U8_MAX, MLX5_LAG_XA_MARK_MASTER);
 	if (!entry)
 		return;
 
-	xa_clear_mark(&ldev->pfs, idx, MLX5_LAG_XA_MARK_MASTER);
+	xa_clear_mark(&ldev->fns, idx, MLX5_LAG_XA_MARK_MASTER);
 }
 
 /* Devcom event handler to manage LAG master marking */
@@ -698,15 +698,15 @@ int mlx5_lag_num_devs(struct mlx5_lag *ldev)
 
 int mlx5_lag_num_netdevs(struct mlx5_lag *ldev)
 {
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int i, num = 0;
 
 	if (!ldev)
 		return 0;
 
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (pf->netdev)
+		fn = mlx5_lag_fn(ldev, i);
+		if (fn->netdev)
 			num++;
 	}
 	return num;
@@ -725,9 +725,9 @@ static bool __mlx5_lag_is_sriov(struct mlx5_lag *ldev)
 static bool __mlx5_lag_is_sd_active(struct mlx5_lag *ldev,
 				    struct mlx5_core_dev *dev)
 {
-	struct lag_func *pf = mlx5_lag_pf_by_dev(ldev, dev);
+	struct lag_fn *fn = mlx5_lag_fn_by_dev(ldev, dev);
 
-	return pf && pf->sd_fdb_active;
+	return fn && fn->sd_fdb_active;
 }
 
 /* Create a mapping between steering slots and active ports.
@@ -802,12 +802,12 @@ static int mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
 
 static bool mlx5_lag_has_drop_rule(struct mlx5_lag *ldev)
 {
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int i;
 
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (pf->has_drop)
+		fn = mlx5_lag_fn(ldev, i);
+		if (fn->has_drop)
 			return true;
 	}
 	return false;
@@ -815,17 +815,19 @@ static bool mlx5_lag_has_drop_rule(struct mlx5_lag *ldev)
 
 static void mlx5_lag_drop_rule_cleanup(struct mlx5_lag *ldev)
 {
-	struct lag_func *pf;
+	struct mlx5_eswitch *esw;
+	struct lag_fn *fn;
 	int i;
 
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (!pf->has_drop)
+		fn = mlx5_lag_fn(ldev, i);
+		if (!fn->has_drop)
 			continue;
 
-		mlx5_esw_acl_ingress_vport_drop_rule_destroy(pf->dev->priv.eswitch,
+		esw = fn->dev->priv.eswitch;
+		mlx5_esw_acl_ingress_vport_drop_rule_destroy(esw,
 							     MLX5_VPORT_UPLINK);
-		pf->has_drop = false;
+		fn->has_drop = false;
 	}
 }
 
@@ -833,7 +835,7 @@ static void mlx5_lag_drop_rule_setup(struct mlx5_lag *ldev,
 				     struct lag_tracker *tracker)
 {
 	struct mlx5_core_dev *dev;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int err;
 	int i;
 
@@ -849,12 +851,12 @@ static void mlx5_lag_drop_rule_setup(struct mlx5_lag *ldev,
 		if (tracker->netdev_state[i].tx_enabled &&
 		    tracker->netdev_state[i].link_up)
 			continue;
-		pf = mlx5_lag_pf(ldev, i);
-		dev = pf->dev;
+		fn = mlx5_lag_fn(ldev, i);
+		dev = fn->dev;
 		err = mlx5_esw_acl_ingress_vport_drop_rule_create(dev->priv.eswitch,
 								  MLX5_VPORT_UPLINK);
 		if (!err)
-			pf->has_drop = true;
+			fn->has_drop = true;
 		else
 			mlx5_core_err(dev,
 				      "Failed to create lag drop rule, error: %d",
@@ -888,7 +890,7 @@ static int _mlx5_modify_lag(struct mlx5_lag *ldev,
 	if (idx < 0)
 		return -EINVAL;
 
-	dev0 = mlx5_lag_pf(ldev, idx)->dev;
+	dev0 = mlx5_lag_fn(ldev, idx)->dev;
 	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &ldev->mode_flags)) {
 		ret = mlx5_lag_port_sel_modify(ldev, ports);
 		if (ret ||
@@ -908,7 +910,7 @@ static int _mlx5_modify_lag(struct mlx5_lag *ldev,
 static struct net_device *mlx5_lag_active_backup_get_netdev(struct mlx5_core_dev *dev)
 {
 	struct net_device *ndev = NULL;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	struct mlx5_lag *ldev;
 	unsigned long flags;
 	int i, last_idx;
@@ -920,16 +922,16 @@ static struct net_device *mlx5_lag_active_backup_get_netdev(struct mlx5_core_dev
 		goto unlock;
 
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
+		fn = mlx5_lag_fn(ldev, i);
 		if (ldev->tracker.netdev_state[i].tx_enabled)
-			ndev = pf->netdev;
+			ndev = fn->netdev;
 	}
 	if (!ndev) {
 		last_idx = mlx5_lag_get_dev_index_by_seq(ldev, ldev->ports - 1);
 		if (last_idx < 0)
 			goto unlock;
-		pf = mlx5_lag_pf(ldev, last_idx);
-		ndev = pf->netdev;
+		fn = mlx5_lag_fn(ldev, last_idx);
+		ndev = fn->netdev;
 	}
 
 	dev_hold(ndev);
@@ -954,7 +956,7 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 	if (first_idx < 0)
 		return;
 
-	dev0 = mlx5_lag_pf(ldev, first_idx)->dev;
+	dev0 = mlx5_lag_fn(ldev, first_idx)->dev;
 
 	ports = kcalloc(ldev->ports * MLX5_LAG_MAX_HASH_BUCKETS,
 			sizeof(*ports), GFP_KERNEL);
@@ -1022,7 +1024,7 @@ static int mlx5_lag_set_port_sel_mode(struct mlx5_lag *ldev,
 	    mode == MLX5_LAG_MODE_MULTIPATH)
 		return 0;
 
-	dev0 = mlx5_lag_pf(ldev, first_idx)->dev;
+	dev0 = mlx5_lag_fn(ldev, first_idx)->dev;
 
 	if (!MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table)) {
 		if (ldev->ports > 2)
@@ -1080,7 +1082,7 @@ static int mlx5_create_lag(struct mlx5_lag *ldev,
 	if (first_idx < 0)
 		return -EINVAL;
 
-	dev0 = mlx5_lag_pf(ldev, first_idx)->dev;
+	dev0 = mlx5_lag_fn(ldev, first_idx)->dev;
 	if (tracker)
 		mlx5_lag_print_mapping(dev0, ldev, tracker, flags);
 	mlx5_core_info(dev0, "shared_fdb:%d mode:%s\n",
@@ -1128,7 +1130,7 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 	if (master_idx < 0)
 		return -EINVAL;
 
-	dev0 = mlx5_lag_pf(ldev, master_idx)->dev;
+	dev0 = mlx5_lag_fn(ldev, master_idx)->dev;
 	err = mlx5_lag_set_flags(ldev, mode, tracker, shared_fdb, &flags);
 	if (err)
 		return err;
@@ -1191,7 +1193,7 @@ int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 	if (master_idx < 0)
 		return -EINVAL;
 
-	dev0 = mlx5_lag_pf(ldev, master_idx)->dev;
+	dev0 = mlx5_lag_fn(ldev, master_idx)->dev;
 	ldev->mode = MLX5_LAG_MODE_NONE;
 	ldev->mode_flags = 0;
 	mlx5_lag_mp_reset(ldev);
@@ -1232,7 +1234,7 @@ bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 	struct mlx5_core_dev *dev;
 	u8 mode;
 #endif
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	bool roce_support;
 	int i;
 
@@ -1241,35 +1243,35 @@ bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 
 #ifdef CONFIG_MLX5_ESWITCH
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		dev = pf->dev;
+		fn = mlx5_lag_fn(ldev, i);
+		dev = fn->dev;
 		if (mlx5_eswitch_num_vfs(dev->priv.eswitch) && !is_mdev_switchdev_mode(dev))
 			return false;
 	}
 
-	pf = mlx5_lag_pf(ldev, master_idx);
-	dev = pf->dev;
+	fn = mlx5_lag_fn(ldev, master_idx);
+	dev = fn->dev;
 	mode = mlx5_eswitch_mode(dev);
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (mlx5_eswitch_mode(pf->dev) != mode)
+		fn = mlx5_lag_fn(ldev, i);
+		if (mlx5_eswitch_mode(fn->dev) != mode)
 			return false;
 	}
 
 #else
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (mlx5_sriov_is_enabled(pf->dev))
+		fn = mlx5_lag_fn(ldev, i);
+		if (mlx5_sriov_is_enabled(fn->dev))
 			return false;
 	}
 #endif
-	pf = mlx5_lag_pf(ldev, master_idx);
-	roce_support = mlx5_get_roce_state(pf->dev);
+	fn = mlx5_lag_fn(ldev, master_idx);
+	roce_support = mlx5_get_roce_state(fn->dev);
 	mlx5_ldev_for_each(i, 0, ldev) {
 		if (i == master_idx)
 			continue;
-		pf = mlx5_lag_pf(ldev, i);
-		if (mlx5_get_roce_state(pf->dev) != roce_support)
+		fn = mlx5_lag_fn(ldev, i);
+		if (mlx5_get_roce_state(fn->dev) != roce_support)
 			return false;
 	}
 
@@ -1279,19 +1281,19 @@ bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 static void mlx5_lag_assert_locked_transition(struct mlx5_lag *ldev, u32 filter)
 {
 	struct mlx5_devcom_comp_dev *devcom = NULL;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int i;
 
 	lockdep_assert_held(&ldev->lock);
 
 	i = mlx5_get_next_lag_func(ldev, 0, filter);
-	if (i < ldev->max_funcs) {
-		pf = mlx5_lag_pf(ldev, i);
+	if (i < ldev->max_fns) {
+		fn = mlx5_lag_fn(ldev, i);
 		if (filter == MLX5_LAG_FILTER_PORTS ||
 		    filter == MLX5_LAG_FILTER_ALL)
-			devcom = pf->dev->priv.hca_devcom_comp;
+			devcom = fn->dev->priv.hca_devcom_comp;
 		else
-			devcom = mlx5_sd_get_devcom(pf->dev);
+			devcom = mlx5_sd_get_devcom(fn->dev);
 	}
 	mlx5_devcom_comp_assert_locked(devcom);
 }
@@ -1338,22 +1340,22 @@ static void mlx5_lag_rescan_devices_locked_filter(struct mlx5_lag *ldev,
 						  bool enable, u32 filter)
 {
 	struct mlx5_core_dev *devs[MLX5_MAX_PORTS];
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int num_devs = 0;
 	int i;
 
 	mlx5_lag_assert_locked_transition(ldev, filter);
 
 	mlx5_lag_for_each(i, 0, ldev, filter) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (pf->dev->priv.flags & MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV)
+		fn = mlx5_lag_fn(ldev, i);
+		if (fn->dev->priv.flags & MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV)
 			continue;
 
 		if (enable)
-			pf->dev->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
+			fn->dev->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
 		else
-			pf->dev->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
-		devs[num_devs++] = pf->dev;
+			fn->dev->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
+		devs[num_devs++] = fn->dev;
 	}
 
 	mlx5_lag_drop_lock_for_reps(ldev, filter);
@@ -1385,14 +1387,14 @@ void mlx5_lag_remove_devices(struct mlx5_lag *ldev)
 static int mlx5_lag_reload_ib_reps_idx(struct mlx5_lag *ldev, int idx,
 				       u32 flags)
 {
-	struct lag_func *pf = mlx5_lag_pf(ldev, idx);
+	struct lag_fn *fn = mlx5_lag_fn(ldev, idx);
 	struct mlx5_eswitch *esw;
 	int ret;
 
-	if (pf->dev->priv.flags & flags)
+	if (fn->dev->priv.flags & flags)
 		return 0;
 
-	esw = pf->dev->priv.eswitch;
+	esw = fn->dev->priv.eswitch;
 	mlx5_esw_reps_block(esw);
 	ret = mlx5_eswitch_reload_ib_reps(esw);
 	mlx5_esw_reps_unblock(esw);
@@ -1453,14 +1455,14 @@ int mlx5_lag_reload_ib_reps_from_locked(struct mlx5_lag *ldev, u32 flags,
 
 static void mlx5_lag_unload_reps_unlocked(struct mlx5_lag *ldev, u32 filter)
 {
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int i;
 
 	mlx5_lag_for_each(i, 0, ldev, filter) {
 		struct mlx5_eswitch *esw;
 
-		pf = mlx5_lag_pf(ldev, i);
-		esw = pf->dev->priv.eswitch;
+		fn = mlx5_lag_fn(ldev, i);
+		esw = fn->dev->priv.eswitch;
 		mlx5_esw_reps_block(esw);
 		mlx5_eswitch_unload_reps(esw);
 		mlx5_esw_reps_unblock(esw);
@@ -1494,7 +1496,7 @@ void mlx5_disable_lag(struct mlx5_lag *ldev)
 		return;
 	}
 
-	dev0 = mlx5_lag_pf(ldev, idx)->dev;
+	dev0 = mlx5_lag_fn(ldev, idx)->dev;
 	roce_lag = __mlx5_lag_is_roce(ldev);
 
 	if (roce_lag) {
@@ -1502,7 +1504,7 @@ void mlx5_disable_lag(struct mlx5_lag *ldev)
 		mlx5_ldev_for_each(i, 0, ldev) {
 			if (i == idx)
 				continue;
-			mlx5_nic_vport_disable_roce(mlx5_lag_pf(ldev, i)->dev);
+			mlx5_nic_vport_disable_roce(mlx5_lag_fn(ldev, i)->dev);
 		}
 	}
 
@@ -1517,18 +1519,18 @@ void mlx5_disable_lag(struct mlx5_lag *ldev)
 static bool mlx5_lag_is_roce_lag(struct mlx5_lag *ldev)
 {
 	bool roce_lag = true;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int i;
 
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		roce_lag = roce_lag && !mlx5_sriov_is_enabled(pf->dev);
+		fn = mlx5_lag_fn(ldev, i);
+		roce_lag = roce_lag && !mlx5_sriov_is_enabled(fn->dev);
 	}
 
 #ifdef CONFIG_MLX5_ESWITCH
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		roce_lag = roce_lag && is_mdev_legacy_mode(pf->dev);
+		fn = mlx5_lag_fn(ldev, i);
+		roce_lag = roce_lag && is_mdev_legacy_mode(fn->dev);
 	}
 #endif
 
@@ -1557,15 +1559,15 @@ static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
 	mlx5_ldev_for_each(pf_idx, 0, ldev) {
 		u8 opmod = MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT;
 		struct mlx5_core_dev *pf_mdev;
-		struct lag_func *pf;
+		struct lag_fn *fn;
 		u32 speed;
 		u8 state;
 		int ret;
 
-		pf = mlx5_lag_pf(ldev, pf_idx);
-		if (!pf)
+		fn = mlx5_lag_fn(ldev, pf_idx);
+		if (!fn)
 			continue;
-		pf_mdev = pf->dev;
+		pf_mdev = fn->dev;
 		if (!pf_mdev)
 			continue;
 		ret = mlx5_query_vport_max_tx_speed(pf_mdev, opmod, 0, 0,
@@ -1604,14 +1606,14 @@ static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
 	*max_speed = 0;
 	mlx5_ldev_for_each(pf_idx, 0, ldev) {
 		struct mlx5_core_dev *pf_mdev;
-		struct lag_func *pf;
+		struct lag_fn *fn;
 		u32 speed;
 		int ret;
 
-		pf = mlx5_lag_pf(ldev, pf_idx);
-		if (!pf)
+		fn = mlx5_lag_fn(ldev, pf_idx);
+		if (!fn)
 			continue;
-		pf_mdev = pf->dev;
+		pf_mdev = fn->dev;
 		if (!pf_mdev)
 			continue;
 
@@ -1671,7 +1673,7 @@ static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
 void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *mdev;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	u32 speed;
 	int pf_idx;
 
@@ -1691,10 +1693,10 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
 	speed = speed / MLX5_MAX_TX_SPEED_UNIT;
 
 	mlx5_ldev_for_each(pf_idx, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, pf_idx);
-		if (!pf)
+		fn = mlx5_lag_fn(ldev, pf_idx);
+		if (!fn)
 			continue;
-		mdev = pf->dev;
+		mdev = fn->dev;
 		if (!mdev)
 			continue;
 
@@ -1705,16 +1707,16 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
 void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *mdev;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	u32 speed;
 	int pf_idx;
 	int ret;
 
 	mlx5_ldev_for_each(pf_idx, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, pf_idx);
-		if (!pf)
+		fn = mlx5_lag_fn(ldev, pf_idx);
+		if (!fn)
 			continue;
-		mdev = pf->dev;
+		mdev = fn->dev;
 		if (!mdev)
 			continue;
 
@@ -1745,7 +1747,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 	if (idx < 0)
 		return;
 
-	dev0 = mlx5_lag_pf(ldev, idx)->dev;
+	dev0 = mlx5_lag_fn(ldev, idx)->dev;
 	if (!mlx5_lag_is_ready(ldev)) {
 		do_bond = false;
 	} else {
@@ -1790,7 +1792,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 				mlx5_ldev_for_each(i, 0, ldev) {
 					if (i == idx)
 						continue;
-					dev = mlx5_lag_pf(ldev, i)->dev;
+					dev = mlx5_lag_fn(ldev, i)->dev;
 					if (mlx5_get_roce_state(dev))
 						mlx5_nic_vport_enable_roce(dev);
 				}
@@ -1824,7 +1826,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 struct mlx5_devcom_comp_dev *mlx5_lag_get_devcom_comp(struct mlx5_lag *ldev)
 {
 	struct mlx5_devcom_comp_dev *devcom = NULL;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	u32 filter;
 	int i;
 
@@ -1832,9 +1834,9 @@ struct mlx5_devcom_comp_dev *mlx5_lag_get_devcom_comp(struct mlx5_lag *ldev)
 	filter = ldev->virt_lag ? MLX5_LAG_FILTER_ALL :
 		MLX5_LAG_FILTER_PORTS;
 	i = mlx5_get_next_lag_func(ldev, 0, filter);
-	if (i < ldev->max_funcs) {
-		pf = mlx5_lag_pf(ldev, i);
-		devcom = pf->dev->priv.hca_devcom_comp;
+	if (i < ldev->max_fns) {
+		fn = mlx5_lag_fn(ldev, i);
+		devcom = fn->dev->priv.hca_devcom_comp;
 	}
 	mutex_unlock(&ldev->lock);
 	return devcom;
@@ -1842,7 +1844,7 @@ struct mlx5_devcom_comp_dev *mlx5_lag_get_devcom_comp(struct mlx5_lag *ldev)
 
 static int mlx5_lag_demux_ft_fg_init(struct mlx5_core_dev *dev,
 				     struct mlx5_flow_table_attr *ft_attr,
-				     struct lag_func *pf)
+				     struct lag_fn *fn)
 {
 #ifdef CONFIG_MLX5_ESWITCH
 	struct mlx5_flow_namespace *ns;
@@ -1853,20 +1855,20 @@ static int mlx5_lag_demux_ft_fg_init(struct mlx5_core_dev *dev,
 	if (!ns)
 		return 0;
 
-	pf->lag_demux_ft = mlx5_create_flow_table(ns, ft_attr);
-	if (IS_ERR(pf->lag_demux_ft))
-		return PTR_ERR(pf->lag_demux_ft);
+	fn->lag_demux_ft = mlx5_create_flow_table(ns, ft_attr);
+	if (IS_ERR(fn->lag_demux_ft))
+		return PTR_ERR(fn->lag_demux_ft);
 
 	fg = mlx5_esw_lag_demux_fg_create(dev->priv.eswitch,
-					  pf->lag_demux_ft);
+					  fn->lag_demux_ft);
 	if (IS_ERR(fg)) {
 		err = PTR_ERR(fg);
-		mlx5_destroy_flow_table(pf->lag_demux_ft);
-		pf->lag_demux_ft = NULL;
+		mlx5_destroy_flow_table(fn->lag_demux_ft);
+		fn->lag_demux_ft = NULL;
 		return err;
 	}
 
-	pf->lag_demux_fg = fg;
+	fn->lag_demux_fg = fg;
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -1875,7 +1877,7 @@ static int mlx5_lag_demux_ft_fg_init(struct mlx5_core_dev *dev,
 
 static int mlx5_lag_demux_fw_init(struct mlx5_core_dev *dev,
 				  struct mlx5_flow_table_attr *ft_attr,
-				  struct lag_func *pf)
+				  struct lag_fn *fn)
 {
 	struct mlx5_flow_namespace *ns;
 	int err;
@@ -1884,12 +1886,12 @@ static int mlx5_lag_demux_fw_init(struct mlx5_core_dev *dev,
 	if (!ns)
 		return 0;
 
-	pf->lag_demux_fg = NULL;
+	fn->lag_demux_fg = NULL;
 	ft_attr->max_fte = 1;
-	pf->lag_demux_ft = mlx5_create_lag_demux_flow_table(ns, ft_attr);
-	if (IS_ERR(pf->lag_demux_ft)) {
-		err = PTR_ERR(pf->lag_demux_ft);
-		pf->lag_demux_ft = NULL;
+	fn->lag_demux_ft = mlx5_create_lag_demux_flow_table(ns, ft_attr);
+	if (IS_ERR(fn->lag_demux_ft)) {
+		err = PTR_ERR(fn->lag_demux_ft);
+		fn->lag_demux_ft = NULL;
 		return err;
 	}
 
@@ -1900,7 +1902,7 @@ int mlx5_lag_demux_init(struct mlx5_core_dev *dev,
 			struct mlx5_flow_table_attr *ft_attr)
 {
 	struct mlx5_lag *ldev;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 
 	if (!ft_attr)
 		return -EINVAL;
@@ -1909,16 +1911,16 @@ int mlx5_lag_demux_init(struct mlx5_core_dev *dev,
 	if (!ldev)
 		return -ENODEV;
 
-	pf = mlx5_lag_pf_by_dev(ldev, dev);
-	if (!pf)
+	fn = mlx5_lag_fn_by_dev(ldev, dev);
+	if (!fn)
 		return -ENODEV;
 
-	xa_init(&pf->lag_demux_rules);
+	xa_init(&fn->lag_demux_rules);
 
 	if (mlx5_lag_is_sw_managed(dev))
-		return mlx5_lag_demux_ft_fg_init(dev, ft_attr, pf);
+		return mlx5_lag_demux_ft_fg_init(dev, ft_attr, fn);
 
-	return mlx5_lag_demux_fw_init(dev, ft_attr, pf);
+	return mlx5_lag_demux_fw_init(dev, ft_attr, fn);
 }
 EXPORT_SYMBOL(mlx5_lag_demux_init);
 
@@ -1927,31 +1929,31 @@ void mlx5_lag_demux_cleanup(struct mlx5_core_dev *dev)
 	struct mlx5_flow_handle *rule;
 	struct mlx5_lag *ldev;
 	unsigned long vport_num;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 
 	ldev = mlx5_lag_dev(dev);
 	if (!ldev)
 		return;
 
-	pf = mlx5_lag_pf_by_dev(ldev, dev);
-	if (!pf)
+	fn = mlx5_lag_fn_by_dev(ldev, dev);
+	if (!fn)
 		return;
 
-	xa_for_each(&pf->lag_demux_rules, vport_num, rule)
+	xa_for_each(&fn->lag_demux_rules, vport_num, rule)
 		mlx5_del_flow_rules(rule);
-	xa_destroy(&pf->lag_demux_rules);
+	xa_destroy(&fn->lag_demux_rules);
 
-	if (pf->lag_demux_fg)
-		mlx5_destroy_flow_group(pf->lag_demux_fg);
-	if (pf->lag_demux_ft)
-		mlx5_destroy_flow_table(pf->lag_demux_ft);
-	pf->lag_demux_fg = NULL;
-	pf->lag_demux_ft = NULL;
+	if (fn->lag_demux_fg)
+		mlx5_destroy_flow_group(fn->lag_demux_fg);
+	if (fn->lag_demux_ft)
+		mlx5_destroy_flow_table(fn->lag_demux_ft);
+	fn->lag_demux_fg = NULL;
+	fn->lag_demux_ft = NULL;
 }
 EXPORT_SYMBOL(mlx5_lag_demux_cleanup);
 
-static struct lag_func *mlx5_lag_dev_get_master_pf(struct mlx5_lag *ldev,
-						   struct mlx5_core_dev *dev)
+static struct lag_fn *mlx5_lag_dev_get_master_fn(struct mlx5_lag *ldev,
+						 struct mlx5_core_dev *dev)
 {
 	u32 filter = mlx5_lag_get_filter(ldev, dev);
 	int idx;
@@ -1960,14 +1962,14 @@ static struct lag_func *mlx5_lag_dev_get_master_pf(struct mlx5_lag *ldev,
 	if (idx < 0)
 		return NULL;
 
-	return mlx5_lag_pf(ldev, idx);
+	return mlx5_lag_fn(ldev, idx);
 }
 
 int mlx5_lag_demux_rule_add(struct mlx5_core_dev *vport_dev, u16 vport_num,
 			    int index)
 {
 	struct mlx5_flow_handle *rule;
-	struct lag_func *master;
+	struct lag_fn *master;
 	struct mlx5_lag *ldev;
 	int err;
 
@@ -1975,7 +1977,7 @@ int mlx5_lag_demux_rule_add(struct mlx5_core_dev *vport_dev, u16 vport_num,
 	if (!ldev)
 		return 0;
 
-	master = mlx5_lag_dev_get_master_pf(ldev, vport_dev);
+	master = mlx5_lag_dev_get_master_fn(ldev, vport_dev);
 	if (!master || !master->lag_demux_fg)
 		return 0;
 
@@ -2008,18 +2010,18 @@ EXPORT_SYMBOL(mlx5_lag_demux_rule_add);
 void mlx5_lag_demux_rule_del(struct mlx5_core_dev *dev, int index)
 {
 	struct mlx5_flow_handle *rule;
-	struct lag_func *master_pf;
+	struct lag_fn *master_fn;
 	struct mlx5_lag *ldev;
 
 	ldev = mlx5_lag_dev(dev);
 	if (!ldev)
 		return;
 
-	master_pf = mlx5_lag_dev_get_master_pf(ldev, dev);
-	if (!master_pf || !master_pf->lag_demux_fg)
+	master_fn = mlx5_lag_dev_get_master_fn(ldev, dev);
+	if (!master_fn || !master_fn->lag_demux_fg)
 		return;
 
-	rule = xa_erase(&master_pf->lag_demux_rules, index);
+	rule = xa_erase(&master_fn->lag_demux_rules, index);
 	if (rule)
 		mlx5_del_flow_rules(rule);
 }
@@ -2069,7 +2071,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 	struct netdev_lag_upper_info *lag_upper_info = NULL;
 	bool is_bonded, is_in_lag, mode_supported;
 	bool has_inactive = 0;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	struct slave *slave;
 	u8 bond_status = 0;
 	int num_slaves = 0;
@@ -2090,8 +2092,8 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 	rcu_read_lock();
 	for_each_netdev_in_bond_rcu(upper, ndev_tmp) {
 		mlx5_ldev_for_each(i, 0, ldev) {
-			pf = mlx5_lag_pf(ldev, i);
-			if (pf->netdev == ndev_tmp) {
+			fn = mlx5_lag_fn(ldev, i);
+			if (fn->netdev == ndev_tmp) {
 				idx++;
 				break;
 			}
@@ -2313,16 +2315,16 @@ static void mlx5_ldev_add_netdev(struct mlx5_lag *ldev,
 				struct mlx5_core_dev *dev,
 				struct net_device *netdev)
 {
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	unsigned long flags;
 	int i;
 
 	spin_lock_irqsave(&lag_lock, flags);
-	/* Find pf entry by matching dev pointer */
+	/* Find fn entry by matching dev pointer */
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (pf->dev == dev) {
-			pf->netdev = netdev;
+		fn = mlx5_lag_fn(ldev, i);
+		if (fn->dev == dev) {
+			fn->netdev = netdev;
 			ldev->tracker.netdev_state[i].link_up = 0;
 			ldev->tracker.netdev_state[i].tx_enabled = 0;
 			break;
@@ -2334,15 +2336,15 @@ static void mlx5_ldev_add_netdev(struct mlx5_lag *ldev,
 static void mlx5_ldev_remove_netdev(struct mlx5_lag *ldev,
 				    struct net_device *netdev)
 {
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	unsigned long flags;
 	int i;
 
 	spin_lock_irqsave(&lag_lock, flags);
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (pf->netdev == netdev) {
-			pf->netdev = NULL;
+		fn = mlx5_lag_fn(ldev, i);
+		if (fn->netdev == netdev) {
+			fn->netdev = NULL;
 			break;
 		}
 	}
@@ -2353,37 +2355,37 @@ int mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
 		       struct mlx5_core_dev *dev,
 		       u32 group_id)
 {
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	u32 idx;
 	int err;
 
-	pf = kzalloc_obj(*pf);
-	if (!pf)
+	fn = kzalloc_obj(*fn);
+	if (!fn)
 		return -ENOMEM;
 
-	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, U8_MAX - 1),
+	err = xa_alloc(&ldev->fns, &idx, fn, XA_LIMIT(0, U8_MAX - 1),
 		       GFP_KERNEL);
 	if (err) {
-		kfree(pf);
+		kfree(fn);
 		return err;
 	}
 
-	/* max_funcs is the iteration ceiling; grow it, never shrink. */
-	if (idx >= ldev->max_funcs)
-		ldev->max_funcs = idx + 1;
-	pf->idx = idx;
-	pf->dev = dev;
-	pf->group_id = group_id;
+	/* max_fns is the iteration ceiling; grow it, never shrink. */
+	if (idx >= ldev->max_fns)
+		ldev->max_fns = idx + 1;
+	fn->idx = idx;
+	fn->dev = dev;
+	fn->group_id = group_id;
 	dev->priv.lag = ldev;
 
 	if (group_id)
 		return 0;
 
-	xa_set_mark(&ldev->pfs, idx, MLX5_LAG_XA_MARK_PORT);
+	xa_set_mark(&ldev->fns, idx, MLX5_LAG_XA_MARK_PORT);
 
-	MLX5_NB_INIT(&pf->port_change_nb,
+	MLX5_NB_INIT(&fn->port_change_nb,
 		     mlx5_lag_mpesw_port_change_event, PORT_CHANGE);
-	mlx5_eq_notifier_register(dev, &pf->port_change_nb);
+	mlx5_eq_notifier_register(dev, &fn->port_change_nb);
 
 	return 0;
 }
@@ -2391,24 +2393,24 @@ int mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
 void mlx5_ldev_remove_mdev(struct mlx5_lag *ldev,
 			   struct mlx5_core_dev *dev)
 {
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int i;
 
 	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (pf->dev == dev)
+		fn = mlx5_lag_fn(ldev, i);
+		if (fn->dev == dev)
 			break;
 	}
-	if (i >= ldev->max_funcs)
+	if (i >= ldev->max_fns)
 		return;
 
-	if (pf->port_change_nb.nb.notifier_call)
-		mlx5_eq_notifier_unregister(dev, &pf->port_change_nb);
+	if (fn->port_change_nb.nb.notifier_call)
+		mlx5_eq_notifier_unregister(dev, &fn->port_change_nb);
 
-	pf->dev = NULL;
+	fn->dev = NULL;
 	dev->priv.lag = NULL;
-	xa_erase(&ldev->pfs, pf->idx);
-	kfree(pf);
+	xa_erase(&ldev->fns, fn->idx);
+	kfree(fn);
 }
 
 /* Must be called with HCA devcom component lock held */
@@ -2584,18 +2586,18 @@ void mlx5_lag_add_netdev(struct mlx5_core_dev *dev,
 int mlx5_get_pre_lag_func(struct mlx5_lag *ldev, int start_idx, int end_idx,
 			  u32 filter)
 {
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int i;
 
 	for (i = start_idx; i >= end_idx; i--) {
-		pf = xa_load(&ldev->pfs, i);
-		if (!pf || !pf->dev)
+		fn = xa_load(&ldev->fns, i);
+		if (!fn || !fn->dev)
 			continue;
 		if (filter == MLX5_LAG_FILTER_PORTS) {
-			if (xa_get_mark(&ldev->pfs, i, MLX5_LAG_XA_MARK_PORT))
+			if (xa_get_mark(&ldev->fns, i, MLX5_LAG_XA_MARK_PORT))
 				return i;
 		} else if (filter == MLX5_LAG_FILTER_ALL ||
-			   filter == pf->group_id) {
+			   filter == fn->group_id) {
 			return i;
 		}
 	}
@@ -2604,25 +2606,25 @@ int mlx5_get_pre_lag_func(struct mlx5_lag *ldev, int start_idx, int end_idx,
 
 int mlx5_get_next_lag_func(struct mlx5_lag *ldev, int start_idx, u32 filter)
 {
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	unsigned long idx;
 
 	if (filter == MLX5_LAG_FILTER_PORTS) {
-		xa_for_each_marked_start(&ldev->pfs, idx, pf,
+		xa_for_each_marked_start(&ldev->fns, idx, fn,
 					 MLX5_LAG_XA_MARK_PORT, start_idx)
-			if (pf->dev)
+			if (fn->dev)
 				return idx;
-		return ldev->max_funcs;
+		return ldev->max_fns;
 	}
 
-	xa_for_each_start(&ldev->pfs, idx, pf, start_idx) {
-		if (!pf->dev)
+	xa_for_each_start(&ldev->fns, idx, fn, start_idx) {
+		if (!fn->dev)
 			continue;
 		if (filter == MLX5_LAG_FILTER_ALL ||
-		    filter == pf->group_id)
+		    filter == fn->group_id)
 			return idx;
 	}
-	return ldev->max_funcs;
+	return ldev->max_fns;
 }
 
 bool mlx5_lag_is_roce(struct mlx5_core_dev *dev)
@@ -2676,7 +2678,7 @@ bool mlx5_lag_is_master(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
 	unsigned long flags;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	bool res = false;
 	int idx;
 
@@ -2690,8 +2692,8 @@ bool mlx5_lag_is_master(struct mlx5_core_dev *dev)
 							   filter);
 		if ((__mlx5_lag_is_active(ldev) ||
 		     __mlx5_lag_is_sd_active(ldev, dev)) && idx >= 0) {
-			pf = mlx5_lag_pf(ldev, idx);
-			res = pf && dev == pf->dev;
+			fn = mlx5_lag_fn(ldev, idx);
+			res = fn && dev == fn->dev;
 		}
 	}
 	spin_unlock_irqrestore(&lag_lock, flags);
@@ -2754,7 +2756,7 @@ void mlx5_lag_disable_change(struct mlx5_core_dev *dev)
 	struct mlx5_devcom_comp_dev *sd_devcom = mlx5_sd_get_devcom(dev);
 	struct mlx5_core_dev *primary = dev;
 	struct mlx5_lag *ldev;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	bool mpesw;
 	int i;
 
@@ -2793,9 +2795,9 @@ void mlx5_lag_disable_change(struct mlx5_core_dev *dev)
 	mlx5_devcom_comp_lock(sd_devcom);
 	mutex_lock(&ldev->lock);
 	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (pf->dev == dev && pf->sd_fdb_active) {
-			mlx5_lag_shared_fdb_destroy(ldev, pf->group_id);
+		fn = mlx5_lag_fn(ldev, i);
+		if (fn->dev == dev && fn->sd_fdb_active) {
+			mlx5_lag_shared_fdb_destroy(ldev, fn->group_id);
 			break;
 		}
 	}
@@ -2822,7 +2824,7 @@ u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
 {
 	struct mlx5_lag *ldev;
 	unsigned long flags;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	u8 port = 0;
 	int i;
 
@@ -2832,8 +2834,8 @@ u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
 		goto unlock;
 
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (pf->netdev == slave) {
+		fn = mlx5_lag_fn(ldev, i);
+		if (fn->netdev == slave) {
 			port = i;
 			break;
 		}
@@ -2864,7 +2866,7 @@ struct mlx5_core_dev *mlx5_lag_get_next_peer_mdev(struct mlx5_core_dev *dev, int
 	struct mlx5_core_dev *peer_dev = NULL;
 	struct mlx5_lag *ldev;
 	unsigned long flags;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int idx;
 
 	spin_lock_irqsave(&lag_lock, flags);
@@ -2872,22 +2874,22 @@ struct mlx5_core_dev *mlx5_lag_get_next_peer_mdev(struct mlx5_core_dev *dev, int
 	if (!ldev)
 		goto unlock;
 
-	if (*i == ldev->max_funcs)
+	if (*i == ldev->max_fns)
 		goto unlock;
 	mlx5_lag_for_each(idx, *i, ldev, mlx5_lag_get_filter(ldev, dev)) {
-		pf = mlx5_lag_pf(ldev, idx);
-		if (pf->dev != dev)
+		fn = mlx5_lag_fn(ldev, idx);
+		if (fn->dev != dev)
 			break;
 	}
 
-	if (idx == ldev->max_funcs) {
+	if (idx == ldev->max_fns) {
 		*i = idx;
 		goto unlock;
 	}
 	*i = idx + 1;
 
-	pf = mlx5_lag_pf(ldev, idx);
-	peer_dev = pf->dev;
+	fn = mlx5_lag_fn(ldev, idx);
+	peer_dev = fn->dev;
 
 unlock:
 	spin_unlock_irqrestore(&lag_lock, flags);
@@ -2905,7 +2907,7 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 	int ret = 0, i, j, idx = 0;
 	struct mlx5_lag *ldev;
 	unsigned long flags;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int num_ports;
 	void *out;
 
@@ -2926,8 +2928,8 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 	if (ldev && __mlx5_lag_is_active(ldev)) {
 		num_ports = ldev->ports;
 		mlx5_ldev_for_each(i, 0, ldev) {
-			pf = mlx5_lag_pf(ldev, i);
-			mdev[idx++] = pf->dev;
+			fn = mlx5_lag_fn(ldev, i);
+			mdev[idx++] = fn->dev;
 		}
 	} else {
 		num_ports = 1;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 479d9f42ff3f..cbe380ae8bf9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -51,7 +51,7 @@ enum mlx5_lag_mode {
 	MLX5_LAG_MODE_MPESW,
 };
 
-struct lag_func {
+struct lag_fn {
 	struct mlx5_core_dev *dev;
 	struct net_device    *netdev;
 	bool has_drop;
@@ -83,13 +83,13 @@ struct mlx5_lag {
 	unsigned long		  mode_flags;
 	unsigned long		  state_flags;
 	u8			  ports;
-	u8			  max_funcs;
+	u8			  max_fns;
 	u8			  buckets;
 	bool			  virt_lag;
 	int			  mode_changes_in_progress;
 	u8			  *v2p_map;
 	struct kref               ref;
-	struct xarray             pfs;
+	struct xarray             fns;
 	struct lag_tracker        tracker;
 	struct workqueue_struct   *wq;
 	struct delayed_work       bond_work;
@@ -109,44 +109,44 @@ mlx5_lag_dev(struct mlx5_core_dev *dev)
 	return dev->priv.lag;
 }
 
-static inline struct lag_func *
-mlx5_lag_pf(struct mlx5_lag *ldev, unsigned int idx)
+static inline struct lag_fn *
+mlx5_lag_fn(struct mlx5_lag *ldev, unsigned int idx)
 {
-	return xa_load(&ldev->pfs, idx);
+	return xa_load(&ldev->fns, idx);
 }
 
 /* Get device index (mlx5_get_dev_index) from xarray index */
 static inline int mlx5_lag_xa_to_dev_idx(struct mlx5_lag *ldev, int xa_idx)
 {
-	struct lag_func *pf = mlx5_lag_pf(ldev, xa_idx);
+	struct lag_fn *fn = mlx5_lag_fn(ldev, xa_idx);
 
-	return pf ? mlx5_get_dev_index(pf->dev) : -ENOENT;
+	return fn ? mlx5_get_dev_index(fn->dev) : -ENOENT;
 }
 
-/* Find lag_func by device index (reverse lookup from mlx5_get_dev_index) */
-static inline struct lag_func *
-mlx5_lag_pf_by_dev_idx(struct mlx5_lag *ldev, int dev_idx)
+/* Find lag_fn by device index (reverse lookup from mlx5_get_dev_index) */
+static inline struct lag_fn *
+mlx5_lag_fn_by_dev_idx(struct mlx5_lag *ldev, int dev_idx)
 {
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	unsigned long idx;
 
-	xa_for_each(&ldev->pfs, idx, pf) {
-		if (mlx5_get_dev_index(pf->dev) == dev_idx)
-			return pf;
+	xa_for_each(&ldev->fns, idx, fn) {
+		if (mlx5_get_dev_index(fn->dev) == dev_idx)
+			return fn;
 	}
 	return NULL;
 }
 
-/* Find lag_func by mlx5_core_dev pointer */
-static inline struct lag_func *
-mlx5_lag_pf_by_dev(struct mlx5_lag *ldev, struct mlx5_core_dev *dev)
+/* Find lag_fn by mlx5_core_dev pointer */
+static inline struct lag_fn *
+mlx5_lag_fn_by_dev(struct mlx5_lag *ldev, struct mlx5_core_dev *dev)
 {
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	unsigned long idx;
 
-	xa_for_each(&ldev->pfs, idx, pf) {
-		if (pf->dev == dev)
-			return pf;
+	xa_for_each(&ldev->fns, idx, fn) {
+		if (fn->dev == dev)
+			return fn;
 	}
 	return NULL;
 }
@@ -154,17 +154,17 @@ mlx5_lag_pf_by_dev(struct mlx5_lag *ldev, struct mlx5_core_dev *dev)
 static inline bool
 __mlx5_lag_is_sd(struct mlx5_lag *ldev, struct mlx5_core_dev *dev)
 {
-	struct lag_func *pf = mlx5_lag_pf_by_dev(ldev, dev);
+	struct lag_fn *fn = mlx5_lag_fn_by_dev(ldev, dev);
 
-	return pf && pf->group_id != 0;
+	return fn && fn->group_id != 0;
 }
 
 static inline bool
 __mlx5_lag_dev_is_port(struct mlx5_lag *ldev, struct mlx5_core_dev *dev)
 {
-	struct lag_func *pf = mlx5_lag_pf_by_dev(ldev, dev);
+	struct lag_fn *fn = mlx5_lag_fn_by_dev(ldev, dev);
 
-	return pf && xa_get_mark(&ldev->pfs, pf->idx, MLX5_LAG_XA_MARK_PORT);
+	return fn && xa_get_mark(&ldev->fns, fn->idx, MLX5_LAG_XA_MARK_PORT);
 }
 
 static inline bool
@@ -299,7 +299,7 @@ static inline bool mlx5_lag_is_supported(struct mlx5_core_dev *dev)
 #define mlx5_lag_for_each(i, start_index, ldev, filter) \
 	for (int tmp = start_index; \
 	     tmp = mlx5_get_next_lag_func(ldev, tmp, filter), \
-	     i = tmp, tmp < (ldev)->max_funcs; tmp++)
+	     i = tmp, tmp < (ldev)->max_fns; tmp++)
 
 #define mlx5_lag_for_each_reverse(i, start_index, end_index, ldev, filter) \
 	for (int tmp = start_index, tmp1 = end_index; \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index 2077fc5d80c7..587638278f34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -26,15 +26,15 @@ static bool mlx5_lag_multipath_check_prereq(struct mlx5_lag *ldev)
 	if (__mlx5_lag_is_active(ldev) && !__mlx5_lag_is_multipath(ldev))
 		return false;
 
-	if (mlx5_lag_is_sw_managed(mlx5_lag_pf(ldev, idx0)->dev) ||
-	    mlx5_lag_is_sw_managed(mlx5_lag_pf(ldev, idx1)->dev))
+	if (mlx5_lag_is_sw_managed(mlx5_lag_fn(ldev, idx0)->dev) ||
+	    mlx5_lag_is_sw_managed(mlx5_lag_fn(ldev, idx1)->dev))
 		return false;
 
 	if (ldev->ports > MLX5_LAG_MULTIPATH_OFFLOADS_SUPPORTED_PORTS)
 		return false;
 
-	return mlx5_esw_multipath_prereq(mlx5_lag_pf(ldev, idx0)->dev,
-					 mlx5_lag_pf(ldev, idx1)->dev);
+	return mlx5_esw_multipath_prereq(mlx5_lag_fn(ldev, idx0)->dev,
+					 mlx5_lag_fn(ldev, idx1)->dev);
 }
 
 bool mlx5_lag_is_multipath(struct mlx5_core_dev *dev)
@@ -59,11 +59,15 @@ static void mlx5_lag_set_port_affinity(struct mlx5_lag *ldev,
 {
 	int idx0 = mlx5_lag_get_dev_index_by_seq(ldev, MLX5_LAG_P1);
 	int idx1 = mlx5_lag_get_dev_index_by_seq(ldev, MLX5_LAG_P2);
+	struct mlx5_core_dev *dev0, *dev1;
 	struct lag_tracker tracker = {};
 
 	if (idx0 < 0 || idx1 < 0 || !__mlx5_lag_is_multipath(ldev))
 		return;
 
+	dev0 = mlx5_lag_fn(ldev, idx0)->dev;
+	dev1 = mlx5_lag_fn(ldev, idx1)->dev;
+
 	switch (port) {
 	case MLX5_LAG_NORMAL_AFFINITY:
 		tracker.netdev_state[idx0].tx_enabled = true;
@@ -84,18 +88,17 @@ static void mlx5_lag_set_port_affinity(struct mlx5_lag *ldev,
 		tracker.netdev_state[idx1].link_up = true;
 		break;
 	default:
-		mlx5_core_warn(mlx5_lag_pf(ldev, idx0)->dev,
-			       "Invalid affinity port %d", port);
+		mlx5_core_warn(dev0, "Invalid affinity port %d", port);
 		return;
 	}
 
 	if (tracker.netdev_state[idx0].tx_enabled)
-		mlx5_notifier_call_chain(mlx5_lag_pf(ldev, idx0)->dev->priv.events,
+		mlx5_notifier_call_chain(dev0->priv.events,
 					 MLX5_DEV_EVENT_PORT_AFFINITY,
 					 (void *)0);
 
 	if (tracker.netdev_state[idx1].tx_enabled)
-		mlx5_notifier_call_chain(mlx5_lag_pf(ldev, idx1)->dev->priv.events,
+		mlx5_notifier_call_chain(dev1->priv.events,
 					 MLX5_DEV_EVENT_PORT_AFFINITY,
 					 (void *)0);
 
@@ -150,7 +153,7 @@ mlx5_lag_get_next_fib_dev(struct mlx5_lag *ldev,
 		fib_dev = fib_info_nh(fi, i)->fib_nh_dev;
 		ldev_idx = mlx5_lag_dev_get_netdev_idx(ldev, fib_dev);
 		if (ldev_idx >= 0)
-			return mlx5_lag_pf(ldev, ldev_idx)->netdev;
+			return mlx5_lag_fn(ldev, ldev_idx)->netdev;
 	}
 
 	return NULL;
@@ -182,7 +185,7 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev, unsigned long event,
 	    mp->fib.dst_len <= fen_info->dst_len &&
 	    !(mp->fib.dst_len == fen_info->dst_len &&
 	      fi->fib_priority < mp->fib.priority)) {
-		mlx5_core_dbg(mlx5_lag_pf(ldev, idx)->dev,
+		mlx5_core_dbg(mlx5_lag_fn(ldev, idx)->dev,
 			      "Multipath entry with lower priority was rejected\n");
 		return;
 	}
@@ -198,7 +201,7 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev, unsigned long event,
 	}
 
 	if (nh_dev0 == nh_dev1) {
-		mlx5_core_warn(mlx5_lag_pf(ldev, idx)->dev,
+		mlx5_core_warn(mlx5_lag_fn(ldev, idx)->dev,
 			       "Multipath offload doesn't support routes with multiple nexthops of the same device");
 		return;
 	}
@@ -207,7 +210,7 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev, unsigned long event,
 		if (__mlx5_lag_is_active(ldev)) {
 			mlx5_ldev_for_each(i, 0, ldev) {
 				dev_idx++;
-				if (mlx5_lag_pf(ldev, i)->netdev == nh_dev0)
+				if (mlx5_lag_fn(ldev, i)->netdev == nh_dev0)
 					break;
 			}
 			mlx5_lag_set_port_affinity(ldev, dev_idx);
@@ -244,7 +247,7 @@ static void mlx5_lag_fib_nexthop_event(struct mlx5_lag *ldev,
 	/* nh added/removed */
 	if (event == FIB_EVENT_NH_DEL) {
 		mlx5_ldev_for_each(i, 0, ldev) {
-			if (mlx5_lag_pf(ldev, i)->netdev == fib_nh->fib_nh_dev)
+			if (mlx5_lag_fn(ldev, i)->netdev == fib_nh->fib_nh_dev)
 				break;
 			dev_idx++;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 56faa1d498c7..6e3bef276611 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -16,7 +16,7 @@ static void mlx5_mpesw_metadata_cleanup(struct mlx5_lag *ldev)
 	int i;
 
 	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
-		dev = mlx5_lag_pf(ldev, i)->dev;
+		dev = mlx5_lag_fn(ldev, i)->dev;
 		esw = dev->priv.eswitch;
 		pf_metadata = ldev->lag_mpesw.pf_metadata[i];
 		if (!pf_metadata)
@@ -37,7 +37,7 @@ static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
 	int i, err;
 
 	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
-		dev = mlx5_lag_pf(ldev, i)->dev;
+		dev = mlx5_lag_fn(ldev, i)->dev;
 		esw = dev->priv.eswitch;
 		pf_metadata = mlx5_esw_match_metadata_alloc(esw);
 		if (!pf_metadata) {
@@ -53,7 +53,7 @@ static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
 	}
 
 	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
-		dev = mlx5_lag_pf(ldev, i)->dev;
+		dev = mlx5_lag_fn(ldev, i)->dev;
 		mlx5_notifier_call_chain(dev->priv.events, MLX5_DEV_EVENT_MULTIPORT_ESW,
 					 (void *)0);
 	}
@@ -67,14 +67,14 @@ static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
 
 static void mlx5_mpesw_restore_sd_fdb(struct mlx5_lag *ldev)
 {
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int err, i;
 
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		err = mlx5_lag_shared_fdb_create(ldev, NULL, 0, pf->group_id);
+		fn = mlx5_lag_fn(ldev, i);
+		err = mlx5_lag_shared_fdb_create(ldev, NULL, 0, fn->group_id);
 		if (err)
-			mlx5_core_warn(pf->dev,
+			mlx5_core_warn(fn->dev,
 				       "Failed to restore SD shared FDB (%d)\n",
 				       err);
 	}
@@ -82,26 +82,26 @@ static void mlx5_mpesw_restore_sd_fdb(struct mlx5_lag *ldev)
 
 static int mlx5_mpesw_teardown_sd_fdb(struct mlx5_lag *ldev)
 {
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int i;
 
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (!pf->sd_fdb_active)
+		fn = mlx5_lag_fn(ldev, i);
+		if (!fn->sd_fdb_active)
 			continue;
-		mlx5_lag_shared_fdb_destroy(ldev, pf->group_id);
+		mlx5_lag_shared_fdb_destroy(ldev, fn->group_id);
 	}
 	return 0;
 }
 
 static bool mlx5_lag_has_sd_group(struct mlx5_lag *ldev)
 {
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int i;
 
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (pf->group_id)
+		fn = mlx5_lag_fn(ldev, i);
+		if (fn->group_id)
 			return true;
 	}
 	return false;
@@ -155,7 +155,7 @@ static int mlx5_lag_enable_mpesw(struct mlx5_lag *ldev)
 		goto err_clear_master;
 	}
 
-	dev0 = mlx5_lag_pf(ldev, idx)->dev;
+	dev0 = mlx5_lag_fn(ldev, idx)->dev;
 	valid = ldev->virt_lag ? mlx5_virt_mpesw_validate(ldev, dev0) :
 		mlx5_phys_mpesw_validate(ldev, dev0);
 	if (!valid) {
@@ -212,7 +212,7 @@ void mlx5_mpesw_sd_devcoms_lock(struct mlx5_lag *ldev)
 	int i;
 
 	mlx5_ldev_for_each(i, 0, ldev) {
-		sd_devcom = mlx5_sd_get_devcom(mlx5_lag_pf(ldev, i)->dev);
+		sd_devcom = mlx5_sd_get_devcom(mlx5_lag_fn(ldev, i)->dev);
 		if (sd_devcom)
 			mlx5_devcom_comp_lock(sd_devcom);
 	}
@@ -223,8 +223,8 @@ void mlx5_mpesw_sd_devcoms_unlock(struct mlx5_lag *ldev)
 	struct mlx5_devcom_comp_dev *sd_devcom;
 	int i;
 
-	mlx5_ldev_for_each_reverse(i, ldev->max_funcs, 0, ldev) {
-		sd_devcom = mlx5_sd_get_devcom(mlx5_lag_pf(ldev, i)->dev);
+	mlx5_ldev_for_each_reverse(i, ldev->max_fns, 0, ldev) {
+		sd_devcom = mlx5_sd_get_devcom(mlx5_lag_fn(ldev, i)->dev);
 		if (sd_devcom)
 			mlx5_devcom_comp_unlock(sd_devcom);
 	}
@@ -348,10 +348,10 @@ int mlx5_lag_mpesw_port_change_event(struct notifier_block *nb,
 				     unsigned long event, void *data)
 {
 	struct mlx5_nb *mlx5_nb = container_of(nb, struct mlx5_nb, nb);
-	struct lag_func *lag_func = container_of(mlx5_nb,
-						 struct lag_func,
+	struct lag_fn *lag_fn = container_of(mlx5_nb,
+						 struct lag_fn,
 						 port_change_nb);
-	struct mlx5_core_dev *dev = lag_func->dev;
+	struct mlx5_core_dev *dev = lag_fn->dev;
 	struct mlx5_lag *ldev = dev->priv.lag;
 	struct mlx5_eqe *eqe = data;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
index 2a034b2a3eee..183e18910095 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
@@ -50,7 +50,7 @@ static int mlx5_lag_create_port_sel_table(struct mlx5_lag *ldev,
 	if (first_idx < 0)
 		return -EINVAL;
 
-	dev = mlx5_lag_pf(ldev, first_idx)->dev;
+	dev = mlx5_lag_fn(ldev, first_idx)->dev;
 	ft_attr.max_fte = ldev->ports * ldev->buckets;
 	ft_attr.level = MLX5_LAG_FT_LEVEL_DEFINER;
 
@@ -79,6 +79,7 @@ static int mlx5_lag_create_port_sel_table(struct mlx5_lag *ldev,
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
 	mlx5_ldev_for_each(i, 0, ldev) {
 		for (j = 0; j < ldev->buckets; j++) {
+			struct mlx5_core_dev *mdev;
 			u8 affinity;
 
 			idx = i * ldev->buckets + j;
@@ -87,9 +88,8 @@ static int mlx5_lag_create_port_sel_table(struct mlx5_lag *ldev,
 			/* affinity is 1-indexed device index,
 			 * use reverse lookup.
 			 */
-			dest.vport.vhca_id =
-				MLX5_CAP_GEN(mlx5_lag_pf_by_dev_idx(ldev, affinity - 1)->dev,
-					     vhca_id);
+			mdev = mlx5_lag_fn_by_dev_idx(ldev, affinity - 1)->dev;
+			dest.vport.vhca_id = MLX5_CAP_GEN(mdev, vhca_id);
 			lag_definer->rules[idx] = mlx5_add_flow_rules(lag_definer->ft,
 								      NULL, &flow_act,
 								      &dest, 1);
@@ -311,7 +311,7 @@ mlx5_lag_create_definer(struct mlx5_lag *ldev, enum netdev_lag_hash hash,
 	if (first_idx < 0)
 		return ERR_PTR(-EINVAL);
 
-	dev = mlx5_lag_pf(ldev, first_idx)->dev;
+	dev = mlx5_lag_fn(ldev, first_idx)->dev;
 	lag_definer = kzalloc_obj(*lag_definer);
 	if (!lag_definer)
 		return ERR_PTR(-ENOMEM);
@@ -360,7 +360,7 @@ static void mlx5_lag_destroy_definer(struct mlx5_lag *ldev,
 	if (first_idx < 0)
 		return;
 
-	dev = mlx5_lag_pf(ldev, first_idx)->dev;
+	dev = mlx5_lag_fn(ldev, first_idx)->dev;
 	mlx5_ldev_for_each(i, 0, ldev) {
 		for (j = 0; j < ldev->buckets; j++) {
 			idx = i * ldev->buckets + j;
@@ -524,7 +524,7 @@ static int mlx5_lag_create_ttc_table(struct mlx5_lag *ldev)
 	if (first_idx < 0)
 		return -EINVAL;
 
-	dev = mlx5_lag_pf(ldev, first_idx)->dev;
+	dev = mlx5_lag_fn(ldev, first_idx)->dev;
 	mlx5_lag_set_outer_ttc_params(ldev, &ttc_params);
 	port_sel->outer.ttc = mlx5_create_ttc_table(dev, &ttc_params);
 	return PTR_ERR_OR_ZERO(port_sel->outer.ttc);
@@ -540,7 +540,7 @@ static int mlx5_lag_create_inner_ttc_table(struct mlx5_lag *ldev)
 	if (first_idx < 0)
 		return -EINVAL;
 
-	dev = mlx5_lag_pf(ldev, first_idx)->dev;
+	dev = mlx5_lag_fn(ldev, first_idx)->dev;
 	mlx5_lag_set_inner_ttc_params(ldev, &ttc_params);
 	port_sel->inner.ttc = mlx5_create_inner_ttc_table(dev, &ttc_params);
 	return PTR_ERR_OR_ZERO(port_sel->inner.ttc);
@@ -594,6 +594,9 @@ static int __mlx5_lag_modify_definers_destinations(struct mlx5_lag *ldev,
 
 	mlx5_ldev_for_each(i, 0, ldev) {
 		for (j = 0; j < ldev->buckets; j++) {
+			struct mlx5_core_dev *mdev;
+			u8 affinity;
+
 			idx = i * ldev->buckets + j;
 			if (ldev->v2p_map[idx] == ports[idx])
 				continue;
@@ -601,9 +604,9 @@ static int __mlx5_lag_modify_definers_destinations(struct mlx5_lag *ldev,
 			/* ports[] contains 1-indexed device indices,
 			 * use reverse lookup.
 			 */
-			dest.vport.vhca_id =
-				MLX5_CAP_GEN(mlx5_lag_pf_by_dev_idx(ldev, ports[idx] - 1)->dev,
-					     vhca_id);
+			affinity = ports[idx];
+			mdev = mlx5_lag_fn_by_dev_idx(ldev, affinity - 1)->dev;
+			dest.vport.vhca_id = MLX5_CAP_GEN(mdev, vhca_id);
 			err = mlx5_modify_rule_destination(def->rules[idx], &dest, NULL);
 			if (err)
 				return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
index 29048b0c2797..404278a15ef7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
@@ -19,11 +19,11 @@ bool mlx5_lag_shared_fdb_supported_filter(struct mlx5_lag *ldev, u32 filter)
 	if (idx < 0)
 		return false;
 
-	dev0 = mlx5_lag_pf(ldev, idx)->dev;
+	dev0 = mlx5_lag_fn(ldev, idx)->dev;
 	mlx5_lag_for_each(i, 0, ldev, filter) {
 		if (i == idx)
 			continue;
-		dev = mlx5_lag_pf(ldev, i)->dev;
+		dev = mlx5_lag_fn(ldev, i)->dev;
 		if (is_mdev_switchdev_mode(dev) &&
 		    mlx5_eswitch_vport_match_metadata_enabled(dev->priv.eswitch) &&
 		    MLX5_CAP_GEN(dev, lag_native_fdb_selection) &&
@@ -59,7 +59,7 @@ static int mlx5_lag_create_single_fdb_filter(struct mlx5_lag *ldev, u32 filter)
 	if (master_idx < 0)
 		return -EINVAL;
 
-	dev0 = mlx5_lag_pf(ldev, master_idx)->dev;
+	dev0 = mlx5_lag_fn(ldev, master_idx)->dev;
 	master_esw = dev0->priv.eswitch;
 	mlx5_lag_for_each(i, 0, ldev, filter) {
 		struct mlx5_eswitch *slave_esw;
@@ -67,11 +67,11 @@ static int mlx5_lag_create_single_fdb_filter(struct mlx5_lag *ldev, u32 filter)
 		if (i == master_idx)
 			continue;
 
-		slave_esw = mlx5_lag_pf(ldev, i)->dev->priv.eswitch;
+		slave_esw = mlx5_lag_fn(ldev, i)->dev->priv.eswitch;
 
 		err = mlx5_eswitch_offloads_single_fdb_add_one(master_esw,
 							       slave_esw,
-							       ldev->max_funcs);
+							       ldev->max_fns);
 		if (err)
 			goto err;
 	}
@@ -82,7 +82,7 @@ static int mlx5_lag_create_single_fdb_filter(struct mlx5_lag *ldev, u32 filter)
 
 		if (j == master_idx)
 			continue;
-		slave_esw = mlx5_lag_pf(ldev, j)->dev->priv.eswitch;
+		slave_esw = mlx5_lag_fn(ldev, j)->dev->priv.eswitch;
 		mlx5_eswitch_offloads_single_fdb_del_one(master_esw, slave_esw);
 	}
 	return err;
@@ -101,7 +101,7 @@ int mlx5_lag_create_vport_lag(struct mlx5_lag *ldev, u32 group_id)
 	if (master_idx < 0)
 		return -EINVAL;
 
-	dev0 = mlx5_lag_pf(ldev, master_idx)->dev;
+	dev0 = mlx5_lag_fn(ldev, master_idx)->dev;
 	master_esw = dev0->priv.eswitch;
 
 	mlx5_lag_for_each(i, 0, ldev, filter) {
@@ -110,7 +110,7 @@ int mlx5_lag_create_vport_lag(struct mlx5_lag *ldev, u32 group_id)
 		if (i == master_idx)
 			continue;
 
-		slave_esw = mlx5_lag_pf(ldev, i)->dev->priv.eswitch;
+		slave_esw = mlx5_lag_fn(ldev, i)->dev->priv.eswitch;
 		err = mlx5_eswitch_offloads_vport_lag_add_one(master_esw,
 							      slave_esw);
 		if (err)
@@ -125,7 +125,7 @@ int mlx5_lag_create_vport_lag(struct mlx5_lag *ldev, u32 group_id)
 
 		if (j == master_idx)
 			continue;
-		slave_esw = mlx5_lag_pf(ldev, j)->dev->priv.eswitch;
+		slave_esw = mlx5_lag_fn(ldev, j)->dev->priv.eswitch;
 		mlx5_eswitch_offloads_vport_lag_del_one(master_esw, slave_esw);
 	}
 	return err;
@@ -143,7 +143,7 @@ int mlx5_lag_destroy_vport_lag(struct mlx5_lag *ldev, u32 group_id)
 	if (master_idx < 0)
 		return 0;
 
-	dev0 = mlx5_lag_pf(ldev, master_idx)->dev;
+	dev0 = mlx5_lag_fn(ldev, master_idx)->dev;
 	master_esw = dev0->priv.eswitch;
 
 	mlx5_lag_for_each(i, 0, ldev, filter) {
@@ -151,7 +151,7 @@ int mlx5_lag_destroy_vport_lag(struct mlx5_lag *ldev, u32 group_id)
 
 		if (i == master_idx)
 			continue;
-		dev = mlx5_lag_pf(ldev, i)->dev;
+		dev = mlx5_lag_fn(ldev, i)->dev;
 		mlx5_eswitch_offloads_vport_lag_del_one(master_esw,
 							dev->priv.eswitch);
 	}
@@ -170,12 +170,12 @@ static void mlx5_lag_destroy_single_fdb_filter(struct mlx5_lag *ldev,
 	if (master_idx < 0)
 		return;
 
-	master_esw = mlx5_lag_pf(ldev, master_idx)->dev->priv.eswitch;
+	master_esw = mlx5_lag_fn(ldev, master_idx)->dev->priv.eswitch;
 	mlx5_lag_for_each(i, 0, ldev, filter) {
 		if (i == master_idx)
 			continue;
 
-		peer_esw = mlx5_lag_pf(ldev, i)->dev->priv.eswitch;
+		peer_esw = mlx5_lag_fn(ldev, i)->dev->priv.eswitch;
 		mlx5_eswitch_offloads_single_fdb_del_one(master_esw, peer_esw);
 	}
 }
@@ -214,14 +214,14 @@ int mlx5_lag_shared_fdb_create(struct mlx5_lag *ldev,
 	int idx = mlx5_lag_get_dev_index_by_seq_filter(ldev, MLX5_LAG_P1,
 						       filter);
 	struct mlx5_core_dev *dev0;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int err;
 	int i;
 
 	if (idx < 0)
 		return -EINVAL;
 
-	dev0 = mlx5_lag_pf(ldev, idx)->dev;
+	dev0 = mlx5_lag_fn(ldev, idx)->dev;
 
 	mlx5_lag_remove_devices_filter(ldev, filter);
 
@@ -242,8 +242,8 @@ int mlx5_lag_shared_fdb_create(struct mlx5_lag *ldev,
 			goto err_add_devices;
 		}
 		mlx5_lag_for_each(i, 0, ldev, filter) {
-			pf = mlx5_lag_pf(ldev, i);
-			pf->sd_fdb_active = true;
+			fn = mlx5_lag_fn(ldev, i);
+			fn->sd_fdb_active = true;
 		}
 		BLOCKING_INIT_NOTIFIER_HEAD(&dev0->priv.lag_nh);
 	}
@@ -265,8 +265,8 @@ int mlx5_lag_shared_fdb_create(struct mlx5_lag *ldev,
 		mlx5_deactivate_lag(ldev);
 	} else {
 		mlx5_lag_for_each(i, 0, ldev, filter) {
-			pf = mlx5_lag_pf(ldev, i);
-			pf->sd_fdb_active = false;
+			fn = mlx5_lag_fn(ldev, i);
+			fn->sd_fdb_active = false;
 		}
 		mlx5_lag_destroy_single_fdb_filter(ldev, group_id);
 		mlx5_lag_unload_reps_from_locked(ldev, filter);
@@ -280,7 +280,7 @@ int mlx5_lag_shared_fdb_create(struct mlx5_lag *ldev,
 void mlx5_lag_shared_fdb_destroy(struct mlx5_lag *ldev, u32 group_id)
 {
 	u32 filter = group_id ? group_id : MLX5_LAG_FILTER_ALL;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int err;
 	int i;
 
@@ -292,8 +292,8 @@ void mlx5_lag_shared_fdb_destroy(struct mlx5_lag *ldev, u32 group_id)
 			return;
 	} else {
 		mlx5_lag_for_each(i, 0, ldev, filter) {
-			pf = mlx5_lag_pf(ldev, i);
-			pf->sd_fdb_active = false;
+			fn = mlx5_lag_fn(ldev, i);
+			fn->sd_fdb_active = false;
 		}
 		mlx5_lag_destroy_single_fdb_filter(ldev, group_id);
 		mlx5_lag_unload_reps_from_locked(ldev, filter);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
index 4cdc50cd6f03..f843efbca660 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
@@ -300,7 +300,7 @@ static int sd_lag_state_show(struct seq_file *file, void *priv)
 {
 	struct mlx5_core_dev *dev = file->private;
 	struct mlx5_lag *ldev;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	bool active = false;
 	int i;
 
@@ -310,9 +310,9 @@ static int sd_lag_state_show(struct seq_file *file, void *priv)
 
 	mutex_lock(&ldev->lock);
 	mlx5_ldev_for_each(i, 0, ldev) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (pf->dev == dev) {
-			active = pf->sd_fdb_active;
+		fn = mlx5_lag_fn(ldev, i);
+		if (fn->dev == dev) {
+			active = fn->sd_fdb_active;
 			break;
 		}
 	}
@@ -334,7 +334,7 @@ static void sd_lag_init(struct mlx5_core_dev *dev)
 	struct mlx5_sd *sd = mlx5_get_sd(primary);
 	struct mlx5_core_dev *pos, *to;
 	struct mlx5_lag *ldev;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int err;
 	int i;
 
@@ -346,14 +346,14 @@ static void sd_lag_init(struct mlx5_core_dev *dev)
 	}
 
 	mutex_lock(&ldev->lock);
-	pf = mlx5_lag_pf_by_dev(ldev, primary);
-	if (!pf) {
+	fn = mlx5_lag_fn_by_dev(ldev, primary);
+	if (!fn) {
 		sd_warn(primary, "%s: primary not registered in ldev, skipping\n",
 			__func__);
 		goto out;
 	}
 
-	pf->group_id = sd->group_id;
+	fn->group_id = sd->group_id;
 
 	mlx5_sd_for_each_secondary(i, primary, pos) {
 		err = mlx5_ldev_add_mdev(ldev, pos, sd->group_id);
@@ -372,7 +372,7 @@ static void sd_lag_init(struct mlx5_core_dev *dev)
 	to = pos;
 	mlx5_sd_for_each_secondary_to(i, primary, to, pos)
 		mlx5_ldev_remove_mdev(ldev, pos);
-	pf->group_id = 0;
+	fn->group_id = 0;
 	mutex_unlock(&ldev->lock);
 }
 
@@ -381,7 +381,7 @@ static void sd_lag_cleanup(struct mlx5_core_dev *dev)
 	struct mlx5_core_dev *primary = mlx5_sd_get_primary(dev);
 	struct mlx5_core_dev *pos;
 	struct mlx5_lag *ldev;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int i;
 
 	ldev = mlx5_lag_dev(primary);
@@ -392,9 +392,9 @@ static void sd_lag_cleanup(struct mlx5_core_dev *dev)
 	mlx5_sd_for_each_secondary(i, primary, pos)
 		mlx5_ldev_remove_mdev(ldev, pos);
 
-	pf = mlx5_lag_pf_by_dev(ldev, primary);
-	if (pf)
-		pf->group_id = 0;
+	fn = mlx5_lag_fn_by_dev(ldev, primary);
+	if (fn)
+		fn->group_id = 0;
 	mutex_unlock(&ldev->lock);
 }
 
@@ -989,7 +989,7 @@ static void mlx5_sd_activate_shared_fdb(struct mlx5_core_dev *primary)
 	struct mlx5_sd *sd = mlx5_get_sd(primary);
 	struct mlx5_core_dev *pos;
 	struct mlx5_lag *ldev;
-	struct lag_func *pf;
+	struct lag_fn *fn;
 	int err;
 	int i;
 
@@ -1009,8 +1009,8 @@ static void mlx5_sd_activate_shared_fdb(struct mlx5_core_dev *primary)
 
 	/* Check if SD FDB is already active for this group */
 	mlx5_lag_for_each(i, 0, ldev, sd->group_id) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (pf->sd_fdb_active)
+		fn = mlx5_lag_fn(ldev, i);
+		if (fn->sd_fdb_active)
 			goto unlock;
 		break;
 	}
-- 
2.44.0

