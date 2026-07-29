Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010058.outbound.protection.outlook.com [52.101.193.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62BB3BA222;
	Wed, 29 Jul 2026 07:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785308502; cv=fail; b=AlfvhE1HT069d+iuSp0F8wQKUkMWP+6LJgH/YdbqEwFgZdkR01nvE7201Hsi32GXE2XRroQT6A6T5dvU+Jyqu5u+2Ktey+KAT7XVchr9+hkHMrXHToT+4+RMnGclSb19kc6YkLuDuRiwn//ynXUlLUZ3YhD5fdkuK5xXkyOY/rk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785308502; c=relaxed/simple;
	bh=96y5cnL8as+Yo4SFl1KAlbI//SOkoi3WG/f3R8VQE7w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Vn3vqPhEKnycL36zj2fWDVzdwTyTyJRHCYPNKNM+40wjUvVsm9/6kiERrEW2U3OjZvPXj6XI2xxD0tBJjb1TTtRyFMLnIwe4UUw9Ov58aZmLejObM2AgYFsee+J7aGh9yW/es2K+hZ/LnwHY2iV+Pe7pqqAZ1EcdMAfNvCW7he0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D7c7py8d; arc=fail smtp.client-ip=52.101.193.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D7c7py8d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kr7XyELbw132SYBgelHf34u47v6FKIgis+sqwZEEB4dY+WwgHqTQgZ0z8HCSeVJY8NNEUqGiO4niatyqqImD03wDTYQ7O4znRGZc4dK4M2cHD8SFOueGyxm6k+anF+ga1fL7nSPYazCG4svMfZ9t14x4uD3dYRW+yV02l7eD5pzqLFjZUUn2n0bQ39C0kb/fVCores39vXyEwp6en9qwftqXPwpILzJO2fXy0IBZSUUWrQ85mXEfHQ6sbzrpHtcVBjLg90anMfY6s4iQFm2w3d+1N1uCWo8InWWn9yvxaXMQLc7nM7EJ47AH1kLgdDjJdCEnLP7jTODq1BqyfkrfAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dY8mM6ruS9EdeUEljka9Cg6jxu3/B6UH0g5GOkFHEBk=;
 b=j2n3DmZcGqsUwl9EP1tGoFhi/HYhs3Tv3t0wpJ6gsY5Jx+NLQpu1/DkQZu8bSVlXgBoV1VowyIskrb3aZKIUP5NWl25Iu25pQh1mOKwlkY4heFwxAlYu7Z+Z1mPP5f/H6oVi/9fTf0yr+cmWhFNWV6j0L45foRpW7oLgtLEUaW4wHZ0w4ht28yAoAsirVu1y9QhIxQEtdgOcU/TQC1Cm8W0jtDFt9gkKVqZnyX95r+U45gsDUIuJqlWt9l5ivuyfZb2gelWISZMxbmYmacP+RAWdwNkWGKK5LfH3ZTfkGx4M9hS0/Xmyn/YwcK870BhSuTJxSLlq9TXl6ROkwlSJaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dY8mM6ruS9EdeUEljka9Cg6jxu3/B6UH0g5GOkFHEBk=;
 b=D7c7py8d/Kc7alRUfQ3vNTHkK7zwCyo2w1YG3GkuQgWNbNhWTDJgbiXwWMGKKjHrPjp32f6xhfZLkl8oLCIwp1TqT2SPpcOAuXrhAfNCPTXdpMJPXPLgxzklyMsvYIXjAWmEHUwa1PEe6T8FRom4/yucA0+5f4owm/tJzeS0Sdcy15PNhB/uLHV1wCfcPoNcATx6v5ID2Vuh/PDWovCxtRvwfw8q7vWXHMMWSbiGuTs3XGpw2jbfx5vEKyG8oklDiobd0gnDFB5xM1xBc64V4Tfz+haSYx2j2vyto8A4TzmGpASaKosmWpnoRHB6FXgrKv15vZx6AA8WbSp1WwrGxA==
Received: from DS7P220CA0091.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:25a::10) by
 CH1PPFDB1826343.namprd12.prod.outlook.com (2603:10b6:61f:fc00::628) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 07:01:32 +0000
Received: from DS1PEPF00017096.namprd05.prod.outlook.com
 (2603:10b6:8:25a:cafe::9e) by DS7P220CA0091.outlook.office365.com
 (2603:10b6:8:25a::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.13 via Frontend Transport; Wed,
 29 Jul 2026 07:01:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF00017096.mail.protection.outlook.com (10.167.18.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Wed, 29 Jul 2026 07:01:31 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 29 Jul
 2026 00:01:17 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 29 Jul
 2026 00:01:15 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Wed, 29
 Jul 2026 00:01:10 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Adithya Jayachandran <ajayachandra@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Jurgens
	<danielj@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jiri Pirko
	<jiri@resnulli.us>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Maher Sanalla <msanalla@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Parav Pandit <parav@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Simon Horman
	<horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: Move representor vnic reporter to eswitch devlink port
Date: Wed, 29 Jul 2026 10:00:59 +0300
Message-ID: <20260729070059.2421788-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017096:EE_|CH1PPFDB1826343:EE_
X-MS-Office365-Filtering-Correlation-Id: edd48c47-416d-42cd-b121-08deed3f385f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|23010399003|1800799024|82310400026|6133799003|56012099006|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	3qSRBeTKsGNnst+7m8w4RNWGlzMOUYkmbQsMPNHxtn0p0iRrX6dhhRqBl7gamKONlKY+LjoZ8KfAVTp+Aru2l9u0KzUKuJPy2AWeeWUF9rJgKD0G5KJSO9LBAjg3G6rs/qZZc16A1zAcAYMM2nnQVoVBQ23trns2h5r74nEk+pAGhwuJ/juc3nHRZM8OGq7mBkQwu5qFDoPNpUunysVMCiLtybiqVyYLqYUz7Jc1Kxcv+vqf8wmAd4cJezfBr6x/AlJTmISxlsTdl9rlaqwuC+URTYbabUO2KAtKaV0j236J4ZXPtIhC4ZnyHFdw5Ndrm3TYhECZjtjWZvJhGuCEjvU8X6M1HvUmr8Rh6adpoEGkXYS/YR8jvTfdWqmeemLMDfVfa45vO6DqUPPZ0MKeJ7WR6CP8T3DL140eYDtCRFymOVILbOYlX3WHlkabgJPigSGlYeGCEGq3oli2JODwoMobq0fp+YtNwbOBVys9UhdCN/hZmMmyzUNW0AQ/7tybmXrlwh+rlMMUfaPegen4V+1KVjqCoRQxIqfsuzRjWCtTWJGNMkygUfT/Lyb+cAWAO4P/lmnhUrHQLFn1gUfoA/iBHVonIduxLDIkJRimvxh0QB7bd68h73zR4ed6UacKcGNaDz1tXi3aiCp7pcGQXcNgwRdt00BXkCuWlcv9v8QKVP6HmvQcZvMQOnWvtbB0azW4YXVlZGFKFmYMscNUmQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(23010399003)(1800799024)(82310400026)(6133799003)(56012099006)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DEqQdjOjeT+Cnh/L9K1mHcg7+qJNwrxY7mZ4y4wxBauLg4wQrVj0y7seAQyOlHRivGTfWRe/FwvjdEE9hVMqyZruUr7zL33MWY0og+WXP9Bb+UGIJyouPbcaGXXeLWZwMX5X7hdtPUNS1gwM/LzZ39VXaweXcY+oV1Qk4KmaI2PUCqnp4qiXzO7VI3LOOJBzS1FATAGnfionSS7cVxeTiHbBY6vamwZHIvWdaHornABFRmEJBvwjzllU3OGBpktZJm0j6psnJKIb3QJmM7k9Sv3PliOZC4c7/oxX9oeNPLSjARwv44SPbIw+Lp0TFMcf3up9dakSmJYxyGigy4YCAtAlgPJyy+ativoC3Idk1yR2YYi155fTGYLpb/aObxTrVLHuEbgFLsK4TFCy7AF6Q0AKl+2DTixDFnhXcFMQCahTA7nQ6d2h5Vz3x9dRrHpY
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 07:01:31.6247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: edd48c47-416d-42cd-b121-08deed3f385f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017096.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFDB1826343

From: Carolina Jubran <cjubran@nvidia.com>

The representor vnic devlink health reporter is created and destroyed
along the representor netdev (un)load path, which is not serialized by
the devlink instance lock. Destroying the reporter from there triggers
a devl_assert_locked() splat on driver unbind:
  WARNING: net/devlink/core.c:259 at devl_assert_locked+0x54/0x70, CPU#2: bash/3758
  Modules linked in: mlx5_vdpa vringh vdpa mlx5_ib mlx5_fwctl mlx5_core ...
  CPU: 2 UID: 0 PID: 3758 Comm: bash Tainted: G        W           6.19.0+ #1 PREEMPT
  Tainted: [W]=WARN
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), ...
  RIP: 0010:devl_assert_locked+0x54/0x70
  Call Trace:
   <TASK>
   devl_health_reporter_destroy+0x3a/0x1b0
   mlx5e_vport_rep_unload+0x12d/0x2b0 [mlx5_core]
   mlx5_eswitch_unregister_vport_reps+0x1b8/0x220 [mlx5_core]
   ? __esw_offloads_unload_rep+0x190/0x190 [mlx5_core]
   ? kernfs_remove_by_name_ns+0xc3/0xf0
   device_release_driver_internal+0x3b2/0x560
   unbind_store+0xce/0xf0

Move the reporter's lifecycle to the eswitch devlink port
(un)register paths and store the handle on mlx5_devlink_port. The
reporter is logically tied to the eswitch port, and its diagnose
callback only uses mlx5_eswitch_rep, so pass the rep directly as the
reporter priv.

Fixes: cf14af140a5a ("net/mlx5e: Add vnic devlink health reporter to representors")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 52 +------------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  1 -
 .../mellanox/mlx5/core/esw/devlink_port.c     | 39 ++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 4 files changed, 41 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index c8b76d301c92..783c76953e95 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -56,7 +56,6 @@
 #include "lib/vxlan.h"
 #define CREATE_TRACE_POINTS
 #include "diag/en_rep_tracepoint.h"
-#include "diag/reporter_vnic.h"
 #include "en_accel/ipsec.h"
 #include "en/tc/int_port.h"
 #include "en/ptp.h"
@@ -1425,51 +1424,6 @@ static unsigned int mlx5e_ul_rep_stats_grps_num(struct mlx5e_priv *priv)
 	return ARRAY_SIZE(mlx5e_ul_rep_stats_grps);
 }
 
-static int
-mlx5e_rep_vnic_reporter_diagnose(struct devlink_health_reporter *reporter,
-				 struct devlink_fmsg *fmsg,
-				 struct netlink_ext_ack *extack)
-{
-	struct mlx5e_rep_priv *rpriv = devlink_health_reporter_priv(reporter);
-	struct mlx5_eswitch_rep *rep = rpriv->rep;
-
-	mlx5_reporter_vnic_diagnose_counters(rep->esw->dev, fmsg, rep->vport,
-					     true);
-	return 0;
-}
-
-static const struct devlink_health_reporter_ops mlx5_rep_vnic_reporter_ops = {
-	.name = "vnic",
-	.diagnose = mlx5e_rep_vnic_reporter_diagnose,
-};
-
-static void mlx5e_rep_vnic_reporter_create(struct mlx5e_priv *priv,
-					   struct devlink_port *dl_port)
-{
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
-	struct devlink_health_reporter *reporter;
-
-	reporter = devl_port_health_reporter_create(dl_port,
-						    &mlx5_rep_vnic_reporter_ops,
-						    rpriv);
-	if (IS_ERR(reporter)) {
-		mlx5_core_err(priv->mdev,
-			      "Failed to create representor vnic reporter, err = %pe\n",
-			      reporter);
-		return;
-	}
-
-	rpriv->rep_vnic_reporter = reporter;
-}
-
-static void mlx5e_rep_vnic_reporter_destroy(struct mlx5e_priv *priv)
-{
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
-
-	if (!IS_ERR_OR_NULL(rpriv->rep_vnic_reporter))
-		devl_health_reporter_destroy(rpriv->rep_vnic_reporter);
-}
-
 static const struct mlx5e_profile mlx5e_rep_profile = {
 	.init			= mlx5e_init_rep,
 	.cleanup		= mlx5e_cleanup_rep,
@@ -1593,10 +1547,8 @@ mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 
 	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch,
 						 rpriv->rep->vport);
-	if (!IS_ERR(dl_port)) {
+	if (!IS_ERR(dl_port))
 		SET_NETDEV_DEVLINK_PORT(netdev, dl_port);
-		mlx5e_rep_vnic_reporter_create(priv, dl_port);
-	}
 
 	err = register_netdev(netdev);
 	if (err) {
@@ -1609,7 +1561,6 @@ mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	return 0;
 
 err_detach_netdev:
-	mlx5e_rep_vnic_reporter_destroy(priv);
 	mlx5e_detach_netdev(netdev_priv(netdev));
 err_cleanup_profile:
 	priv->profile->cleanup(priv);
@@ -1667,7 +1618,6 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	}
 
 	unregister_netdev(netdev);
-	mlx5e_rep_vnic_reporter_destroy(priv);
 	mlx5e_detach_netdev(priv);
 	priv->profile->cleanup(priv);
 	mlx5e_destroy_netdev(netdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 70640fa1ad7b..bcd7b4e814d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -118,7 +118,6 @@ struct mlx5e_rep_priv {
 	struct rtnl_link_stats64 prev_vf_vport_stats;
 	struct mlx5_flow_handle *send_to_vport_meta_rule;
 	struct rhashtable tc_ht;
-	struct devlink_health_reporter *rep_vnic_reporter;
 };
 
 static inline
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 6e50311faa27..46f110170fb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -4,6 +4,27 @@
 #include <linux/mlx5/driver.h>
 #include "eswitch.h"
 #include "devlink.h"
+#include "mlx5_core.h"
+#include "diag/reporter_vnic.h"
+
+static int
+mlx5_esw_rep_vnic_reporter_diagnose(struct devlink_health_reporter *reporter,
+				    struct devlink_fmsg *fmsg,
+				    struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch_rep *rep = devlink_health_reporter_priv(reporter);
+
+	mlx5_reporter_vnic_diagnose_counters(rep->esw->dev, fmsg, rep->vport,
+					     true);
+
+	return 0;
+}
+
+static const struct
+devlink_health_reporter_ops mlx5_esw_rep_vnic_reporter_ops = {
+	.name = "vnic",
+	.diagnose = mlx5_esw_rep_vnic_reporter_diagnose,
+};
 
 static void
 mlx5_esw_get_port_parent_id(struct mlx5_core_dev *dev, struct netdev_phys_item_id *ppid)
@@ -217,9 +238,11 @@ static void mlx5_esw_devlink_port_res_unregister(struct devlink_port *dl_port)
 
 int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 {
+	struct devlink_health_reporter *reporter;
 	struct mlx5_core_dev *dev = esw->dev;
 	const struct devlink_port_ops *ops;
 	struct mlx5_devlink_port *dl_port;
+	struct mlx5_eswitch_rep *rep;
 	u16 vport_num = vport->vport;
 	unsigned int dl_port_index;
 	struct devlink *devlink;
@@ -252,6 +275,16 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, struct mlx
 		mlx5_core_dbg(dev, "Failed to register port resources: %d\n",
 			      err);
 
+	rep = mlx5_eswitch_vport_rep(esw, vport_num);
+	reporter = devl_port_health_reporter_create(
+		&dl_port->dl_port, &mlx5_esw_rep_vnic_reporter_ops, rep);
+	if (IS_ERR(reporter))
+		mlx5_core_dbg(dev,
+			      "Failed to create vnic health reporter for vport %d: %pe\n",
+			      vport_num, reporter);
+	else
+		dl_port->vnic_reporter = reporter;
+
 	return 0;
 
 rate_err:
@@ -266,6 +299,12 @@ void mlx5_esw_offloads_devlink_port_unregister(struct mlx5_vport *vport)
 	if (!vport->dl_port)
 		return;
 	dl_port = vport->dl_port;
+
+	if (dl_port->vnic_reporter) {
+		devl_health_reporter_destroy(dl_port->vnic_reporter);
+		dl_port->vnic_reporter = NULL;
+	}
+
 	mlx5_esw_devlink_port_res_unregister(&dl_port->dl_port);
 
 	mlx5_esw_qos_vport_update_parent(vport, NULL, NULL);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index fea72b1dedab..e8817d45763a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -189,6 +189,7 @@ struct mlx5_vport;
 struct mlx5_devlink_port {
 	struct devlink_port dl_port;
 	struct mlx5_vport *vport;
+	struct devlink_health_reporter *vnic_reporter;
 };
 
 static inline void mlx5_devlink_port_init(struct mlx5_devlink_port *dl_port,

base-commit: 3bd438a58e910db5dc369aa25dfed1fc95f1b596
-- 
2.44.0

