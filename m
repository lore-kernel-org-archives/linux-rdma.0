Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993009;
	b=gie1Ll/CoILeexH1xo8AVwlMWZkiCHehaBtFugqwf8Z7dAjL1DjLriR4hO70u//7kfCK
	 uEtFdGI1vjGKHa5NKR7RxtWa3++0sThEqoF2fGX703+5v0lKxRI4xyHEjmEU/7hU7nlrq
	 dCirLzNOGHKc36UTdEHb9jrRY5z4tx8wTsALVuvfaXTyTAzfRtf/32zE1zvkbAuGPaDiD
	 OU5qsYBDRGSlWByo2aopO1ugGuLB/pu5C48EhgHpGs6sPnqTfEph3hK+4++z7wpMrmjCd
	 UQe+qGZyDPV9kxMgIg8CbptOKADDHTV1ssK1J+3uDxLt45JenUWiK8frpJ8oLYIcqjw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993009;
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
	bh=uQc1yeqihEno27XwAd7uU+0kc8M7ak/jjycaIFWAvYc=;
	b=oYKn/BQdlXXRVu1nEE3gGA/ZYholrcMYAk6Bb23fWvz1kJO8d7OMpFVMiDIjRqo6IG74
	 e5rZRQpwSpO0x8B/+QCfKW8OPS1ynR7fL9UKkgj6DSYqlkm3q0zN0tr+0KGfZiSVJIo2I
	 D8T+nLvEkpMAApLBJzLPEobsoKpnWoHyGavkUIbXzDcuWzYn3jdUE0cCyWd30oRdsxRkQ
	 wRSI+FSOV5j9UHn9eM9Q2XMzk55r73sRHVzFY3OXyXrhAkEKrbVEN0+5Dme45nknUTzu5
	 wrPKed/nwMldQyTNkLOQTOI36qyoHICoIpC4NpWTzSxv+IDu0RKevAk5h8guX14v4BQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jdlKHU+S;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.56
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013056.outbound.protection.outlook.com [40.107.201.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E901606A321;
	Mon, 26 Oct 2026 05:36:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E901606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jdlKHU+S
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f9obbTr1djj83F9iwFhyZXGlzfXdWDDiY/nkjgq7DzIy0GjnCKsmq6xWzENLY9hgH/DOJtczPk4AjCVWu1R0X3ev5E732TVKIIOgznXCWtt+HF+2sbo20yQ+jFJP4c4QAHPLQU/3i7FRC+Y6uCRjibPRxHJ0PBVe6t9B3yd6cyhwbTLCmRWl4+vPCy5wL5mFWEKzDI6uwg1NZzfokVBkaZ0Y4Rveslj6Zn/CwtzcgOMwCJ4p81DOaXsqfpN1vSmV4cxlStLQsV4Nl/z07BxIYqBpwxL0kAFBmnFXtkklxCnudTvsD9dH42ZnYluDiZ4MUzrq2aPv/Gx0Djf/JMq5lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQc1yeqihEno27XwAd7uU+0kc8M7ak/jjycaIFWAvYc=;
 b=Dwhun7dV46UY/pDzx3qn/FE0cPdIJ09AGfqUmD3QiZfXTzxsXbkN9P3RiAZTD0KVTApMfucQW+HAQHKA762dY2LPnAj3g8k5acu8Q5u7gQoCpkJz0MXZuJW4z6/CVTXLRqbpDvzDgfa7MDH8P3Hbt/upaFIDI4dpTA2EsJWBaaWFtaP6FLE5gu2UDo0NRVyH4XiLxvvsVxDGbvNmrzNFMEoApwXzsQnxDlpsdqoBiKOof1T0Z7CMDgtKYVyLEiAB4QgyjMsTzk/9bkOVjEzrF7+A47SxRZBBg62sxVlqCeoZSvZnUOnkJnSfNuk4w5U/douU8eXuMrN9iqrMnon3/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQc1yeqihEno27XwAd7uU+0kc8M7ak/jjycaIFWAvYc=;
 b=jdlKHU+Sm5DmoqFjPpcdDr/g95JzaVzyYbp5vNiUwpr056jxrJQ+7HhMxfp3ZLiceUUkfd8lXFWI5YJuO5D6HY5TKRIItZWE1gM3dFhqWRO1HBKwGY331eHBrOvNPZ2bmufOIt7slb+qzj6D3lrQ9A8m05HYc0FsTPpTWXIuN/wwBO12hFXIA4eKrlqw57I5OlLUgU4l7ik1HWAKCLv/lQe86SNioD2c9lL5t7/4M5hyNl2Ua3wDjdCst7GoAzOEaLUZBeFhzb3nZilJOUlz+SqRoeTUutdORD59NZ/xQ4GxY4X83LOVC3OhYrAuVCPWwsC5tw59DXC9vuVljaEqcg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SA1PR12MB7442.namprd12.prod.outlook.com
 (2603:10b6:806:2b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:36:44 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:36:44 +0000
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
Subject: [PATCH 02/26] dma-buf: Add the SGT DMA mapping type
Date: Mon, 26 Oct 2026 16:35:53 +1100
Message-ID: <20261026053623.202642-3-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY6PR01CA0066.ausprd01.prod.outlook.com
 (2603:10c6:10:ea::17) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 6cbd2b24-0f33-4ced-3ca1-08df33231ee5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|6133799003|22082099003|3023799007|56012099006|11063799006|5023799004|261022075727099003|261021123027099003|10067099003|261009223027099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	MTd+3u5sDmtN+AFr5rgs4n7Fd2baHIgcDcTWzR8Et+d0VUg6cFzFpAAIwdW9Hgprvmw1qDKd8Hkfu/v+76TMDsFcSbWrPLDwMPCUCM/Fy1A3cEWRAHbp5FFwcu0PSRBrqNzf9SzH9OXWV7clOArDv28A6i9qM4H79yUwytwA2YDTPi/0Q3GT2vKgc64INkeHlEt8/80cnVRFjPA4Tyi5sBVhorKlk+SrhBDC69/sI2soDzB84aG8HrcTIIXdc8u6xT7AVELQHURbI2cJXeAPspbbaZIvyvkf6qE2XLMGnnebLBjupyNxcrwVY7bU28U4XEXa37sE7EqoxS5jYtGtkDDVlUCpTjqtd2Sg++C2kWK50dcwgpamif48zOv1EDx2kWKdRv+1ctmwYXSF16nFFFiaold835xFU4Xjx0m0k9OV2yyimzShWuR/VlwlpE33kry9+aIEgBtQOGXNf2QFGfm9dGsAiPbtp6eInTVf/Isq7PeLEZHXHqBKgcAZ1n2R3Oou+pIkmQenO2l4+JjVbJXxq7e7Jd8w5VPo0Ip8CtfdzB2ajojFfCu9+/AZvoojdI2H901D9QqBvgyqjv0MhJ3P0vDqbHwORWr0iyMHd3o5rodu3Txj4pA+SHw53wDr+Cw3XPVZ0vawcInki7CIg4DnAxv2slcY8SUEdTktWEs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(6133799003)(22082099003)(3023799007)(56012099006)(11063799006)(5023799004)(261022075727099003)(261021123027099003)(10067099003)(261009223027099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lYLlZoWMRVhfqTpgWzoMxjMvzrmXKDVqexC/CPfW/hzzVylypuMjfUuqlf+a?=
 =?us-ascii?Q?0q8qlmEfZHA/BWrGbZ+CsS22ixONHlmPiAM7av2g4eKtkDTVDA5OKt/Lza7A?=
 =?us-ascii?Q?7Z9pPV8JmZEHU5vFfTBYY+j/+sW4MU0xD/ptJbXBtvayn36N4SUbJb9nBJGO?=
 =?us-ascii?Q?Z1PUtgRFZYNW9Lgn+vBAiUt1/W+ObWAttaG86uvVWZc6mUMVE3yorr3CEASY?=
 =?us-ascii?Q?xwuftDvgtXAChJcOa2hh5d4bZolHQUbiZdzn7YhkiITnBBdRjWxieaNuMnne?=
 =?us-ascii?Q?2O/HTNcZ9ORB8EeM0CSEPFdLWGBi5XIHxSwF2RuqThuaMX9YniWcnBj3DaQu?=
 =?us-ascii?Q?Yu89kM/8zpLvQ+82KIeymgzfEg5JrQ9sUPfYgVUsZbloO1+iP5aOLXvUXKLF?=
 =?us-ascii?Q?tMI4XYkrRfaMVVQDT6af4wYaykpqZuXvgbPUWxjsQPa6HaQemVlqBrIaAF9z?=
 =?us-ascii?Q?mRvyPQNFRsXRnRwa9ELcfDf4W76gWSnuyHrA1WYA3ZdpocYyK/kMkRdozXfk?=
 =?us-ascii?Q?+Ii/fQokMpOGrfYVzfEtfFchBzfVIzbN1zfh7AL13omVSz5KAo75qHD0yQZQ?=
 =?us-ascii?Q?T5UBeQYZ7NmeFUns/n9CpeBL024a572k+kbvSFcRYWTVD2kNQHlmAbTyd48m?=
 =?us-ascii?Q?dBcsRRLhBJ5vuNj5T362CgWB+4aW5KosoacP5Y7vx2FUcKpzvVPbuRzBu3UQ?=
 =?us-ascii?Q?Ns+ijU/6T6Q4nfP4KY/m01g4vNQqTWeizTYQZIveEokVVkgjksXMIGidgc1A?=
 =?us-ascii?Q?ksMFFJoTfp1bhHdZd4bxR3tR8Yk//fYDy8R54JGum4AFBuaqFsKvO+kQi+9T?=
 =?us-ascii?Q?zZnhgWVxIYuJtUJ2qdUEH3XV7fUF4LxuJSx4/KvishQGAv7nSL7ENl1MGMC0?=
 =?us-ascii?Q?mbtO9qqZPS8+8sb+NeqwuPH8KML/XUQtNB0TcM8A2PxpH3OH+X5064Ptf6d9?=
 =?us-ascii?Q?rj5vsKVOpdJU5HD6/u3GdboafRZIpeGgJ7HDpjZ0LmSPzIu1peNEtOS7y4m3?=
 =?us-ascii?Q?XUc9d32/+sFxbXWsdvQkNXWxw/02MHOKLYG1vbq37ffDsTZ+gLmJpSjQOnSd?=
 =?us-ascii?Q?Q2Irc1iJgjdacGlm3sL/pYpdT9NZMOfySGIPUt+ku6Hhd0bYva7bukT+HSSj?=
 =?us-ascii?Q?oKnU4qNpucnOLQ7NzfWD3s9K2MKWHKK6KA2mF8BstTOo7G6kM4/tTMq0xxWm?=
 =?us-ascii?Q?4Upd/xol07cu0sRyscW2mVx3Sd3SQ/kPzj7r9SlzIGYuBq+6ngEbc0yN75ZH?=
 =?us-ascii?Q?4GoB4k9RTqhANnWutU4LWoW7OR8yiFEmTlaegNEhwNkWpU/mj+tgY3LG5TQU?=
 =?us-ascii?Q?5hZCeTyLZeZGgl+zB7hoo8fZJVgtsdw9Lim2SPSee7epEtAooteWLElneFEt?=
 =?us-ascii?Q?Ig/n5O1wjyxnH3gdx5gc7Bm7SnIZqnSK0gpFAwDbrx6IfCGx2U/9c+nD0fjQ?=
 =?us-ascii?Q?RZMFUdNB0H8rO038Y+z5DMjgsQEbnj8F0bkm0xstb33FOBwROMVvmLmE9XF2?=
 =?us-ascii?Q?Whha0hN9U7WYZzWO2TsLDKlE+XnPf/tUAexTRhdIfW6Fy763QYSQ8G/Azqxn?=
 =?us-ascii?Q?ciwyrl7WQzoaLbdulwxSksdifgo0ChwseUp35Doj0ufcvH7+NfoG6bvbOIpX?=
 =?us-ascii?Q?GUEi5M8Dt8nf9dFvjOCfFQMA0pL1f5v1ziqNAHg7HpVxgoW6FqfI8NUBOHt0?=
 =?us-ascii?Q?WQ697piZjF2A4RnB/LAigfvGwaDvX04Hf3i40AcTwyn3Up+UW9PIBa7OmC6m?=
 =?us-ascii?Q?96VK0ovg2g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cbd2b24-0f33-4ced-3ca1-08df33231ee5
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:36:44.5821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: heTnKsJ6SnsXt6kgHao4auVs1kPv1S5HaQjNcC2UZp2IVGy+G7WRnhaagbC8z6neBBsy6oP8JVbaXLTeMNp46Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7442

From: Jason Gunthorpe <jgg@nvidia.com>

The SGT (Scatter Gather Table) DMA mapping type represents the existing
sg_table/scatterlist based DMA mapping. It provides a sg_table based
map/unmap interface that exactly matches how things work today.

dma_buf_sgt_exp_compat_match will be used in the next patch to
transparently wrap an unaware exporter with a mapping type.

The SGT type handles the allow_peer2peer flag directly through matching
logic. The importer indicates if it is willing to accept peer2peer and the
exporter indicates if it requires peer2peer. A required peer2peer exporter
will not match to an importer that does not accept peer2peer.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c |  95 ++++++++++++++++++++++++++++
 include/linux/dma-buf-mapping.h   | 101 ++++++++++++++++++++++++++++++
 include/linux/dma-buf.h           |  18 +++++-
 3 files changed, 213 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index 616ab057fb28..d30c0e9ef038 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -6,6 +6,7 @@
 #include <linux/dma-buf-mapping.h>
 #include <linux/dma-resv.h>
 #include <linux/dma-buf.h>
+#include <linux/seq_file.h>
 #include <linux/overflow.h>
 #include <linux/align.h>
 
@@ -319,3 +320,97 @@ int dma_buf_match_mapping(struct dma_buf_match_args *args,
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_match_mapping, "DMA_BUF");
+
+static int dma_buf_sgt_match(struct dma_buf *dmabuf,
+			     const struct dma_buf_mapping_match *exp,
+			     const struct dma_buf_mapping_match *imp)
+{
+	switch (exp->sgt_data.exporter_requires_p2p) {
+	case DMA_SGT_NO_P2P:
+		return 0;
+	case DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE:
+		if (WARN_ON(!exp->sgt_data.exporting_p2p_device) ||
+		    imp->sgt_data.importer_accepts_p2p !=
+			    DMA_SGT_IMPORTER_ACCEPTS_P2P)
+			return -EOPNOTSUPP;
+		if (pci_p2pdma_distance(exp->sgt_data.exporting_p2p_device,
+					imp->sgt_data.importing_dma_device,
+					true) < 0)
+			return -EOPNOTSUPP;
+		return 0;
+	}
+	return 0;
+}
+
+static inline void
+dma_buf_sgt_finish_match(struct dma_buf_match_args *args,
+			 const struct dma_buf_mapping_match *exp,
+			 const struct dma_buf_mapping_match *imp)
+{
+	struct dma_buf_attachment *attach = args->attach;
+
+	attach->map_type = (struct dma_buf_mapping_match) {
+		.type = &dma_buf_mapping_sgt_type,
+		.exp_ops = exp->exp_ops,
+		.sgt_data = {
+			.importing_dma_device = imp->sgt_data.importing_dma_device,
+			/* exporting_p2p_device is left opaque */
+			.importer_accepts_p2p = imp->sgt_data.importer_accepts_p2p,
+			.exporter_requires_p2p = exp->sgt_data.exporter_requires_p2p,
+		},
+	};
+
+	/*
+	 * Setup the SGT type variables stored in attach because importers and
+	 * exporters that do not natively use mappings expect them to be there.
+	 * When converting to use mappings users should use the match versions
+	 * of these instead.
+	 */
+	attach->dev = imp->sgt_data.importing_dma_device;
+	attach->peer2peer = attach->map_type.sgt_data.importer_accepts_p2p ==
+			    DMA_SGT_IMPORTER_ACCEPTS_P2P;
+}
+
+static void dma_buf_sgt_debugfs_dump(struct seq_file *s,
+				     struct dma_buf_attachment *attach)
+{
+	seq_printf(s, " %s", dev_name(dma_buf_sgt_dma_device(attach)));
+}
+
+struct dma_buf_mapping_type dma_buf_mapping_sgt_type = {
+	.name = "DMA Mapped Scatter Gather Table",
+	.match = dma_buf_sgt_match,
+	.finish_match = dma_buf_sgt_finish_match,
+	.debugfs_dump = dma_buf_sgt_debugfs_dump,
+};
+EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_sgt_type, "DMA_BUF");
+
+static struct sg_table *
+dma_buf_sgt_compat_map_dma_buf(struct dma_buf_attachment *attach,
+			       enum dma_data_direction dir)
+{
+	return attach->dmabuf->ops->map_dma_buf(attach, dir);
+}
+
+static void dma_buf_sgt_compat_unmap_dma_buf(struct dma_buf_attachment *attach,
+					     struct sg_table *sgt,
+					     enum dma_data_direction dir)
+{
+	attach->dmabuf->ops->unmap_dma_buf(attach, sgt, dir);
+}
+
+/* Route the classic map/unmap ops through the exp ops for old importers */
+static const struct dma_buf_mapping_sgt_exp_ops dma_buf_sgt_compat_exp_ops = {
+	.map_dma_buf = dma_buf_sgt_compat_map_dma_buf,
+	.unmap_dma_buf = dma_buf_sgt_compat_unmap_dma_buf,
+};
+
+/*
+ * This mapping type is used for unaware exporters that do not support
+ * match_mapping(). It wraps the dma_buf ops for SGT mappings into a mapping
+ * type so aware importers can transparently work with unaware exporters. This
+ * does not require p2p because old exporters will check it through the
+ * attach->peer2peer mechanism.
+ */
+const struct dma_buf_mapping_match dma_buf_sgt_exp_compat_match =
+	DMA_BUF_EMAPPING_SGT(&dma_buf_sgt_compat_exp_ops);
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 03a03624166b..f9b749af362b 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -12,6 +12,12 @@ struct dma_buf;
 struct dma_buf_attachment;
 struct dma_buf_mapping_exp_ops;
 
+enum dma_sgt_requires_p2p {
+	DMA_SGT_NO_P2P = 0,
+	DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE,
+	DMA_SGT_IMPORTER_ACCEPTS_P2P,
+};
+
 /* Type tag for all mapping operations */
 struct dma_buf_mapping_exp_ops {};
 
@@ -90,4 +96,99 @@ int dma_buf_match_mapping(struct dma_buf_match_args *args,
 			  const struct dma_buf_mapping_match *exp_mappings,
 			  size_t exp_len);
 
+/*
+ * DMA Mapped Scatterlist Type
+ *
+ * When this type is matched the map/unmap functions are:
+ *
+ *  dma_buf_map_attachment()
+ *  dma_buf_unmap_attachment()
+ *
+ * The struct sg_table returned by those functions has only the DMA portions
+ * available. The caller must not try to use the struct page * information.
+ *
+ * importing_dma_device is passed to the DMA API to provide the dma_addr_t's.
+ */
+extern struct dma_buf_mapping_type dma_buf_mapping_sgt_type;
+
+struct dma_buf_mapping_sgt_exp_ops {
+	struct dma_buf_mapping_exp_ops ops;
+	struct sg_table *(*map_dma_buf)(struct dma_buf_attachment *attach,
+					enum dma_data_direction dir);
+	void (*unmap_dma_buf)(struct dma_buf_attachment *attach,
+			      struct sg_table *sgt,
+			      enum dma_data_direction dir);
+};
+
+/**
+ * dma_buf_sgt_dma_device - Return the device to use for DMA mapping
+ * @attach: sgt mapping type attachment
+ *
+ * Called by the exporter to get the struct device to pass to the DMA API
+ * during map and unmap callbacks.
+ */
+static inline struct device *
+dma_buf_sgt_dma_device(struct dma_buf_attachment *attach)
+{
+	if (attach->map_type.type != &dma_buf_mapping_sgt_type)
+		return NULL;
+	return attach->map_type.sgt_data.importing_dma_device;
+}
+
+/**
+ * dma_buf_sgt_p2p_allowed - True if MMIO memory can be used peer to peer
+ * @attach: sgt mapping type attachment
+ *
+ * Should be called by exporters, returns true if the exporter's
+ * DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE was matched.
+ */
+static inline bool dma_buf_sgt_p2p_allowed(struct dma_buf_attachment *attach)
+{
+	if (attach->map_type.type != &dma_buf_mapping_sgt_type)
+		return false;
+	return attach->map_type.sgt_data.exporter_requires_p2p ==
+	       DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE;
+}
+
+static inline const struct dma_buf_mapping_sgt_exp_ops *
+dma_buf_get_sgt_ops(struct dma_buf_attachment *attach)
+{
+	if (attach->map_type.type != &dma_buf_mapping_sgt_type)
+		return NULL;
+	return container_of(attach->map_type.exp_ops,
+			    struct dma_buf_mapping_sgt_exp_ops, ops);
+}
+
+static inline struct dma_buf_mapping_match
+DMA_BUF_IMAPPING_SGT(struct device *importing_dma_device,
+		     enum dma_sgt_requires_p2p importer_accepts_p2p)
+{
+	return (struct dma_buf_mapping_match){
+		.type = &dma_buf_mapping_sgt_type,
+		.sgt_data = { .importing_dma_device = importing_dma_device,
+			      .importer_accepts_p2p = importer_accepts_p2p },
+	};
+}
+#define DMA_BUF_EMAPPING_SGT(_exp_ops)                                      \
+	((struct dma_buf_mapping_match){ .type = &dma_buf_mapping_sgt_type, \
+					 .exp_ops = &((_exp_ops)->ops) })
+
+/*
+ * Only matches if the importing device is P2P capable and the P2P subsystem
+ * says P2P is possible from p2p_device.
+ */
+static inline struct dma_buf_mapping_match
+DMA_BUF_EMAPPING_SGT_P2P(const struct dma_buf_mapping_sgt_exp_ops *exp_ops,
+			 struct pci_dev *p2p_device)
+{
+	struct dma_buf_mapping_match match = DMA_BUF_EMAPPING_SGT(exp_ops);
+
+	match.sgt_data.exporter_requires_p2p =
+		DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE;
+	match.sgt_data.exporting_p2p_device = p2p_device;
+	return match;
+}
+
+extern const struct dma_buf_mapping_match dma_buf_sgt_exp_compat_match;
+
 #endif
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index a749562c1728..3e82ec59d5ce 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -30,6 +30,7 @@ struct dma_buf_attachment;
 struct dma_buf_mapping_type;
 struct dma_buf_mapping_exp_ops;
 
+
 /*
  * Upper bound on the number of mapping types an attachment can record as
  * mutually acceptable. An exporter offering more compatible types than this
@@ -46,7 +47,22 @@ struct dma_buf_mapping_match {
 	const struct dma_buf_mapping_type *type;
 	const struct dma_buf_mapping_exp_ops *exp_ops;
 	union {
-		/* Each mapping_type has unique match parameters here */
+		/* For dma_buf_mapping_sgt_type */
+		struct {
+			struct device *importing_dma_device;
+			/* Only used if DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE */
+			struct pci_dev *exporting_p2p_device;
+			/*
+			 * These p2p flags are used to support the hard coded
+			 * mechanism for p2p. If an exporting device knows it
+			 * will put MMIO into the sgt then it should set
+			 * exporter_requires_p2p. Importers should set
+			 * importer_accepts_p2p unless it is known that the
+			 * importing HW never supports P2P because of HW issues.
+			 */
+			u8 importer_accepts_p2p;
+			u8 exporter_requires_p2p;
+		} sgt_data;
 	};
 };
 
-- 
2.54.0

