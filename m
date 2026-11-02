Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658852;
	b=A/r6kG10vKoakG6vk6pGWzS0jAZM5gzzGZlR3lH5kjB9pICURHmUFH60eDLY/zUlJ5Ek
	 VxJCJ+O2cTHuqd5dY0xkHqRbOZnePTbuue6WF6/Erqfynb5mbdof07f0yS1XYIVFkKC69
	 yv2LNW6FLlmg9qRyDnTIRi1jFwVAjB8P/lsQtstMgUUvjbF83w+aggjD8E69Xag6yH4XN
	 sJQLv3+xJxzsI2uXOTLZbatewZ4txc54fABbSyttFb5VJtLzoT4PfBHXGwXZvDsnAVrsd
	 6l0mBFnX/jIPHIULI7QAWBPM8PQT+8wZvxOLcWMHNK8LEArdq8tqB4JtzP3Fp9MZiBw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658852;
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
	bh=56KjI9MzG7lUwRrTtN2wc9yFRSRe+WZ1fQ5IbAzMJWk=;
	b=YmKAnKRXO/X8lKxHSmlJmBLuR64eNpbc5UJpSdwMq84lq5n38Mu3fBtv53IBK44WagWV
	 2DbuE41qGF+ohoRaBzLIVIuqlmc17ZraprTLf2AiZvoFGS6HJ7EY9EXtelCBuL2JhUO5C
	 cF6jflgZrNTgP/RMYM7zyjlsn4NetJikPy10ipgivQ+VKyaxCBhmzVnnCE3ncFqsrMPnj
	 6akWzDd5rn2/wvdJAQLSl/s6et1pWJ3lORbjFQWZzDEOxC6BJy9bZkFMBmGiudcVaUDz9
	 1GzWxHC68LYvxpwVRDUCxbU/ABy8x3DBPAtYxhDjmPaiEWASio15quOOlmSHzETIVwg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qRKgaeQS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.46
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012046.outbound.protection.outlook.com [52.101.43.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709BA606A33B;
	Mon,  2 Nov 2026 22:34:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 709BA606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qRKgaeQS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=doukN85R514LaLW1LmqvollOVF1HwSI5XAuVlL5m24O4/rFekXlWCT+Q4b9tQJvUhH9cnkDc3gAsXUNbs9y9b26KF3bNlBSuVgNOGovQDpk4ziyA0EAd6zFC4vt/8i/x9PqUSWg6ihvSvwqPaD/8JTz1YOW/AnFKAHvuemrvh0mKfUoC8b5DB3Rx/eVkniRR3hrdrvH5yGlfWsQjKgmAz+tvi4+kq2sYRBUewXbQvWBfV4POZkrM+nHExrT+19wimp/YPWJ0TtwgXK3OWSCtZCcS357cpDwEbDCLgJdbhOALuT4lV8CnY32Yfjbx9qhy8Z74ZItWdRzIbwVdWc+rmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=56KjI9MzG7lUwRrTtN2wc9yFRSRe+WZ1fQ5IbAzMJWk=;
 b=CPsSbdr05nC/Jci01/I0MJU0rAmWKbvr1j878wpKWk4+0bw84zhbR1Vp5wZseCzsw2SCZLVJiunKyWcV62chVELuLT+7DLk9QA6L2zjifNw+0MCHaWmXBCjvJQXkn1zF86kqpkAQK++RFO4IilxlTvX2Rptnj0AGIklk5kQxnM0CMMQKYLS4s8+MR+JiWYaUDvie2fK2EeiyhabxGZUKvwAN/KHDm59t31GWd7j9l32nXu3h7jPL35hVOwmsWb+V3vdhlI3l0ovyGN5VtoXIW5g2RNOwceBFEyXBv5W0wSu/CP8344FQsGl0liI6u0hROnmyQyx2c7FRvJOO4fMPnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56KjI9MzG7lUwRrTtN2wc9yFRSRe+WZ1fQ5IbAzMJWk=;
 b=qRKgaeQSnVCLmF5U8xggNuPd7k8rk82FhE6NFvwLOEW4bdIIXbThZM4hyF9Q4u0wAsvpaI/bZS50nkFRnKmxf0ab5kMIKCYYyIAVvuqlyEOwgHJ24IPJtgyOiAON1ior3kLeqURgk/WLwb2jM24VvvCF/iqPftfc4djIJ9DtJ2qcZXIQOy2g5jIIEqiZrska8YTCO/Mt8DrT9ZAJUZsZAH74vM7FD28cUkuwC2gd831y0DMfnL8yZNlbzAkVC4mmA7uXaDCd4W7w633xS3xYSFq3s0doE8s8d08y3DkIbMnBTneakf6hCSbc52UA0g55zrR1A0dUszcVhl3/G6fbGw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:34:08 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 22:34:07 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	stable@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jianxin Xiong <jianxin.xiong@intel.com>,
	Sean Hefty <sean.hefty@intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next v2 03/15] RDMA/core: Allow optional access flags in dmabuf reg ioctl
Date: Tue,  3 Nov 2026 00:32:56 +0200
Message-ID: <20261102223325.2115128-4-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102223325.2115128-1-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL2P290CA0026.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::13) To CY5PR12MB6478.namprd12.prod.outlook.com
 (2603:10b6:930:35::19)
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
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|CY5PR12MB6383:EE_
X-MS-Office365-Filtering-Correlation-Id: b22d5224-6b4c-4d89-c4bb-08df39316812
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|10067099003|18002099003|22082099003|261102123227099003|56012099006|11063799006|261022105027099003|261026140227099003|261009223027099003|261028144727099003|261021121427099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	7u8GKGCrdw3hhL3mAK9TuWUYv0jhaPvV+yOFDFMPMVfPYLmsc1OohLSbUTvTv3BQDvs35hAL50TNyDDGRyRyn/BfuNsOU8GrtndcyneqVR1XVGTH+Za6JM+7VtjZJGrWqL7v7wXOq3wWGvV73TPO4ekMHOvPbJ+8zqIXzQbtOUsYMu2A88yauD4CHcpKDHHdcmaxI8SyRvBnzxxd7f0NMSXTiVtSZyCmJmT80JAJO5osDbW+RDqU7Ygn10cUZYulQn89Y2L0GRSxnAR2MFOOc0KyRNbPKEvfQ4I7jnBTVevfFQS2eSnmyY/agOMcJ7sc0SySprj0yRz1VBtqb3OklL2kMOK/BcxX8775v0LVCPiWLABHDvY3/VUaQlDL5ooWrasFHYaVPUlQ6E+ml9ynzJgn8QOBzJ4Wut93WOuMgfFFIjT+t/qa+eIFqNTWQQM0CmCyY8oKcJnUk80KeEbAqAHi/50YCF9XAqat3C059XUhTrMx0y5Cv/vIiEf/3h8KXRlD7UIuqIhFwd5aw4hoiQ3eU8XjFJEbKfLyOoIY6g2J7VFJQ/uIti9TYsKAiYLA4j0ctAK7lvuoPZ8eZHaTkIu+c4iqNOX48ncb0OAH9UDwasxWQAZZCT1z4JHgCrv7fSMIPkXzaLhmIwex7qhfU/LnA1yXFYagKIKjctz7ltY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(10067099003)(18002099003)(22082099003)(261102123227099003)(56012099006)(11063799006)(261022105027099003)(261026140227099003)(261009223027099003)(261028144727099003)(261021121427099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pPWPoc+C3gA96SCCR70Z/NesJZLi/LwhpEq5KI64JJR1kwuzCYDIHg0zcCf3?=
 =?us-ascii?Q?xEezAw0rNLlLYoYDir2Xk0LdhwrSjKsSbYEkRoawteDxDNJpZs1/cdNbB4VR?=
 =?us-ascii?Q?/x1NEqsFLRZGtXpFkZ2v/AU5+PFfxAzrdDTNcB7H2DGgErYiMQMdf0A2Ro22?=
 =?us-ascii?Q?Y+PRkZvyIHTkaFaegphX9MgWGMbG/lvsHdTnu7vKqaU2Qgtxl/xNLoqZ4PuP?=
 =?us-ascii?Q?EZq9p7EXHkilLw/41aSbwnimcczfxquGZWM0TzKoGwANFMim82nKrNUnCFtQ?=
 =?us-ascii?Q?E88nye5JHKYOpbHDm0KRnzCad1+kxXghYQoK7rYFnUUFrjnz3F94w6FDnsKM?=
 =?us-ascii?Q?LAnxhqzDp+ycSUxtng5evlx+iu/c0R4W1Gd/G5/FAb9jvC2DP3X0iLEzW1P/?=
 =?us-ascii?Q?TW8wuCmn4tjH7K5OkNB2kEPbPQF97pgieERRllUbOuDKuIdz3j2orb5pEWsk?=
 =?us-ascii?Q?6aaeKCwZzia5ATcpKN7zg2CnOG38fDTxWedUhz7IKVolHgZqBw+tLLAUPdXN?=
 =?us-ascii?Q?a6YHwdzU+KgrIQat9GIGhn/9PXbdqU31twicYkkKAG4KBGtvY29XPMOxxEeq?=
 =?us-ascii?Q?kkBnpC0F6lS8r8nhttNVfIu+zwf5vaVmsuQOxfDea21QeDMME2FfP0yfgN5I?=
 =?us-ascii?Q?Cf4rXBADgOTd19H/Xywj5fTakWWF4AAkou9ES+vg+IcPoN55tOoJZe7+MogF?=
 =?us-ascii?Q?yQiCuQ9BnzVduyeHU+vBD5LTxVK6wzosYGm6woQhC8O93VM38Ww8PQPf2clv?=
 =?us-ascii?Q?0Tw28OOvOO28ZMdVtSLtKknGDAyjEGxi5NfcGaA3aZ6ug+uG82VTRUclcM88?=
 =?us-ascii?Q?6iS2oSC5GSPtekrNjswiiy9eAW+hHtG8Llk8RfznlVbPFP3XAFvlcHTK6zOA?=
 =?us-ascii?Q?K4zkbKhvOxcLbGPLUmOuVpuzK1nBWGhAt9WgSOemzC6Ja7yrU3xRUtRrJmj4?=
 =?us-ascii?Q?0yC8rawO5u45CnaI/K8gih5C/nhxQhoH5I+7ASz6HhKurfC6acHdB5Od0129?=
 =?us-ascii?Q?oGNbgBNqOrxchS2A8jjrjp1k6ZnhIBesrGiCBCi7I5H1KUezrmdNn6F5jKXX?=
 =?us-ascii?Q?4Uw6tkdqDbSb0FZlOsm0uKfyfeK/w5nzeuCrTItxZ3Xg3irfrFbFVcIDzHXI?=
 =?us-ascii?Q?/GisDYyAqJAYFFQ5uWoYOQIYdhM51Lm6sQTAVeMGVzstwg8oLRiIa3yfZ9Hd?=
 =?us-ascii?Q?ZSnlei56F4C20KVQMqor/TBy1/dtW8DQAn7Y4N2rUz2cU5eD3r4c6oFlBffB?=
 =?us-ascii?Q?fbiWENsTKJ6OeXjIydrGs8iLiPXIUeBRkFEi9OvKxrBgHnzKZQWVAlLz4WOi?=
 =?us-ascii?Q?qN7cnj5JYipD+7AI5XP63g5R/6zMJrkybvLVHu3lCGlCp+3BhoRb1ApUk+yp?=
 =?us-ascii?Q?SNW2bejnQ8kV/Jkcnn8JM1GHfpiN5DCiP6Q4Uu2qC3gu2O059LHIXcffe2rc?=
 =?us-ascii?Q?Nzvd1eS0XT1aIdq8C2rOj4cBXKeMPXUrpG10LwPEg0FCDfu23UWe6LAZLsPe?=
 =?us-ascii?Q?+38lruJleWaNuNFpiRJJ585At2BJMYhjqXJdwhjqCo9rOJmtjq7mRRBi/RkO?=
 =?us-ascii?Q?O5Xwg+gaKXQJsIIO/hwKZmOthH6BcMVeGYxsZWfW5qZ5eQF01bu6O58jqxvB?=
 =?us-ascii?Q?e2P4Xj5MCdsmlYppxp9zdhljx2A22GNAIP+/d2dSpv8JsZLDxihSi92cHg39?=
 =?us-ascii?Q?3wxl4lUgDxhkjpYqrxGeAaB1N31gM04fBufU58i9Tnx9PDmkmV7jpdclFEyn?=
 =?us-ascii?Q?8YUWt0Mluw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b22d5224-6b4c-4d89-c4bb-08df39316812
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:34:07.2969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7hWsYfpt23kp9SAVR/4yHH0kww9ICha3rN9LrtNWdbjIUVCtN/Ji2vBOt/MNWk42sajyH74S13PMSfW8Uuhsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6383

The uverbs ABI reserves the optional access flags range as best-effort:
drivers should accept any flag in this range and treat the actual support
as opportunistic, never failing registration when an optional flag is
requested.

Add the optional access flag to the allow-list of dmabuf registration
ioctl. Uverbs users can now request any optional access flag on dmabuf
registrations and drivers will apply the flag's effect on a best-effort
basis when supported.

Fixes: bfe0cc6eb249 ("RDMA/uverbs: Add uverbs command for dma-buf based MR registration")
Cc: stable@vger.kernel.org
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/core/uverbs_std_types_mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infiniband/core/uverbs_std_types_mr.c
index 0c72f801e0d3..b6d6cbe448a2 100644
--- a/drivers/infiniband/core/uverbs_std_types_mr.c
+++ b/drivers/infiniband/core/uverbs_std_types_mr.c
@@ -229,7 +229,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_REG_DMABUF_MR)(
 				 IB_ACCESS_REMOTE_READ |
 				 IB_ACCESS_REMOTE_WRITE |
 				 IB_ACCESS_REMOTE_ATOMIC |
-				 IB_ACCESS_RELAXED_ORDERING);
+				 IB_ACCESS_OPTIONAL);
 	if (ret)
 		return ret;
 
-- 
2.52.0

