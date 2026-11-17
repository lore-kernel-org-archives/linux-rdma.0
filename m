Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935501;
	b=AK8amVd9meJSvT+HssasE0vH6gN+R15HbZnVBbnt6n026olcGIc7maGHKz3RpR0lmKWg
	 nvT78XZ7qLCsbd2txTzkE48+CVCtwyVl9R5wtT3r/FMYFwoQfDIp8Xi3SazWxKiRcM1xe
	 eTrTfb9gYGgUrOoKGr8oMOodcpiswro3d7uTHAQUldrqJeJEwBJd519jbTEYwRAelXu4X
	 eEb1i45G4KEU+J/5wK1GCqBHBwXZr4KMDhzObCraWf27QFDTDAzlh5rP+5WfA4viGNF5J
	 7h4xMu2mRqtk5xamV73575Tdh8GXyck4t1ZN/6RAAnXaaFBo25m6tUog3Taw+KJ/Jtg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935501;
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
	bh=xZjMDJyqr+zQ1C3iYq6kKLn6mJ/KqIY761Y74rjsoRI=;
	b=SYhnn9RgdXN6p6svv5QdQQ6PZh3GH2qYYHr2iqI5Gaikh47TEeIPFpzxgKbSycN1193l
	 HUdKONtjHNi4qbREl6IWmZxrMWaRIkxOnqWdk6tHMDtXGY8s4LZEs/syVlUSZq9jStSpS
	 EII1jhGzN1qDvkWYyO77dN1QIytN21GtytSsQ64Ybo6NwP+ICqSRo3OuPtauUbdcONVHM
	 vPi6QApggK7rm+H3pKxhz+QhoU48xhw5cIeQaNKCehkLZSTskuF0KQAT66MPxPhCPJZvd
	 vNRRO70/N2Q7o184QHXl2tnTXaNYgRPYwMSVt0ObERTheqouQ/Y+hvr4FmHbqAeBpQA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="PGYF8dk/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.58
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010058.outbound.protection.outlook.com [40.93.198.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E75606A31C;
	Tue, 17 Nov 2026 17:11:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6E75606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PGYF8dk/
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rxdax7wH1hJ51RxPnXmXB5jljGoxNys7xz1veDC6GDM/hasK7QFp1UdzzCnAQ4+nEQ2A/WVZPezwAFKInH7iIyBveG2uVa6V27tmEuN5ZzNmCXLNEJ/KyHo3d9OyK9X5KAxBrbTKHxjKbeU21eIQdHSunjGKArSQTVJwo0UC+VIRecF9vOYQigJGYIqU9I5w1fEU2lCyXlBDZlehVGlN+96G0NrmNxCHtnlMCV5iESjhXGWU98xcpiynk9863yd0UbCvjMCe9CMTaBUZUQXG/Mvlud5J0ucp3eV5wCkkswhK/459gEuD1fQG4CxSXUAxt8TQqa8i2mtWYVCOj+9N2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZjMDJyqr+zQ1C3iYq6kKLn6mJ/KqIY761Y74rjsoRI=;
 b=ilG7SxbkUO6c9Bv4+h3r13QjRlv4ZUjVjaAAs41eMJH2YKd3hPqgAUWoPJlVvezItHoiKMtOwj1R+amyi4mSRBQAfp3LIY/jEda4FjT2yb3kDjiPkcH0+9szxV67xBgCoEduisG/lpaXelycqm3kM4An/JFpK0PkHoeh+33BmBxi5E8qIDwI/IMPrVBRfiNchPdlwizejC/5H3zHdu5SaaNIXaPY2DGHs16iCRqICaBwMbZ8Rt6QYGaJZlhIrf8dM6SFt288L7vMKEFwBNbdL/kCvJaGQNVsGSAzNqr1ZVokx4nFJNyD6TrHT4DyqI9RIxIU7wZsmPc8byUMFo1KNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZjMDJyqr+zQ1C3iYq6kKLn6mJ/KqIY761Y74rjsoRI=;
 b=PGYF8dk/qDu7eJS7dA766xPrz7ea0VFYwFSaLBu9lj5uLNY6CtrWZFb+oQUlcGQzyeouMS+0m3Csi88/pWOf93ghBaE+GZvSlcrMzUMh06NkVgDVvwvsORQaHsMV33McYgq2PMpNn/C+81nXixl8pUCxDMK+8oZKRJkaq3ydyNrugmDwkdhDZMu+DdHkKUPiNsBIqgpmUBpuol1zZbGp9vrCugRXYa2x341eGJ1bOg5Hl6LlNSdTzoKp6sCzm05Hpei02NJ8HAzK8lkOx93JnasjnjDBGWjvHeNHE+U7t0oeGwKh8XqPcMd3U4hfx9gRQ5cxuBWl4WshaJWMJmT/CQ==
Received: from MW4PR04CA0377.namprd04.prod.outlook.com (2603:10b6:303:81::22)
 by SJ0PR12MB6902.namprd12.prod.outlook.com (2603:10b6:a03:484::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:11:30 +0000
Received: from MWH0EPF000A6732.namprd04.prod.outlook.com
 (2603:10b6:303:81:cafe::7a) by MW4PR04CA0377.outlook.office365.com
 (2603:10b6:303:81::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Tue,
 17 Nov 2026 17:11:30 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MWH0EPF000A6732.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:11:30 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:10:49 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:10:49 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:10:45 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 14/21] RDMA/core: Set the CQ comp_handler after its poll context is set up
Date: Tue, 17 Nov 2026 19:09:07 +0200
Message-ID: <20261117170914.27410-15-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6732:EE_|SJ0PR12MB6902:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f754356-c375-42dc-bbc8-08df44cdd2ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|23010399003|18002099003|22082099003|261009221227099003|261009223027099003|11063799006|56012099006|261102123227099003|261028144727099003|10067099003|261026140227099003|261026121527099003|261021121427099003|261022075727099003|261022105027099003|261021123027099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	9WkEkf1vCX4Gbremw9+RgZ8v76xUucI/FL2cqYnlSJMTwUIq82YVjNRx/mmD41zm02SgFdsj97ZYDVL457QFfqbcIpK3polN3PJivpPHHR+gJPilKpxchRLp+MDJMiN2EQE41r10UxkMKKtvEfM5yLVcdUUyfo1+85WSNMf5rhZa1U0h515RWMpdlCfdbZG+slZmsRoUA8I/yvMWV2LL+rwD1spCirxlEVPEIcYTQaXsQRVN+I5Dz2P0bH8Y+iU2/8v9BqI8hqwdEs88NdTg2Tg9DAduBZV57/KhzN/7ya340U2mvTMclLVOkuEso744vFYYj2sYwVczFQjpgK7sBBm7Wd68vHHbv9EXvuWCsLPm2Er+Ho3vpo7mKTA78UhIWUkIa6aR7udbhT4suathqomDCdQ/9m27orN2JKDkc0Qy+v7BEV8CjvKHIk/mOkLobznDfe3+c4HeMwMXJ9/Cs0ApwdIZIDMP88evlm8PybubOYma9nC0bQaqlPtDSvDoYm63xVmUKOPvkMyatlJfui1tzCwQdldiI2kBBuvXvZm6cSJPpyeb44L3YdI3dMeRGX9QbOAx/bzHT7qZdJQYe9m84S4FLMulMNJNRcD5eo37l3pWoKi9nMHwUMAQ5xJpZuzpXZdNjKnan+Gc7bypnkwnLs7LeMeyhdVaUKpos+dxpjUuHGLpq0YjJcW7thPgQaHJ1pdFL+q5HHhh8AUj8A==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(261009221227099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(10067099003)(261026140227099003)(261026121527099003)(261021121427099003)(261022075727099003)(261022105027099003)(261021123027099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	i7JLEgP0LBnI3Rh1DXih2klfiOH64L3GhrZiFMmwQuMNFGFLLlXVVuBFmhekBEgWF4iqUXVE0T+0tzP21pCY1PJUu8lNJHd7JFhlV2R28blhy39Akdyz0uVmUpI11Hn6drMVepAuXymTUm72ESNMBlXfNK8rr+WJIwlzLM8NUUe8Dj/KvxmRXUlWWtCO3M5dErIRtJ6UfON16UuGTmY3dtb5DAGOrsiLDDWB8+jvwvOn54bwR9zWkOP5X+UPab0WnpEZ5YUN7/W/LOQBwkDgoSyA9Zxbh0+pukXj7WrtdgN4PeKOfMw7Vuhd+SK7VmEXY9rVZj3ABINBP1vUmCKBLoSJo1eTGlHHCkhq2SINVyE5ktL2PUgjfkaKFOnOUyH1fKWYp22tLsdcaCm6tdhjBf2T7Dqdh1mB/0x6JKZALKIJy2SXxATu7EBokWC/feIC
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:11:30.6810
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f754356-c375-42dc-bbc8-08df44cdd2ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6732.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6902

__ib_alloc_cq() sets comp_handler before it initializes the poll context
the handler schedules, and for the workqueue contexts it arms the CQ
before setting comp_wq. The CQ is reachable from the completion
interrupt once ops.create_cq() returns, so a completion event raised in
that window would schedule an uninitialized irq_poll or work, or queue
work on a NULL workqueue. A conforming device raises no event for a new,
empty CQ, but nothing in the core relies on that.

Initialize the poll context first, then set comp_handler, and arm the CQ
only after that.

Fixes: 14d3a3b2498e ("IB: add a proper completion queue abstraction")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/core/cq.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index 12304c9a9403..42e4d272f5ad 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -217,6 +217,7 @@ struct ib_cq *__ib_alloc_cq(struct ib_device *dev, void *private, int nr_cqe,
 		.cqe		= nr_cqe,
 		.comp_vector	= comp_vector,
 	};
+	ib_comp_handler comp_handler;
 	struct ib_cq *cq;
 	int ret = -ENOMEM;
 
@@ -248,19 +249,16 @@ struct ib_cq *__ib_alloc_cq(struct ib_device *dev, void *private, int nr_cqe,
 
 	switch (cq->poll_ctx) {
 	case IB_POLL_DIRECT:
-		cq->comp_handler = ib_cq_completion_direct;
+		comp_handler = ib_cq_completion_direct;
 		break;
 	case IB_POLL_SOFTIRQ:
-		cq->comp_handler = ib_cq_completion_softirq;
-
+		comp_handler = ib_cq_completion_softirq;
 		irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ, ib_poll_handler);
-		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 		break;
 	case IB_POLL_WORKQUEUE:
 	case IB_POLL_UNBOUND_WORKQUEUE:
-		cq->comp_handler = ib_cq_completion_workqueue;
+		comp_handler = ib_cq_completion_workqueue;
 		INIT_WORK(&cq->work, ib_cq_poll_work);
-		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 		cq->comp_wq = (cq->poll_ctx == IB_POLL_WORKQUEUE) ?
 				ib_comp_wq : ib_comp_unbound_wq;
 		break;
@@ -269,6 +267,15 @@ struct ib_cq *__ib_alloc_cq(struct ib_device *dev, void *private, int nr_cqe,
 		goto out_destroy_cq;
 	}
 
+	/*
+	 * The CQ is reachable from the completion interrupt once created. Set
+	 * the handler only after the poll context it schedules is set up, and
+	 * arm the CQ only after that.
+	 */
+	cq->comp_handler = comp_handler;
+	if (cq->poll_ctx != IB_POLL_DIRECT)
+		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
+
 	rdma_restrack_add(&cq->res);
 	trace_cq_alloc(cq, nr_cqe, comp_vector, poll_ctx);
 	return cq;
-- 
2.18.1

