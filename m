Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010062.outbound.protection.outlook.com [52.101.46.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1194E343882;
	Sun,  4 Oct 2026 07:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791097408; cv=fail; b=upfthgdc/23WpfYKR/N/TbQYgc+z8ZUsRQhr0l3uEiSVBkYni3pqBi+MpQtn/+qzdwliMRQxGn9nHBDv2Zb0XZs7+gHOVdyZHJsPkHULMPbcJhedDS2EYafBr75m43QJw632Aku4xawVP1vRdRGttPx9zJzpvIC+XvBulOVEZiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791097408; c=relaxed/simple;
	bh=tXZuHzojybCB974khQD8xw6dUxEKxS/1+bwjNhRcKt0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TRP4+dCVYaooi/4gak7RvxsMezxV71Kq7/DE4Fwz45qx5savfCVQ2T2BNHDtItTRSE4LCjdhZvd1YM/EWchhzEJynAlPKNRAfxbJ07a3HGARsFCNpTqXb9Ogl1MBKY+jr3DNvGua8jYMYQt6h4A69BKwfVJDhthu0sFZuSq+ZbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lXMP7lRA; arc=fail smtp.client-ip=52.101.46.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lXMP7lRA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u4JX1gBKSQDEXWgbpC/7trUXHtiNu2ksNud8w9uwdKeN7BonPdmklUmzxiCXni0Bc+jBUYqeTRBlDx0NKncPDrf/S9mogKGtDk54iY8qp7maa7D4+Yfdxs8mW9u5lDPCoJFNLF7wy+tRDc6VxIlzrjOcy1Bd5BnomMXmzyvGhJGr+H/Dd2lFjGe091On5kg1KLRwH6ldDZZH4xOs/VJHbFYwyGMBlnVsDtSX/5rdK4S1vAFMgr1q0q/mZwf/ZO+/GKKfKmke56WT2pIIpkFIis/cYjoqDPRYKAtGrIL+bmskSmnDp31GY9M6OJDouswPHHf49EY0Gd2wVfD7L7rQ5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W1k8DbcXGtYTCxGwgCb1HDKb6ZPwpPKAExj0xIGck5s=;
 b=I3N/qowTOj89Pun8uD7gdpU1euPmHyjwiuVdVRoAFb8yqjednrseez7kawPHOELaKfo/fsWVTKhwuMEDHV2cWcfsqUKgMtY5mAeJtmiKC6tO0mmd7Zv4r8RV2RoKTKneoJXYD/9J5AzcxVlkIq4yoZcSJ32K4NRTAAFMn4SMG0jo4WH9cv+Iz/s6gTOjsG4fYPGpweNMtsetx50+I11RKnYXZhsZtM15h4ynFZKALx6vOJznoS8IaAekH3uIjVqG7cWDFUiAoM0kiOYxmPWb1ePD48+NP3xVTQhv9Usa55l2LzvS2aFKUlsU1i/0CpEumJi/2Bd1r42g4kwGd06z2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1k8DbcXGtYTCxGwgCb1HDKb6ZPwpPKAExj0xIGck5s=;
 b=lXMP7lRAFDRu5axIj0/CTqrNbXu9R44Wla1U8AxoEwIuvtvFyphFCu00YkSwJ/pieadirH4/vy4/KOSHds4vk3zYmxb1jiipkJ/9LvbUec1BFSkibrgK7m15iURK52zswcQbNnbX7/Vadh9jORMPe3b8/O+WvWbgUc2fcW/b4Bj23gLk6Jb9spdSFMY7dCk4MFtRTCb3lJin7XoMHDC+mp3s3h3PQwhQ61zFCKRUV8noTwtM6kS9oDOmPyASz21JZnHOIbKbJSSmwotUyNBlRnwsFzGlgZnSjm1y6cHOvGL2PL7HReU7zIvQAZWiqbrmP2r8HA30U6N93adTjyi6UQ==
Received: from SA9P221CA0020.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::25)
 by IA1PR12MB7614.namprd12.prod.outlook.com (2603:10b6:208:429::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Sun, 4 Oct
 2026 07:03:22 +0000
Received: from SA2PEPF00003F63.namprd04.prod.outlook.com
 (2603:10b6:806:25:cafe::17) by SA9P221CA0020.outlook.office365.com
 (2603:10b6:806:25::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Sun, 4
 Oct 2026 07:03:22 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF00003F63.mail.protection.outlook.com (10.167.248.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Sun, 4 Oct 2026 07:03:21 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 4 Oct
 2026 00:03:07 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 00:03:06 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 00:03:03 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, "open
 list" <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark
 Bloch <mbloch@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5: Lag, only cache max_tx_speed that FW has not accepted
Date: Sun, 4 Oct 2026 10:02:46 +0300
Message-ID: <20261004070246.215239-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F63:EE_|IA1PR12MB7614:EE_
X-MS-Office365-Filtering-Correlation-Id: ada3027b-6600-415d-9e61-08df21e5939f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|376014|36860700016|10067099003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	PgmheJK1T+F5MbYj9Ps4WtaABfKlE9CVYOafnvuHcXnfxReFjbFbkgOjeu1HLuQpdNfX2X7YJWXId5mGem1zD3pNaPHFj+l9OJVzBZae4Kvf+JoZEzvVHevJjtuBye0buJN6enoEEeEd4aeU4Dvttfdl4k+rOKIwTvvGwfTBf8aw6m4k8L7A1pEvwLRTKhywGr39e5rLx8EZTd+yiY348JYLJJlonkSCfyZHUgjx5LVdJFirE8wV0ucE/JOCRpwAEQxu3nvvz257vdI108mCiykIkOS5GCA8aNyCwWnDyeb+QHLrUiIHRe7H3xTVHyG8tgLzhEgAYmYVsqLuobFNVlPRm//7J9i3ce/fJEuTEVk5+8tUFZzWrGb/2XJE5rniFJemSLApG/sn9wUgYQNS6+l1F8ge8Qps9TMJzldMOVQ1aVStCqhmBDdG/D2F/iE4pviD2DZGkh6fXDyf38GSDU+O8aQILDXG9pjxI5jCI8PPrz1XA/bh2KsI1N4b9NRzdhXQyGW4M6m3zvSj4p1Td19Gx89JKjnNowm5ii/21p09DNTKmHu9LZPZ4V0eHEivaJs8VfeB2Oy+s4XC5sRUTQzNytnKX8tobQEeDb9juNnUHHuWa0HnbQ1Auhx1ikOQpKrz65DDlRDfTnr4cgTXfkky/gwsQjyvQjhEfBEOqtGTbMwAy3DRFdj9tUBX7HiPSaHgmwHyBZvZdRWuC53tLQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(376014)(36860700016)(10067099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	t2YECOBgl7LOG0z136l/LqAyMNhD/kjJ4s2oESeziv+DxqipTRbX5yV2bExiraIyI7MagUZUmRKV2ESzuh/h+8EQLuZF2TL7gFvUegQG/rfRs3KpnV39sMHtCJzrpPSq6G2FB9Y+fOzDHY93g4529J/LA6jalqHPLK6jAxBS4HRXeAxGMPyV9yER5yCP57kbhs+9VQdaWCZitxiBIoxvT4qjhp3QUrtMKeQRCCYU5qwGtmf4CexrNAxuRb1D/bBMt4mQOGJiKJ+pPWHlsRF2mjOrt3sHOIhc/5Z8Jf/yuBS9G0d4rw6tb9mRRKhnNjxGJjk/dWfzdPhi3fON1UUyqHWg5/0C7kPOan31X3NxPH/rdWAySwlYb/fe2tjXLchNxAV61pgNSXRGbFWoutORhoC2vwBYAujIaWjQYdm3XR8v5gtuFwICmemEQYVPWn8W
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2026 07:03:21.6838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ada3027b-6600-415d-9e61-08df21e5939f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7614

From: Or Har-Toov <ohartoov@nvidia.com>

vport->agg_max_tx_speed caches a max_tx_speed that could not be pushed
to FW, to be applied by mlx5_esw_vport_enable() once the vport comes up.

mlx5_lag_modify_device_vports_speed() also wrote it for enabled vports,
unconditionally, before even attempting the FW push. If that push
failed, the cache still claimed speed had been applied, even though FW
might still hold the old value. That unconfirmed value could then leak
out: mlx5_esw_vport_enable() replays it if the vport is later disabled
and re-enabled with no LAG update in between.

Write the cache only where FW does not hold the value: when the vport
is disabled and cannot be modified, and when the push itself failed.
Clear it once FW has accepted the value, so a superseded speed is not
replayed over a newer one. A vport whose push succeeded therefore keeps
no cached speed, and relies on FW retaining the programmed value.

This was raised in the AI review of v1 of "net/mlx5: Lag, reset vport
speed on teardown". It is unrelated to that patch, so it is fixed here
separately.

Link: https://lore.kernel.org/all/20260915015118.875210-1-kuba@kernel.org/
Fixes: c6df9a65cbb0 ("net/mlx5: Skip disabled vports when setting max TX speed")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c |  2 ++
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 12 ++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index fc197d1dc9df..f8c220bf7b5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -951,6 +951,8 @@ static void mlx5_esw_vport_set_max_tx_speed(struct mlx5_eswitch *esw,
 		mlx5_core_dbg(esw->dev,
 			      "Failed to set vport %d speed %d, err=%d\n",
 			      vport->vport, vport->agg_max_tx_speed, ret);
+	else
+		vport->agg_max_tx_speed = 0;
 }
 
 int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 3b34bec559e0..7cee78cb47df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1502,17 +1502,21 @@ static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
 		if (vport->vport == MLX5_VPORT_UPLINK)
 			continue;
 
-		vport->agg_max_tx_speed = speed;
-
-		if (!vport->enabled)
+		if (!vport->enabled) {
+			vport->agg_max_tx_speed = speed;
 			continue;
+		}
 
 		ret = mlx5_modify_vport_max_tx_speed(mdev, op_mod,
 						     vport->vport, true, speed);
-		if (ret)
+		if (ret) {
 			mlx5_core_dbg(mdev,
 				      "Failed to set vport %d speed %d, err=%d\n",
 				      vport->vport, speed, ret);
+			vport->agg_max_tx_speed = speed;
+		} else {
+			vport->agg_max_tx_speed = 0;
+		}
 	}
 	mutex_unlock(&esw->state_lock);
 }

base-commit: 6dc989ea46b96ce170840174b4a38c4a387fb005
-- 
2.44.0

