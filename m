Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993049;
	b=JFUajqsagr8UptC1VPuiCg8/O5hjTYhDlLIE5XvGxTnpNzyhF4yCmyD1pgrKzZb1ZmWK
	 GgKlc6YvF2gvPaNyt5oE/N469Qb5x71fRVXZGRpNnWdvq+kTjEigYM3IixFLF0NZrYitn
	 1W0m2tW/fR68s9dWAXHQIzxFyCsQfJUV+r/dhlqpkbRgHUQ0XIcfO9734lCej5AvAFc2G
	 C5cTwYrck3i2alrrilkwWNxcqW5w+LiBQwo4FHGbw0Mk19HSY9TW0FW4vUsfFMPPrRPRC
	 c1TyRn21aXrhVHweRgDy5gT3DQrwVZvA//mcH162hS9spI/I8eI94uVYDL99+OAlmTQ==
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
	bh=W2F0KELSUs6/71h8h9r92atIER08lZOK2hxTHF+qjYg=;
	b=vGZ+g/a7kdwVmgCiwLI8UNZ2OyrZSp46v/aDdl+5cYekeRVDzCTUOLfjI3UcxROSxMib
	 9LGhd54CUzCJUZssndhSqz4S0xQiiOnfGNC+MH5OZLA6nnJ2Cg2G591ipDLUHrqknPx1x
	 IAppK3I8cJFYD0i//Bf4uUHsWHC1hspD9J5JJFX3YdjUjlwmauHeKG6VZCibpcyWXvsx8
	 Zu2aMOrMIF++dB1m5cmMLTGlKoVwYA1OZ3DKO7ZAJ0mGgPk2kx8vpx7kV0W6IZJJwKdjI
	 fC+VyPofAQN65KWnW5Y07fPsQIqCpX0B4HAWhIKfncSTjbj10liL2Y3OvKBs4/LOARA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tcCllwgS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.7
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012007.outbound.protection.outlook.com [40.93.195.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50BB606A324;
	Mon, 26 Oct 2026 05:37:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C50BB606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tcCllwgS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UkvAPgKqToBq5fq6aJLWFqUwAAIl7gQi7fGDusvWdiSvY6Toa0t+p29G/9TH/hC3XbP4fZebWTl3jIrZbzV/SfHcgpysunbPRX6XzoodvMOfxIMBC2iFGcCKXKxqMf+ffF5TTzcL7cmxaYZDHayeMC5Cs3wOXz+kyNNgl3k13h1D1qfEh5G3DXXaoERtk2BG7EKsN3yQ9mmnqQtqbeH9Zoze/9qsGUuE3URKRay4wLJnroyJ6LktM8GAI5PLa1cY6I2SC9FwMLhA+htbdfL/o+glULDSmTmQKgLb/CdARmun7j8lnLL8L/NhgpFKib/btZEsAicI6G4hurRWKLcY8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W2F0KELSUs6/71h8h9r92atIER08lZOK2hxTHF+qjYg=;
 b=mqq5NkOV/UXl51x94A8bJUc4G71Xy9BGaci/UYn5UZWl8GAOxSU6JaFfTguAlzXyX2Z5q7vDQya5iv2oQ2ZgExIzkdE4M15hMOVb7jJdtjaWeh9B0Ha5qWruwLC4WwZdS+6SuopFwj4UmSR/VuLOklt0581elxBL4vY0QfrumpNzYPhTVUTPjRZ0NzE4Cihl9s7vWA9pCSYbT5h7mDej/L5hg9NiZEJ+ImKsoPq+VCkMoMOJJL97uxyIz+LtFGuzd9qpEICTLqK/kbDqJcxn/7LzBAICtxX5oXjnVg6G+yfw+ZHshbumq80ZEcP0dYtnAn2NgK1LQirbsMWqPMudig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2F0KELSUs6/71h8h9r92atIER08lZOK2hxTHF+qjYg=;
 b=tcCllwgSa4SkjpbHAdn5SP/lsiSPlfVukDYxhq66dfrsx4PTO7ykoxYVCg4AMoUBuS/Frgq9De3EvSeBFAMTbZoVwQidgcNOMZZAKOZklefRag3NTHpcsfl1enbqqkCIWEE7VlCq6wep4iIIid0wJ+x8jtFSTGxDCBT9dsmItO0rZ+aLXLZdXXLKzsbpEymcnwIIVKyNvDsBCbNKY+Iv/rSPeLJ6OqaaPMRYeI6sYvOYvS283Dj8tGPAd3qnl/QhYJjWhVVjbB9dZbFs9NxxSnbIcxis1Hz0aMWCi+Vz1UoSYfxgcCHKQUV1g5aXo+gZcoRTwqJbijweXMVd/C0Z4g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SA1PR12MB7442.namprd12.prod.outlook.com
 (2603:10b6:806:2b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:37:05 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:37:05 +0000
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
Subject: [PATCH 06/26] dma-buf: Add match set queries for exporter placement decisions
Date: Mon, 26 Oct 2026 16:35:57 +1100
Message-ID: <20261026053623.202642-7-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P282CA0142.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:205::12) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: ebd06811-3bef-43db-11e2-08df33232b30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|56012099006|11063799006|10067099003|261009223027099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	Lcydfke4LyCP+sJTOPU/geZmJN+S+h0ALBIhLd+0Ad9da7zxF1baji1TLDHuSmoYnKpeHdy4HSWE9Os1Wod6JugVzoopWBz57RannMt0Hk4GUECF6gffzqpN+S/gT/Sa7UmqPEdBXxlxK7VfNuevC+FFJdP1+fF+DKap+HK9ee/QJQNUdvUCxYs4KldiY/0IKzNV96XdQK7Cgn0rNKv0qBAJt+HEyMrX09PgMA/LBI0D7vLN6Adbb/9nX0DkYreWBmQMn4qqFGU+nlDZNRC5W0ujQ3gJM24MMwWVpyb1AEJ4e8Y+DY64sIHtpaS+tL324AayPWdpPjO2bxjCzcqwGqQPfIoc9/4ezRU5B0J6ZgOCF6h5TAp5zMoXPneH2OJqYxfpfs9X7laS0BuRinj10P7JTC1E9TG7Ad0Kq/ZGyvEW1EM1aIwOfUnHs/PrDPhjoxQJA2n0YhQUwmUaybuNM04dFKa6rYgOlKvFvV2aZO6SiSwnGJuBj6UEmalHk36pTdADm1MiPxOaGF0Voo2D2jvhC6wMiHh/Q+spbLVH9XMwkGrO4ZWQ8b04gsEqP3jbKblmESRrAz+sbefHF5WSRyFMJpNMsftoGpsSWXAZuOrmOpNstG4ka9ZjSaZTnn7tYPkJHHkRNRHYpT+2FZ9po7PDkiHX6ONMhCIk1k/s7ew=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003)(261009223027099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?34XT7rWq2EPO5luoa0SnXN6/5fJ/ILVUKbYXngm2W28YwU4PffjCWWBRnZYx?=
 =?us-ascii?Q?0PvIycGWOYVOJg0vQy0GpZqoqyZ5hfiJYRYWCFGsk5cgkLpeQw3NzZIIW1Dr?=
 =?us-ascii?Q?mN0mc5nusiPXOPhm3+6V8jzKkfOrf7YC9b+5Wlghu3giLv4TWOxCg5BvX0r+?=
 =?us-ascii?Q?ODJeZKW0Cebw74S/ryNJJaW2tVcSP+SePL9IexqSDljJeGYfMgY/N4NwBHM1?=
 =?us-ascii?Q?uFAGVjQdlryUcCxhhTUeDadD63z2uTgh12sbyxSzaqETs8/RxldaEkM2T8tj?=
 =?us-ascii?Q?PeJYgjo9C6/M8mBa477MMfCxkRQOQw3yvB+rcAnZKYGDzNmLwtqe7nMaCtRI?=
 =?us-ascii?Q?PiQYe4gx4H9lv0ZAZku32DIu2gfaa0HIKLZhFO488i6eKcP5fHdnaREE2Ajg?=
 =?us-ascii?Q?feMCbjc5FFlzLD9/Jg2Ww+o4kNYlcAppFKNQfy3ok5DlDku00MkPfeu1+7wg?=
 =?us-ascii?Q?lutG3QHa6CbvZ5tGGDf0m1kgNCvqcuntFcylfTONapL+uG16nHWYe2NFDLfo?=
 =?us-ascii?Q?NdMyt9VQSTJXqWV4akmNSAnCyGc3/c2saPO+XRCmxJT0jsV9Nluse1HqWIrG?=
 =?us-ascii?Q?vOudcf573si/qRAorZLQ5PeEfQCUw8Iw7Q8LZKhm9ddNsN7Umg+A7VQ2CKgp?=
 =?us-ascii?Q?s+F/g1uRWMU1ncki46w/e1kupCqUnS8Fk3qol2iQJ6E9bXX3eGU+g9m8WZ/j?=
 =?us-ascii?Q?dZUOF8i81ISRMm6CyrtjUrcp2eKGCbd2chncuHRWIEHeSC3YEbHqe13r71Oo?=
 =?us-ascii?Q?kZfMQgJfTQci25g1uIfXdVGctZtAJ+OCwjSnjOv9lf/cJ9BskSafjQ5Lx3Bv?=
 =?us-ascii?Q?tjkD9NVOiMxRgRvpKWjUN7i/4zZvQXQ8xTsr5qWiesoodCQJnfUwXJBNi0pk?=
 =?us-ascii?Q?hbhUE5goABtSxKxGrZCvjZ+emF4A1dI5cEhzX1Znxem63T+XI/AKaXVvMmeh?=
 =?us-ascii?Q?6RjAmRBTCOSd6EtWqXFYYeYbgectCYFq1L9eXg3F3C2Iju7CAcvgsNUwCPRq?=
 =?us-ascii?Q?gnz1nnHmhL7rjQse7m7+txlz9/w1mgWTuMR0J7Fl8cwr0KLEy0cnJSLJXOEo?=
 =?us-ascii?Q?25KPvl7G+p0qPuLkkEGrQAKRMZBzM8Z9LGqe9MzjYLjiFU+Yx6+pTpBHNoxw?=
 =?us-ascii?Q?SnPClgBTG9okt4dyHCfBxtSfFX1FELE/beTUFRgX2bwFc9LtSRvhSdMlKGU1?=
 =?us-ascii?Q?ZZoQgNIXi7US2X3ytQQgFvK3iVdwKe3T9oFlkyjt4NYFaMyhW8wRg4Fw9h8p?=
 =?us-ascii?Q?lz7q/JUdbSXnfb0ha6JmHNdSaANegOCH9XbEXGM++2tU68UrJ6llU1/+JBQJ?=
 =?us-ascii?Q?fv1DBNzkCSJFflpcUgnWXQU975LYqRhwgVUWJoeIyhoMK8M8TD4mlX+xvbtB?=
 =?us-ascii?Q?5uGkhxs7RrLbirnqzUajIuk+z1XSWlPOXjPDeFIRxRlH54+C60tZK+QRytbF?=
 =?us-ascii?Q?xYF3xRX0MckxbNKqlIW+pP/SbQu8RiDjazILUgBagrlHMAqKcB9T/wH+7HSM?=
 =?us-ascii?Q?udX/5feFROgc22Ueaukabrgt4mK2YjGvDy7cpuZzAf1hOYLhYibk7niy7Qr+?=
 =?us-ascii?Q?BBtLmulumwLHRt4XY9vmPGdsCsX/1xjxmQrNsKmviDG4AvcoIJCiK/VpjuQf?=
 =?us-ascii?Q?BZ4ET4TjMLrgkw88IfcXYGJ8Ksstub/z89a5oYY+1OqsT793DgFF872I2rpX?=
 =?us-ascii?Q?o31rJviQMiTR2W53dG386ES4SiSQ6lU0zR267LCslu55cW9cm3fCaWCeLTks?=
 =?us-ascii?Q?7zBWpnxg7Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebd06811-3bef-43db-11e2-08df33232b30
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:37:05.3485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IE8AWSFFzH+pQWG0hGAvDjQNrYCGPupmFkCrgyz0fNfIgoDegxc7FNZ/u925OEte8P5hA0SxrkpFlbnn1jFHkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7442

Exporters deciding placement in their pin path walk every attachment
to determine whether it can take P2P. With selection deferred to pin or
map an unmapped attachment only holds the exporter's default. Therefore
determining what is possible requires walking attachments.

Add dma_buf_attach_accepts() and dma_buf_attach_accepts_sgt_p2p() to
walk the match set and determine if an attachment is possible with P2P.
A future series will convert P2P into a distinct match type.

Assisted-by: LLM
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 include/linux/dma-buf-mapping.h | 46 +++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index c04fac71726a..494bc29910f4 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -102,6 +102,26 @@ int dma_buf_match_mapping(struct dma_buf_match_args *args,
  */
 int dma_buf_mapping_select(struct dma_buf_attachment *attach);
 
+/**
+ * dma_buf_attach_accepts - Is @type in the attachment's match set
+ * @attach: the attachment
+ * @type: a mapping type
+ *
+ * Called by exporters deciding placement in pin or select_mapping to determine
+ * whether the importer could be served with @type.
+ */
+static inline bool
+dma_buf_attach_accepts(const struct dma_buf_attachment *attach,
+		       const struct dma_buf_mapping_type *type)
+{
+	unsigned int i;
+
+	for (i = 0; i < attach->nr_matches; i++)
+		if (attach->matches[i].type == type)
+			return true;
+	return false;
+}
+
 /*
  * DMA Mapped Scatterlist Type
  *
@@ -147,6 +167,10 @@ dma_buf_sgt_dma_device(struct dma_buf_attachment *attach)
  *
  * Should be called by exporters, returns true if the exporter's
  * DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE was matched.
+ *
+ * Reflects the current selection, so is only meaningful inside the
+ * exporter's pin and map callbacks. For attachments which may be unmapped use
+ * dma_buf_attach_accepts_sgt_p2p().
  */
 static inline bool dma_buf_sgt_p2p_allowed(struct dma_buf_attachment *attach)
 {
@@ -156,6 +180,28 @@ static inline bool dma_buf_sgt_p2p_allowed(struct dma_buf_attachment *attach)
 	       DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE;
 }
 
+/**
+ * dma_buf_attach_accepts_sgt_p2p - Could this attachment take a P2P SGT?
+ * @attach: any attachment
+ *
+ * Like dma_buf_sgt_p2p_allowed() but valid for attachments that are not mapped.
+ * Instead determines if p2p is part of the current possible match set rather
+ * than the current selection. Called by exporters walking all attachments in
+ * their pin path.
+ */
+static inline bool
+dma_buf_attach_accepts_sgt_p2p(const struct dma_buf_attachment *attach)
+{
+	unsigned int i;
+
+	for (i = 0; i < attach->nr_matches; i++)
+		if (attach->matches[i].type == &dma_buf_mapping_sgt_type &&
+		    attach->matches[i].sgt_data.exporter_requires_p2p ==
+			    DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE)
+			return true;
+	return false;
+}
+
 static inline const struct dma_buf_mapping_sgt_exp_ops *
 dma_buf_get_sgt_ops(struct dma_buf_attachment *attach)
 {
-- 
2.54.0

