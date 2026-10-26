Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.62
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993049;
	b=F+32mR2dKd7Hq6bxgBSU5n02Ni69/FUcyH7oIY+HBLBXzY/OMZ+RCPLx+Nijqrg6Ampy
	 OBoSNjFbcK1bGjez3TDnAuDFlAxBTMPdS1jfw7IKUjGYvE4KMppDUle556IPs1obnKHoB
	 8qyriV4jX1mU64dUUUveuA6VJ/MXYa78O6Q4XKWA2goqf3RGbEBnD6vd5Lfrf5ootPB5x
	 +2+ujMxy6ACF7V3DFJiSBYB7RieqpD1lZsoreBJ2HEKZU/w3EbR+Y3X/EsISUtqmzFVmT
	 Y2sZG0vtWY5j+WKj4ziU1HqMuSxUC9ohrqQzFKkLFrWc6N+zd5sRj0HiPz24n4GUHKw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993049;
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
	bh=3bp1bDzM3Z2wdxeBifnzX+g5SsEqmGsSgeTtPBTL9xA=;
	b=KBiJVdMahhWVv0R4hoP46wegE3tJaQaNzuX+6NV6trgjxUEwJS7IE65hGEcajEL4tlHF
	 katm7xL/rdY1kDDSzOlcbUYrXuzxilbQpHE7MS4IHktnVXjsLXsYnQmH7HA2hEkAtEF0G
	 akF/2Avdbb2fQREEsc1GeomKffWy8Sow2X4vkLKVELJVslZ4qECncXV/sh1ZDhoHZy4js
	 b1GMloayosTv+ZhbaXJccmpjf5oThjFljc/6XvdC7+LPa7by4YkVOHRCI8CB7E43p/db0
	 y11JlGkTH7MLaRqzwysT390oGuSYegEDylqPMOU1kjBAGJU9zH0V7IQ1xQDDkEkhPTg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JMnxzF9g;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.62
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011062.outbound.protection.outlook.com [52.101.62.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005BF60A2628;
	Mon, 26 Oct 2026 05:37:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 005BF60A2628
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JMnxzF9g
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qJWa6QuXIzgA5MII9lTVpJ0TlUfhp436jsfYoP9u59GkrpxulxXDtcDih/1OjdVrnDbNkm6WAOpIPpdJO1afgtYSxcZd6kihiOlpjTWRPCJ6sDufKTtnoGtgDpBQ3jGrb9i8repIKVh8BrtTt3JI+wXieoZ22H/103dvp7ws6g/Cy6zM6fN//x6XGHk8OAHawLYmrETsqhODwzTnLjkBzlgOpTo/2rRh30XoAXXsk89opFdCzo1jaWy3ovQHt0ntstgYVfhPsPNO+5rM1M4/B0KwyAT5t2oS4RSvZ6rxca5PmN9PFbkkQB9RuFxFXlA42Ej11Q/1A4a+A8z4h7Bz7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3bp1bDzM3Z2wdxeBifnzX+g5SsEqmGsSgeTtPBTL9xA=;
 b=e7pm/q6cXdML+a7PCybSqB2WtCNjOkd2g/KNgs8ipoyWgXJzrog3gjEiuqqfweowhRxOLhBJUJkeIT0n+pfMxxiaoxueKyTmy6dbR3c+HE5fR0Fzmlkoumidak8zfWLRaWnzdno1Quc6mu1SCXzm4rzG1OVT8bXzawm8/M+rjOVbRW/kR/y1MIpS2fYu7d+S/X+zSOnRN1btmvzmJe4OiKhJSmFO1klwp8Nt+mSjDecYVvvbgk12pmq/DO4e9f6fsicuj0gvEO5eWETYFbl2kGAO1Gi1tUekyKuTfEMlVIXnlwNvnOEWrwe/DGD1DBcSZYTMWiJwqZ6SYCmmrZSmqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3bp1bDzM3Z2wdxeBifnzX+g5SsEqmGsSgeTtPBTL9xA=;
 b=JMnxzF9g/hZb9ZE7GAj5zEKGCGc8+rombDn++VMM7mk4gwZInt4GkJCkl2zuP3eVA0BgmybfpTSBFT+uVKAPdkEgyGN2M1WpCTZkt216v3ekq+pmsKSYjEBaoeeFKLmUHjjGEhBuMaUWHYU4WI+tKzdjZyRx69H/n5h/57CuC40AWJHwlw2kT3jUyxojHifX8U0UHYzvseRgHVPbPHTDjWJ8UpmoFHHjhVc0AlzZWtqHX+/ZQUNXm8KnEdC8cKp0yMnSFzzK3CultfCA3BUytcP0a/yACUfaVqxWrwknyZyKRg6TeJEv1F1G+DAEs7FnNsJiGWyfJ6LXmNkBT67N9g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SA1PR12MB7442.namprd12.prod.outlook.com
 (2603:10b6:806:2b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:37:11 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:37:11 +0000
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
Subject: [PATCH 07/26] dma-buf: Add dma_buf_mapping_map() returning a type-tagged mapping
Date: Mon, 26 Oct 2026 16:35:58 +1100
Message-ID: <20261026053623.202642-8-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5PR01CA0092.ausprd01.prod.outlook.com
 (2603:10c6:10:207::6) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 55f310ec-38f9-4070-b5dd-08df33232ea6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|6133799003|22082099003|56012099006|11063799006|5023799004|261022075727099003|10067099003|261009223027099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	S0YiP59vwDyPQKfLeZnOF7/lIwF0fIpaUgr/V20NyqKJCvskwfnJf9v70GLKTSbAewOWMjkHRG+KNQAipyf+ZPh+v0pAO043TV6zdfxsHOzmSUyMsjJowLhweBvBHnbjkVQPk00wirDktucnQ0Ua5ljJBdJazCMzf7OXn1+zaeSUv1TOModD4hN7uFuEOcvZolW6vRAWWX5ppXI6J3gmaiblcd7qiKdAi61HffT0NJ78zgV/SmayD9BBFbNE9/aaJW7muNGhJAolPPmeqTs45u0DVai1SmVEiAOgWkzVO+pgRqQ1fRDOG3KCYnqt/bK8kp6OVTagOwML2RDRjmlra16YrxYtOY9ePhcf91Z8A4R5CFEXnGsMty+oArVyn60UJmqsKF9eNCuRZkwimLB110x84ieZZzo9M/5vKrnrAdN2SbR+rx2JFowvFHZ3lbl+zhYuoTolQjQ7I9xwcEAUUoF4M/9W4Vy2ScFVr9srBFUX0b+6i5Ca6XDNdaEcrnGcSmG1VZLs7amClYRD2kxeq8qbD34PGYKI7HqizEsbTWgpFIwEKlOu2SIdHs51VdIcf54oqrub2YU9EDCwNsK4xvjBmV4ceLVRdSi5zCwhm8FlSw/nLPrNx0Tb/MKV/9BfZvkV4xDTONl/pcFaYdpI3Um7u6tEoMyYDaBFwEy9CG4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(6133799003)(22082099003)(56012099006)(11063799006)(5023799004)(261022075727099003)(10067099003)(261009223027099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6a8tjwOjeUgVFqIX7PrNQPrcOnWN0K8S59yG9+RfQ8Mjuik8fja8Ds6FQt+Y?=
 =?us-ascii?Q?g3wzkLwJCwaPwypjUvm1WIm0ERTa9yEzO52vu/QDGlTsxHLbbBuSjPy1XZK5?=
 =?us-ascii?Q?IuEL6hlTMwUWPbG3IfLaGEh7Qtp9mHe35nRHwt5HEaa4HQU79Bs/KDmi7WQl?=
 =?us-ascii?Q?/eeC57SJzatZK1cDaq4yQEuaKFGMBEA7qv2ci1BiO89EkVX/jDXwPa0Kxf/b?=
 =?us-ascii?Q?NjP/fbMOAeBMhWRZnnxAUPAEp4UQwpl1qzpUp+4Z5/DuYXePHBO/0MbHjr8P?=
 =?us-ascii?Q?He47sIk5wS7H0lt4Jw3FTsuvCM9eBREMn1ck5h8CU0AOPCBIMeg8KU39Nxt2?=
 =?us-ascii?Q?rtJehRxcVBAA4/KG3Bnd7cCqnJ9BmYqkF1DCwvETQmIBL54nwgcZhsAgjGx2?=
 =?us-ascii?Q?EMSgeoP1hETlAMh/4QZWYBWtDT7V7G+VAuyKq5TrC0g2tWUw1sbprfLYPdLQ?=
 =?us-ascii?Q?Oe+CgaGRQDNnYi0owmJymFVJLdKByTaaevv0IpyFUi4H7n2riaAG1OhW9i4c?=
 =?us-ascii?Q?RWbjIgIxi9mRGdhseL03pw+Et5R5pwfYMdXRuVeeIbON51/Gr9x8Q0lGXymf?=
 =?us-ascii?Q?kPTB606grBFoxFCFsd2fjA7/jTjHxuVpA2LGrTzF+H+2/4yUd4v9sTFEms4H?=
 =?us-ascii?Q?Ms6jdTLP7qz3FJAJsyrXXI56CpnZ66Kl48JUalnqfHipA2l1RMUJ5kGMoxxO?=
 =?us-ascii?Q?vjAWo3IJpEXZ3nS1t45Q1UfQZF8dU68whBfytheCEKCGLs0QVNc0L5vhgx2e?=
 =?us-ascii?Q?74AI1j9OgLxvuPXErm1jgPCi/HcX2CvljdXz1p2I2Oq4yDenI+yWZmDjt13y?=
 =?us-ascii?Q?6jWmU9oBfsPpC7qeyxi1pib3OZBR2A5TguJaA3i4q7zTHDnPSlPHXvPpGNTj?=
 =?us-ascii?Q?1WhpqOc7WCs4RC1f90s6ICa2bOh8utEPTmkADdO0j9nJUgIUG8h5ToPgM5Ih?=
 =?us-ascii?Q?DfvwwoqfCvvw1Bk2TNxWZn7L9Ib8BuNsnuvVd7AaIh0qk7pj8U3hhRXy6j7i?=
 =?us-ascii?Q?70KDFgQKtGiRQGS/UaTDaGCQeMncrlmPof2VUxs4T66k10cfiPifkmt1p7Vn?=
 =?us-ascii?Q?GHzy5CFUx2v5PlRnCXkB2Fwih+MO6ZRL9Sekoj8ZlVGKMsDWBttptQpZxZQ3?=
 =?us-ascii?Q?72uUrSXe2oXncNt8Y5u8No1Vqb16PhLRedyE9xBcULElir+XyYB8CaJcxu3R?=
 =?us-ascii?Q?5kmAVvonc1aCHoCBcjQFbFpl1mcMj80mq9RzexO9Tru0KIw1deUcmj5TRCz2?=
 =?us-ascii?Q?5UABxNdX0oPbQRyOnZpOHbTaPMWpNR3W47+bfB1np46PblSA2Usxcik9ebK4?=
 =?us-ascii?Q?hHiZZcAmqIVzMWK2sP40lXFpQHKlhPLhfgce/gp04uFkn6Qyqn84iOoRw5XI?=
 =?us-ascii?Q?kJ9lk4DtEWoOqmhZ8S6VLLgL0Ds0XOpXTFV/zmMcEOpfiPEd7DRiC6eMzL2J?=
 =?us-ascii?Q?tj0Cdcme2F/jSoXTMmfPWycli4r8Pp5qtQcbfMDmN2bkvcYoRt7haBoV01+o?=
 =?us-ascii?Q?FQ0jj4tBPmRxhsSx35qHCifJC0svgL8FptgBPE48KoMh7DcTk/LCQ5npqwFM?=
 =?us-ascii?Q?SAQC/B/RmnX80oPYwWlW2DniWem7psdd6KFMGZ5Q8bP/Sg3Xha/l2F6Rv1th?=
 =?us-ascii?Q?WQ7Ux+99hEo2iMbZkchngOH4X87Pxcjjo/dq7nSNpWF/rNaDz/eOt6Jd6f4I?=
 =?us-ascii?Q?qSxhsa/lml1e2N/EcZ7mlsBpdqbylp1/+z+j8ceISnm8OzlhW6sTptbcfgBx?=
 =?us-ascii?Q?a1J1uP2GaA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f310ec-38f9-4070-b5dd-08df33232ea6
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:37:11.0120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fB0HtonACV39H7z8/ALD8LNs0VrilhLoGduZZpi4QwBg5wvxY2QCoya3qUMTTgp7/xz37ApLzvU1Kr95rap8eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7442

An importer that lists more than one mapping type cannot know which
type-specific map function to call, because the exporter selects the
type at map time. Create a generic entry point to determine the correct
type.

dma_buf_mapping_map() selects via dma_buf_mapping_select() and dispatches
to a map op on struct dma_buf_mapping_type. That returns a struct
dma_buf_mapping carrying the type, embedded in the type's own
result struct. dma_buf_mapping_unmap() hands it back through the type's
unmap op.

To support existing SGT importers the SGT type implements both. Its
result is struct dma_buf_sgt_mapping with the sg_table reachable through
dma_buf_sgt_mapping_table(). The sgt map body is shared with the SGT
type's map function which remains the entry point for importers listing
only SGT.

Assisted-by: LLM
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c | 75 +++++++++++++++++++++++++++++++
 drivers/dma-buf/dma-buf.c         | 33 ++++++++++++++
 include/linux/dma-buf-mapping.h   | 63 ++++++++++++++++++++++++++
 3 files changed, 171 insertions(+)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index dbcd83b6dcff..7a5a379a372e 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -366,6 +366,79 @@ int dma_buf_mapping_select(struct dma_buf_attachment *attach)
 	return 0;
 }
 
+/**
+ * dma_buf_mapping_map - Map an attachment with whichever type the exporter
+ *                       selects
+ * @attach: the attachment
+ * @dir: DMA direction
+ *
+ * For importers that listed more than one mapping type. The exporter picks the
+ * type from the possible matches and the result's &dma_buf_mapping.type records
+ * which was used. Must be called with the dma_resv lock held, and the lock must
+ * be held until the result has been acted on. Importers that listed a single
+ * type keep using that type's map function.
+ *
+ * Returns: a &struct dma_buf_mapping to pass to dma_buf_mapping_unmap(), or
+ * an ERR_PTR.
+ */
+struct dma_buf_mapping *dma_buf_mapping_map(struct dma_buf_attachment *attach,
+					    enum dma_data_direction dir)
+{
+	struct dma_buf_mapping *mapping;
+	int ret;
+
+	might_sleep();
+
+	if (WARN_ON(!attach || !attach->dmabuf))
+		return ERR_PTR(-EINVAL);
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	ret = dma_buf_mapping_select(attach);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (!attach->map_type.type->map) {
+		ret = -EOPNOTSUPP;
+		goto err_release;
+	}
+
+	mapping = attach->map_type.type->map(attach, dir);
+	if (IS_ERR(mapping)) {
+		ret = PTR_ERR(mapping);
+		goto err_release;
+	}
+
+	return mapping;
+
+err_release:
+	/* Nothing was established, so the choice may be made afresh */
+	attach->selected = false;
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_map, "DMA_BUF");
+
+/**
+ * dma_buf_mapping_unmap - Release a mapping from dma_buf_mapping_map()
+ * @attach: the attachment
+ * @mapping: what dma_buf_mapping_map() returned
+ * @dir: DMA direction used for the map
+ */
+void dma_buf_mapping_unmap(struct dma_buf_attachment *attach,
+			   struct dma_buf_mapping *mapping,
+			   enum dma_data_direction dir)
+{
+	might_sleep();
+
+	if (WARN_ON(!attach || !attach->dmabuf || !mapping))
+		return;
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	mapping->type->unmap(attach, mapping, dir);
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_unmap, "DMA_BUF");
+
 static int dma_buf_sgt_match(struct dma_buf *dmabuf,
 			     const struct dma_buf_mapping_match *exp,
 			     const struct dma_buf_mapping_match *imp)
@@ -427,6 +500,8 @@ struct dma_buf_mapping_type dma_buf_mapping_sgt_type = {
 	.match = dma_buf_sgt_match,
 	.finish_match = dma_buf_sgt_finish_match,
 	.debugfs_dump = dma_buf_sgt_debugfs_dump,
+	.map = dma_buf_sgt_type_map,
+	.unmap = dma_buf_sgt_type_unmap,
 };
 EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_sgt_type, "DMA_BUF");
 
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 03f06c4b957c..90699e85e4c8 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1353,6 +1353,39 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_map_attachment, "DMA_BUF");
 
+/* &dma_buf_mapping_type.map / .unmap for the SGT type */
+struct dma_buf_mapping *dma_buf_sgt_type_map(struct dma_buf_attachment *attach,
+					     enum dma_data_direction dir)
+{
+	struct dma_buf_sgt_mapping *mapping;
+	int ret;
+
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping)
+		return ERR_PTR(-ENOMEM);
+
+	mapping->base.type = &dma_buf_mapping_sgt_type;
+	mapping->sgt = __dma_buf_sgt_map_attachment(attach, dir);
+	if (IS_ERR(mapping->sgt)) {
+		ret = PTR_ERR(mapping->sgt);
+		kfree(mapping);
+		return ERR_PTR(ret);
+	}
+
+	return &mapping->base;
+}
+
+void dma_buf_sgt_type_unmap(struct dma_buf_attachment *attach,
+			    struct dma_buf_mapping *base,
+			    enum dma_data_direction dir)
+{
+	struct dma_buf_sgt_mapping *mapping =
+		container_of(base, struct dma_buf_sgt_mapping, base);
+
+	dma_buf_unmap_attachment(attach, mapping->sgt, dir);
+	kfree(mapping);
+}
+
 /**
  * dma_buf_map_attachment_unlocked - Returns the scatterlist table of the attachment;
  * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 494bc29910f4..885e0e54b5eb 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -21,6 +21,16 @@ enum dma_sgt_requires_p2p {
 /* Type tag for all mapping operations */
 struct dma_buf_mapping_exp_ops {};
 
+/**
+ * struct dma_buf_mapping - header of a mapping made with dma_buf_mapping_map()
+ * @type: The mapping type the exporter selected. Importers that listed more
+ *        than one type switch on this and use the type's accessor to get at
+ *        the type-specific result embedding this header.
+ */
+struct dma_buf_mapping {
+	const struct dma_buf_mapping_type *type;
+};
+
 /*
  * Internal struct to pass arguments from the attach function to the matching
  * function
@@ -82,8 +92,35 @@ struct dma_buf_mapping_type {
 	 */
 	void (*debugfs_dump)(struct seq_file *s,
 			     struct dma_buf_attachment *attach);
+
+	/**
+	 * @map:
+	 *
+	 * Produce a mapping of this type for @attach, which has already been
+	 * selected into @attach->map_type. Called by dma_buf_mapping_map()
+	 * with the dma_resv lock held. Responsible for pin-on-map of static
+	 * importers if the type supports them. Optional; a type without it
+	 * can only be used through its own map functions.
+	 */
+	struct dma_buf_mapping *(*map)(struct dma_buf_attachment *attach,
+				       enum dma_data_direction dir);
+
+	/**
+	 * @unmap:
+	 *
+	 * Release a mapping returned by @map.
+	 */
+	void (*unmap)(struct dma_buf_attachment *attach,
+		      struct dma_buf_mapping *mapping,
+		      enum dma_data_direction dir);
 };
 
+struct dma_buf_mapping *dma_buf_mapping_map(struct dma_buf_attachment *attach,
+					    enum dma_data_direction dir);
+void dma_buf_mapping_unmap(struct dma_buf_attachment *attach,
+			   struct dma_buf_mapping *mapping,
+			   enum dma_data_direction dir);
+
 struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 					 struct p2pdma_provider *provider,
 					 struct phys_vec *phys_vec,
@@ -122,6 +159,13 @@ dma_buf_attach_accepts(const struct dma_buf_attachment *attach,
 	return false;
 }
 
+/* Internal: &dma_buf_mapping_sgt_type.map / .unmap, implemented in dma-buf.c */
+struct dma_buf_mapping *dma_buf_sgt_type_map(struct dma_buf_attachment *attach,
+					     enum dma_data_direction dir);
+void dma_buf_sgt_type_unmap(struct dma_buf_attachment *attach,
+			    struct dma_buf_mapping *mapping,
+			    enum dma_data_direction dir);
+
 /*
  * DMA Mapped Scatterlist Type
  *
@@ -137,6 +181,25 @@ dma_buf_attach_accepts(const struct dma_buf_attachment *attach,
  */
 extern struct dma_buf_mapping_type dma_buf_mapping_sgt_type;
 
+/**
+ * struct dma_buf_sgt_mapping - dma_buf_mapping_map() result for the SGT type
+ * @base: common header, @base.type == &dma_buf_mapping_sgt_type
+ * @sgt: the DMA mapped scatterlist, as the SGT type's own map function
+ *       returns it
+ */
+struct dma_buf_sgt_mapping {
+	struct dma_buf_mapping base;
+	struct sg_table *sgt;
+};
+
+static inline struct sg_table *
+dma_buf_sgt_mapping_table(struct dma_buf_mapping *mapping)
+{
+	if (WARN_ON(mapping->type != &dma_buf_mapping_sgt_type))
+		return NULL;
+	return container_of(mapping, struct dma_buf_sgt_mapping, base)->sgt;
+}
+
 struct dma_buf_mapping_sgt_exp_ops {
 	struct dma_buf_mapping_exp_ops ops;
 	struct sg_table *(*map_dma_buf)(struct dma_buf_attachment *attach,
-- 
2.54.0

