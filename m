Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794405473;
	b=5saZxOzr3A8WpChYJ1lX8yYwWmrB9oQrQtNkbtm0sE9Wl2l9xP7IT9dOAMGjcJl920yP
	 eHshGBdjg6463iaJsW08MmyVgxx03D2jh/CBHebNlDfEpfR3AdV2YEj56dEneTl3hdwAc
	 xNkSKIeBDHMJ9SqYkLbDl8rUB09Rw2EjWm25mNFNwfKc6PwiqM+o1m2dgWBqBWCwOGiEG
	 eeJEmyjps8fsYdb/ZvE4Cre1Hu+qkm/C4oh0c9mIKNP4N/7iDAXgdDrmOQzoJ1eaG7TDJ
	 5k5U8ARuC7B7ZC7DD75psXYG5v8PkoEey5SycyJwqn034m64rdhha3CMiMn60iWU1yw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794405473;
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
	bh=N8IkK8KYarwKEJh7pM7PGwK538bFc6RDti2GTwZuT54=;
	b=TIn1BmnWbbRbYwI+Ze2rFsvt6uCTMcr6zfiRdmhbVeCLsWnlZjWZQfwxiEw3QcO5y8V8
	 2/BvIQoI7hniGhZPyz3/DOcFDRZYtIBiLUHmgoMtIQAsbeVWBCXV6xN0ffloEBHb02cge
	 le87cVL3WFrGpaxYEU45X1PoiTRJHxr67yuUDqx0zZpod75N8drzv43qOJmRVrMkhnt3f
	 CMpZtNCcJuk8mAOat/Rs0TbrdxvN7FWKsspZF5pFCm3tXY9D5gCk+/SvJUVUweaBBDwXv
	 BNERJHTUmcN18Qy8dwbmOpC7eFYtAJCfdKioJp8cNcxwhgnf+7uee0HhrMm9oLAcJ0g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TQgtYhdE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.13
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012013.outbound.protection.outlook.com [40.107.200.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345CB606A880;
	Wed, 11 Nov 2026 13:57:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 345CB606A880
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TQgtYhdE
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hQR161LGJKit9rBQB5u9wSwXwaMtu9V4pMqpNNF4dnCR+tl1QOAm/yR0h+7vlp+V3XDaz9mtLLupM5fOsb5+HjtEyvBEoIm+pECVUEZVQuAkaQ/C7pgwLUgZJmBobQfPj6BNFBOxvkFZK8doO7grOjNvdPignr9xVhZgeVFfWmoVBVeSBa/b4QKJOK+eiGIgREI8aj8Gkc3jF6Hwzo6KyrQZfzwVVohOqN/vnjhfzm1UMwwpV9AVpJfwTqB+dMtxrZy5FE7HBo87qMdfGrJdHr8nyN0wHC/2PaZEruADIZCoXQjzKPQAZXNBKSK3tkDTU29e4Tkd8F5eNAz7dJq0UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N8IkK8KYarwKEJh7pM7PGwK538bFc6RDti2GTwZuT54=;
 b=J5D6fbFc4bX2ZxlKXWdjH7WEiANzqZuGSdc1aD7CatjLrFHLGcGPSIrlr5V0YfTayY8jfn/8zqryxNDgjbiVrjSYWM1n2zNiC/Bbenx5zqAPiPcI3Wv4iITBTqhd188ru8CRr8ee1zwiZ0xSrQ8Pxgf9UNSDJuaDjlqKtvOxzrp5PWBcj2ilsTd2UppvIfZFRP07dqzP5nzlSP1GorORRHKiPDJkIMwv/UxxDja5Cdu2PAZ5khUIGYrQShlTYE75+ze3ojPswznbzvWVECOzS/IJwOYnTfpzz0TJzy58OhB7quoC+YKZKMVK3VNEGktYoq8nxocutAWBeW5ZbNfJJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8IkK8KYarwKEJh7pM7PGwK538bFc6RDti2GTwZuT54=;
 b=TQgtYhdEbuHLeFAZrodfArzbqpi+njSyZvHrzSCzNKkuBuJjcQdzO85ChwKj1DZiqupWK7kkov4fB3DE4sDGBzinRBOidRldnw/DFuvo+66m6MkD7+sLUvdzewG2OTrJHFYsB+W7EQhla/tRvCdjS+TONn1KsY0r91eoPvyXzg2Ty9M9iOZu+swqXavkLBB2UBL4TtX75eKXGDWg60SrUoMlXGhZA2UR/hNX/SkxF3G2CBOFOszonT1fROuIZpVlkggWTrpPGllTsxfGc8Cd7FU5jYXDB+3MvtJ8AOXofWe5Z3qLqbfFKS441cwnSuBW6EqajUj/duTRutVZjueK7w==
Received: from MW4PR03CA0061.namprd03.prod.outlook.com (2603:10b6:303:b6::6)
 by DM4PR12MB7744.namprd12.prod.outlook.com (2603:10b6:8:100::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 13:57:45 +0000
Received: from PH7PEPF00000007.namprd04.prod.outlook.com
 (2603:10b6:303:b6:cafe::9e) by MW4PR03CA0061.outlook.office365.com
 (2603:10b6:303:b6::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Wed,
 11 Nov 2026 13:57:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH7PEPF00000007.mail.protection.outlook.com (10.167.243.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 11 Nov 2026 13:57:45 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 05:57:24 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 05:57:24 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Wed, 11
 Nov 2026 05:57:21 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Wed, 11 Nov 2026 15:57:04 +0200
Subject: [PATCH rdma-next v2 3/3] RDMA/core: Don't warn on oversized bundle
 allocations
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
Message-ID: <20261111-devx-umem-mailbox-overflow-v2-3-1e7ca8237b58@nvidia.com>
References: <20261111-devx-umem-mailbox-overflow-v2-0-1e7ca8237b58@nvidia.com>
In-Reply-To: <20261111-devx-umem-mailbox-overflow-v2-0-1e7ca8237b58@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Yishai
 Hadas" <yishaih@nvidia.com>, Yishai Hadas <yishaih@mellanox.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Uri Dar <udar@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794405431; l=1686;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=/L4hV2+24nHi73lq6P3HZlkIYextT0+opDa5B1zcJRA=;
 b=gKtOU+M4oMlWs3BV5RL42NCJ5zQAV/SOAIeVCzwmFZ88xzFVYFz/++8mqytBu7kPGnSF0pR0L
 1jqvhGLDl7RBukyYAF0T4Qlm42U7c12KjcbIdBrrGYelaOXfA2k0qK7
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PEPF00000007:EE_|DM4PR12MB7744:EE_
X-MS-Office365-Filtering-Correlation-Id: 816e84a5-4b11-4acb-a46e-08df3ffbc32d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|36860700016|1800799024|82310400026|10067099003|11063799006|56012099006|261021123027099003|261021121427099003|261009223027099003|261102123227099003|261026140227099003|261026121527099003|261022105027099003|261022075727099003|261028144727099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	bwpW9wAzWiEzjvSIMJ7wP5HvRDjuZvCwjhK/mM6i+vg/RVVIaVWSS2Y0uSH85Mspepq/jv7LNdhEO5oDeLcCWaaU+LDKSzZhdJNAxjumGuCvGhRcGqpT4Q1UXRsizFbIfQnvLRvZ0ICbUy3INk79864F2EbW4znVvK8/UMOSpQ9DMdmBop0yyLn1fTw00Lj8/TT8cBvXCUuUKMkReHg2sPj18jH44hpi7rwsWI4RHMA6Zxa9FmtO30YUv6QRJaDhmeWEnziADBo3wUknfBKjr4tI6wb97YL41Em8jeoDPf+taEocU28K8G6pKplzmh2BvYFXzF5jiiU0RJD3N1gaJGnHGpTKFB8DW+v0bb1gRbIUN/mkYBUnWU3W/rlEKQmP2YVoi44fT2arjOtaSgnJR1LzqST3D2S2aXCrzW9qqRSmp7EopSnnisuqw8eYM5JkyU5y4ugai1mgIUgB5mHBTydj0jJL6pIJiaAp1iMbyuKflCosMdSEK3VBP48Z6IrtOS5Fj8Nd2tNyyvMLevOFXcCws+fBRdtGdnv/e+LbUYY+3WKr2DF/IrwqE8XRA71C7efgS0vWyoO95fD6S5Vf3Pt8uP2dAuWDNQWKGnvPrjUPW7FA8uHvFapevp88ZAnc0SAvYXGadsHDFZLXUiWYy+4MC14DZVZQjqoavftVPaJc64Q+ihgEUmKsfDCFAGMeKPDwKl3quyFJ+t0ZfHHmVQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(36860700016)(1800799024)(82310400026)(10067099003)(11063799006)(56012099006)(261021123027099003)(261021121427099003)(261009223027099003)(261102123227099003)(261026140227099003)(261026121527099003)(261022105027099003)(261022075727099003)(261028144727099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IQvsBvYfrRkf4icfpA8bMZAhOTv9uTZYsbTI605SrS4F8b/vEeRt0YCOcC0dqGkCRSQFpwvlmFvpCUSY9F0604ltaQL5kR7/6Qlfm5oSyui8NvnWxt1Wkdfaa9XsBxjHBqMka4lGNdV23KTUsh5CbyLOdH9vYJ3UWvgwDywtEdS09J8bs+FH9mNeg+EPCdNOxzbtKRE//dlTjAhOhnDmjydEn1BHH/LWHOe0egAr6gZSImIHNMrLfOX4sFVsVV/FZBrvYUzv5TL/y7vy18BvV/393W8gRvjGOlcSuJuTkaLO2mQF7+jYoCQtLkOv7eXTpSBadxiCY17vWYVCJQ+hlhgCHQgFQSaZtqiNsi3Z2wsbivR1CHN49qeRtCqBZWbLFYoVSrXxI95e/7P9Pi2rpaHxXDfosN56mL2lH2jFs02jiUHtkJQ+qIdl4bYAu4DY
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 13:57:45.2940
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 816e84a5-4b11-4acb-a46e-08df3ffbc32d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH7PEPF00000007.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7744

From: Uri Dar <udar@nvidia.com>

_uverbs_alloc() serves requests that do not fit in the bundle's internal
buffer from kvmalloc(), prepending a small list header. The requested
size can be derived from userspace input, and since commit 7661809d493b
("mm: don't allow oversized kvmalloc() calls") kvmalloc() WARNs on any
request above INT_MAX unless __GFP_NOWARN is given.

mlx5 DEVX UMEM registration is one such caller: its CREATE_UMEM mailbox
scales with the size of the user's UMEM, and a mailbox that passes the
driver's INT_MAX check can still exceed INT_MAX once the header is
added.

As with memdup_user(), an allocation sized by userspace should fail
quietly rather than warn. Pass __GFP_NOWARN so such requests fail with
-ENOMEM.

Fixes: 461bb2eee4e1 ("IB/uverbs: Add a simple allocator to uverbs_attr_bundle")
Signed-off-by: Uri Dar <udar@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/core/ib_core_uverbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ib_core_uverbs.c b/drivers/infiniband/core/ib_core_uverbs.c
index 74d9c006bad5aa5d8366b1b75843c9873c62c344..c41b77d7084034613678e8b4b25bc95f72c8e241 100644
--- a/drivers/infiniband/core/ib_core_uverbs.c
+++ b/drivers/infiniband/core/ib_core_uverbs.c
@@ -554,7 +554,7 @@ __malloc void *_uverbs_alloc(struct uverbs_attr_bundle *bundle, size_t size,
 	if (new_used > pbundle->internal_avail) {
 		struct bundle_alloc_head *buf;
 
-		buf = kvmalloc_flex(*buf, data, size, flags);
+		buf = kvmalloc_flex(*buf, data, size, flags | __GFP_NOWARN);
 		if (!buf)
 			return ERR_PTR(-ENOMEM);
 		buf->next = pbundle->allocated_mem;

-- 
2.49.0

