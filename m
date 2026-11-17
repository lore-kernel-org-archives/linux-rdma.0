Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794924144;
	b=VX6iIOeM8X5irGpeAc1mJi4mZrEP2a5qoToNrDZTGDdRDOYs6x4YGLByvy+9jEN436KJ
	 qcXg1DRbroP+93GAyzKYWcZBrReqV7c7sGtj0r+lhm5t05j1NzO1RsxMG5FLc5GRwnalk
	 FARntuh5SxjpVAxByovgcGnVBVztm0kjNDsViLR7F5qBHnUFDvjAbM3IMYQ6MotVE8J4x
	 Lp2mfPoTbn9Uyi9YraFYVSbFS7oBnzf8VqLzIYDz844dCfBNVyA1wyxGw3Im4Tccv/qXX
	 8Q6PAdqBlimR1+K/n0cUO34JbG1i92280zZ75H80+1aRysbIGbgA9J9zgOsJuP3iKgA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924144;
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
	bh=At3FkNS55pndgj8Xvz/Jhih1tkc7ZvnOznEq/Zux9FM=;
	b=d49kR/9fZ0f1aHQboKlFFdGj6jpvaXiS+HQfDteeWPzD3XR+04jbeZgbAeM8vNWYV9yx
	 iPunyUk4Sdtrt9crMcCtZwxyPSzUOHBKiRSyv0qDi7LAuFlx2qxxNy9UC4IG9S1WvVL4G
	 t+M0oVpmKcPVOo3XQT0RSdu249X3YOazbU/oXm3pqu3Ea0kuT9vpcYAxwpU1Y8kFFcTe2
	 fFF6PxAOaWPCSVQp0r/HwaJZ9KiOUVX477lLM6+ElcKx5GdM4JQOKJhOwDbaeq+RXG54M
	 fFSl3EvzNQDXiegMyBjbtTwtB58b0ftP7KN4frJHtZwBzEUh7vVaxjxk4FYxT4EHw/A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GfCj52lK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.14
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010014.outbound.protection.outlook.com [52.101.85.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD9D606A334;
	Tue, 17 Nov 2026 14:02:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AD9D606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GfCj52lK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KFPqhHCUInNvGHHYM9vy6F0NR6bjotN+v5X/yhAIAajDVtiY235wK7nwQ1k6WXWuAVBNwtH1KiM45kQvKSvrGivy7cxyTAUS5C1DoUd4pbPW3wj1KcQmNM590pwQXk07HwqgiTFG1rsSZ3oBXMd7VQ0ynu/+Qe6Owcm/qImx7qogBd1WY//uV6Z4lMCnkbKCJKpVSwypsgZ+KUIti+BSTuDP/P9AUfCWOIbTyhGUnsScLUuKmumtHtFSXRcXCkqRj/ZdVSRIlIsD/vYkOckTz7PyS2Xhx6D5NIktj0iwImmgSkvgRcklAdXhm8wv1hcRBtQfUQdzE2+Kgb1BX4kbSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=At3FkNS55pndgj8Xvz/Jhih1tkc7ZvnOznEq/Zux9FM=;
 b=FM9Y29OwtW8ZVV/CeTQkYJ75Y9DGRcz/NPRs5RuIqxFOl2xzr5IiQrW4FJ08n0+i/xQD0s41DWBTZx7fLFv59Obrt3tka6+d6KAtxT7QilswS4tg/NUJESiP/QKdCZEReqxuPzEG93SoAQOV4Ns6sa3WxJoc4dDt9CBkqnhhdHd2jd0nSZDdKYlGsz6cT89W1xDiVWJ3fustLLQkADfkc9R1Bbcn1C1X7jDubDqEUv3j1PN3OHyu5yzBmb/5wUGK6PYwAH1I/uZMiQH8bkPuL9emy8H54r6uVwTTW9ygfUyXo8jNTyqWsMLrzaCHdY+H+kqb267W8Pyp04I40TtDQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=At3FkNS55pndgj8Xvz/Jhih1tkc7ZvnOznEq/Zux9FM=;
 b=GfCj52lK34+Vzc4WnwJMKc7jM+JUAYzDGnjQabHZvjEcX58G5eRQ8U1yjNnBFTpAX1XfT7NeWvtjPbVyO7vk/t9R25ddK70BbcXKhj9T2FYK1xluFQzsQn/NJjpCSOSQwf7mq4L7oRiZFGCYojTYtyb43SJpXHIhZ/P519BpKcuLWya6wPxqUdBEp8O6IrDgiJeplfOKg1kFg0MJznvGvku4Nz+rV4RHpM/VsCq6CneEcEvdgRbvgcDlnk3EpthI8WdmKeQRjd6STzpY0bgUFbsFhPjPVw4xN22p0wAbalPNz3gd4kfMdSRwcGCd/gW8YvIhQDo3hNDsucTcLUXv1g==
Received: from CH0PR03CA0238.namprd03.prod.outlook.com (2603:10b6:610:e7::33)
 by BL1PR12MB5851.namprd12.prod.outlook.com (2603:10b6:208:396::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 14:02:16 +0000
Received: from IA0PEPF00000037.namprd03.prod.outlook.com
 (2603:10b6:610:e7:cafe::6a) by CH0PR03CA0238.outlook.office365.com
 (2603:10b6:610:e7::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Tue,
 17 Nov 2026 14:02:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 IA0PEPF00000037.mail.protection.outlook.com (10.167.249.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 14:02:14 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 17 Nov
 2026 06:01:46 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 17 Nov
 2026 06:01:46 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 17
 Nov 2026 06:01:43 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Tue, 17 Nov 2026 16:01:20 +0200
Subject: [PATCH rdma-next 09/11] RDMA/mlx5: Cache the CQ core device and
 resolve it via cq_to_mdev()
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
Message-ID: <20261117-mlx5-sd-prep-v1-9-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
In-Reply-To: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	"Sabrina Dubroca" <sd@queasysnail.net>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, Edward Srouji <edwards@nvidia.com>, "Akiva
 Goldberger" <agoldberger@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794924076; l=17577;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=FhU+TLIM/+Apam5t0J/yB9aqoDO+X7fTRBw0zklWJyk=;
 b=ywpZyULMehv+QtiytGOtoDJXX6SMa/NBqDY2aIBzPjR6ZiAGVZviU7JG3Ur174bfjNrCkTBrN
 h9DN+m8WH9nCA9yq/TVO/w34u7wBUfLeUDGgfq5bKZy7izBCjB5SpKT
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PEPF00000037:EE_|BL1PR12MB5851:EE_
X-MS-Office365-Filtering-Correlation-Id: b1cd3824-2ae8-4d88-f3bc-08df44b36236
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|23010399003|6133799003|22082099003|18002099003|261009223027099003|261022075727099003|261022105027099003|261021123027099003|261021121427099003|261026140227099003|261026121527099003|261028144727099003|56012099006|11063799006|10067099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	mL1TnI3Y3Qf1aGC/C2BJmyNKnxNOb4QkdrxQhI9McplWskSPzBSLqZC78nH1G16KOS5yOgEAX3CBEf+KtjEsqXBgD3JOxKZJk1dBc+A/OwEmH+k7pJ8Ci4oG4EGpy+vkKlkyAA4efMXM2tO1+uPG5ASf+9VXw+VUqEZ3z0t50a0WWGWmqxI6+/LaT4qXCPIgYRwA//y6wQvntc+M5yM9nYZudrH54OST0Vnz82jNuvtdWxyG4ukwAdC4BGIRQmn1WHfE2Is2+bFrkXkidLUsjATCXhyF8Q1QXkUXKCwGlmBqM7LTQxVnitNgRQnx+KXEu3rTGmyfHLIAiOIqKluUfqZjFfsU9vtIMDZbJf+WwRjcXYmCBaL1lGOeke+27h65Ki31VW4ga16XlmuthhYnGmiqvXkHTNV9BLzfZ+gOsIRmqD9QpxOb2gelSR7SBHU7eViU7YJU+eLSmayrwBHkiEIg/aW3Y/jEQeVrEKOleLnnqNHDzGJwoEFqwwr94IXYBhzqNH3Vm927EyJJR3320GPj1kx0fXZJYI5MvpucPEjQoQdmPLsHXMynn1bD3QjX5Dy/fbVnRE15jY4LHZ7+FMhy443ed+DldjKx5hGjTA7JjB+veH7F6BC2lgNwSpuyIYfI/nXqF3uevNmrZFPCYIC7vUzPAfmWPR6u+cYr2qfMXrc+7p5LgpAuNKoXprE7AdwAAMMOr07hcQ3JnvKkEg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(23010399003)(6133799003)(22082099003)(18002099003)(261009223027099003)(261022075727099003)(261022105027099003)(261021123027099003)(261021121427099003)(261026140227099003)(261026121527099003)(261028144727099003)(56012099006)(11063799006)(10067099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VHenyNuhqBKrBrNRwLH0mXeCTCwQZeDfeWygAP+4FJRjIsxD0nk6efJpn7c98OzC6uo1pUkys1gTYHAA0Elx6qW27Smr2hjG70y9FWTYLsHUd/pBj2B7UpR7UO28IhwCRuSCxH+o7L8ZH1RW+3LmGxELZeERl46VLWiYuWdE/KbJBocO+xqgysJVlBLAEFqpKwIsSRTWwevquXl8IleDHSoy8ylOVY5sIptE4nMUpStXwLYLkSXpEsdyGLlZ+m292Zl35C6QAcG7jFwrWuwbQdrTIL9l5HoLcyXuk1pyRpX+QSB2w57CQs0/x7zaxdm9+Th7agvsfoR1rIVUt7PzctPRWe/b9JOSATyK1O9DQVA/apSVvRATG03JhEgnUq5BGZ/qZb6NqyCZcpxp4rvhN7XWpoMjUQOni74dMyOMsoqh6RWl6zRxCOEZNXjcfMi1
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 14:02:14.6344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1cd3824-2ae8-4d88-f3bc-08df44b36236
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF00000037.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5851

From: Akiva Goldberger <agoldberger@nvidia.com>

A CQ can be created by the user or the kernel, so it doesn't always have
a user context, and it has no attached PD. Therefore, it lacks a
reliable source for resolving the core device it was created on.  Cache
the core device in mlx5_ib_cq at create time and add the cq_to_mdev()
helper to resolve the core device instead of using the dev->mdev
reference.

No functional change.

Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cq.c       | 102 ++++++++++++++++++----------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h  |   6 ++
 drivers/infiniband/hw/mlx5/qp.c       |   2 +-
 drivers/infiniband/hw/mlx5/restrack.c |  14 ++---
 4 files changed, 66 insertions(+), 58 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index b28ce05fab8f3d668d4e9b43c5562e7a88c37b4a..5eaf50fe7f540c3fb1c909f19589ece932bcb2b4 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -358,9 +358,9 @@ static void handle_atomics(struct mlx5_ib_qp *qp, struct mlx5_cqe64 *cqe64,
 	qp->sq.last_poll = tail;
 }
 
-static void free_cq_buf(struct mlx5_ib_dev *dev, struct mlx5_ib_cq_buf *buf)
+static void free_cq_buf(struct mlx5_core_dev *mdev, struct mlx5_ib_cq_buf *buf)
 {
-	mlx5_frag_buf_free(dev->mdev, &buf->frag_buf);
+	mlx5_frag_buf_free(mdev, &buf->frag_buf);
 }
 
 static void get_sig_err_item(struct mlx5_sig_err_cqe *cqe,
@@ -480,7 +480,7 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
 	opcode = get_cqe_opcode(cqe64);
 	if (unlikely(opcode == MLX5_CQE_RESIZE_CQ)) {
 		if (likely(cq->resize_buf)) {
-			free_cq_buf(dev, &cq->buf);
+			free_cq_buf(cq_to_mdev(cq), &cq->buf);
 			cq->buf = *cq->resize_buf;
 			kfree(cq->resize_buf);
 			cq->resize_buf = NULL;
@@ -612,8 +612,7 @@ int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 {
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
 	struct mlx5_ib_qp *cur_qp = NULL;
-	struct mlx5_ib_dev *dev = to_dev(cq->ibcq.device);
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = cq_to_mdev(cq);
 	unsigned long flags;
 	int soft_polled = 0;
 	int npolled;
@@ -647,8 +646,8 @@ int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 
 int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 {
-	struct mlx5_core_dev *mdev = to_dev(ibcq->device)->mdev;
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
+	struct mlx5_core_dev *mdev = cq_to_mdev(cq);
 	void __iomem *uar_page = mdev->priv.bfreg.up->map;
 	unsigned long irq_flags;
 	int ret = 0;
@@ -669,7 +668,7 @@ int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 	return ret;
 }
 
-static int alloc_cq_frag_buf(struct mlx5_ib_dev *dev,
+static int alloc_cq_frag_buf(struct mlx5_core_dev *mdev,
 			     struct mlx5_ib_cq_buf *buf,
 			     int nent,
 			     int cqe_size)
@@ -679,10 +678,10 @@ static int alloc_cq_frag_buf(struct mlx5_ib_dev *dev,
 	u8 log_wq_sz     = ilog2(cqe_size);
 	int err;
 
-	err = mlx5_frag_buf_alloc_node(dev->mdev,
+	err = mlx5_frag_buf_alloc_node(mdev,
 				       nent * cqe_size,
 				       frag_buf,
-				       dev->mdev->priv.numa_node);
+				       mdev->priv.numa_node);
 	if (err)
 		return err;
 
@@ -700,7 +699,7 @@ enum {
 	MLX5_CQE_RES_FORMAT_CSUM_STRIDX = 3,
 };
 
-static int mini_cqe_res_format_to_hw(struct mlx5_ib_dev *dev, u8 format)
+static int mini_cqe_res_format_to_hw(struct mlx5_core_dev *mdev, u8 format)
 {
 	switch (format) {
 	case MLX5_IB_CQE_RES_FORMAT_HASH:
@@ -708,7 +707,7 @@ static int mini_cqe_res_format_to_hw(struct mlx5_ib_dev *dev, u8 format)
 	case MLX5_IB_CQE_RES_FORMAT_CSUM:
 		return MLX5_CQE_RES_FORMAT_CSUM;
 	case MLX5_IB_CQE_RES_FORMAT_CSUM_STRIDX:
-		if (MLX5_CAP_GEN(dev->mdev, mini_cqe_resp_stride_index))
+		if (MLX5_CAP_GEN(mdev, mini_cqe_resp_stride_index))
 			return MLX5_CQE_RES_FORMAT_CSUM_STRIDX;
 		return -EOPNOTSUPP;
 	default:
@@ -807,9 +806,9 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 		int mini_cqe_format;
 
 		if (!((*cqe_size == 128 &&
-		       MLX5_CAP_GEN(dev->mdev, cqe_compression_128)) ||
+		       MLX5_CAP_GEN(cq_to_mdev(cq), cqe_compression_128)) ||
 		      (*cqe_size == 64  &&
-		       MLX5_CAP_GEN(dev->mdev, cqe_compression)))) {
+		       MLX5_CAP_GEN(cq_to_mdev(cq), cqe_compression)))) {
 			err = -EOPNOTSUPP;
 			mlx5_ib_warn(dev, "CQE compression is not supported for size %d!\n",
 				     *cqe_size);
@@ -817,7 +816,7 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 		}
 
 		mini_cqe_format =
-			mini_cqe_res_format_to_hw(dev,
+			mini_cqe_res_format_to_hw(cq_to_mdev(cq),
 						  ucmd.cqe_comp_res_format);
 		if (mini_cqe_format < 0) {
 			err = mini_cqe_format;
@@ -832,7 +831,7 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 
 	if (ucmd.flags & MLX5_IB_CREATE_CQ_FLAGS_CQE_128B_PAD) {
 		if (*cqe_size != 128 ||
-		    !MLX5_CAP_GEN(dev->mdev, cqe_128_always)) {
+		    !MLX5_CAP_GEN(cq_to_mdev(cq), cqe_128_always)) {
 			err = -EOPNOTSUPP;
 			mlx5_ib_warn(dev,
 				     "CQE padding is not supported for CQE size of %dB!\n",
@@ -882,7 +881,7 @@ static void init_cq_frag_buf(struct mlx5_ib_cq_buf *buf)
 	}
 }
 
-static int create_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
+static int create_cq_kernel(struct mlx5_ib_cq *cq,
 			    int entries, int cqe_size,
 			    u32 **cqb, int *index, int *inlen)
 {
@@ -890,7 +889,7 @@ static int create_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 	void *cqc;
 	int err;
 
-	err = mlx5_db_alloc(dev->mdev, &cq->db);
+	err = mlx5_db_alloc(cq_to_mdev(cq), &cq->db);
 	if (err)
 		return err;
 
@@ -898,7 +897,7 @@ static int create_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 	cq->mcq.arm_db     = cq->db.db + 1;
 	cq->mcq.cqe_sz = cqe_size;
 
-	err = alloc_cq_frag_buf(dev, &cq->buf, entries, cqe_size);
+	err = alloc_cq_frag_buf(cq_to_mdev(cq), &cq->buf, entries, cqe_size);
 	if (err)
 		goto err_db;
 
@@ -921,22 +920,22 @@ static int create_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 		 cq->buf.frag_buf.page_shift -
 		 MLX5_ADAPTER_PAGE_SHIFT);
 
-	*index = dev->mdev->priv.bfreg.up->index;
+	*index = cq_to_mdev(cq)->priv.bfreg.up->index;
 
 	return 0;
 
 err_buf:
-	free_cq_buf(dev, &cq->buf);
+	free_cq_buf(cq_to_mdev(cq), &cq->buf);
 
 err_db:
-	mlx5_db_free(dev->mdev, &cq->db);
+	mlx5_db_free(cq_to_mdev(cq), &cq->db);
 	return err;
 }
 
-static void destroy_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq)
+static void destroy_cq_kernel(struct mlx5_ib_cq *cq)
 {
-	free_cq_buf(dev, &cq->buf);
-	mlx5_db_free(dev->mdev, &cq->db);
+	free_cq_buf(cq_to_mdev(cq), &cq->buf);
+	mlx5_db_free(cq_to_mdev(cq), &cq->db);
 }
 
 static void notify_soft_wc_handler(struct work_struct *work)
@@ -967,14 +966,16 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 	int eqn;
 	int err;
 
-	if (attr->cqe > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
+	cq->mdev = dev->mdev;
+
+	if (attr->cqe > (1 << MLX5_CAP_GEN(cq_to_mdev(cq), log_max_cq_sz)))
 		return -EINVAL;
 
 	if (check_cq_create_flags(attr->flags))
 		return -EOPNOTSUPP;
 
 	entries = roundup_pow_of_two(entries + 1);
-	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
+	if (entries > (1 << MLX5_CAP_GEN(cq_to_mdev(cq), log_max_cq_sz)))
 		return -EINVAL;
 
 	cq->ibcq.cqe = entries - 1;
@@ -990,7 +991,7 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 	if (err)
 		return err;
 
-	err = mlx5_comp_eqn_get(dev->mdev, vector, &eqn);
+	err = mlx5_comp_eqn_get(cq_to_mdev(cq), vector, &eqn);
 	if (err)
 		goto err_cqb;
 
@@ -1011,7 +1012,8 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 	cq->mcq.comp = mlx5_add_cq_to_tasklet;
 	cq->mcq.tasklet_ctx.comp = mlx5_ib_cq_comp;
 
-	err = mlx5_core_create_cq(dev->mdev, &cq->mcq, cqb, inlen, out, sizeof(out));
+	err = mlx5_core_create_cq(cq_to_mdev(cq), &cq->mcq, cqb, inlen, out,
+				  sizeof(out));
 	if (err)
 		goto err_cqb;
 
@@ -1029,7 +1031,7 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 	return 0;
 
 err_cmd:
-	mlx5_core_destroy_cq(dev->mdev, &cq->mcq);
+	mlx5_core_destroy_cq(cq_to_mdev(cq), &cq->mcq);
 
 err_cqb:
 	kvfree(cqb);
@@ -1055,11 +1057,13 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	int eqn;
 	int err;
 
-	if (attr->cqe > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
+	cq->mdev = dev->mdev;
+
+	if (attr->cqe > (1 << MLX5_CAP_GEN(cq_to_mdev(cq), log_max_cq_sz)))
 		return -EINVAL;
 
 	entries = roundup_pow_of_two(entries + 1);
-	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
+	if (entries > (1 << MLX5_CAP_GEN(cq_to_mdev(cq), log_max_cq_sz)))
 		return -EINVAL;
 
 	cq->ibcq.cqe = entries - 1;
@@ -1069,14 +1073,14 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	INIT_LIST_HEAD(&cq->list_recv_qp);
 
 	cqe_size = cache_line_size() == 128 ? 128 : 64;
-	err = create_cq_kernel(dev, cq, entries, cqe_size, &cqb, &index,
+	err = create_cq_kernel(cq, entries, cqe_size, &cqb, &index,
 			       &inlen);
 	if (err)
 		return err;
 
 	INIT_WORK(&cq->notify_work, notify_soft_wc_handler);
 
-	err = mlx5_comp_eqn_get(dev->mdev, vector, &eqn);
+	err = mlx5_comp_eqn_get(cq_to_mdev(cq), vector, &eqn);
 	if (err)
 		goto err_cqb;
 
@@ -1094,7 +1098,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 
 	cq->mcq.comp = mlx5_ib_cq_comp;
 
-	err = mlx5_core_create_cq(dev->mdev, &cq->mcq, cqb, inlen, out,
+	err = mlx5_core_create_cq(cq_to_mdev(cq), &cq->mcq, cqb, inlen, out,
 				  sizeof(out));
 	if (err)
 		goto err_cqb;
@@ -1108,25 +1112,24 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 
 err_cqb:
 	kvfree(cqb);
-	destroy_cq_kernel(dev, cq);
+	destroy_cq_kernel(cq);
 	return err;
 }
 
 int mlx5_ib_pre_destroy_cq(struct ib_cq *cq)
 {
-	struct mlx5_ib_dev *dev = to_dev(cq->device);
 	struct mlx5_ib_cq *mcq = to_mcq(cq);
 
 	if (!cq->uobject)
 		cancel_work_sync(&mcq->notify_work);
 
-	return mlx5_core_destroy_cq(dev->mdev, &mcq->mcq);
+	return mlx5_core_destroy_cq(cq_to_mdev(mcq), &mcq->mcq);
 }
 
 void mlx5_ib_post_destroy_cq(struct ib_cq *cq)
 {
 	WARN_ON(!list_empty(&to_mcq(cq)->wc_list));
-	destroy_cq_kernel(to_dev(cq->device), to_mcq(cq));
+	destroy_cq_kernel(to_mcq(cq));
 }
 
 int mlx5_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
@@ -1217,13 +1220,13 @@ int mlx5_ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period)
 	struct mlx5_ib_cq *mcq = to_mcq(cq);
 	int err;
 
-	if (!MLX5_CAP_GEN(dev->mdev, cq_moderation))
+	if (!MLX5_CAP_GEN(cq_to_mdev(mcq), cq_moderation))
 		return -EOPNOTSUPP;
 
 	if (cq_period > MLX5_MAX_CQ_PERIOD)
 		return -EINVAL;
 
-	err = mlx5_core_modify_cq_moderation(dev->mdev, &mcq->mcq,
+	err = mlx5_core_modify_cq_moderation(cq_to_mdev(mcq), &mcq->mcq,
 					     cq_period, cq_count);
 	if (err)
 		mlx5_ib_warn(dev, "modify cq 0x%x failed\n", mcq->mcq.cqn);
@@ -1264,7 +1267,7 @@ static int resize_user(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 	return 0;
 }
 
-static int resize_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
+static int resize_kernel(struct mlx5_ib_cq *cq,
 			 int entries, int cqe_size)
 {
 	int err;
@@ -1273,7 +1276,8 @@ static int resize_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 	if (!cq->resize_buf)
 		return -ENOMEM;
 
-	err = alloc_cq_frag_buf(dev, cq->resize_buf, entries, cqe_size);
+	err = alloc_cq_frag_buf(cq_to_mdev(cq), cq->resize_buf, entries,
+				cqe_size);
 	if (err)
 		goto ex;
 
@@ -1357,16 +1361,16 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 	int cqe_size;
 	unsigned long flags;
 
-	if (!MLX5_CAP_GEN(dev->mdev, cq_resize)) {
+	if (!MLX5_CAP_GEN(cq_to_mdev(cq), cq_resize)) {
 		pr_info("Firmware does not support resize CQ\n");
 		return -ENOSYS;
 	}
 
-	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
+	if (entries > (1 << MLX5_CAP_GEN(cq_to_mdev(cq), log_max_cq_sz)))
 		return -EINVAL;
 
 	entries = roundup_pow_of_two(entries + 1);
-	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)) + 1)
+	if (entries > (1 << MLX5_CAP_GEN(cq_to_mdev(cq), log_max_cq_sz)) + 1)
 		return -EINVAL;
 
 	if (entries == ibcq->cqe + 1)
@@ -1394,7 +1398,7 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 		struct mlx5_frag_buf *frag_buf;
 
 		cqe_size = 64;
-		err = resize_kernel(dev, cq, entries, cqe_size);
+		err = resize_kernel(cq, entries, cqe_size);
 		if (err)
 			goto ex;
 		frag_buf = &cq->resize_buf->frag_buf;
@@ -1438,7 +1442,7 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 	MLX5_SET(modify_cq_in, in, op_mod, MLX5_CQ_OPMOD_RESIZE);
 	MLX5_SET(modify_cq_in, in, cqn, cq->mcq.cqn);
 
-	err = mlx5_core_modify_cq(dev->mdev, &cq->mcq, in, inlen);
+	err = mlx5_core_modify_cq(cq_to_mdev(cq), &cq->mcq, in, inlen);
 	if (err)
 		goto ex_alloc;
 
@@ -1465,7 +1469,7 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 		cq->ibcq.cqe = entries - 1;
 		spin_unlock_irqrestore(&cq->lock, flags);
 		if (resized)
-			free_cq_buf(dev, &tbuf);
+			free_cq_buf(cq_to_mdev(cq), &tbuf);
 	}
 	mutex_unlock(&cq->resize_mutex);
 
@@ -1478,7 +1482,7 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 ex_resize:
 	ib_umem_release(cq->resize_umem);
 	if (!udata) {
-		free_cq_buf(dev, cq->resize_buf);
+		free_cq_buf(cq_to_mdev(cq), cq->resize_buf);
 		cq->resize_buf = NULL;
 	}
 ex:
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 15d28cad7ea6c1778419e490ccc9c78c24920a06..61c663c7bfc9cf20b3b40dbb8aa4f621fe1d8ea8 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -572,6 +572,7 @@ enum mlx5_ib_cq_pr_flags {
 struct mlx5_ib_cq {
 	struct ib_cq		ibcq;
 	struct mlx5_core_cq	mcq;
+	struct mlx5_core_dev	*mdev;
 	struct mlx5_ib_cq_buf	buf;
 	struct mlx5_db		db;
 
@@ -1305,6 +1306,11 @@ static inline struct mlx5_core_dev *uctx_to_mdev(struct mlx5_ib_ucontext *uctx)
 	return to_dev(uctx->ibucontext.device)->mdev;
 }
 
+static inline struct mlx5_core_dev *cq_to_mdev(struct mlx5_ib_cq *cq)
+{
+	return cq->mdev;
+}
+
 static inline struct mlx5_ib_mw *to_mmw(struct ib_mw *ibmw)
 {
 	return container_of(ibmw, struct mlx5_ib_mw, ibmw);
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 1135e710e339818aaa15f1077874561745ca6305..01babb9a0003abe2520200fcec2e9eb9224516e7 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5878,7 +5878,7 @@ static void handle_drain_completion(struct ib_cq *cq,
 				    struct mlx5_ib_drain_cqe *sdrain,
 				    struct mlx5_ib_dev *dev)
 {
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = cq_to_mdev(to_mcq(cq));
 
 	if (cq->poll_ctx == IB_POLL_DIRECT) {
 		while (wait_for_completion_timeout(&sdrain->done, HZ / 10) <= 0)
diff --git a/drivers/infiniband/hw/mlx5/restrack.c b/drivers/infiniband/hw/mlx5/restrack.c
index 866252cdce52452968519c8e785068a27cd40a34..f38fe7f694bae29bf23b15dddc46aa541545f761 100644
--- a/drivers/infiniband/hw/mlx5/restrack.c
+++ b/drivers/infiniband/hw/mlx5/restrack.c
@@ -56,7 +56,7 @@ static int dump_rsc(struct mlx5_core_dev *mdev, enum mlx5_sgmt_type type,
 	return err;
 }
 
-static int fill_res_raw(struct sk_buff *msg, struct mlx5_ib_dev *dev,
+static int fill_res_raw(struct sk_buff *msg, struct mlx5_core_dev *mdev,
 			enum mlx5_sgmt_type type, u32 key)
 {
 	int len = 0;
@@ -67,7 +67,7 @@ static int fill_res_raw(struct sk_buff *msg, struct mlx5_ib_dev *dev,
 	if (!data)
 		return -ENOMEM;
 
-	err = dump_rsc(dev->mdev, type, key, data, &len);
+	err = dump_rsc(mdev, type, key, data, &len);
 	if (err)
 		goto out;
 
@@ -124,7 +124,7 @@ static int fill_res_mr_entry_raw(struct sk_buff *msg, struct ib_mr *ibmr)
 {
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
 
-	return fill_res_raw(msg, mr_to_dev(mr), MLX5_SGMT_TYPE_PRM_QUERY_MKEY,
+	return fill_res_raw(msg, mr_to_mdev(mr), MLX5_SGMT_TYPE_PRM_QUERY_MKEY,
 			    mlx5_mkey_to_idx(mr->mmkey.key));
 }
 
@@ -158,10 +158,10 @@ static int fill_res_mr_entry(struct sk_buff *msg, struct ib_mr *ibmr)
 
 static int fill_res_cq_entry_raw(struct sk_buff *msg, struct ib_cq *ibcq)
 {
-	struct mlx5_ib_dev *dev = to_dev(ibcq->device);
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
 
-	return fill_res_raw(msg, dev, MLX5_SGMT_TYPE_PRM_QUERY_CQ, cq->mcq.cqn);
+	return fill_res_raw(msg, cq_to_mdev(cq), MLX5_SGMT_TYPE_PRM_QUERY_CQ,
+			    cq->mcq.cqn);
 }
 
 static int fill_res_qp_entry(struct sk_buff *msg, struct ib_qp *ibqp)
@@ -191,9 +191,7 @@ static int fill_res_qp_entry(struct sk_buff *msg, struct ib_qp *ibqp)
 
 static int fill_res_qp_entry_raw(struct sk_buff *msg, struct ib_qp *ibqp)
 {
-	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
-
-	return fill_res_raw(msg, dev, MLX5_SGMT_TYPE_PRM_QUERY_QP,
+	return fill_res_raw(msg, qp_to_mdev(ibqp), MLX5_SGMT_TYPE_PRM_QUERY_QP,
 			    ibqp->qp_num);
 }
 

-- 
2.49.0

