Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724106;
	b=Kat5VQYnkyfZ4MKhSdchbL2srsQXPJZsbZ+VykyfMdPcl1yMj5L+rFLQxo/B3sIEs5g6
	 4XBP1uwOCYG3MUce9Y4O3AdfEO9BNGSysV/CbvUoAAp1HU/YZBkp1hAWwoRUS33lPnKPb
	 jS6l27EkiV9ELafwoEsyqLV6kOF4V46U7drtv4dP84Bh14QZaWfzV12Ckfja3giiRybzk
	 AGxnAePh4ypiuGWJxwdJzoDtnIrGV3+DqJ22hMUQRrsBJ9ufVyfzzyBE9QfyL2K777t9C
	 MIT0Ghvm9rG+kQPxNO91wm9ZEuCSpnzPmoNt/2GR7ZFeteiVJh10/RJaRXI7JbUjRQQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724106;
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
	bh=avYBd6TX5Dlwiarmod8I5aNXxInmgSHavWnsMdb+LWY=;
	b=h0cX1rxuUT0Ax225lvmS06PXL8FKf6jI5OODThy+XS66VHxSQH8Xyk4+RWSR3CaGFxZ6
	 4UiQuGqRrWMQ8cJ7WMH7nPMepJvU4k5eTBmVLBj69rAix7di07Pv7z0gD4qRuDYxISGRF
	 oDLxaXK2uy0E5dOsIvDbYYKdgOE7ycwanEy6jdzKGE+dn9Orn5iilbHvZSJ+3Q/7blHhE
	 oYYqHIImvkltp7UuPUS+jZwCNckKmSp/KATzBVoCyrJeM4PiQkgarQuyi7AQBXx4FNEZI
	 GXINQ5y2jan8I7lSBuBsdkju/WcN9ty0n7VTNJVMvFIKExFqzfMFHgnU1jjmb6KbIaw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MGKEalFJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.26
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010026.outbound.protection.outlook.com [52.101.201.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22196083632;
	Tue,  3 Nov 2026 16:41:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C22196083632
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MGKEalFJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dB30sUyyu0GsRlWDTCtgHZeKjEM3juvPKctH6oC4qCOPe35HDap7YCgeiU3adGZaSGJ0+QkTmZwIsaFvCa0S96EMFZOg5d5H+swQy7ZUst6JflddvCWtT1EH/1OXuF82ugXd3cX2uTUQVAbiEQiYWl+3DsabPwnJoe7vKsUu8ceRtMf+/U9fpeFQn26XiGomaPGnX6wICTb4gBGGibBrWjZNmvMYdN8VUoBgPK01JUbelXsdUn4PVZTFyx1NeXEgNiUunUjlzdg7i8OYGOy9C+KOFOMqTx/X+f3IgceOrQyffi71NFm2mto7mCKP4CI10ch3eDg+gGYLo2e9YGLQoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avYBd6TX5Dlwiarmod8I5aNXxInmgSHavWnsMdb+LWY=;
 b=g+d8J2/7yWjY/HZrJR4X+nuGHjEpeWEqy+l2O6kup+yB/5wMhbn622E93zqAYXSKfEa/tsO32cWuuxZFpVlorK1znIqauaPPykuFDCQT4o2G9YGP/kfXAGP3gHqqqKp9YBlVdPicNq+aLEiEFjurjGT2Nx97mHFQMRmWHnBGVYtJoXqFKfGHwK+8L6aSKpOH3oTiP5/JKRAm6eIIlOJctObQPU8qc+iTrPSgLsvZ2acfie8lNuj/MkW01su/j0Utn9od1lZjhnrGle7cx3Q+DPjRcrfnTwZ1OMcqcABbL5iStqEZVXgixPuSl+vCav8xNp0wxh6dDwRsuT/Lw9d+gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avYBd6TX5Dlwiarmod8I5aNXxInmgSHavWnsMdb+LWY=;
 b=MGKEalFJ6ludu9VkLPe0jBfgCD7nbv4+23/lQnpXPDkooM7bKXNy9UnCrQfcB6+tH8rb5NC52oE/ax2/sv9fHHVvb9+b+T1GtrxrLmhxilSpx0JV/v4clci8x0V1Lquk+rPtTmrXfb0WWpvCk7E1Rhp3C7J6EAq47dHEQXwnpVglAruX1jj/7HIvtmlKRbpFipudg0RHvyKpyu4GchCSkMCGHXpTVcQs0Qtgq6PrqFB4+4vQ6RucAhnO+tYa0T4vpwDqWJwZaeHnFCdHrFXDTUYmZ4Ud9Pa7M0FCewHikFtnKzf1IFQf8oRXnnPXiDZ8gFdgLQn8ysJqHMKQ7uHKXg==
Received: from BY3PR05CA0017.namprd05.prod.outlook.com (2603:10b6:a03:254::22)
 by IA3PR12MB597905.namprd12.prod.outlook.com (2603:10b6:208:53f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:41:43 +0000
Received: from SJ1PEPF000037AA.namprd03.prod.outlook.com
 (2603:10b6:a03:254:cafe::7a) by BY3PR05CA0017.outlook.office365.com
 (2603:10b6:a03:254::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:41:42 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037AA.mail.protection.outlook.com (10.167.244.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:41:42 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:17 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:16 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:41:12 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 12/23] RDMA/mlx5: Verify UMR CQ polling against a hostile NIC
Date: Tue, 3 Nov 2026 18:39:38 +0200
Message-ID: <20261103163949.1554-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261103163949.1554-1-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037AA:EE_|IA3PR12MB597905:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c496d2d-99be-4790-4231-08df39c95766
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|36860700016|82310400026|56012099006|261021135927099003|5023799004|11063799006|261028144727099003|261009223027099003|261021121427099003|261022105027099003|261026121527099003|261026140227099003|261022075727099003|10067099003|18002099003|261102123227099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	kwRfqYmeIkev1zqvoHN/8iimMPRz5XsYFQAnyL0UWruz0rPzW38rb1III6QFsQc0ArI5JmU2WDYXzjeUYIHCOfW925z4qX6eDGy2MhxARkwhJ4/ChEgTEWkNvYsKmmu1VG6xzJ+hsElXmYpmUaE02qWs3rFQqoP+0OBxpQSrr9HxLc9Vdo3vfpVEmSE2wURwyHeexrJj9LhgDZUeg5G6fZHqfBEGCIuzS2TI296pqxwJV51QbJ1fHdTJDWJ/KcnLkQv6oFJwx/BbBTWhxyAhcUSSlLH+qm52XykrM2RiK6NHa03z1TK67SeYBuTxOtTrg33eCt77OCvOEbTG2HDzazRd3CuoJrxrte/ARdmiprVzt+vvyD4rjkDiZHqenZuOsFG01nBdD8UhOVrk3DzxwlEF1mAb6aqrEEdBylmc1Rs2b0bTQvqU8mZJOy4b+qo8UCaD6+KNU3QPdinWXvbNpI+J7KpBuE4b1mPXdjQzRDfiykF1YoSYs7GaGl0GTHa5bBPdpp9kqvyyQrmoDTvXnAyZh0vHtt3Q7XSZFQ77vgct4NIFJKSQGE2x2fMW+wuF5aTTU9nVY87taPQKKgs02QnwSO8YMM81Ye3diZ57rr+6J9Fq/Zj4HUE245L6p2P3vbLrPxi8E/NIDNqcgQ4RiR3Kka0XS4gvf3WeOJfpbO+1UFH01zIEbEUwS2Ps2niBle7XLJ/qIjrboBNFVQVQKw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(36860700016)(82310400026)(56012099006)(261021135927099003)(5023799004)(11063799006)(261028144727099003)(261009223027099003)(261021121427099003)(261022105027099003)(261026121527099003)(261026140227099003)(261022075727099003)(10067099003)(18002099003)(261102123227099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yRfGUc9lt0WwsHqAW2IkCW2kNoBLo0yM3WpriTMUqMNlCiQfZrPBcADEhTOm4dgGOvgpmsAajABD4bDzt2laHByDIMEYRoEpaIpmo1dn4jKP7HdDzE0r4lwBlylv2UGgOQuQIYyhT+og54VCv+Ykbk7IXXigrkfnz8VqoU3c/JcqmgYHypCwC3L/uwC+3Loxo1V8AUMdP+WELo2eg5B2b7C+AMwBziyPweSj0OfqVfCCk9ts6pyOEJ9AUX1yy0lmdkEhu4xnf38EFgTDLM7N8H1+9Tgf8kWYSF9URQKuOmW7LyjiMBxhu12aByCJhQbYFFwgtiXRb/nnTq4r4DwcOUPm0jzMFY8768wpmD91J21Dy+5SuuUv1b8FUbbwggYcAaT1vNEwznr3886N+9/9ZRIo2RW1ds40NABycqY3G5fihM0Qe5VBbBJyV4GfvNOU
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:41:42.6108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c496d2d-99be-4790-4231-08df39c95766
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037AA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR12MB597905

The generic poll path trusts the CQE content: its opcode, QPN and
wqe_counter decide which request is completed and which waiter is woken.
A forged CQE can therefore complete a request the driver never posted,
or one that already completed. The driver then writes through a context
it no longer owns, which corrupts memory, as the context is usually on
the waiter's stack.

In adversarial mode, install a dedicated poll_one for the UMR CQ that
does not take the CQE's word for it. The driver keeps a shadow FIFO of
its posted requests, and a CQE is accepted only if its opcode and QPN
match the UMR QP and its full wqe_counter matches the oldest pending
request, one already passed to the doorbell. The context is then taken
from the FIFO, never from the CQE. This cannot prove that the NIC
really executed the request, as it can always report the oldest one as
completed; it ensures that the driver completes only a context it owns,
once and in order.

A CQE that fails validation proves the NIC is forging completions, so
nothing it reports on this QP can be trusted any more. Mark the UMR
path permanently failed, so neither a new post nor a QP recovery can
reopen it, stop interpreting this CQ and force the mlx5_core health
recovery. The forced variant is needed because such a NIC still looks
healthy to the fatal sensors. Recovery moves the device to the internal
error state, and the existing flush then completes the pending requests
in software and wakes their waiters, so this path does not complete
them itself.

On teardown, stop polling the CQ before destroying the UMR QP, so a CQE
for the destroyed QP, or for a reused QPN, is never interpreted.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cq.c      | 156 +++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   5 +
 drivers/infiniband/hw/mlx5/umr.c     |  38 +++++++
 3 files changed, 199 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 11c1153747c2..1a98263ec311 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -37,6 +37,7 @@
 #include "mlx5_ib.h"
 #include "srq.h"
 #include "qp.h"
+#include "umr.h"
 
 #define UVERBS_MODULE_NAME mlx5_ib
 #include <rdma/uverbs_named_ioctl.h>
@@ -608,6 +609,161 @@ static int poll_soft_wc(struct mlx5_ib_cq *cq, int num_entries,
 	return npolled;
 }
 
+static int mlx5_ib_poll_one_stopped(struct mlx5_ib_cq *cq,
+				    struct mlx5_ib_qp **cur_qp, struct ib_wc *wc)
+{
+	return -EAGAIN;
+}
+
+/**
+ * mlx5_ib_cq_stop_polling - stop interpreting CQEs on a CQ
+ * @ibcq: the CQ
+ *
+ * Takes cq->lock, which mlx5_ib_poll_cq() holds while polling, so no poll
+ * is in flight on return and no CQE is looked at again.
+ */
+void mlx5_ib_cq_stop_polling(struct ib_cq *ibcq)
+{
+	struct mlx5_ib_cq *cq = to_mcq(ibcq);
+	unsigned long flags;
+
+	spin_lock_irqsave(&cq->lock, flags);
+	cq->poll_one = mlx5_ib_poll_one_stopped;
+	spin_unlock_irqrestore(&cq->lock, flags);
+}
+
+/*
+ * poll_one of the UMR CQ in adversarial_mode. A CQE is accepted only if it
+ * matches the oldest request in the shadow FIFO, otherwise the device is
+ * treated as compromised.
+ */
+int mlx5_ib_poll_one_umr(struct mlx5_ib_cq *cq, struct mlx5_ib_qp **cur_qp,
+		      struct ib_wc *wc)
+{
+	struct mlx5_ib_dev *dev = to_mdev(cq->ibcq.device);
+	struct mlx5r_umr_context *expected;
+	struct umr_common *umrc = &dev->umrc;
+	struct mlx5_err_cqe err_cqe;
+	struct mlx5_cqe64 *cqe64;
+	struct mlx5_ib_wq *wq;
+	struct mlx5_ib_qp *qp;
+	struct ib_qp *ibqp;
+	u16 wqe_ctr;
+	u8 opcode;
+	u32 head;
+	u32 sop_qpn;
+	u32 qpn;
+	u8 sop;
+	int idx;
+	void *cqe;
+
+	cqe = next_cqe_sw(cq);
+	if (!cqe)
+		return -EAGAIN;
+
+	cqe64 = (cq->mcq.cqe_sz == 64) ? cqe : cqe + 64;
+	++cq->mcq.cons_index;
+	/*
+	 * Read each field once, so a NIC rewriting the CQE cannot change it
+	 * between validation and use.
+	 */
+	rmb();
+	opcode  = READ_ONCE(cqe64->op_own) >> 4;
+	sop_qpn = ntohl(READ_ONCE(cqe64->sop_drop_qpn));
+	qpn     = sop_qpn & 0xffffff;
+	sop     = sop_qpn >> 24;
+	wqe_ctr = be16_to_cpu(READ_ONCE(cqe64->wqe_counter));
+
+	/*
+	 * This poll_one is installed before the UMR QP is published, so a CQE
+	 * seen while the QP is NULL is forged. Teardown stops polling before
+	 * the QP is destroyed.
+	 */
+	ibqp = smp_load_acquire(&dev->umrc.qp);
+	if (unlikely(!ibqp)) {
+		mlx5_ib_err(dev, "CQE on the UMR CQ before its QP is published\n");
+		goto forged_cqe;
+	}
+	qp = to_mqp(ibqp);
+	wq = &qp->sq;
+	idx = wqe_ctr & (wq->wqe_cnt - 1);
+
+	if (unlikely((opcode != MLX5_CQE_REQ && opcode != MLX5_CQE_REQ_ERR) ||
+		     qpn != umrc->qpn || sop != MLX5_OPCODE_UMR)) {
+		mlx5_ib_err(dev,
+			    "Unexpected CQE on UMR CQ: opcode 0x%x sop 0x%x qpn 0x%x\n",
+			    opcode, sop, qpn);
+		goto forged_cqe;
+	}
+
+	/* Pairs with smp_store_release() in mlx5r_umr_post_send() */
+	head = umrc->pending_head;
+	expected = smp_load_acquire(&umrc->pending[head & (MLX5_UMR_MAX_WR - 1)]);
+
+	if (unlikely(!expected)) {
+		mlx5_ib_err(dev,
+			    "UMR CQE wqe_ctr 0x%x with an empty shadow FIFO, possible NIC forgery\n",
+			    wqe_ctr);
+		goto forged_cqe;
+	}
+
+	if (unlikely(wqe_ctr != expected->wqe_ctr)) {
+		mlx5_ib_err(dev,
+			    "UMR wqe_ctr 0x%x mismatch with expected context, possible NIC forgery\n",
+			    wqe_ctr);
+		goto forged_cqe;
+	}
+
+	/*
+	 * A WQE records wq->head when posted, and mlx5r_ring_db() then advances
+	 * wq->head. If they are still equal, mlx5r_ring_db() was not reached
+	 * yet, so the WQE was never handed to the NIC.
+	 */
+	if (unlikely(wq->wqe_head[idx] == READ_ONCE(wq->head))) {
+		mlx5_ib_err(dev,
+			    "UMR CQE wqe_ctr 0x%x for an uncommitted WQE, possible NIC forgery\n",
+			    wqe_ctr);
+		goto forged_cqe;
+	}
+
+	/* Pop the shadow FIFO head: validated, dispatch to its waiter */
+	WRITE_ONCE(umrc->pending[head & (MLX5_UMR_MAX_WR - 1)], NULL);
+	umrc->pending_head = head + 1;
+	wc->wr_cqe = &expected->cqe;
+
+	wc->qp = &qp->ibqp;
+	wq->tail = wq->wqe_head[idx] + 1;
+	/* Advance wq->last_poll, the internal error flush starts from it */
+	handle_atomics(qp, cqe64, wq->last_poll, idx);
+
+	if (opcode == MLX5_CQE_REQ) {
+		wc->status = IB_WC_SUCCESS;
+	} else {
+		/* Copy the CQE, so its syndrome is read once */
+		err_cqe = *(struct mlx5_err_cqe *)cqe64;
+		mlx5_handle_error_cqe(dev, &err_cqe, wc);
+		/* As in the generic path, a real failure starts the recovery */
+		if (wc->status != IB_WC_WR_FLUSH_ERR)
+			umrc->state = MLX5_UMR_STATE_RECOVER;
+	}
+
+	return 0;
+
+forged_cqe:
+	/* mlx5_ib_poll_cq() updates the CI only for a returned completion */
+	mlx5_cq_set_ci(&cq->mcq);
+	/*
+	 * The NIC forged a CQE. Fail the UMR path for good, ignore any later
+	 * CQE and force the health recovery, as the fatal sensors still read
+	 * clean. The internal error flush then completes the waiters. Return
+	 * an error, not -EAGAIN, as a CQE was consumed.
+	 */
+	umrc->state = MLX5_UMR_STATE_ERR;
+	cq->poll_one = mlx5_ib_poll_one_stopped;
+	mlx5_trigger_health_work_force(dev->mdev);
+	return -EIO;
+}
+
 int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 {
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 9cc4b2f99b69..f7c718e3d974 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -768,6 +768,8 @@ struct umr_common {
 	struct ib_pd	*pd;
 	struct ib_cq	*cq;
 	struct ib_qp	*qp;
+	/* Checked against each CQE in adversarial_mode */
+	u32		qpn;
 	/* Protects from UMR QP overflow
 	 */
 	struct semaphore	sem;
@@ -1311,6 +1313,9 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 			   struct uverbs_attr_bundle *attrs);
 int mlx5_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
 int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
+int mlx5_ib_poll_one_umr(struct mlx5_ib_cq *cq, struct mlx5_ib_qp **cur_qp,
+		      struct ib_wc *wc);
+void mlx5_ib_cq_stop_polling(struct ib_cq *ibcq);
 int mlx5_ib_pre_destroy_cq(struct ib_cq *cq);
 void mlx5_ib_post_destroy_cq(struct ib_cq *cq);
 int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags);
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index aba79a19d627..b0f00d4bc93c 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -194,6 +194,23 @@ int mlx5r_umr_resource_init(struct mlx5_ib_dev *dev)
 	sema_init(&dev->umrc.sem, MAX_UMR_WR);
 	mutex_init(&dev->umrc.lock);
 	dev->umrc.state = MLX5_UMR_STATE_ACTIVE;
+
+	if (mlx5_ib_adversarial_mode) {
+		struct mlx5_ib_cq *mcq = to_mcq(cq);
+		unsigned long flags;
+
+		dev->umrc.qpn = qp->qp_num;
+		/*
+		 * UMRs can be posted as soon as the QP is published below, by
+		 * this caller or by a concurrent MR registration, so install
+		 * mlx5_ib_poll_one_umr() first. The CQ is already armed, so
+		 * swap it under cq->lock, which the poll loop holds.
+		 */
+		spin_lock_irqsave(&mcq->lock, flags);
+		mcq->poll_one = mlx5_ib_poll_one_umr;
+		spin_unlock_irqrestore(&mcq->lock, flags);
+	}
+
 	smp_store_release(&dev->umrc.qp, qp);
 
 	mutex_unlock(&dev->umrc.init_lock);
@@ -212,6 +229,14 @@ void mlx5r_umr_resource_cleanup(struct mlx5_ib_dev *dev)
 {
 	if (dev->umrc.state == MLX5_UMR_STATE_UNINIT)
 		return;
+
+	/*
+	 * Stop polling before the QP is destroyed, as its QPN may then be
+	 * reused and a forged CQE carrying it must not be interpreted.
+	 */
+	if (mlx5_ib_adversarial_mode)
+		mlx5_ib_cq_stop_polling(dev->umrc.cq);
+
 	mutex_destroy(&dev->umrc.lock);
 	/* After device init, UMR cp/qp are not unset during the lifetime. */
 	ib_destroy_qp(dev->umrc.qp);
@@ -319,6 +344,11 @@ static int mlx5r_umr_recover(struct mlx5_ib_dev *dev, u32 mkey,
 	int err;
 
 	mutex_lock(&umrc->lock);
+	if (mlx5_ib_adversarial_mode && umrc->state == MLX5_UMR_STATE_ERR) {
+		/* The NIC forged a CQE, don't revive the QP */
+		mutex_unlock(&umrc->lock);
+		return -EFAULT;
+	}
 	/* Preventing any further WRs to be sent now */
 	if (umrc->state != MLX5_UMR_STATE_RECOVER) {
 		mlx5_ib_warn(dev, "UMR recovery encountered an unexpected state=%d\n",
@@ -425,6 +455,14 @@ static int mlx5r_umr_post_send_wait(struct mlx5_ib_dev *dev, u32 mkey,
 		if (umr_context.status == IB_WC_WR_FLUSH_ERR)
 			continue;
 
+		if (mlx5_ib_adversarial_mode) {
+			/* A forged CQE was detected, don't recover the QP */
+			if (umrc->state == MLX5_UMR_STATE_ERR) {
+				err = -EFAULT;
+				break;
+			}
+		}
+
 		WARN_ON_ONCE(1);
 		mlx5_ib_warn(dev,
 			"reg umr failed (%u). Trying to recover and resubmit the flushed WQEs, mkey = %u\n",
-- 
2.18.1

