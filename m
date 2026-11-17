Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935462;
	b=wkr3OumQzLKXqYxx3bn6FZI8V3f4YaU9CvoAc4L7PQAZiNPyjdvAGxrpnqDhAvFrSOt3
	 pypeZ8scxW4OSBj1/fbzRTIQp7zIvYP4fn+pdgOaS8fFc2tZ9yKvqVYrFmJ8nqfo479Lo
	 mKqX6lfgY5+cucD2MUxhLQVizrg5wUVLHDnISUcUMUzwYA7MXWzpK/Y4laE+r2gxSzlzJ
	 3Nf+ZvkUeNOd/ziiJThibmv8+Ia/gSz7WS0weAuQWY7DU0T3oTBFcoo99CJ3Qx8QSRZFu
	 7O++bDvKdGmnnQvpjvg3SzESPs4GHM2WjDdi9fV7lHmDfDaYMR1Vzb6Ta7zrvUUwTZg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935462;
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
	bh=2Jf1D2oi0IjuLsz9mAdHEmSrK6IhzTeR26gYIiDfxUI=;
	b=uEbeoc7+1UGa+ZjdCsguZwaKiuRcEcuzlDVL8oT2ss1JqVddOVJQhwJyfAUstQGIAFNi
	 EaQe6ZuvsPcbJqopmS/VVvhfa/Hah+827wEpYY/3pGFKl4GMS5MmAb38S4Fdbj+4NQhk/
	 5dXNlQgoDc0b+D8LY6A3h50hv0KiBb2th23zO+3QQnJH9VwD8nhB3a4HDscZlU/0kfrbm
	 2H3yRTlC0E13a/7eMUKBR82ue/pO1zOtfhqpUgoHEfguYavXXVt7HqErXyW8SJhJo9XBX
	 pjkiASQ1/pgrUB0kJRjwcEHp+yiXc+e0AsOnh2IdOWoEm+CEyQZWw9Uj3P9MzF9MM4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lSY9vXDF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.46
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011046.outbound.protection.outlook.com [40.93.194.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B82E60A2611;
	Tue, 17 Nov 2026 17:11:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B82E60A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lSY9vXDF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KbpADIj2O1QzGIW5JFSgi3w1cQsxDJMNXwHSSgPlbyXw96miWmRFUYgXpJ4Ro3gtlQHo5YbhSh/7gLJKyiHqgD97v3K0ReTCGUg5h6CuNCUQIb/Ajqypr579ZP5KH6lTfKHIyOQ52znEfDA3QM87HIIErA2VFlMFCJo2ppXSBMUiiseLxXql1cqdB8o54kLxwY07STw8zRxmlx1WodIhDYVdGRtP3N99bUK3PnFBHg1yz3OQCD5+/h7vhIfX54GkXr6XyvFKwyFygosuTCoFGcJZYx+R54AG0pJSQpWmLDDIjCjb/CWOsHX9Pfvpb2DIDl9m9G00AAH8eoStA1U98g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Jf1D2oi0IjuLsz9mAdHEmSrK6IhzTeR26gYIiDfxUI=;
 b=vsXV18CKj6XPd0uFet2INzUBjsFfMI40UUZ1wLW1GHdSHJCvjm6pUadEyS16yNgutkuRc5uyfOzggcDmoMwHgEFOWRfMhGxx3900sfdP/bdfaT3hXzdPAAbzBvgd6ZwnkPoGCZKbxmusxRV2PVj0b3t5vbY/pmbumJoCJnJBpNUrNzH6Qw9AFZxNMfkf9+Lh+3eJZWMqref4WfmA/DXqSZwkZY0zMT9RQUlWiyJfz/fzNc8MJf3z0P8KjdVMzBC4VSGi9ez4zjCPmATmpyQcgB8V+M1V35FKUxA7MEwYgZNg+0cxCI+aYfPX44fdMnrJuZO4RYoGrqcFX+0OrDx4Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Jf1D2oi0IjuLsz9mAdHEmSrK6IhzTeR26gYIiDfxUI=;
 b=lSY9vXDFyym9S0vmKKQ8DjWZwv5uso34wqMFxULJmlW0iRh3fQOuXe/Kn7Y3MYpgfu0Hxc13bCGwoX4NF7wPS+KdiUjSmKNatcUxHIZ3PmdyXVsyhj3iqs03J3TTtwTXEVoR1Xb3lVD/kvU+2szY1fM0uwQZY8ApCmoJcT6//doRPWUvFFGuZmlXhLV1CNeUgPDhGJ2hWI1ik+l4kodFau+0wzgHmOUURp0/Pgrx3nBCbTfRd+BloD/o6eGshzrzJpTLh14aumXoI0F2Avc/+59NmB116LB31zeGTxoP9IP+c+J7zRrxNgAFXm5Z4hZMp7/Gdd2MyRN8259ZaKnEiA==
Received: from SJ0PR05CA0025.namprd05.prod.outlook.com (2603:10b6:a03:33b::30)
 by DS6PR12MB460083.namprd12.prod.outlook.com (2603:10b6:8:4d3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:10:57 +0000
Received: from SJ1PEPF00002327.namprd03.prod.outlook.com
 (2603:10b6:a03:33b:cafe::a) by SJ0PR05CA0025.outlook.office365.com
 (2603:10b6:a03:33b::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.5 via Frontend Transport; Tue, 17
 Nov 2026 17:10:57 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002327.mail.protection.outlook.com (10.167.242.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:10:57 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:10:40 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:10:39 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:10:35 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 12/21] RDMA/mlx5: Verify UMR CQ polling against a hostile NIC
Date: Tue, 17 Nov 2026 19:09:05 +0200
Message-ID: <20261117170914.27410-13-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002327:EE_|DS6PR12MB460083:EE_
X-MS-Office365-Filtering-Correlation-Id: 547bd0f9-a10a-490b-5805-08df44cdbef0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|376014|1800799024|18002099003|6133799003|22082099003|261009223027099003|11063799006|5023799004|56012099006|261028144727099003|261022075727099003|261022105027099003|261026140227099003|261026121527099003|261021135927099003|261021121427099003|261102123227099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Z0wCMCdPMncfJ9dPZaL7XEjyLqfPZq4pv3pFqOevCVCJkye3w+tztuxHxW/Y4q5gw12kdHQmOupXJXzpkvvShoHaDNhPdL1NQjMVXnvij1jf6b3AXSYFlEtIJ1MbVxzwd2UgFIuVO/LMKrJAK10iuWVNJVmZ/THGk9autzUOefI4gvSQh83JakKSViy0RfDyBNgOeMEoqSCXP/j+Xsn+4PP8zzgOrg9/AQd6927fvX8be1TZCww4RYEEdOw6ayDf0CuCzAHdr9MWY9Xv5iJ6BPteM32UMBzCv9SnFddIPivxX1PchhcaktRgTwVX+LSW/nPAjcT5AMURVNc/DYe4cLicrvI1wTpLUOA8wGuQoY+8AvXIDwtfSM1gN7xQuy99+ry1ToyJ1P+TWw8TSJTODktMiXbuWinhBTubueNGmpCmXaE2PqFt/B49Rs4/6YnH28ydslI2pkMpMfHuxQcD8CTM54OxwtFA2q8GqvSD9NF8vFvsm4LAQNWPfqCVChNRtIyQDPE8d5DwtYQauwhBrWvUZw5nBCciu9xofi5m37AwiwL5pke/zL2dOoWbicJ36J6swA+ltlQdPtajpwC41QOcX3bA1EPJGPiqmrnhst4Czgpe1i6egqsXfHqIBDJ3sB3o2hQghxp14VHntP7nl2/UEweTxX74SWwJG2riBvYJ9wWauOO3bVIUgsn7b445HgO230v6b6o5CeKysYxjmg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(376014)(1800799024)(18002099003)(6133799003)(22082099003)(261009223027099003)(11063799006)(5023799004)(56012099006)(261028144727099003)(261022075727099003)(261022105027099003)(261026140227099003)(261026121527099003)(261021135927099003)(261021121427099003)(261102123227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2EO+G+DBa9u7tIPCuG091tmfy84LcCmfZuDom2Aq4ot2mitEt0TIoB+63vcwGCuN3OsmZIBrGDwwUvEz1XzNvFY7oX56z8oi7UD/p4+0RmbxMH4NL+4fqXVfPIBSB3MMoUYeDtK3JxWEnEOmuqZYQDbRJ3Ay0SL5HDfqTintASZeW40ZrgDX4YhaonwQQe9t1CiKP2eF70L0oz5IYORJQCXOFNbWz9XAqYkfIXxRiLdossJGItyUzlSZMaxalocLlKJwubQjupiQfQuIu10OfjiagF/yNbHGHa84d1stP7j9oVBzrqeAEmNUHJ6drOqgIUbVYcJ5N9a9Dt7dibJPg9KvTgWu+FFu+GSASOdhpSBfb4AFYr0QKp9HJqAC/HDeI0P0xI67gVhrtCiBtah6OX3VUr/01du1t3Z9jvYkWghwVJvKzutCI18H5AcVdFpD
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:10:57.2086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 547bd0f9-a10a-490b-5805-08df44cdbef0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002327.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB460083

The generic poll path trusts the CQE content: its opcode, QPN and
wqe_counter decide which request is completed and which waiter is woken.
A forged CQE can therefore complete a request the driver never posted,
or one that already completed. The driver then writes through a context
it no longer owns, which corrupts memory, as the context is usually on
the waiter's stack.

In adversarial mode, poll the UMR CQ with a dedicated poller that does
not take the CQE's word for it. The driver keeps a shadow FIFO of its
posted requests, and a CQE is accepted only if its opcode and QPN match
the UMR QP and its full wqe_counter matches the oldest pending request,
one already passed to the doorbell. The context is then taken from the
FIFO, never from the CQE. This cannot prove that the NIC really executed
the request, as it can always report the oldest one as completed; it
ensures that the driver completes only a context it owns, once and in
order.

The generic poll path must not run at all in adversarial mode. Kernel
ULPs are kept off the device and user CQs are polled by userspace, so
the UMR CQ is the only CQ the kernel polls. mlx5_ib_poll_cq() checks the
mode once per call, and polls only a CQ marked for UMR verification,
which is set under cq->lock before the UMR QP is published. Any other
CQ, and the UMR CQ once polling stopped, returns no CQE and nothing is
consumed. Outside adversarial mode the poll path is unchanged.

A CQE that fails validation proves the NIC is forging completions, so
nothing it reports on this QP can be trusted any more. Mark the UMR
path permanently failed, so neither a new post nor a QP recovery can
reopen it, stop interpreting this CQ and force the mlx5_core health
recovery. The forced variant is needed because such a NIC still looks
healthy to the fatal sensors. Recovery moves the device to the internal
error state, and the existing flush then completes the pending requests
in software and wakes their waiters, so this path does not complete
them itself.

A non-flush error CQE is valid only while the UMR path is active: a real
failure moves the QP to error, after which the NIC returns only flush
errors until the recovery resets it. Accept one only by moving the state
from active to recover atomically, and treat it as forged otherwise, so
a single recovery runs at a time.

On teardown, stop polling the CQ before destroying the UMR QP, so a CQE
for the destroyed QP, or for a reused QPN, is never completed to a
waiter.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cq.c      | 192 +++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   5 +
 drivers/infiniband/hw/mlx5/umr.c     |  38 ++++++
 3 files changed, 235 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 2581a7693585..a5197318d96f 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -37,6 +37,7 @@
 #include "mlx5_ib.h"
 #include "srq.h"
 #include "qp.h"
+#include "umr.h"
 
 #define UVERBS_MODULE_NAME mlx5_ib
 #include <rdma/uverbs_named_ioctl.h>
@@ -608,6 +609,190 @@ static int poll_soft_wc(struct mlx5_ib_cq *cq, int num_entries,
 	return npolled;
 }
 
+/**
+ * mlx5_ib_cq_stop_polling - stop interpreting CQEs on a CQ
+ * @ibcq: the CQ
+ *
+ * For adversarial_mode only, where mlx5_ib_poll_cq() polls a CQ only while
+ * umr_verify is set. Takes cq->lock, which mlx5_ib_poll_cq() holds while
+ * polling, so no poll is in flight on return and later polls return no CQE
+ * from the NIC.
+ */
+void mlx5_ib_cq_stop_polling(struct ib_cq *ibcq)
+{
+	struct mlx5_ib_cq *cq = to_mcq(ibcq);
+	unsigned long flags;
+
+	spin_lock_irqsave(&cq->lock, flags);
+	cq->umr_verify = false;
+	spin_unlock_irqrestore(&cq->lock, flags);
+}
+
+/*
+ * Poll one CQE of the UMR CQ in adversarial_mode. A CQE is accepted only if
+ * it matches the oldest request in the shadow FIFO, otherwise the device is
+ * treated as compromised.
+ */
+static int mlx5_ib_poll_one_umr(struct mlx5_ib_cq *cq, struct ib_wc *wc)
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
+	 * umr_verify is set before the UMR QP is published, so a CQE
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
+	if (opcode == MLX5_CQE_REQ) {
+		wc->status = IB_WC_SUCCESS;
+	} else {
+		/* Copy the CQE, so its syndrome is read once */
+		err_cqe = *(struct mlx5_err_cqe *)cqe64;
+		mlx5_handle_error_cqe(dev, &err_cqe, wc);
+		/*
+		 * A real failure during a recovery is forged, the QP
+		 * only flushes.
+		 */
+		if (wc->status != IB_WC_WR_FLUSH_ERR &&
+		    cmpxchg(&umrc->state, MLX5_UMR_STATE_ACTIVE,
+			    MLX5_UMR_STATE_RECOVER) != MLX5_UMR_STATE_ACTIVE) {
+			mlx5_ib_err(dev,
+				    "UMR error CQE status %d in state %d, possible NIC forgery\n",
+				    wc->status, READ_ONCE(umrc->state));
+			goto forged_cqe;
+		}
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
+	cq->umr_verify = false;
+	mlx5_trigger_health_work_force(dev->mdev);
+	return -EIO;
+}
+
+/*
+ * mlx5_poll_one() trusts the CQE, so it must not run in adversarial_mode.
+ * Kernel ULPs are kept off the device and user CQs are polled by
+ * userspace, so only the UMR CQ is polled here, by its verifying poller.
+ * Any other CQ, and the UMR CQ before its poller is set up or once polling
+ * stopped, returns no CQE and nothing is consumed.
+ *
+ * Called with cq->lock held, which serializes umr_verify changes.
+ */
+static int mlx5_ib_poll_cq_adversarial(struct mlx5_ib_cq *cq, int num_entries,
+				       struct ib_wc *wc)
+{
+	int npolled;
+
+	if (!cq->umr_verify)
+		return 0;
+
+	for (npolled = 0; npolled < num_entries; npolled++) {
+		if (mlx5_ib_poll_one_umr(cq, wc + npolled))
+			break;
+	}
+
+	return npolled;
+}
+
 int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 {
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
@@ -632,11 +817,18 @@ int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 	if (unlikely(!list_empty(&cq->wc_list)))
 		soft_polled = poll_soft_wc(cq, num_entries, wc, false);
 
+	if (unlikely(dev->ib_dev.adversarial_mode)) {
+		npolled = mlx5_ib_poll_cq_adversarial(cq, num_entries - soft_polled,
+						      wc + soft_polled);
+		goto set_ci;
+	}
+
 	for (npolled = 0; npolled < num_entries - soft_polled; npolled++) {
 		if (mlx5_poll_one(cq, &cur_qp, wc + soft_polled + npolled))
 			break;
 	}
 
+set_ci:
 	if (npolled)
 		mlx5_cq_set_ci(&cq->mcq);
 out:
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 08d2a37a5f3b..5b7a3e3b456d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -592,6 +592,8 @@ struct mlx5_ib_cq {
 	enum ib_cq_notify_flags notify_flags;
 	struct work_struct	notify_work;
 	u16			private_flags; /* Use mlx5_ib_cq_pr_flags */
+	/* adversarial_mode: polled by the verifying UMR poller */
+	bool			umr_verify;
 };
 
 struct mlx5_ib_wc {
@@ -766,6 +768,8 @@ struct umr_common {
 	struct ib_pd	*pd;
 	struct ib_cq	*cq;
 	struct ib_qp	*qp;
+	/* Checked against each CQE in adversarial_mode */
+	u32		qpn;
 	/* Protects from UMR QP overflow
 	 */
 	struct semaphore	sem;
@@ -1309,6 +1313,7 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 			   struct uverbs_attr_bundle *attrs);
 int mlx5_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
 int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
+void mlx5_ib_cq_stop_polling(struct ib_cq *ibcq);
 int mlx5_ib_pre_destroy_cq(struct ib_cq *cq);
 void mlx5_ib_post_destroy_cq(struct ib_cq *cq);
 int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags);
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index bd180cb7f211..7b89faec0570 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -194,6 +194,23 @@ int mlx5r_umr_resource_init(struct mlx5_ib_dev *dev)
 	sema_init(&dev->umrc.sem, MAX_UMR_WR);
 	mutex_init(&dev->umrc.lock);
 	dev->umrc.state = MLX5_UMR_STATE_ACTIVE;
+
+	if (dev->ib_dev.adversarial_mode) {
+		struct mlx5_ib_cq *mcq = to_mcq(cq);
+		unsigned long flags;
+
+		dev->umrc.qpn = qp->qp_num;
+		/*
+		 * UMRs can be posted as soon as the QP is published below, by
+		 * this caller or by a concurrent MR registration, so enable
+		 * the verifying UMR poller first. The CQ is already armed, so
+		 * set it under cq->lock, which mlx5_ib_poll_cq() holds.
+		 */
+		spin_lock_irqsave(&mcq->lock, flags);
+		mcq->umr_verify = true;
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
+	if (dev->ib_dev.adversarial_mode)
+		mlx5_ib_cq_stop_polling(dev->umrc.cq);
+
 	mutex_destroy(&dev->umrc.lock);
 	/* After device init, UMR cp/qp are not unset during the lifetime. */
 	ib_destroy_qp(dev->umrc.qp);
@@ -319,6 +344,11 @@ static int mlx5r_umr_recover(struct mlx5_ib_dev *dev, u32 mkey,
 	int err;
 
 	mutex_lock(&umrc->lock);
+	if (dev->ib_dev.adversarial_mode && umrc->state == MLX5_UMR_STATE_ERR) {
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
 
+		if (dev->ib_dev.adversarial_mode) {
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

