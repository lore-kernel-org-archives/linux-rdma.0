Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993099;
	b=SRxJWOWT1GrVpdySv7NDYLY1TT0FLw9PCUvJDeoikl0ktHuF2TcLkZVTuAkeoJkVOrww
	 wC8RUOLSp9/YSxiT83idfXWNbp5tL5pTlXGgi8d1/BEgAMyMXzoWWZGtifEPQ5j1mN9rK
	 wM0wV6Js+6vaU4KFkJbDjgQaO1fvEk30pig6YfMtjV4Aiy8QBcyCHg+akllhmXAlodigt
	 AwplRBgwXJuKp/YQIO3MKG4ag1psEqvXgeazD2AJGf55wOeq44C6Llb2DM4xHUHFTr2Z3
	 o+X3TcgmnWgkTTXrBN6DiBqcqY8evJ9lKlgKOI1GERp7+uwqN/mxJx6xJjAwj8F1yxw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993099;
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
	bh=6dRCzn5viTe7SKeHNjAEAXsjfYd/OOnFavncKBFIXNI=;
	b=fVGtJFV3ZlSxBBn+IfQpikwTN63ZqII7uLaEwXiEBaoKSl1whTiVne8r/lFrwtGd2km2
	 I4E59aVq+DmvW8f+bI9DrHqhH0x9RCniQ2nZScXUf1cRdA9VWbPo7oAWQJAKdSqGw2+d/
	 biHnomcGw+/WT4IKrA8HjZzJNt+7NLCe5hMeLz9PjNFmNFPoRs8LgD4ZrPTLhstf0QWqm
	 gAUoHwx7Ui2mY8LUva9RldSY31ho9UW9QKAB8BEfpdAJLNXWYBm+RWO3qD2bqJUmJBcdS
	 HvVCNSC7xb1W6fXQoaGCc1xuMuGWqhcTgbVVXxN2bGvUj9TP359nGMaWk9IqN0+fJZg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VTsK+wGQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.55
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012055.outbound.protection.outlook.com [52.101.53.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D2F60A2617;
	Mon, 26 Oct 2026 05:38:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17D2F60A2617
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VTsK+wGQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A6FhklNO3pSZBHbtQ3PdAhkZlDuRt+dIH8FjHjzlqWndkEsaIK6ipA5llJjN/3U+PsuRh1foSEM+AlAZkKc6G0wBRgnZ1bjFsEURutiqJ7MxEl3c410003Q7jdxrGzGQ0epVkDr8nToSMsyMTHVcwbPJ9CXXMx/ZWJQu/ZJd9KpnDmDTFo90DnhRL4EZ4McRBZFbFxQzAqu0iPj/c4ngWQsnO2WGd/4IDv6DYEmBclX6/qxIOZjk5dZFHIpmmnjbR70cXPDeKTcx0H00jOH9Bti3je3iiHvwK9aIqVDIyTgz92urXfjEIbDkyO5LOGgBohzEYCEpxAw2NFtVjfNDTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6dRCzn5viTe7SKeHNjAEAXsjfYd/OOnFavncKBFIXNI=;
 b=fQIL7K9fH53hj5ozsrCqyc81BGQpoomOfFjU5GVdXK1ru88vYFBz6dl4B6dtVf/82UzZvBOKBILX4s0I6nSISneRjDCukp2wEvyjuESnzr30B/qs+YePemP7AP2yXDZDGTeaacgot//8iRTv1HkCsov5v2ubioBfYZ9zhNoDHiVCePt6eGcUMR7o9OjXvPkygnLxFYoXGmrMXMQUm2pVFsMn9J2i1IfTC3SdUoylnA9Hq7Lm1RQewwAK9floMiOlEWme5OUidzHrCCCp/r0xcWay6YCNvTDiJtbIQwlNeJfb0UBSl116VBWdJJha9/5FZmw48UWmI6U08vwikrwHMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dRCzn5viTe7SKeHNjAEAXsjfYd/OOnFavncKBFIXNI=;
 b=VTsK+wGQJq5THEcdYMFfdD6o9BT/KxA5MpOB7AZotbJngzz4pC18cEgIeY2HTeXCljxUZmVTiUllnRrhUtU/yEZR/eISxKJHROtJdc0SRGyWG/YWJTjYQhGjjSIXQvj1IWqbF1mNyE7o3RLvjLlkxQBf++gArMh0gJheVsFZpJSIIWuyBBeo3UWkA8MXjYOWt5naswDKNqgOkbgpAyJAYzJFjvYWyIBp6zC8rS36pCltVEdfK8c5PVO4oc3OeGHwT4RQafZu+1TqM5f+QQFgh9v4KnLdzPjhPs4McCT1Bd3QMuRIjvR5mxVzdceHDYyI+H8ZlLOjNRvZL/B6TMzovQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SJ0PR12MB6967.namprd12.prod.outlook.com
 (2603:10b6:a03:44b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:38:15 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:38:15 +0000
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
Subject: [PATCH 20/26] dma-buf: Remove unused SGT stuff from the common structures
Date: Mon, 26 Oct 2026 16:36:11 +1100
Message-ID: <20261026053623.202642-21-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5PR01CA0040.ausprd01.prod.outlook.com
 (2603:10c6:10:1f8::6) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 1f418314-c100-4c12-3b9c-08df33235500
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|18002099003|22082099003|6133799003|3023799007|56012099006|11063799006|261022075727099003|261021121427099003|261021123027099003|10067099003|261009221227099003|261009223027099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	o5B0l4OqKId2FhQ0+oRaF0yVmdzSJ/MQMPawF0EQPhdhbksowsFLTeIm5yN2HFbMEClQoabwr0bR6yLCA04w4S5vUzFEyGjhoBaejtFfqgyr2qQWeL4u2khE+taHdDIoDyijC5VhgtiJg5yCORynzY9a+SNTZl/RhiZ5NHjdIoiB1M+RwOencSU4/6D4yH7GmYkum6jJkMS3VMArhg2CUULofkRro9jkWxM+hBasQMONKhVwGxz3i0Aq1kX1+O9OYXSGICI+JASdoq+z1udcu2F7+gSH9HYZO7zA6THb4IdpcS3rj892UZAm0cU+C1SjCm4555kDu2ap3uL2P8DYA6xKreokRBHgrh2l/1ZsXoz3CRjk+3OGZ6Ic0BB9llPDMKJ6I8GexqBjrIz0fRIM8edqkpMtSqR17mvwsGgOX+GMHzWj9Fx63ZGQ/OM2uYsthZB6ibZRX0r+tU3uAkKNj6SpKH0WlF6M+c5nV29g4s6lpCXdEc/pLj+TN0IZsioLw0u+mUVsk0FwEPQULNXcyRD8KkuzkY1JIiMLHYO8QO3u1TPgQqRlRZhXujcI0Plpu2c4bhuI4EVHl1LqQHZib5igZU18MqLz9I2+T43Y7+/+0IebCkx3fAXjayPJZVUOsiJF9hhmJnzx+t8+PTNEuShyZTsMjT2Ty96rF3V7ClM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(6133799003)(3023799007)(56012099006)(11063799006)(261022075727099003)(261021121427099003)(261021123027099003)(10067099003)(261009221227099003)(261009223027099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RyWAg3nBe1fpi6KwBrZmIhwjQdCqNpMEeKp9719yExYug+KaWP4SwiE6W6yO?=
 =?us-ascii?Q?C+hSo3sbvZaySMjfA2a4qAIiosMwqr2bES4yP4dvnuE2gqb+CoYmkigJT7nj?=
 =?us-ascii?Q?oWGvh76FT0C9RIasM8bCGAfSlqGGqbA+2yJDphmfHBFp3+1o1twPJgIv47V1?=
 =?us-ascii?Q?/flxcBGh9z2ahDXnxFVtQQKbrV3zgeIZEAQs7VFNpBdOCD1zCftfngGGDam8?=
 =?us-ascii?Q?pLHVdZ1FpqCp9bgGVzlgbWBq7bUn9kO7ZlpLdLwGXHCmV1QIOd3CblHbJwqt?=
 =?us-ascii?Q?vA6wM4wDeuFUMLB0nEaGt7A7AqY1uOI80ZVhacNbpVVHNrEr8BmHYdlsqxtQ?=
 =?us-ascii?Q?iKn1j9WFo9GqOnAlEqZGFF5EqZnLSTO2q88/CB3YxBamn5XE4lpY5VKHsNE4?=
 =?us-ascii?Q?DaB87jOAdzh4DuaANkNKGb50PL3KhhQ/d0bvFTbxDUUxW4FGtVq0NDmD74f8?=
 =?us-ascii?Q?zJE+k/pvKbaO+EWDecKF0T6CemrUUNTWwGHZqxZWIDUEf4liameiMa/VMCvX?=
 =?us-ascii?Q?HvJCCvfUS9qL1uDH9yAPSqm4TbI3HIfa5EgSSwRNAaKNdOfMarBCmvfP+HEp?=
 =?us-ascii?Q?cudAVrEo0KdCSBjTBA3aXPbFk2UX9PSElg/cEdaq65naiWPZGsAjIYSlP0Ae?=
 =?us-ascii?Q?nEhIQqC3NLElANct2DTVdZfFFuL9ZKz/YUY5flX7jwZG/zxX1K8QAS5zmTkY?=
 =?us-ascii?Q?00kUsULDURmmi8NmrP3LXqr7ivAr3Ch9j4lLr7fsgqmR3egs3mGv05vZvXtl?=
 =?us-ascii?Q?FyCCTuo7S0t7xnob5IxpF0rq6I8Y1EfQs7FYQJxtj9pfbzG0IAW7IU0MlZ+u?=
 =?us-ascii?Q?Jq6DnILhMMUiFp5QtSxLlMjeR9NZau/T1nrSR9Yg4vKpAPqtCv+wDCXKFOcY?=
 =?us-ascii?Q?YiNXUDW1hCwbm9AEjhtoox0D7ICNxgOikMKwF0R0n10YCsOAD8PbVoJv7X/3?=
 =?us-ascii?Q?1EHFYODMxZK1DJT9i86zrt3wcBnhhC6NdlboUQjJzFBAR2Lzp7m8GSYdaZFB?=
 =?us-ascii?Q?sJRsxY68npdii+Rnnbzu3UcSvkBa0WEHRTOCVuJLcZqaJEvFN/WTsniFFR/H?=
 =?us-ascii?Q?FSMQ7v4eep28HbKiVooZPpETZ4rI6F/aqESA/RzmeiNPPea08Q6rpZgfbI4z?=
 =?us-ascii?Q?3K+Gtnm6sg50uVNieGOa53uV1Xd8lrzPxlalCQLkk0fVUgirrb7Rm6Vb+ZDb?=
 =?us-ascii?Q?9szJX9Oxe1IdvShzNRi3YDIXMjYHXv/QYmyWPObxBm1zD1xIzzKibBBucsWP?=
 =?us-ascii?Q?k8yD5eJDnyPvbN2Ev90i8ZcNrwnmKjbt77lyXx+TJcSz4HpWRHZ94Jx/4mGc?=
 =?us-ascii?Q?3Td3DdLsx44umwHYYwzSDtoO4eYkAdz1HvJ80hI8d26ss0fhcWb36aJWzOsj?=
 =?us-ascii?Q?1YYRDgiMRwexciNd7nHqPr/CfCqfxAz6ThZ73DQU8fbwoic0HZiJwj0J5Khx?=
 =?us-ascii?Q?y/mfmeP0q7uqFPZ5fDXqrVPwGVHrmsW/+jEzKw8CE2GQZfXGGokp+hlRCkp9?=
 =?us-ascii?Q?r9BrGxmdIbGg2UylqrDIPX3rXtMT7AvzGcZXXO3Ii5ShSjixYx5rvqpAbH83?=
 =?us-ascii?Q?d75Do9Tm1l08pshqY69ttRbOY5qWqUrnDzjFyDi6wkp86OMs7ZMuMLrd2td3?=
 =?us-ascii?Q?gO8UWGe6Yf2yhWmb8apEQqzJrPHLhfWdMZ7sJa63BHzEnHrXll/Pd4ukWBVV?=
 =?us-ascii?Q?1HSVyTLXWAStEne7Oe8QeWcfNqjcDQdOQiwmjRzKBg6jLUCBpgk1hoKVeaWa?=
 =?us-ascii?Q?errkVnHVhA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f418314-c100-4c12-3b9c-08df33235500
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:38:15.3590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S44SmNYSjK4cXRu2Msqv3CNtY1uK/KSIZeFvUjx9CYaeC8HiqOsZ8TR9dC66jajbrtHFXKWMB62kQALDbVCQlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6967

From: Jason Gunthorpe <jgg@nvidia.com>

Now that all exporters are converted these compatibility things can be
removed:

dma_buf_ops: map_dma_buf/unmap_dma_buf
             Moved to dma_buf_mapping_sgt_exp_ops

dma_buf_attachment: dev
		    Moved to attach->map_type.importing_dma_device

dma_buf_attachment: peer2peer
		    Moved to attach->map_type.exporter_requires_p2p
                    accessed via dma_buf_sgt_p2p_allowed()

dma_buf_sgt_exp_compat_match: No compatibility exporters anymore

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ use dma_buf_sgt_dma_device(attach) in dma_buf_detach trace point instead of attach->dev - apopple ]
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c | 40 -----------------
 drivers/dma-buf/dma-buf.c         | 27 +++---------
 drivers/gpu/drm/drm_prime.c       |  2 -
 include/linux/dma-buf-mapping.h   | 67 +++++++++++++++++++++++++++-
 include/linux/dma-buf.h           | 73 -------------------------------
 5 files changed, 72 insertions(+), 137 deletions(-)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index 7d20979af7fb..403f8432586a 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -479,16 +479,6 @@ dma_buf_sgt_finish_match(struct dma_buf_match_args *args,
 			.exporter_requires_p2p = exp->sgt_data.exporter_requires_p2p,
 		},
 	};
-
-	/*
-	 * Setup the SGT type variables stored in attach because importers and
-	 * exporters that do not natively use mappings expect them to be there.
-	 * When converting to use mappings users should use the match versions
-	 * of these instead.
-	 */
-	attach->dev = imp->sgt_data.importing_dma_device;
-	attach->peer2peer = attach->map_type.sgt_data.importer_accepts_p2p ==
-			    DMA_SGT_IMPORTER_ACCEPTS_P2P;
 }
 
 static void dma_buf_sgt_debugfs_dump(struct seq_file *s,
@@ -506,33 +496,3 @@ struct dma_buf_mapping_type dma_buf_mapping_sgt_type = {
 	.unmap = dma_buf_sgt_type_unmap,
 };
 EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_sgt_type, "DMA_BUF");
-
-static struct sg_table *
-dma_buf_sgt_compat_map_dma_buf(struct dma_buf_attachment *attach,
-			       enum dma_data_direction dir)
-{
-	return attach->dmabuf->ops->map_dma_buf(attach, dir);
-}
-
-static void dma_buf_sgt_compat_unmap_dma_buf(struct dma_buf_attachment *attach,
-					     struct sg_table *sgt,
-					     enum dma_data_direction dir)
-{
-	attach->dmabuf->ops->unmap_dma_buf(attach, sgt, dir);
-}
-
-/* Route the classic map/unmap ops through the exp ops for old importers */
-static const struct dma_buf_mapping_sgt_exp_ops dma_buf_sgt_compat_exp_ops = {
-	.map_dma_buf = dma_buf_sgt_compat_map_dma_buf,
-	.unmap_dma_buf = dma_buf_sgt_compat_unmap_dma_buf,
-};
-
-/*
- * This mapping type is used for unaware exporters that do not support
- * match_mapping(). It wraps the dma_buf ops for SGT mappings into a mapping
- * type so aware importers can transparently work with unaware exporters. This
- * does not require p2p because old exporters will check it through the
- * attach->peer2peer mechanism.
- */
-const struct dma_buf_mapping_match dma_buf_sgt_exp_compat_match =
-	DMA_BUF_EMAPPING_SGT(&dma_buf_sgt_compat_exp_ops);
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 6c9ab8bc09ac..dc65752fb0fa 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -718,19 +718,9 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 		    || !exp_info->ops->release))
 		return ERR_PTR(-EINVAL);
 
-	if (exp_info->ops->match_mapping ||
-	    exp_info->ops->single_exporter_match) {
-		if (WARN_ON(exp_info->ops->map_dma_buf ||
-			    exp_info->ops->unmap_dma_buf))
-			return ERR_PTR(-EINVAL);
-		if (WARN_ON(exp_info->ops->match_mapping &&
-			    exp_info->ops->single_exporter_match))
-			return ERR_PTR(-EINVAL);
-	} else {
-		if (WARN_ON(!exp_info->ops->map_dma_buf ||
-			    !exp_info->ops->unmap_dma_buf))
-			return ERR_PTR(-EINVAL);
-	}
+	if (WARN_ON(!exp_info->ops->match_mapping &&
+		    !exp_info->ops->single_exporter_match))
+		return ERR_PTR(-EINVAL);
 
 	if (WARN_ON(!exp_info->ops->pin != !exp_info->ops->unpin))
 		return ERR_PTR(-EINVAL);
@@ -1082,12 +1072,8 @@ struct dma_buf_attachment *dma_buf_mapping_attach(
 		if (ret)
 			goto err_attach;
 	} else {
-		const struct dma_buf_mapping_match *exp_match =
-			dmabuf->ops->single_exporter_match;
-
-		if (!exp_match)
-			exp_match = &dma_buf_sgt_exp_compat_match;
-		ret = dma_buf_match_mapping(&match_args, exp_match, 1);
+		ret = dma_buf_match_mapping(
+			&match_args, dmabuf->ops->single_exporter_match, 1);
 		if (ret)
 			goto err_attach;
 	}
@@ -1180,7 +1166,8 @@ void dma_buf_detach(struct dma_buf *dmabuf, struct dma_buf_attachment *attach)
 		dmabuf->ops->detach(dmabuf, attach);
 
 	DMA_BUF_TRACE(trace_dma_buf_detach, dmabuf, attach,
-		dma_buf_attachment_is_dynamic(attach), attach->dev);
+		dma_buf_attachment_is_dynamic(attach),
+		dma_buf_sgt_dma_device(attach));
 
 	kfree(attach);
 }
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index d797598e42f7..7792caf87883 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -593,8 +593,6 @@ static bool is_gem_map_dma_buf(struct dma_buf_attachment *attach)
 	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops =
 		dma_buf_get_sgt_ops(attach);
 
-	if (attach->dmabuf->ops->map_dma_buf == drm_gem_map_dma_buf)
-		return true;
 	if (sgt_exp_ops && sgt_exp_ops->map_dma_buf == drm_gem_map_dma_buf)
 		return true;
 	return false;
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 4aaddad8c7be..91a55cbe0bb4 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -202,8 +202,73 @@ dma_buf_sgt_mapping_table(struct dma_buf_mapping *mapping)
 
 struct dma_buf_mapping_sgt_exp_ops {
 	struct dma_buf_mapping_exp_ops ops;
+
+	/**
+	 * @map_dma_buf:
+	 *
+	 * This is called by dma_buf_map_attachment() and is used to map a
+	 * shared &dma_buf into device address space, and it is mandatory. It
+	 * can only be called if @attach has been called successfully.
+	 *
+	 * This call may sleep, e.g. when the backing storage first needs to be
+	 * allocated, or moved to a location suitable for all currently attached
+	 * devices.
+	 *
+	 * Note that any specific buffer attributes required for this function
+	 * should get added to device_dma_parameters accessible via
+	 * &device.dma_params from the &dma_buf_attachment. The @attach callback
+	 * should also check these constraints.
+	 *
+	 * If this is being called for the first time, the exporter can now
+	 * choose to scan through the list of attachments for this buffer,
+	 * collate the requirements of the attached devices, and choose an
+	 * appropriate backing storage for the buffer.
+	 *
+	 * Based on enum dma_data_direction, it might be possible to have
+	 * multiple users accessing at the same time (for reading, maybe), or
+	 * any other kind of sharing that the exporter might wish to make
+	 * available to buffer-users.
+	 *
+	 * This is always called with the dmabuf->resv object locked when
+	 * the dynamic_mapping flag is true.
+	 *
+	 * Note that for non-dynamic exporters the driver must guarantee that
+	 * that the memory is available for use and cleared of any old data by
+	 * the time this function returns.  Drivers which pipeline their buffer
+	 * moves internally must wait for all moves and clears to complete.
+	 * Dynamic exporters do not need to follow this rule: For non-dynamic
+	 * importers the buffer is already pinned through @pin, which has the
+	 * same requirements. Dynamic importers otoh are required to obey the
+	 * dma_resv fences.
+	 *
+	 * Returns:
+	 *
+	 * A &sg_table scatter list of the backing storage of the DMA buffer,
+	 * already mapped into the device address space of the &device attached
+	 * with the provided &dma_buf_attachment. The addresses and lengths in
+	 * the scatter list are PAGE_SIZE aligned.
+	 *
+	 * On failure, returns a negative error value wrapped into a pointer.
+	 * May also return -EINTR when a signal was received while being
+	 * blocked.
+	 *
+	 * Note that exporters should not try to cache the scatter list, or
+	 * return the same one for multiple calls. Caching is done either by the
+	 * DMA-BUF code (for non-dynamic importers) or the importer. Ownership
+	 * of the scatter list is transferred to the caller, and returned by
+	 * @unmap_dma_buf.
+	 */
 	struct sg_table *(*map_dma_buf)(struct dma_buf_attachment *attach,
 					enum dma_data_direction dir);
+
+	/**
+	 * @unmap_dma_buf:
+	 *
+	 * This is called by dma_buf_unmap_attachment() and should unmap and
+	 * release the &sg_table allocated in @map_dma_buf, and it is mandatory.
+	 * For static dma_buf handling this might also unpin the backing
+	 * storage if this is the last mapping of the DMA buffer.
+	 */
 	void (*unmap_dma_buf)(struct dma_buf_attachment *attach,
 			      struct sg_table *sgt,
 			      enum dma_data_direction dir);
@@ -304,8 +369,6 @@ DMA_BUF_EMAPPING_SGT_P2P(const struct dma_buf_mapping_sgt_exp_ops *exp_ops,
 	return match;
 }
 
-extern const struct dma_buf_mapping_match dma_buf_sgt_exp_compat_match;
-
 /*
  * dma_buf_ops initializer helper for simple drivers that use a single
  * SGT map/unmap operation without P2P.
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index d78eec3476f3..77a18b9817ac 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -152,75 +152,6 @@ struct dma_buf_ops {
 	 */
 	void (*unpin)(struct dma_buf_attachment *attach);
 
-	/**
-	 * @map_dma_buf:
-	 *
-	 * This is called by dma_buf_map_attachment() and is used to map a
-	 * shared &dma_buf into device address space, and it is mandatory. It
-	 * can only be called if @attach has been called successfully.
-	 *
-	 * This call may sleep, e.g. when the backing storage first needs to be
-	 * allocated, or moved to a location suitable for all currently attached
-	 * devices.
-	 *
-	 * Note that any specific buffer attributes required for this function
-	 * should get added to device_dma_parameters accessible via
-	 * &device.dma_params from the &dma_buf_attachment. The @attach callback
-	 * should also check these constraints.
-	 *
-	 * If this is being called for the first time, the exporter can now
-	 * choose to scan through the list of attachments for this buffer,
-	 * collate the requirements of the attached devices, and choose an
-	 * appropriate backing storage for the buffer.
-	 *
-	 * Based on enum dma_data_direction, it might be possible to have
-	 * multiple users accessing at the same time (for reading, maybe), or
-	 * any other kind of sharing that the exporter might wish to make
-	 * available to buffer-users.
-	 *
-	 * This is always called with the dmabuf->resv object locked when
-	 * the dynamic_mapping flag is true.
-	 *
-	 * Note that for non-dynamic exporters the driver must guarantee that
-	 * that the memory is available for use and cleared of any old data by
-	 * the time this function returns.  Drivers which pipeline their buffer
-	 * moves internally must wait for all moves and clears to complete.
-	 * Dynamic exporters do not need to follow this rule: For non-dynamic
-	 * importers the buffer is already pinned through @pin, which has the
-	 * same requirements. Dynamic importers otoh are required to obey the
-	 * dma_resv fences.
-	 *
-	 * Returns:
-	 *
-	 * A &sg_table scatter list of the backing storage of the DMA buffer,
-	 * already mapped into the device address space of the &device attached
-	 * with the provided &dma_buf_attachment. The addresses and lengths in
-	 * the scatter list are PAGE_SIZE aligned.
-	 *
-	 * On failure, returns a negative error value wrapped into a pointer.
-	 * May also return -EINTR when a signal was received while being
-	 * blocked.
-	 *
-	 * Note that exporters should not try to cache the scatter list, or
-	 * return the same one for multiple calls. Caching is done either by the
-	 * DMA-BUF code (for non-dynamic importers) or the importer. Ownership
-	 * of the scatter list is transferred to the caller, and returned by
-	 * @unmap_dma_buf.
-	 */
-	struct sg_table * (*map_dma_buf)(struct dma_buf_attachment *,
-					 enum dma_data_direction);
-	/**
-	 * @unmap_dma_buf:
-	 *
-	 * This is called by dma_buf_unmap_attachment() and should unmap and
-	 * release the &sg_table allocated in @map_dma_buf, and it is mandatory.
-	 * For static dma_buf handling this might also unpin the backing
-	 * storage if this is the last mapping of the DMA buffer.
-	 */
-	void (*unmap_dma_buf)(struct dma_buf_attachment *,
-			      struct sg_table *,
-			      enum dma_data_direction);
-
 	/* TODO: Add try_map_dma_buf version, to return immed with -EBUSY
 	 * if the call would block.
 	 */
@@ -562,9 +493,7 @@ struct dma_buf_attach_ops {
 /**
  * struct dma_buf_attachment - holds device-buffer attachment data
  * @dmabuf: buffer for this attachment.
- * @dev: device attached to the buffer.
  * @node: list of dma_buf_attachment, protected by dma_resv lock of the dmabuf.
- * @peer2peer: true if the importer can handle peer resources without pages.
  * @priv: exporter specific attachment data.
  * @importer_ops: importer operations for this attachment, if provided
  * dma_buf_map/unmap_attachment() must be called with the dma_resv lock held.
@@ -591,9 +520,7 @@ struct dma_buf_attach_ops {
  */
 struct dma_buf_attachment {
 	struct dma_buf *dmabuf;
-	struct device *dev;
 	struct list_head node;
-	bool peer2peer;
 	const struct dma_buf_attach_ops *importer_ops;
 	void *importer_priv;
 	void *priv;
-- 
2.54.0

