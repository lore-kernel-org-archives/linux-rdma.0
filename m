Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794235396;
	b=OzY0Pm2vJHW0kTYiSFG7ihURmTcOO9dR9WcRiEd3/m/SB5rDQPuTjxeQ8qBQ2YQ2cEFe
	 ridCCUb+74xwKNsWMHDLXdid5lYXfnrjHw4D9NY7+QkRXnjPiPJ8j4yLDTkWUSlrpb7lI
	 5MeRMA7HfMaU507yzhCqiqLs3um5FrpsdrbobcUmwzq/efTtyNFs835rZnj3yCKr2UKMq
	 oBXpXT8izarVY49JJov//NwLMd4tPq/O9MhpUmF1BmAV8JL1/mme1sD57B6WIXLbxUXWW
	 o6ioj1d+71ciVfPPRDAuEIcw7K3JAKrkEij9jPcN3zo2JlF/HV+mqetJ/MjsApL2wVQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794235396;
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
	b=TKM8BXTtzmbE1g03il3dV3AzFDcPM6sR9oyGO5X+WxGqWNAzpaPo5Sgcrj5PRfdQo+xS
	 FS64GEEjDr9gp0tC+4f6jFlogRf422+iIQMPEXOZXc+uw4pHnv+z+WN9RwLCpiToDiRtz
	 C4YG/Ed99oaWCC/l1UnUyPakLxqgUl8ILq05CmcL2dLmWE91y4ATSQdobd1bSQi+63m1t
	 tw10v5pOAzYc4hfWlHa8Oq/ntqXzs7FaD3HNTjmS1tl7nyEsguQWThXTgy0nHXY0rzZhW
	 eIuLovXWwoKoGfHdfZuMxfNzO6bXWwNhyK9THr0lNbZjRL5zqmQAJmpx2FUc/th0vvQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jrCqNIC9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.70
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012070.outbound.protection.outlook.com [52.101.48.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE64606A321;
	Mon,  9 Nov 2026 14:43:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DE64606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jrCqNIC9
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZAY/yLcBh91n549rRbecCUarhevVoRWIwk/4f00VuF6koEyVtKfcy5gRRbr+eA2ZoYWn+WhS25T/9dlfudRJ3r439t3WqIFO6Ac+i/SgQlQwX3dy3cvdHqQ/sx2Ub8YkzxRbCk1lqWvg5vTFXOpTCqAVh/QLFyyu34Pqd6PtWj9zWAX4EMyA7I+6bSZU3VQVDHnRDvmPkap5gIeQbIzb8CVQIQidMdATB5m2jEVwRVJDEKeSCzte5fQrFM4soSoMsYiNJk1UW5AUvBFB8x5wxrO4EaFOMAMzesGjcdN5nhChav8mLJatp3C41eDzzF/Im681A81dAghVtRbHhT8T8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N8IkK8KYarwKEJh7pM7PGwK538bFc6RDti2GTwZuT54=;
 b=nhJAFly8zK1GeiwmgyLePhRz/Oseo8NG7qJEWPgwhxJ6ow8spQ0hYDaWCr/14UNPw4/lBA9EKF/HRm1f7V+kehBXwWYW3I7ZvjHyyG8H7sPOweJdUyDAjQ0voAweMb3pIVQmgeHNvu34OTBMCCspjZchBtljVIATKKD612Tp4Njquu/gAKiqdzsxU9zPdf0O7ujtpXqkKnYqAsDQwB0HIlRjytIIqHe8F9VRuMG+w28VjXsFTT/id+ARb3/Ec2VqjcEYC8C0X5lb0DgO+1uvJgE7Um27Mj+Tlly9t825nxmcfVRtQsXZ/DykSbnJHl/qSPcH+51IEWbgtOc5+ucSfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8IkK8KYarwKEJh7pM7PGwK538bFc6RDti2GTwZuT54=;
 b=jrCqNIC9piea+AauxaOMMvojn4jQOTOzNNGd+XJqOOuhomBqrC6xCd4qE9UrIAC2R4MzBJh2JPydpLnCEKjiUc5TxJEmpt1TftmiegqeWyqZVLbNvXEbAwLH4g6U9uoWpa9QvMDt1r78g/aW0opdIpGEBSsD92zzLEl2fQLQtezLJF3NXConDa5N9Vw50P4hrm+Vp3WybDGIxidf18RZzNYV4DHJd55qjVJH91oEkMD39qH/3ZvJQiq0u7Kb9PcBBgdlq5paTlcca10MTcXyIGVNFFkIsWQFAJIPW0Yjk9t/XLaNTjHQrV1kgQIE0oKoN/bmqcR/2CmDIdoV88Fvzw==
Received: from BN9PR03CA0389.namprd03.prod.outlook.com (2603:10b6:408:f7::34)
 by CHBPR12MB443627.namprd12.prod.outlook.com (2603:10b6:610:36c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 14:43:11 +0000
Received: from BN7PEPF000000A7.namprd05.prod.outlook.com
 (2603:10b6:408:f7:cafe::47) by BN9PR03CA0389.outlook.office365.com
 (2603:10b6:408:f7::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Mon, 9
 Nov 2026 14:43:11 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN7PEPF000000A7.mail.protection.outlook.com (10.167.245.231) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 14:43:11 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 06:42:49 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 06:42:49 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 9 Nov
 2026 06:42:47 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Mon, 9 Nov 2026 16:42:33 +0200
Subject: [PATCH rdma-next 2/2] RDMA/core: Don't warn on oversized bundle
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
Message-ID: <20261109-devx-umem-mailbox-overflow-v1-2-4a63baab25dc@nvidia.com>
References: <20261109-devx-umem-mailbox-overflow-v1-0-4a63baab25dc@nvidia.com>
In-Reply-To: <20261109-devx-umem-mailbox-overflow-v1-0-4a63baab25dc@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Yishai
 Hadas" <yishaih@nvidia.com>, Yishai Hadas <yishaih@mellanox.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Uri Dar <udar@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794235360; l=1686;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=/L4hV2+24nHi73lq6P3HZlkIYextT0+opDa5B1zcJRA=;
 b=aEWr5/6ZVN8fnM0Z3wMYWRMxJuMZJioWtebJCs9zZEkGxMxpjsHjMh5gDnNwWGoJjKsjEoF8m
 3WpZjVLsdt4DcJQsZiJAm7Oz1zC/tsDbmne4ygQYlV5S1KWeCQ/zbvY
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PEPF000000A7:EE_|CHBPR12MB443627:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f1acab3-5049-4ebe-9a42-08df3e6fc764
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|1800799024|22082099003|18002099003|10067099003|11063799006|261028144727099003|261102123227099003|261022105027099003|261022075727099003|56012099006|261021121427099003|261021123027099003|261026140227099003|261026121527099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	6aAMRSn08KTB46GKGaXmK5jmGN+huO4JJ5ILw0cw21aBiQOebhR3qSL5n9RuApp4i5H1uJFvcJVEeuEe1cGfTuYsw5N0HD//9MBum+in2jEs7MTvqT30kY18ujQxsAGG6A9cKnVLtiz/C53JGd/73vACk1Je5PeZBl3ST6k2y6K7q92c7vZBvUm3HNa+tjT1ypcaxk+hJMrSv5dA5OVUe+EnqMu+OKej/sGXoCwzCIGNqDTG53974RTH1Vo3FdFOM7qNF3FvQ+YtjEn6f96otsHzvlIkEj4qpGG7nGpVzxFxfRIHu3KRJcfMArfCTPfcxg0q7+FmdPA0dVb7n0lZH+KYbdnn8kRYIQS1uhW3m3zMnFeUG1JF8AsqpqWm1ePqBYLPKBI14fpsp9FcgUEVwrfVvCuLfbz+rDm8HRT2al+6DbUDY9m9OlJOq6Exd550XfUii2I1qypurau0dwcalaAb6bsNX47Iw6Yuij0H2j8ErqglaKnwB2YfJvB6bC6PUyfKtT8UwNSYUNuaM6gmf5ru2u2f5lyOjugfAPTTy/iRACCUbgvQKJgF70woIB+b+xUGNFE/r6Az7zepVH4NIkjOsUHzm4LR21d2Eu0rIQ+8QR0KaAM797G0sORX/KJgGkQwQy8jXLjqNI0IhSeaoxYs078lsS84awJsg5xA8M3qUXHF6jaDSOT7YYqF6DiQqSSjJXjhebWLu2Hn1HtKqg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(1800799024)(22082099003)(18002099003)(10067099003)(11063799006)(261028144727099003)(261102123227099003)(261022105027099003)(261022075727099003)(56012099006)(261021121427099003)(261021123027099003)(261026140227099003)(261026121527099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	56DM7/R0dqV1NyRqnaWdTKi0pKzcf0tpzf88MBepLkerixnR8rQYK1VgMiCUvoEEbY95oP/EMofVv2I+UKE2HTVSxL94+iQauTLqJoLLDLafPdXlLKCHvJu+TqHw4ZQ/pVrEJKaZGx7FSfD4EbK5HElKkVxZosbcV2EiR43Yssxw5SBWRjLGTcobM2TjHSB/zv2t3ysJy8kPzMMRem2Wsi9JJdxCGTbeciIzjwp1mOoe6BK2TqB02pIimi9E4jOVFxeNm8I13RI1DkZNtN2pJf11yklXfvTtmROqxnK6GVy5k603leQXSXSMNANvp/KqdAcAVg8wx4R2gMfhsbh969dhGlpxsFq77OjYazrlgOJdPYU2ZtNN9KBr38YX2H9f2Lq1swDftFNZijlDpDRtV1sNIPnl4Uo53Sa9DGJhryEUrPqIpdkcxwTSI6QzPoy6
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 14:43:11.5644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f1acab3-5049-4ebe-9a42-08df3e6fc764
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000A7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHBPR12MB443627

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

