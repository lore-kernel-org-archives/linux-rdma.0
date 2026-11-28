Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795870911;
	b=tlNPTArLR3qf+JCuWRaHYHum4I/6A39Cjec7Pr8YunpwmL42JJK19gWEsh6JBAtoCoaU
	 XvITSpOlO8g0hImPCM3SC3hgGbeJ9SVDJxsYNbADABSWjL4R8mhz3yd2YGeXNtIyATwuK
	 0swqSElFfQpBCl4DeZVTgSpeDVm6CYceB7/F0UiTfAONe4r136CilyMbmXAW7l2kLeZPS
	 LhQu8vpdZppPRbVqNWgr3CThM19qx6X4VxQMe80knBtcWqPxkZdqYbnZJePoCHvGYsPBU
	 gddaMKOTLqarGWinh4wg8GIARzXTE9vWaExJZJ2Xu3wB/FvLJoUs6HiVXBBAQYFwTAQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795870911;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:References:In-Reply-To:To:CC:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=jgJClTwJzZ0uFZjTmxQpT7qLKJwHwwz9DUEEazJvI/c=;
	b=GMNomhaWCDMq6UTF2/JDJLtfGc5DovUTuwLmEHDAjEmaubqoVAgDQqkthSgXEjlRzCkN
	 Idt2go3gxGy8KZQ1FpqHF6yug8071oKjsKAZ/1P1PDy6slxVcAXOIA9X2LBiqxsvJLXGp
	 3ZA8VIdodCaFUctnduxX5mcoMIzY7vsCwSAriyN1SlKoOTKgxDPD0g9MgU5bMENkTRnxy
	 6aCeg6/dnoEaM2fwmoIPK5bAHguPwTvjAbnX7HNNRbmO00NtdpWDHvgGlFxPKEo9s9biN
	 Q/9EDRnaiwPK6Eqd/6X9Zu1RvHeO+0xQ8qpKOA2Ce2J0HqJwOHlA7HuWpsKC2AECzqw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ph9UoM2m;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.10
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010010.outbound.protection.outlook.com [52.101.201.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B4B606A338;
	Sat, 28 Nov 2026 13:01:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35B4B606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ph9UoM2m
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E34wVhcMDB0BnGegWYemijjRYncb15KjgIa+X5bOKpFe7T7bdSgKGR3Zo7k5DzElBqanZZ+2IPpGfdT0BXA4u2mQ6pR+pO1xeueh/A+KOPQj/fw0vJvYr9sSd3ihCgyxSV5hCf1FmiY79evA8BwKlNeW1uhp8NKp35IGoxqA+fHGID9F2TdRBDh1wG+Pqy7PC2164PkW1vDtHaCbWEdU/bpUXqknaF/P839sX4tHoAPkDlrD1QGNuM6mKlQ5KaucL/Hdo7XDrkGRl75XhiLVdT1MNBvlbsbclDJu77Q2jtEUPpjtv/mV3H3XUBEh8owxQ2n/xy1PLRxAKBtn+oeW+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jgJClTwJzZ0uFZjTmxQpT7qLKJwHwwz9DUEEazJvI/c=;
 b=mqdDEBDkiiGoDub6to1QoCh+5fCxI1WD6velUSjd0y2HPH0agW2KMiYKnf9ykIm0CaIWho5gBEqde3JxkNIemI0v7MZlSsg/A37uW9e4Nx9Aj16mLDxwXffKbEPKs0JCktgBSM2EWuOXMb0JYO7oX8mniJNusKrBznTAcQlQIDkx8OMBhnX0Ug+mqOd2mSwmg5NnZshfMQU1aHRvj66jECeNFhPehQ8Fyh1+kQlVwEhfMQ7zYYXk/Vqthwvja+zJISK8HAFII7WjNBrnvqUcYzOP3oSLAMnLkDB25Vkg9Qz0GHUhzBrReZbU8D/jTDZKKSp0Ibm2LMdNq2zHZPBz1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgJClTwJzZ0uFZjTmxQpT7qLKJwHwwz9DUEEazJvI/c=;
 b=ph9UoM2m7DdcEVCJtH2kGR2U0j3NjYmWJyMhPfcDvdXPLldxTgrAL/CYkwLPOT+xt8xf+9iTACBrhwp14P33xD2pWF7zasEvjlAfaGKbbnmVKMsCPH4oEOb01c49L+kwSqcxi7p+qHKp8blUfB3NCJe+0M56kxJbslf1SXTXO4gqsZsfeDWZ+prZwpDWT2LA6YiEbzmNSOoEb4AFpxUV8lXmcanUgvZNdsuXErYvz/VGRw9UXvpg9TGIfqdkljV+AW2HXG4kIVTpc+DGpL1t/wRtZiP5MrA0Qmx1YBnrWB6B5vPo0b5M5L3cfD9s/DuvwtRIR9K9G01dvFrY0PILCw==
Received: from BN9PR03CA0398.namprd03.prod.outlook.com (2603:10b6:408:111::13)
 by IA1PR12MB7685.namprd12.prod.outlook.com (2603:10b6:208:423::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.10; Sat, 28 Nov
 2026 13:01:41 +0000
Received: from BN5PEPF0004698C.namprd02.prod.outlook.com
 (2603:10b6:408:111:cafe::3a) by BN9PR03CA0398.outlook.office365.com
 (2603:10b6:408:111::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Sat,
 28 Nov 2026 13:01:41 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN5PEPF0004698C.mail.protection.outlook.com (10.167.245.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Sat, 28 Nov 2026 13:01:41 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:01:31 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sat, 28 Nov 2026 05:01:30 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sat, 28 Nov 2026 05:01:29 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sat, 28 Nov 2026 15:01:17 +0200
Subject: [PATCH rdma-next v2 04/11] RDMA/mlx5: Select the core device
 through PD for QP commands
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261128-mlx5-sd-prep-v2-4-751878123711@nvidia.com>
References: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
In-Reply-To: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Akiva Goldberger <agoldberger@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795870878; l=28334;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=AYaM2y/fhNNMZLbu7rbeNOaefAwgru+n10PwrvQ9ZHM=;
 b=PZdjNCF9IwGDs2tK8yp/wUA9GFS7V04/2nwpntcGBtynFup55PmG34jCExmRegIbkXnDlK7dN
 88Bb9ZV/XliAalpScKh97Y8EvYsrWFIpLjSWR24uHxPSZGGuT+iABEg
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN5PEPF0004698C:EE_|IA1PR12MB7685:EE_
X-MS-Office365-Filtering-Correlation-Id: b3227bc9-f476-4038-79f0-08df4d4fbf45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|82310400026|376014|261102123227099003|261021123027099003|261022105027099003|261021121427099003|261026121527099003|261026140227099003|261028144727099003|56012099006|260925021311599003|260925022911599003|260925021911599003|11063799006|10067099003|22082099003|18002099003|261009223027099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	3Ow0GPMDof8ouiew02n5+3p3T9OpFd3PNCzv+X9bZgqsf8GN2OBpJ/ZKDIJA2Qx5cOt8WK+/9NGr1X3qpzZfPIHkHnNIhtYy0pZ7qgxV8qocBOlwoWLgLzpp6S4qfAPSerewIywDFJ6/3UsVEiTP0ugcUlUfmW6Ui9qfYnYjQZoSLThpDG38dJzfwUr31J0uIFj053duqR6Mc3vlYEnBna6NZ2IWroQ/TTkznNj1H1OKBAXuTM6Nn+tA6GQqzmfoQ/+8pMrBTJrXC/VHXK36rfeZg0sw8c4QBxzXoE5YKTSbt7BVYdbX4iqBRkAoj7Pnfftmh1dvSmSdeRn6+Sxa+jVY356Jbey7N9UQ8MdD0kKa0vfTQdUYdPPet7BYkgAN/Wx1uHv5LgeCdgvH4mg7UALE8mfmeFPaxh/QEvWKZ3es5gUCIxvtspPLRttkxyhmqaBY7dhVcIhCcm7RcBoHxhGJuPckJHq/AUA8qUm5Ra7xr10ofMfnu+NWGvW8DDANSf20bJAGISs//5VM5mZMT5o7ghysUiDNz7s8x8iGzfbzSmN/UW9uPk6IT07S76tQKTvJHPvuAHrEApAZRKnees0MYSVBcpOwOjPg96D1b1BRczMH8p75jeAU3wNSpOnJKSezwrAlsx7P8WyEToYC00sxJj81XG0jDVzBBgi6Hf24AbhjqnCn1v0tXv5sngOBfjGCqgOT4tnLGh7iAHBhkw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(82310400026)(376014)(261102123227099003)(261021123027099003)(261022105027099003)(261021121427099003)(261026121527099003)(261026140227099003)(261028144727099003)(56012099006)(260925021311599003)(260925022911599003)(260925021911599003)(11063799006)(10067099003)(22082099003)(18002099003)(261009223027099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oKyRaCuiVCUwGKuiIoEev4o1sxzljkTqvdkhZw5G8tXUWlWCh4B+rdrbAfEiBUS5dHJ6hv1DxFlAYzzu/NuUHLPyFnyvA+2zjC1D9v2rxFyy5lz3cK3yRcDb710v2noBzClQbOhI22vpCN5NV0OuYpY+5eTBsHhBHwf8T8sQplrX9Q91nVDYEHTSfPv/1Kcx2uPKpFJnDdoTdC2BFxDc+pFrPu+aOj01y52Z/ot2mOK0ThuY9kxcNZrq7XiP4XD/p99RaydUGiJZmYdqyryLPccvSgZhyqWBktM3gv4fXXjWz02WQjA3GmSjJ3bgU4yJo5aOOzonJlRfAEjeHHG0kUfMKQaycqpnJJCGjOGEHyccIzTwclM8EENbcm1xJ2rB1LHYBUkP7q9YfpArazbasq4OrLb2MN3he2ICAE6eoNU7DlS+/ZLy0OXLhcYanKe6
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2026 13:01:41.4855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3227bc9-f476-4038-79f0-08df4d4fbf45
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN5PEPF0004698C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7685

From: Akiva Goldberger <agoldberger@nvidia.com>

All QPs are bound to a PD, either through ibqp->pd or, for XRC target
QPs, through the devr.p0 PD. Add qp_to_mdev() to derive the core device
from a QP through its associated PD.

A DCT is created either by verbs, inside an mlx5_ib_qp, or by DEVX,
inside a devx_obj, so the DCT commands cannot reach its PD the same way.
Rather than store a core device in every DCT, have their callers pass
it, resolved from the QP or the ucontext that owns the DCT.

No functional change.

Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c    |  11 ++--
 drivers/infiniband/hw/mlx5/main.c    |   3 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  23 ++++++++
 drivers/infiniband/hw/mlx5/qp.c      |  59 +++++++++----------
 drivers/infiniband/hw/mlx5/qp.h      |  32 +++++------
 drivers/infiniband/hw/mlx5/qpc.c     | 107 +++++++++++++++++++----------------
 6 files changed, 136 insertions(+), 99 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 9c5527a10d0ac832859cbf8e948addb3c50c4bed..2317220e9cacaa31fbc2455b5da5aa5af301622a 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1469,7 +1469,8 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 	if (obj->flags & DEVX_OBJ_FLAGS_HW_FREED)
 		ret = 0;
 	else if (obj->flags & DEVX_OBJ_FLAGS_DCT)
-		ret = mlx5_core_destroy_dct(obj->ib_dev, &obj->core_dct);
+		ret = mlx5_core_destroy_dct(obj->ib_dev, obj->ib_dev->mdev,
+					    &obj->core_dct);
 	else if (obj->flags & DEVX_OBJ_FLAGS_CQ)
 		ret = mlx5_core_destroy_cq(obj->ib_dev->mdev, &obj->core_cq);
 	else
@@ -1572,8 +1573,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 
 	if (opcode == MLX5_CMD_OP_CREATE_DCT) {
 		obj->flags |= DEVX_OBJ_FLAGS_DCT;
-		err = mlx5_core_create_dct(dev, &obj->core_dct, cmd_in,
-					   cmd_in_len, cmd_out, cmd_out_len);
+		err = mlx5_core_create_dct(dev, dev->mdev, &obj->core_dct,
+					   cmd_in, cmd_in_len, cmd_out,
+					   cmd_out_len);
 	} else if (opcode == MLX5_CMD_OP_CREATE_CQ &&
 		   !is_apu_cq(dev, cmd_in)) {
 		obj->flags |= DEVX_OBJ_FLAGS_CQ;
@@ -1631,7 +1633,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 
 obj_destroy:
 	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
-		mlx5_core_destroy_dct(obj->ib_dev, &obj->core_dct);
+		mlx5_core_destroy_dct(obj->ib_dev, obj->ib_dev->mdev,
+				      &obj->core_dct);
 	else if (obj->flags & DEVX_OBJ_FLAGS_CQ)
 		mlx5_core_destroy_cq(obj->ib_dev->mdev, &obj->core_cq);
 	else
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 6dc25fae205656725d9a118379af04cca41f080f..5bba04ac16d5b749ddb50ae7ec7823a7a0115fc9 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3030,7 +3030,8 @@ static void delay_drop_handler(struct work_struct *work)
 	atomic_inc(&delay_drop->events_cnt);
 
 	mutex_lock(&delay_drop->lock);
-	err = mlx5_core_set_delay_drop(delay_drop->dev, delay_drop->timeout);
+	err = mlx5_core_set_delay_drop(delay_drop->dev->mdev,
+				       delay_drop->timeout);
 	if (err) {
 		mlx5_ib_warn(delay_drop->dev, "Failed to set delay drop, timeout=%u\n",
 			     delay_drop->timeout);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index c8b658c963b2cfebec49d423dfdebb8a09a597e4..03261e22de9bd1532d50d8024ae989d5af0ffaa8 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1277,6 +1277,29 @@ static inline struct mlx5_core_dev *__mlx5_ib_pd_to_mdev(struct mlx5_ib_pd *pd)
 		struct ib_pd * : __ib_pd_to_mdev, \
 		struct mlx5_ib_pd * : __mlx5_ib_pd_to_mdev)(pd)
 
+static inline struct mlx5_core_dev *__ibqp_to_mdev(struct ib_qp *ibqp)
+{
+	struct ib_pd *pd = ibqp->pd ?: to_dev(ibqp->device)->devr.p0;
+
+	return pd_to_mdev(pd);
+}
+
+static inline struct mlx5_core_dev *__mlx5_ibqp_to_mdev(struct mlx5_ib_qp *qp)
+{
+	return __ibqp_to_mdev(&qp->ibqp);
+}
+
+static inline struct mlx5_core_dev *__mqp_to_mdev(struct mlx5_core_qp *mqp)
+{
+	return __mlx5_ibqp_to_mdev(to_mibqp(mqp));
+}
+
+#define qp_to_mdev(q) \
+	_Generic((q), \
+		struct ib_qp * : __ibqp_to_mdev, \
+		struct mlx5_ib_qp * : __mlx5_ibqp_to_mdev, \
+		struct mlx5_core_qp * : __mqp_to_mdev)(q)
+
 static inline struct mlx5_core_dev *srq_to_mdev(struct mlx5_core_srq *msrq)
 {
 	return pd_to_mdev(to_mibsrq(msrq)->ibsrq.pd);
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index b8ca60903090298a41c11df2e10f612a10236fca..416d3abfaeee0773bee5c1cf9245c373c3568449 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -326,22 +326,22 @@ int mlx5_ib_read_wqe_srq(struct mlx5_ib_srq *srq, int wqe_index, void *buffer,
 
 static void mlx5_ib_qp_err_syndrome(struct ib_qp *ibqp)
 {
-	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
+	struct mlx5_core_dev *mdev = qp_to_mdev(ibqp);
 	int outlen = MLX5_ST_SZ_BYTES(query_qp_out);
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
 	void *pas_ext_union, *err_syn;
 	u32 *outb;
 	int err;
 
-	if (!MLX5_CAP_GEN(dev->mdev, qpc_extension) ||
-	    !MLX5_CAP_GEN(dev->mdev, qp_error_syndrome))
+	if (!MLX5_CAP_GEN(mdev, qpc_extension) ||
+	    !MLX5_CAP_GEN(mdev, qp_error_syndrome))
 		return;
 
 	outb = kzalloc(outlen, GFP_KERNEL);
 	if (!outb)
 		return;
 
-	err = mlx5_core_qp_query(dev, &qp->trans_qp.base.mqp, outb, outlen,
+	err = mlx5_core_qp_query(mdev, &qp->trans_qp.base.mqp, outb, outlen,
 				 true);
 	if (err)
 		goto out;
@@ -1435,7 +1435,7 @@ static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
 	pas = (__be64 *)MLX5_ADDR_OF(wq, wq, pas);
 	mlx5_ib_populate_pas(sq->ubuffer.umem, page_size, pas, 0);
 
-	err = mlx5_core_create_sq_tracked(dev, in, inlen, &sq->base.mqp);
+	err = mlx5_core_create_sq_tracked(pd, in, inlen, &sq->base.mqp);
 
 	kvfree(in);
 
@@ -1451,11 +1451,10 @@ static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
 	return err;
 }
 
-static void destroy_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
-				     struct mlx5_ib_sq *sq)
+static void destroy_raw_packet_qp_sq(struct ib_pd *pd, struct mlx5_ib_sq *sq)
 {
 	destroy_flow_rule_vport_sq(sq);
-	mlx5_core_destroy_sq_tracked(dev, &sq->base.mqp);
+	mlx5_core_destroy_sq_tracked(pd, &sq->base.mqp);
 	ib_umem_release(sq->ubuffer.umem);
 }
 
@@ -1522,17 +1521,16 @@ static int create_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 	pas = (__be64 *)MLX5_ADDR_OF(wq, wq, pas);
 	mlx5_ib_populate_pas(umem, page_size, pas, 0);
 
-	err = mlx5_core_create_rq_tracked(dev, in, inlen, &rq->base.mqp);
+	err = mlx5_core_create_rq_tracked(pd, in, inlen, &rq->base.mqp);
 
 	kvfree(in);
 
 	return err;
 }
 
-static void destroy_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
-				     struct mlx5_ib_rq *rq)
+static void destroy_raw_packet_qp_rq(struct ib_pd *pd, struct mlx5_ib_rq *rq)
 {
-	mlx5_core_destroy_rq_tracked(dev, &rq->base.mqp);
+	mlx5_core_destroy_rq_tracked(pd, &rq->base.mqp);
 }
 
 static void destroy_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
@@ -1686,11 +1684,11 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	return 0;
 
 err_destroy_rq:
-	destroy_raw_packet_qp_rq(dev, rq);
+	destroy_raw_packet_qp_rq(pd, rq);
 err_destroy_sq:
 	if (!qp->sq.wqe_cnt)
 		return err;
-	destroy_raw_packet_qp_sq(dev, sq);
+	destroy_raw_packet_qp_sq(pd, sq);
 err_destroy_tis:
 	destroy_raw_packet_qp_tis(dev, sq, pd);
 
@@ -1706,11 +1704,11 @@ static void destroy_raw_packet_qp(struct mlx5_ib_dev *dev,
 
 	if (qp->rq.wqe_cnt) {
 		destroy_raw_packet_qp_tir(dev, rq, qp->flags_en, qp->ibqp.pd);
-		destroy_raw_packet_qp_rq(dev, rq);
+		destroy_raw_packet_qp_rq(qp->ibqp.pd, rq);
 	}
 
 	if (qp->sq.wqe_cnt) {
-		destroy_raw_packet_qp_sq(dev, sq);
+		destroy_raw_packet_qp_sq(qp->ibqp.pd, sq);
 		destroy_raw_packet_qp_tis(dev, sq, qp->ibqp.pd);
 	}
 }
@@ -2718,7 +2716,7 @@ static void destroy_qp_common(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (qp->state != IB_QPS_RESET) {
 		if (qp->type != IB_QPT_RAW_PACKET &&
 		    !(qp->flags & IB_QP_CREATE_SOURCE_QPN)) {
-			err = mlx5_core_qp_modify(dev, MLX5_CMD_OP_2RST_QP, 0,
+			err = mlx5_core_qp_modify(MLX5_CMD_OP_2RST_QP, 0,
 						  NULL, &base->mqp, NULL);
 		} else {
 			struct mlx5_modify_raw_qp_param raw_qp_param = {
@@ -3252,7 +3250,8 @@ static int mlx5_ib_destroy_dct(struct mlx5_ib_qp *mqp)
 	if (mqp->state == IB_QPS_RTR) {
 		int err;
 
-		err = mlx5_core_destroy_dct(dev, &mqp->dct.mdct);
+		err = mlx5_core_destroy_dct(dev, qp_to_mdev(mqp),
+					    &mqp->dct.mdct);
 		if (err) {
 			mlx5_ib_warn(dev, "failed to destroy DCT %d\n", err);
 			return err;
@@ -4546,7 +4545,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 					ucmd->ece_options : 0;
 			resp->response_length = sizeof(*resp);
 		}
-		err = mlx5_core_qp_modify(dev, op, optpar, qpc, &base->mqp,
+		err = mlx5_core_qp_modify(op, optpar, qpc, &base->mqp,
 					  &resp->ece_options);
 
 		if (err) {
@@ -4754,7 +4753,8 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			MLX5_SET(dctc, dctc, dp_ordering_force, 1);
 		}
 
-		err = mlx5_core_create_dct(dev, &qp->dct.mdct, qp->dct.in,
+		err = mlx5_core_create_dct(dev, qp_to_mdev(qp), &qp->dct.mdct,
+					   qp->dct.in,
 					   MLX5_ST_SZ_BYTES(create_dct_in), out,
 					   sizeof(out));
 		err = mlx5_cmd_check(dev->mdev, err, qp->dct.in, out);
@@ -4765,7 +4765,8 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			resp.ece_options = MLX5_GET(create_dct_out, out, ece);
 		err = ib_respond_udata(udata, resp);
 		if (err) {
-			mlx5_core_destroy_dct(dev, &qp->dct.mdct);
+			mlx5_core_destroy_dct(dev, qp_to_mdev(qp),
+					      &qp->dct.mdct);
 			return err;
 		}
 	} else {
@@ -5118,8 +5119,8 @@ static int query_qp_attr(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (!outb)
 		return -ENOMEM;
 
-	err = mlx5_core_qp_query(dev, &qp->trans_qp.base.mqp, outb, outlen,
-				 false);
+	err = mlx5_core_qp_query(qp_to_mdev(qp), &qp->trans_qp.base.mqp, outb,
+				 outlen, false);
 	if (err)
 		goto out;
 
@@ -5197,7 +5198,7 @@ static int mlx5_ib_dct_query_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *mqp,
 	if (!out)
 		return -ENOMEM;
 
-	err = mlx5_core_dct_query(dev, dct, out, outlen);
+	err = mlx5_core_dct_query(qp_to_mdev(mqp), dct, out, outlen);
 	if (err)
 		goto out;
 
@@ -5357,7 +5358,7 @@ static int set_delay_drop(struct mlx5_ib_dev *dev)
 	if (dev->delay_drop.activate)
 		goto out;
 
-	err = mlx5_core_set_delay_drop(dev, dev->delay_drop.timeout);
+	err = mlx5_core_set_delay_drop(dev->mdev, dev->delay_drop.timeout);
 	if (err)
 		goto out;
 
@@ -5469,13 +5470,13 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 	}
 	rq_pas0 = (__be64 *)MLX5_ADDR_OF(wq, wq, pas);
 	mlx5_ib_populate_pas(rwq->umem, 1UL << rwq->page_shift, rq_pas0, 0);
-	err = mlx5_core_create_rq_tracked(dev, in, inlen, &rwq->core_qp);
+	err = mlx5_core_create_rq_tracked(pd, in, inlen, &rwq->core_qp);
 	if (!err && init_attr->create_flags & IB_WQ_FLAGS_DELAY_DROP) {
 		err = set_delay_drop(dev);
 		if (err) {
 			mlx5_ib_warn(dev, "Failed to enable delay drop err=%d\n",
 				     err);
-			mlx5_core_destroy_rq_tracked(dev, &rwq->core_qp);
+			mlx5_core_destroy_rq_tracked(pd, &rwq->core_qp);
 		} else {
 			rwq->create_flags |= MLX5_IB_WQ_FLAGS_DELAY_DROP;
 		}
@@ -5642,7 +5643,7 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 	return &rwq->ibwq;
 
 err_copy:
-	mlx5_core_destroy_rq_tracked(dev, &rwq->core_qp);
+	mlx5_core_destroy_rq_tracked(pd, &rwq->core_qp);
 err_user_rq:
 	destroy_user_rq(dev, pd, rwq, udata);
 err:
@@ -5656,7 +5657,7 @@ int mlx5_ib_destroy_wq(struct ib_wq *wq, struct ib_udata *udata)
 	struct mlx5_ib_rwq *rwq = to_mrwq(wq);
 	int ret;
 
-	ret = mlx5_core_destroy_rq_tracked(dev, &rwq->core_qp);
+	ret = mlx5_core_destroy_rq_tracked(wq->pd, &rwq->core_qp);
 	if (ret)
 		return ret;
 	destroy_user_rq(dev, wq->pd, rwq, udata);
diff --git a/drivers/infiniband/hw/mlx5/qp.h b/drivers/infiniband/hw/mlx5/qp.h
index 2530e7730635f30cf6b2fe9b54a3c61de5d1f53c..9dabf0326071814eb44c47637ef95e6088ba35d8 100644
--- a/drivers/infiniband/hw/mlx5/qp.h
+++ b/drivers/infiniband/hw/mlx5/qp.h
@@ -21,29 +21,29 @@ struct mlx5_qp_table {
 int mlx5_init_qp_table(struct mlx5_ib_dev *dev);
 void mlx5_cleanup_qp_table(struct mlx5_ib_dev *dev);
 
-int mlx5_core_create_dct(struct mlx5_ib_dev *dev, struct mlx5_core_dct *qp,
-			 u32 *in, int inlen, u32 *out, int outlen);
+int mlx5_core_create_dct(struct mlx5_ib_dev *dev, struct mlx5_core_dev *mdev,
+			 struct mlx5_core_dct *qp, u32 *in, int inlen,
+			 u32 *out, int outlen);
 int mlx5_qpc_create_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp,
 		       u32 *in, int inlen, u32 *out);
-int mlx5_core_qp_modify(struct mlx5_ib_dev *dev, u16 opcode, u32 opt_param_mask,
-			void *qpc, struct mlx5_core_qp *qp, u32 *ece);
+int mlx5_core_qp_modify(u16 opcode, u32 opt_param_mask, void *qpc,
+			struct mlx5_core_qp *qp, u32 *ece);
 int mlx5_core_destroy_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp);
-int mlx5_core_destroy_dct(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct);
-int mlx5_core_qp_query(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp,
+int mlx5_core_destroy_dct(struct mlx5_ib_dev *dev, struct mlx5_core_dev *mdev,
+			  struct mlx5_core_dct *dct);
+int mlx5_core_qp_query(struct mlx5_core_dev *mdev, struct mlx5_core_qp *qp,
 		       u32 *out, int outlen, bool qpc_ext);
-int mlx5_core_dct_query(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct,
+int mlx5_core_dct_query(struct mlx5_core_dev *mdev, struct mlx5_core_dct *dct,
 			u32 *out, int outlen);
 
-int mlx5_core_set_delay_drop(struct mlx5_ib_dev *dev, u32 timeout_usec);
+int mlx5_core_set_delay_drop(struct mlx5_core_dev *mdev, u32 timeout_usec);
 
-int mlx5_core_destroy_rq_tracked(struct mlx5_ib_dev *dev,
-				 struct mlx5_core_qp *rq);
-int mlx5_core_create_sq_tracked(struct mlx5_ib_dev *dev, u32 *in, int inlen,
+int mlx5_core_destroy_rq_tracked(struct ib_pd *pd, struct mlx5_core_qp *rq);
+int mlx5_core_create_sq_tracked(struct ib_pd *pd, u32 *in, int inlen,
 				struct mlx5_core_qp *sq);
-void mlx5_core_destroy_sq_tracked(struct mlx5_ib_dev *dev,
-				  struct mlx5_core_qp *sq);
+void mlx5_core_destroy_sq_tracked(struct ib_pd *pd, struct mlx5_core_qp *sq);
 
-int mlx5_core_create_rq_tracked(struct mlx5_ib_dev *dev, u32 *in, int inlen,
+int mlx5_core_create_rq_tracked(struct ib_pd *pd, u32 *in, int inlen,
 				struct mlx5_core_qp *rq);
 
 struct mlx5_core_rsc_common *mlx5_core_res_hold(struct mlx5_ib_dev *dev,
@@ -51,8 +51,8 @@ struct mlx5_core_rsc_common *mlx5_core_res_hold(struct mlx5_ib_dev *dev,
 						enum mlx5_res_type res_type);
 void mlx5_core_res_put(struct mlx5_core_rsc_common *res);
 
-int mlx5_core_xrcd_alloc(struct mlx5_ib_dev *dev, u32 *xrcdn);
-int mlx5_core_xrcd_dealloc(struct mlx5_ib_dev *dev, u32 xrcdn);
+int mlx5_core_xrcd_alloc(struct mlx5_core_dev *mdev, u32 *xrcdn);
+int mlx5_core_xrcd_dealloc(struct mlx5_core_dev *mdev, u32 xrcdn);
 int mlx5_ib_qp_set_counter(struct ib_qp *qp, struct rdma_counter *counter);
 int mlx5_ib_qp_event_init(void);
 void mlx5_ib_qp_event_cleanup(void);
diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index a1b15c0346d34e9b969a2b60298b78930d8769d6..5fde1570c75da4d91aa3dc9de2962e89d21a2448 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -9,7 +9,7 @@
 #include "mlx5_ib.h"
 #include "qp.h"
 
-static int mlx5_core_drain_dct(struct mlx5_ib_dev *dev,
+static int mlx5_core_drain_dct(struct mlx5_core_dev *mdev,
 			       struct mlx5_core_dct *dct);
 
 static struct mlx5_core_rsc_common *
@@ -208,7 +208,7 @@ static void destroy_resource_common(struct mlx5_ib_dev *dev,
 	wait_for_completion(&qp->common.free);
 }
 
-static int _mlx5_core_destroy_dct(struct mlx5_ib_dev *dev,
+static int _mlx5_core_destroy_dct(struct mlx5_core_dev *mdev,
 				  struct mlx5_core_dct *dct)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_dct_in)] = {};
@@ -217,11 +217,12 @@ static int _mlx5_core_destroy_dct(struct mlx5_ib_dev *dev,
 	MLX5_SET(destroy_dct_in, in, opcode, MLX5_CMD_OP_DESTROY_DCT);
 	MLX5_SET(destroy_dct_in, in, dctn, qp->qpn);
 	MLX5_SET(destroy_dct_in, in, uid, qp->uid);
-	return mlx5_cmd_exec_in(dev->mdev, destroy_dct, in);
+	return mlx5_cmd_exec_in(mdev, destroy_dct, in);
 }
 
-int mlx5_core_create_dct(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct,
-			 u32 *in, int inlen, u32 *out, int outlen)
+int mlx5_core_create_dct(struct mlx5_ib_dev *dev, struct mlx5_core_dev *mdev,
+			 struct mlx5_core_dct *dct, u32 *in, int inlen,
+			 u32 *out, int outlen)
 {
 	struct mlx5_core_qp *qp = &dct->mqp;
 	int err;
@@ -229,7 +230,7 @@ int mlx5_core_create_dct(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct,
 	init_completion(&dct->drained);
 	MLX5_SET(create_dct_in, in, opcode, MLX5_CMD_OP_CREATE_DCT);
 
-	err = mlx5_cmd_do(dev->mdev, in, inlen, out, outlen);
+	err = mlx5_cmd_do(mdev, in, inlen, out, outlen);
 	if (err)
 		return err;
 
@@ -241,19 +242,20 @@ int mlx5_core_create_dct(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct,
 
 	return 0;
 err_cmd:
-	_mlx5_core_destroy_dct(dev, dct);
+	_mlx5_core_destroy_dct(mdev, dct);
 	return err;
 }
 
 int mlx5_qpc_create_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp,
 		       u32 *in, int inlen, u32 *out)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	u32 din[MLX5_ST_SZ_DW(destroy_qp_in)] = {};
 	int err;
 
 	MLX5_SET(create_qp_in, in, opcode, MLX5_CMD_OP_CREATE_QP);
 
-	err = mlx5_cmd_exec(dev->mdev, in, inlen, out,
+	err = mlx5_cmd_exec(mdev, in, inlen, out,
 			    MLX5_ST_SZ_BYTES(create_qp_out));
 	if (err)
 		return err;
@@ -274,7 +276,7 @@ int mlx5_qpc_create_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp,
 		goto err_cmd;
 
 	if (dev->ib_dev.type != RDMA_DEVICE_TYPE_SMI)
-		mlx5_debug_qp_add(dev->mdev, qp);
+		mlx5_debug_qp_add(mdev, qp);
 
 	return 0;
 
@@ -282,11 +284,11 @@ int mlx5_qpc_create_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp,
 	MLX5_SET(destroy_qp_in, din, opcode, MLX5_CMD_OP_DESTROY_QP);
 	MLX5_SET(destroy_qp_in, din, qpn, qp->qpn);
 	MLX5_SET(destroy_qp_in, din, uid, qp->uid);
-	mlx5_cmd_exec_in(dev->mdev, destroy_qp, din);
+	mlx5_cmd_exec_in(mdev, destroy_qp, din);
 	return err;
 }
 
-static int mlx5_core_drain_dct(struct mlx5_ib_dev *dev,
+static int mlx5_core_drain_dct(struct mlx5_core_dev *mdev,
 			       struct mlx5_core_dct *dct)
 {
 	u32 in[MLX5_ST_SZ_DW(drain_dct_in)] = {};
@@ -295,19 +297,19 @@ static int mlx5_core_drain_dct(struct mlx5_ib_dev *dev,
 	MLX5_SET(drain_dct_in, in, opcode, MLX5_CMD_OP_DRAIN_DCT);
 	MLX5_SET(drain_dct_in, in, dctn, qp->qpn);
 	MLX5_SET(drain_dct_in, in, uid, qp->uid);
-	return mlx5_cmd_exec_in(dev->mdev, drain_dct, in);
+	return mlx5_cmd_exec_in(mdev, drain_dct, in);
 }
 
-int mlx5_core_destroy_dct(struct mlx5_ib_dev *dev,
+int mlx5_core_destroy_dct(struct mlx5_ib_dev *dev, struct mlx5_core_dev *mdev,
 			  struct mlx5_core_dct *dct)
 {
 	struct mlx5_qp_table *table = &dev->qp_table;
 	struct mlx5_core_dct *tmp;
 	int err;
 
-	err = mlx5_core_drain_dct(dev, dct);
+	err = mlx5_core_drain_dct(mdev, dct);
 	if (err) {
-		if (dev->mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+		if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 			goto destroy;
 
 		return err;
@@ -319,7 +321,7 @@ int mlx5_core_destroy_dct(struct mlx5_ib_dev *dev,
 	if (WARN_ON(tmp != dct))
 		return xa_err(tmp) ?: -EINVAL;
 
-	err = _mlx5_core_destroy_dct(dev, dct);
+	err = _mlx5_core_destroy_dct(mdev, dct);
 	if (err) {
 		xa_cmpxchg_irq(&table->dct_xa, dct->mqp.qpn, XA_ZERO_ENTRY, dct, 0);
 		return err;
@@ -337,20 +339,21 @@ int mlx5_core_destroy_dct(struct mlx5_ib_dev *dev,
 
 int mlx5_core_destroy_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	u32 in[MLX5_ST_SZ_DW(destroy_qp_in)] = {};
 
 	if (dev->ib_dev.type != RDMA_DEVICE_TYPE_SMI)
-		mlx5_debug_qp_remove(dev->mdev, qp);
+		mlx5_debug_qp_remove(mdev, qp);
 
 	destroy_resource_common(dev, qp);
 
 	MLX5_SET(destroy_qp_in, in, opcode, MLX5_CMD_OP_DESTROY_QP);
 	MLX5_SET(destroy_qp_in, in, qpn, qp->qpn);
 	MLX5_SET(destroy_qp_in, in, uid, qp->uid);
-	return mlx5_cmd_exec_in(dev->mdev, destroy_qp, in);
+	return mlx5_cmd_exec_in(mdev, destroy_qp, in);
 }
 
-int mlx5_core_set_delay_drop(struct mlx5_ib_dev *dev,
+int mlx5_core_set_delay_drop(struct mlx5_core_dev *mdev,
 			     u32 timeout_usec)
 {
 	u32 in[MLX5_ST_SZ_DW(set_delay_drop_params_in)] = {};
@@ -359,7 +362,7 @@ int mlx5_core_set_delay_drop(struct mlx5_ib_dev *dev,
 		 MLX5_CMD_OP_SET_DELAY_DROP_PARAMS);
 	MLX5_SET(set_delay_drop_params_in, in, delay_drop_timeout,
 		 timeout_usec / 100);
-	return mlx5_cmd_exec_in(dev->mdev, set_delay_drop_params, in);
+	return mlx5_cmd_exec_in(mdev, set_delay_drop_params, in);
 }
 
 struct mbox_info {
@@ -509,18 +512,19 @@ static int modify_qp_mbox_alloc(struct mlx5_core_dev *mdev, u16 opcode, int qpn,
 	return 0;
 }
 
-int mlx5_core_qp_modify(struct mlx5_ib_dev *dev, u16 opcode, u32 opt_param_mask,
-			void *qpc, struct mlx5_core_qp *qp, u32 *ece)
+int mlx5_core_qp_modify(u16 opcode, u32 opt_param_mask, void *qpc,
+			struct mlx5_core_qp *qp, u32 *ece)
 {
+	struct mlx5_core_dev *mdev = qp_to_mdev(qp);
 	struct mbox_info mbox;
 	int err;
 
-	err = modify_qp_mbox_alloc(dev->mdev, opcode, qp->qpn, opt_param_mask,
+	err = modify_qp_mbox_alloc(mdev, opcode, qp->qpn, opt_param_mask,
 				   qpc, &mbox, qp->uid, (ece) ? *ece : 0);
 	if (err)
 		return err;
 
-	err = mlx5_cmd_exec(dev->mdev, mbox.in, mbox.inlen, mbox.out,
+	err = mlx5_cmd_exec(mdev, mbox.in, mbox.inlen, mbox.out,
 			    mbox.outlen);
 
 	if (ece)
@@ -556,7 +560,7 @@ void mlx5_cleanup_qp_table(struct mlx5_ib_dev *dev)
 		mlx5_qp_debugfs_cleanup(dev->mdev);
 }
 
-int mlx5_core_qp_query(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp,
+int mlx5_core_qp_query(struct mlx5_core_dev *mdev, struct mlx5_core_qp *qp,
 		       u32 *out, int outlen, bool qpc_ext)
 {
 	u32 in[MLX5_ST_SZ_DW(query_qp_in)] = {};
@@ -565,10 +569,10 @@ int mlx5_core_qp_query(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp,
 	MLX5_SET(query_qp_in, in, qpn, qp->qpn);
 	MLX5_SET(query_qp_in, in, qpc_ext, qpc_ext);
 
-	return mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, outlen);
+	return mlx5_cmd_exec(mdev, in, sizeof(in), out, outlen);
 }
 
-int mlx5_core_dct_query(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct,
+int mlx5_core_dct_query(struct mlx5_core_dev *mdev, struct mlx5_core_dct *dct,
 			u32 *out, int outlen)
 {
 	u32 in[MLX5_ST_SZ_DW(query_dct_in)] = {};
@@ -577,49 +581,51 @@ int mlx5_core_dct_query(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct,
 	MLX5_SET(query_dct_in, in, opcode, MLX5_CMD_OP_QUERY_DCT);
 	MLX5_SET(query_dct_in, in, dctn, qp->qpn);
 
-	return mlx5_cmd_exec(dev->mdev, (void *)&in, sizeof(in), (void *)out,
-			     outlen);
+	return mlx5_cmd_exec(mdev, (void *)&in, sizeof(in),
+			     (void *)out, outlen);
 }
 
-int mlx5_core_xrcd_alloc(struct mlx5_ib_dev *dev, u32 *xrcdn)
+int mlx5_core_xrcd_alloc(struct mlx5_core_dev *mdev, u32 *xrcdn)
 {
 	u32 out[MLX5_ST_SZ_DW(alloc_xrcd_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(alloc_xrcd_in)] = {};
 	int err;
 
 	MLX5_SET(alloc_xrcd_in, in, opcode, MLX5_CMD_OP_ALLOC_XRCD);
-	err = mlx5_cmd_exec_inout(dev->mdev, alloc_xrcd, in, out);
+	err = mlx5_cmd_exec_inout(mdev, alloc_xrcd, in, out);
 	if (!err)
 		*xrcdn = MLX5_GET(alloc_xrcd_out, out, xrcd);
 	return err;
 }
 
-int mlx5_core_xrcd_dealloc(struct mlx5_ib_dev *dev, u32 xrcdn)
+int mlx5_core_xrcd_dealloc(struct mlx5_core_dev *mdev, u32 xrcdn)
 {
 	u32 in[MLX5_ST_SZ_DW(dealloc_xrcd_in)] = {};
 
 	MLX5_SET(dealloc_xrcd_in, in, opcode, MLX5_CMD_OP_DEALLOC_XRCD);
 	MLX5_SET(dealloc_xrcd_in, in, xrcd, xrcdn);
-	return mlx5_cmd_exec_in(dev->mdev, dealloc_xrcd, in);
+	return mlx5_cmd_exec_in(mdev, dealloc_xrcd, in);
 }
 
-static int destroy_rq_tracked(struct mlx5_ib_dev *dev, u32 rqn, u16 uid)
+static int destroy_rq_tracked(struct mlx5_core_dev *mdev, u32 rqn, u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_rq_in)] = {};
 
 	MLX5_SET(destroy_rq_in, in, opcode, MLX5_CMD_OP_DESTROY_RQ);
 	MLX5_SET(destroy_rq_in, in, rqn, rqn);
 	MLX5_SET(destroy_rq_in, in, uid, uid);
-	return mlx5_cmd_exec_in(dev->mdev, destroy_rq, in);
+	return mlx5_cmd_exec_in(mdev, destroy_rq, in);
 }
 
-int mlx5_core_create_rq_tracked(struct mlx5_ib_dev *dev, u32 *in, int inlen,
+int mlx5_core_create_rq_tracked(struct ib_pd *pd, u32 *in, int inlen,
 				struct mlx5_core_qp *rq)
 {
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	int err;
 	u32 rqn;
 
-	err = mlx5_core_create_rq(dev->mdev, in, inlen, &rqn);
+	err = mlx5_core_create_rq(mdev, in, inlen, &rqn);
 	if (err)
 		return err;
 
@@ -632,14 +638,14 @@ int mlx5_core_create_rq_tracked(struct mlx5_ib_dev *dev, u32 *in, int inlen,
 	return 0;
 
 err_destroy_rq:
-	destroy_rq_tracked(dev, rq->qpn, rq->uid);
+	destroy_rq_tracked(mdev, rq->qpn, rq->uid);
 
 	return err;
 }
 
-int mlx5_core_destroy_rq_tracked(struct mlx5_ib_dev *dev,
-				 struct mlx5_core_qp *rq)
+int mlx5_core_destroy_rq_tracked(struct ib_pd *pd, struct mlx5_core_qp *rq)
 {
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	int ret;
 
 	/* The rq destruction can be called again in case it fails, hence we
@@ -647,7 +653,7 @@ int mlx5_core_destroy_rq_tracked(struct mlx5_ib_dev *dev,
 	 * is completed successfully we actually destroy the resources.
 	 */
 	modify_resource_common_state(dev, rq, true);
-	ret = destroy_rq_tracked(dev, rq->qpn, rq->uid);
+	ret = destroy_rq_tracked(pd_to_mdev(pd), rq->qpn, rq->uid);
 	if (ret) {
 		modify_resource_common_state(dev, rq, false);
 		return ret;
@@ -656,24 +662,26 @@ int mlx5_core_destroy_rq_tracked(struct mlx5_ib_dev *dev,
 	return 0;
 }
 
-static void destroy_sq_tracked(struct mlx5_ib_dev *dev, u32 sqn, u16 uid)
+static void destroy_sq_tracked(struct mlx5_core_dev *mdev, u32 sqn, u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_sq_in)] = {};
 
 	MLX5_SET(destroy_sq_in, in, opcode, MLX5_CMD_OP_DESTROY_SQ);
 	MLX5_SET(destroy_sq_in, in, sqn, sqn);
 	MLX5_SET(destroy_sq_in, in, uid, uid);
-	mlx5_cmd_exec_in(dev->mdev, destroy_sq, in);
+	mlx5_cmd_exec_in(mdev, destroy_sq, in);
 }
 
-int mlx5_core_create_sq_tracked(struct mlx5_ib_dev *dev, u32 *in, int inlen,
+int mlx5_core_create_sq_tracked(struct ib_pd *pd, u32 *in, int inlen,
 				struct mlx5_core_qp *sq)
 {
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	u32 out[MLX5_ST_SZ_DW(create_sq_out)] = {};
 	int err;
 
 	MLX5_SET(create_sq_in, in, opcode, MLX5_CMD_OP_CREATE_SQ);
-	err = mlx5_cmd_exec(dev->mdev, in, inlen, out, sizeof(out));
+	err = mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
 	if (err)
 		return err;
 
@@ -686,16 +694,17 @@ int mlx5_core_create_sq_tracked(struct mlx5_ib_dev *dev, u32 *in, int inlen,
 	return 0;
 
 err_destroy_sq:
-	destroy_sq_tracked(dev, sq->qpn, sq->uid);
+	destroy_sq_tracked(mdev, sq->qpn, sq->uid);
 
 	return err;
 }
 
-void mlx5_core_destroy_sq_tracked(struct mlx5_ib_dev *dev,
-				  struct mlx5_core_qp *sq)
+void mlx5_core_destroy_sq_tracked(struct ib_pd *pd, struct mlx5_core_qp *sq)
 {
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
+
 	destroy_resource_common(dev, sq);
-	destroy_sq_tracked(dev, sq->qpn, sq->uid);
+	destroy_sq_tracked(pd_to_mdev(pd), sq->qpn, sq->uid);
 }
 
 struct mlx5_core_rsc_common *mlx5_core_res_hold(struct mlx5_ib_dev *dev,

-- 
2.49.0

