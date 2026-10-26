Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993121;
	b=rle5gSVzCfzpy7Y+AafRyFwrsV0Y6xpqdKSABDQm3rThPDE4chqoetoINiV1tIwwCBjy
	 c2ZQyaz8OuBdhYKKhSynYVDkkSlru088z4AlC1+86pbotufJnyqmJblW1ufWCSaFgUzY+
	 aSIMO/g0KDiWROazMoA1fI/f56DLeFhz5+RXtu4ajUol3dggKtu4MGuqk7VpRmv9wVshc
	 xPvyDsZEOr6Tjt27DOkFUsc+3Ffo/AQHqPlL302/h3b82OuFOx21l8+3VgIAjwkJ+FZQj
	 wIKUzCGg0UPfR0jq78wLzXjI5Iz0V22S9JOpFS4QA9fJUiOfINndzSmO3WvKTctiu0Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993121;
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
	bh=01qhkv0UwYC2HqI/Bus2cOTDoXMw6c8oaejQ9+uOCXA=;
	b=SFnFILMxRnv7tVtPSwUv692lF3v4W7LpnaPCFLbG6WJusfafXQQQ3+Ac8GhMdwkON2dr
	 V2NLnq7l6O8CBAWpF8YnC+EyejphadWu2OhR6iA/KK+UD8CU1ZUlCX+tSMOEk67OxE3zh
	 qrmYzIDtwKX9iamnhym5T9Guc/LnfdjUM5pSKSgZA6l4D/CoEqCMdatDvHd1GIhf8j91P
	 9FYxYPi4LvTRq7Ltox2M+hjbqFyo5VCXlCsuP8OJ7xxJKPOzImlEFTqDU6jGB5IrBl8Do
	 6IxITE0ipy3G9YQhYYvC2cLYyELMfhRF5aLBCvSQ5xK+T7jIkY0Pkg1P9FHs8qVIMwQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=i7wzVTN+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.49
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010049.outbound.protection.outlook.com [52.101.201.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401A860A2634;
	Mon, 26 Oct 2026 05:38:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 401A860A2634
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=i7wzVTN+
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fHQoudL/zPWCEClS+ltGoU14e1xqV9o0TTdVMMFy4ojbRR98yJZJmmleZidcKKa5/sZrPbkfmQd4DZmfV6Wj/pAh9AuulDnQH5iTs7ssrgHiIX7HTUQeiu+8uzRcnYwD36QcwX/fA0ynhdeAK+D2pNu+AVpc/1EuNeV+dF29b5sNiZZwLy8et2bOQlQY7sNP96B9ckfoSnCpZp+GCcwI6AMnv6AsF7MlEbARm9cu4Pp63+0jgnK7Q3aC5pV2N7Gwd3XDEf1JeRUht82Nw4R1pkAc33fTFfGY2m8f1c9XkoqYxAE54AmW503TeLuGZA1CfRsx3ruky38Vjz7ATpNvcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=01qhkv0UwYC2HqI/Bus2cOTDoXMw6c8oaejQ9+uOCXA=;
 b=HGq8hvytbZqkpBANag7ZViswUks+AFTbUZKRlkTg72tbvjDy/CW3HStiVpeA8hdTn3EJg2SOJO8IfTd0wtWne003k0q5/fe10MO2rwUvmLqMId2bfWGYl2onv6hAr58DK1VySlVmczn9y89bEE+3nd1FWjEpZ2iULA04iYIDRysT9SxQ8tKOoy+0fpgzQNSxY6oO0Rjng1n9HhkVasmMEaGVQblmRXaEbPt+YsaduPdJheOl/OoAd0RUDMOMRCnQ0UBDkcP0P5ojCitjKF0cux2dtDIsma5/ywF7A6UWpeZNlZN0jNKP+oeqBhvG9JIzzsbvlr3jBkk8XD/u4Blnhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01qhkv0UwYC2HqI/Bus2cOTDoXMw6c8oaejQ9+uOCXA=;
 b=i7wzVTN+9JYXt8tw7MvhaSVjMWHpphp5pgavh3UcCM2g9OKaW+AS6WyoTEhsGKz4ef7nCEb+pMDhSGdhZHa/3/cZr12pXbBEjJ7G90FLwvOGd7pktq45SgX7IqBXV1GTF2IXwuhZVlI1hagIuC+PGotp/UNGmGQ/Y0yaqT6qfmTihhbVxnM21qUqTe0hNgP9ZIBKg1evOXU5pRIGf62kknuh94liGHQWgtR2Z5GkezU6F361rdzh6V/0nNV4N5XwvPccWIwxY4OwSrpYpUJkzmAtrubF0wV0RbmJy9fHkCxE1dgL3DXS3zJnqJLLi1J1QU1BT2QEs0eaQltyfEBe2w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SJ0PR12MB6967.namprd12.prod.outlook.com
 (2603:10b6:a03:44b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:38:37 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:38:37 +0000
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
Subject: [PATCH 24/26] treewide: Rename dma_buf_dynamic_attach() to dma_buf_sgt_dynamic_attach()
Date: Mon, 26 Oct 2026 16:36:15 +1100
Message-ID: <20261026053623.202642-25-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P300CA0102.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:248::19) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 35637b44-eb21-4013-4364-08df33236238
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|18002099003|22082099003|6133799003|56012099006|11063799006|261022075727099003|261021121427099003|261021123027099003|10067099003|261009221727099003|261009220027099003|261009221227099003|261009223327099003|261009223027099003|261022113327099003;
X-Microsoft-Antispam-Message-Info:
	tlrImbnyijWF46v7/Jd/Nb6xnx43OnoeVTAMmi8FuQVBqtb2RuKmqHkuKuxuIZ+11rcXmSEQtAQTpwoKUGHs8dCy0FGG+sHxHjJZwizOI9pJQ1UdNH1ui8H1tXPWJXW27b0ZRJwFpPDI3IphYd+xi+XrNSAoHmuHmIm0wYFRsGNBgMO2zMNZ8hlRwbZrT05DCjChLqsF+D3SYQMBoqzjGcYneoC1FIXHz9Ealnpbax45asabOus1uGwpzMzt3dlbrxEmmOVszDIS1F6GOJ/OWJasHIXIyMkur55Cw57+AgNIZ59NnG6dRH4zM4qsAOpyeN609jHni0tMawhs0w6e6WEWSQFxSucOjS983ObtVTF9LB7SYFw4yfiMHLYu6kpInd4TkGrmKZUjpgtjt8Ibyjmz/6168oilq9MV4OpyzSXXdbwOLhOUoLnCiqnqm6uct2G5HnBCklSqzOfXczoGpUh+i011VLAifZwzsMYxTTMuxtZwb/LJiWcbE485wvzgOPe7ILhU+tnHe08wqRCHRr+x/9QCQdqGRx7z6CLGTFswVXpdWRetSTiSu03pZnzKnwM6cTlkAxMT5urNzIQAENZYsKmPwI0ymd3a71iy/5Hoh2sTeBOpKI4pRV0EuJp/qhGc4hFy6XxBm1vV379D6O24+FWXCywRdcD2JJKjGN8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(6133799003)(56012099006)(11063799006)(261022075727099003)(261021121427099003)(261021123027099003)(10067099003)(261009221727099003)(261009220027099003)(261009221227099003)(261009223327099003)(261009223027099003)(261022113327099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?43FogyUx9ZiX4pXHw45ezdAKzhxiutjLJTCegC4C7E4Q5VBkrGyZ7hcOoirb?=
 =?us-ascii?Q?k9mf9+iK4oaG3lfFpuVqhUAciYalitgOD3RYqBNj93RgVdDnjQWHHc9dmoct?=
 =?us-ascii?Q?cKZiuzNOiJHzOOj5LIb3T0Wtg5+4fQpK9fZrCpHoT/cjECeFGSHkSMrBwh17?=
 =?us-ascii?Q?lKrwxqRaDP9b2Sdmxqmni+xgpZCtSTruSz5IbwW8HwKSAM6D3pFJ6wu/u9aC?=
 =?us-ascii?Q?SMSFE8/JEHjbNTma0ssvMDQLLRcXpzkmldNsCZHT/Pp97Kz4c7jDEFQQJZS7?=
 =?us-ascii?Q?nAVn3vZpI6+XPRCSl3GEOE1F6bGxXndxooKjZu0N6BUw2uAnCI2/ZI2HPunu?=
 =?us-ascii?Q?Dna+btSVR8j9eohrC8ASVautJi4N2kCuLAoZ0Jmi59BSwUvuiB/bSAG6lV8V?=
 =?us-ascii?Q?Z1vbr3YO4+PicjwaKJ0+QD60P3pVSNmHiyOAmxbm4NGRNW7rO+J9NI9cO7EM?=
 =?us-ascii?Q?YNUdbw+LTgTxgvjas7OOwi1BwAatQN5y/HeH4HLtRCpti7HuWsV9dNtvvvNu?=
 =?us-ascii?Q?m2DlUik3kwipQHnUGSKeXMTulzmjiOIUOJHuuvtA2KOUUlyU+HQAqQIXv0o4?=
 =?us-ascii?Q?7Xx104tvNHbn9nL3nzkZI4OCRohPWbW68NcXAxdl30i8ZjEy8nqIShCEtz8K?=
 =?us-ascii?Q?491Jt2TiN/LSLEXF6LS/xUONEOkTDdt619ttDLl8fVAwIVY9FhsMqCDmWgxf?=
 =?us-ascii?Q?psbcxcbN6gn90FiyXGRcGKnmzwx/Od2onNQxEkj17VVmegzNqZvkK3+xaEFA?=
 =?us-ascii?Q?e3rVQ3+9v2teyY5LNc4mX44UoTLsg0ZlvMdBEiqCU7YYLrmF5iYg97aDudG9?=
 =?us-ascii?Q?spEu3VG7M6vgv33Gz7XL4CTT5vAw5vb1gtTX/lpe9vnby8WmHe4CKGC0UrFS?=
 =?us-ascii?Q?EJ4VMwkbKwHi2fBVcwjKiNzZ8pDsyw/pThDxKYXhvYk3KNBNTq6NA11309HV?=
 =?us-ascii?Q?6/iO1euvtUJEyJweA1oS5J4y4C9VnHouthw17LUjLE/dpM5JWmCKFk035wgN?=
 =?us-ascii?Q?1+qCw20jBMctrf3AfldHXHbMdM8FpgvOIef3tIEPJjfnlXviXUk2zGAHGZFF?=
 =?us-ascii?Q?XVjXkJXoASi23hYIfpLZOEjsUOb4H4GnzDsQrds2y6TJUNwV9URB7/Bcd2HR?=
 =?us-ascii?Q?5OmZy8qhSlLnTr12fWh7B9nkFLlw4oulWWv9Pq1GrPrl9UROO5HFWIGCbFKP?=
 =?us-ascii?Q?AKPlXJUbe8NKqaCAuQC1UeD2HoPZS8SIfZU6k+HvAQ9GBiQgpHV8RGs2hdw3?=
 =?us-ascii?Q?XbI9MpbrVockQR4PNcLf3I5CUjASZ/Wv7tSla27v6//q47AAY4mNktzLsYJT?=
 =?us-ascii?Q?MqmlOxHbJ5IAuyd5PYM8UbnLEDKQ5y4OlVSaXqAo7rUiHyHYDDSd05NALMI+?=
 =?us-ascii?Q?VnreffvY9X2ydfI2fVdBF+dxa4W4kVbVLVZ4sseu+iatdlIgf8JkRnZ8erPc?=
 =?us-ascii?Q?ehBDp39+XjaPioFesFwAIMIOjep2BjxQ9ibG11QJk72kw829Dgp+uWSc/ZCo?=
 =?us-ascii?Q?sXYP1gQ5Loa/U+D4B8d0FwW/BkIba5pESrFN5kQQwzzSY73pydKezR4vkYdM?=
 =?us-ascii?Q?6f15PnbtFiOu3ZXyoKBd/YudHDt78Hh59lkrO8QijKGlsqXzZYu4PDvUyqS/?=
 =?us-ascii?Q?GMOqcXW1w51j8TMtjHsyqXtPJ90r0XQBCBmGB1mjk/s2aiQ7zv/BIulHPjiB?=
 =?us-ascii?Q?7yXdJWPP0Vr1EVBjCH6gYbNVS4rIMXQyDP3PnRJ4/emk9mBv8vnyjdCjgOCV?=
 =?us-ascii?Q?jgtmog70yg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35637b44-eb21-4013-4364-08df33236238
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:38:37.6776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4OW47ZsZk82rKu5pb5weBpCCqllixZNMGbrCUX0QHC9CtFhGxBzP511aFnVojqF5c29juYK8xZS/DXrOTSUfdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6967

From: Jason Gunthorpe <jgg@nvidia.com>

This attach function always creates a SGT mapping type importer.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/dma-buf/dma-buf.c                   | 14 +++++++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c |  4 ++--
 drivers/gpu/drm/virtio/virtgpu_prime.c      |  4 ++--
 drivers/gpu/drm/xe/xe_dma_buf.c             |  2 +-
 drivers/infiniband/core/umem_dmabuf.c       |  7 ++-----
 drivers/iommu/iommufd/pages.c               |  5 +++--
 include/linux/dma-buf.h                     |  6 +++---
 7 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 06bc25eff079..40301939331f 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -967,7 +967,7 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
  *    functions:
  *
  *     - dma_buf_sgt_attach()
- *     - dma_buf_dynamic_attach()
+ *     - dma_buf_sgt_dynamic_attach()
  *     - dma_buf_detach()
  *     - dma_buf_export()
  *     - dma_buf_fd()
@@ -1120,7 +1120,7 @@ struct dma_buf_attachment *dma_buf_sgt_attach(struct dma_buf *dmabuf,
 EXPORT_SYMBOL_NS_GPL(dma_buf_sgt_attach, "DMA_BUF");
 
 /**
- * dma_buf_dynamic_attach - Add the device to dma_buf's attachments list
+ * dma_buf_sgt_dynamic_attach - Add the device to dma_buf's attachments list
  * @dmabuf:		[in]	buffer to attach device to.
  * @dev:		[in]	device to be attached.
  * @importer_ops:	[in]	importer operations for the attachment
@@ -1129,9 +1129,9 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_sgt_attach, "DMA_BUF");
  * Wrapper to call dma_buf_mapping_attach() for drivers which only support SGT.
  */
 struct dma_buf_attachment *
-dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
-		       const struct dma_buf_attach_ops *importer_ops,
-		       void *importer_priv)
+dma_buf_sgt_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
+			   const struct dma_buf_attach_ops *importer_ops,
+			   void *importer_priv)
 {
 	struct dma_buf_mapping_match sgt_match[] = {
 		DMA_BUF_IMAPPING_SGT(dev, importer_ops->allow_peer2peer ?
@@ -1142,7 +1142,7 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 	return dma_buf_mapping_attach(dmabuf, sgt_match, ARRAY_SIZE(sgt_match),
 				      importer_ops, importer_priv);
 }
-EXPORT_SYMBOL_NS_GPL(dma_buf_dynamic_attach, "DMA_BUF");
+EXPORT_SYMBOL_NS_GPL(dma_buf_sgt_dynamic_attach, "DMA_BUF");
 
 /**
  * dma_buf_detach - Remove the given attachment from dmabuf's attachments list
@@ -1177,7 +1177,7 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_detach, "DMA_BUF");
  * dma_buf_pin - Lock down the DMA-buf
  * @attach:	[in]	attachment which should be pinned
  *
- * Only dynamic importers (who set up @attach with dma_buf_dynamic_attach()) may
+ * Only dynamic importers (who set up @attach with dma_buf_sgt_dynamic_attach()) may
  * call this, and only for limited use cases like scanout and not for temporary
  * pin operations. It is not permitted to allow userspace to pin arbitrary
  * amounts of buffers through this interface.
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
index 19ee9f85ff30..45dbf57c7899 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -653,8 +653,8 @@ struct drm_gem_object *amdgpu_gem_prime_import(struct drm_device *dev,
 	if (IS_ERR(obj))
 		return obj;
 
-	attach = dma_buf_dynamic_attach(dma_buf, dev->dev,
-					&amdgpu_dma_buf_attach_ops, obj);
+	attach = dma_buf_sgt_dynamic_attach(dma_buf, dev->dev,
+					    &amdgpu_dma_buf_attach_ops, obj);
 	if (IS_ERR(attach)) {
 		drm_gem_object_put(obj);
 		return ERR_CAST(attach);
diff --git a/drivers/gpu/drm/virtio/virtgpu_prime.c b/drivers/gpu/drm/virtio/virtgpu_prime.c
index 2faa22875a51..09571e746cfc 100644
--- a/drivers/gpu/drm/virtio/virtgpu_prime.c
+++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
@@ -366,8 +366,8 @@ struct drm_gem_object *virtgpu_gem_prime_import(struct drm_device *dev,
 	obj->funcs = &virtgpu_gem_dma_buf_funcs;
 	drm_gem_private_object_init(dev, obj, buf->size);
 
-	attach = dma_buf_dynamic_attach(buf, dev->dev,
-					&virtgpu_dma_buf_attach_ops, obj);
+	attach = dma_buf_sgt_dynamic_attach(buf, dev->dev,
+					    &virtgpu_dma_buf_attach_ops, obj);
 	if (IS_ERR(attach)) {
 		kfree(bo);
 		return ERR_CAST(attach);
diff --git a/drivers/gpu/drm/xe/xe_dma_buf.c b/drivers/gpu/drm/xe/xe_dma_buf.c
index 3ca198da6ee8..4ed246f8617e 100644
--- a/drivers/gpu/drm/xe/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/xe_dma_buf.c
@@ -402,7 +402,7 @@ struct drm_gem_object *xe_gem_prime_import(struct drm_device *dev,
 		attach_ops = test->attach_ops;
 #endif
 
-	attach = dma_buf_dynamic_attach(dma_buf, dev->dev, attach_ops, obj);
+	attach = dma_buf_sgt_dynamic_attach(dma_buf, dev->dev, attach_ops, obj);
 	if (IS_ERR(attach)) {
 		xe_bo_put(gem_to_xe_bo(obj));
 		return ERR_CAST(attach);
diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
index 950db165d9c7..5bcf848c8675 100644
--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -152,11 +152,8 @@ ib_umem_dmabuf_get_with_dma_device(struct ib_device *device,
 	if (!ib_umem_num_pages(umem))
 		goto out_free_umem;
 
-	umem_dmabuf->attach = dma_buf_dynamic_attach(
-					dmabuf,
-					dma_device,
-					ops,
-					umem_dmabuf);
+	umem_dmabuf->attach = dma_buf_sgt_dynamic_attach(dmabuf, dma_device,
+							 ops, umem_dmabuf);
 	if (IS_ERR(umem_dmabuf->attach)) {
 		ret = ERR_CAST(umem_dmabuf->attach);
 		goto out_free_umem;
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 404f31d8f729..82bd6d630ce8 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -1487,8 +1487,9 @@ static int iopt_map_dmabuf(struct iommufd_ctx *ictx, struct iopt_pages *pages,
 	struct dma_buf_attachment *attach;
 	int rc;
 
-	attach = dma_buf_dynamic_attach(dmabuf, iommufd_global_device(),
-					&iopt_dmabuf_attach_revoke_ops, pages);
+	attach = dma_buf_sgt_dynamic_attach(dmabuf, iommufd_global_device(),
+					    &iopt_dmabuf_attach_revoke_ops,
+					    pages);
 	if (IS_ERR(attach))
 		return PTR_ERR(attach);
 
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 208752eb93d9..b2f4cec5e748 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -594,9 +594,9 @@ static inline bool dma_buf_is_dynamic(struct dma_buf *dmabuf)
 struct dma_buf_attachment *dma_buf_sgt_attach(struct dma_buf *dmabuf,
 					      struct device *dev);
 struct dma_buf_attachment *
-dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
-		       const struct dma_buf_attach_ops *importer_ops,
-		       void *importer_priv);
+dma_buf_sgt_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
+			   const struct dma_buf_attach_ops *importer_ops,
+			   void *importer_priv);
 struct dma_buf_attachment *dma_buf_mapping_attach(
 	struct dma_buf *dmabuf, struct dma_buf_mapping_match *importer_matches,
 	size_t match_len, const struct dma_buf_attach_ops *importer_ops,
-- 
2.54.0

