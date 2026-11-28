Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795870919;
	b=rcsJr6tTp3uGIMhtqmCPDa90E8HlMJvkWzv1iSEcEcEOaKjbXT0rksoydL+REFZmJU3g
	 yx9DDXJT5gLcP1VU90aVhkJ29+i3NCz/QbHHASuEBqaC3391m9EvjFWGD6C/11tRDBjD9
	 mmDiifFmgfhxsQ+A7Jgqwcs7OjcB7foRflVRvVa7m+lytoH/HgknvD3k7wHJiagY3QlsD
	 xDEsWbRf/lGhYpGWdEWmI+ptnPO1D30rNY3K3BY5K2Ws4wJvnaQCNt85WrOilk8EbmepY
	 uQrWTawbhFpGO0gZYBdzk3eMHudutDTRQ16rf5PNXG4cGvVgXmsMWZgk5L2BWMZJovA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795870919;
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
	bh=OVo5fhiPLXV5Sx5QjoPohcoGYRHMSrccxhsGGAArAdM=;
	b=Gpu2OjspUWaGlZeyrkHwvpOBIaPzDf1tjJ4Ol5Sqqdb5mP4UIHOmYTqfr239kJMpGJeQ
	 uq5+1FJdte3A+YupdxJvdUcXdVo+hLM7DjHwh65dL8mcAXA4Ogr0XXZvt40AbRkxKlZcs
	 4gpvR28mAHH+zcPbIrMEHWQfgxHE+Df1RKid3wgQAOu1bAThILc3k+/X7NnuH+eUwWHJ7
	 AvxNdWMsluFM6LZSmTmRoeqQz23BV9jj5tJYxhHFzAYgBXW7Rr22OBjH1rF/H4i6UxfBR
	 nM9JE9PG9y+9gCQEmFBEZcsJaIn+CznNdBFJYxawuiGQCEsfM2Aq4eVF22nCL4KRBPw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tYvP+zxU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.42
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012042.outbound.protection.outlook.com [40.93.195.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95A1606A336;
	Sat, 28 Nov 2026 13:01:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E95A1606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tYvP+zxU
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XEoraY0ZiGIwXDfppSG21uTAoEZ5q1l6nwajw229cY6Y8HIbM5UVkkaql3naamwE3Qih4XoDSe9UnJHiAP4NsFTx0R+0gJxm/8Z5d9IeiMbqqZWLxcoHnRCeoCGXnwxFmMNYa6DLofJsjFB/g8aGMrh0vu5Gi9vhhIIDTMYGrv0N+YwB+nwL8fIkZyr1yzUriebgQJEd1OOtm3NHd5UNEDd9Sue2uMCq0dLrUfHM1S2DNJCSs8Ibn9RKSegCrTY8I6ZqbgQmq3IxnHfd64Hou/MIcop1+1UUv5Y+ld5Vr4nQQR1AiJDhst2Ce2fbIuwiMcjg9HYPK6OwJ9XISbKsUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVo5fhiPLXV5Sx5QjoPohcoGYRHMSrccxhsGGAArAdM=;
 b=ggtLNcf/hgWmJWQeuGTnRMaMmazkzU0dn2bSR7llwLlVKQFourdIPhFepHkUilq/ttvYXbtzEyDlATBllnWD0/QU+N2tWqEfRRZSpiRBrKLMEcsrf3TF/0cZzDylJyunYYWW8z8rUYBcsOoTjvVBwv+XA8B23r5d3yiemqig0we5hkPTlgmIbtoORBHmHNA7KK7dKpdctHwhylDt7yqmh+m64hu3Y0oFxWYeq97NHBs2o/a6bxmfyONjMGPfWBErgX2Xs4mtDrhHRPq/ebeNgBtab7Y2cLbwKqWl0+j5uTXfCS29a2XO/SIX/xKz+bzEyjtFBQLhj9MhFoBh7rtoVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVo5fhiPLXV5Sx5QjoPohcoGYRHMSrccxhsGGAArAdM=;
 b=tYvP+zxUIQxAbLajnCSrkZ3nT0WnOTdIJsyYNVFiyp81qctTomcKHxFoXEnjhhOKNt05nUMiN61NZJFasTjLaBFlR59T/f4N/Ke754Omx8dqcyHI5ff4jZR/8gqHFgfuPwUF4WEhni9boUpMn7ipDmIFuoszuTent+mdaSYBt1ZtkG6Did/T9+nQfwIDpn9omSF8RGWF7AZGpxjEPvYZuFi9IoxLNVfx5eyyLSWxOXiJv1jDSzs8n1w8UPjyYkVH9skbwuVjVokbb3/bXk2VJOIx9heu26VfzR+ZXaAg3aZMjw+Wk5iIctjM83DHZlHgiIPX7Ek7JigTJfG7j07i4A==
Received: from BN0PR04CA0078.namprd04.prod.outlook.com (2603:10b6:408:ea::23)
 by CY8PR12MB8241.namprd12.prod.outlook.com (2603:10b6:930:76::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Sat, 28 Nov
 2026 13:01:52 +0000
Received: from BN5PEPF0004698D.namprd02.prod.outlook.com
 (2603:10b6:408:ea:cafe::22) by BN0PR04CA0078.outlook.office365.com
 (2603:10b6:408:ea::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Sat,
 28 Nov 2026 13:01:52 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN5PEPF0004698D.mail.protection.outlook.com (10.167.245.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Sat, 28 Nov 2026 13:01:52 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:01:43 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sat, 28 Nov 2026 05:01:42 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sat, 28 Nov 2026 05:01:41 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sat, 28 Nov 2026 15:01:22 +0200
Subject: [PATCH rdma-next v2 09/11] RDMA/mlx5: Cache the CQ core device and
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
Message-ID: <20261128-mlx5-sd-prep-v2-9-751878123711@nvidia.com>
References: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
In-Reply-To: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Akiva Goldberger <agoldberger@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795870878; l=15709;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=BGEZSk7Ue3KDmou2oAmIoyZ1rt7R152iPXjbekuYMuA=;
 b=EUX1/9q4BPKKbOKoRR0zO4q0l/qDFgpS9ySu+UrS5jFPh+xImIAowRhFQd+KZa7b6hxIlGx8V
 A4HcJX8Yj2sCZ82WQDyPNRE2aCl/ywqRhaU7UHsOlwqJLXyyPjj9Lxo
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN5PEPF0004698D:EE_|CY8PR12MB8241:EE_
X-MS-Office365-Filtering-Correlation-Id: 88000bf5-cd50-475b-66e4-08df4d4fc5a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700016|23010399003|18002099003|22082099003|6133799003|261009223027099003|10067099003|261026140227099003|261026121527099003|261021121427099003|261028144727099003|261102123227099003|261021123027099003|261022105027099003|261022075727099003|11063799006|56012099006|260925021911599003|260925022911599003|260925021311599003;
X-Microsoft-Antispam-Message-Info:
	rPLOo4A45D9wIIC5ZxOuKyG32BvEp0VzL+e+zkz932h0ZE7/g+Or+mRWwHATFXW7qxn0byMXMEFt01YuR4t88kmbxKeLimbPWU840Mwfo+2UHSaHxp456OJpUBgVbWHmgOEF04N6lPqXpd6fJGP/y/6b5eWnTeezPQ0YfNJ3BCR6E3Zn1K9ytkrKBLzhxcitTvwIJ+8TZ/1/d2p1tE+DE0/fi0PaPfSWGdZZZwiJ9ozb8Nq9jrssz/oRs9AQBOXa1wJaYkVXs5TRdyXFXhWzC3yMsh+ZRWqwT/siX+trXxeD7nNb+DoYvGxZ8wbnDQhdh29mK+te9fqS02nlwARIBdVZNtsN9R4jx+stqG1BclTJPCtRg4LnUAfvG9hiqmxE2Z+Dae/RF9I2CujVqiU8k2Vlz0f4230G5yRS7QZ+o6kXejUyZc7MT/77jU4o7fXy0tFyHD/3sPVS0S1Ff9S9hN1Svb8WK+x9WH6iucOSJHwHZHWvstDMj1pdopNVsmOO1++eAt4ZEQM1Z2dvfLNyM9hWTXtVgbMf01FcI7lQnDcI0BnvIHDTquDYYCk7tmLbFPj/hr+3YYB44y2Fm1k6uBn5BER3Jdds6YZFVsXXP7Oon54K0RmvnRNfM7TXAPnUO+jCGtg9FeA3LZGAWp7du1+d/0v0HVUKlbaGgdaLqku9KkV5dIQQX6pV9CDEdNVtDLks95cS+D+I3ckRpquSrw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700016)(23010399003)(18002099003)(22082099003)(6133799003)(261009223027099003)(10067099003)(261026140227099003)(261026121527099003)(261021121427099003)(261028144727099003)(261102123227099003)(261021123027099003)(261022105027099003)(261022075727099003)(11063799006)(56012099006)(260925021911599003)(260925022911599003)(260925021311599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zKm8wjuiZZqfxbX5WN7/45QiFt4afaXODUzvaFwG2PFG1tCNO2qXMjh11PLu1l5dVQJ2yiv815nMFiPZjECXyMuf6VdlG3E7PjXZATtAhKQIGR/EFNv+PH2xeiii8pwjmSeZQb/wCdQLAHqLULUdXL5UZXYd7BQjxGxZHAsFpvye0AhHIMet7rMsHwyz53yg8RiXFG9EX9Uh0SWr5So1+bRMYyAwUUtPP1fyjtyXOQmGh+MHGp08ivs6UM1wd5XAe7jWegxX8z6KkjuBCVPpWiEX7A8vU/35z/4HVx60Nak55Eyd6piOT0vNa9EZe67n1ve0j9IGRBitbvVaQo2aV/9vEpcjKC5EARwGIRFnEFF5SoUj1d09pU5tnAT+QbB0bFktA2sd82fgkwMIDlxaBBVebIbKAeA+8/G5RhB8qCs7HJ0bQCcRc6o/ugIGr607
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2026 13:01:52.0914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88000bf5-cd50-475b-66e4-08df4d4fc5a9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN5PEPF0004698D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8241

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
 drivers/infiniband/hw/mlx5/cq.c       | 89 ++++++++++++++++++-----------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h  |  6 +++
 drivers/infiniband/hw/mlx5/qp.c       |  2 +-
 drivers/infiniband/hw/mlx5/restrack.c | 14 +++---
 4 files changed, 59 insertions(+), 52 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 6b9777e2622ea30abce1156bb4369668e07cc3c9..79a2ef1a767fb7d8db82070798b6598f217f644e 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -353,9 +353,9 @@ static void handle_atomics(struct mlx5_ib_qp *qp, struct mlx5_cqe64 *cqe64,
 	qp->sq.last_poll = tail;
 }
 
-static void free_cq_buf(struct mlx5_ib_dev *dev, struct mlx5_ib_cq_buf *buf)
+static void free_cq_buf(struct mlx5_core_dev *mdev, struct mlx5_ib_cq_buf *buf)
 {
-	mlx5_frag_buf_free(dev->mdev, &buf->frag_buf);
+	mlx5_frag_buf_free(mdev, &buf->frag_buf);
 }
 
 static void get_sig_err_item(struct mlx5_sig_err_cqe *cqe,
@@ -598,8 +598,7 @@ int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 {
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
 	struct mlx5_ib_qp *cur_qp = NULL;
-	struct mlx5_ib_dev *dev = to_dev(cq->ibcq.device);
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = cq_to_mdev(cq);
 	unsigned long flags;
 	int soft_polled = 0;
 	int npolled;
@@ -633,8 +632,8 @@ int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 
 int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 {
-	struct mlx5_core_dev *mdev = to_dev(ibcq->device)->mdev;
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
+	struct mlx5_core_dev *mdev = cq_to_mdev(cq);
 	void __iomem *uar_page = mdev->priv.bfreg.up->map;
 	unsigned long irq_flags;
 	int ret = 0;
@@ -655,7 +654,7 @@ int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 	return ret;
 }
 
-static int alloc_cq_frag_buf(struct mlx5_ib_dev *dev,
+static int alloc_cq_frag_buf(struct mlx5_core_dev *mdev,
 			     struct mlx5_ib_cq_buf *buf,
 			     int nent,
 			     int cqe_size)
@@ -665,10 +664,10 @@ static int alloc_cq_frag_buf(struct mlx5_ib_dev *dev,
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
 
@@ -686,7 +685,7 @@ enum {
 	MLX5_CQE_RES_FORMAT_CSUM_STRIDX = 3,
 };
 
-static int mini_cqe_res_format_to_hw(struct mlx5_ib_dev *dev, u8 format)
+static int mini_cqe_res_format_to_hw(struct mlx5_core_dev *mdev, u8 format)
 {
 	switch (format) {
 	case MLX5_IB_CQE_RES_FORMAT_HASH:
@@ -694,7 +693,7 @@ static int mini_cqe_res_format_to_hw(struct mlx5_ib_dev *dev, u8 format)
 	case MLX5_IB_CQE_RES_FORMAT_CSUM:
 		return MLX5_CQE_RES_FORMAT_CSUM;
 	case MLX5_IB_CQE_RES_FORMAT_CSUM_STRIDX:
-		if (MLX5_CAP_GEN(dev->mdev, mini_cqe_resp_stride_index))
+		if (MLX5_CAP_GEN(mdev, mini_cqe_resp_stride_index))
 			return MLX5_CQE_RES_FORMAT_CSUM_STRIDX;
 		return -EOPNOTSUPP;
 	default:
@@ -793,9 +792,9 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
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
@@ -803,7 +802,7 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 		}
 
 		mini_cqe_format =
-			mini_cqe_res_format_to_hw(dev,
+			mini_cqe_res_format_to_hw(cq_to_mdev(cq),
 						  ucmd.cqe_comp_res_format);
 		if (mini_cqe_format < 0) {
 			err = mini_cqe_format;
@@ -818,7 +817,7 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 
 	if (ucmd.flags & MLX5_IB_CREATE_CQ_FLAGS_CQE_128B_PAD) {
 		if (*cqe_size != 128 ||
-		    !MLX5_CAP_GEN(dev->mdev, cqe_128_always)) {
+		    !MLX5_CAP_GEN(cq_to_mdev(cq), cqe_128_always)) {
 			err = -EOPNOTSUPP;
 			mlx5_ib_warn(dev,
 				     "CQE padding is not supported for CQE size of %dB!\n",
@@ -868,7 +867,7 @@ static void init_cq_frag_buf(struct mlx5_ib_cq_buf *buf)
 	}
 }
 
-static int create_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
+static int create_cq_kernel(struct mlx5_ib_cq *cq,
 			    int entries, int cqe_size,
 			    u32 **cqb, int *index, int *inlen)
 {
@@ -876,7 +875,7 @@ static int create_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 	void *cqc;
 	int err;
 
-	err = mlx5_db_alloc(dev->mdev, &cq->db);
+	err = mlx5_db_alloc(cq_to_mdev(cq), &cq->db);
 	if (err)
 		return err;
 
@@ -884,7 +883,7 @@ static int create_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 	cq->mcq.arm_db     = cq->db.db + 1;
 	cq->mcq.cqe_sz = cqe_size;
 
-	err = alloc_cq_frag_buf(dev, &cq->buf, entries, cqe_size);
+	err = alloc_cq_frag_buf(cq_to_mdev(cq), &cq->buf, entries, cqe_size);
 	if (err)
 		goto err_db;
 
@@ -907,22 +906,22 @@ static int create_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
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
@@ -953,14 +952,16 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
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
@@ -976,7 +977,7 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 	if (err)
 		return err;
 
-	err = mlx5_comp_eqn_get(dev->mdev, vector, &eqn);
+	err = mlx5_comp_eqn_get(cq_to_mdev(cq), vector, &eqn);
 	if (err)
 		goto err_cqb;
 
@@ -997,7 +998,8 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 	cq->mcq.comp = mlx5_add_cq_to_tasklet;
 	cq->mcq.tasklet_ctx.comp = mlx5_ib_cq_comp;
 
-	err = mlx5_core_create_cq(dev->mdev, &cq->mcq, cqb, inlen, out, sizeof(out));
+	err = mlx5_core_create_cq(cq_to_mdev(cq), &cq->mcq, cqb, inlen, out,
+				  sizeof(out));
 	if (err)
 		goto err_cqb;
 
@@ -1015,7 +1017,7 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 	return 0;
 
 err_cmd:
-	mlx5_core_destroy_cq(dev->mdev, &cq->mcq);
+	mlx5_core_destroy_cq(cq_to_mdev(cq), &cq->mcq);
 
 err_cqb:
 	kvfree(cqb);
@@ -1041,11 +1043,13 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
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
@@ -1055,14 +1059,14 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
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
 
@@ -1080,7 +1084,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 
 	cq->mcq.comp = mlx5_ib_cq_comp;
 
-	err = mlx5_core_create_cq(dev->mdev, &cq->mcq, cqb, inlen, out,
+	err = mlx5_core_create_cq(cq_to_mdev(cq), &cq->mcq, cqb, inlen, out,
 				  sizeof(out));
 	if (err)
 		goto err_cqb;
@@ -1094,25 +1098,24 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 
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
@@ -1203,13 +1206,13 @@ int mlx5_ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period)
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
@@ -1266,16 +1269,16 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 	int inlen;
 	int cqe_size;
 
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
@@ -1330,7 +1333,7 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 	MLX5_SET(modify_cq_in, in, op_mod, MLX5_CQ_OPMOD_RESIZE);
 	MLX5_SET(modify_cq_in, in, cqn, cq->mcq.cqn);
 
-	err = mlx5_core_modify_cq(dev->mdev, &cq->mcq, in, inlen);
+	err = mlx5_core_modify_cq(cq_to_mdev(cq), &cq->mcq, in, inlen);
 	if (err)
 		goto ex_alloc;
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 76882a692994e2473a46893876244436d6f69a63..0ffd2ab5b5ade17c43fb7323381268edb5677b75 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -573,6 +573,7 @@ enum mlx5_ib_cq_pr_flags {
 struct mlx5_ib_cq {
 	struct ib_cq		ibcq;
 	struct mlx5_core_cq	mcq;
+	struct mlx5_core_dev	*mdev;
 	struct mlx5_ib_cq_buf	buf;
 	struct mlx5_db		db;
 
@@ -1320,6 +1321,11 @@ static inline struct mlx5_core_dev *uctx_to_mdev(struct mlx5_ib_ucontext *uctx)
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
index be0b3437eb86329edb66bb8fc6d0dfdd8c18f8dd..87fd27c9279f5df2ee612af1b4451b3eef920f49 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5874,7 +5874,7 @@ static void handle_drain_completion(struct ib_cq *cq,
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

