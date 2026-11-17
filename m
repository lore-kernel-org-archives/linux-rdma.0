Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935509;
	b=muN4+Fp83ov4aXPVN+fEv4tKOyeNdsZ8PSEENPZaeK55WZJEygzKcmEuiXVXG6EnVwPN
	 6tI+ViI+bZH2+3TBjivr0SGXl3S6ajhje3QXE8Psz2xaTngl3gseI8plxuRuTwZ/4gRbZ
	 Qncj3uKW3bCDK2hl6Eful19MEWf03bXVpPtrGm175eiioYjZ8gcphLJgS9XaLcwwWuKh8
	 FEXCLNKmxOsSZeAVX4qgwXfhSEOzoet7eDlYxyGjIQLqF/50Ky0YMa6z4eUZvMItq8nD1
	 i7dHAjH5UuaExunmHh04bL/Zv/y/yyXRTV5FcY582vuWKu21/6NH1OSwqojS74542qQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935509;
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
	bh=X+cdTVGIH4N+STSOWXoTFT4qZPSeCoVaGhbKUWA7GSg=;
	b=bnAz6UDDm/wpoY8xYYIZYM0GgeJfbQFhqjvj8t0WAE6Sb/JIMP55AoUokv3AZMlGjjBn
	 gZuC4b+oXav/lJykVVxbqlh/R2NzWWMNSFNA+CDoSqQmYsqJWFoF+yi8+j4eRMJAFz5MO
	 Q0c4e1rqUAHN2+KIJtjpM5rvhgczoBCQ+BedYZKbPCi7XmD/d97cW5/naQTiGeoB0z54c
	 m3CQFvJMxnqJLwFzKS+ORwb0QecLOF2vb4Z4ri43bzJGx2ny8P6L+Mel4SwkZh5HSGj3O
	 ZZ59hKo9fUZ2oObJXQb5nfeoY7KIbM/wCEhfYhOyDtbmvvca3bbmcP8i+SLRqF/r08w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iCVwbFEy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.20
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013020.outbound.protection.outlook.com [40.93.201.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B89606A31C;
	Tue, 17 Nov 2026 17:11:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77B89606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iCVwbFEy
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OgYqbezCQXQKZExpqg4J6D8fgvyFYjfBHEGdCm5ZpSin/ebUyhMYSonIN+rw3JEDL6Nv/QyU9rNNnwooMGthZWvk5cvtU+pgyiKZqSB9Sy+i1zJJP6ySyAGBrWJTOcoaaTzCDpKvErVqcKHsyAqtv3URyKfQ1dTefoV9xv0fqRvpJZk1e2cFpswmPs22sMpHooysAyoG8tiDkT497W1ypRDUdtH/4D+pjHlPbND5jcJfYhF5gUgQ4eXbFZZj+Cs9NtsNO30RSi8mc8s4Jc5PeI0LZNYWASEpwohnnVfZQvA1cFw2SQtRJ2R88bxgRlEKkbXINgLXxbKbTZZ0KVxmBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+cdTVGIH4N+STSOWXoTFT4qZPSeCoVaGhbKUWA7GSg=;
 b=B5n3iVvq1Of5+S4DcqadOw8BuAJwwAcMTKbxogr2+q3O/oRY+18UbHPGBpEZ0SAdfmUY/upL6x3zGgRSoV3c/KwwJR1FU9Mv2KhGHCcGYbLYjKVZdSZLOvnhFk/kcf/qE8vVtZ5dCYQ+DoxbKBlaAVBHZrSicQhAgnhyKaxphfIHjbVSv5CeWwWjo6Scz2WXS71SB8ZtSRfqRQ/0GefP9xC5Ek665MyaBmzMO64/LhzUzSp5zpAz0HWOysEHwjQnApK1tEXLU+HqWe/paj2YIxdsb+6OdXzdvDv5TXm52SbQV615DQr4yx/XrPYLWB3eHRkbwRkTqaLC97QhUFc6TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+cdTVGIH4N+STSOWXoTFT4qZPSeCoVaGhbKUWA7GSg=;
 b=iCVwbFEyZKqqUh1GcCeMyxyYDt8GC0pR2cvx+cvfR3NnDwmuCyYz3QGYHf+ksRmzH8Ahb2cfy2TxS6I5EfUj2GusQEiW6Oy5fyy9Ik4cAy0PrSywyafsFVccsdFr9V+CTkGuj2xW5eC3D3RSxArFCSLwhEPWw8VSJ8hgWVZIH+rU2XGOHdYgLJTn2sZb/dDb8c3HYLu4rF2sYvhAO0/6JWgD93LF0cm9u+EaLtasJGF0eh5UOWJFRPwpyutxndJMSRAb6ADdjb7zV2UQgdFdzBAnVLWauOH2FV6VeytECys3N4foebZCjZprwc5OYjoWV0QaAWoWa8MdZQt2VObR3A==
Received: from PH7P222CA0024.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:33a::24)
 by SJ1PR12MB6364.namprd12.prod.outlook.com (2603:10b6:a03:452::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:11:39 +0000
Received: from MWH0EPF000A6730.namprd04.prod.outlook.com
 (2603:10b6:510:33a:cafe::83) by PH7P222CA0024.outlook.office365.com
 (2603:10b6:510:33a::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Tue, 17
 Nov 2026 17:11:39 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MWH0EPF000A6730.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:11:39 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:10:54 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:10:53 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:10:49 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 15/21] RDMA/mlx5: Ignore completion events for a kernel CQ that is not ready
Date: Tue, 17 Nov 2026 19:09:08 +0200
Message-ID: <20261117170914.27410-16-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261117170914.27410-1-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6730:EE_|SJ1PR12MB6364:EE_
X-MS-Office365-Filtering-Correlation-Id: e0965e4c-8235-4f6f-2f59-08df44cdd81e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|376014|22082099003|18002099003|261009223027099003|11063799006|56012099006|261028144727099003|261102123227099003|261021123027099003|261022105027099003|261026140227099003|261026121527099003|261021135927099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	E5w+78j5fUaNpTr7hrc4GAS+tiLcIEMvKoxT4IzRBK5uEbxogJCvVck68mA/IZphDz3oL5f970KJ2Fuf8tuPxi2V7fCbmBuDdPGwsmuNnMlNFqfjGVXRJQXpE1PulNG5b6yc0H+KnT1C32BzkYCQHoVL8Fdq+vOQajUDk4cqke4qvv223KzWIDstY7/SwLecSMCL2+cSr1kd5LC4havoFdAhX3xS+Sf5z7wowZP97Sn+CLeiHRToj5u+qTHl5aI+mhc/XSalhHSYeKzvfFVSTQrL5RI+qtnMvDCjtbCBS/GBf3cOH5wUTnFAKCEh0D6qwmlRtvBSCKuxFb1s9Jzn6k8NGZ60c6mklNL5hCpfD2Et/nHfJMmxykG94CKPN6pvhkfqMjXpTInBXGUiBwet7In0i1vnCInHLk+QwFh2TyHrVU7FvdaOI5xOgNZTonWKXzFP4nd5oItpTFTWaG62kk46S2I9GQC44KQw2NSmYbHpt2suxJ4rXZqE8yGf2LOvLT7Cr+bo6BAoxkjwlj1V0zlWVs0XXohljSZRNwicBm5lCSFwN1ArOvgOvEFfLUzzxTUds38BjsE4eIgkP85MXNLrhW+KI6jNtqSv395Kq0SvCKzBsFgC3xblLBHn80qjC5wsmf6TQwsl1tzIpF0HsN5cs4QAKk455aVZX9Nx+cNW5N/UnJkhJJZ0ymAERdpK6GAiKCJEGUQLBIe2Iv4tWQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(376014)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006)(261028144727099003)(261102123227099003)(261021123027099003)(261022105027099003)(261026140227099003)(261026121527099003)(261021135927099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	es47vw+rm/RV/90VGRccPHwBZ0oaLaVwc32qLjPN9ShrI/28MCgW92F8gdiOBDlt8ynAYCGsRVMNxMiI8D2zR+KwKvXHy2ijDnATZLcrt8OTcBqZLu+DLJS6h5mLchprmsgOdpW81c4lUa/iJKFgY0pVfo/SYt/vAxqPLNrh6oDux1To+tUf5ueiK2UruDAooPc2xi37SmxzAPPU1kl+INNMh7H168mv02pJxp3eSyDsY7Ez9wDERKLH8Xn8N+KmsIeFu9MHgr9cr4CQkfFd8a4KjIEDzDZtjIlfqkBgeU4udGoXoi8hmg6nzS2wuQxBpqmo2il2OzLE1A3iDYIUb+u0DJqeRwbiKkd6N7IyrHJFssqUZDU3mq4Xb2OgviYxTSQD6lxLIkoIl6WcWSPtKuwr4S+Hgdo+za3f8OUGYzSGqs5zVAWyataPGUheZtLR
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:11:39.3812
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0965e4c-8235-4f6f-2f59-08df44cdd81e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6730.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6364

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
index a5197318d96f..831bdf238319 100644
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
@@ -853,6 +871,16 @@ int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 		ret = 1;
 	spin_unlock_irqrestore(&cq->lock, irq_flags);
 
+	/*
+	 * The core arms a kernel CQ only after its poll context and handler
+	 * are set. Mark it ready before the doorbell, so an event raised
+	 * right after it is not dropped.
+	 */
+	if (ibcq->device->adversarial_mode && !cq->ready) {
+		/* Pairs with the acquire in mlx5_ib_kernel_cq_comp() */
+		smp_store_release(&cq->ready, true);
+	}
+
 	mlx5_cq_arm(&cq->mcq,
 		    (flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED ?
 		    MLX5_CQ_DB_REQ_NOT_SOL : MLX5_CQ_DB_REQ_NOT,
@@ -1284,7 +1312,8 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	MLX5_SET(cqc, cqc, c_eqn_or_apu_element, eqn);
 	MLX5_SET64(cqc, cqc, dbr_addr, cq->db.dma);
 
-	cq->mcq.comp = mlx5_ib_cq_comp;
+	cq->mcq.comp = dev->ib_dev.adversarial_mode ? mlx5_ib_kernel_cq_comp :
+						  mlx5_ib_cq_comp;
 
 	err = mlx5_core_create_cq(dev->mdev, &cq->mcq, cqb, inlen, out,
 				  sizeof(out));
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 5b7a3e3b456d..84aad754435e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -592,6 +592,8 @@ struct mlx5_ib_cq {
 	enum ib_cq_notify_flags notify_flags;
 	struct work_struct	notify_work;
 	u16			private_flags; /* Use mlx5_ib_cq_pr_flags */
+	/* adversarial_mode: kernel CQ events are handled only once set */
+	bool			ready;
 	/* adversarial_mode: polled by the verifying UMR poller */
 	bool			umr_verify;
 };
-- 
2.18.1

