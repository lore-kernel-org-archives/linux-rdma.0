Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.3
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795873014;
	b=A1Yty4G9g/yiMgvzOrENI3qaKsBsImrI4UxEyNZRSNjc0EoUrFcBn656PHtwJbR1DgEf
	 pOA7o+iSWxsyZ3EGynig9uDK6cn/xr1n5Iweqffei7pCYXCSf4iihT6fOZZJrAug4qhTB
	 QkUeQ1IjUxb6N2gQamZcJ2d0v9SBrL1smMAy5mKt99yjoqvr3VhYel/V5PiaPoe09b9lk
	 9Rc4bOK25ZnC4vbl2Pbwqi32tUSquMPclJhGimQXJ0p2AVHq6ZXqbUKdiiLqkIRT1wmJb
	 FNhQE7AvBfoMhnCZD8T9lqVmi3f33HTAPwNYN2voytgOgAGVm7SZytlhfGNW/mtlPRg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795873014;
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
	bh=8WnGjwJ/2T71p5H4fFtWy+N1wap41gK+UvObz4LpTwg=;
	b=dpwmMe5XsXkuQ+YZw+ghfLsgasykS/jpIndnIN3oe3HttKrQfyEt4ehHj9v60+1+0JZ1
	 RRGt/eBUDGEJO68066Zwejvez1X6T8L57rLHVA7qvz2reENaqZoO1iMztkVB0tkAmQ12h
	 gcwgkPNWX+hsb6TYbm1gpcr+EqdTgtX/FlIWmlun9HGVHOQB3F3vhfU1cvxHsYS7ayTHp
	 Qpx8CdeAbVuqyhPqHK/Ef/ajWFQEqE+3xcxW08mlw1cPO0qQTqoTk/hNnVyUjPFsYbURi
	 s6AVbeLd3vuhdaoErK4t0h6h9lv65ZSl6951P8Ox+eXCTLu7jlay4kHY9Tv6UiPVLUA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Uyh9MpUu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.3
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011003.outbound.protection.outlook.com [40.93.194.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F54606A31F;
	Sat, 28 Nov 2026 13:36:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76F54606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Uyh9MpUu
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cGt4gHIDQBL/rJQl3PoKwk8CA4Q7J4HBwrkTTSXo8LWwrIYTCc5BnPWzSnl/ikfedtEJ6S/65qw/M9jIn3TiRp8o81IcvY6md3i6a7hOy7bh4XeSybceh2w7sDHl/b+Mi8nX979TweLMlAj8tIKiKBmwXJuXAwYhmmSs3hzRKumVe06kPHyyJgdm+Hb4NWldR79svuCf3sQNbV6m9vPibsrnidqERDT7p3Gtz3kKhtFoUNdBC1aadxzepeCFDLUurl4lf5ivBw+CIcXlfovGFUAFBIKFMpGM6SKs6zC6GX2o4+LnJRmpjsyJ+YM9Kq9k14B5obUScZv2+QCQOImeZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8WnGjwJ/2T71p5H4fFtWy+N1wap41gK+UvObz4LpTwg=;
 b=KhEMS8I4uQsHPAKX6aMlyyP6/1peYEuiCY4+Kd1Ythl9uhDKkFNrQagw4ps70/eG/Qce0fIgfcCRXLTOnUemLFeTN5Fv0QcvR3wn7wnOIR94lOm5bsCd5z81WsU2YYZbBvfUqqxU5fbu8sfPY7B8gJX7VbiusL8wihMCjwk9RA0+L5/EwUmFv+3yT0i8/4NNGoI+FaG9J4bD354EiwEm5M2OP9ke8OjjXlp2wrKuSuiv9tj2rc+npr/EzakYwt5JuXW+QURYfzKlyBPN89En0iYTBd0rn3LOz07bke2gwZ3LFszh4usDT5kz2OXX8VsyiyzhE+MVTbfN6guZU7dBKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8WnGjwJ/2T71p5H4fFtWy+N1wap41gK+UvObz4LpTwg=;
 b=Uyh9MpUuRJIjKI4TgirXrwKzu1S+4MtGpfq5YrHvfsp7wMuT51u17JhnmXY45neXxFuU1qpIE0R6OQnw4cAjDjqZ0F3fHPcsS+D9GXY0vBAoJluTGySffHxYRnO9/otFuGKdZISiuD+dws0LntGADpyoKwi1FsQVFoF+Gr/1KQr0Yri6aG+YCsNJazQww80gERttHiExkx+tINN4DvTBCaiZc2GobQOxB1ecFm087iXpYWCxgoa0YFXrlnKiedd7SnZdt0nlbJ2sBmyC0BXd7/y9moDWn8YMqKPjhXlpBGj7f/uTxx/RGD0ePSqCnSQ14QeA7s151isJ5/yEIu6HjQ==
Received: from CH2PR03CA0022.namprd03.prod.outlook.com (2603:10b6:610:59::32)
 by SN7PR12MB6984.namprd12.prod.outlook.com (2603:10b6:806:260::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Sat, 28 Nov
 2026 13:36:47 +0000
Received: from LV8PEPF0000005E.namprd02.prod.outlook.com
 (2603:10b6:610:59:cafe::45) by CH2PR03CA0022.outlook.office365.com
 (2603:10b6:610:59::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Sat,
 28 Nov 2026 13:36:47 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 LV8PEPF0000005E.mail.protection.outlook.com (10.167.245.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Sat, 28 Nov 2026 13:36:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:36:36 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:36:35 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Sat, 28
 Nov 2026 05:36:32 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sat, 28 Nov 2026 15:36:25 +0200
Subject: [PATCH rdma-next 1/3] RDMA/uverbs: Permit dma-buf export to work
 with pinned importers
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
Message-ID: <20261128-mlx5-pinned-revocable-dmabuf-v1-1-a4cde143a58e@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795872988; l=2285;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=/3oGGvz1DG3IInjf/JmW06oy2zIdND2YGgaQOcvEjjs=;
 b=F4S+LOwUwc7rhXxdP4Is28aAy0rcdtWYDZx+Xkr2ZkK/snOlGZHvsX0GSNZCC3l5YQNVyTMLg
 4AFOkXj33oIChXxxQJr4pGc8Li7nhBmZeSdeneRN4Gzf8hvNkAOaCPI
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PEPF0000005E:EE_|SN7PR12MB6984:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c16cc89-eff3-4c90-ba88-08df4d54a640
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|82310400026|376014|7416014|10067099003|56012099006|261026121527099003|261026140227099003|261022105027099003|261028144727099003|261021123027099003|261021121427099003|261102123227099003|261102130727099003|261009221227099003|261009223327099003|261009223027099003|261009221727099003|261009220027099003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	Lbdm/Qf3za1xzxAC+TEdfDEe/Rn/UhUjQ4R3F8sOzKrrILZEsYT13cgU9WpjLdHnDgG3veF2HuTUPACCY44Sv3dOKsh25ubUjYNKxp974yhz76S1OXi6DjtwPBUkZ6Ss4v6Yjm6y5J+p+BS0ZR4G5HUqez2Tam3t57xYGWGjmencLAduxm5uBdlGRpqhfH4fpJdmI+iTKeOHjUiEu7y9/n8KhUSRksCMVbetO6JijUcmk0xFjITz6VZ0ipC+yWxNwaI/FB8R3r9C2dYf2mw+xYc2elLQFJmUiczNreobcQfenKw87jIAYExeQd9Vil8Vc42fFbE9obhH17p5DwuAe+jKT1+WsSSY4h0B1TxQfn5m22XnReFnR2iXww8t4G/Qsx5PUyC00RZMLryDbruzowqagAZW0Csy+bOwj4ACONOgOFjmjVyEePUbH9rW2eM0vEqKspwtdYvxRA4V2rXRylLitAfemLGe5GeYZuC+AQKwZmGs5gg/7SvUON1O+p0s1B6ijClWJzmajckgj+q4h/AiRJ3HDkfNXx5QKJR0mYG3g285sYnYFhAaFtXiRW/1KlWz17Pn+NqfSJdvDp24cMnD8hANuvVOF7Rcl0v97rWIJwft4c26eC1ktr3/xZd2PJVRppvL3MS3mMDbLrYfh7BdBbwJlITEDRsiLoZSS7khUvdQXuNPHt8hQa1ygD+m
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(82310400026)(376014)(7416014)(10067099003)(56012099006)(261026121527099003)(261026140227099003)(261022105027099003)(261028144727099003)(261021123027099003)(261021121427099003)(261102123227099003)(261102130727099003)(261009221227099003)(261009223327099003)(261009223027099003)(261009221727099003)(261009220027099003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fhAvyvVF6rWDACCAaFf0KtKca05cN4BStwvVkjt5oSpahaqhs+aObqVNwktRQpOnsPxu7mpoexkEZl0kxqPHhHg8011BWCfiduZxyZ4tqalJPH4AcLWlMIBRfhZFWN4ZaGdr0kcBAnXFifanvSscOEktJYk3Z2ovoKBsf2QeF6W+ljxaFSoAn6a149/CYNxztetAZjEUAVUIeNdP1k59Fvq6Z3N0qO24XHW4atDTq5C62/j7aEooucJjaU5cG8ddsEkQpSrNdw8cdUDPRBIyU1YLtIz+RJ3RX7nUQohx6xN3DJUI7J0kmZqpAgMqThnGmL/4/WvAJf1MFfZDmza0hIaRDXC0tgOCbcsdMGPXfv+Cm3k9ojN72y+31P2zEGjZHf/iW8c2vn7p7ePCQWMMPlHund4zBgxIoqP2H4swlXCKCXj1UsjZAK+ChFnZqguy
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2026 13:36:47.0093
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c16cc89-eff3-4c90-ba88-08df4d54a640
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000005E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6984

From: Chiara Meiohas <cmeiohas@nvidia.com>

Till now the uverbs dma-buf export path (used to export PCI based
memory regions, e.g. device memory) has rejected pinned importers,
unconditionally failing .pin since it had no way to distinguish
importers that can handle a revoke from those that can't.

Using dma_buf_attach_revocable() it can tell the difference between
pinned importers that support the flow described in
dma_buf_invalidate_mappings() and those that don't.

Thus permit compatible pinned importers: drop the hardcoded-failing
.pin/.unpin and gate admission in .attach on revocability instead.

This follows the same approach taken in commit 6ffe939bf94fb ("vfio:
Permit VFIO to work with pinned importers").

Signed-off-by: Chiara Meiohas <cmeiohas@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/core/uverbs_std_types_dmabuf.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_dmabuf.c b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
index 8d8c997a48834cfd6a8c4c6ba867cc996a2406eb..4de527af01d265effdc042e186693b52b0c1ccec 100644
--- a/drivers/infiniband/core/uverbs_std_types_dmabuf.c
+++ b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
@@ -18,6 +18,9 @@ static int uverbs_dmabuf_attach(struct dma_buf *dmabuf,
 	if (!attachment->peer2peer)
 		return -EOPNOTSUPP;
 
+	if (!dma_buf_attach_revocable(attachment))
+		return -EOPNOTSUPP;
+
 	return 0;
 }
 
@@ -54,15 +57,6 @@ static void uverbs_dmabuf_unmap(struct dma_buf_attachment *attachment,
 	kref_put(&priv->kref, ib_uverbs_dmabuf_done);
 }
 
-static int uverbs_dmabuf_pin(struct dma_buf_attachment *attach)
-{
-	return -EOPNOTSUPP;
-}
-
-static void uverbs_dmabuf_unpin(struct dma_buf_attachment *attach)
-{
-}
-
 static void uverbs_dmabuf_release(struct dma_buf *dmabuf)
 {
 	struct ib_uverbs_dmabuf_file *priv = dmabuf->priv;
@@ -99,8 +93,6 @@ static const struct dma_buf_ops uverbs_dmabuf_ops = {
 	.attach = uverbs_dmabuf_attach,
 	.map_dma_buf = uverbs_dmabuf_map,
 	.unmap_dma_buf = uverbs_dmabuf_unmap,
-	.pin = uverbs_dmabuf_pin,
-	.unpin = uverbs_dmabuf_unpin,
 	.release = uverbs_dmabuf_release,
 };
 

-- 
2.49.0

