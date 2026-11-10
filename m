Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318331;
	b=xVS9hhoGW/UYk574aDIT0+DItOMHbTQR3AeDiOoj9S8SXaBRovRe1KFCPiojjYQIOBDb
	 zius9582EvjDAaFmF1DP9+p6wtECtwzuKhFZorhhWPkR3FpCoMsz+yEEBBwxOYUOHVdJu
	 O/i9gyXgzrn07NsKHepp7ZQ23acsIv0D8di7063GJ9wj/Jzy+DD2B/+8repUQSuEP8F7z
	 c0OJiJVcM3jgEasCSFBp2a5QE7D7rgvARX4aC8iqz8yasWSkszDKHjfxC0h9kkr2Wkkaw
	 8TVOnAPWZIwZjXR4EdSNE+HIN19bHldHi2GBjJ6eIvlK5ckFq8QtPrjJyXSJYil+zLw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318331;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
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
	bh=YUHTsKocvCLdA09Nttn7hdcMPgo0WPW+7GbTi1gy2ZQ=;
	b=f227B8atwnOLgO9/3ohowGo8PIRgy5+h/b5kkKsdyTocxHlljANClhKs22kaqshC6vkM
	 Oqmp1wFTQvwRxIRzYSft43SH4xsYWYiIDviNjBuA+zBBjmuVSZeE6I+jtT899QMMxqjpI
	 Gv9ah6BV55l/ozxFcR100zk0k6JoM4BPEbyoY6JDPXz3sUugXBw03cNTAtHTIfL//Vk1X
	 5W72Ge2w7bVZRoXcbbQZAP7KTajEFSNXUMHDOrKH6a2AEEZDQ/KCPgazM/v/IY3yQBIjc
	 61qZTUtPYxnc/EMOytcM6azm0cAlZzsDpdsoDdj1vsDG9b+DAPmDsPvl3pdOfT8DO5Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mCnoyPg4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.2
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010002.outbound.protection.outlook.com [40.93.198.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8437606A330;
	Tue, 10 Nov 2026 13:45:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8437606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mCnoyPg4
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hMQ9EBehU+72pTEZ2ww8aDEdznZGU142HeXEb/mg2rem84NvLt4zf/4PAdGLoT08y1Nqf3ySDXG2+ahZcaCZcedtNU8QPhmQi+qWX14lg9zU9+OLUZcCF7qzkV2D5fQyMhOT+79OE0T8YJs9xw3/fM+ojPdrSxOWV4xYFq0J79O0ZD+/zTDtzxMAARSeika+0yWxUitO0FIT11V88EswX1EQzQGRBpMHKYNBU+siCxsohCLwgAopxkhUmdaErVIBfyq9m8i+OWZwjZY8led7Xjb4nPlSLmrUEqHgUv2SuDTj4Hb/5iaDFV7kl0FpL5+dC7cqwsn7KOUahqo/xuCY1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUHTsKocvCLdA09Nttn7hdcMPgo0WPW+7GbTi1gy2ZQ=;
 b=jgndirdbolaytZa38fFxpltHYaDzRhhsQG8wW0AJq01zVpbyiqj4w6vQ7smMcI4+0kx6XctFasRTWk0fz5SXOCCJfKqeHEbpevy8xM+UqidYmbnLoimmDhYYDEP6JITiog39c6PBcrNfbVQl+YIM8mDZHByETi0Dug2RP6FnoKCZ8qQOV9y4eLRWRdTzZ9TahX5n0aUfBScYQuATo9DMS1rFjKREW/GdoiExunqZJBbA19xs1rKETBAQeA1z+0XJqs9BfuGKfD9ZonnoBx0PajlA+4tKb3rhM+7E2oGGrzCT604cv5fCtKMslt8QGtAlAhnDjFad3mAjTGZhhU8y+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUHTsKocvCLdA09Nttn7hdcMPgo0WPW+7GbTi1gy2ZQ=;
 b=mCnoyPg4veR2jU2D5fiWhoURgcGmu1f6JVNYz+l2Uy3wFLm0uZX6qlt+9BeW8IuUB7u2iowT3V1VZjdDyg6YMoyv3Z0yjqaqwdN9tbus3UmoZWNedOuMEWnTCKV4CrjJXsa7pEDsE5s0LHHkjlnsVXZc4BRCxvV0aYmmAFZA40NKXyd09ksKSSLcb+j6wrgH3OZDLe+Jaw+NLbirfMlw0fQlCOP/c98HEC0u3eAFh3CfCH9vbIpaqsnHpBcmtQYKKnQ6oBAC0C24cMzilw4CcBIXv3Dg4wxY9T/Mr+bE/x8bW7PVx8+jdkPPgZKz0q7YBne1JWcM6pKe4gnMVx3k8A==
Received: from SJ0PR13CA0121.namprd13.prod.outlook.com (2603:10b6:a03:2c6::6)
 by IA0PPF95ABFC125.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bdb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 13:45:26 +0000
Received: from SJ5PEPF000001F0.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::93) by SJ0PR13CA0121.outlook.office365.com
 (2603:10b6:a03:2c6::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:45:25 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F0.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:45:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:06 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:06 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:45:02 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 17/24] RDMA/mlx5: Ignore completion events for a kernel CQ that is not ready
Date: Tue, 10 Nov 2026 15:43:13 +0200
Message-ID: <20261110134320.34408-18-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261110134320.34408-1-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F0:EE_|IA0PPF95ABFC125:EE_
X-MS-Office365-Filtering-Correlation-Id: d32a9c63-5cd9-48c8-dc91-08df3f30dfea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|36860700016|82310400026|1800799024|22082099003|18002099003|10067099003|11063799006|261102123227099003|261026121527099003|261028144727099003|261022105027099003|261009223027099003|261021121427099003|261021135927099003|261021123027099003|56012099006|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	WZnwiXCw44ng98O7pxTAv4XECtvRH2qk/GnqAFeuNOGR4GVeIEvIqaF2ktKjWo09zBFr91GerSBJoxvbXc0GhvUYgaX2ueI5nmQmU+CxFAHtK3A4YuUjIb+oNki5SleQh0r/rqoWZd+g1K2uYKdcOsXhqiJOJWlFGsIoyrb0aJuyqWF1U2wc5DezvMtmbPOZDkTE1mVoUY7YMfOA/o263OnSxcx1kBrohRvzAkDe7V2W+0W7ZGNF1JEzfHbPI+XzaWEHVgFvt+jW4v1n5JeR6kdclLfKi2RBPqUnIuS9WdR4s+Uy+6VrzlmBtoVzuB954KOxLHHo6F+AnWo3ijamAaaBLYz4EN+iISsO1M2ph47iTs/WJ1YHYTCTuMcBCmc4aLZH2/ZDwbbGK0CFD1ivrqIYgFQAyiQ2F92nKTCGYzixmv0Yk5ZVFWQcAMiCeVVnJpD081fStrXUMofXHarv08PknZFnOai6fpCfkodJoXy7EZuflRlnKFHAOnAgdEG+TGm0Zd572y55Btu9FPkNzgG8P1SoknYrOgE68P9WMTNRfhts/2QDj0bEwwREIY1dPfLVi47lMzfZlPru1Y9Z1OW8c0ejdi+YxnciEDX6V25aRBL6HzOHup2WIlhaxUStN2XAX4C5PqE3+R9mFGPT0+yXEAS+3/cVqXhVHLml9YHZKDkQCys3UU6N3+ByRFrA5HZxb71FEIX9Bs6t9jQryw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(36860700016)(82310400026)(1800799024)(22082099003)(18002099003)(10067099003)(11063799006)(261102123227099003)(261026121527099003)(261028144727099003)(261022105027099003)(261009223027099003)(261021121427099003)(261021135927099003)(261021123027099003)(56012099006)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	07hyHy6DsxhVs56NrmfF5ezK0mr8MnK8IqpsUOrZoM9kPhx6VIZ18dI4p9v0YC86/8YubYhfWftTELwn1M7yi73bBpz2yLzFjvrStFRARG7hHlO7/ePnmADDT5d15PThg/EtEtM7pUNjoXBLwpC9VQF7vMsmEttKLCw6sCx5tW5Yv/UzL+qKBiBnPFoieh9gildDeksYgIVL3K/MsDOdJ0LqvVkkl52oGSPW3QCPeSMbE0JJ4dSwsWcVkIlld4J2HS6Nmc+URKQ1pIrnGnGVzUgdFp116f6onRdxFnaIzgzY+Vd/3utok26UItNjvi/WZWwghPBH3NqeJbeaHjSWaQM0N6TCzMvTYZdXR3RsKjolNW1vqI69GeNaxvdW4SXI5fP8+y9fHVgJLJGW9MlrdBx2QQAcwZkuD2oDM0AaEQHHUi9CiuOc7eRwtB/YGZaq
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:45:25.6782
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d32a9c63-5cd9-48c8-dc91-08df3f30dfea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF95ABFC125

A kernel CQ can be reached from the completion interrupt before it is
set up: __ib_alloc_cq() sets its poll context and handler only after
ops.create_cq(), and devr->c0 has no handler, as it is never armed.

A trusted NIC raises no event for a CQ that is not armed, but a hostile
NIC in adversarial mode can. For devr->c0 that ends in a NULL call. For
a CQ from __ib_alloc_cq(), on a weakly ordered CPU, the interrupt can
see the handler but not the poll context, and crash in irq_poll.

In adversarial mode, give kernel CQs their own event callback, which
ignores events until the first arm, the point where the core has
finished setting up the CQ. mlx5_ib_arm_cq() marks the CQ ready with a
release before the doorbell, and the callback checks it with an
acquire.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cq.c      | 31 +++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 ++
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 54ab85b99f45..85ae8ba311e1 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -49,6 +49,24 @@ static void mlx5_ib_cq_comp(struct mlx5_core_cq *cq, struct mlx5_eqe *eqe)
 	ibcq->comp_handler(ibcq, ibcq->cq_context);
 }
 
+/*
+ * A hostile NIC can raise an event for a kernel CQ before the core arms it,
+ * when its poll context and handler may not be visible yet. Ignore events
+ * until the core finished setting up the CQ.
+ */
+static void mlx5_ib_kernel_cq_comp(struct mlx5_core_cq *cq,
+				   struct mlx5_eqe *eqe)
+{
+	/*
+	 * Only the first events can find it unset. Pairs with the release in
+	 * mlx5_ib_arm_cq().
+	 */
+	if (!smp_load_acquire(&to_mibcq(cq)->ready))
+		return;
+
+	mlx5_ib_cq_comp(cq, eqe);
+}
+
 static void mlx5_ib_cq_event(struct mlx5_core_cq *mcq, enum mlx5_event type)
 {
 	struct mlx5_ib_cq *cq = container_of(mcq, struct mlx5_ib_cq, mcq);
@@ -835,6 +853,16 @@ int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 		ret = 1;
 	spin_unlock_irqrestore(&cq->lock, irq_flags);
 
+	/*
+	 * The core arms a kernel CQ only after its poll context and handler
+	 * are set. Mark it ready before the doorbell, so an event raised
+	 * right after it is not dropped.
+	 */
+	if (mlx5_ib_adversarial_mode && !cq->ready) {
+		/* Pairs with the acquire in mlx5_ib_kernel_cq_comp() */
+		smp_store_release(&cq->ready, true);
+	}
+
 	mlx5_cq_arm(&cq->mcq,
 		    (flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED ?
 		    MLX5_CQ_DB_REQ_NOT_SOL : MLX5_CQ_DB_REQ_NOT,
@@ -1268,7 +1296,8 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	MLX5_SET(cqc, cqc, c_eqn_or_apu_element, eqn);
 	MLX5_SET64(cqc, cqc, dbr_addr, cq->db.dma);
 
-	cq->mcq.comp = mlx5_ib_cq_comp;
+	cq->mcq.comp = mlx5_ib_adversarial_mode ? mlx5_ib_kernel_cq_comp :
+						  mlx5_ib_cq_comp;
 	/*
 	 * Set before mlx5_core_create_cq(). No real CQE can arrive before a
 	 * QP uses the CQ, but a forged one can make mlx5_ib_poll_cq() call it.
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index f7c718e3d974..44fa25ab6e0d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -592,6 +592,8 @@ struct mlx5_ib_cq {
 	enum ib_cq_notify_flags notify_flags;
 	struct work_struct	notify_work;
 	u16			private_flags; /* Use mlx5_ib_cq_pr_flags */
+	/* adversarial_mode: kernel CQ events are handled only once set */
+	bool			ready;
 	int (*poll_one)(struct mlx5_ib_cq *cq, struct mlx5_ib_qp **cur_qp,
 			struct ib_wc *wc);
 };
-- 
2.18.1

