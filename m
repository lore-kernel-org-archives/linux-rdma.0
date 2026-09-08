Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012020.outbound.protection.outlook.com [52.101.53.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6851B566C4A
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881460; cv=fail; b=lEdFsHlUmZWPSSdtygBu7JoMrbbka1N6hL9mHfvz/yjiQMKsELWiUNSZ80XSdZyRexTt+KDUVRCq6+XlTRSqW9C6cnAQqTpxnp0DpvFTcsN1S6Xo+9L5Kc+YyDiG+OUEohNTQzYYnwMGeXLBMnG0qKJt8XYHSBn5DTRcRmru9Vk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881460; c=relaxed/simple;
	bh=Wv34VfP0diC5R8SYgxj+3Yv97Q66XJb4tMYsBj5QAv4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qvuCa0rUWCpxJFt+Tj05iWQROVIhvaYdkeOFWmy8HaM9EbZMyNU8/1X/qgT4sFwLey/CFhHe9hywUUO4a7xFBkvel7xU01fOC6g8bZj3pzAnlsHGMrEit1hDLFCq32+GcGVJ3b+nNcb+nfiqU3l6CQqfB2Nu9qtlSvIY6ZIszgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sYtQVeBg; arc=fail smtp.client-ip=52.101.53.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sYtQVeBg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aj7W/lxGi5/nUZzeaYTtuAWuqIZ+PfSF7Hv2E0tnl3Q22qbogZX3c5UZQx9TBZDwTuoGMMyZAmn9C/67DSFOX2PlHzxbWLGUxm8pQWFdzcnaZEhmKcfC/IMTS1lU2WGWO0VATLNE08dVAZd9dCdOHyRz4ho/YJDjVr/xuCuVUvMpFjXHI6wFMvIrki4c4W9EGsykle/VdbPvEXXQyGqxCm/UcBDjaNeCEmjJrIYb/M78GoeJmUbZxA6I8YZOGDBMJX+ZeeWoAmjSriCWHR604Oj1jEWbUkFhOQlQ6z/OHD6+ijgKGBsMrguwUYrpreEO9tnu/1oaMmiJgPX6FCF63w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFTkwTkAyeO/CJPv6e6Lq5ywn4cjjh0d/b4XQqDUfqM=;
 b=aBqU8+qqEND/qsTIJSFc28hwyIwLLsEuvPyswVsRTrxdcByjVu1YaTAf5MiBE+m23yjxQlAiy4+GvFO3aevDUppHebmTY0PFKrmTIkkEwpVYDs7tXdg/mR3i5ZZdxWK9eH8E9BvlYa6X7dzLaK92o1CpaNeCCFfsay9xa7rgu93l0MZg+VAGiijNlOLvrG61gjcR5gfxnLKo3reSS0w4pFAavG/7rMlsoU6Nlmlv6tr0nKMPyjWwcYtZELo4H8iv53ecu16BtDjBHidSlQjazegwMVJQuS1oi+xqvMKjN04iTMb7Z4V6bNRJyzBm7qR/Ddkvax/CH+XFh7J8cAuJSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFTkwTkAyeO/CJPv6e6Lq5ywn4cjjh0d/b4XQqDUfqM=;
 b=sYtQVeBgFYo+HRktN8at73NvG/fDifQRybRZIZX/X8BKNMCPG85iaOnXwi+/i3IZXP2F5XXTmDJlo/CDILajhz45zIHTrsZZ9/FWbBUVijW2iYqbNS6sTg9YU6IgUwULUtIwMIjSaVdIsdEUYthIof/gaCJ+fbRkq3dHjTYXr+hsg3q84PcdPSq8NS+tZt4y3mLFDvcAToSF6BUwd3yPDwyKO41Gs5raYZXNli8hTulw9wBYeDLxGRfZF/DNUWg+EfnwgmICDyKANIdqde1gh/phJJz9NGh6mkRB8351YAk/3NEBTyLg8FgIIs0KCs/wcd/BVcYRIWcSLyEXFC7ljw==
Received: from CH2PR04CA0004.namprd04.prod.outlook.com (2603:10b6:610:52::14)
 by SA3PR12MB7976.namprd12.prod.outlook.com (2603:10b6:806:312::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 15:30:42 +0000
Received: from BN2PEPF0000A891.namprd04.prod.outlook.com
 (2603:10b6:610:52:cafe::90) by CH2PR04CA0004.outlook.office365.com
 (2603:10b6:610:52::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 15:30:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A891.mail.protection.outlook.com (10.167.248.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 15:30:42 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:10 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:10 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 8 Sep
 2026 08:30:05 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 08/15] RDMA/mlx5: Fix mlx5_ib_dev_res_init() failure when XRC cap is absent
Date: Tue, 8 Sep 2026 18:28:44 +0300
Message-ID: <20260908152851.1307294-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260908152851.1307294-1-yishaih@nvidia.com>
References: <20260908152851.1307294-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A891:EE_|SA3PR12MB7976:EE_
X-MS-Office365-Filtering-Correlation-Id: 2075dcc5-0adb-4ff6-e1d3-08df0dbe24c9
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|1800799024|36860700016|376014|7416014|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	aeAjVD8U7sjoPu29P6xCioeH6Lo3xYQ95FLN+cQTD4pf8FsR+ZGbW+0St9hvftag5n35X3gQfrEnMWd+FdsRmlehece3/+KLVqHpirWwjK/yvqMUJnyn7j1u1v5bWdhqJDVNHCP8czSv626ED69Vn2a8b64xnwo0bglJvrl9Yx0f1wjehz8VV9seNcvZZxt986AIAO83a3Ja5u+DvlLoWm0Y+4qsNsaIyYA8yexWTknfNsHYF8mR0/zIUjELY8rRlMIIo/yZp+6ZsdbXTZCTv8KTom0Q+PpKJJCFq/hfw+9vE9ktKr2KnaBOJ5TuopPi3GG0EqTMM6LuRaR6JS3u/KAPw5vXjKex62pffLZexwPs23bnycSo6tow8gOFmyvNQD4RYNwarmXokeN4FTJQiTJVq47X3dFVdLVjPEHeuYtWl47Zor1LOHjtu9tg8RLPSeszIOuYuxay35/bssTHYuojadP9nejKUoR+G1UWvb6QoLkC3RWH3UMhF7H+2q2MeV/WWS+IHPmIlWCwscvlxwxHr+Pc/PAXjYSljpe6/HHUIE+dUQBUoxMXH1nqX+yJp/Q0r4B6Vj3inJedWaSi28yJIn+rkAgeGghBong2jGja71cemAbRbEF3E88MOL6e6O+Zydhl2umBsxMDvs7sPtR1nmaZIP0bceVBt5WPSJizWyeRmDEJc8EXCbOuEF8vgjR+BHCnfiUVb1ttXrXrmw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(1800799024)(36860700016)(376014)(7416014)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lApcItL2pT1LGTu/ZnPDnXJc6xbReYt+cCRXhJ+5vSSR06ul8Dd3B+ppu13OLamtPrfrSe8VaAVKluws2bABGpJA9JuaaeD+BAB3DpEbKtqQvnluMIGh5I56DjvMfD39m4No7aZMtT3dC/gS6kVfqR/XMG0HOdLNlq6ZkmvREIt1spWefEKM4MIvOsImdnO5rvPCHai7z5aF6VkwfyXjth4oarB0YbuFry7jm+2rDWTya6wttQhuQkV9k69Yu8HfCZRooCmHknBylO3sUB6sslDrg7JoIaRYcX7HJjeofd+44bJWFOY0np4zmCasVKDBrq+9nlPra/ln6oSZNjFz7V4tzQbNijvghuKhGQkkZDucAGQ/PVPOX05fu3+9FHfFmalt7/SX47VCj1EhPYHSFwJ+fkntwO1kbDcsJ1vrC3poBfAFUi3/i34l9JA5tDv4
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:30:42.0190
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2075dcc5-0adb-4ff6-e1d3-08df0dbe24c9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A891.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7976

mlx5_ib_dev_res_init() returned -EOPNOTSUPP when the firmware XRC
capability is zero, causing the driver probe to fail on any device where
XRC is not available.

XRC is an optional feature.  Make it optional throughout the devr
resource path:

- Initialize cq_lock and srq_lock unconditionally so that
  mlx5_ib_dev_res_srq_init() (called on every QP creation) can safely
  lock srq_lock regardless of whether XRC is present.

- Skip the mlx5_cmd_xrcd_alloc() calls when xrc=0 and guard the
  matching mlx5_cmd_xrcd_dealloc() calls in the cleanup path.

- In mlx5_ib_dev_res_srq_init(), skip creating the XRC-type placeholder
  SRQ (s0) when xrc=0.  All devr->s0 accesses in qp.c are inside XRC
  QP paths that the verbs layer rejects before reaching this driver when
  xrc=0, so devr->s0=NULL is safe.  Guard the s0 destruction in cleanup
  accordingly.

- The BASIC-type placeholder SRQ (s1) does not require XRC and is still
  created normally.  devr->s1 accesses in qp.c are not locally
  null-checked, but mlx5_ib_create_qp() always calls
  mlx5_ib_dev_res_srq_init() before reaching them, so devr->s1 is
  guaranteed non-NULL by the time they run.

Fixes: f4375443b786 ("RDMA/mlx5: Get XRCD number directly for the internal use")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 56 +++++++++++++++++++------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 373ee1f42d4a..8b8a0f26cf19 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3373,7 +3373,7 @@ int mlx5_ib_dev_res_srq_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_ib_resources *devr = &dev->devr;
 	struct ib_srq_init_attr attr;
-	struct ib_srq *s0, *s1;
+	struct ib_srq *s0 = NULL, *s1;
 	int ret = 0;
 
 	/*
@@ -3391,19 +3391,27 @@ int mlx5_ib_dev_res_srq_init(struct mlx5_ib_dev *dev)
 	if (ret)
 		goto unlock;
 
-	memset(&attr, 0, sizeof(attr));
-	attr.attr.max_sge = 1;
-	attr.attr.max_wr = 1;
-	attr.srq_type = IB_SRQT_XRC;
-	attr.ext.cq = devr->c0;
-
-	s0 = ib_create_srq(devr->p0, &attr);
-	if (IS_ERR(s0)) {
-		ret = PTR_ERR(s0);
-		mlx5_ib_err(dev,
-			    "Couldn't create SRQ 0 for res init, err=%pe\n",
-			    s0);
-		goto unlock;
+	/*
+	 * s0 is an XRC-type placeholder SRQ used as the default XRQN for
+	 * XRC QPs.  Skip it when XRC is absent; all devr->s0 accesses in
+	 * qp.c are inside XRC QP paths that the verbs layer blocks before
+	 * reaching this driver when xrc=0, so NULL is safe.
+	 */
+	if (MLX5_CAP_GEN(dev->mdev, xrc)) {
+		memset(&attr, 0, sizeof(attr));
+		attr.attr.max_sge = 1;
+		attr.attr.max_wr = 1;
+		attr.srq_type = IB_SRQT_XRC;
+		attr.ext.cq = devr->c0;
+
+		s0 = ib_create_srq(devr->p0, &attr);
+		if (IS_ERR(s0)) {
+			ret = PTR_ERR(s0);
+			mlx5_ib_err(dev,
+				    "Couldn't create SRQ 0 for res init, err=%pe\n",
+				    s0);
+			goto unlock;
+		}
 	}
 
 	memset(&attr, 0, sizeof(attr));
@@ -3417,7 +3425,8 @@ int mlx5_ib_dev_res_srq_init(struct mlx5_ib_dev *dev)
 		mlx5_ib_err(dev,
 			    "Couldn't create SRQ 1 for res init, err=%pe\n",
 			    s1);
-		ib_destroy_srq(s0);
+		if (s0)
+			ib_destroy_srq(s0);
 		goto unlock;
 	}
 
@@ -3434,8 +3443,11 @@ static int mlx5_ib_dev_res_init(struct mlx5_ib_dev *dev)
 	struct mlx5_ib_resources *devr = &dev->devr;
 	int ret;
 
+	mutex_init(&devr->cq_lock);
+	mutex_init(&devr->srq_lock);
+
 	if (!MLX5_CAP_GEN(dev->mdev, xrc))
-		return -EOPNOTSUPP;
+		return 0;
 
 	ret = mlx5_cmd_xrcd_alloc(dev->mdev, &devr->xrcdn0, 0);
 	if (ret)
@@ -3447,9 +3459,6 @@ static int mlx5_ib_dev_res_init(struct mlx5_ib_dev *dev)
 		return ret;
 	}
 
-	mutex_init(&devr->cq_lock);
-	mutex_init(&devr->srq_lock);
-
 	return 0;
 }
 
@@ -3460,10 +3469,13 @@ static void mlx5_ib_dev_res_cleanup(struct mlx5_ib_dev *dev)
 	/* After s0/s1 init, they are not unset during the device lifetime. */
 	if (devr->s1) {
 		ib_destroy_srq(devr->s1);
-		ib_destroy_srq(devr->s0);
+		if (devr->s0)
+			ib_destroy_srq(devr->s0);
+	}
+	if (MLX5_CAP_GEN(dev->mdev, xrc)) {
+		mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn1, 0);
+		mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn0, 0);
 	}
-	mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn1, 0);
-	mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn0, 0);
 	/* After p0/c0 init, they are not unset during the device lifetime. */
 	if (devr->c0) {
 		ib_destroy_cq(devr->c0);
-- 
2.18.1

