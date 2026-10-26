Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993130;
	b=po9dr9MO8plcchTTXHctJ+03IOXlQA3sSMHHHhG6ts8ev81lPj+h+F4W6KmasqXhzxkx
	 WKRTeVwFg8nCbzNoYmnuKKuhJaNhDP0rT35zBY2JFjeXmY13XejkmDZY7g8TObaavwDN9
	 W8qPRhIVnc+cNC8FZyZRGqmipvUfX5wvnkrZKr97wMvZwNU7c0eFbLhUWV9H7NzYvKdtn
	 xruGFQjjqolkegbQBegM87Nl1hP6ukHwtAHESbmxM4+iBLt0eGWycd4G+hiC2d35SzDus
	 I1GT1DkyKEYXPUk2FgeYsqv6eTOmD0BthKd8x2zAGhOAp8WqiWq7clS02y8S6oT51gQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993130;
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
	bh=U9Zgt5dzUclq9HhFcitSUkfPZubgPfwHtPe8H0eLaHc=;
	b=Y4vcEZAjRtrADX07StwdI7U2JakMJdmTRtzkOeSioiDotWqLJ4Zo/Jefdw0lm6CqB8po
	 h5RClnglR0HeT7UsMqg9a+4YgQmbf8uPPxnS4Y5jVuFDzBEQQnyFwCgLmyA9jHBcywxC2
	 yCdg1hZ3CRsu1eSFczIBOfriM6tD3iAMFBwKrJmvHtvlAeGD+K2WNEqyu5mZCP3Gd9a66
	 Rj+0//99saPExptpZQxZ5w5RgqRuhHJNfxnYKJjuylskUXKGc1LECpPqSO7Hl5SPJ+P1A
	 /0tAksb8kdeFQ6WMZoI94xx7IvowrFVGyQg6gDbO/cIpK5BFCKd3wRay2St+w2i217w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aqeNHE6d;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.13
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010013.outbound.protection.outlook.com [52.101.46.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C0060A261F;
	Mon, 26 Oct 2026 05:38:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85C0060A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aqeNHE6d
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GB5rgUipmtgDEbp2QsZIXAjQ4Ggo8weFoX2KZPx/16mkNLcKzrihXSvca0vx8LpMnPMFknHcHIBxrcYRMZdpo1qGH/HTLicQlyQge4yebpCQPDzSdSMuZXNbC4nxNxa+/VEO3icrTBLfiEHx1J+h35hxmaMuOi845pIApUUenNlztXmk5qc/hr9oUXhUbAXehryVbonk+cbifR0KYTB9uNBkWwrGOcFDhaRVib6mnzsLB59PJT0oPHDWRulKjzlEQ9r99wQX1I5Fo6o6abr1G0yMEZBtFhXRDzb5vm+TwpWQsJ0mPwaCI7wBgatYzuoAhvEGqCvGHak6FLonnvtTDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9Zgt5dzUclq9HhFcitSUkfPZubgPfwHtPe8H0eLaHc=;
 b=CCsM9KxAFxV8YCjQJ4waH1k/4xssDe+f78APNv5HBxYlhDcVU1XDUpP5eM3Obc6kwFcgxEDevSPPNF5qbbBqWun5BW6aZIyIYvKv3yp99QY60TdhZbJDW50FuHUf2mzD1cHLwgMkgxQWPKAoOYSxwqRmxN3qMNR0IgIkROAf6jvMliAwGcq4v/Nb26jYkeegqknigsz8qUJucH6RYu/unynL2VZWO9i/Vdv09aSdYWQutNAAnNyucatp2HzsYBIB5oFseRb+vvdm0SXwe3+ZWLFtxpyT7T3St4gX1SaasmMl6HKB504xGcbvbN6cxQBoOJWs6rY2UZzue20mYwyKyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9Zgt5dzUclq9HhFcitSUkfPZubgPfwHtPe8H0eLaHc=;
 b=aqeNHE6drhE07DwRV+PIqHVhYliu1k3VI9tVF1ebAhhKA7n0CDjRWiUpep5rclNdhKBJNq1nkrZAtRo3FYl2k5E8VOXmmU3ZCaoDX5eZQUtkKPHqat1ZWzX7C/V8XPgc5pfdjCWqyLHGgnNrRTN1u2mCkeE5cVjG96Wpztat9Yyyll7/itsUX/+zXYPoU1Ka9R8YxBBEQfhOLxdfWcSMVofNX9IU42A4meXhzQyusVkPQMdnWlCqzKnkXo4LXwd/GOaa2oSuXnIuFykAfbsp4xQOEC11SCdxdxfGqfUE2C+jlu5xPqLI9Femi5KUO83Q2UHVU/D/2xeOBAUjNjggnQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SJ0PR12MB6967.namprd12.prod.outlook.com
 (2603:10b6:a03:44b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:38:46 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:38:46 +0000
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
Subject: [PATCH 26/26] dma-buf: Add kunit tests for mapping type selection
Date: Mon, 26 Oct 2026 16:36:17 +1100
Message-ID: <20261026053623.202642-27-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY6PR01CA0028.ausprd01.prod.outlook.com
 (2603:10c6:10:eb::15) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: c56c8658-3380-4e8d-8829-08df3323678c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|18002099003|22082099003|56012099006|5023799004|11063799006|261021121427099003|10067099003|261009223027099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	1/8Ogwd/OVNaArnLN2n/UtMTIQnDYwUDwvoGd2ZlEqmZsLdLC25oTEpESJMtMI63C8E2FDCqjdrPfpM45atSXIvNWaUNtEEtYxdof8TRBBx8YHik3L1eA7xzCfPuOVzgNFYa8H+QdBUcP5URcMvkapS1tKXOrcpmwdLghIa/xtAAVkq6kzR78P41tvLwezcEgtrRaXAuJjAHYvmK5O/eGgKubsnLblVZgfP9MOOdkryxP+M5eDioilhjocCDY5E4AAx6sUQb6NExDrMp10gGVgnzi3iOMzJxzIRmN8pt523dufjsu0E0efrHXdIbpN95JsEm6nb44VUwFanDmZBteYp2xxZYYNReulmY+Nv8BwdybEm6Bx5bRTwPcnfgZ3A9Til64F2iHYEFvFGNgaVtS1N/G7wX/dmKAC9uS7yVe6eLp+PaZW9gDeDfbors0vmkYYKsQpx66CN2P1/rOEsr3EXHfcQKrrKic7XmUbicdj1Tv9EUFJOwsprZZJUs4IWTQ/+YUQlRSkq0U0uGugm/nOLKkUeh3YhIHZ4ZqbvOX6h33gNaYse29471OZuggiPXfHOCDzvQdn1JaGTEOBUOiFzvQo7pO088p8No6mYsOW+sMpByeOHhScswb5Nw9iM0LJtv8wHua++Y0cw1jeUEOuA16TzZcB79o8rZL33KCbQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(56012099006)(5023799004)(11063799006)(261021121427099003)(10067099003)(261009223027099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8PB5x9cl/okdihhG/v8m1ZsaIKksosRkb2+1Pi/cu6wUYIjJiiCbuvmXNIfY?=
 =?us-ascii?Q?DYAiRkDo2uI986N/rP2fQPoYtxGQwlziV2NmsPjbpkMlcFnfrTvby3t+dG9L?=
 =?us-ascii?Q?HfBiRUJuRLnNpB8yzFMSU46W4CvDavfhf+pFstM6Ei+18qVc0K+CUTaqU5L3?=
 =?us-ascii?Q?I5zrRX3opsvuqmh3anBjzpb46PV/cAeP0bNK7S8sa6G1ClfWsetKi87ENLPY?=
 =?us-ascii?Q?kdF7EQ1X0CVFqktA6+K4pND9UdWMlx/MjYsGs5hxrAKEprEIcGQTIlbP8xBi?=
 =?us-ascii?Q?EsW/ApYuTdoVeAjWJrCt9456L/I75k0F0LltrKHJBDtmBdviYh1LH9cx7aqT?=
 =?us-ascii?Q?iJXLPfCQZ7TXcPIKL2f9tFDqQfwoLK8D5r7MLfjZ0u6VRgK7r+BMjdLuzP5B?=
 =?us-ascii?Q?F8E/SYB1GUhJFTlacXY6BxeBs8ctwNlw41K7s3eLF0lPCjEn8Emo/vI6M8Hp?=
 =?us-ascii?Q?A4gBK7DZLazbapAuaDE1y97abuBR0aINf/cqADQz7tHnq1oa/Pb1dHhRjngO?=
 =?us-ascii?Q?z797Tq/28+C9YTt1fymS/T4It6O9CdHdLNnlAm7URBrz5wTHjZdNLuPVPm6u?=
 =?us-ascii?Q?V2RxeJflVaTDdhYdWUiJQxcZj0SwUiuuoOOyo1sEFZsQOgdzhtNaOwWo05Cg?=
 =?us-ascii?Q?6hfuJiVSymfSlngRJ9yCxzVpqlUTHOkNIhxTQXQCuEBNYvXZtrUh8hqm6rUb?=
 =?us-ascii?Q?nxlZ12L0VXllJufkMFEUJTulrrvk6Hhl56LCqEpV8Ud85X4l9WHaJm95DpaG?=
 =?us-ascii?Q?cdtz5yQClRHxZECk2SGMxnPbGuvWnUGdfdcVFIUZVQQ08tP+Taq0RDopELcs?=
 =?us-ascii?Q?mCzj/OAO9NyqfZNhYOExyPGtrRuz743X0+dCsz6OXxzR+Ecn2POYP5jBfGkK?=
 =?us-ascii?Q?cM76YSsEUrAs2/VbJ818z3JV3DzFkAiLxu5bRPlEEe2fw/IIG/xIft2V5+D4?=
 =?us-ascii?Q?+a2YxUj/cQa3QZMGXXFJ+0fh1DACglXuVm4D8Ri/HwsKTThQy0ejtj/hDjhT?=
 =?us-ascii?Q?1dCWVj2OPGk6/NQC2ogZf8Edww7KlitCz0kq01RHwmX4WrOWWTCUVv5A6t/Q?=
 =?us-ascii?Q?/9gmhby5ce+NQFRR/VXRZiOyht0HoMrk+OFFlqJfuaS37nCWgdIPQ3Fd5F0m?=
 =?us-ascii?Q?cA60Ro+3pSeBrt5rdjIH6FvQwGtuPfCR+TSHvkuGcRU9ExETKQtIa/HCAQKe?=
 =?us-ascii?Q?QnRd+Pfuqq6zs7RHoMiPNZEbE9XAWtlWsYOc8hhzTJw9jFknZUQTDcoNEpwH?=
 =?us-ascii?Q?SmThjTKtZkS/8g5fX3QR0g/KO87K8cYLQEi8RxHFZ0bVFfxxYY3OfQqByLlK?=
 =?us-ascii?Q?VhEfGijWkvetkFgLQbeK7OUFjCJlDggB5WA+l29Et1VUiKkrRN0lpDSRtetB?=
 =?us-ascii?Q?n6GsY6v0EGLXB0HA6jSb48DMACHlXhgB/5yO5esHTGTH3YdVu48/OisH4O4b?=
 =?us-ascii?Q?66JMmWCO91RGaZc9Apg+pEX1CdthUfDUlfIXKKmGDLOQAjcr9T52ogmxLG8C?=
 =?us-ascii?Q?FEZ/UPtP9B/2LLWF5NXI2HDOk2jXBKF6WPQSh4Oie/t25JUxvWnoTUm5gyU/?=
 =?us-ascii?Q?oZDR/jbML4UysF0VDauj5pA/aOnj9bWo5KeC+mKF1PbZ6JrqRecTDpBjc9AQ?=
 =?us-ascii?Q?mtS5oKc/fCKPlndv+Tk9IQ17r1MY3phXhOwX4smMRQinhs10LxlWNqnIdgfx?=
 =?us-ascii?Q?GiNHea3NPaW5MY4ZgjB3ZAJwr2IIjcZ+M2FGqX5MOcQP/zQvUET/zWSua12g?=
 =?us-ascii?Q?JWRzpXXM4w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c56c8658-3380-4e8d-8829-08df3323678c
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:38:46.4849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YB3y2dSKwJOAQ4btuldUOl0ScviD085WZVIpum88iUoL4jMVG/tRre0p0sow/kQ5pvQrEyt3XDMfSV9AH4khaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6967

Add an offer list and a select_mapping() callback to the mock exporter
along with map/unmap for the two mock types.

Adds tests for the exporter/importer contract.

 - test_match_set_is_final: a later importer attaching, even one the
   exporter answers differently, does not change an existing
   attachment's match set or default. Later attachments influence what
   the exporter selects at pin and map time, not previous attachments.

 - test_select_at_map: the exporter chooses a non-default entry
   at the first map and the result is tagged with it. A pin taken
   under the live mapping inherits the type and the choice survives
   unmap/remap even though the exporter would answer differently. Only
   dma_buf_invalidate_mappings() allows the exporter to make a different
   selection. An -EBUSY from selection leaves nothing established.

 - test_select_at_pin: pin selects, and the choice survives map, unmap
   and unpin so a pinned importer that is never invalidated keeps its
   first type for the life of the import.

Assisted-by: LLM
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/st-dma-mapping.c | 277 +++++++++++++++++++++++++++++++
 1 file changed, 277 insertions(+)

diff --git a/drivers/dma-buf/st-dma-mapping.c b/drivers/dma-buf/st-dma-mapping.c
index 9d0f1e389e15..22c1d73ea087 100644
--- a/drivers/dma-buf/st-dma-mapping.c
+++ b/drivers/dma-buf/st-dma-mapping.c
@@ -7,6 +7,7 @@
 #include <kunit/test.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-buf-mapping.h>
+#include <linux/dma-resv.h>
 #include <linux/errno.h>
 
 /* Mock tracking state -- reset before each test */
@@ -20,6 +21,14 @@ static const struct dma_buf_match_args *mock_finish_args_arg;
 static const struct dma_buf_mapping_match *mock_finish_exp_arg;
 static const struct dma_buf_mapping_match *mock_finish_imp_arg;
 
+/* Mapping types the configurable mock exporter currently offers */
+static const struct dma_buf_mapping_match *mock_exp_offer;
+static size_t mock_exp_offer_len;
+
+/* Which match set entry the selecting mock exporter picks, or an error */
+static int mock_select_idx;
+static int mock_select_err;
+
 static int reset_mock_state(struct kunit *test)
 {
 	mock_match_called = false;
@@ -30,6 +39,10 @@ static int reset_mock_state(struct kunit *test)
 	mock_finish_args_arg = NULL;
 	mock_finish_exp_arg = NULL;
 	mock_finish_imp_arg = NULL;
+	mock_exp_offer = NULL;
+	mock_exp_offer_len = 0;
+	mock_select_idx = 0;
+	mock_select_err = 0;
 	return 0;
 }
 
@@ -357,6 +370,267 @@ static void test_mock_attach(struct kunit *test)
 	dma_buf_put(dmabuf);
 }
 
+static int mock_dmabuf_offer_match_mapping(struct dma_buf_match_args *args)
+{
+	return dma_buf_match_mapping(args, mock_exp_offer, mock_exp_offer_len);
+}
+
+static const struct dma_buf_ops mock_dmabuf_offer_ops = {
+	.release = mock_dmabuf_release,
+	.match_mapping = mock_dmabuf_offer_match_mapping,
+};
+
+/*
+ * The match set is final once attached. A later importer attaching, even one
+ * the exporter answers differently, must not change an existing attachment.
+ *
+ * Later attachments influence what the exporter selects at pin or map time,
+ * not what was previously negotiated.
+ */
+static void test_match_set_is_final(struct kunit *test)
+{
+	static const struct dma_buf_mapping_match offer_ab[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	static const struct dma_buf_mapping_match offer_b[] = {
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp1[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp2[] = { { .type = &mock_type_b } };
+	struct dma_buf_attachment *attach1, *attach2;
+	struct dma_buf *dmabuf;
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_offer_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	mock_exp_offer = offer_ab;
+	mock_exp_offer_len = ARRAY_SIZE(offer_ab);
+	attach1 = dma_buf_mapping_attach(dmabuf, imp1, ARRAY_SIZE(imp1),
+					 &mock_importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach1);
+	KUNIT_ASSERT_EQ(test, attach1->nr_matches, 2);
+	KUNIT_EXPECT_PTR_EQ(test, attach1->map_type.type, &mock_type_a);
+
+	/* Exporter's answer for new importers changes; attach1 does not */
+	mock_exp_offer = offer_b;
+	mock_exp_offer_len = ARRAY_SIZE(offer_b);
+	attach2 = dma_buf_mapping_attach(dmabuf, imp2, ARRAY_SIZE(imp2),
+					 &mock_importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach2);
+	KUNIT_ASSERT_EQ(test, attach2->nr_matches, 1);
+	KUNIT_EXPECT_PTR_EQ(test, attach2->map_type.type, &mock_type_b);
+	KUNIT_EXPECT_EQ(test, attach1->nr_matches, 2);
+	KUNIT_EXPECT_PTR_EQ(test, attach1->map_type.type, &mock_type_a);
+
+	dma_buf_detach(dmabuf, attach2);
+	KUNIT_EXPECT_EQ(test, attach1->nr_matches, 2);
+	KUNIT_EXPECT_PTR_EQ(test, attach1->map_type.type, &mock_type_a);
+
+	dma_buf_detach(dmabuf, attach1);
+	dma_buf_put(dmabuf);
+}
+
+/* Mock mapping result for the generic map path */
+struct mock_mapping {
+	struct dma_buf_mapping base;
+	const struct dma_buf_mapping_type *made_by;
+};
+
+static struct dma_buf_mapping *mock_type_map(struct dma_buf_attachment *attach,
+					     enum dma_data_direction dir)
+{
+	struct mock_mapping *m = kzalloc_obj(*m);
+
+	if (!m)
+		return ERR_PTR(-ENOMEM);
+	m->base.type = attach->map_type.type;
+	m->made_by = attach->map_type.type;
+	return &m->base;
+}
+
+static void mock_type_unmap(struct dma_buf_attachment *attach,
+			    struct dma_buf_mapping *mapping,
+			    enum dma_data_direction dir)
+{
+	kfree(container_of(mapping, struct mock_mapping, base));
+}
+
+/* Exporter choosing the match set entry the test asks for */
+static const struct dma_buf_mapping_match *
+mock_dmabuf_select_mapping(struct dma_buf_attachment *attach)
+{
+	if (mock_select_err)
+		return ERR_PTR(mock_select_err);
+	return &attach->matches[mock_select_idx];
+}
+
+static const struct dma_buf_ops mock_dmabuf_select_ops = {
+	.release = mock_dmabuf_release,
+	.match_mapping = mock_dmabuf_offer_match_mapping,
+	.select_mapping = mock_dmabuf_select_mapping,
+};
+
+/*
+ * Exporter decides type at first map from the match set. The result is tagged
+ * with it and the core holds the choice across unmap/remap until the attachment
+ * has been explicitly invalidated.
+ */
+static void test_select_at_map(struct kunit *test)
+{
+	static const struct dma_buf_mapping_match offer_ab[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_attachment *attach;
+	struct dma_buf_mapping *mapping;
+	struct dma_buf *dmabuf;
+
+	mock_type_a.map = mock_type_map;
+	mock_type_a.unmap = mock_type_unmap;
+	mock_type_b.map = mock_type_map;
+	mock_type_b.unmap = mock_type_unmap;
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_select_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	mock_exp_offer = offer_ab;
+	mock_exp_offer_len = ARRAY_SIZE(offer_ab);
+	attach = dma_buf_mapping_attach(dmabuf, imp, ARRAY_SIZE(imp),
+					&mock_importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+	KUNIT_EXPECT_FALSE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, attach->map_type.type, &mock_type_a);
+
+	dma_resv_lock(dmabuf->resv, NULL);
+
+	/* Exporter picks the second entry (mock_type_b) */
+	mock_select_idx = 1;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, mapping->type, &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, attach->map_type.type, &mock_type_b);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+
+	/* A pin taken whilst mapping is live gets the same type */
+	mock_select_idx = 0;
+	KUNIT_EXPECT_EQ(test, dma_buf_pin(attach), 0);
+	KUNIT_EXPECT_PTR_EQ(test, attach->map_type.type, &mock_type_b);
+	dma_buf_unpin(attach);
+
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+
+	/*
+	 * Unmapped the exporter would now pick A, but no invalidate has
+	 * happened so remap must get B again to avoid ping-ponging.
+	 */
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, mapping->type, &mock_type_b);
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+
+	/* Only an explicit invalidation allows the type to change */
+	dma_buf_invalidate_mappings(dmabuf);
+	KUNIT_EXPECT_FALSE(test, attach->selected);
+	/* map_type is kept for a pending unmap until the next selection */
+	KUNIT_EXPECT_PTR_EQ(test, attach->map_type.type, &mock_type_b);
+
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, mapping->type, &mock_type_a);
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+
+	/* Exporter cannot serve this importer right now */
+	dma_buf_invalidate_mappings(dmabuf);
+	mock_select_err = -EBUSY;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_EXPECT_EQ(test, PTR_ERR(mapping), -EBUSY);
+	KUNIT_EXPECT_FALSE(test, attach->selected);
+	mock_select_err = 0;
+
+	dma_resv_unlock(dmabuf->resv);
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+
+	mock_type_a.map = NULL;
+	mock_type_a.unmap = NULL;
+	mock_type_b.map = NULL;
+	mock_type_b.unmap = NULL;
+}
+
+/*
+ * Pin selects too and the choice survives map, unmap and unpin. A pinned
+ * importer that is never invalidated keeps its first type for the life of the
+ * attachment.
+ */
+static void test_select_at_pin(struct kunit *test)
+{
+	static const struct dma_buf_mapping_match offer_ab[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_attachment *attach;
+	struct dma_buf_mapping *mapping;
+	struct dma_buf *dmabuf;
+
+	mock_type_a.map = mock_type_map;
+	mock_type_a.unmap = mock_type_unmap;
+	mock_type_b.map = mock_type_map;
+	mock_type_b.unmap = mock_type_unmap;
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_select_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	mock_exp_offer = offer_ab;
+	mock_exp_offer_len = ARRAY_SIZE(offer_ab);
+	attach = dma_buf_mapping_attach(dmabuf, imp, ARRAY_SIZE(imp),
+					&mock_importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+
+	dma_resv_lock(dmabuf->resv, NULL);
+
+	mock_select_idx = 1;
+	KUNIT_EXPECT_EQ(test, dma_buf_pin(attach), 0);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, attach->map_type.type, &mock_type_b);
+
+	/* Map after pin uses the pinned type regardless of the exporter now */
+	mock_select_idx = 0;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, mapping->type, &mock_type_b);
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+
+	KUNIT_EXPECT_PTR_EQ(test, attach->map_type.type, &mock_type_b);
+
+	dma_buf_unpin(attach);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, attach->map_type.type, &mock_type_b);
+
+	dma_resv_unlock(dmabuf->resv);
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+
+	mock_type_a.map = NULL;
+	mock_type_a.unmap = NULL;
+	mock_type_b.map = NULL;
+	mock_type_b.unmap = NULL;
+}
+
 static const struct dma_exporter dma_exporter_params[] = {
 	{ &mock_dmabuf_simple_sgt_ops, "simple_sgt" },
 	{ &mock_dmabuf_two_exp_ops, "two_exp" },
@@ -371,6 +645,9 @@ static struct kunit_case dma_mapping_cases[] = {
 	KUNIT_CASE(test_match_importer_priority),
 	KUNIT_CASE_PARAM(test_sgt_attach, dma_exporter_gen_params),
 	KUNIT_CASE(test_mock_attach),
+	KUNIT_CASE(test_match_set_is_final),
+	KUNIT_CASE(test_select_at_map),
+	KUNIT_CASE(test_select_at_pin),
 	{}
 };
 
-- 
2.54.0

