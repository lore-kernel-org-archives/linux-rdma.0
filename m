Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795873015;
	b=sCx67GYOMveRw/Ql+yfxU9F/1fFAQ3tnigPD3I2kjTHejmEHaV9f+A2exqIznRFMsHp9
	 REmVpknUOgBEL8kCmYOd5gF00BVs/zvXqsdh+mMRYc1fWfY9C8LMJFnpmhCYmKJ5couZB
	 11oUDdTqlDGtT43saP7qRKN7Jzr1x1dSYLaJJ9TAiwfzRZo72St1095awpHtbQfZMOa56
	 i9+GkC3w5VK2P3U/Mx1IJ1sMPXd1axVErHZp4RQV+ncEIJb7CGKcF5m+47OyMikQPeqi+
	 SZY0S7Jvjc6r4Wx84iu69/r+a0TE8AEgZyw99IFMVymdNupJ6lEXLRCdifLOlZSiIzg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795873015;
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
	bh=XapzJARuGMXt6Py4hD3iuG6EIiEOL8nSrIgz+F7VJe0=;
	b=eUgeEA2yYsnPTRCyKXdFkkiChj5KXEQLJPQbpvwJQIkSGCrOcVwARhAJ4zJxXJw5VfHg
	 p8dwWKP9G/HCdKZ36ydpyLAZ4daEH1n6W1pz5Dzmgu53xdiR9xni/xQxVbpzYpBIZCj6T
	 BsroxGs9BnUhqREZ7XqLFFiSvNPv3Xc7KGpdZp7mK9ylMmC9FXNBElvOAyhGpkX3FqaSM
	 kmPbPE/6imq9BJ5wJrCtMhW0Z55oImeAuSJgV6vF7HuNhXh0TfYHk8WTXQ2Zh6WugJpj+
	 CUIDP5mVtwH2S6v1DN6bRcwzO4YH7N6QnijM3Dlf75MryBJF76s/k2yPvEGQbsvNtVw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="ab/SnxTd";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.6
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010006.outbound.protection.outlook.com [40.93.198.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C2A606A327;
	Sat, 28 Nov 2026 13:36:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54C2A606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ab/SnxTd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L2UwnGK8wR0dsSXr01i9CK4Ay9i6fBBXUTv1Zfx0dFJK+VZXAXCtfvdR+cu0u/Yl+kWsypaRd7ui8+O6dig3p2fh/zbd2NURTCOlxjrF5vs1a/gAMYGmRDeuCzcdODqdSZPbgD4cuGEsfO+PqurF813XJe+l7fwYe1P2vCX1pWY4kSFX1Uteu6idSCG9/uhyp5sKrItW+O/DF/gH0pqBm2vtipeXoxNIBsicrlF8lN7GgAXCEVyqFvvjSmbeiQyZxDTBWVcamPnjiw58Gt/iN6WGpyD/1j5bgL33DqSw5U82iy3e8eP763yuDQOCngLBhuT7TgJjKGIjO6rK+hHcBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XapzJARuGMXt6Py4hD3iuG6EIiEOL8nSrIgz+F7VJe0=;
 b=HU53moeU0LlB+cAIQHl+15GeBbdWlvSO0M2q3megLdGCH+Lvl+Tqkuo8AtQUl0sNqXwDmMQA4HkZkXucuHMpLnx2n3HTKv0ZkL+0+7ipEUATWF2TF2l5a2HqHaRqtw4FUiczppLxF0eQFfi5dzFHrs0FRwgWX7Oc/4eXU7GhJZsEznceRMtZcMmx7Lq79rKYnvPzWvcxl73+flV8ll3IalmlemaA1gQxznuZrPuy1XEubsq6p+g956volDLfoW1LNDItPH75X2kwLyBvPCz1h1yGav0t2sZ6u6ufoExo4auro76lKTE9Uv8a6xFFRFqd2Tyw2YeVBCQTEPM6ybK2xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XapzJARuGMXt6Py4hD3iuG6EIiEOL8nSrIgz+F7VJe0=;
 b=ab/SnxTdYwDX0WFKqv+sJIE9WfyWpvOJNQvQ9fHOM+UvO/Oj7e/WkewlTY/eu+KynUg3VodUT5Kiu7W+tWLHDFy4txN5zvcg9ARIdnRrn/1mtPzvB7W6isjEINKOOBuKAYcAphtUThBUc4zMzHnWBw8DhSE2F1SjwD/B3UjHS6cofGe8jAl6UZDsnfCvH3Id+VynTD9X4A4Ar5Un4xKWh5WCRwmdC1Aqo2QXwAyUOfwnLY/dJUj1SbOV2553qclmGyd+tLuhuYQiesBEwrgTyItoNfKwuI1B0ol23H6tE0j5cRASjEmPE45lDbqhtELrUFtHSrke2iqdL69DrmRJBQ==
Received: from CH2PR03CA0001.namprd03.prod.outlook.com (2603:10b6:610:59::11)
 by IA4PR12MB233949.namprd12.prod.outlook.com (2603:10b6:207:150::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.9; Sat, 28 Nov
 2026 13:36:50 +0000
Received: from LV8PEPF0000005E.namprd02.prod.outlook.com
 (2603:10b6:610:59:cafe::a7) by CH2PR03CA0001.outlook.office365.com
 (2603:10b6:610:59::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Sat,
 28 Nov 2026 13:36:50 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 LV8PEPF0000005E.mail.protection.outlook.com (10.167.245.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Sat, 28 Nov 2026 13:36:50 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:36:40 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:36:39 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Sat, 28
 Nov 2026 05:36:36 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sat, 28 Nov 2026 15:36:26 +0200
Subject: [PATCH rdma-next 2/3] RDMA/mlx5: Move dma-buf MR init out of
 ODP-only compilation
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
Message-ID: <20261128-mlx5-pinned-revocable-dmabuf-v1-2-a4cde143a58e@nvidia.com>
References: <20261128-mlx5-pinned-revocable-dmabuf-v1-0-a4cde143a58e@nvidia.com>
In-Reply-To: <20261128-mlx5-pinned-revocable-dmabuf-v1-0-a4cde143a58e@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, "Sumit
 Semwal" <sumit.semwal@linaro.org>, =?utf-8?q?Christian_K=C3=B6nig?=
	<christian.koenig@amd.com>, Philipp Stanner <phasta@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linaro-mm-sig@lists.linaro.org>, Edward Srouji <edwards@nvidia.com>, "Chiara
 Meiohas" <cmeiohas@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795872988; l=6720;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=vFKkHisc3c8WcLfwReHJD/HKxnLuF8W6k8tmVC9/eMU=;
 b=YHl7+jbceuURwT2LOQMXBPwB6T6onF6uWa/csAUjJSq3t0Osaj1GIUSRxbWKSIKUr4CYpSwte
 qKvkTA6Qoo/D+T7p6AtZe2H2BZ9PhHM1Eq3pC2RKa4PdaCHDVbau5Hg
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PEPF0000005E:EE_|IA4PR12MB233949:EE_
X-MS-Office365-Filtering-Correlation-Id: 604b921b-7d02-4637-a300-08df4d54a864
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|7416014|23010399003|82310400026|56012099006|10067099003|261026140227099003|261028144727099003|261022105027099003|261021123027099003|261021121427099003|261102123227099003|261009221227099003|261009223327099003|261009223027099003|261009221727099003|261009220027099003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	0regXHslaSe0MDU+0iA1YgCiTmoAsbnhXe2BEvP8v79ZFzFb1csExqyNy8bUC5WDXQMC75fYHBUVnJ6GbtI9umOw0/i3K6IOZwpoyeCVl48NMgZ+pqVYZqgtiMcjsbGEXoIMiTfWgSBxfLNd2BAtDufS0NtPOJH5RVYTAp8tFOMwL/u7ozvlWeZkgNYq6yGIqB4DtS8887kFBKEhRX90ewPx+31Oh24ug0Gv+oRvd180Kwe7CN3Y90Qo0iPac1CQprcyC3qVwDGOCA8prOGhCQqYYCHlffL0S9XnfD46Q2Q52NeGfZrrO9bZSewUd8w1NRbHx15VA8Cxkc9gLsTckl5gdu8n8Tz0Ci/GiPLQSIr2Q6ONRMEFLEj/GUkByEazw1sLWUY5IrD6SPnpw7Vvx1KSmo9MPG8/yVjp7kpL5uCaczTNYiEyxDZkPI7U8qPHBiHg34FZKY5NUNdqhxf7ZAG30zQvexysoMpSfWy4naKJFm7BDRpJPh0Te9byNUa1UBCtWNYgDBMHs7S9t19h6d/lhKXXPAD5X1O9SrvqiM8WST0RPkUIiWOR+Y4lSRW1mod69BBADXW+OFpVbDs7MwBdbmnl6KNNLQ+SROvbgiyDMnAXBHvyi8lLSwEDRuULS28DfsceDSnZboYzJxZcTw1DtnhuHL5T+Tm1LqlqKxna1FogBcQmsc0R9IqrFXbi+ld1TjZ3odjf7hnnTb3tPw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(7416014)(23010399003)(82310400026)(56012099006)(10067099003)(261026140227099003)(261028144727099003)(261022105027099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009221227099003)(261009223327099003)(261009223027099003)(261009221727099003)(261009220027099003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	X2xy1ycS21hIIbpjM6ylglZpJQGl95mFii+zjG7Xhd6CRvqrcGkQ5WkaxXpHan/Kqm4zceiOow59rFFZ7ZlP/w2SRj28YVZngESkKa1iNdMLPv5NaigFK7kzQs3CwS6/tuPRkglY0T3wuyHXdbqhyFXxTHf81zuIKZ8jiXNcrfJGlGRiXZD4mqDHVviZqv4rrQYzoyio1sdbBevloOECRH09OTomq1aenc+Lu7ISLYLNZlNqHKSzD3GG5lNP97uzd8pmoNX3NC1lAHWipaSjQISBCRY9DRVVbrahnIUirVssul0YNfr+GQH42FGnsKiOnDmEVcE1ohIgsJs/BMgiLyqa5DAmBPZFNfQL38+UCzo+IayOtus0VsK0EFxmoYEq0FERt6KU/88ZAJ1gfZQtfYfTJEmMgrRym2RH4g1EXNOSKT4uf14yUBSjQgdd1bSb
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2026 13:36:50.5631
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 604b921b-7d02-4637-a300-08df4d54a864
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000005E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB233949

From: Chiara Meiohas <cmeiohas@nvidia.com>

dma-buf MR creation currently lives in odp.c, which is only built
under CONFIG_INFINIBAND_ON_DEMAND_PAGING, even though it has no actual
dependency on ODP. Move it into mr.c, which is always built.

This is a preparatory patch for the next commit, with no behavioral
change of its own.

Signed-off-by: Chiara Meiohas <cmeiohas@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  7 ++---
 drivers/infiniband/hw/mlx5/mr.c      | 60 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/odp.c     | 58 ++--------------------------------
 3 files changed, 64 insertions(+), 61 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b2d4db344071bcc068a767f94ffb64b80df9499d..3b3ba6cb21fdd34250a7ba4f1d11cc06d5b59fbd 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1415,7 +1415,6 @@ int mlx5_ib_advise_mr_prefetch(struct ib_pd *pd,
 			       enum ib_uverbs_advise_mr_advice advice,
 			       u32 flags, struct ib_sge *sg_list, u32 num_sge);
 int mlx5_ib_init_odp_mr(struct mlx5_ib_mr *mr, struct ib_pd *pd);
-int mlx5_ib_init_dmabuf_mr(struct mlx5_ib_mr *mr, struct ib_pd *pd);
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 static inline int mlx5_ib_odp_init_one(struct mlx5_ib_dev *ibdev) { return 0; }
 static inline int mlx5r_odp_create_eq(struct mlx5_ib_dev *dev,
@@ -1447,12 +1446,10 @@ static inline int mlx5_ib_init_odp_mr(struct mlx5_ib_mr *mr, struct ib_pd *pd)
 {
 	return -EOPNOTSUPP;
 }
-static inline int mlx5_ib_init_dmabuf_mr(struct mlx5_ib_mr *mr, struct ib_pd *pd)
-{
-	return -EOPNOTSUPP;
-}
 #endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 
+int mlx5_ib_dmabuf_mr_update_pas(struct mlx5_ib_mr *mr, u32 pdn, u32 flags);
+
 extern const struct mmu_interval_notifier_ops mlx5_mn_ops;
 
 /* Needed for rep profile */
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 7952d80349dc6c086758472da762f320ca8e5df8..4bd911e0596c676a8caa4165fca139db6852cbab 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -894,6 +894,66 @@ static const struct dma_buf_attach_ops mlx5_ib_dmabuf_attach_ops = {
 	.invalidate_mappings = mlx5_ib_dmabuf_invalidate_cb,
 };
 
+int mlx5_ib_dmabuf_mr_update_pas(struct mlx5_ib_mr *mr, u32 pdn, u32 flags)
+{
+	struct ib_umem_dmabuf *umem_dmabuf = to_ib_umem_dmabuf(mr->umem);
+	int access_mode = mr->data_direct ? MLX5_MKC_ACCESS_MODE_KSM :
+					    MLX5_MKC_ACCESS_MODE_MTT;
+	unsigned int old_page_shift = mr->page_shift;
+	unsigned int page_shift;
+	unsigned long page_size;
+	int err;
+
+	dma_resv_lock(umem_dmabuf->attach->dmabuf->resv, NULL);
+	err = ib_umem_dmabuf_map_pages(umem_dmabuf);
+	if (err) {
+		dma_resv_unlock(umem_dmabuf->attach->dmabuf->resv);
+		return err;
+	}
+
+	page_size = mlx5_umem_dmabuf_find_best_pgsz(umem_dmabuf, access_mode);
+	if (!page_size) {
+		ib_umem_dmabuf_unmap_pages(umem_dmabuf);
+		err = -EINVAL;
+	} else {
+		page_shift = order_base_2(page_size);
+		if (page_shift != mr->page_shift && mr->dmabuf_faulted) {
+			err = mlx5r_umr_dmabuf_update_pgsz(mr, flags, pdn,
+							   page_shift);
+		} else {
+			mr->page_shift = page_shift;
+			if (mr->data_direct)
+				err = mlx5r_umr_update_data_direct_ksm_pas(
+					mr, flags);
+			else
+				err = mlx5r_umr_update_mr_pas(mr, flags,
+							      pdn);
+		}
+	}
+	dma_resv_unlock(umem_dmabuf->attach->dmabuf->resv);
+
+	if (err) {
+		mr->page_shift = old_page_shift;
+		return err;
+	}
+
+	mr->dmabuf_faulted = 1;
+	return 0;
+}
+
+static int mlx5_ib_init_dmabuf_mr(struct mlx5_ib_mr *mr, struct ib_pd *pd)
+{
+	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
+	u32 pdn;
+
+	if (mr->data_direct)
+		pdn = dev->mdev->data_direct->pdn;
+	else
+		pdn = to_mpd(pd)->pdn;
+
+	return mlx5_ib_dmabuf_mr_update_pas(mr, pdn, MLX5_IB_UPD_XLT_ENABLE);
+}
+
 static struct ib_mr *
 reg_user_mr_dmabuf(struct ib_pd *pd, struct device *dma_device,
 		   u64 offset, u64 length, u64 virt_addr,
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index b2643ff871a36a190293af2f6c4571d243818670..81c86f6145d0f509fa9964bf83f007e035cc86c6 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -840,52 +840,15 @@ static int pagefault_implicit_mr(struct mlx5_ib_mr *imr,
 static int pagefault_dmabuf_mr(struct mlx5_ib_mr *mr, size_t bcnt,
 			       u32 *bytes_mapped, u32 flags, u32 pdn)
 {
-	struct ib_umem_dmabuf *umem_dmabuf = to_ib_umem_dmabuf(mr->umem);
-	int access_mode = mr->data_direct ? MLX5_MKC_ACCESS_MODE_KSM :
-					    MLX5_MKC_ACCESS_MODE_MTT;
-	unsigned int old_page_shift = mr->page_shift;
-	unsigned int page_shift;
-	unsigned long page_size;
 	u32 xlt_flags = 0;
 	int err;
 
 	if (flags & MLX5_PF_FLAGS_ENABLE)
 		xlt_flags |= MLX5_IB_UPD_XLT_ENABLE;
 
-	dma_resv_lock(umem_dmabuf->attach->dmabuf->resv, NULL);
-	err = ib_umem_dmabuf_map_pages(umem_dmabuf);
-	if (err) {
-		dma_resv_unlock(umem_dmabuf->attach->dmabuf->resv);
-		return err;
-	}
-
-	page_size = mlx5_umem_dmabuf_find_best_pgsz(umem_dmabuf, access_mode);
-	if (!page_size) {
-		ib_umem_dmabuf_unmap_pages(umem_dmabuf);
-		err = -EINVAL;
-	} else {
-		page_shift = order_base_2(page_size);
-		if (page_shift != mr->page_shift && mr->dmabuf_faulted) {
-			err = mlx5r_umr_dmabuf_update_pgsz(mr, xlt_flags, pdn,
-							   page_shift);
-		} else {
-			mr->page_shift = page_shift;
-			if (mr->data_direct)
-				err = mlx5r_umr_update_data_direct_ksm_pas(
-					mr, xlt_flags);
-			else
-				err = mlx5r_umr_update_mr_pas(mr, xlt_flags,
-							      pdn);
-		}
-	}
-	dma_resv_unlock(umem_dmabuf->attach->dmabuf->resv);
-
-	if (err) {
-		mr->page_shift = old_page_shift;
+	err = mlx5_ib_dmabuf_mr_update_pas(mr, pdn, xlt_flags);
+	if (err)
 		return err;
-	}
-
-	mr->dmabuf_faulted = 1;
 
 	if (bytes_mapped)
 		*bytes_mapped += bcnt;
@@ -947,23 +910,6 @@ int mlx5_ib_init_odp_mr(struct mlx5_ib_mr *mr, struct ib_pd *pd)
 	return ret >= 0 ? 0 : ret;
 }
 
-int mlx5_ib_init_dmabuf_mr(struct mlx5_ib_mr *mr, struct ib_pd *pd)
-{
-	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
-	u32 pdn;
-	int ret;
-
-	if (mr->data_direct)
-		pdn = dev->mdev->data_direct->pdn;
-	else
-		pdn = to_mpd(pd)->pdn;
-
-	ret = pagefault_dmabuf_mr(mr, mr->umem->length, NULL,
-				  MLX5_PF_FLAGS_ENABLE, pdn);
-
-	return ret >= 0 ? 0 : ret;
-}
-
 struct pf_frame {
 	struct pf_frame *next;
 	u32 key;

-- 
2.49.0

