Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.23
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724117;
	b=ve9y1rYVzd4YOg90WTTNingFst9CsZlIPJZh/umMLQd+G7VhvaTqPOdSqCYxwUSdlnNn
	 u/EQ8H9i9uJg8u34Yqvt6ag0MhV+kwK52xEdrzDYbkM+PDWgT/SzWTd34Z5en6ZUFK/DT
	 ONw3irlN89uw1zWltcYVVktwF03dFyGbmlNSEVGTJDDdR6IglP1lWYClxHlAxpk0E41PT
	 vyhUi9woXXH969dL9oqsQ1Bse20wRkH7x7UWOcu/bfCdKMPOh7z+yQVzOjdku0x0msENq
	 h22BDLLxId/cuyJ8mNiUI/419zJFA+nM581xqVyfwaVrcbdjdqOnYpKcTrbatCXOZEw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724117;
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
	b=ElPka38ito/xeFZM7ZZVYU8diI1WFQOUHO9ewHHOuGMgHXkeqxeUYW44PR+qJMVNRFT0
	 pFYyTIOl5oOkIF44F2SHKBlN13lQATqdqlQP35sEzn85tSYJzbOYwQYPAZYQV+9TooN8b
	 FM7VqNlXp2gTlbBfDv8hzgsnpV5GEDJfRtCHvOSBrVbLjt0PP5FeYr0sYzsvFYNPf2mRv
	 qvkFMH02AuyLKzarqB2GtHYBrr/tR/KmEEZagrBKvTKnfml4tsgN/szPjzFqN53VPv90b
	 rWpOlvkFBk7dz2yYFhKk/dR1fhMcC9xpiqBrJ3qHBZC+oDVTnBmklBPtLu7kvhBbFQQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Hyv4nimq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.23
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010023.outbound.protection.outlook.com [52.101.193.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4210B60A263B;
	Tue,  3 Nov 2026 16:41:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4210B60A263B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Hyv4nimq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NLszZD60RM0eXigszXLNn6kvAIyTrq2T1ANhMUUtuRQA+kqK9Cl+XrCCsgZuWl20OJ19X9IEb053npT6uHKjhltJJoa/Am/KVTE40IKbqtFTo3QmWU8korOD6AEL2N+UR4sI4jALPfr7CztDCPbWhoQtHOEv72Z6Rn/q+7unNBgJlwLGrxuZvSQG6GKb+OH4QQ4U4S2zBZTPmHjiDUj5I6iG2RKNRarPfk7D9dYyRpbqZGU/DPfqLeEw+cRs3+XKyAYTYFNwGb18/K944p5BXB3hDTYHL7fCgmfdf/CxBERAQNkqy7LGTytLtnKBck2RpckeYZubJXPREUxK4FXIfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZjMDJyqr+zQ1C3iYq6kKLn6mJ/KqIY761Y74rjsoRI=;
 b=jZCbLK4ABNsdFGDrMpIAPEV62lg0WoUjuk/MgXjR0VklKQx0TJihdQStpfoOEfK/pZwb2dQVl9x6LUogFXneiE2YZJn5NKa13FCZLoKQ/4gKtTU+THDRYuEtnQlql2qsHhE9XNIatzT8ryW5ZhWE5tJ7Qru59sQaL03faIPosf4TQdNqm3vKLtWcyfd3KV9DJw93c17zPIIGNwZ2YZVhHZ8DrU4rN7dRwM2Itf4ZnKm+ceENgL65vwo862hniY3nsNLGJrwuSSwA+art6RXEbnCFH9CaTHtFBYTv9UmG73gSBxk0RwglvbaGkolA23sHje2ltE7KGyXf1urmfdLL6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZjMDJyqr+zQ1C3iYq6kKLn6mJ/KqIY761Y74rjsoRI=;
 b=Hyv4nimq2YbBefXX6JgupB1y7wR+c6h8w5Krb7M4JArvfydxbZeWGw/Hn8K4xV1uHwKHIlYiI7G9qlTqzsUpjlqxsbwb84BqFsvSyRQ9ZBz4XuIiSiMkhBsRA/EeWniyExd/clZw7bW2aQryvI7XpxNBu7l62jHK7AVwoXuTUFJTUjEp7fgyVe4ZcHYWI+PoTWcfWzfr4F2DJnsKov4J/CeI49ysLOKKSQ4n6iEOQ215LPZUYu9WxJw6x/UXi5hm5KMLwgxerWPnG8OmbrHmVS7B/yCnTx95f0l/sL08pTyBP2Rv+KhRwyHwuJFRaNGYHnXItnXH/kj6A2TpW2zTMA==
Received: from SJ0PR03CA0334.namprd03.prod.outlook.com (2603:10b6:a03:39c::9)
 by SA3PR12MB8439.namprd12.prod.outlook.com (2603:10b6:806:2f7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:41:52 +0000
Received: from SJ1PEPF000037AB.namprd03.prod.outlook.com
 (2603:10b6:a03:39c:cafe::1d) by SJ0PR03CA0334.outlook.office365.com
 (2603:10b6:a03:39c::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:41:52 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037AB.mail.protection.outlook.com (10.167.244.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:41:52 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:30 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:30 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:41:26 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 15/23] RDMA/core: Set the CQ comp_handler after its poll context is set up
Date: Tue, 3 Nov 2026 18:39:41 +0200
Message-ID: <20261103163949.1554-16-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037AB:EE_|SA3PR12MB8439:EE_
X-MS-Office365-Filtering-Correlation-Id: 14a915ac-ff78-44c5-4b17-08df39c95d12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700016|23010399003|18002099003|22082099003|261102123227099003|56012099006|10067099003|261009221227099003|261009223027099003|261022105027099003|261021121427099003|261021123027099003|261022075727099003|5023799004|11063799006|261026121527099003|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	pDWWkN3gBZCvCWpGCQgQQDZusI1Esaic3Bwhb2bipLJXIwpj0Dgi2Xe4LbmwV+MsxLIumNJsbeD12F0rxoG3ZFNI4JJiZfgyI70XWzYPMxCfm1O7VpYE3odN3BQEwSq0tB7YS5gQch2lLMFASxGLbomIgFaQ6bzPTzlCnz95V1jbobo608CseA7DZlA5LMcKliQS7FZHsVYMnN3E6DY0OOzJWNbA4tUPwwTXwAr6tlZ7d1Lm4W+Yh9fkmEB6VMeNHkQxkBowwd/XQSi6nzfzzC6thrUL2VYJn8Jh8sRyoT8+834cXSqFSSzC0Ct/qRg5Q7k78CqaVegt25afFek8IC3cMtQ0ZSylwT9WhcfcfDqZbM4QvFvQWQQBsWj48lGNP+rRnT1cMmqwN8qAjQDhTMOP7pTejDCt34410CJPoqCzMnipnAYJAYYni+chVy02qF+jPVpNuginccncIg42LyRfXdHbGiy6vV9SapzLJ1GUnix0s8ubnDJw9MA2YvC+CI2p53OGYWWPuxKHx+S71IhS5sxvWqlBIIAS1xwp48uWymCgCLsdMj5EBhWOPNvb2RFoZu/MQf0vIBvExo85AwboUapfh45svjx+JN9bBRcqRXoPvYrJo++tVpqq1eix9z+X5elh0CIVYWj9COI6oVIOAOnLPhly5nF5mT9f95JyXunSs7MqZuQ0Bs6QJwfqmQHQGdwm7EV0M1eLaU0+cg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700016)(23010399003)(18002099003)(22082099003)(261102123227099003)(56012099006)(10067099003)(261009221227099003)(261009223027099003)(261022105027099003)(261021121427099003)(261021123027099003)(261022075727099003)(5023799004)(11063799006)(261026121527099003)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uX4vmbWAgtzQfAF1eS3p/m9mX/S6HdM5cEvTFbtwV1/w3A371LuWNOSmki7Vafc3IIFlhD3gb8ynsOmZJfLT+nSYZbrmisXBfwJs7Aqu/Y3KpPbG365U64wkBHUFcnxa1IsYovStmnW/jHgGhfkGsg4ypsnAYG6DitouNdklMfKd1JsGBEFWePvnAU50YScJrExR779S1PdxszN3mb4oJ2E35PvXSIVvlIRMl3Gon/Ec2EW/pdxFlhZ+bACrV+snYKt3zHpD7WMtcLDMXGqz+y1C8fHXkdvsnRwQhtnNZXswaGWzzXNjMlgX/0INE8aaJcogGCApktPQ/XLmdL8KFLhArDfPoQGiHQ/rHfSv1UxZNnwveM9JDpL4KaKlFMeT3FglAhIiyEufgRlaWyZ7VIsB18P9X9FO+5H2z/N2GwcbDt4TQkPohNzg/8XXLuZP
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:41:52.2296
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14a915ac-ff78-44c5-4b17-08df39c95d12
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037AB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8439

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

