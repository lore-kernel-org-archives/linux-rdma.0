Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012049.outbound.protection.outlook.com [52.101.43.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990694A3F1D
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881496; cv=fail; b=VzsscLK0WYVKs0gJ+EJIg4u8NAopbkk9A+dc5HtIUePCDwAWNMDqRLwsjL6qycx9X6zb3LNOnJRCA+kpzJ/MMumE/YRW8xTLeCurFMGNZxQ8SiFYCodmvIzGVhRv4l6gNPMw1FOgrPiDurXTagtSde8FueZ8aYXC8yHahzeQKLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881496; c=relaxed/simple;
	bh=deEIQSKthw0kj25eoVpkhWCnERpNpD3LFx8dA/I8N/A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F/2WKvaV/7l7q3Ly7oZCR1E3jKjnPCKZ2r8rqpU5DXyDplt2NGK4RYjISbEgWnl8sSZvY6tgnyBGMJ3J11HxMAMoNEQqejSbl5FaWGH8eKMMNjnZ7zdW46VIrFpHmtKbMA7MzDhMgATw2xRO7mVoMk79LZ/HBGc97oPcCk+FMd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=C8GMPJQX; arc=fail smtp.client-ip=52.101.43.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C8GMPJQX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wbgoShoYSP0yuNQMc3yQVQvwposNGMa6m06hXl1uaHQ9fjraQjMpD18ABz0a+Fy5CdkbcHLiwUDpfHgyh4atT28e0SXhgEtiCYy8uia3MzGma53fbbGLwMJR6pao6Jg4eHrM7c22xW6X+RND9ry5Fx1hkjwUYfqdqoQ2Yskus0rM6w9Kek9wkq8WGljnh8AWxq7gYPqk9jWIN/YDCTPgT+aC+8azsmb2S43gsdSweaynIteC/AnZQlDrpGfZ8qgKZdxWYhjsbaSwMJdC2X79fDjUq/0B97khiQe6frJSqlPEz9D/M4fPwS6dxQjQZxELuey2HGn2Cy6DXOTK2eNJKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nZXuGhhE+HO7bQWG9cZm1hKpWmZbVo6S5CX3DmNE2DM=;
 b=WZoqwrXYFF/Rj/R6zj4KU1ZZ0usJKcIqKjc6MYaB0C3HyNOz56YQxcjn1uN2Dka5vsca9ATKj1xX3scD/y3KTBR33tG0tKS6U7cBRcQY6nKvk1lxSyBzRJ2sMBchpux7AVNBCg7p/D34d+DS+UcqU+p5NA76DpKTNzIPN/FxQVS2PG2sQqIyaSOFLI8WFUYJe+bn7FW1VS53Tjq41vlCjyS+WE+sdQhbytntRAcuQSin6eWAZiLY4V31LSBKhIl41U9RXoP61OHKKejOcX8aEZmkNXIPszdjQXUwB4VMNJuxL9pAdBYHQ3cagd96QECBR3BiAe0qWpJDK1sShf2xig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZXuGhhE+HO7bQWG9cZm1hKpWmZbVo6S5CX3DmNE2DM=;
 b=C8GMPJQXiJN5G2beMNJt7obCRwzggdUPopUMn2PV8ayrdbeQCoFyDK1tpswDdUkU9ex6CNy5a5y7mwJyMLtIturL6kz/gFqhOEAgGmoafCF+2KAIX09xOZZ1bvaWijm5TsAreC5XIIDJU/UiO6+DYp/DV86/i3iRYAJflge9amNAqxiwDRSfnr/fw8f0mu1LVkp33QXlpeTVLzPdFM0VpuIYzkJqOINKlfAtJR8mgCGmMg4qYKD+yuCHNBM0FPK8Zecy/mJz/sQ3GX5tf5fATTAuPIOSSPjgeDiSUsGaE+rl8hACDKh0ghix3VK2pR4t0kR2pnlZM1dE9N8yz49scg==
Received: from CH2PR04CA0027.namprd04.prod.outlook.com (2603:10b6:610:52::37)
 by SJ1PR12MB6218.namprd12.prod.outlook.com (2603:10b6:a03:457::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 15:31:18 +0000
Received: from BN2PEPF0000A891.namprd04.prod.outlook.com
 (2603:10b6:610:52:cafe::5b) by CH2PR04CA0027.outlook.office365.com
 (2603:10b6:610:52::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 15:31:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A891.mail.protection.outlook.com (10.167.248.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 15:31:16 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:37 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:36 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 8 Sep
 2026 08:30:31 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 13/15] RDMA/mlx5: Set QP event handler before firmware QPC insertion
Date: Tue, 8 Sep 2026 18:28:49 +0300
Message-ID: <20260908152851.1307294-14-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A891:EE_|SJ1PR12MB6218:EE_
X-MS-Office365-Filtering-Correlation-Id: a9d0ebe0-ec61-43db-ebfd-08df0dbe3919
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|7416014|376014|23010399003|6133799003|3023799007|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	jvN0ScgSwjZtFyq7NsdjuB10SFDsFjRgc6t7Uba71ZC+ABRHMK8htStX4FfQ1D5bKRFwy5GAke3lZYJXP75CF5+NqC04Brfc3iPYkB30xIDdzPTJbjr5hsyyxUu1vZ8YFczip3HvKJMiqrQkElGiVpLVXLIT9xOdw5EF4PlrFdpNuY5CFXuq+ueZAVvrsw6THzZssPhH9Ed87HtdrQB8FAH/t9jX1XWESmajbAjgN6DJFvEdQZJekEKf/pro2jr2SbQr5dXCu4F8LLjOJRL1/X1Dw6H2PrZz7j717j5uMLKQ74Kc0p0Ev3LIutAO3/KvojBwllsllfihg0FZhUcSJ8jv75OCpfa2Np7IsxZxg/GzQHiIcBm7/h5hwQYjCjuGNj4dhPx+Zws8RiIaMVEchNzegxi6BrPK40lVMI1wNyKZURYmXAdGisKSP3GwfIOYy63kFd1ZK9/r+c8sL42gjVeKzCy8VrFgHMuA3Wz9dlriQ1ZEq5lsOoC07jOogVQ9OIdieBqeBdpsyqwDUd1tOuDsioifUVpodSM5inLXrLNgxr3rDWC8+C3b7pYJxV+PVepZ/QCNzbnUVa0o9mHEKyWW9fPgXFN0kT3ozF2B4Sr2z68tHYJzqzrgV+9y9CkL3DMGBrFGfgeDPYQLWDlqyqGDRpm0lBwr1D4YmB1WPgDRj8Es6BCde/QlwXfgzsSvIfuJcwuL00okhzUFJ5O+xQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(7416014)(376014)(23010399003)(6133799003)(3023799007)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gslvgGWwujyyLWnBLbriUZRMoQvJq7WTYA0S56/7rKL+/adcmbWA82YBJ9ChRsvHFbrYM03Alpus8e3GbYcR6uPDHczi3ZPyFYZ5eH7qxj/s62NSVQujHZ+qDXoDt4YxmoruYiBhoO5AEPu3iPRfS20tJHaolhfmD1hbcD43c+QP1koqGYI16pXRYNs1j6OoN2462qoO/R9OLHdzWWqv7/yu65jeX24Wx8OSk355wJhWs11St60qVoatHNVVD1+rMNjtfqTTTRimF/OPw63YF3y50C9L3+6O+q46/kCz7lxVPBNYy1a6CEY3+fRQ0/VZN87bCP6ABz54ra2AAC6YNjGGaLOICqI7hhlon2m6zk/k27952fI3iK74IiWNVZv7oAFAwH1sdogf7NPT5bvmni9LrYpvqgyVbeFLtfLcwEeVj3jiTA1YfUnzF/3PZiLr
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:31:16.0995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9d0ebe0-ec61-43db-ebfd-08df0dbe3919
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A891.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6218

Four QP create paths (create_xrc_tgt_qp, create_dci, create_qp's default
path for create_user_qp/create_kernel_qp, and the raw-packet QP SQ
object in create_raw_packet_qp) assigned base->container_mibqp and
base->mqp.event only after mlx5_qpc_create_qp() /
create_raw_packet_qp_sq() returned. Those functions insert the QPC into
dev->qp_table.tree, making it immediately visible to
rsc_event_notifier(). A hostile NIC can fire a QP error EQE for the new
QPN/SQN in that window, reaching qp->event() with a NULL function
pointer and causing a kernel oops. This is the same class of bug already
fixed for the raw-packet QP's RQ object in a previous commit.

Move both assignments before the firmware create call in each path so
the event handler is always valid by the time the resource is reachable
by events. to_mibqp() indirects through container_mibqp, so it must also
be set before insertion.

Add a WARN_ON_ONCE(!qp->event) guard in rsc_event_notifier() as a
belt-and-suspenders defense against any future code paths that may
re-introduce the same ordering hazard.

Also set ibqp.qp_num in mlx5_qpc_create_qp() before
create_resource_common() inserts the QP into the radix tree, so an EQE
arriving in that window does not observe qp_num == 0. create_qp() still
overrides this with 0/1 for QP0/QP1 afterwards, and DCT sets its own
identifier independently since it does not go through this function.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c  | 22 ++++++++++------------
 drivers/infiniband/hw/mlx5/qpc.c | 10 ++++++++++
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7f18ff364e62..2af599b81886 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1624,6 +1624,8 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		if (err)
 			return err;
 
+		sq->base.container_mibqp = qp;
+		sq->base.mqp.event = mlx5_ib_qp_event;
 		err = create_raw_packet_qp_sq(dev, udata, attrs, sq, in, pd,
 					      to_mcq(init_attr->send_cq));
 		if (err)
@@ -1635,9 +1637,6 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			resp->sqn = sq->base.mqp.qpn;
 			resp->comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_SQN;
 		}
-
-		sq->base.container_mibqp = qp;
-		sq->base.mqp.event = mlx5_ib_qp_event;
 	}
 
 	if (qp->rq.wqe_cnt) {
@@ -2093,13 +2092,13 @@ static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	}
 
 	base = &qp->trans_qp.base;
+	base->container_mibqp = qp;
+	base->mqp.event = mlx5_ib_qp_event;
 	err = mlx5_qpc_create_qp(dev, &base->mqp, in, inlen, out);
 	kvfree(in);
 	if (err)
 		return err;
 
-	base->container_mibqp = qp;
-	base->mqp.event = mlx5_ib_qp_event;
 	if (MLX5_CAP_GEN(mdev, ece_support))
 		params->resp.ece_options = MLX5_GET(create_qp_out, out, ece);
 
@@ -2237,14 +2236,14 @@ static int create_dci(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		qp->flags &= ~IB_QP_CREATE_PCI_WRITE_END_PADDING;
 	}
 
+	base->container_mibqp = qp;
+	base->mqp.event = mlx5_ib_qp_event;
 	err = mlx5_qpc_create_qp(dev, &base->mqp, in, inlen, out);
 
 	kvfree(in);
 	if (err)
 		goto err_create;
 
-	base->container_mibqp = qp;
-	base->mqp.event = mlx5_ib_qp_event;
 	if (MLX5_CAP_GEN(mdev, ece_support))
 		params->resp.ece_options = MLX5_GET(create_qp_out, out, ece);
 
@@ -2433,6 +2432,8 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		qp->flags &= ~IB_QP_CREATE_PCI_WRITE_END_PADDING;
 	}
 
+	base->container_mibqp = qp;
+	base->mqp.event = mlx5_ib_qp_event;
 	if (init_attr->qp_type == IB_QPT_RAW_PACKET ||
 	    qp->flags & IB_QP_CREATE_SOURCE_QPN) {
 		qp->raw_packet_qp.sq.ubuffer.buf_addr = ucmd->sq_buf_addr;
@@ -2447,8 +2448,6 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	if (err)
 		goto err_create;
 
-	base->container_mibqp = qp;
-	base->mqp.event = mlx5_ib_qp_event;
 	if (MLX5_CAP_GEN(mdev, ece_support))
 		params->resp.ece_options = MLX5_GET(create_qp_out, out, ece);
 
@@ -2578,14 +2577,13 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	    MLX5_CAP_GEN(mdev, go_back_n))
 		MLX5_SET(qpc, qpc, retry_mode, MLX5_QP_RM_GO_BACK_N);
 
+	base->container_mibqp = qp;
+	base->mqp.event = mlx5_ib_qp_event;
 	err = mlx5_qpc_create_qp(dev, &base->mqp, in, inlen, out);
 	kvfree(in);
 	if (err)
 		goto err_create;
 
-	base->container_mibqp = qp;
-	base->mqp.event = mlx5_ib_qp_event;
-
 	get_cqs(qp->type, attr->send_cq, attr->recv_cq,
 		&send_cq, &recv_cq);
 	spin_lock_irqsave(&dev->reset_flow_resource_lock, flags);
diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index a7a4f9420271..77ddab666ecd 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -146,6 +146,8 @@ static int rsc_event_notifier(struct notifier_block *nb,
 	case MLX5_RES_RQ:
 	case MLX5_RES_SQ:
 		qp = (struct mlx5_core_qp *)common;
+		if (WARN_ON_ONCE(!qp->event))
+			goto out;
 		qp->event(qp, event_type);
 		/* Need to put resource in event handler */
 		return NOTIFY_OK;
@@ -258,6 +260,14 @@ int mlx5_qpc_create_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp,
 
 	qp->uid = MLX5_GET(create_qp_in, in, uid);
 	qp->qpn = MLX5_GET(create_qp_out, out, qpn);
+	/* Set ibqp.qp_num before create_resource_common() inserts the QP into
+	 * the radix tree and makes it visible to EQE processing.  The
+	 * assignment in create_qp() happens only after this function returns,
+	 * leaving a window where an arriving EQE would observe qp_num == 0.
+	 * create_qp() still overrides this with 0/1 for QP0/QP1, and sets it
+	 * independently for DCT (which does not go through this function).
+	 */
+	to_mibqp(qp)->ibqp.qp_num = qp->qpn;
 
 	err = create_resource_common(dev, qp, MLX5_RES_QP);
 	if (err)
-- 
2.18.1

