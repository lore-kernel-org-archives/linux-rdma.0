Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011050.outbound.protection.outlook.com [52.101.62.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7C824BBEB;
	Sun,  6 Sep 2026 09:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788685673; cv=fail; b=kVoWCIRhNHyP0jEcUaqaZ7iZW4T6kWTu7oN8hlB31qGVjvTRiaxCk5W8Of4THgPImD4xN1sad1bQvmSF1nEQzrmk/QIz+31yP3tFu4pvDy6+bDjtmX65G+3y1he2xIK8Pk3FfI7A4uGXRsn8PdpjGxjr8E1aj5pjXKVRiUM6YP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788685673; c=relaxed/simple;
	bh=S56FIvfRoTxSQPGu3xtXNNGQv/CBziH9iyvp7pd5jkU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ck6e5fw1gcSimXq9qcBxXkC9kQ283aE7v6MRmhKm6vbtoUTdPENeLDdRccze5Cna2JJR+9eqKsmX1lOkZzl15sZhZ6t+1yGSnUc5rDh6EpQja5iegoA3Ig0B5GA5noAI5aOA6Z9IyDCZT5ePqA77Ian8PWrL1E9A3wJIjL/GRKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BM1Mddto; arc=fail smtp.client-ip=52.101.62.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BM1Mddto"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gwh//Aaem3TljcjQp3IXx7/5KglyJrw9s72aN9RYsBawavhuqqQG1ZQYxtWVPJp1UcKUNeSJ6n9tfWtKn8nuYXJjJss/ck7C+dH2zBsXzywFOEF5s8WvmvDUkNI81Ib+GA5y1wWGt3f8z+UH9EadrY9c6LziEW1qc8ZhZKYbD9DBB73aGTfnq3sq33VfOCbkS2EJVcBoZvPzYJ+iO5EaEILXg5RuEr3vC1w0Ry4JyhCIsKoJSD7c06c0lc/Wnlh7aAhVxNhgQ/lNCvrgMsQE90gjMkaaOqQCPgJ0wF+x5ym6oqmM2x15NG4C2B2+IyDWonJBLorOvNXaPo0KrxrWMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mfmPGrRBGB7WtJ4qSWVrKoADviagbeCzOwl4y0oEl0=;
 b=PqC5kOAvvuKRDI1kFiNO77xTthmVxivZPhDnSul5SeFG+COmcunZLUQSvk3jRUbcOsZbXfXUpaeIT872T/qIkUYfVyaHKm487IAUzxJ8lecEsnG5xzlxPRAIGFlRPWUGE1SSkSelmYhmn18+fWdoxRrkqae2hHRBpacC1uygcRZHOorXg6vEGYNgRwAuHs+/5/s4Jgeox4F6ExN31Lpl5Dr4u/UHuow2hQKLLrhsuYqrIcram4Oc1g99ql6nAXNzD7VkrPv0/FeK3xoVrskUnEGeTHKbKExur2LwhZCLvvQdSHV49LBa1zlhvgmqiglh22QGoXbAPg1XVzXJ9gSatA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mfmPGrRBGB7WtJ4qSWVrKoADviagbeCzOwl4y0oEl0=;
 b=BM1Mddtoo7KTP7JztY8fvt0drsYnRRZNVNI1BSjvP3ILvfYlGZjWDgoQJKhrAcvm8JQXsa686JTcPim92PkOMPR9+0C6g3Spr0KaKlNhkZQVO0pBesawMCxZWuLlmBz2MvobwBSqc/97sNbLCCEUmnvU9rRibrlsN9Uw/ICbiB3HnOH4NhR3AtjTQadsuMXiMEPcO5hVQzJkxHAEDF7ilGqqvs2MVrwME/iEBx1xbXCLpHp8PCSW0+ZFst47wC3p6+fZGGjrY88CafI6aRWQpEqTI3SpsnTuiVB1NbqHc6s6nuafbjnqlmsRZWKwKZk68pEGpZ9iLh5Y63/ZePmDsg==
Received: from SJ0PR13CA0029.namprd13.prod.outlook.com (2603:10b6:a03:2c0::34)
 by MW4PR12MB5643.namprd12.prod.outlook.com (2603:10b6:303:188::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.14; Sun, 6 Sep
 2026 09:07:43 +0000
Received: from SJ1PEPF000037AA.namprd03.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::d) by SJ0PR13CA0029.outlook.office365.com
 (2603:10b6:a03:2c0::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.6 via Frontend Transport; Sun, 6
 Sep 2026 09:07:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037AA.mail.protection.outlook.com (10.167.244.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Sun, 6 Sep 2026 09:07:42 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 6 Sep
 2026 02:07:29 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 6 Sep
 2026 02:07:28 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Sun, 6 Sep
 2026 02:07:24 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Maher Sanalla
	<msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net V2] net/mlx5e: Move representor vnic reporter to eswitch devlink port
Date: Sun, 6 Sep 2026 12:07:00 +0300
Message-ID: <20260906090700.3761260-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037AA:EE_|MW4PR12MB5643:EE_
X-MS-Office365-Filtering-Correlation-Id: 7867ac1d-767b-4d70-89a4-08df0bf64f45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|82310400026|376014|10067099003|6133799003|18002099003|56012099006|11063799006|13003099007;
X-Microsoft-Antispam-Message-Info:
	fvN9m5CMUFXYLA0D3+xZvsZ2UCg3mIdk2vKODG+25EzP7/Ak3j2jg6APSzANIhMCrK1Qd62Qx+PNjPLhIb64gxvjuyCI+/DPHVR1m8up8wrPLkduRRGXfRMDMPfn+cQGc8INQpTFCH7MGZDAbpJsMLlc6k9K7vSRsHMbZNJRkIlXikFV5EaEekvhjGrIdefbQDq4aN53lwdQ2oOtKGAt88hEwFeB/eb4i66BA6FPzRfeWTyflc644oMXNbI2ljsNJARdueuYQcA66u6OZ5Zim25w2WmrrFkaztMVjZnje8FSqUXC3Z5XPETf+grveyoSRWZQJHwCgqSu4RZAYpSsOUvEsVVvImTdXuSOIsyqamdzBWwQyzCzWtl+wnzZ3YS/JXXGLDMqN40IMFXaxyInTgH2NVtvMMYbMYp0hXQ8nkT2zbTyihCRbxM/8TxP61YJ3vRxpWrS2SDtagh+7Z2iJZmtAlKuvG5bxPyC/CGL8aR8iLY4pgPCAYJ/v6nPL1WR/EjDnEs/z3SsbRKsgL7BLmUorE8w2O6tLwEVVzL5ax4FzlR0LxRRu7zM2Mr377B8JRdxFEKU2GhSlnzwUPDp7BqJPB+5AHaOuLvYlzANq86Gb7V49EhpiHWJVcs0HJuo0esZOG20NNT1TD9n0NHKteey6XoKLe7EeY7N7h3ar07d8QWQPIIvxeQdRTIrAgp0MPrwUQt4MEMCxJEFRvjM2w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(82310400026)(376014)(10067099003)(6133799003)(18002099003)(56012099006)(11063799006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	s1jaX9sddX2fbjHlDAPGTglLOob6rmdgB0EdeogKk1800csO5Z9WtD3XasD0ttnspeFL4dTxsdgGomkxbnUhDewBjs/MRhuWuzU7SSXVVGYuik48B9GYGJ4B5zV2NvyrIxopNkhRMVDgFpm2FAEWqqsdpiJSr218ozWaDJboFQAvPpOmVISoWxoKIagxIpZB1gmPB+aX/kkjBFwbtmhrao0l795JSSCrJHHbIJiNhE2b2604pqQiy/GrD65JxNFPzDJE6Y9rcVaJX9EXDk8+eKtQcGEbwCfwZcot+nGihXGBV2d4USWvDtUUssOKEYBjiva5ockxibi1dIFi2d1L9t/3vFa8GvedtSnHdzw+hFBSJ9SXaTyIzbupo5Ua/XVda8Pl1VEQeV7dZ8Lue+kDyH0XWoEAOOjTqjKR/Qi6dVrh72oaWKTdaSpSe0PDlzvi
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 09:07:42.8241
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7867ac1d-767b-4d70-89a4-08df0bf64f45
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037AA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5643

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

Move the reporter's lifecycle to the eswitch devlink port (un)register
paths, which are already serialized by the devlink instance lock, and
store the handle on mlx5_devlink_port. Use the port's mlx5_vport as the
reporter priv since the diagnose callback only needs a device handle and
a vport number, and mlx5_vport carries both and is initialized before
any representor driver probes.

Fixes: cf14af140a5a ("net/mlx5e: Add vnic devlink health reporter to representors")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 52 +------------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  1 -
 .../mellanox/mlx5/core/esw/devlink_port.c     | 37 +++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 4 files changed, 39 insertions(+), 52 deletions(-)

V2:
Use mlx5_vport instead of mlx5_eswitch_rep as the reporter private data.

V1:
https://lore.kernel.org/all/20260729070059.2421788-1-tariqt@nvidia.com/

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index ce765692fd19..88a170e40bd9 100644
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
@@ -1439,51 +1438,6 @@ static unsigned int mlx5e_ul_rep_stats_grps_num(struct mlx5e_priv *priv)
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
@@ -1607,10 +1561,8 @@ mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 
 	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch,
 						 rpriv->rep->vport);
-	if (!IS_ERR(dl_port)) {
+	if (!IS_ERR(dl_port))
 		SET_NETDEV_DEVLINK_PORT(netdev, dl_port);
-		mlx5e_rep_vnic_reporter_create(priv, dl_port);
-	}
 
 	err = register_netdev(netdev);
 	if (err) {
@@ -1623,7 +1575,6 @@ mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	return 0;
 
 err_detach_netdev:
-	mlx5e_rep_vnic_reporter_destroy(priv);
 	mlx5e_detach_netdev(netdev_priv(netdev));
 err_cleanup_profile:
 	priv->profile->cleanup(priv);
@@ -1681,7 +1632,6 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
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
index 36b00a856bc2..fdc960ea5331 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -4,6 +4,26 @@
 #include <linux/mlx5/driver.h>
 #include "eswitch.h"
 #include "devlink.h"
+#include "diag/reporter_vnic.h"
+
+static int
+mlx5_esw_rep_vnic_reporter_diagnose(struct devlink_health_reporter *reporter,
+				    struct devlink_fmsg *fmsg,
+				    struct netlink_ext_ack *extack)
+{
+	struct mlx5_vport *vport = devlink_health_reporter_priv(reporter);
+
+	mlx5_reporter_vnic_diagnose_counters(vport->dev, fmsg, vport->vport,
+					     true);
+
+	return 0;
+}
+
+static const
+struct devlink_health_reporter_ops mlx5_esw_rep_vnic_reporter_ops = {
+	.name = "vnic",
+	.diagnose = mlx5_esw_rep_vnic_reporter_diagnose,
+};
 
 static void
 mlx5_esw_get_port_parent_id(struct mlx5_core_dev *dev, struct netdev_phys_item_id *ppid)
@@ -220,6 +240,7 @@ static void mlx5_esw_devlink_port_res_unregister(struct devlink_port *dl_port)
 
 int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 {
+	struct devlink_health_reporter *reporter;
 	struct mlx5_core_dev *dev = esw->dev;
 	const struct devlink_port_ops *ops;
 	struct mlx5_devlink_port *dl_port;
@@ -255,6 +276,16 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, struct mlx
 		mlx5_core_dbg(dev, "Failed to register port resources: %d\n",
 			      err);
 
+	reporter = devl_port_health_reporter_create(
+		&dl_port->dl_port, &mlx5_esw_rep_vnic_reporter_ops,
+		vport);
+	if (IS_ERR(reporter))
+		mlx5_core_err(dev,
+			      "Failed to create vnic health reporter for vport %d: %pe\n",
+			      vport_num, reporter);
+	else
+		dl_port->vnic_reporter = reporter;
+
 	return 0;
 
 rate_err:
@@ -269,6 +300,12 @@ void mlx5_esw_offloads_devlink_port_unregister(struct mlx5_vport *vport)
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
 
 	devl_rate_leaf_destroy(&dl_port->dl_port);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index c655f6e8da1c..8b1f93b13ea9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -189,6 +189,7 @@ struct mlx5_vport;
 struct mlx5_devlink_port {
 	struct devlink_port dl_port;
 	struct mlx5_vport *vport;
+	struct devlink_health_reporter *vnic_reporter;
 };
 
 static inline void mlx5_devlink_port_init(struct mlx5_devlink_port *dl_port,

base-commit: 2b4707a149a55e8fa75c9ef32b359d60f470a566
-- 
2.44.0

