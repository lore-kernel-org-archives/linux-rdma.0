Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011001.outbound.protection.outlook.com [40.93.194.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88A1448BA2;
	Thu, 23 Jul 2026 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818921; cv=fail; b=U1yy2ODPmTBrOPfVSWarvLpwtvaSb95s6U+HQXxCz0QJC4CJEz0jSIj+edIHHgzcELDSPwgXGXoe1gY08kffQrK8oW2h2DlQU6RobfImH/hzU4q4XDrxYR7ZNbpLCw9HHcCB5LKEtK65EzPmxLGPC3mHOI3ZeoSTDACoW6fDJCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818921; c=relaxed/simple;
	bh=BomeWANZj/V8uwZhGhfPsrIPH7dGPQxe7I/4D//zTnw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=akC8ezASlH+x1lxLC3DMTLwvtsS7ZmtmvCOQZK55066cITYm9LZMm93RGfTR62O0KtHY4BCVB8epCnzV2jUdOcpmDdVMKpI/LPSLmwWhfIcmrOeEyApvLEclcowa8vViEbt5XUZfuHCbAAluQYU+BNxXoHX+nx5geOPwdXxGKrc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TKFBo8GK; arc=fail smtp.client-ip=40.93.194.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TKFBo8GK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bPv8ZSURBs052LEq+jiDGZYs84IjAiBij2wU+xVL27cN08qdQOf3DymNT/MQH4oKXyr+4Vs7WDCzwhcoZhqah/J6kNW2BpRJ/wBT/3sEM7s7O+7GXmFs4RGgWK5GD3jRiaGQ5I9gQJ6AAEMiQ15kOb2cUKlaH2CLg4wuGIkr+4/HEdklyOxypOHLif1j1qXDrPYcI0Vm7Egy2/VrKgO5GDwBt8UDIACfJ+xrpU22mhXEg+MbKfBeglKT1swVhzKZdqCjEirFIOwU52js+rtkWTgZSO5kDlCOz4tKcvyEMemX7QL7aRAY0z+ckCIE3la7CXC2bDnguZsnYhYb8xezZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvyqKHlMo3TWajLiPIt74JMd5pXyOUaLry84Us77Sj0=;
 b=ebLM1HGkGutqu581ot8bYpRfXt4zOg8KSNRi/404+XCEk7xSMCrNHPylV8kZ4ra0NXzyb5e/E1yTSVNuAZdg+Bq7TnlmKGaKsfWi5W+EUyl97FTOkPAhTOkGUA/0RMkeF5tmSsrUMFLeY+e+RNtSomFhMfsGfMcSP2pEXUN1M3IsVSq3OqgeKgEjSd+YC7VP7MEL4G1ttgaBaZTMGkgCFSNkbspQAfaAC0V6ePnbH8le2PzKgp6yM8QKrBavxJMmEGN00NDXs9HPs1aXNd9lD2BREFypJwJe8klWjNzXGl2WwNmQRqqoQcpO5OP/OXWUzTo3hJz60Ja0BA3/DGkV2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvyqKHlMo3TWajLiPIt74JMd5pXyOUaLry84Us77Sj0=;
 b=TKFBo8GKyEbjCcsjfGjJK+pn3FgYw25Sg1P2Ep4CRstZ1kVLjXe+0W8E4cA2vhgj9uLlpbEam/egd2X5yCl6WPxCyvGJ5eDQAIaIv1zbBCGvhXkGO6LoNzj0PTZAibT3Kp8Ajewolz5i3pmvP85GlGH1ngfu/VbV70DIc22KclSAC8cA940jmNUlBgWp0fvKBjwbBl3f+/61d0sX8rQt4fl1mU3EUZ5pBVm8PYQMJleikm0VXQHiX5wn/eBujQiaQ6FCzl0GC3ei6r9ET9eCgo8zXqmx9CKCtbHjh4IbZ106Onz0+OkPlhVw2CEU7nQ75O2I/DJivblvRCLpjRKyoQ==
Received: from IA4P221CA0005.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:559::10)
 by BL1PR12MB5970.namprd12.prod.outlook.com (2603:10b6:208:399::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 15:01:56 +0000
Received: from MN1PEPF0000ECD6.namprd02.prod.outlook.com
 (2603:10b6:208:559:cafe::4b) by IA4P221CA0005.outlook.office365.com
 (2603:10b6:208:559::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 15:01:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MN1PEPF0000ECD6.mail.protection.outlook.com (10.167.242.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 15:01:55 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 23 Jul
 2026 08:01:30 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 23 Jul 2026 08:01:29 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 08:01:27 -0700
From: Edward Srouji <edwards@nvidia.com>
Date: Thu, 23 Jul 2026 18:01:23 +0300
Subject: [PATCH rdma-next] RDMA/mlx5: Deprecate latency-sensitive QPs
 feature
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260723-deprecate-lat-qps-v1-1-8bc8b8431520@nvidia.com>
X-B4-Tracking: v=1; b=H4sIAMIsYmoC/x2MQQqEMAwAvyI5G9CsKPUr4iG0UQNatS2LIP7d4
 nEYZm6IElQi9MUNQf4adfcZ6rIAu7CfBdVlBqqorTr6oZMjiOUkuHLC84houTYNEXWNMZC77Ce
 9vucAwW2MXq4E4/O8U2348m4AAAA=
X-Change-ID: 20260723-deprecate-lat-qps-ca1942227499
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, Michael Guralnik <michaelgur@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>, Edward Srouji <edwards@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784818886; l=3586;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=0iFMfNvYNEKQ65gM9KLPQlw2h1HCwakGMDCYyHbjT6M=;
 b=Ed1ANQaHxooRXZ+/C0pTMcYp4l4WKfAMnpHG6T0GrUuXX/bxk/uynjkbPMsH8a7CsQx3Ko4M3
 F9Izm5p5DfYCpsj39rxWjIyngnUnaBLRTe+iUZ100GK0uo5rU5MeYQ5
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD6:EE_|BL1PR12MB5970:EE_
X-MS-Office365-Filtering-Correlation-Id: d2c982f0-36a8-43fe-b3bd-08dee8cb5681
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|82310400026|376014|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	fmwtYzphdhaMbIqRS42nOQgINXDd0IIFImp99QFq8aSQ+N9X6IgFVifVfzRRTnURgN4+jU/VIpZ+V368ZV4ghmuSnj6fLBnIa83/z4oe3Adb06M+pW+JFVb3VpLam1CC3Xa7R5bbPnxHtBnmEu2fx/yK2atym8gdo4AbtU1GfSw4yY6uIJHtX01F1wxbWJy3qN/SlAJ9XGPq1pZlcHm4CSTOQOC8Knc2ukhXx+THJlicdQfWDpDluvP4fScQJnV9fu5ZynLQbvNiUPq4yy/12iTVhLfL4AWjDEbWz4GGqsD3yvNZrWtSBqJ+ZfysSk9zobwFs/f6UO969Gcc0s2jIqM9nGilU4KOCATtkal6p9FauKsGd/zNQLQ1fLs06/uYQvvHh2rSmI+rf9qJ5qxfgENoEfaRo/2oiSHmKsGlqx8mC5wddgkx5AF79YNb4G8uEmMpu3syT3mxLlwG9k2CDE3aA4QoTXi00NW0NzXj2uVuiVPF/B6Ykl92SfLXN+jpuHigKwvl28UovTp4YpBNEnwabLI8UH7T6fKI49b21xfxFtzDye/zuH3rYJMXiy/0Mi2yGXg3zHvkAnOh14C3YYiHeqo3hGJ872UZrYpYxFfVRTNT1IFaciH9+mJmxFjfN3q86GcupnpzjuJJ7i13jaGbYkyvBLIqMTp/jIRaF5gBbhkk+2IFvJyFITuhPKAv7rIwd/HzXY89I8fKdZiT9Q==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(82310400026)(376014)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	98fQ76PtbLeBv1IfcQ/PRFHomaCTPLgXr8LkRIyF1na+XDCplyr3fnUsWk3AA59snKqJs4zKi6agFZLDJIONXpeWY9/YRs6U/M6Pwo4MvlkIlrtkXTUR5/Z5/d5Tqg4A5C015BkHIBl0cKrHP84NYDOtStuTuR06XwFU3eodIAsEaJrkP3ScdKkfIG7dagWEX8LZhAKfZYHTGfnLaSO/QnN/LK1Id8pRLZqzz83r8o4JVTbyYEUqb/3rjhB63yusaeH8oMFS4Pa1yeSQaqB32uk2iZwFJ3yiVD2OA448DeOZO/pS2p0caswBC8jwOMtNHyb7cXweIfeTqxhE9DmiGZa4tVLHI5ZXDejzXnsa0evsAp2FqPe+sOXZhbIdg0rMNCOo2oL5dx580W+LsHzyL4uojE0n9aZdPCc97KBthlZlooBqJaxNGMmW1FBsHF3r
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 15:01:55.8086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c982f0-36a8-43fe-b3bd-08dee8cb5681
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5970

From: Michael Guralnik <michaelgur@nvidia.com>

New HW no longer implements a separate class for latency-sensitive QPs and
advertises this by a new cap bit.
REG_UMR is the only QP that used this feature, so gate its usage of the
feature on this cap.

Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c |  6 +++++-
 drivers/infiniband/hw/mlx5/qp.c   | 12 +++++++-----
 include/linux/mlx5/mlx5_ifc.h     |  3 ++-
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d65ebdef28234fe91ad4c24a5ded2d3af8bc646e..a0f5341f40ff1c0414939dba50301f0255825065 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4950,6 +4950,9 @@ static int mlx5_ib_stage_bfrag_init(struct mlx5_ib_dev *dev)
 	if (err)
 		return err;
 
+	if (MLX5_CAP_GEN(dev->mdev, qp_latency_sensitive_disable))
+		return 0;
+
 	err = mlx5_alloc_bfreg(dev->mdev, &dev->fp_bfreg, false, true);
 	if (err)
 		mlx5_free_bfreg(dev->mdev, &dev->bfreg);
@@ -4959,7 +4962,8 @@ static int mlx5_ib_stage_bfrag_init(struct mlx5_ib_dev *dev)
 
 static void mlx5_ib_stage_bfrag_cleanup(struct mlx5_ib_dev *dev)
 {
-	mlx5_free_bfreg(dev->mdev, &dev->fp_bfreg);
+	if (!MLX5_CAP_GEN(dev->mdev, qp_latency_sensitive_disable))
+		mlx5_free_bfreg(dev->mdev, &dev->fp_bfreg);
 	mlx5_free_bfreg(dev->mdev, &dev->bfreg);
 }
 
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7ff02d89c31d5b4db4c94453efafc0fce212acea..9253402ed645c9985eed098d3b21bea638028218 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1123,7 +1123,8 @@ static int _create_kernel_qp(struct mlx5_ib_dev *dev,
 	void *qpc;
 	int err;
 
-	if (init_attr->qp_type == MLX5_IB_QPT_REG_UMR)
+	if (init_attr->qp_type == MLX5_IB_QPT_REG_UMR &&
+	    !MLX5_CAP_GEN(dev->mdev, qp_latency_sensitive_disable))
 		qp->bf.bfreg = &dev->fp_bfreg;
 	else
 		qp->bf.bfreg = &dev->bfreg;
@@ -2509,11 +2510,12 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	MLX5_SET(qpc, qpc, st, mlx5_st);
 	MLX5_SET(qpc, qpc, pm_state, MLX5_QP_PM_MIGRATED);
 
-	if (attr->qp_type != MLX5_IB_QPT_REG_UMR)
+	if (attr->qp_type == MLX5_IB_QPT_REG_UMR) {
+		if (!MLX5_CAP_GEN(dev->mdev, qp_latency_sensitive_disable))
+			MLX5_SET(qpc, qpc, latency_sensitive, 1);
+	} else {
 		MLX5_SET(qpc, qpc, pd, to_mpd(pd ? pd : devr->p0)->pdn);
-	else
-		MLX5_SET(qpc, qpc, latency_sensitive, 1);
-
+	}
 
 	if (qp->flags & IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK)
 		MLX5_SET(qpc, qpc, block_lb_mc, 1);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 695c86ee6d7a3f15945fe7af092f63d9121da47a..28582c4d94d4335283009595f6a278c4d17c7eaa 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -2005,7 +2005,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         log_max_stride_sz_rq[0x5];
 	u8         reserved_at_3a8[0x3];
 	u8         log_min_stride_sz_rq[0x5];
-	u8         reserved_at_3b0[0x3];
+	u8         reserved_at_3b0[0x2];
+	u8         qp_latency_sensitive_disable[0x1];
 	u8         log_max_stride_sz_sq[0x5];
 	u8         reserved_at_3b8[0x3];
 	u8         log_min_stride_sz_sq[0x5];

---
base-commit: 9b66c9af7172ffcf727214fa0ebe9a5e1ed6eb16
change-id: 20260723-deprecate-lat-qps-ca1942227499

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

