Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993127;
	b=gL343GxvPPb7/Z28dwcqPqyY+oLdnP9F+JimRD2Ik3UI5RsivG4/RsF4Q7qUln/m7cF8
	 eucByFV7fYLAJokO+uLoc/HjvTs+6v+lzIj2DXYqnO5pB5MrMM7SQKOh6XrFunTvjcl93
	 oeZojWj9sGxJp2FXnrJzC6udAyNiptwm5+w/wXMuzksaUYv9p5xLycKv/rOw7CGdaEjZK
	 wowGahakRoi0lAngkJMv8v+kbmTvGntNe2tQxXm15VHRaYG4ytPP4LY8vj2Ft0QeUbNXf
	 qm2C5N9mwLavaury3wF8dhLCoVRYPFOunJbfnx7XYJgHl26qJGrDr+dWwFfWs08G5rg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993127;
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
	bh=omjT3x4Mor9YKifck/IQ3Rn1pS/qkEztusBwXFWEUe0=;
	b=EP3OeevPj/uvPoz0yXgMF28gmmTCipyvTs8iGR8ysY9SgCWlqyOsN5UK2wlViguW9EMy
	 6qm3G5FqMtHYXPxFWETo0H55HGP7SL7dvEhmSNgxN8LNVZDest62LF1jpQkGHI/1H6SbY
	 EA1jtUyOGL5fQSUOPJ8PmDOt7p2BT3HYh5Ukz/B576ix/jS4mFVJEuz62lMw5b54Fq+Ff
	 QmaVSOQZ16aHEnVrKn+osKNjkG6hkxWtRIeWq13jmBWA3ELkj9dp+fnTBVzyVNK7bnWMH
	 4jqGwD4OkaNYquMcPqbAuSYO95ND4dWwbVxu9nW8bu4eIW78Ne752Uc3OpVTHpsyzdA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZAk2dXNT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.16
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010016.outbound.protection.outlook.com [52.101.56.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C76606A322;
	Mon, 26 Oct 2026 05:38:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8C76606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZAk2dXNT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q7+5jIYudsUjnF6yf04hvz+1SSB6b4bYgUrbwLMELbDI4SA/RKPKkQD3dG+WRHM3Lf6DzC4FuTaG+fCZzOq9LGpUa/7aUrYcMPgTgPQ9zsfCvczjYNq0wzzJ9711xgQ4Mu6L0MtYb3fCnJfXZj09iSYnFaHz/GlqtTGLgbi+1APt6iehFLp6i1tpn42CppjuaUGbz7m4c2XqYpetEyA51gRi5EJPd0vOEHFqBVv3afCkNh9MP9ySyU7kCHIrQ5E19TLSH1evk6Xv6YOcItWVFOj5gYoLnABEcbbSWcI50JhKdr040BgUrLib78aC2p3h/lgg+Zp5b9Xz17MJER/+HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=omjT3x4Mor9YKifck/IQ3Rn1pS/qkEztusBwXFWEUe0=;
 b=FeNac9Eol+I90c7Etxuoi8iNjGdl6xoY+oqpkQYLY1tKiOQb2hypIzPNILKA17ZljgfLvJG+mH4/2bRqDJQQ+1yaeuEksPkmL//AXWBeabA2WY+otvGcQ/9cHqitcl8eHULYeJCOe8RiTclOV2iqtJZecCPZcLc37MKqcEiEpGt6qbD/aUKRcE8yj8SqSZNbuP2WYJNn+UUKX9MvV7i9Jmg+V+3VpfVAERU96Fr7LBnrPRMY8jbByM+E4ez5iqZceoiAndT3SjxdigKer5bLjiUoV7C/WgSmWS8tJHRqHvgkbmRiHyIVBXChuMRWGWgxics3S9qQC4utM41fKtiWCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=omjT3x4Mor9YKifck/IQ3Rn1pS/qkEztusBwXFWEUe0=;
 b=ZAk2dXNT6kZPdxGPxBV4wBUW/7UZkEK2W+pfJsWSfE0TQfqMOLr7p9Zyts4foajL203WGhoGapIyEg0nd1dcKXTHNSh1El+HoWM7p2OD4hmcBUAN4PDm/jBzbyBn5chl3sZvsX6tgp7h2a8poJp3BZnHVYH/Cb2isDcH5NmG3XWFjNOGwpiRgky6i5gAd8XfUQdb8KRotw0MRXTMvXWK8Epu5cURoFwCTGYbMjk6zd2bPNnpn4ouXL7H2sw5onFBLJu32qR04c314Jo2HIUXGWmOSzjbgVbO6XQQZ79NZZ9ZMuZUA38RZ4uc4OKTlmDKyZVmkMx71mphUxD+QHnNtA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SJ0PR12MB6967.namprd12.prod.outlook.com
 (2603:10b6:a03:44b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:38:43 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:38:43 +0000
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
Subject: [PATCH 25/26] dma-buf: Add kunit tests for mapping type
Date: Mon, 26 Oct 2026 16:36:16 +1100
Message-ID: <20261026053623.202642-26-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5PR01CA0086.ausprd01.prod.outlook.com
 (2603:10c6:10:1f5::18) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|SJ0PR12MB6967:EE_
X-MS-Office365-Filtering-Correlation-Id: f75b264f-6854-4109-ef49-08df33236583
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|18002099003|22082099003|56012099006|11063799006|261022075727099003|261021121427099003|10067099003|261009223027099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	COEYSZrz1fhEnJT0NiTofSqT4vWaBw7tuZNw5Tn83CfnTj0QeZ/5lQTreKqaBs6Ht3doufN34u34c3AZ4wOuBL9Gt8oy2mGtCKrcWaV/y4OXkI1eotFH8d0qYo+s+atksROQwSaxg4nPqEsGh9L8qYjccvU/Osuza/iyOdJM/MiVCpMYhkjXzrtzEpwzm79SEAGezf4WQFcb0h7AfmNYHHSM2YFKNoYRpa5JswMcOdChORBxy4JU35p/+Czn1uke2vqbYF7K0h2hqcQyTryOYdatXTTr8y+qqY/cDdry+p2lS5QBg+JxmITgErVaj02uNKkQbC4xDnOkJaPGD7r3D1jXLLQAUEYmiOZeswxSbK5sGBm1uOT3mm+yzpkS/kd5PrBZzH4tFgsN0nY6NUR+ugrcxkBbVlxftlWnWx4H9bJxgKN1U/OFe1PjvcM2cpdblI9liqg5JYbLj87BPtey/wdX4jzKhehoeJRZc9opP5yztfb/eGJ1sQaG6NfSBZgc6mItpZwxFY0t8CP+IgDc8U491e0c8cJiVnMzEUlBVdvve11rc/F1Br3bw8b1jHiYh3wBIdd07wGPD9TCe7sARFzX/8HSgWFvd0BjjmAjj6usMxmWz0RxMznIbAor1lQAz8oDI9W+H5s/rhIISkYlxkG2uexj+IztXLiAO9xKo3w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(56012099006)(11063799006)(261022075727099003)(261021121427099003)(10067099003)(261009223027099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?signlY3OO1veHFKrWdCguYEYzr7i+jqVYB71w9lBPVG7/8nv0VK+X+IXRBWG?=
 =?us-ascii?Q?Lcujf1/AXTvlRnrr+DvPVko7OP0PnNMVucqIc7rdXSn9Jly5jIe90A7/0sT+?=
 =?us-ascii?Q?7RfZZ0OxQ2mehiV8vQdXA4aaJNq52gWtDsjOcmpyRweCwOD2aNo4T5Tsz/fn?=
 =?us-ascii?Q?NzVwVSKYhage799PIbXheuqSYq25vy9uGQUn7KP5I43A/1xIapROqMxaOw0D?=
 =?us-ascii?Q?/5HeihLfqAAnpDECERSQtG2xvc6QLe0RpBijywQ1rTMjzKv7S6KJ2qMt8FVB?=
 =?us-ascii?Q?KsPkL6Tb09I8z0YNO05RzmBS4NJ7/eWfo0CeaABAFFNlmm3k4jFYU0WH97cM?=
 =?us-ascii?Q?BcNxTFLn215aMCmm7g00L8BWgK1khvdopH3Q4yiDHXFCYqRMQvTK6gYwTRZh?=
 =?us-ascii?Q?3F0NZqCGCPtxGVlfy031LsccuyyAs/UAUiJjtsMQmHJ3Rd6IZo5OPq4wiYbv?=
 =?us-ascii?Q?6x6YI2ukWv5Jvwu7gwGBN5YA7Jpuk4LdiVUfIPi4pj5GfL8lmyAn/tHj6tGK?=
 =?us-ascii?Q?szsJTFnOCvv5NZqsH+Qshn6eghJWqik6Kxl7bNc6bJzrYklkaTgQq9YQLDgn?=
 =?us-ascii?Q?9uLoHEeGQHrRk5DkOR98TqsFCrXovrrEViVWsSSMdz9DhGhQfTHICcpDuJ8q?=
 =?us-ascii?Q?OjNFoz9Jc0pNtLJX8/hRdwG45RI+oenedH080t5QHnAc3V1NqByktAMmujM+?=
 =?us-ascii?Q?3Nupcqh2Q1TahEx4cr/veUWsjnYSkqkWun4Q/bPX0gmmsP/ctIe5KV7Bu2+z?=
 =?us-ascii?Q?pqHfjeN95gjnjNmpKfsKgBZAqxqV7PaXc708U4JgrGRESPb/CCWx0VTopuay?=
 =?us-ascii?Q?imwI8t0xK+1T3Sk7HA5c9ArtWa72ICSG7wZe2+ztfSjU61Kxv9IwkThb4mOh?=
 =?us-ascii?Q?vJ3NPqDYfJBa8/MHxIK6zoLL0eMYc0tlCpFBqAJJIFkyeS3MitpQ0nQ0UR0X?=
 =?us-ascii?Q?RR4RyEhPlpn3caA+/BEWrZzt4K7LaVcDQE/N6aBVDhouyvXWhU74IwY9qE9B?=
 =?us-ascii?Q?8inTES0xPjUzQlXvQFu6y4vJyx5Vs0e8RTuA1td4P2EHqm5TUeUFx/zG9jXD?=
 =?us-ascii?Q?5bDjI/AoiORJEJ/RHTJpAa8ZpYXnEmS+hs5H8SISf7tsKpMVAGfara3OgMPV?=
 =?us-ascii?Q?q5DLnHRz7UuQZiOmZ9g9KeqyI7IvO22QM/r0VkfnCbT9CZBqWHsD9kDWPwEs?=
 =?us-ascii?Q?bmMt/fEeHOsXrD476GrDWUa1Kig9pAgnyGlfYBE5uVFzUH0EvM3bH2mW7iiT?=
 =?us-ascii?Q?/eKK5Inwiw3e1XzVQX7qzE1apRHEAGh2VErLl/RteeucigbJ2aqlCdAlar8S?=
 =?us-ascii?Q?02tubNMxFusWzw2p0hnLBFCHSSGa6emJZjn4vzasi8bfEwwewmO0Pm9DvMcx?=
 =?us-ascii?Q?LgUp8dbL62UOmHQcv/WFJyOKlJJCbpsnalRWT6y8kcz2lW75PT378EWhfe0L?=
 =?us-ascii?Q?0oTQsOMURAEIREhufuHmq1qKdSs8zO6jMHBEdgKgrvi8XCSUwkvRnmAjntLm?=
 =?us-ascii?Q?AF0+oMpnorCUd5LRpmZX4hT2Q7aqgvrt1UQtBQD8SiNZMl2nnAmBjmj7B5of?=
 =?us-ascii?Q?mhsghk/JSDxrqrSCkaoMI9oZj8uRJOydiyWNiLeFA8g5utMwVCN9MrLmQ5fI?=
 =?us-ascii?Q?lpqJ3kvXvGE5kdpFuq2Y4IkUxyZ6cejEUJRQBlHJXriu1L6ui+cx7M4pU9Hs?=
 =?us-ascii?Q?deBb7cnn+rNLJFqT5gcgoYztqPcq/5R6SUgoka31qT/hB1cUx8lB5vc/upol?=
 =?us-ascii?Q?PjjtP4GiTQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f75b264f-6854-4109-ef49-08df33236583
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:38:43.0623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nvp2zJAG1tXwzHkd275b5CzBNlPBBXJmSn3h3NbA3yxv5H7bGvOsFYvVE93WlcRuEwErG0Y6tZgsksqMx5wjMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6967

From: Jason Gunthorpe <jgg@nvidia.com>

Some basic coverage of common flows:
 - Check dma_buf_match_mapping()'s rules. These choices effectively
   become driver facing API and it would be a pain to change them later
 - Test the dma_bug_sgt attachment flow to see that the new wrappers work

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ .move_notify renamed to .invalidate_mappings - apopple ]
[ dma_buf_match_mapping() records every compatible pair into the
  attachment instead of stopping at the first, so every test passes an
  attachment and the priority tests assert the recorded match set - apopple ]
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/Makefile         |   1 +
 drivers/dma-buf/st-dma-mapping.c | 385 +++++++++++++++++++++++++++++++
 2 files changed, 386 insertions(+)
 create mode 100644 drivers/dma-buf/st-dma-mapping.c

diff --git a/drivers/dma-buf/Makefile b/drivers/dma-buf/Makefile
index b25d7550bacf..92fce1b5e2e0 100644
--- a/drivers/dma-buf/Makefile
+++ b/drivers/dma-buf/Makefile
@@ -11,6 +11,7 @@ dmabuf_kunit-y := \
 	st-dma-fence.o \
 	st-dma-fence-chain.o \
 	st-dma-fence-unwrap.o \
+	st-dma-mapping.o \
 	st-dma-resv.o
 
 obj-$(CONFIG_DMABUF_KUNIT_TEST) += dmabuf_kunit.o
diff --git a/drivers/dma-buf/st-dma-mapping.c b/drivers/dma-buf/st-dma-mapping.c
new file mode 100644
index 000000000000..9d0f1e389e15
--- /dev/null
+++ b/drivers/dma-buf/st-dma-mapping.c
@@ -0,0 +1,385 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for dma_buf_match_mapping()
+ */
+
+#include <kunit/device.h>
+#include <kunit/test.h>
+#include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
+#include <linux/errno.h>
+
+/* Mock tracking state -- reset before each test */
+static bool mock_match_called;
+static const struct dma_buf_mapping_match *mock_match_exp_arg;
+static const struct dma_buf_mapping_match *mock_match_imp_arg;
+static int mock_match_ret;
+
+static bool mock_finish_called;
+static const struct dma_buf_match_args *mock_finish_args_arg;
+static const struct dma_buf_mapping_match *mock_finish_exp_arg;
+static const struct dma_buf_mapping_match *mock_finish_imp_arg;
+
+static int reset_mock_state(struct kunit *test)
+{
+	mock_match_called = false;
+	mock_match_exp_arg = NULL;
+	mock_match_imp_arg = NULL;
+	mock_match_ret = 0;
+	mock_finish_called = false;
+	mock_finish_args_arg = NULL;
+	mock_finish_exp_arg = NULL;
+	mock_finish_imp_arg = NULL;
+	return 0;
+}
+
+static int mock_match(struct dma_buf *dmabuf,
+		      const struct dma_buf_mapping_match *exp,
+		      const struct dma_buf_mapping_match *imp)
+{
+	mock_match_called = true;
+	mock_match_exp_arg = exp;
+	mock_match_imp_arg = imp;
+	return mock_match_ret;
+}
+
+static void mock_finish_match(struct dma_buf_match_args *args,
+			      const struct dma_buf_mapping_match *exp,
+			      const struct dma_buf_mapping_match *imp)
+{
+	mock_finish_called = true;
+	mock_finish_args_arg = args;
+	mock_finish_exp_arg = exp;
+	mock_finish_imp_arg = imp;
+
+	args->attach->map_type = (struct dma_buf_mapping_match){
+		.type = exp->type,
+		.exp_ops = exp->exp_ops,
+	};
+}
+
+/* Type with both match and finish_match callbacks */
+static struct dma_buf_mapping_type mock_type_a = {
+	.name = "mock_type_a",
+	.match = mock_match,
+	.finish_match = mock_finish_match,
+};
+
+/* Second type -- distinct pointer identity from A */
+static struct dma_buf_mapping_type mock_type_b = {
+	.name = "mock_type_b",
+	.match = mock_match,
+	.finish_match = mock_finish_match,
+};
+
+static void test_match_fail(struct kunit *test)
+{
+	struct dma_buf_mapping_match matches[] = { { .type = &mock_type_a } };
+	struct dma_buf_mapping_match exp[] = { { .type = &mock_type_b } };
+	struct dma_buf_attachment attach = {};
+	struct dma_buf_match_args args = {
+		.attach = &attach,
+		.imp_matches = matches,
+		.imp_len = ARRAY_SIZE(matches),
+	};
+
+	/* Zero-length exporter array returns -EINVAL */
+	KUNIT_EXPECT_EQ(test, dma_buf_match_mapping(&args, NULL, 0), -EINVAL);
+	KUNIT_EXPECT_FALSE(test, mock_match_called);
+	KUNIT_EXPECT_FALSE(test, mock_finish_called);
+
+	/* Zero-length importer array returns -EINVAL */
+	args = (struct dma_buf_match_args){ .attach = &attach };
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, matches,
+					      ARRAY_SIZE(matches)),
+			-EINVAL);
+	KUNIT_EXPECT_FALSE(test, mock_match_called);
+	KUNIT_EXPECT_FALSE(test, mock_finish_called);
+
+	/* Different types produce no match */
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, exp, ARRAY_SIZE(exp)),
+			-EINVAL);
+	KUNIT_EXPECT_FALSE(test, mock_match_called);
+	KUNIT_EXPECT_FALSE(test, mock_finish_called);
+}
+
+/* When type->match() is NULL same types always match */
+static void test_match_no_match_callback(struct kunit *test)
+{
+	static struct dma_buf_mapping_type mock_type_no_match = {
+		.name = "mock_type_no_match",
+		.finish_match = mock_finish_match,
+	};
+	struct dma_buf_mapping_match matches[] = {
+		{ .type = &mock_type_no_match }
+	};
+	struct dma_buf_attachment attach = {};
+	struct dma_buf_match_args args = {
+		.attach = &attach,
+		.imp_matches = matches,
+		.imp_len = ARRAY_SIZE(matches),
+	};
+
+	KUNIT_EXPECT_EQ(
+		test,
+		dma_buf_match_mapping(&args, matches, ARRAY_SIZE(matches)), 0);
+	KUNIT_EXPECT_FALSE(test, mock_match_called);
+	KUNIT_EXPECT_TRUE(test, mock_finish_called);
+	KUNIT_EXPECT_PTR_EQ(test, mock_finish_args_arg, &args);
+	KUNIT_EXPECT_PTR_EQ(test, mock_finish_exp_arg, &matches[0]);
+	KUNIT_EXPECT_PTR_EQ(test, mock_finish_imp_arg, &matches[0]);
+}
+
+static void test_match_callback_returns(struct kunit *test)
+{
+	struct dma_buf_mapping_match matches[] = { { .type = &mock_type_a } };
+	struct dma_buf_attachment attach = {};
+	struct dma_buf_match_args args = {
+		.attach = &attach,
+		.imp_matches = matches,
+		.imp_len = ARRAY_SIZE(matches),
+	};
+
+	/* type->match() returns -EOPNOTSUPP. Skips to next */
+	mock_match_ret = -EOPNOTSUPP;
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, matches,
+					      ARRAY_SIZE(matches)),
+			-EINVAL);
+	KUNIT_EXPECT_TRUE(test, mock_match_called);
+	KUNIT_EXPECT_FALSE(test, mock_finish_called);
+
+	/* type->match() returns an error code. Stops immediately, returns code */
+	mock_match_ret = -ENOMEM;
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, matches,
+					      ARRAY_SIZE(matches)),
+			-ENOMEM);
+	KUNIT_EXPECT_TRUE(test, mock_match_called);
+	KUNIT_EXPECT_FALSE(test, mock_finish_called);
+}
+
+/*
+ * The match set records every compatible pair, in the exporter's order. The
+ * first entry is the default selection.
+ */
+static void test_match_exporter_priority(struct kunit *test)
+{
+	struct dma_buf_mapping_match exp1[2] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match exp2[] = { { .type = &mock_type_b } };
+	struct dma_buf_mapping_match imp[2] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_attachment attach = {};
+	struct dma_buf_match_args args = {
+		.attach = &attach,
+		.imp_matches = imp,
+		.imp_len = ARRAY_SIZE(imp),
+	};
+
+	/* Both match, exporter order preserved, first is the default */
+	KUNIT_EXPECT_EQ(
+		test, dma_buf_match_mapping(&args, exp1, ARRAY_SIZE(exp1)), 0);
+	KUNIT_ASSERT_EQ(test, attach.nr_matches, 2);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[0].type, &mock_type_a);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[1].type, &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, attach.map_type.type, &mock_type_a);
+
+	/* Only the second importer type is offered */
+	KUNIT_EXPECT_EQ(
+		test, dma_buf_match_mapping(&args, exp2, ARRAY_SIZE(exp2)), 0);
+	KUNIT_ASSERT_EQ(test, attach.nr_matches, 1);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[0].type, &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, attach.map_type.type, &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, mock_finish_imp_arg, &imp[1]);
+}
+
+/* The exporter's order wins over the importer's */
+static void test_match_importer_priority(struct kunit *test)
+{
+	struct dma_buf_mapping_match exp[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp1[] = { { .type = &mock_type_b } };
+	struct dma_buf_mapping_match imp2[] = {
+		{ .type = &mock_type_b },
+		{ .type = &mock_type_a },
+	};
+	struct dma_buf_attachment attach = {};
+	struct dma_buf_match_args args = {
+		.attach = &attach,
+		.imp_matches = imp1,
+		.imp_len = ARRAY_SIZE(imp1),
+	};
+
+	/* Single importer type */
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, exp, ARRAY_SIZE(exp)), 0);
+	KUNIT_ASSERT_EQ(test, attach.nr_matches, 1);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[0].type, &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, mock_finish_imp_arg, &imp1[0]);
+
+	/* Importer prefers B, exporter prefers A: A is the default */
+	args.imp_matches = imp2;
+	args.imp_len = ARRAY_SIZE(imp2);
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, exp, ARRAY_SIZE(exp)), 0);
+	KUNIT_ASSERT_EQ(test, attach.nr_matches, 2);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[0].type, &mock_type_a);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[1].type, &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, attach.map_type.type, &mock_type_a);
+}
+
+static void mock_dmabuf_release(struct dma_buf *dmabuf)
+{
+}
+
+static struct sg_table *mock_map_dma_buf(struct dma_buf_attachment *attach,
+					 enum dma_data_direction dir)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static void mock_unmap_dma_buf(struct dma_buf_attachment *attach,
+			       struct sg_table *sgt,
+			       enum dma_data_direction dir)
+{
+}
+
+static const struct dma_buf_mapping_sgt_exp_ops mock_sgt_ops = {
+	.map_dma_buf = mock_map_dma_buf,
+	.unmap_dma_buf = mock_unmap_dma_buf,
+};
+
+static const struct dma_buf_ops mock_dmabuf_simple_sgt_ops = {
+	.release = mock_dmabuf_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(mock_map_dma_buf, mock_unmap_dma_buf),
+};
+
+static int mock_dmabuf_match_mapping(struct dma_buf_match_args *args)
+{
+	struct dma_buf_mapping_match sgt_match[2];
+	unsigned int num_match = 0;
+
+	sgt_match[num_match++] =
+		(struct dma_buf_mapping_match){ .type = &mock_type_a };
+
+	sgt_match[num_match++] = DMA_BUF_EMAPPING_SGT(&mock_sgt_ops);
+
+	return dma_buf_match_mapping(args, sgt_match, ARRAY_SIZE(sgt_match));
+}
+
+static const struct dma_buf_ops mock_dmabuf_two_exp_ops = {
+	.release = mock_dmabuf_release,
+	.match_mapping = mock_dmabuf_match_mapping,
+};
+
+struct dma_exporter {
+	const struct dma_buf_ops *ops;
+	const char *desc;
+};
+
+static struct dma_buf *mock_dmabuf_export(const struct dma_buf_ops *ops)
+{
+	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
+
+	exp_info.ops = ops;
+	exp_info.size = PAGE_SIZE;
+	exp_info.priv = ERR_PTR(-EINVAL);
+	return dma_buf_export(&exp_info);
+}
+
+/*
+ * Check that a simple SGT exporter with single_exporter_match works with
+ * dma_buf_sgt_attach()
+ */
+static void test_sgt_attach(struct kunit *test)
+{
+	const struct dma_exporter *param = test->param_value;
+	struct dma_buf *dmabuf;
+	struct dma_buf_attachment *attach;
+	struct device *dev;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(param->ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	attach = dma_buf_sgt_attach(dmabuf, dev);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+
+	KUNIT_EXPECT_PTR_EQ(test, attach->map_type.type,
+			    &dma_buf_mapping_sgt_type);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_sgt_dma_device(attach), dev);
+	KUNIT_EXPECT_FALSE(test, dma_buf_sgt_p2p_allowed(attach));
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+}
+
+static void mock_move_notify(struct dma_buf_attachment *attach)
+{
+}
+
+static const struct dma_buf_attach_ops mock_importer_ops = {
+	.invalidate_mappings = &mock_move_notify,
+};
+
+/* Check a dynamic attach with a non-sgt mapping type */
+static void test_mock_attach(struct kunit *test)
+{
+	struct dma_buf_mapping_match imp[] = { { .type = &mock_type_a } };
+	struct dma_buf *dmabuf;
+	struct dma_buf_attachment *attach;
+	struct device *dev;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_two_exp_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	attach = dma_buf_mapping_attach(dmabuf, imp, ARRAY_SIZE(imp),
+					&mock_importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+
+	KUNIT_EXPECT_PTR_EQ(test, attach->map_type.type, &mock_type_a);
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+}
+
+static const struct dma_exporter dma_exporter_params[] = {
+	{ &mock_dmabuf_simple_sgt_ops, "simple_sgt" },
+	{ &mock_dmabuf_two_exp_ops, "two_exp" },
+};
+KUNIT_ARRAY_PARAM_DESC(dma_exporter, dma_exporter_params, desc);
+
+static struct kunit_case dma_mapping_cases[] = {
+	KUNIT_CASE(test_match_fail),
+	KUNIT_CASE(test_match_no_match_callback),
+	KUNIT_CASE(test_match_callback_returns),
+	KUNIT_CASE(test_match_exporter_priority),
+	KUNIT_CASE(test_match_importer_priority),
+	KUNIT_CASE_PARAM(test_sgt_attach, dma_exporter_gen_params),
+	KUNIT_CASE(test_mock_attach),
+	{}
+};
+
+static struct kunit_suite dma_mapping_test_suite = {
+	.name = "dma-buf-mapping",
+	.init = reset_mock_state,
+	.test_cases = dma_mapping_cases,
+};
+
+kunit_test_suite(dma_mapping_test_suite);
+
+MODULE_IMPORT_NS("DMA_BUF");
-- 
2.54.0

