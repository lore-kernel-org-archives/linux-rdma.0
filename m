Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012069.outbound.protection.outlook.com [40.107.209.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679EF30566F
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481509; cv=fail; b=KWLIOniAj0qC1oFkkD9TspPyybcUUcv/GfWQuGUkDQ0lHf2Af/j6iwr1pLF57wRbUm55wRUxL6Y+44LF+sw9ThdhiODFXFv2aA/tmP6xNCcs5gkmKV81E4TKEVWn6IxaC9leqtTm4zbVkVu1MIKIL/58QBbzQU0JseLXvkMtT1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481509; c=relaxed/simple;
	bh=LgIhh4PvlbPWBlrnmPTNCewo5fM9Oag9BMVD7UVhkJU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZqkDTcVr6UbHNWtJ7BGkHD7vbjkmeafCIGYQwAMICLoP5zm0MNwVNqTCsL99rAl1BzHW0q3ep7xJDd6Nu4m3cIZsyI9OZm3WVctaY/EWzwvTiYNswUa2dDoRyzaw/05vp6snMug3ch7O8nIDHSu0/cPGHsSAdFWsRzm65Jrxc1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hOk/yPjN; arc=fail smtp.client-ip=40.107.209.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hOk/yPjN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HIZ4GtrOc1KNjik7fiQWYQzHlQ5GBJKTe5MvAdYY5IRRUXYLRZawwTZnnz3T5V4VPcu5SkyLQNIX1AoCh3szMh2XSaDNmEKCPst/+w4CvnAtP2Cy3cH5DJd2m/x4yhlt7waJsEKga1RopUZZ6wwEonkx3iL8FypgufGxdIczNk91ss+p5V5AoHMqvoWQcDlqMNR8bnrUwUUxAIw10bEfCKKLbNDUGcpJQ0uk8jEjkxph7oNq53DdBW3mQnrOd/jGuc8FPxRq13ZuABTb2ixuNmxPiR7SmE8WCv43Gq5HVnY93pLjOGXheqiasD6MUppHgz3UBWSZB2TFFMvR4hWFRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+0Zn8I7EbHSYdEO5ycKrLdC0LGGhy5boH8kdPEuy6g=;
 b=lxp5ko9woT4ifAGnxjoqTvZwMBIQRi8/H09f8yxJd6Ny+KcB46Jkr2CjhVZTvZnDdgtIbgLi0/aRpWgubFLTvJhnJ3GDcTY515dZxS5pPcZkwgEQFRyIYJu1PAe1uBvscV9D0YwjCEYOhYaT3fe8+ITl/VVCnW0ArBBvmckojjTE3k9Af9tfQ8xRokcNeW1fy6aIUduETjXWzkDwyA/LGqQz0oP5bnXotjLzvvg3485j0ztYeWjQZOBKecTsm79AQOONT65qfYU4gvj1brq8lwiLv4ur4lcO46HOwhssgfRXWDOashx0amgKR4xWgUx4KDPlTFiOf/bttEH9WY7mCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+0Zn8I7EbHSYdEO5ycKrLdC0LGGhy5boH8kdPEuy6g=;
 b=hOk/yPjN+DoRCCdIXOp2sBvDC4SAVZ80rOxnwgWcLfovAyB0mkQ0UBNJxjKbOM4QjjqrKEKnhp8iwM9ohkeolmHH4dzkTTg8jRk9lRikuYJ0QBrML5O79k9GIE+PJAjtwaYm1I9FiNo53imZQvKxguIxA4WBGt30dAuqFLXg4+c9LsE4/ayMc9z4BQmDWW4yJg6J6rHay6AyEa9IqCle4ZUSsxLWzY6mNVlyHcAjbArpBGBpJ/D/vymmRgSFgkSt/yPVhMdfDilm8DhdM0YoZntn+nSSYurnFgZvZGoI1c/8S0XxusKTXW+yhUo47mVQeHX+nnY3nheTr/S11dl45w==
Received: from YT4PR01CA0049.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:111::14)
 by CH3PR12MB8234.namprd12.prod.outlook.com (2603:10b6:610:125::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 14:11:43 +0000
Received: from BL02EPF00021F6D.namprd02.prod.outlook.com
 (2603:10b6:b01:111:cafe::91) by YT4PR01CA0049.outlook.office365.com
 (2603:10b6:b01:111::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 14:11:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F6D.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 14:11:43 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 07:11:13 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 07:11:13 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 07:11:09 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 13/15] RDMA/mlx5: Set QP event handler before firmware QPC insertion
Date: Tue, 15 Sep 2026 17:09:31 +0300
Message-ID: <20260915140933.40580-14-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6D:EE_|CH3PR12MB8234:EE_
X-MS-Office365-Filtering-Correlation-Id: 3add4ce1-2e56-4bf0-d8e8-08df1333453b
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|36860700016|376014|7416014|10067099003|3023799007|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	fqToJssD/w7JJoAANxusxHvlLUuZn4N7aWPAZmOP9vdg+V9vmCXhYSYEioUzJFkd7CpeF/16LCkUGkUcY9I1M9g87p/0aUqSAF4ahbcOVSfG8HqZ5bb2k04QDZI4DjCksq6DzwAtBE8ZFX7oBf4Esi3I27asmhzHCVTpHNmQxbobp7HudGDr3LXKoCPv52eYrcdc7W4JTrAUx827qcJeJSeluSN5pkJi3YKy6CriNe0mk+DzMbRzPsqVifLWxcd8e+YkzUuKmveO5l93qdjbY/P502h1vG7gPH+xF6NotvNQd3He9/x6NFlcEPv2lYH6ibsepouNc7VT4uSxcGWK6LHCKLJlyJGr+AAw59ALXDsUOScBjjwwtvYnO3INCHMqOK7samx+TQ6TAPwceXyTJklO+fNC3red+ycsLKtQBypjLXuy5LmbPnD2U3p+lbH4hKYUVEksNhSTXoILz/0gwxeXhcumQ+im0KKykyT3631n9S+eAefmroxIx71xqBwo+FWUcTROisAkRvPiYImtHJp3Mx/4czsD8aAFl+3Ua9Jmp8c6+TaI/pvPl4OkAq/ciaPVzusaPZqhDCusLdC8xT7DOEYJ6tvAUuGE3e531ecxaykfnyzNlU41UOFDgVMwx3CaoPdNwSEqP3rAY6tAbIYWa+ggf28gWKXSKnMJIgPYoOe++YET9tPkgMvCnJypjjxJ8iY3SHkJyOr/Hyx6jA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(36860700016)(376014)(7416014)(10067099003)(3023799007)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	S6MCxD9a4L6e6ASfCLsraoLjd+XeDFPodtodpwBLW97+gfMwfBIIofvozakh5hTrVIYI45N1cRuGnWutnt2QxeHM0Pg049IMgRl2TAo4ZkAkz4/h9RwaLya7YxtOl3jY0C7xZgCrlYbcczV6YTyvsXH37RNV6phxjxTWsrCJt609R0JsnITadbDWlcCtO3X9wK3FPJrQlSz52ZtVi/89ZFUkxfp1LREQLJ8isfgHk3xAledrKFIqdEs4vacgr/iBM57pvrsSzt//llsyG1TNMinQIFOpxZeq1jnAiCpdcWlmOgrmZcVAgJhbrDu9RGNtKD8+O+53jYbHYLS8ghOFsGIDVp9bb9ZHNXVlX+NptEIygycqTE6y4FbBIzj9RvSvcdzpfp/st+MXlZIsyW9aTLF0cuVQZMdjiBek3tHbKvBYXlyYAn/WAwqhPbiMT1iZ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 14:11:43.3914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3add4ce1-2e56-4bf0-d8e8-08df1333453b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8234

Four QP creation paths assigned base->container_mibqp and
base->mqp.event after the firmware create call that inserts the QP into
dev->qp_table.tree. A firmware error EQE in that window reaches
qp->event() with a NULL pointer.

Move both assignments before the firmware call.

Also set ibqp.qp_num inside mlx5_qpc_create_qp() before
create_resource_common() so an EQE arriving early does not observe
qp_num==0.

In addition, add a WARN_ON_ONCE(!qp->event) guard in
rsc_event_notifier() as a safeguard for future regressions.

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

