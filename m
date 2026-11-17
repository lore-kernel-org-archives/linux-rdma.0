Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794924184;
	b=FD//XWoUgt/E2zDHV7JNDA4Hsa4t7AGER9cwYgS7R8/B/eTc1kUbTZMJOSaTQzqLglwH
	 +VaTPM+5oUR8OAKFjCtTJUDJ/xA7JfOqXqBBvF8sdyQ+D9jxhXiZXzAXpTC5oQ31/gUQg
	 r+gfbyADZmYQiLDnrmQRH/RAkPKNh/lxbflMeo0ZghNTT+NOYj0vg4RMN4B+5LSVjIF7a
	 QdihMnbiQ8y+5MNPzRUoIK/QvHvXa0BCxoIiVGONhOwV45kyzPzwGCezQGeYZGVhbZYrV
	 MXPwf/d6mXTOqOg7VeApcfhsNK1lOzc/vjuyWRbvRUZt2s3s/5fT6tCW4+9pKyKbRGQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924184;
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
	bh=YXBIm33SkPqbUNSRtWdNG/dRHWLfffEixm/wZ73n3x0=;
	b=sNTeQj4TFAubabXjoMFbCxRQPjVIS6WBMHj7PAEV9Z3qd0DilDp0b+dF1eCWV6h+PHOD
	 zl2Z3W0XvUL0Bkuzok87fb7ETOMC6T88F+BT5lY/ZXRp94DL562WankuF7qQkCOs/pRKe
	 9fAGHO7BlkeYPu/uMVGDsGHwJ9Gq0Yayn9VB7eId0XnZKNJ6ECBmDUHrfgOEzrmjY8bHg
	 S6Cbbb1eTAxL2wYiODmnCCD7PHcFsNtdfTBE+IsDzb/qYjVdpCK1elmdQ4xJQnZkE3qEY
	 g6x//eD1H+I0zr8sKRMP5wPQSH/FDQLnjauNI2I6Sr6j4cv3OpehAiCrQkflHylNumA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MWVQcpOx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.15
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011015.outbound.protection.outlook.com [52.101.62.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6D2606A323;
	Tue, 17 Nov 2026 14:03:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A6D2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MWVQcpOx
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WszIwwb6qQG44IVLHC8fGN61jYdlkXqC1Tz4fmcJmBE8mcBFJYVwfXSykx3Ea9cSDu6ViKaIWI012AkJ9gnt08HPgT2U/pU6ZNyb4e3FozLTK9GR7k2+GJ8FJq1gNITZUQj8c4oYG7Vj4R1fFgQwTTzc0t4RA3c3K/e2K05sekU7iaFAIsmi4y/68jA49D9OW3sUfTB8Ca7BRQiJKWar2cRDZzo54UECmlyg4e9m3wyjKD2sCI4T9fu8Q3GtrVKpPhw/d2zkRmObwB7ApRXaAtw/xr+fokKf3xh+W4DuLxGqogO4W7/UZkajOabv85lDFIMLvqtUwcYUyQr0Hznvtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YXBIm33SkPqbUNSRtWdNG/dRHWLfffEixm/wZ73n3x0=;
 b=mZx4/7Ouhbbe75MovRBTSN2Kyh3GkTu57kEhjccS1eygh3OAaQJxgjWextaZIIblb2akJ5iFa0xq7CjTBBwMRu78e7e3mOyL4BdgIlGba09BJqi7EocZTWRVSjSqWidwnwSntqI8yN101l5diYvOHShKnYsdgpQgpwVUNxTZSduGMH81Ud+NA9/A9SAxFzCbVxsWaRpbB0q8bDC3E5E3WSb4nBVKqtJ3mFW7f+1LnE0bclhDiYx0prLgGsShzXWK5TTsUxw9QpK434idmQVwzzR2liMGxn+9vl0c6/ckPTS2K3DWOEvV0Jv5/wwk+NNHzbx6r7QumnCDUzdRDBQwcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YXBIm33SkPqbUNSRtWdNG/dRHWLfffEixm/wZ73n3x0=;
 b=MWVQcpOxnLunTI0o4MC8aE7JtG7Vxx6c5Gth6eeXRlenId0u6inv28bmt+f+4jYKsAs5sbFBdYtpAIRCm91BVAaaz/qdnvIZXuCCOwp6zwcBFfPrsHnAIYWL45pVof9E7lpBSW6d/eryVZb9eBKHOLIZja9Xu9x+dtz3Nn6MSAp3G98pNYbkI10fbzeLMx2aIDP6kzh8qu+kAlaszghqHWyetTD2YF0b22TaOPDyenT7eP1MB1h0PQ9RyvZTSrr1FKV/oFvqooEyO0vRrZAGVv0EgNo34/XifgVXBOhQ8XS/Wx8WkVfXiSa01BFCTu61I/cePEv0A9vZZz1X4gtgDQ==
Received: from SJ0PR03CA0019.namprd03.prod.outlook.com (2603:10b6:a03:33a::24)
 by LV0PR12MB008041.namprd12.prod.outlook.com (2603:10b6:408:3f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 14:02:06 +0000
Received: from MW2PEPF00014676.namprd04.prod.outlook.com
 (2603:10b6:a03:33a:cafe::25) by SJ0PR03CA0019.outlook.office365.com
 (2603:10b6:a03:33a::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Tue,
 17 Nov 2026 14:02:05 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MW2PEPF00014676.mail.protection.outlook.com (10.167.249.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 14:02:05 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 06:01:32 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 17 Nov
 2026 06:01:31 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 17
 Nov 2026 06:01:29 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Tue, 17 Nov 2026 16:01:15 +0200
Subject: [PATCH rdma-next 04/11] RDMA/mlx5: Select the core device through
 PD for QP commands
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
Message-ID: <20261117-mlx5-sd-prep-v1-4-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
In-Reply-To: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	"Sabrina Dubroca" <sd@queasysnail.net>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, Edward Srouji <edwards@nvidia.com>, "Akiva
 Goldberger" <agoldberger@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794924076; l=28334;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=k4ox1iiYm3YHI8yklaE+Hi2O2pL4DcE1fIspxpW5t38=;
 b=EOd/6GC126l1S7UaAALt15I9wsj9+EN+DTOHIFp5/VxHhMraVYfi4uhy+SHgTqnI+kshzg08+
 ATFUBg/S4oPBDqmsmTJJpEj9Sre6yvwdC+vYKcjc73y41FXKdBJAxJ4
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PEPF00014676:EE_|LV0PR12MB008041:EE_
X-MS-Office365-Filtering-Correlation-Id: 28878d3e-b4a7-4008-ee31-08df44b35cbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|23010399003|18002099003|22082099003|261009223027099003|3023799007|56012099006|260925022911599003|11063799006|260925021911599003|260925021311599003|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261021121427099003|261022105027099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	kfboLqqQEs/QbImd0INvOqL5oI1NQkmgFW2X/hHIPlxNpJ8JlzrrT8vzoQtqt9REASPzMB/nky/IFc8L3a8bO2sQo9lfmR28aqoNhHwz+6xcc+65mQaZKSwKEDLsGpBAZj9vQexmNs0m4T1NOLrXPi7fTd4rYZM8MDPRLJeKNJD7xiGpXyT80REoMBvzZUoTMU3VLlSO6Ujhpt+nq/rC65wd9S+JLF9E9b4IaiQ9d46+m7cvFme7+vKq0VY0c07vVl8Xp1zQM3SjuhS+a5CrkoUogeWVQqAaXyg+UdwEnwX/4+NdSSvaNy1a8t7M+cmekMUJkrbXmhfiNCImPeb9Itd89f0a9E3RBNMoM4ONzdCOXgmo35ivUNyLykdlYe4FlQXYCLUSc8PzBq5bfNfmJAHQgQjAMhzqKvWPZTU7ENApbD0up/3JIq1aJWj/GMhmb32Vir4aYihzDaHhx2wKuJTnvlkJFTLYQPUg3wwpCda69QwXEXgZqKds2Y2CQ1vEIWclfJ1PXRyNwSWFhpEHZ1LpBR2Cxy45+9V7kPPEps7nSwvaxoCiDox6FDU92DRVASI5mirAg2/LXcTDq+RrgnSn+KsmirfFQBC7Ykeqr+EemS3n+xW2dS0zkQy4T5eY1ia+4HNdLCpMQipPOOMlaxtBv76bcPOr9daAF3WsKxX5DolK1QN7kSy09CbKazWXbovQAGtcm01hL3pPs+T+Mw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(23010399003)(18002099003)(22082099003)(261009223027099003)(3023799007)(56012099006)(260925022911599003)(11063799006)(260925021911599003)(260925021311599003)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021121427099003)(261022105027099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Z33DSnbUXCqjADY/WF7LMVoFZdWvgh7ec0o5hNPmOwkuItOrVGiJa08JthvANyUlWgAQCUBCS9m9pCHqM3mOUy0vDGcutIhDV9wuDRU+Gm3rbNECpmjGXQtIBKDbvJCC+rpamr+04+cJA/7RLsIfdyiBvoXctaO9+e5LlnEQ4EjpqMSc+HpRtpYJLzxebDHmSqniLK6WPRFSpyE3za/K4mnw0i7Wt7+CMLGtaze4WBhv+RZQqr1nf6wqHEOuzJXi0qj5XUC78tDgNzGHQkuP61zN6gU0XjUWp30xWc+vpqzNQtr/OOSHPDTnCW5/T5NLJmmM5rj6T4TmzfnMV/77+jC0GQfmj+rUQgyM3IGDLqQJPnbDE66uwusGWZD1ijOQf4yh4OuDAZRRi4c122HT4KpwFdwwSI0wPfBiG3VqYtXKZJChH5st741yMa8jMO5T
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 14:02:05.4738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28878d3e-b4a7-4008-ee31-08df44b35cbe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW2PEPF00014676.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB008041

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
index 75f5fc256ff6eab4f3ba2de4c0d9c3d7da8d5432..aa27fce2e197c22a9b2ebdfae5c96cbd0a41102f 100644
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
index 28a2d75b3f37cade52130da86d011965823352bf..4ec9b56afef7d9fb52ebcd22e0858eb741d010be 100644
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
index bbb73314921bdec91186bf5e855850fcb2b30632..feca1db57921f34dcdb687d1eca59fecc2fd385f 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1262,6 +1262,29 @@ static inline struct mlx5_core_dev *__mlx5_ib_pd_to_mdev(struct mlx5_ib_pd *pd)
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
index da4e9a52d2f9b778368ca0ae520442af42cbb23e..2196e06f593e16693f682fc0e9eb7a3b18131f60 100644
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
@@ -1439,7 +1439,7 @@ static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
 	pas = (__be64 *)MLX5_ADDR_OF(wq, wq, pas);
 	mlx5_ib_populate_pas(sq->ubuffer.umem, page_size, pas, 0);
 
-	err = mlx5_core_create_sq_tracked(dev, in, inlen, &sq->base.mqp);
+	err = mlx5_core_create_sq_tracked(pd, in, inlen, &sq->base.mqp);
 
 	kvfree(in);
 
@@ -1455,11 +1455,10 @@ static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
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
 
@@ -1526,17 +1525,16 @@ static int create_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
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
@@ -1690,11 +1688,11 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
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
 
@@ -1710,11 +1708,11 @@ static void destroy_raw_packet_qp(struct mlx5_ib_dev *dev,
 
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
@@ -2722,7 +2720,7 @@ static void destroy_qp_common(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (qp->state != IB_QPS_RESET) {
 		if (qp->type != IB_QPT_RAW_PACKET &&
 		    !(qp->flags & IB_QP_CREATE_SOURCE_QPN)) {
-			err = mlx5_core_qp_modify(dev, MLX5_CMD_OP_2RST_QP, 0,
+			err = mlx5_core_qp_modify(MLX5_CMD_OP_2RST_QP, 0,
 						  NULL, &base->mqp, NULL);
 		} else {
 			struct mlx5_modify_raw_qp_param raw_qp_param = {
@@ -3256,7 +3254,8 @@ static int mlx5_ib_destroy_dct(struct mlx5_ib_qp *mqp)
 	if (mqp->state == IB_QPS_RTR) {
 		int err;
 
-		err = mlx5_core_destroy_dct(dev, &mqp->dct.mdct);
+		err = mlx5_core_destroy_dct(dev, qp_to_mdev(mqp),
+					    &mqp->dct.mdct);
 		if (err) {
 			mlx5_ib_warn(dev, "failed to destroy DCT %d\n", err);
 			return err;
@@ -4550,7 +4549,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 					ucmd->ece_options : 0;
 			resp->response_length = sizeof(*resp);
 		}
-		err = mlx5_core_qp_modify(dev, op, optpar, qpc, &base->mqp,
+		err = mlx5_core_qp_modify(op, optpar, qpc, &base->mqp,
 					  &resp->ece_options);
 
 		if (err) {
@@ -4758,7 +4757,8 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			MLX5_SET(dctc, dctc, dp_ordering_force, 1);
 		}
 
-		err = mlx5_core_create_dct(dev, &qp->dct.mdct, qp->dct.in,
+		err = mlx5_core_create_dct(dev, qp_to_mdev(qp), &qp->dct.mdct,
+					   qp->dct.in,
 					   MLX5_ST_SZ_BYTES(create_dct_in), out,
 					   sizeof(out));
 		err = mlx5_cmd_check(dev->mdev, err, qp->dct.in, out);
@@ -4769,7 +4769,8 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			resp.ece_options = MLX5_GET(create_dct_out, out, ece);
 		err = ib_respond_udata(udata, resp);
 		if (err) {
-			mlx5_core_destroy_dct(dev, &qp->dct.mdct);
+			mlx5_core_destroy_dct(dev, qp_to_mdev(qp),
+					      &qp->dct.mdct);
 			return err;
 		}
 	} else {
@@ -5122,8 +5123,8 @@ static int query_qp_attr(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (!outb)
 		return -ENOMEM;
 
-	err = mlx5_core_qp_query(dev, &qp->trans_qp.base.mqp, outb, outlen,
-				 false);
+	err = mlx5_core_qp_query(qp_to_mdev(qp), &qp->trans_qp.base.mqp, outb,
+				 outlen, false);
 	if (err)
 		goto out;
 
@@ -5201,7 +5202,7 @@ static int mlx5_ib_dct_query_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *mqp,
 	if (!out)
 		return -ENOMEM;
 
-	err = mlx5_core_dct_query(dev, dct, out, outlen);
+	err = mlx5_core_dct_query(qp_to_mdev(mqp), dct, out, outlen);
 	if (err)
 		goto out;
 
@@ -5361,7 +5362,7 @@ static int set_delay_drop(struct mlx5_ib_dev *dev)
 	if (dev->delay_drop.activate)
 		goto out;
 
-	err = mlx5_core_set_delay_drop(dev, dev->delay_drop.timeout);
+	err = mlx5_core_set_delay_drop(dev->mdev, dev->delay_drop.timeout);
 	if (err)
 		goto out;
 
@@ -5473,13 +5474,13 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
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
@@ -5646,7 +5647,7 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 	return &rwq->ibwq;
 
 err_copy:
-	mlx5_core_destroy_rq_tracked(dev, &rwq->core_qp);
+	mlx5_core_destroy_rq_tracked(pd, &rwq->core_qp);
 err_user_rq:
 	destroy_user_rq(dev, pd, rwq, udata);
 err:
@@ -5660,7 +5661,7 @@ int mlx5_ib_destroy_wq(struct ib_wq *wq, struct ib_udata *udata)
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

