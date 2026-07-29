Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010015.outbound.protection.outlook.com [52.101.201.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50BC4279FE;
	Wed, 29 Jul 2026 08:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785312287; cv=fail; b=BjcHk44wtQwb00jyKZ2TMQhM3X8dlTyPdffKkuGBxNgW0SLDU80hMin5kdSEwoqvaK//7Qvm0mdugF0DEpJWcGVKKhuO17d5TAVPOosu5j0TVYd7EAH9oSBG6GOh3ZlB6OeYG++0iP91Sce1gDgXQGIeCGrYS6gNagtnCST8vQw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785312287; c=relaxed/simple;
	bh=JRlovFZX0namGwQ4lRxL46qSQh7iIggs4zMGkVcytkQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hqEFv/auBOicbf21/nkmQX6WPOtQRSxkkKo08nwiKuxOhi3xueMufi5mufeyjYZ+NWE2rzGmwkgpIPCiaa/WdaFtMYm3mbd0mFRQBokzg4wzjkIzGXEln1ts5zTdx0Z4JxyiKGOiKwY8yor1DFuFFs8uGkEd8i9RK/F7i2+6eRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SBgP+I8H; arc=fail smtp.client-ip=52.101.201.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SBgP+I8H"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u4s6yJ3pO+mJnsJLlbGZpPOGAPwzxEp9g5V8oYYgfzq7VsvBOfrqL+PNsStS229WOp/5+HJr7peKxePaGQK7Ocumm9B0kMFLc9rLLtY5OhwrllKdkcv2tQlbm8NXIkpqNmiEOEIOtLZjkO7sCDs1y1bgbKYiQZvw1hPVAVUdMY57JLrERZt/taPgStvsX4z1ZKqj4o08vifWNO6dt8ByCTsXLFtJU+d1kjtzX7N6ihmKNDSPZc5GqkPOgwsQY+9Sn+k4j6nm1DfKiH1Nkp87CU3eV7MwuKGMt5F+MYG5g0V68YMe7REY8WShL7El8ihyx6JROF2HB2X1qxBP7ycu4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7NThZkRqI7lLB/2+7mjBRta3C27bVfnDVVLhQi3rUPo=;
 b=pgeO2cfJM7aAOOVJACeJ5OQL4GYa1MGfwRcN252rxjB772TxFZMsG/pu/rqZ8JgKLx1NF7fyOA81JU3fx5C0pi05cFou3hThCFKm5MRLUEfJYWXKwczzyoS8d2wuQnp6B8a4yuOhfmaWZBm/I7HU2sGWRbvKsT6FfskeoV7HTmDEBCo944U5xICPmRgr5rl63L+jiBXiJEhHpXYKruSas2ra+okCam0mRv6R+qX/dhJY6Yp7GnoM9S3LzcN3WD+AODonvoy/ogF134KV9V7iZYQcVbIKh/37Zw2e6r9UijIKZdzkIu4Y1fORLMiQHXdu8jA3Sj91SnEeomuGvXuqDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7NThZkRqI7lLB/2+7mjBRta3C27bVfnDVVLhQi3rUPo=;
 b=SBgP+I8HwKAATXU91eAZjjfpUDN9eKBiBapHf2/J9W81L3oDNA4aWPjkPQkwfUNqfikBL20YwMo9lOzxNGkTzGaB3gnV0s+QO0Gy3KJT+0ZpCj5A5ca+VhLV2zgRHFsW+1kFb2nFUMqC48NafNKqcKdHUc6yibqFefWHLJCOI1M1WFYmzPdIoSF02kActE0lBWwbexJF1S4V/mT2rFox7IVF0o+brwpwhHmKRNErwuhl05dJ9pANShbTRhH2wQlDZO0bF6Pamd0VAvdV1kew9MLp0Dky0bqCnwtKl0YKXJlD8dzUzqwcVRaMRIHIrYCy+OAh7DaICeND31OGUl9iCw==
Received: from YT3PR01CA0104.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:85::29)
 by DS0PR12MB8020.namprd12.prod.outlook.com (2603:10b6:8:14f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 08:04:37 +0000
Received: from BL6PEPF0002256E.namprd02.prod.outlook.com
 (2603:10b6:b01:85:cafe::9c) by YT3PR01CA0104.outlook.office365.com
 (2603:10b6:b01:85::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Wed,
 29 Jul 2026 08:04:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0002256E.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Wed, 29 Jul 2026 08:04:35 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 29 Jul
 2026 01:04:16 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 29 Jul
 2026 01:04:16 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Wed, 29
 Jul 2026 01:04:11 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Kees Cook <kees@kernel.org>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Michael
 Guralnik" <michaelgur@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5: fw_tracer, return NULL on create error
Date: Wed, 29 Jul 2026 11:04:02 +0300
Message-ID: <20260729080402.2427184-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256E:EE_|DS0PR12MB8020:EE_
X-MS-Office365-Filtering-Correlation-Id: 94e887e9-1abe-439c-5a24-08deed4807d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|376014|82310400026|7416014|10067099003|11063799006|56012099006|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	TGcxX0xJqtUFH+G3uaRnxlqBzEdI10Wz8qOvYfCsJ4Pu6Cyw3FwrBnEvqKxCZwZ1G/zG1ZwkgYzjyHV0NV8vantNz3lkRTn8Il15LXnLJmZaGt46qrYtz/qqA3TLMeoX6k39YdVawJXgEbBMEoenUGDGNZnuXzm8CSuYYHODDnvjFHEElNcic+DA5pPujIqq3+6tXHEDJKSYzl7Rf90AgLF6VS1cku2VBD9/lZSDcWHQnRTP4rxh66T+pfoGJ7C+iv7wcs9gB92/B61YtA1gJk43T68h8L0xIdk/uoBcxbSg3pABKkGiTPFRCrEzBWvvmQxXZ3r4c/hhC9kuh3AAW6lY81Z2dsLWUtBEz9NcaRFrBF69kpxx0J1xiNRbhd8Vu1bObqj7uJnwDl7U4Kr+39Q5b8xoHwjTVWRa6qw/On4yqWa/bk+kUtZRFYpNGXRj/DxBFfZTUwNAXR1wri6V8Jk7jtm+RKgyvrsDO7POX+fmIQdaDtHPBV2glocR40wcWMJ7PMchdHSaFq33Xj7pE2dJOGGq1NrZTmd4B7F98iY6anusfkHqxJK1XcP8NuWyT+Y865/t7GwwlRNRjwcmv6OWZZVqOSMHUeuFGmnXjDlWvH6mruVhliG1nJz2iN5m2fJ31JEwQx7xqsoVVadA0vVdJqefIf3lczsleurdhLAtvE+oNJkcTvo5eNnWuQo7OcRgQ9jZ2Zl8+bIlpFhV/w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(376014)(82310400026)(7416014)(10067099003)(11063799006)(56012099006)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3osgNinYHcMaTSoYdkoBixE4XoeQTSk3CWVy2LzspbAKqifBg2Yas1vaGGp2AmtDpt+EilFfG+T6GNaeWJLY8nV1gzHEW7EMhmboXj3WpD5x99nKb+2F63ASBkH5+IG9yM5LC7USz8vZIP4AFJsroaHFCMBuLcLB60AegIrC9MPQCkQ3Sl5pyASVrudcENk9+c/OVdeSp+z5B6YduNeMloJlDqIjK0pLraY5FgWNq69UjY28pVlx8jLqWuiPHuxCF3SbuTK6Rc5tneZXEjtAUIMFmP+sqg+cV/AHWc8tA6fhrirS/XQHineWACfAa2WC7IN5miZb6IWCdlkCpjtuaHd+sgKri39F2HmNsTIdAOAONsyEFB8ASNkfmOJS7fQjceztab2esH2txPuUYB7lLZ2+tv4J3oaRSMpDYRJaNikWLDsMiqZU3AZgf3nWfNSl
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 08:04:35.5921
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94e887e9-1abe-439c-5a24-08deed4807d0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8020

From: Michael Guralnik <michaelgur@nvidia.com>

Tracer creation can fail by returning either NULL or ERR_PTR.
The return value is stored without a check on the device, and users
treat ERR_PTR and NULL the same way.
This also causes a crash in the core dump logic, which is missing the
ERR_PTR check and ends up dereferencing it, as shown in the trace below.

Switch tracer creation to return NULL on failure only, so callers only
need a single NULL check.

  Internal error: Oops: 0000000096000006 [#1]  SMP
  Modules linked in: mlx5_ib ib_uverbs ib_core ipv6 mlx5_core
  CPU: 1 UID: 0 PID: 12 Comm: kworker/u16:0 Not tainted 6.19.7 #1 PREEMPT(none)
  Workqueue: mlx5_health0001:01:00.0 mlx5_fw_reporter_err_work [mlx5_core]
  pstate: a3400009 (NzCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
  pc : mlx5_fw_tracer_trigger_core_dump_general+0x58/0xe0 [mlx5_core]
  lr : mlx5_fw_tracer_trigger_core_dump_general+0x40/0xe0 [mlx5_core]
  sp : ffff800081cf3c40
  x29: ffff800081cf3c90 x28: 0000000000000000 x27: 0000000000000000
  x26: ffff000080018828 x25: 0000000000000000 x24: ffff000080304a05
  x23: ffff800081cf3d80 x22: ffff0000847e01a0 x21: 0000000000000000
  x20: ffff0000847e01a0 x19: ffffffffffffffa1 x18: ffff80008310bbf0
  x17: ffff800080119650 x16: ffff80008010df54 x15: ffff80008010d4ac
  x14: ffff800079c202e4 x13: ffff80008002fe60 x12: ffff800080119650
  x11: ffff80008010df54 x10: ffff80008010d4ac x9 : ffff800079c203d8
  x8 : ffff800081cf3c88 x7 : 0000000000000000 x6 : 0000000000000000
  x5 : 0000000000000000 x4 : 0000000000000008 x3 : 0000000000000030
  x2 : 0000000000000008 x1 : 0000000000000000 x0 : 00000000c5c4000e
  Call trace:
   mlx5_fw_tracer_trigger_core_dump_general+0x58/0xe0 [mlx5_core] (P)
   mlx5_fw_reporter_dump+0x30/0x2e0 [mlx5_core]
   devlink_health_do_dump+0x9c/0x160
   devlink_health_report+0x1c0/0x288
   mlx5_fw_reporter_err_work+0xac/0xc0 [mlx5_core]
   process_one_work+0x15c/0x3d8
   worker_thread+0x18c/0x320
   kthread+0x148/0x228
   ret_from_fork+0x10/0x20
  Code: b9400000 5ac00800 7a401800 540003ca (3940a260)
  ---[ end trace 0000000000000000 ]---
  Kernel panic - not syncing: Oops: Fatal exception
  SMP: stopping secondary CPUs
  Kernel Offset: disabled
  CPU features: 0x000000,00078031,75fce5a1,35fffe67
  Memory Limit: none
  ---[ end Kernel panic - not syncing: Oops: Fatal exception ]---

Fixes: fd1483fe1f9f ("net/mlx5: Add support for FW reporter dump")
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index adcc73e2a5b3..1493d8106c1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -1025,13 +1025,11 @@ struct mlx5_fw_tracer *mlx5_fw_tracer_create(struct mlx5_core_dev *dev)
 
 	tracer = kvzalloc_obj(*tracer);
 	if (!tracer)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	tracer->work_queue = create_singlethread_workqueue("mlx5_fw_tracer");
-	if (!tracer->work_queue) {
-		err = -ENOMEM;
+	if (!tracer->work_queue)
 		goto free_tracer;
-	}
 
 	tracer->dev = dev;
 
@@ -1073,7 +1071,7 @@ struct mlx5_fw_tracer *mlx5_fw_tracer_create(struct mlx5_core_dev *dev)
 	destroy_workqueue(tracer->work_queue);
 free_tracer:
 	kvfree(tracer);
-	return ERR_PTR(err);
+	return NULL;
 }
 
 static int fw_tracer_event(struct notifier_block *nb, unsigned long action, void *data);
@@ -1084,7 +1082,7 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 	struct mlx5_core_dev *dev;
 	int err;
 
-	if (IS_ERR_OR_NULL(tracer))
+	if (!tracer)
 		return 0;
 
 	if (!tracer->str_db.loaded)
@@ -1134,7 +1132,7 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 /* Stop tracer + Cleanup HW resources */
 void mlx5_fw_tracer_cleanup(struct mlx5_fw_tracer *tracer)
 {
-	if (IS_ERR_OR_NULL(tracer))
+	if (!tracer)
 		return;
 
 	mutex_lock(&tracer->state_lock);
@@ -1163,7 +1161,7 @@ void mlx5_fw_tracer_cleanup(struct mlx5_fw_tracer *tracer)
 /* Free software resources (Buffers, etc ..) */
 void mlx5_fw_tracer_destroy(struct mlx5_fw_tracer *tracer)
 {
-	if (IS_ERR_OR_NULL(tracer))
+	if (!tracer)
 		return;
 
 	mlx5_core_dbg(tracer->dev, "FWTracer: Destroy\n");
@@ -1215,7 +1213,7 @@ int mlx5_fw_tracer_reload(struct mlx5_fw_tracer *tracer)
 	struct mlx5_core_dev *dev;
 	int err;
 
-	if (IS_ERR_OR_NULL(tracer))
+	if (!tracer)
 		return 0;
 
 	dev = tracer->dev;

base-commit: 3bd438a58e910db5dc369aa25dfed1fc95f1b596
-- 
2.44.0

