Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795873023;
	b=1fnz79kQ/uR2lVhM6sO1SEgZlKWO2rL05tDAfHX+ZqxkRXe+hySsXiqUppGZLHhEaqQI
	 j/rORzL70BpLTo60OJjgW/AoSXz1ovEp0uY4eGlA82bGYUoXzmwQwVqy0QMUjMMZ+pYsk
	 0vSRyaJVX56QZ60kl4nJVN7820bdzbYldS8By7nznaXJy8XaSEHStoumo34ecffxE9oqu
	 GNHn5dCGfmH/j1lhFvfrqUvScYt2DOnVNtj8SQQlkOO4Yckds/FtWoa/8e4ac4RKhkeFg
	 T/1v9gX7nbzXSfY9OUP/SvwAlwT+4hpMa0xOn2iCQIHGheV+HCGUU7CaERdYaZyUFzQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795873023;
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
	bh=gWlorwbRQs6u279nCmvABwpB5YBlyrOBpo1LfvhJLBA=;
	b=w4mxWQX9MnqcGlWzIPYdgbHq2rUAbcVWe5DVAVgY9WwM7S7QS8Ax6FATPL7H1GFHWkfU
	 FO7CIgbDt0QQ355iCVEmGpFsi7ehXEeqd1UuCQMH3R/YY05MA9bFYqZLaz/IyzzPbYCjt
	 CG02MGPJj4gD9x02l8yEzk4moR+5bAeRjkqEreOh1XHqOxmEPBw/o5glT+4VV46osd0/e
	 pk9mNinlrAv7D4qjiS/hG8E5VQbkMXjMeC1P9V65uHHKgOjY2K98EIdTPguHd2ZkUslip
	 OgqelnfmgOxY9MxgJ1dpZXgClTExnp8aR38NBan7quv8+zUSXLwMFibvrNWusEHAWNw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="K/G0xdfZ";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.44
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010044.outbound.protection.outlook.com [52.101.46.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A35E606A31C;
	Sat, 28 Nov 2026 13:37:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A35E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=K/G0xdfZ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vc1/d1+j0zEdCyvTtDwHjZv2TFha6qe0jXuC5gdttTwCfArXoldnxNzVsZvn+SMPj5BgdCoKiNAx4kyeN3jJMFnBRuXaJv/wFaCD0umeIKpGpIz1TOvpGCw3EjJR8aJBaEiLarFY2h1vEhJL9nD3A4PsWy85sLhAGlwpD1culingp0Jgya9Pu/2V71P5bD2ugRGDgUEk0VR1RUDwpKNea5uQspMLevvU+fLyx8gq/mWJMYVOwxsg9kK/mgun7WGvLruEzOv+SXu8gykCZgElZZEAqBb4bfeCQ7lUsktfxiUC6dOS02cb240HHIwBy6pKWhspkSRCkmxENrxDkYIuEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWlorwbRQs6u279nCmvABwpB5YBlyrOBpo1LfvhJLBA=;
 b=oeEn5W7sSMJMdARiAOgpcZKfCsW3fYpTwHedyp2VBWbWMxJSI4JyD/catJty95Idqu7ilCj/vRVwXkqKmKKfwSL9DEI9uwgANPhfIQLOc2MNlH6wr8rubuhw3Vbjd1TiBx9+sPppMDo5ArHGzZy1+PU1jWrZmipFtUzVRwZJT9HVxJdfRk1Wc69IVD2Mh4yTxVHBzb9Vllza4cQwj1sEL5Wib5due+Y6biNx88zWEJ3GdfM3GK7pbbZtX+SR2ug0orpE4FCeWigIkL/J5j/sZXKdhH/FgIxJrylv4+6LCSp6iNEIYKPdox+dSde7uKh3qPSuhfpEr7E77bBiS4Gmyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWlorwbRQs6u279nCmvABwpB5YBlyrOBpo1LfvhJLBA=;
 b=K/G0xdfZngGHUVZSqtmy+zsIK+wV5dSluSBmrr4ROrP6dc6JXcxU88z80CRdM+QOWYDS2P10eps6Y4KoITBQlPlqPnDtMmsLkfoRGQQUrUsXWOdlrn8rMgd989OQCrd/ZIV29lPk2JnPPEisiL9dhkltgVYgz5yRsCjQ0iOe6K/9Rr4GaHKeapIRXQ/QzymqaSrXi18RgFVWpcziUOUjAaGPu/0/qYq9RRl5dyuGZcAcK7+m04pb7Hza6MgzHnnZwt74KEJ46RM0FnR8OapwsflZ9gpSCT/mHzQEWdJlJTpXLRBHXox9WDajotJyo1dVaYxy4iQgOqlf+84JcuVB9g==
Received: from CH0PR03CA0190.namprd03.prod.outlook.com (2603:10b6:610:e4::15)
 by SJ0PR12MB7005.namprd12.prod.outlook.com (2603:10b6:a03:486::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.10; Sat, 28 Nov
 2026 13:36:54 +0000
Received: from DS4PEPF000001C4.namprd21.prod.outlook.com
 (2603:10b6:610:e4:cafe::62) by CH0PR03CA0190.outlook.office365.com
 (2603:10b6:610:e4::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Sat,
 28 Nov 2026 13:36:54 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS4PEPF000001C4.mail.protection.outlook.com (10.167.23.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Sat, 28 Nov 2026 13:36:53 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:36:44 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:36:43 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Sat, 28
 Nov 2026 05:36:40 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sat, 28 Nov 2026 15:36:27 +0200
Subject: [PATCH rdma-next 3/3] RDMA/mlx5: Try pinned revocable dmabuf
 import by default
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
Message-ID: <20261128-mlx5-pinned-revocable-dmabuf-v1-3-a4cde143a58e@nvidia.com>
References: <20261128-mlx5-pinned-revocable-dmabuf-v1-0-a4cde143a58e@nvidia.com>
In-Reply-To: <20261128-mlx5-pinned-revocable-dmabuf-v1-0-a4cde143a58e@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, "Sumit
 Semwal" <sumit.semwal@linaro.org>, =?utf-8?q?Christian_K=C3=B6nig?=
	<christian.koenig@amd.com>, Philipp Stanner <phasta@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linaro-mm-sig@lists.linaro.org>, Edward Srouji <edwards@nvidia.com>, "Yishai
 Hadas" <yishaih@nvidia.com>, Chiara Meiohas <cmeiohas@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795872988; l=10407;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=MMrYtnaYBmoi5+3i2hdHpK4e7Mmk3pIAsyRgsi6mdHM=;
 b=X518DKYi9GT/km5161gdGmxArjuNwy+pFwCeGS7PzGYc38psK2BNkSX+K4yuup13EeHnDUOD/
 EY7wAgrl8QDBN2N4hrC/9uTR6jpH+AhdNT4Gv2KyUPUkkDJn0BYAwRC
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PEPF000001C4:EE_|SJ0PR12MB7005:EE_
X-MS-Office365-Filtering-Correlation-Id: 48d59501-ec7a-4a6b-0671-08df4d54aa4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|7416014|23010399003|82310400026|10067099003|261102123227099003|56012099006|261026121527099003|261026140227099003|261022105027099003|261021121427099003|261028144727099003|261021123027099003|261102130727099003|5023799004|261009221727099003|261009223027099003|261009220027099003|261009221227099003|261009223327099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	WQTOyQaxEUY0R4QZDHC1eGnkLRvtEfL77L5Hvkr2rHIE01HUoFHqhiCLgmDos1s96cBU/VbVUx3crSL7CH9fY3VAJvXo+LqwFQQmlt3JcA/fEbuw2gsO5flbKMXEN73fmEO39Wc+Ag98Uz3zYlSqkSe8IjqLMsS/iKyx6gsziDvmMOdkYJ4PlA6nHtDFtgWWrXD1Q60I2uDOLDiStKpgoX/d14xx4bytEDbpyoDeDSCZ27Z+IJe1YkLsddpsW6ZlOliHA3gK3ppYwaZ2vBnK8EXPAJDYFoBU6JiCTIlZOx8czIrzXaZeFLlK2Pqbol/RltlGOtjk7mSIVubcbep7mBH5AyXdA7+C2dQE50gHMc5XF05tUejEvrmBDQ29s6UAvzci1kHLFc6cSPKmXzrAVt/bppRuWrIAKdpG+M0OZaVjN/zNsDKUP2+KdB8M0Jnz6n77WLwlgCQ6Xj2ycHaYNTwVxKOo6QTpHBgd0hSiD8FZZTY0Ctpq+h7oDiLQyUteefCgKD0NZCEcE5eepCU8R3GRXzH9aP4I7GYYBlXDQ9I7oJ089zR1NZBudfl0ttPCjRQT9wLoqSiBkALNJvCf+9NIspEXPjAic6ZK0g2NjCy2AMXsCgqoVLE+qYQ5wE6U/L4UUyhCzwz0cs9FwdY670S/R2o8dmf00ZLFsNm0jWePDcorE90vPTmIe7YdSAIcsuDoPYanoVKCFCj+hITIww==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(7416014)(23010399003)(82310400026)(10067099003)(261102123227099003)(56012099006)(261026121527099003)(261026140227099003)(261022105027099003)(261021121427099003)(261028144727099003)(261021123027099003)(261102130727099003)(5023799004)(261009221727099003)(261009223027099003)(261009220027099003)(261009221227099003)(261009223327099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JH2D6gI34frXPUwmeFX2BOev9mxJrXAYlaBbx810AKcQdIl9Ak2+CdI3jH3vUt9c/EUZW1dQX1nZFK3yuiSsxeAklWs4N8f/2xpCWVPFgUBionkJdREtVzi6HRJWQltCq6gZ2ddiD0A/5zHAUtjOo6o8dwlzGyL5tcRXhD253ZAKurKo253ks4ifUXVgWqYNp8iLk3p2GGr9HDM/bnYAqNhUlUuljtUYiUcU5HWfIw+QfABU4D5sr8CERxYT6ERqg+tp15B3gmnLvh8WHi5McGH8NDRFK8FG8wDATL0aRX6ItuzMklkkvk5B+FRipP4yaaPI/f5U1xMad6DVR+egM9eYTaysTMBGTnN2ltnYq3TVzo7OClXGiayAbYOredyonlBSBJqzA714jbq3kN9fF8fVX3EQCJ0H1KuiDxNtM74+2cqo7nfVz0YhsLpZiUM+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2026 13:36:53.8541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d59501-ec7a-4a6b-0671-08df4d54aa4f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS4PEPF000001C4.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7005

From: Yishai Hadas <yishaih@nvidia.com>

mlx5 imported dma-bufs assuming they needed to support being moved.
To support this, mkeys were sized for the worst case: dma-buf size /
PAGE_SIZE. Many exporters do not require movable support, making this
overkill, such as when applications register GPU memory as a dma-buf
for peer-to-peer DMA.

Try a pinned, revocable attach first instead. When the exporter
grants it, the buffer is guaranteed not to move, so the mkey can be
sized exactly. Otherwise, fall back to today's existing behavior,
unchanged. Only that fallback requires CONFIG_INFINIBAND_ON_DEMAND_PAGING.

A pinned revocable import is revoked permanently when the exporter
invalidates the buffer, e.g. VFIO on a memory-disable or a reset. Unlike
a movable import, the MR is not restored when the exporter restores
access, and userspace has to register it again.

On a revoke the mkey is disabled with a UMR, so the device stops
accessing the buffer. A revoke cannot run while the MR is being
registered, as the reservation lock is held until the mkey is enabled.

This follows the same approach irdma already uses for pinned
revocable dmabuf import, commit 4707bf5f6c86 ("RDMA/irdma: Add
support for revocable pinned dmabuf import")

Co-developed-by: Chiara Meiohas <cmeiohas@nvidia.com>
Signed-off-by: Chiara Meiohas <cmeiohas@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c | 143 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 126 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 4bd911e0596c676a8caa4165fca139db6852cbab..55e6d8656692e4d8a05f43bf2c5f5effa9d53c5f 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -430,7 +430,7 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 	struct mlx5_ib_mr *mr;
 	unsigned long page_size;
 
-	if (umem->is_dmabuf)
+	if (umem->is_dmabuf && !to_ib_umem_dmabuf(umem)->pinned)
 		page_size = mlx5_umem_dmabuf_default_pgsz(umem, iova);
 	else
 		page_size = mlx5_umem_mkc_find_best_pgsz(dev, umem, iova,
@@ -894,7 +894,8 @@ static const struct dma_buf_attach_ops mlx5_ib_dmabuf_attach_ops = {
 	.invalidate_mappings = mlx5_ib_dmabuf_invalidate_cb,
 };
 
-int mlx5_ib_dmabuf_mr_update_pas(struct mlx5_ib_mr *mr, u32 pdn, u32 flags)
+static int mlx5_ib_dmabuf_mr_update_pas_locked(struct mlx5_ib_mr *mr, u32 pdn,
+					       u32 flags)
 {
 	struct ib_umem_dmabuf *umem_dmabuf = to_ib_umem_dmabuf(mr->umem);
 	int access_mode = mr->data_direct ? MLX5_MKC_ACCESS_MODE_KSM :
@@ -904,12 +905,11 @@ int mlx5_ib_dmabuf_mr_update_pas(struct mlx5_ib_mr *mr, u32 pdn, u32 flags)
 	unsigned long page_size;
 	int err;
 
-	dma_resv_lock(umem_dmabuf->attach->dmabuf->resv, NULL);
+	dma_resv_assert_held(umem_dmabuf->attach->dmabuf->resv);
+
 	err = ib_umem_dmabuf_map_pages(umem_dmabuf);
-	if (err) {
-		dma_resv_unlock(umem_dmabuf->attach->dmabuf->resv);
+	if (err)
 		return err;
-	}
 
 	page_size = mlx5_umem_dmabuf_find_best_pgsz(umem_dmabuf, access_mode);
 	if (!page_size) {
@@ -930,7 +930,6 @@ int mlx5_ib_dmabuf_mr_update_pas(struct mlx5_ib_mr *mr, u32 pdn, u32 flags)
 							      pdn);
 		}
 	}
-	dma_resv_unlock(umem_dmabuf->attach->dmabuf->resv);
 
 	if (err) {
 		mr->page_shift = old_page_shift;
@@ -941,7 +940,19 @@ int mlx5_ib_dmabuf_mr_update_pas(struct mlx5_ib_mr *mr, u32 pdn, u32 flags)
 	return 0;
 }
 
-static int mlx5_ib_init_dmabuf_mr(struct mlx5_ib_mr *mr, struct ib_pd *pd)
+int mlx5_ib_dmabuf_mr_update_pas(struct mlx5_ib_mr *mr, u32 pdn, u32 flags)
+{
+	struct dma_resv *resv = to_ib_umem_dmabuf(mr->umem)->attach->dmabuf->resv;
+	int err;
+
+	dma_resv_lock(resv, NULL);
+	err = mlx5_ib_dmabuf_mr_update_pas_locked(mr, pdn, flags);
+	dma_resv_unlock(resv);
+	return err;
+}
+
+static int mlx5_ib_init_dmabuf_mr_locked(struct mlx5_ib_mr *mr,
+					 struct ib_pd *pd)
 {
 	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
 	u32 pdn;
@@ -951,7 +962,48 @@ static int mlx5_ib_init_dmabuf_mr(struct mlx5_ib_mr *mr, struct ib_pd *pd)
 	else
 		pdn = to_mpd(pd)->pdn;
 
-	return mlx5_ib_dmabuf_mr_update_pas(mr, pdn, MLX5_IB_UPD_XLT_ENABLE);
+	return mlx5_ib_dmabuf_mr_update_pas_locked(mr, pdn,
+						   MLX5_IB_UPD_XLT_ENABLE);
+}
+
+static int mlx5_ib_init_dmabuf_mr(struct mlx5_ib_mr *mr, struct ib_pd *pd)
+{
+	struct dma_resv *resv = to_ib_umem_dmabuf(mr->umem)->attach->dmabuf->resv;
+	int err;
+
+	dma_resv_lock(resv, NULL);
+	err = mlx5_ib_init_dmabuf_mr_locked(mr, pd);
+	dma_resv_unlock(resv);
+	return err;
+}
+
+/*
+ * Revoke callback of a pinned revocable dmabuf MR. It runs under the dmabuf
+ * reservation lock, either on an exporter invalidation or from
+ * ib_umem_release() at deregistration. It returns void, and the caller
+ * unconditionally unmaps and unpins the buffer once it returns, so it
+ * disables the mkey with a UMR to stop the device from accessing it.
+ */
+static void mlx5_ib_dmabuf_pinned_revoke(void *priv)
+{
+	struct mlx5_ib_mr *mr = priv;
+	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
+	int err;
+
+	dma_resv_assert_held(to_ib_umem_dmabuf(mr->umem)->attach->dmabuf->resv);
+
+	err = mlx5r_umr_revoke_mr(mr);
+	if (err) {
+		mlx5_ib_warn(dev, "dmabuf mr revoke failed to disable mkey 0x%x, err %d\n",
+			     mr->mmkey.key, err);
+		return;
+	}
+
+	/*
+	 * Mark the key as disabled. If the UMR failed, deregistration destroys
+	 * the key instead of returning it to the pool.
+	 */
+	mr->revoked = true;
 }
 
 static struct ib_mr *
@@ -964,6 +1016,7 @@ reg_user_mr_dmabuf(struct ib_pd *pd, struct device *dma_device,
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct mlx5_ib_mr *mr = NULL;
 	struct ib_umem_dmabuf *umem_dmabuf;
+	bool revocable_and_pinned = false;
 	u16 st_index = MLX5_MKC_PCIE_TPH_NO_STEERING_TAG_INDEX;
 	u8 ph = MLX5_IB_NO_PH;
 	int err;
@@ -972,12 +1025,23 @@ reg_user_mr_dmabuf(struct ib_pd *pd, struct device *dma_device,
 	if (err)
 		return ERR_PTR(err);
 
-	if (!pinned_mode)
-		umem_dmabuf = ib_umem_dmabuf_get(&dev->ib_dev,
-						 offset, length, fd,
-						 access_flags,
-						 &mlx5_ib_dmabuf_attach_ops);
-	else if (dma_device)
+	if (!pinned_mode) {
+		umem_dmabuf = ib_umem_dmabuf_get_pinned_revocable_and_lock(
+				&dev->ib_dev, offset, length, fd, access_flags);
+		if (!IS_ERR(umem_dmabuf)) {
+			revocable_and_pinned = true;
+		} else {
+			if (!IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
+				mlx5_ib_dbg(dev,
+					   "dmabuf pin failed (%pe) and ODP is not supported\n",
+					   umem_dmabuf);
+				return ERR_CAST(umem_dmabuf);
+			}
+			umem_dmabuf = ib_umem_dmabuf_get(
+				&dev->ib_dev, offset, length, fd,
+				access_flags, &mlx5_ib_dmabuf_attach_ops);
+		}
+	} else if (dma_device)
 		umem_dmabuf = ib_umem_dmabuf_get_pinned_with_dma_device(&dev->ib_dev,
 				dma_device, offset, length,
 				fd, access_flags);
@@ -1002,6 +1066,8 @@ reg_user_mr_dmabuf(struct ib_pd *pd, struct device *dma_device,
 				access_flags, access_mode,
 				st_index, ph);
 	if (IS_ERR(mr)) {
+		if (revocable_and_pinned)
+			ib_umem_dmabuf_revoke_unlock(umem_dmabuf);
 		ib_umem_release(&umem_dmabuf->umem);
 		return ERR_CAST(mr);
 	}
@@ -1010,6 +1076,23 @@ reg_user_mr_dmabuf(struct ib_pd *pd, struct device *dma_device,
 
 	atomic_add(ib_umem_num_pages(mr->umem), &dev->mdev->priv.reg_pages);
 	umem_dmabuf->private = mr;
+	if (revocable_and_pinned) {
+		/*
+		 * Keep the reservation lock until the key is enabled, so an
+		 * exporter revoke cannot run on a half registered MR. A revoke
+		 * that is pending runs once we unlock, on a complete MR.
+		 */
+		err = mlx5_ib_init_dmabuf_mr_locked(mr, pd);
+		if (!err)
+			ib_umem_dmabuf_set_revoke_locked(umem_dmabuf,
+							 mlx5_ib_dmabuf_pinned_revoke,
+							 mr);
+		ib_umem_dmabuf_revoke_unlock(umem_dmabuf);
+		if (err)
+			goto err_dereg_mr;
+		return &mr->ibmr;
+	}
+
 	if (!pinned_mode) {
 		err = mlx5r_odp_create_eq(dev, &dev->odp_pf_eq);
 		if (err)
@@ -1096,8 +1179,7 @@ struct ib_mr *mlx5_ib_reg_user_mr_dmabuf(struct ib_pd *pd, u64 offset,
 	int mlx5_access_flags = 0;
 	int err;
 
-	if (!IS_ENABLED(CONFIG_INFINIBAND_USER_MEM) ||
-	    !IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING))
+	if (!IS_ENABLED(CONFIG_INFINIBAND_USER_MEM))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	if (uverbs_attr_is_valid(attrs, MLX5_IB_ATTR_REG_DMABUF_MR_ACCESS_FLAGS)) {
@@ -1453,6 +1535,12 @@ static int mlx5_umr_revoke_mr_with_lock(struct mlx5_ib_mr *mr)
 	return ret;
 }
 
+static bool is_pinned_revoke_dmabuf_mr(struct mlx5_ib_mr *mr)
+{
+	return mr->umem && mr->umem->is_dmabuf &&
+	       to_ib_umem_dmabuf(mr->umem)->pinned_revoke;
+}
+
 static int mlx5r_handle_mkey_cleanup(struct mlx5_ib_mr *mr)
 {
 	bool is_odp_dma_buf = is_dmabuf_mr(mr) &&
@@ -1461,6 +1549,23 @@ static int mlx5r_handle_mkey_cleanup(struct mlx5_ib_mr *mr)
 	bool is_odp = is_odp_mr(mr);
 	int ret;
 
+	if (is_pinned_revoke_dmabuf_mr(mr)) {
+		/*
+		 * Run the revoke callback if the exporter did not. A key revoked
+		 * by a UMR returns to the pool once the umem is released,
+		 * otherwise destroy it here. ib_umem_dmabuf_revoke() is
+		 * idempotent, so the release later does nothing more.
+		 */
+		ib_umem_dmabuf_revoke(to_ib_umem_dmabuf(mr->umem));
+		if (mr->revoked && mr->ibmr.frmr.pool)
+			return 0;
+
+		ret = destroy_mkey(dev, mr);
+		if (!ret && mr->ibmr.frmr.pool)
+			ib_frmr_pool_drop(&mr->ibmr);
+		return ret;
+	}
+
 	if (mr->ibmr.frmr.pool) {
 		if (!mlx5_umr_revoke_mr_with_lock(mr)) {
 			ib_frmr_pool_push(mr->ibmr.device, &mr->ibmr);
@@ -1545,6 +1650,7 @@ static int __mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 
 	if (mr->umem) {
 		bool is_odp = is_odp_mr(mr);
+		bool is_pinned_revoke = is_pinned_revoke_dmabuf_mr(mr);
 
 		if (!is_odp)
 			atomic_sub(ib_umem_num_pages(mr->umem),
@@ -1552,6 +1658,9 @@ static int __mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 		ib_umem_release(mr->umem);
 		if (is_odp)
 			mlx5_ib_free_odp_mr(mr);
+		/* Push after the release, mr->umem is not touched again */
+		if (is_pinned_revoke && mr->revoked && mr->ibmr.frmr.pool)
+			ib_frmr_pool_push(mr->ibmr.device, &mr->ibmr);
 	}
 
 	if (!mr->ibmr.frmr.pool)

-- 
2.49.0

