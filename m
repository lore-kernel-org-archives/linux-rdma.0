Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.25
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658969;
	b=zacZW3qarxoY7tJt/6TPdYbXtOz1f2CB0PAx11EjBbBPBG/iczn6ZYpb7hMpKgr/3r29
	 ZWQzuAPLfPJqOP3Byx8acPnubkr51b9tNNhbRIK95nupe5OMmzBti0k51Rsp/mkwvcL74
	 eyRFtPySHFbdnq1h+jj1mhPNkxzy6RN9xLvuBc7oxmwrVXHTUg8lsewX9b49/H+RqewjW
	 eKYt044GIopRr+KRqOnwvk+4kfVpQHHixyLww5Z29POn8ka1URjOBnVBCss+/34vWIgL0
	 ZfeSVQ2u4WVE9NTFxiKr2EoX0iyIfwS4nDRKyFmqsx/wFwtxpUyNqSdI6vrXGqE/mIA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658969;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=8ZI4i1XjioIEFgxFENSVZ6Tl9Jmv0AkJ0fEbF1z5CpE=;
	b=1wQu+yEs2QuYncwQ8gP5atzbkln0b1sGDGdq+rzXSdbsFvyx7wpcuoc+I2EMNja3i0GM
	 /9hUrlH8d8F9lpdVLpEV8BKssm4yTFln5y98zY9Am52o+4fB+ci4+OSOWLc1oPWaf3Ao/
	 tE9WAUwc8m81oxah3ikU1vIK0ccIZR6YJPoYLjOoL0YjFJ4IFoLfiZDOukBqPDPRtStTe
	 rvc4OfuEhI1+D9MVjwNO8f8RRBcTkcqHhA2hwosEQZ1QnpcT62dhW2ihlMv5NhDNLYQVs
	 bU9ufzGxvlL0+fyv5QDM26gZodJs1ZJjCL6mwvd5u9zQyUXu80CbssjguGhdr/Nzy5A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JCuQIV1V;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.25
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011025.outbound.protection.outlook.com [52.101.62.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05A2606A32D;
	Mon,  2 Nov 2026 22:36:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A05A2606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JCuQIV1V
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xCQLZuRMrVFJC+cZ8Vl/nasHL8BeCZeUpxofYnY3RYscYJppLLQevC9esmWnW8mv2h7t68+muonvwIhUbttc6mhMVV6jOKE2Fl8Va2UnDJDJtWo2dSXH9Ouy1+uYdqCTMm4D8/S6ceHlWrEOsLZABbiGYy38GKBQKAVdwomLXkEjO7l9LZ+O6fdxAXH3doBTzwRPKFGbfgeLcT8Ub6vwk42LekE5u0+j9yK7JK/8kRlSbYHYSbZC4YGjGOUbodnn2qskgAMoyb16yistsZ8U0fuiWuE2JGarr3senSaUd3J0Rplu4iIu00VnBlMxqatgjRc3eUuRLKDgTQj4TKavJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ZI4i1XjioIEFgxFENSVZ6Tl9Jmv0AkJ0fEbF1z5CpE=;
 b=bcHiWPE3M3m1qowvTRIRQ3q7ksj+N195Hj0YhDOQH0epAkM8Obkf2RD87iujzLYzjGyZxVEr1WJXZ13r+4izLMhonVXe87NQQzoFOdeo/2GpO+GidO23FX7ohvIO+j+wF6EiELi9nxZ9zzYO9a2GRiuKmCYOZ2Fp96+A11BFYITZJEC4/n4LQvHpHU9VbzE6yX/XnMjl3wQeK3V75oWx1au4u48KKtHkNr2o+elVBCnwMV9/5e07g1gyqw/OLQ/L38Ho8yLiBFVIN3Mf07UQKbdZNoPcxGdnyje+Ow+SDan4cnnhUYt/cIS5c7i1aGK/lkNAb+8xSnaCT0oXhEj/Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ZI4i1XjioIEFgxFENSVZ6Tl9Jmv0AkJ0fEbF1z5CpE=;
 b=JCuQIV1VR4EhU/utg45QFn7t8ptcvaulfNikMTMZYceD6Px/VjuuLCCbrd24dGGuVQOfRzeZZD/YL2OoJtMy0K3BS+5SmDW1Wu6Ozdi46bmB5edNDXKQ2lp/5vWzjJpN7WN/b9+fNtnmyMISTGaEGkJKIYckd8EMaQz3Mapyo9/T54y7Gfi9cwQ4KgWsT1EkmDXgqXy/uGOjT/kwtc5rm8a3Ud74GpaCn1Me4BvN+PLu2Wk3zItqKcgNalKKsTL4CpgueH7sdAhKIkODtCcNncSmeMUCTK5wZA39ZG0q3OI0Jy/6VvRkZjTyHHHdng4Pp/02qBxiF12iIBrbrXkXsA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by DS0PR12MB9345.namprd12.prod.outlook.com (2603:10b6:8:1a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:35:02 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 22:35:02 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Li RongQing <lirongqing@baidu.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next v2 13/15] RDMA/uverbs: Add new Unordered MR access flag
Date: Tue,  3 Nov 2026 00:33:06 +0200
Message-ID: <20261102223325.2115128-14-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102223325.2115128-1-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0108.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:50::7) To CY5PR12MB6478.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|DS0PR12MB9345:EE_
X-MS-Office365-Filtering-Correlation-Id: 187553b6-253e-4db6-f39f-08df393188d8
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|10067099003|56012099006|261102123227099003|18002099003|261009223027099003|261009221227099003|261009220027099003|261009221727099003|261009223327099003|261022105027099003|261021123027099003|261021121427099003|11063799006|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	/Oh2vZomPz90ok9GaWj5i2tVmxchCDR24afDoup6Qir2avjZ/EhQO3bdCK0ajQCuZ0EwVIGZkRuLloHFi6/geeYLDQJjdWnqeI6/zbBwfs5WG+g1BlkV9KxfryB0p5TYV10jmRBlh0ao73DBOcxKaUBndAVj1ZmFSG2Bfl24oPNQ95fFLRts5WWfYQhdC/4T/B/ZC9e8Kvr2QrORNIFh9/sxkdBOqrE9EF0QEeKtnTeLSyb8bxtZifHu5eoTamN14apPWoUt0I7hqX8QnvroBrzCcyqKvc1WQt2h1mgC3iEp15l8hrMLc5LAOkZQu5ffsvqL+DXBSo54bgWRIm3z736MGzN3AgsGvfPI8IQFuc85QMwemSH7zde9doVaJIM32NKOXQZyTdqCpvnNbKlIHY+svzae9qiuODWv8rba7fzG19n9k6/5CICMCurQia1dwZCDe/h5RKQTGK8UeR5KpJvI095k2IeBac0Erck45F8PS/ffJzJhJcb6HH6yH0+yoRKRt/GHa8Yww2Y7FzLBCP0IEz9shWabchgndzO80s99Yc2wd6XG/UB2i6N5X+bmMgmJdi2yRdMdBkkPIyWhx6YND2CQTsTPmXcTyvwVzHuzQy9Gyejp+xdXW8DHhnQWFKe0xW2iGKKIL6L1nikdW/IlIYPcn1VacqMvWPDKMQM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(10067099003)(56012099006)(261102123227099003)(18002099003)(261009223027099003)(261009221227099003)(261009220027099003)(261009221727099003)(261009223327099003)(261022105027099003)(261021123027099003)(261021121427099003)(11063799006)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TlMXaLGTjfN0Ve7pJrHq6qQoyLEamfO6Js0LvQ67YKyfx52DXWmibKXTAwBf?=
 =?us-ascii?Q?QMUk63xC046b9dhfAYPX2mlmNXp5NCYfykznldXS1kdizHNgWO6vU5EhhlcX?=
 =?us-ascii?Q?mrkJ3qeionl9doNBLBGkfIMaLXmMcZmxlfsvDQ0vlDe8vdpz1WfoPgrd/z/O?=
 =?us-ascii?Q?qpL8hIpMw9+EYc6XlqkrwNcoC6/Bzkwdptl//Ak0yHkJHMBaFJumSjqt/83h?=
 =?us-ascii?Q?GKhf/vP/YXYw2xpSURJjnmZIRhu/UmV8Ad4WHrGF6YClADDMhh6ASlWJ6dQi?=
 =?us-ascii?Q?r8lAWI0gKXP8X6Q5NKA2zBDqgxcqdKNGG640YQODpvOZEXNQwppAiCe1Tsjo?=
 =?us-ascii?Q?Q3gzZTTFVQOC8SAusZkqjBacHiH805aTaRkylvp8OurqZBmJz4vhAIJFXGjM?=
 =?us-ascii?Q?G8DN1qQQX6vwADdsb/Aon5jUVzwZ0FfTw/PcqaMRXkcUnDOdOHY1WLMYe+PI?=
 =?us-ascii?Q?WFDZobVQinybvENze8wUsrSc7wnAPhURfhKa1wO/tMYJ/ZEUc36DZe2SfM9x?=
 =?us-ascii?Q?8ijwnd2CMBnyylophiDmLZpwBdrIsLCy5rldX/AkWwgeOuCjHUg8Rr0vgINw?=
 =?us-ascii?Q?0x66dua2z83ju5++v8KxoWAFLgm/29+s2CPwcPfWeofuHMdakGu+Z3Fxzyjf?=
 =?us-ascii?Q?9tqQ8il1sX4HmMqSqVWCu9hOT7ydM5EhAGdfkS92+I6DekkC24E1Cpk0op5D?=
 =?us-ascii?Q?L374JT2tHkpco29DnCtK0DZRTvCNRnlfdFUINnSmJ+/aIyNpyPG0y/YOdOlZ?=
 =?us-ascii?Q?Q6z8lH7ogiRmxHb8tf8W55wq6900E8H79aouJkgswVEeMXkrS1JCbErgESZ/?=
 =?us-ascii?Q?wiwrEMQczijlzj3seNaQQPzuhKhrg3AyDI2LJzkzCFQM2AKu6fuCFqEtFm0F?=
 =?us-ascii?Q?9l3yFGq1FFOyyfp/zpZUpP2hMtvQ6stqOgY8iwsngTT8sSiRmUzznYciKLhG?=
 =?us-ascii?Q?A8TupfL7WauyGpLu4E0sKVkAI5APFI2jdQbKWBd7bJbCY4rBTx4F4j8cayxZ?=
 =?us-ascii?Q?yjhyuz6QxPb54XqX5S0hmhmH+vkzv41PxLQwfoc9u8DU45L7wlbdIzTUIyQV?=
 =?us-ascii?Q?e2t1DXrl+ZqqjGV9hM4ih0ZOy7lUvlJfEFWb2GaNFaxNa2taD5te0QMmi0jt?=
 =?us-ascii?Q?zphNIStpjj681aksuuwh+bRuVQkvpsHvEHND6V3t1jZlDKyyFHEIKOkdbY00?=
 =?us-ascii?Q?dlKxUj+MM9xxIn4HXX0b+KWbHQDcu5BLdkwvr6G3HYILKcwSwUb9/eiuZtSS?=
 =?us-ascii?Q?tXCo6sxz4Tqz0utG7nfp+0L6Z+CdzY1TxVBVLNCOs/U3xwAjODmcYytIDpoZ?=
 =?us-ascii?Q?rYQENvSn9uOW3IVkLiiS3CrTCSk4wSoDLklt8pZX9nQxqb6e1kMkxWciQOio?=
 =?us-ascii?Q?Is1JGtWzXWBEIRW9pFoSdh7nP0bLc8ChEuVyajEznstGBcKCRrFN2a2zEmmn?=
 =?us-ascii?Q?HqrvC8Q+vRcGqyxyD80YXPHU6QnuSXnb9Leynj+9aAwxHIxOcrA8nxhNVhfM?=
 =?us-ascii?Q?O4ESMiocViptklx/hlm6IIsVMT72sGgbPguUBjI6MSoi716Sb66SS07y0uab?=
 =?us-ascii?Q?fUTMq+8herU+tA2OuvSkhXEKudeuiGwQj3vlgQb/vO98OZfU3rYPPp/2ZPb4?=
 =?us-ascii?Q?RVvHuB27UPFfdcMKXNoDagtLjjmXhGLrtGV/sp7/W8jtgADpPVY+fyFtNKNK?=
 =?us-ascii?Q?kQ/jyCSF8lrcq+tXRCrhldeXov0AUtnnzwR3+oeqim99KL66Cbq3jpJ7hN9J?=
 =?us-ascii?Q?AIX8qMS7xw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 187553b6-253e-4db6-f39f-08df393188d8
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:35:02.3302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r+oVgAVmeGL7dOTQs7Qlm1nYRvuzX6heu+tjeqeBVLHsqR6XuwUjSnT6rtH5D9l1hnkgVqlUgd7wcmVlfuz6Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9345

Add a new Unordered access flag for MR registrations.
This access flag allows additional relaxing of the order of memory
accesses to the memory region.
Using this access flag allows for concurrent reads and writes of this MR
to be reordered.

This access flag is part of the optional access flags range, drivers
shouldn't fail registration for any value in this range and are expected
to treat them as best-effort.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/core/umem.c          | 2 +-
 include/rdma/ib_verbs.h                 | 1 +
 include/uapi/rdma/ib_user_ioctl_verbs.h | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index b1ab4f0359b0..e07c5d439fbe 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -211,7 +211,7 @@ static struct ib_umem *__ib_umem_get_va(struct ib_device *device,
 	umem->dma_dir    = dir;
 	umem->owning_mm = mm = current->mm;
 	umem->dma_attrs = DMA_ATTR_REQUIRE_COHERENT;
-	if (access & IB_ACCESS_RELAXED_ORDERING)
+	if (access & (IB_ACCESS_RELAXED_ORDERING | IB_ACCESS_UNORDERED))
 		umem->dma_attrs |= DMA_ATTR_WEAK_ORDERING;
 
 	mmgrab(mm);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d6eaa3fee66e..29228226a236 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1505,6 +1505,7 @@ enum ib_access_flags {
 	IB_ACCESS_ON_DEMAND = IB_UVERBS_ACCESS_ON_DEMAND,
 	IB_ACCESS_HUGETLB = IB_UVERBS_ACCESS_HUGETLB,
 	IB_ACCESS_RELAXED_ORDERING = IB_UVERBS_ACCESS_RELAXED_ORDERING,
+	IB_ACCESS_UNORDERED = IB_UVERBS_ACCESS_UNORDERED,
 	IB_ACCESS_FLUSH_GLOBAL = IB_UVERBS_ACCESS_FLUSH_GLOBAL,
 	IB_ACCESS_FLUSH_PERSISTENT = IB_UVERBS_ACCESS_FLUSH_PERSISTENT,
 
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 21f86cc7bb1f..ca8b8b8d28f2 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -62,6 +62,7 @@ enum ib_uverbs_access_flags {
 	IB_UVERBS_ACCESS_FLUSH_PERSISTENT = 1 << 9,
 
 	IB_UVERBS_ACCESS_RELAXED_ORDERING = IB_UVERBS_ACCESS_OPTIONAL_FIRST,
+	IB_UVERBS_ACCESS_UNORDERED = IB_UVERBS_ACCESS_OPTIONAL_FIRST << 1,
 	IB_UVERBS_ACCESS_OPTIONAL_RANGE =
 		((IB_UVERBS_ACCESS_OPTIONAL_LAST << 1) - 1) &
 		~(IB_UVERBS_ACCESS_OPTIONAL_FIRST - 1)
-- 
2.52.0

