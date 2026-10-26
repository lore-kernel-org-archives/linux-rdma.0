Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=40.93.195.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792993050;
	b=VTsfGRPoGmRF8xJv3qGDHWbVEZCwGooah7G2SBXnqDuI1zcHR8YR43E4S39HdgOZ9IB2
	 RYYbi4UJAfQszpAfPKpoDP+szpD3/MAcM94ngGGl0rT2t4BZNwUrQERVXnxWIRx4TRJkq
	 bp2vkKR4rsvnuOCC/pqzRzFEIbDUcAwHrJjUy783UppTUN6Ol4CejA2JcYUMU/2cx1uZd
	 RA2rI7vOeJmVavcKd7ZrwxJG7Okxm41UH1jAxWVNLK78aISNF2VubzeYZlcTf/YN3110J
	 8a5k39u9pHMf3TJhIXGXvEKO4AL2ejsC8BjW8WT9qhu/qQzeuhyx6NmzTjvVeV/Y3TQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993050;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=46NZBu0fDMsKHuKZKDe9ZlZgZjaOE6fO4ips4mAXnHc=;
	b=wej69a6ji8b8VqzLyzon4b9B0OFsdL3u0kW/DmcmLrIfGmZ/6h2ckkKj2sEic8ZLfml8
	 GT8NcmrsUneMieY1JWy9e+96A7WLxQuRdVo1+B6OJ8xdTVA28SSDOq5YCnqoaG6z6ZMSW
	 AhkpszSLDtrcY+0kjc4C3x9wiSjCcpI7EU7mqi6ESSsIk4X8Y/NUS0PKdIdixFqfSp2fe
	 5VIsIMY7LEjmzH7vaSUfAe8ZbXNWeTw7SfaWz2VD1EOeVcwoAFWmZQd6GU4psDxVRM/5O
	 HlmqkP9J5Uos6cjnMzsQ1+oMZsEJDQ8s6oClC0bPjJwQK5fvLUbDxKr4/+/nm5AF2eQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=acD0u71T;
	arc=fail smtp.remote-ip=40.93.195.7
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012007.outbound.protection.outlook.com [40.93.195.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839C560A262B;
	Mon, 26 Oct 2026 05:37:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 839C560A262B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=acD0u71T
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GVhI55Mzcq4atVAmG+GBuK8VMnACMdOlybg85kBgz44Tqt+NRRXMWaNLR3cKCKn+3Ef2FiXobcyuUg+h5PYLxB1CdOI//ICY9Dx0XQuKu9nmd/QruDHSIVGrkYjp5XZeqQaQrHKGJdR19+BzCIFuznhJ6TFwTzoyXV8jZMbVp65xsMrD9DI5bDQfjAJfnbIGH5QnkS0RCswKIpXu4yahJCc4AUsa32le2WYhw2rcemcQub0tvataGs3jBylGlA+4ckYYREP/LlLBAng6o4LeM37RI9SV7/KaWwhqA7zxoRXCJO98pwcimLgLY6IkLOLL5ORAqsTUyEc2kEZaxoWmIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46NZBu0fDMsKHuKZKDe9ZlZgZjaOE6fO4ips4mAXnHc=;
 b=cQHnUy9R0+MambrMeL9lQvZ/Z7G0S4UZi+ghCFycrQCbbp65vD8UXwqwgsCL6OhCAeRSaWRPJxJL+2XiqvmKJ5e3/IST9lvJ7id3HonyeLTRwbqRHkb3oIETw+SabuCfOXKNYExRegODFc6ikWJD4pNXOy9Z11iI27XGpfEnfTVCGvxA5gJTrgE/8QsmsOH5owzBO/ThHKiCAeG0VR/A/snsYXOq/b0b7G1MhBoyMzvUGgFwgmOLyeElh7NCnXstqSvzyNqI7BQhTuSJPAkv/xGOji9s7NHTjVUvQq75XTpMrMql+9PV4Yvp+yGAdscTCx84cQRsdOSh3Bo8KU8tAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46NZBu0fDMsKHuKZKDe9ZlZgZjaOE6fO4ips4mAXnHc=;
 b=acD0u71TY3f1rJTKQDFQrIX+d5Ea06T/4Fn/jK2tWsKt6jFGd62w2Ez8zwDDR+o3cSVOe7xXOwtp0mG/kCmZQr1+3cecVvRDVBa8P8f5qQmBYI9PqL1gdeEJkKKSHg/WzsoGPei24LWe1zGdiu4DDO9KONgaBuG5S4DREwGHmcPTNhB34qq6j9c6YPNIsPFdS9mjzaD4ef+63jsxWYb9jeEy3Rfekns7IitCiqUw7NiYWZiiaJXaMsuGmR6J1AJs1HuZsBVlVie/rtWMwuyCDifD4N8GAwpO5bdls0HkAtaQbCNm85HsfuaPqlMCZWyMXSIi7fX6FlSTa62xPz3VoA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SA1PR12MB7442.namprd12.prod.outlook.com
 (2603:10b6:806:2b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:37:16 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:37:16 +0000
From: Alistair Popple <apopple@nvidia.com>
To: dri-devel@lists.freedesktop.org,
	christian.koenig@amd.com,
	sumit.semwal@linaro.org,
	jgg@nvidia.com
Cc: Alistair Popple <apopple@nvidia.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Matthew Brost <matthew.brost@intel.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dongwon Kim <dongwon.kim@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	intel-xe@lists.freedesktop.org,
	amd-gfx@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	zhipingz@meta.com,
	treding@nvidia.com,
	jhubbard@nvidia.com
Subject: [PATCH 08/26] dma-buf: Allow single exporter drivers to avoid the match_mapping function
Date: Mon, 26 Oct 2026 16:35:59 +1100
Message-ID: <20261026053623.202642-9-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P300CA0055.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1fe::10) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|SA1PR12MB7442:EE_
X-MS-Office365-Filtering-Correlation-Id: b800c6e5-2109-4f05-371d-08df332331c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|6133799003|22082099003|56012099006|11063799006|261022075727099003|261021130227099003|261021123027099003|10067099003|261009223027099003|261022113327099003|261021135927099003|261022115727099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	OFGs+aGAHfk8Fc1mJDVNfPTw3FTzWQIR0O74IXy5xwq4XkA83cbwH9ATD7nA5ea1XAkphCVDXh+Wpq1lEvOATaR9uOfWKpL5rVlQbw/UxR1s7kA4rwfdY9jXZ66kqUVNI8HhLyrFPiM+SuqqJakHlnmSqGG7KZ0c7q1uRAFrv0xiScFqbRT/1C53I23pxbm4DgzFCUeSxHFST25aweqwtoUyl+94NnBwucuJUykdwp/uGkGCr2YoGZg2+7+XhK2dlCvtmPF1MXygygoChKfJMt6uK8lPIgaHaGS66hJTnOVsqDfZFrQ5kap4c7BCTXQ/h+dPFbRUPK/vBf9BfW/nP1U9xDNxLZbvCYiCAjM8PWVSOR8EqB9f2oHEO310jOCKk0MZnKk4c5XBgG2U2EhAEvYCS7GJ8ptX2v3Co+HHQC2dw/dPqqMLn1w7RD1da+p2mxNKTIZpRKxZ5en+3h0kuDxnrqem2BPK/IxnbzTBve/HH/O+y2v+OAJBnZbC3z2UxUBHgQdWJj6j23m6ikg3bZMD87iTtnFcj9i543uL435PEM1Ak3sWZxQD3Oi019jNm2DjWosajZu5MknkduAmrR8TDlVwZ1ooby1bgs61jdNVXGYyCRY628+3JEHrMGLSLYLwIaJ1N6ExDC5+Oiu63DVxwTixxtnPJSBx613ina8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(6133799003)(22082099003)(56012099006)(11063799006)(261022075727099003)(261021130227099003)(261021123027099003)(10067099003)(261009223027099003)(261022113327099003)(261021135927099003)(261022115727099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8ZcL9OemVsts2DOgqPxyEOVc/KBVbK8yQyZjjFZh8F7wzuwTQH/1YsKzdWtw?=
 =?us-ascii?Q?I8xcCDT6LADoGz+GsRLWU0VbXIIOS2krsS4MxQSBnntxc1RCrH5NQ4uxzlue?=
 =?us-ascii?Q?m31RlwqfxZavovBCpe4j9OAsgwBcmZc0Bug4DBAXG3+gdjwUmOJJHMrhjLEp?=
 =?us-ascii?Q?p5auNFWc3LGmCx/6YTZbjTQGY10MojBXQ3FuxIabn64XkIUkSMWr750o0c6T?=
 =?us-ascii?Q?kr+NOamWmRDXl2G3pJ/Xm9FJn/8unLTQDaxYoVkJx3jzywMrw7WjEv2QHXxC?=
 =?us-ascii?Q?PhNsePjbh/b7giFeJCQpAacZ9TlSoF77p2ZGHQGiP/QnwHj8yVFD/+3oPol7?=
 =?us-ascii?Q?Zc7IWpFPgwlDZ8ktjEM3IqvLPhfH3Uv4h86MFEBSS4gfxWGQgN5lZ/9luZu4?=
 =?us-ascii?Q?F2svHekqXS+4gFFqPSCRDeayjoBcjV7Az6JrvsCdoEOJl860mF1RU43tFRjW?=
 =?us-ascii?Q?qhDYcm8m+fxzEqYlpsu43a8yRFr2LX2JKDJFMBqqQr3xrBr2imTKvADEvYgb?=
 =?us-ascii?Q?WpXEjHbiE//US2X5zoi+MTfwStqPYlYJfj3iNNMaC3ZwZhxTz1xgA/2BrxDB?=
 =?us-ascii?Q?GqruBCSYMMgaX1uW6K0uzFO6GI8umR/nkUx/vLTMIykMkE8CppJH84yIhh+j?=
 =?us-ascii?Q?EJiawtaDF8gvCqVjw49lsXB0mkIFQSgvOgahk+xzCYX2Ry5rUMZnXu9K5tbp?=
 =?us-ascii?Q?n+w8dl/P3FRSkrwTwSazFnPcA0m/JwX6ETam0eNf0Z0k3uGpTm0EyUGjWlxe?=
 =?us-ascii?Q?UdAN81GqaUPRaYcD1ZruzvPe8WA1d9Z6hv8Kzt/d2MIvpj2x7WvK6UnBR2/x?=
 =?us-ascii?Q?Vo2mQqofaQHAONCypgQzH1lKfbB+MkBM8YvOOvwAEalna2HheB3D4erpLY9y?=
 =?us-ascii?Q?h8kaj6uCMP7qYKqdhyIEwPD6tGsQfhpxYuREMrCSFXSmDSuaA4uHB5m7CBxP?=
 =?us-ascii?Q?vV97C7ocVYMKuPkR31sGBGGLyHcWs6I/1576o6ScgsJi4VyHo5N82+rodzGs?=
 =?us-ascii?Q?Q1FBSI+JuhahYMBQgxXZuEAOOAvbLl3MWpCCU5qxPzJIx7iiuWw+a1TJFZWt?=
 =?us-ascii?Q?AEq5Nzp6zOj9ItGw4T8oqDTkHaRUi5IvYN/iuoAavX9AZXwVWPtccozhEPNN?=
 =?us-ascii?Q?3xmkPdxvVyoQLS5Vl6/pYivOGbbP4IX1858TftWYAL2xAh8Xa0+JVfJuqOW0?=
 =?us-ascii?Q?RPuEvqakaOtQ/AnukLW+QdFa4/LbSQIqm9ANV2psYiE0FpWf406aoiMiGo9A?=
 =?us-ascii?Q?e6FMx0Q3QiC4naZs/BxYd/UCrODT4/Z1NZsCywRAH+z/xADJOrz8VvQyItVi?=
 =?us-ascii?Q?znCj6LrGNQnMTjC7c9xY66ZmB7xV+/nsIfFxlNTGo+375ofOw+qWyW2kIafw?=
 =?us-ascii?Q?lLAu/4UZJaQt32MQaOQXEOKkRBHRfRtrdf35BFVQ5NozIRpFzPttiWTVeSTv?=
 =?us-ascii?Q?9AjpoO5uMu5a6zTIiFEnvNoX4OA1EVmQxTurXvxI63J6WkyQb39UAHAS4z5m?=
 =?us-ascii?Q?PpjA8tzib/BoFiP481Pdyebs0BID39+KgXtnp/b21XezffWYpKWRzGVhIeTL?=
 =?us-ascii?Q?FDnztVu/bOd8wrgKzGkKx6Uop3+s7ZmeTEFwbBWiL2v5iJFfNne5//ML+Btu?=
 =?us-ascii?Q?lCGjqLPRdBjYiXzK6LR7xXHBpL/LEHD7b7rV0dbJc/GOgHEZVVi/8WBfi1l5?=
 =?us-ascii?Q?VhHi2FlUoUdaK8vvuHAPDc/NJJevVbBf93NE/YnJa2ZlLzEsOJabyc5lIbxM?=
 =?us-ascii?Q?QK+7nAwRjw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b800c6e5-2109-4f05-371d-08df332331c1
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:37:16.3619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ngYSjdlt4R0FouDoWzruxfHrY5x5XS0fK8VCT0cNRuQv5liNQXdKAU3UuUSL7eAbltyni2MldojTq86Kh/YNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7442

From: Jason Gunthorpe <jgg@nvidia.com>

Introduce single_exporter_match into the dma_buf_ops so that single
exporter drivers can simply set it using a static initializer to use the
mapping type APIs. Provide a helper macro DMA_BUF_SIMPLE_SGT_EXP_MATCH()
that generates the initializer for simple drivers that don't use P2P.

More complex exporters, especially those with P2P, need to implement the
match_mapping call back to extract things like their DMA struct device
from the dma_buf in order to do the P2P calculations.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/dma-buf/dma-buf.c       | 14 +++++++++++---
 include/linux/dma-buf-mapping.h | 15 +++++++++++++++
 include/linux/dma-buf.h         |  9 +++++++++
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 90699e85e4c8..6c9ab8bc09ac 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -718,10 +718,14 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 		    || !exp_info->ops->release))
 		return ERR_PTR(-EINVAL);
 
-	if (exp_info->ops->match_mapping) {
+	if (exp_info->ops->match_mapping ||
+	    exp_info->ops->single_exporter_match) {
 		if (WARN_ON(exp_info->ops->map_dma_buf ||
 			    exp_info->ops->unmap_dma_buf))
 			return ERR_PTR(-EINVAL);
+		if (WARN_ON(exp_info->ops->match_mapping &&
+			    exp_info->ops->single_exporter_match))
+			return ERR_PTR(-EINVAL);
 	} else {
 		if (WARN_ON(!exp_info->ops->map_dma_buf ||
 			    !exp_info->ops->unmap_dma_buf))
@@ -1078,8 +1082,12 @@ struct dma_buf_attachment *dma_buf_mapping_attach(
 		if (ret)
 			goto err_attach;
 	} else {
-		ret = dma_buf_match_mapping(&match_args,
-					    &dma_buf_sgt_exp_compat_match, 1);
+		const struct dma_buf_mapping_match *exp_match =
+			dmabuf->ops->single_exporter_match;
+
+		if (!exp_match)
+			exp_match = &dma_buf_sgt_exp_compat_match;
+		ret = dma_buf_match_mapping(&match_args, exp_match, 1);
 		if (ret)
 			goto err_attach;
 	}
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 885e0e54b5eb..4aaddad8c7be 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -306,4 +306,19 @@ DMA_BUF_EMAPPING_SGT_P2P(const struct dma_buf_mapping_sgt_exp_ops *exp_ops,
 
 extern const struct dma_buf_mapping_match dma_buf_sgt_exp_compat_match;
 
+/*
+ * dma_buf_ops initializer helper for simple drivers that use a single
+ * SGT map/unmap operation without P2P.
+ */
+#define DMA_BUF_SIMPLE_SGT_EXP_MATCH(_map, _unmap)                       \
+	.single_exporter_match = &((const struct dma_buf_mapping_match){ \
+		.type = &dma_buf_mapping_sgt_type,                       \
+		.exp_ops = &((const struct dma_buf_mapping_sgt_exp_ops){ \
+			.map_dma_buf = _map,                             \
+			.unmap_dma_buf = _unmap,                         \
+		}.ops),                                                  \
+		.sgt_data = {                                            \
+			.exporter_requires_p2p = DMA_SGT_NO_P2P,         \
+		} })
+
 #endif
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 8bd5026eb642..d78eec3476f3 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -365,6 +365,15 @@ struct dma_buf_ops {
 	 */
 	const struct dma_buf_mapping_match *(*select_mapping)(
 		struct dma_buf_attachment *attach);
+
+	/**
+	 * @single_exporter_match:
+	 *
+	 * Should only be set by the DMA_BUF_SIMPLE_*_EXP_MATCH() helper macros.
+	 * Exactly one of @match_mapping or @single_exporter_match must be
+	 * provided.
+	 */
+	const struct dma_buf_mapping_match *single_exporter_match;
 };
 
 /**
-- 
2.54.0

