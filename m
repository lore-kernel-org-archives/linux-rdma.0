Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010028.outbound.protection.outlook.com [52.101.61.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8823336A358
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481488; cv=fail; b=aq8+9hZ3lGpiFU0YEKUyppr+4Jj6Cc+0SMIFC8ImK5PFPgDRNAttt+stlZrwIguGshFrbL5XxXj5mEfIBqTkRedm6UbX/lwtScNSnphIs8jskSzoO5pYqmGF+1nw5WvPU0Oh0GGCBVAPrsZHe2WwM5LrdN+7lq4AY5mAIWcduXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481488; c=relaxed/simple;
	bh=Gt4tOA4h1jGeJMfZUTQmc1SaQckofygFylYAjNd/RIA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aoV43wHCqkBPGegqXnUGLVmkFGOM0ZxMzSbthWA3i/m+t5TzuHXMlCj5gerGVpfKl4JNYrQc05M+0Bkq9I8GJnGofy9RuPL5g2Q5OQ6GJi5VF0wT7qHv89RxiNUGyx+/C1CrbCkyrz2X4PxyExREj3CSUpHBa0SP2AT6V5IawBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PeLi46q6; arc=fail smtp.client-ip=52.101.61.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PeLi46q6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wDZy0d6DjyawaE5DnDNSWn8YMj1PcvLYfc03zfrJJ9P1sxnb2EcPBPMpytJUjo+pLE4nnV5ZbcdD7RDi+j4S1HtGB7d/j0DoF+ch4DMIxYafkIxiz3eQWkdZeVmw74FvB5cbv098lCpflJbEouR4Hq1OB3h9n828WroJbqPh0wG3njxlwR3uZv5MeRwjZPgHwmroqdHmmFswenFSC8SEhguC+PLrnsSm9fTLJWkcwMKRIWpxcWugxL0/I1EXNQomFwJKcr3UGhWOHTEonaAL9XHc0TE5kWccdyQnGFIcr/YqhOBzu+LZ1WeV61Cw6gEJ4B+AjHzyP2rezoGaZONGAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ZzVZzDL8pTa0jNsbF1ABx1bkp3NidbP4oVEwTxjubQ=;
 b=klgNZ3jtc3zTs3RcOkCVlon7n4qFSLqLxxqsbZeNM5fS+vWt8BxcKeSbthOJzu7PdBpIfiUK3cQc487AVj4/ULdQ8NUUFByMOQrqOYdyFY4R2qqw6MvFjRmyEij3nTL2Nj8i8LkN7AE7Yb/0pINPPNAwAY3SomX5749jwcmSiceWQOmBvvPZ16ZNd3LTc7ATSdwArKF3JG3Z6xXlSp8aZu1K5OL3SCbQrFs42rV793n4B85kFMYEYlQLOOOgTgZhGnFmzYUHvq/UuzC2Kwz7YjqTC28FY7WXWrkT/BWds+QL0PGHJ/QA+5C2vLWdt58odbCqro7ea6AMoieeArrbTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZzVZzDL8pTa0jNsbF1ABx1bkp3NidbP4oVEwTxjubQ=;
 b=PeLi46q6eDiJNzNVEm2Mrgqh+XLkrppI3JiAEg5K5PBW78ANNTyj3ipuRXeH2AQZJMCezBkhXS7Te9jNEmPL1ELB0ajzZ4aJ+/DKMUwgJ66JTtbcJ0b2jN/gVraRFpMscm5aRMSPkCv7goljKW2/eQT/JaoLquVcBkVXacok1+4LMd1oZgOp+hkWzVTnjMFuHZiSGDIJ0tutTMxT+m8VY6nCcLOpI+iRy/SUDDfNH2D9pAWfsEYa4KXBy5yn7r4KEsfrNi+cW2fKGTySFV/FYRN45tNB3AgNJ+3FLmted6LRXozrnw7h2EqlwoCQ1f79V2aucbAERvK4pLKYU5jufQ==
Received: from BL1PR13CA0221.namprd13.prod.outlook.com (2603:10b6:208:2bf::16)
 by PH9PR12MB731475.namprd12.prod.outlook.com (2603:10b6:510:414::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 14:11:20 +0000
Received: from BL02EPF00021F68.namprd02.prod.outlook.com
 (2603:10b6:208:2bf:cafe::49) by BL1PR13CA0221.outlook.office365.com
 (2603:10b6:208:2bf::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 14:11:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F68.mail.protection.outlook.com (10.167.249.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 14:11:20 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 07:10:49 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 07:10:48 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 07:10:44 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 08/15] RDMA/mlx5: Fix mlx5_ib_dev_res_init() failure when XRC cap is absent
Date: Tue, 15 Sep 2026 17:09:26 +0300
Message-ID: <20260915140933.40580-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20260915140933.40580-1-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F68:EE_|PH9PR12MB731475:EE_
X-MS-Office365-Filtering-Correlation-Id: 146b75c9-8e63-48b8-6753-08df1333379c
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|23010399003|36860700016|22082099003|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	tG94BJJNYkLKnfVMwUfP/0XM8nZGEfgqL6j39l8FxqnJObEbkd7fAORa8B2eZVrbCxYYMzP4OMxj07lFCHLm8RY3/Y2yI9DDP4UhRFPaA6ZTjKuB9K8VnFUPQIXYhYKGfXvItKIVQePFw22v84vB0+AEJIuON5oUo+4+uXcpT+Y9P4d/qwchL5MldzawyCABF+51CpIgOuAkL756JG8JIqldUj5gH7L/eEGGx0SPV7+dOB2U7ht94xGIwurppv7KD0xFXvaew78D1SNKnYGMD2C+bU3fq3Y6w0SVMwSnhyCsJu59a/h4LxvOGioQ26ZqY2ZPVg+672KM2ENpleGaVeaz2rPh08GKgXpdW0Dyxhu0aj7WbGu64wWcSYbHJ+IY64Qhqe3GGEqU7NoUGrLhzOIf5idRPMKi+3d4JhJ7rG5olkp2JVBzqP/6lfotS+h0wkOHubhSWH2/UQuLVblYeNVPMGUwhKUGmKFh39HxPt34hCZAMZ8v2L/eJlTDnj+QbQr7GDIjPK3R9Bb56KQQ63D+krSMCqQAaMIbrd1H50qRu0KZLbvYGhq3TbzzXG2VaKOU83H3b/pV7/AYRBoxd8GpNdCLM+TtKaAWb1Ab/pyi8a88eLgasPAi7sz1Z6MTm/i7VJmojYF07W892cKfbk4dNvsnWLA0b8QaH6y9sOCmYEgZbIrU6KuOECb0amqhkaX6xACM8mtdM2HWOWEoZg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(23010399003)(36860700016)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XNXFeMuFBBhuuu2Gg+xzfTAIRGH+q8oru1rmrt7ggJw7mXspCXAg36c02dyFG14BZyfCoMUxCzMpi686RubeQE6jPSI/fiRafukNnuGPy4IKznkZ/DgTW9O86bvPfmedX8k7dFOB8t1RNdgL7KLfQn+qmu4AkFoRsKB9YpVlgjSoaaVcLqlrjVnF65+LYUs5oPH5XzMUCQq/sg5w6bHbmqO0Ji0MHNXi9MZIUa7RsGspI0BQo47WsLtkmpekzzA+26/ScDtBr9XteGzW35JhC/I+7PseRXfX6WjZObphAFLswdYPzZbi8QLfsx4rhOnrl0S5Ry9WXweMMI2uR58gWp0G85GJXAlSAk3qDPZm0lK3BeuvYO7z+Zy+JdJoyV3V8KtkN/8CBQjmDi/nCcSUmxxcWa2Iz7E9+U52n4C8eVV0uE703UtDWgbDmRIQdvTh
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 14:11:20.5377
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 146b75c9-8e63-48b8-6753-08df1333379c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F68.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH9PR12MB731475

mlx5_ib_dev_res_init() returns -EOPNOTSUPP when the firmware XRC
capability is absent, failing driver probe on XRC-less devices.

Make XRC optional throughout the devr resource path: initialize cq_lock
and srq_lock unconditionally (needed for every QP creation), skip xrcd
allocation and the XRC-type placeholder SRQ (s0) when xrc=0, and guard
their cleanup paths accordingly.

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

