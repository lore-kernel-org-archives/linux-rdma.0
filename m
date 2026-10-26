Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993180;
	b=ara+y5PnVgzXBnRPAuRPreH3kUy06U1JvKVbzJxPpxzQRJB/3l6bMB0slXYM1vTZbsmm
	 lvcZi3OnHVBmPkEJ0XPuXWnWP5tczGn4f9Epc41gcjdweuhG318SyCaB7VlXCqOoiDG+W
	 Z9mVHhCanUPymBizZhBc7CEiD3u490AbfA/KPgJPaE9rYEYtH4JrfK3NZ08Q9D8MH/tK9
	 EGC3Pbe7KEEvaW3c453RzUX1/DlheeWuDA8TriBsn159aIXLAsDsfp8FbdiozB5gBq62d
	 65igNqK7atnDV2mrwgEg7YyLuio9vAZ7UP+ZD2Q9SplFhRj6ShCoXNzfM+PJf+ZTugQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993180;
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
	bh=SXL1QxRAqfKetgQUiaIIvbAeXy4Drwi/UlAfB8zG/tE=;
	b=ri4b1PwjBdss5oIzkjW/jVRrbhZBb+EGsK/oPylQBS9PZh2d4Q8ObxWnpyu71d5JAEDw
	 Ax1jdqJZD+F8F5PYHo0dvGToHsWxxFXuhpGH+S5jIvLJtioY9ZNd4j7Wm+Isi/URoTcOZ
	 x33pkgZ+oVyAnoUw+qLtoStppxt7K9TL8bJIHihL2/07utzK96gDg4JxU9mvoI7sLkEC6
	 zQOvm0KYU/+vXydTM4WaRXW/wg0e5jqQ1EikLeEAQD3kyxc91vaZ4I+sVO3uwBmg02NyQ
	 HgGqCJCQktw8iEXxMfphwDXkKgFJBaUAt+rRN2lp0dZRWfNwsMibuScgGx6OPkitNeg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=p0U1NO0y;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.6
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012006.outbound.protection.outlook.com [40.107.200.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFE4606A31A;
	Mon, 26 Oct 2026 05:39:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCFE4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=p0U1NO0y
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jDrKaoQmFwdRot1Zm+9ShflPYfCWLAYzUjGHvu0MpKkgfZPc1YmQLzBdFsVAn2XOCQAoy+hcvflJB167FilNpud+IztsWRiuF3Lwy7EBEv01qHPwHF18zr4jccCyRclrQNUR8Ori6qwuGkOz+68BZZ8YvkKSaM9p8yD3w607PG+AxXr1irf2EvX6JegcfijCoi0CjqBdLN4l1GFXFYCpbnEFiQgZXQ9S6k2c8h4SBaOpgfA/SBlnUn9PmFEEh6otv23r3w4aQTqQxztmCWk3XZWWsh+VcfEmnccCPzMYDV9e58suU6YCa8JYujLJVhn/gg7yHfuWrkl1wLSO0CM6Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SXL1QxRAqfKetgQUiaIIvbAeXy4Drwi/UlAfB8zG/tE=;
 b=wUUz58qAyKEDBdze7hFevc6vKhDYW6nIzTynt2ASKaeJX5Ct2m8unmZSesfjgdL31TVx1F7g4p/er2dCvQeqNKDSUVlk/yM4zgZYyHyJ6XgO4LMqo1EVWS8byc+EiisXQmiCClPCROFfdiumYSFHq3AnoSqdaJ46Y5GoRntYzNYmGtbZ2dxKbCiAIbby6EJd4G/Tfr4ZvuyDCtWpp8jtF0z01GqxFVwrv5B16XZm1z6CLfiuOV4QJCLtb+lMu6kZotgmYNDzCu45yyybr2ZDWizB5WMnEErFYwCq5dgzf3y75rUxfEx1Kqw0P6ViuHfW9UMXHT2wSDjt1uSMGWqplw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXL1QxRAqfKetgQUiaIIvbAeXy4Drwi/UlAfB8zG/tE=;
 b=p0U1NO0ylmTKIBChsWtPZq+l6cPwOEOIcIFfzKr2JFOyT/J8zX6CX0hnfjVHd9ZytFfxymPtTzHM7JOwiFZLuwZDWJ7oTMg72cju4OTiD5Nsz69NIe4aBd9sIQSRsSJ3IdjjA4k5VHak6Z+2uIIr418iPP2iYNxFjk0vXuOK5zW/AyqmKiFfG1hRSmcmUs+GBhFjkM958VGMDigbGypEVPYTFnDSXMpmCso67dJXmkQW+G5IGlKEB2AMs7TuzhMjeMUz4iMYCGLqaMJY4KDeHu6QupQ2IEzN4URHB7E+ODwdJnoTe3eETfX8UsLiOlRur+qavit7zA6ws6WXiDh5tw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SA1PR12MB7442.namprd12.prod.outlook.com
 (2603:10b6:806:2b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:37:36 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:37:36 +0000
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
Subject: [PATCH 12/26] accel/habanalabs: Use the SGT_P2P mapping type
Date: Mon, 26 Oct 2026 16:36:03 +1100
Message-ID: <20261026053623.202642-13-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY6PR01CA0086.ausprd01.prod.outlook.com
 (2603:10c6:10:110::19) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 9a26a90a-9f4b-4de8-86ea-08df33233d7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|56012099006|11063799006|261022075727099003|261021123027099003|10067099003|261009223027099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	QRYV2kIOBwdSi4RTwPkOVLnf4SZkDeHkDmT1r/4zs+CVwZlsuH2r1oqwQEFNP0/z5Q+gb2i9z9Q0WAWqGr/jCWIq+5EeYvRUWKI3PNIoyp4wSxdIKL0bE+VkOwCQpJC2X9D443hqsTDQCe8becEGp1gsHKvIoa+7ZxzsgST3oAtcbeIUMT3e0Lfb7jrs5yjaTi+uJhdFf9cSyYib7jtW1mHsiZTc+Xf1nSFFnnma1+lPcqAjWzrWz10uuECA6B71uCyKJQAt0cWP6S3geZgYcsHLbAP96FB19e2YrsS08obYINAZBj/Z//0al1/sheif5NKN/qpa7Tn87wlH+83PlQG+NSC9dkr+5I8Erg56IipGFPFTo/iKTX71rSYGK/kZ6TxQXwuM+2FfAInOtNfu4T0XGZEV6Z4R7jdfU1KDGRXyIvsueKpUTVa21jrW6TDI0R8m913GWL0HlO5UYGtEo2YX260AJcHfoZT0QCwYunIWaEdMZEFrRxLJ15cofW1iB5kJ6OILBYPKL+W3T3Zm4TsqqjaG3xZmwANYEZSGixbQxsPHiDh6REm0cph4bilZPl/egsOQJ6hvPdbI4jDGSHXe/V1ckluI4RRb7SVIhGXJce6H02rwKiRTk6b2aAsmD68Q65vf4nJfwiEmlHQEZ6DOiFZebORdbffOk8KjP8M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(11063799006)(261022075727099003)(261021123027099003)(10067099003)(261009223027099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PSBg8188YreEm4mdbEhrS2CJKTuhlLIiDzEelKCWwFW+3oskjNiIKnCYIlLU?=
 =?us-ascii?Q?7VrhEW44899nak0RQwd/7tjsGdCXjUJkGO/1kTrauPH43VU+NvhXAnnAgUcC?=
 =?us-ascii?Q?L0kLIQ5W5FbPuM/p78x6Bl1CY+wgnKknWAnh9WOVQAhbmfRTihmP8K9qKe4E?=
 =?us-ascii?Q?mtQ+DF3StaiJpYT4Qd3+jf4xjIVViwxXO4PK66+IBHg/7w+yy47aDJNk98x+?=
 =?us-ascii?Q?WYB6IUY6Lv9blpBWQbus8EjG41LXrH8dZniczMki8bSpjgoGSAXoqRkOe8Vr?=
 =?us-ascii?Q?8cL22RJF2cGS7CJLnmROH6MHKkuqDmCCJ7u1l/ZtDQMf6RZTY2BcijiU9sCl?=
 =?us-ascii?Q?4ED1hpcrb1hHa866FD9Z7AJBmHwUeqWJHl7v01QImWsBb+UI7+zRYIFp7oTR?=
 =?us-ascii?Q?Ehrzy5UdbcjO24mLSGoy8lylvGNiMRzPh65xTfKy2XOrzYkq/3hf0lLj8+GX?=
 =?us-ascii?Q?qcF115aja+/6Qo5EgW+vB2RLazJoUYIMub8oFuIPBWDwt+k7nv3wlCE19xo/?=
 =?us-ascii?Q?NPgs/WiVyW1W7xNPBv8CfNpI2zXgRonRTm+HZ653vF10prOoQwCsh/0llhCZ?=
 =?us-ascii?Q?JCA40grRmdX8yxjjghouURvZERtBkkn/b9TiRItfF5Wx3t/ad1tgi9Kpqb/s?=
 =?us-ascii?Q?0i1XO8hmYSY4yHrMaJSxraclN8YgVlPR2NH8Xc6YqfpN2igO2IKDcsfvxe+A?=
 =?us-ascii?Q?pYV56CSq0f3a7QfPTplydTIo/dZ2asqae81FrayD+oM/r6q+KtNt5X6kzRuw?=
 =?us-ascii?Q?+uIuV1CLVIEngwtvwm6xu5MqlrTtzmHrcFI51vUSxGTIxM+DdkoywILvfDlk?=
 =?us-ascii?Q?euKTcLSnNVlbpfWlhmlSACeWxrziQs/Ti2zDR2Qbn/jRhj5jMBAFxPw5eolJ?=
 =?us-ascii?Q?vr6gRe1XlEvx/y5t8XL+/1ZWNvtCrZBQ+NpEawsDMGqZBJdPxWQgJBDLNrMN?=
 =?us-ascii?Q?OBtwJCKQOgZ2otIgsokqQblhzijyFLcHh+h1g6J1sYYHDD5nNy9wvRWjeNEL?=
 =?us-ascii?Q?YuwDR97PMukYHwyYx9GgdIer996ipopNPZb4IFk801f2yhLM/hgvlqIabRG3?=
 =?us-ascii?Q?672gMnW3nYbbotAAYh7m8hEnqba1ZKz6jXvErFIjcy7RjJHDZwEkuWghz5sf?=
 =?us-ascii?Q?ZxaFChgzDt0bNIwV8ZT6j3hhWR7ccRgLwFd9ysxVPq73097hKBDFyuL488wZ?=
 =?us-ascii?Q?+I0c3+lQNgeNKz46X67g8h/bDvifvs40Ysp4BRLkGxR58Ht3H6ra8zuVz5R5?=
 =?us-ascii?Q?2bZ2nU7NP8+uN9EoDulFnGGX1UfJYSDQ4AGFVWuXJNxbJH1O40IL1nyRC0b8?=
 =?us-ascii?Q?R/N/HwGfmQXJSmWowQPXoc8K3BDyvv88VLi8rOTcffaDTR7+fvtcwns58iR0?=
 =?us-ascii?Q?6+XckwSU8iXgxTDjtMBHGkA/ozBYqmkYl1A+Wj91DKQlaTvdXo85vUID9JO8?=
 =?us-ascii?Q?Lgg8WlukziHmc3BO+NJadz17py6b4ouJpNvr6SraByPJAnXw5BXJAFxUUVlf?=
 =?us-ascii?Q?31VVZYWM88rSz+x1XB689K23lIukoNGN23MYPOuuO+HCyMhRbcMUMXaE3NMg?=
 =?us-ascii?Q?slFry+AOiMUZWAVOSh3h2QAAuKyUsr2XlGGno2sjPmlGFbrqwxtp2YIIzdHs?=
 =?us-ascii?Q?84btPqV8FXZLnzkA8qhAbo703wBOhZyH8y6s2uWa0Yp6Nteuiyx3xunKHZkS?=
 =?us-ascii?Q?u3I9LqI3a2yNiw37D+ZZ0Rixrh3BRDFzNunFjVNUsY4lZcDtTcDafgp+Sa+1?=
 =?us-ascii?Q?yLR6A8LCGg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a26a90a-9f4b-4de8-86ea-08df33233d7a
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:37:36.0335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n9dda1N7jCiOel9Wvlmi+X8iz/XsYyBz+KsLwp70MK/EJ2RXBUMTfhlNC7nDHJUJsgq23efMiYMUDMM1Wl3Taw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7442

From: Jason Gunthorpe <jgg@nvidia.com>

habana has special code to check pci_p2pdma_distance() and rejects any
importer that cannot do P2P DMA to its MMIO.

Convert this directly to a SGT_P2P match which does the same check
inside the matching logic.

Someday this should be converted to use dma_buf_phys_vec_to_sgt() which
does the P2P checking correctly, for both direct and IOMMU based cases,
instead of this hack.

Remove the now empty attach function.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/accel/habanalabs/common/memory.c | 54 +++++++++++-------------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/accel/habanalabs/common/memory.c b/drivers/accel/habanalabs/common/memory.c
index 361cff577381..6745af1328c1 100644
--- a/drivers/accel/habanalabs/common/memory.c
+++ b/drivers/accel/habanalabs/common/memory.c
@@ -9,10 +9,10 @@
 #include "habanalabs.h"
 #include "../include/hw_ip/mmu/mmu_general.h"
 
+#include <linux/dma-buf-mapping.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#include <linux/pci-p2pdma.h>
 
 MODULE_IMPORT_NS("DMA_BUF");
 
@@ -1704,23 +1704,6 @@ static struct sg_table *alloc_sgt_from_device_pages(struct hl_device *hdev, u64
 	return ERR_PTR(rc);
 }
 
-static int hl_dmabuf_attach(struct dma_buf *dmabuf,
-				struct dma_buf_attachment *attachment)
-{
-	struct hl_dmabuf_priv *hl_dmabuf;
-	struct hl_device *hdev;
-	int rc;
-
-	hl_dmabuf = dmabuf->priv;
-	hdev = hl_dmabuf->ctx->hdev;
-
-	rc = pci_p2pdma_distance(hdev->pdev, attachment->dev, true);
-
-	if (rc < 0)
-		attachment->peer2peer = false;
-	return 0;
-}
-
 static struct sg_table *hl_map_dmabuf(struct dma_buf_attachment *attachment,
 					enum dma_data_direction dir)
 {
@@ -1734,11 +1717,6 @@ static struct sg_table *hl_map_dmabuf(struct dma_buf_attachment *attachment,
 	hl_dmabuf = dma_buf->priv;
 	hdev = hl_dmabuf->ctx->hdev;
 
-	if (!attachment->peer2peer) {
-		dev_dbg(hdev->dev, "Failed to map dmabuf because p2p is disabled\n");
-		return ERR_PTR(-EPERM);
-	}
-
 	exported_size = hl_dmabuf->dmabuf->size;
 	offset = hl_dmabuf->offset;
 	phys_pg_pack = hl_dmabuf->phys_pg_pack;
@@ -1753,8 +1731,10 @@ static struct sg_table *hl_map_dmabuf(struct dma_buf_attachment *attachment,
 		page_size = hl_dmabuf->dmabuf->size;
 	}
 
-	sgt = alloc_sgt_from_device_pages(hdev, pages, npages, page_size, exported_size, offset,
-						attachment->dev, dir);
+	sgt = alloc_sgt_from_device_pages(hdev, pages, npages, page_size,
+					  exported_size, offset,
+					  dma_buf_sgt_dma_device(attachment),
+					  dir);
 	if (IS_ERR(sgt))
 		dev_err(hdev->dev, "failed (%ld) to initialize sgt for dmabuf\n", PTR_ERR(sgt));
 
@@ -1776,9 +1756,9 @@ static void hl_unmap_dmabuf(struct dma_buf_attachment *attachment,
 	 * a sync of the memory to the CPU's cache, as it never resided inside that cache.
 	 */
 	for_each_sgtable_dma_sg(sgt, sg, i)
-		dma_unmap_resource(attachment->dev, sg_dma_address(sg),
-					sg_dma_len(sg), dir,
-					DMA_ATTR_SKIP_CPU_SYNC);
+		dma_unmap_resource(dma_buf_sgt_dma_device(attachment),
+				   sg_dma_address(sg), sg_dma_len(sg), dir,
+				   DMA_ATTR_SKIP_CPU_SYNC);
 
 	/* Need to restore orig_nents because sg_free_table use that field */
 	sgt->orig_nents = sgt->nents;
@@ -1848,11 +1828,25 @@ static void hl_release_dmabuf(struct dma_buf *dmabuf)
 	kfree(hl_dmabuf);
 }
 
-static const struct dma_buf_ops habanalabs_dmabuf_ops = {
-	.attach = hl_dmabuf_attach,
+static const struct dma_buf_mapping_sgt_exp_ops hl_dma_buf_sgt_ops = {
 	.map_dma_buf = hl_map_dmabuf,
 	.unmap_dma_buf = hl_unmap_dmabuf,
+};
+
+static int hl_match_mapping(struct dma_buf_match_args *args)
+{
+	struct hl_dmabuf_priv *hl_dmabuf = args->dmabuf->priv;
+	struct dma_buf_mapping_match sgt_match[] = {
+		DMA_BUF_EMAPPING_SGT_P2P(&hl_dma_buf_sgt_ops,
+					 hl_dmabuf->ctx->hdev->pdev),
+	};
+
+	return dma_buf_match_mapping(args, sgt_match, ARRAY_SIZE(sgt_match));
+}
+
+static const struct dma_buf_ops habanalabs_dmabuf_ops = {
 	.release = hl_release_dmabuf,
+	.match_mapping = hl_match_mapping,
 };
 
 static int export_dmabuf(struct hl_ctx *ctx,
-- 
2.54.0

