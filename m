Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012028.outbound.protection.outlook.com [52.101.48.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AE5397E73;
	Sun, 11 Oct 2026 09:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791711552; cv=fail; b=A0R4BEGw1UEG3NPqUGZvASUPRgFWV8cGK4CYuUrrEN+DJS7u65QKO3adq1V7W4RComBptiAXHer0wzDir81TYp5y9dLoelylN5NtqMJ2w5pUXraL2uDtH8qvDt6QCQR6u+JCFwBXBbmsrRA/xihV1xikZLcCVPI0RR4Jce2X8zY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791711552; c=relaxed/simple;
	bh=FV3B0lirah8nsndCFxCEoKne2k1s5m8D4/RkVjC1HgM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mL1IuUVqv4BXxIx+/BXtIEOHJfLQE/k2pJ3ze9Cbh2J+8wMt6NC3XWjpVaGSlEyAnqPNNkIofFcFFDR65NkBmxv7nI5F20L2S9ob2RLxHD86xUcuxKlI2XlGAMh44/Wg2MJAdeLAlfYmI4LVLKIgAN8U1Uvgy/LyijxVViKbLT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DYHQBKql; arc=fail smtp.client-ip=52.101.48.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DYHQBKql"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jMljKKQHIeUADqSRi/aanENXCkzs8WtbMmcOQTEfQOgimtDuemnjKAdKQZxMkfGpyXPEmG6PsRT0gcQ3NXkjg9YjX7kcELjYd11iX/MThshqexdwFf2quDSF7n44qWNWtSOEjzDza4zj0hH5d7Vz6G/Pi7hSROk/9BEokxLOMKlKaODQv11lCfTa4BjdhwgkQCDfCG+VDoVdOS4qF96p1EYR5bQfmvIruXweQhTDThUqwsWvQDrbQ1+Dl6/gcOOYzCJYjC09dkyKmFSx28uHvdfQ5aRiNli+hxM0lWtjfqBmYDQwc2nhpJMuOcQZ8wB8KSSR2nZLZebm5y+Xra02sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wyZ60EjQsTkkahpdDLYn8k8+i9uNu2shgI2mbuPU/r8=;
 b=Arqe/YLMm9T0wG0xi2tPIYhqFAEe6KPz5x7WQ94AKS7g0iyXnnX3S80iZRKoRfakX0gOcHUYyf58Fj6Ad0nrXgfTgIzNt2rsB9ZIf86iEfiMJ6XnBK1G++hHrXzyypbWoL11HjjU54ynzLtA6jQOFBxh7+VmxuKxQVb7rD+Xc4MdEregE/jAdD7jgEltxkfVeQw0+n/MdcmtDq0qXhmkUDVgShJtgJDfqCip9qTLbPAhvBhqbzi+TXK45+k5cCa3+SLF8ZW0emaSePZqOb/qFS1SGCw2ltnPDUklqtQrdO0nh8rOnuSokxw0tDAUlcUbXiTo+vZqZWJ1ar3n3Rxjzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyZ60EjQsTkkahpdDLYn8k8+i9uNu2shgI2mbuPU/r8=;
 b=DYHQBKqlehGY+icwYvGKdFc5bIHTZYAV04yD57KEVaT/H/7nmeu6Q0CULuKb8HHSnV+96TuXeCKgbuAw+JdK/mMSl2fe29ATvfV945PqK99KzjpIkr/u6O4IH+3kvqwQCJFrRD9z09RbewtkCHU5oyreijkIe+gqL3xZgs4Dc9DaGGUfnqMCdusBmnLRLg9QshCArYgxP1vwUEsLXd239mQwYvyilbuuLzA7nK80stk5Bn5S6Lz9EKWafli129btdBZqkKhVcohm83zl44YX39R3scBX4gnZYAZ059Yfm66LTMMVF+jDJgSO/893vYG5mCfEz9Y7a+vvzY5SWa4+kA==
Received: from MW4PR04CA0232.namprd04.prod.outlook.com (2603:10b6:303:87::27)
 by BL3PR12MB6617.namprd12.prod.outlook.com (2603:10b6:208:38c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Sun, 11 Oct
 2026 09:39:06 +0000
Received: from CO1PEPF00012E81.namprd03.prod.outlook.com
 (2603:10b6:303:87:cafe::9e) by MW4PR04CA0232.outlook.office365.com
 (2603:10b6:303:87::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Sun, 11
 Oct 2026 09:39:05 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF00012E81.mail.protection.outlook.com (10.167.249.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Sun, 11 Oct 2026 09:39:05 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 02:38:57 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 02:38:57 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Sun, 11
 Oct 2026 02:38:51 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, "Cosmin
 Ratiu" <cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jiri Pirko
	<jiri@resnulli.us>, Jonathan Corbet <corbet@lwn.net>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	<linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Randy Dunlap
	<rdunlap@infradead.org>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next] net/mlx5: Remove max_external_SFs device resource
Date: Sun, 11 Oct 2026 12:38:28 +0300
Message-ID: <20261011093828.784454-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E81:EE_|BL3PR12MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d46c506-d1e1-4093-688b-08df277b7d9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|1800799024|376014|7416014|36860700016|6133799003|18002099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	uFoHAqm5YYSHN/H1HNHxjQbQU5hx4BflNYyK96LA5wPALE0aJc7gl6o31dcNZFkj+mlKDvxx5DM3ko1B1XSNuX2U7HMpULBRFYDyhFOciUW1q9l8CTzs7QjRsVbEjfiizngB+1bmG7PDGalJMom96UQ4fCzl+BhmHg8llOsvnLMiY+zFxuzMIVTtJPg0jlEEjmhQKGQn9nKbDiMIorOvj9vO78oqYfO6kHQyv7KNQaOMTMdAiqL3mMwCEkolV1bwB+xzK84UIz92RT4f4vHOS2B327INVglRSUIv/VzjI9bDjCh1PXEhnzULtUaLcoWJOc9m2QwAWX0F8A3ubQ3GFiRWPRqcdnf7TSOLpHJvz4lqYH2H1n4V13Q9fDCBYGFglktGsGwhVlYMek5K2p/ZXaa/hzYFf7YTh1BTuyjZREXbffWBprOgZnqcuMPGQwvlYHBL/ui1RxY8B6qQoHIWOgh9y/ycdgXUEuPcA4RXVdwsCvkPX27vy7j6boAvB3BTr6k79ve5J1F7q5vbujBifOP0lthF4akeEb4E4tLhBTHUBFmI9DjPTkzNfzjCM3OC1+uUkZytrzKd4++NZDnQDH0AJW+4oGlaudlE0vlN8rnmL2iHkiTMBYYTYBzVUmHUGyUGXSLIISxme5cRVCRnWuWz+xeXXfQ/qNPqomQWAJr4j7iUgUDk6vQHyCTkKZiivX2yv+csIYeDHGNa39Dzlg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(1800799024)(376014)(7416014)(36860700016)(6133799003)(18002099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	C1BnQNemLmRpSMe1hQbsqHjlthLrJb7RenPPXBAQfefrOhf2uwXNV9Cj8Uj/8QRCaxNPrLxSiDVMqf8fRxXjfeDP/DMpfN3KSCBERAsNoLzv9Y8zMRsgt04U/HP4pNLyk8q/LsNIvlqZMWcZk5s/9kfQHOtkqTO9Vb4ilfLgWTBZncshHUzCTkDK/CXXBZgnzHh8FEdnRr2WFXPrG3yhr59/9HmDjYQzOwnj0JJjSWKGQou+lgkDTRhf68/sgKeYBs8KkQL2Je88pszBWgvm0tMpfGCk3H0tXctYkq+ANXmaN3OjZfG5iN+qPFFgUkewvmhErxitb0VR4aU/70wfwtCdkZBtC2YmtWJvg1DTSEmy83TTmRbjTD82DapCjWCyMAALaDBm6DRHtaf7h8t8v/qrziB8VSA1hxmPvByvxW4TKuZUBOiBr2tfd+mrNzX4
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 09:39:05.0568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d46c506-d1e1-4093-688b-08df277b7d9f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E81.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6617

From: Or Har-Toov <ohartoov@nvidia.com>

The device-level max_external_SFs resource is redundant now that
per-port max_SFs resources are registered on each PF port representor.
Users can look up SF limits per-port directly via 'devlink port show'
to correlate with controller number and pfnum.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../networking/devlink/devlink-resource.rst   |  4 ----
 .../net/ethernet/mellanox/mlx5/core/devlink.h |  1 -
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c | 19 ++++++-------------
 3 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-resource.rst b/Documentation/networking/devlink/devlink-resource.rst
index 47eec8f875b4..b7172d94b2c6 100644
--- a/Documentation/networking/devlink/devlink-resource.rst
+++ b/Documentation/networking/devlink/devlink-resource.rst
@@ -89,14 +89,12 @@ To list resources for all devlink devices and ports:
     $ devlink resource show
     pci/0000:03:00.0:
       name max_local_SFs size 128 unit entry dpipe_tables none
-      name max_external_SFs size 128 unit entry dpipe_tables none
     pci/0000:03:00.0/196608:
       name max_SFs size 128 unit entry dpipe_tables none
     pci/0000:03:00.0/196609:
       name max_SFs size 128 unit entry dpipe_tables none
     pci/0000:03:00.1:
       name max_local_SFs size 128 unit entry dpipe_tables none
-      name max_external_SFs size 128 unit entry dpipe_tables none
     pci/0000:03:00.1/196708:
       name max_SFs size 128 unit entry dpipe_tables none
     pci/0000:03:00.1/196709:
@@ -124,10 +122,8 @@ To dump only device-level resources across all devices:
     $ devlink resource show scope dev
     pci/0000:03:00.0:
       name max_local_SFs size 128 unit entry dpipe_tables none
-      name max_external_SFs size 128 unit entry dpipe_tables none
     pci/0000:03:00.1:
       name max_local_SFs size 128 unit entry dpipe_tables none
-      name max_external_SFs size 128 unit entry dpipe_tables none
 
 To dump only port-level resources across all devices:
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index 4fbb3926a3e5..b4092eadfe53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -8,7 +8,6 @@
 
 enum mlx5_devlink_resource_id {
 	MLX5_DL_RES_MAX_LOCAL_SFS = 1,
-	MLX5_DL_RES_MAX_EXTERNAL_SFS,
 
 	__MLX5_ID_RES_MAX,
 	MLX5_ID_RES_MAX = __MLX5_ID_RES_MAX - 1,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index 1724bf7e0e7a..c36dbd7de877 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -262,24 +262,17 @@ static void mlx5_sf_hw_table_res_unregister(struct mlx5_core_dev *dev)
 	devl_resources_unregister(priv_to_devlink(dev));
 }
 
-static int mlx5_sf_hw_table_res_register(struct mlx5_core_dev *dev, u16 max_fn,
-					 u16 max_ext_fn)
+static int mlx5_sf_hw_table_res_register(struct mlx5_core_dev *dev,
+					 u16 max_fn)
 {
 	struct devlink_resource_size_params size_params;
 	struct devlink *devlink = priv_to_devlink(dev);
-	int err;
 
 	devlink_resource_size_params_init(&size_params, max_fn, max_fn, 1,
 					  DEVLINK_RESOURCE_UNIT_ENTRY);
-	err = devl_resource_register(devlink, "max_local_SFs", max_fn, MLX5_DL_RES_MAX_LOCAL_SFS,
-				     DEVLINK_RESOURCE_ID_PARENT_TOP, &size_params);
-	if (err)
-		return err;
-
-	devlink_resource_size_params_init(&size_params, max_ext_fn, max_ext_fn, 1,
-					  DEVLINK_RESOURCE_UNIT_ENTRY);
-	return devl_resource_register(devlink, "max_external_SFs", max_ext_fn,
-				      MLX5_DL_RES_MAX_EXTERNAL_SFS, DEVLINK_RESOURCE_ID_PARENT_TOP,
+	return devl_resource_register(devlink, "max_local_SFs", max_fn,
+				      MLX5_DL_RES_MAX_LOCAL_SFS,
+				      DEVLINK_RESOURCE_ID_PARENT_TOP,
 				      &size_params);
 }
 
@@ -303,7 +296,7 @@ int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
 	if (err)
 		return err;
 
-	if (mlx5_sf_hw_table_res_register(dev, max_fn, max_ext_fn))
+	if (mlx5_sf_hw_table_res_register(dev, max_fn))
 		mlx5_core_dbg(dev, "failed to register max SFs resources");
 
 	if (!max_fn && !max_ext_fn && !mlx5_esw_has_spf_sfs(dev))

base-commit: d8674294aefef02266c4d47ad10131f1bffbe534
-- 
2.44.0

