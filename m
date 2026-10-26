Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993056;
	b=ocNsjIvj+f2l9bviLL6Ceu+xFmPNLyecOvjN4zVQCUq0WneN1u69dbzmoD7mxb+AIXqa
	 Ik3rolSt2PaV/w/B/BnFxAcRbqx+WCFT6yywsJePFhidsorfikrQD+V7k4iPNwiKE0uLW
	 pdpRyaG4wHyk78ug70NjYQ29jYMMlUU/fHoPnCa+I3MQX6KOAn8W/WRAI3KRsVMA/oV3+
	 MqT3fRFoWlP/lhw3sD6n55bhh3iezN+b67i3ajxdjNXn2AR5d/k0P6JND2VgCcP+D9IT4
	 NdJP0rk9uGDXNYB9FbRnure6hYjRaXfbmOtBbRGxS+zYp6e87OFliGnSXsY6rmBX0oA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993056;
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
	bh=e620eFYwVJHmoOsxw1qJMRyMchsPxMEWnCO9UzQllU4=;
	b=OpHy+KpIhWi5GnjAN+Hmd2ryaktVH4NKLVABdfIt2eO/8GomZGSrxHmd9YUHI/g1ExTW
	 LdwHmGu6IFm3q+s8ECjbWqxzANTgp2A/1/PQQw7lMlyDVbeTFJT3c9F3O0ssXVIWed4ou
	 53V7ZbZUoaa31f9fEUspVO/LKh5zyI3oJuOjHqJMFziKoaLP56b4nQuwGOdR0DaNt6u6i
	 QtPp1XyDGCKdBNER+ztCLPHqFD4zb8Xa65pxC0+nRkwUQQJC2RqRUN3xtNO77xl2OsrZQ
	 9Ax51CB6WRCfc0jrhp2VAjunMBRplds7RhIJoeWBe5aouhYv1/lNPL80V8Vln2nqd3g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GL3cZhZn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.7
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012007.outbound.protection.outlook.com [40.93.195.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E3B60A3821;
	Mon, 26 Oct 2026 05:37:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43E3B60A3821
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GL3cZhZn
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t+K3Nd8cpIAKqwgyXTeipZCsJYaAjiIlFGNVfCIrh3vILNvRQudWB4sLvzXQPBpzN7cXWrGNyR2l6FHctgbb1nEOLg6bQKeApAFjiixkGdqprS7O5thxblYFgodZPa8b+EoKULR08unmI1mjU3dextLa4S6kPBnkM7wKGGPcAkQo12JL03wCRypekx6pRdoPZ7VICaTi/vn0yaNN8Mk/kcc9+4KOd7EtsvzhuVaw5S8c80+KWGSUEug0MVRRBJtvoSUlJ17pjzqi7Ip1vC1oFF5Z3esHI3c1FLoOJXHj7s4uqjSMwTRyt1erbgZL+Ex2lClNS67nsFiwwv8OsRbD8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e620eFYwVJHmoOsxw1qJMRyMchsPxMEWnCO9UzQllU4=;
 b=eJ6lGFOICs//60WUYdrxWn4wzTWoq0mDChd6ArE41jUYBvkjPoF5G38bsdUEJJjHU54xcBsxmHnpGFx97mxV55j9wIsVbTuZpObCCXVIEh3KdJUMsegg3ZvadFnQPWBxhf4G4pchDB8VLGzYx7KWdqoVvG+90g5kZoLvYDZk642RUx2p63ylXlhYBTwfsVOm8/K9xsLbMRKGxXF3OteikaLC+w4tMeGg0ECTtqBFN9bO7dP+Wqtd0kfZaCCpFR5JVrUX7U0XzyvXnfgmy6OOCrWRvF4ps4ntnZ1/z9X6quZtiNnmvaEms+8SOTqvFRM6xLmATJdcTuazA8tLgBa8mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e620eFYwVJHmoOsxw1qJMRyMchsPxMEWnCO9UzQllU4=;
 b=GL3cZhZnPCtQNZz8xRZRO2CiHSBrCBugFV/pfo67Y1VMvS9mXkg3wFHlAPklIUDXoGwgDJuSFllbtGpyNu1P4sVyLgV8BYjrinW0xstTuICso4JSOZX06Ajobxur5L5GkVH4GZZoDxh6rrkU4QPyd5271S2xWrSf1/qO0Bo/8P7ffGUnbH+dRtuuIRfCNcivCuW9mG9kjxtPfyuZHtM/uPLSqH09gxN8rHbSgOR2ocjFOgEO416A6y2CVXQUOAg+7yfgcf7qYW+6BkN9zkKBmCd6gtRkZICgoyi3KUVOg6mK9wW6YIOpt2LR3DiUjUYM2geYEIzFy7HH4yS8bKMJvw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SA1PR12MB7442.namprd12.prod.outlook.com
 (2603:10b6:806:2b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:37:31 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:37:31 +0000
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
Subject: [PATCH 11/26] drm/vmwgfx: Use match_mapping instead of dummy calls
Date: Mon, 26 Oct 2026 16:36:02 +1100
Message-ID: <20261026053623.202642-12-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P282CA0123.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:209::7) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 625421a2-ab71-4ad3-e6c0-08df33233a83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|6133799003|22082099003|56012099006|11063799006|261021123027099003|10067099003|261009223027099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	s3D6FUHGkVlODCpMdpemcVbCDZnEWIQ0spEl11phq5YEL54Nzi/d5W+MEclEgs4oRvPDWbbm9gNc9ycevqb9y3gAl4rjrtJIqdkq+aVZSxOwuiDl/0U55lCPytn02x381hzuuAJxZdMcPw/7M3GOnX5V0dznJID9j+iaOlMWjEKw3cRhEsCmGcdXX+Tjtmj9Aou0sGwwTvtgeshKW2StS50A/X2QjpKzC2/IiM0skKu7Hxs0DGRCBj09yAUCek1vZDWCTOzUv8m8K5rk0QCziciUmIPNhnA78JkIHyONXjJawmtuVSBocbxFpbBvjkRWwOuE1fJAhI+GQEdckJsI1lhOA29jWKH17IL9WBBo3ewgysgZ3cyKIuz+Bx6rUNDSYW4sGbjsnpkuHBinPjJQh4womdJm1TW9mXiluA4/BXaG8Ycjymr35La0t7kwInhPiHYbYArI1yQCJgsGXrbnOR6NMyA4FjtuJaA8XWO9XCJJfdy7yB40Kh6jNWXjM1fUZnYwMHrpgZLTh50uTUZ9MvYSXDvh9MS5nUO9l7d97Edy3WHwvsCSajSLxSpGIlIgR0Qjnfm13nqYj5/nU5FJ5JfX2/X0kMmPVBH4WEhiRRY6NSf95T9ArgbzEIQJkkkIy/ENpJiP0O+leHU0lo5AIA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(6133799003)(22082099003)(56012099006)(11063799006)(261021123027099003)(10067099003)(261009223027099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x6a85lMZog5MEO7hJHBR4WqNDvWuXbuR/b6rFt+qR0NVc+7w6RRLXpwXP8Yz?=
 =?us-ascii?Q?2nrq85EibNcCLg6ASyabieZxH6Ytjlnzfrhtw/Vf7a4EH2Ey34grxQVO/5CV?=
 =?us-ascii?Q?6XYfXUFxvpSX60gAKr+Teej7JStxPxlgu192f9n2GsCA0kip+Svzgx+y1+CV?=
 =?us-ascii?Q?GH6pG+CT9JnT0QQE8Tk0bgDuZjqh24AE0DtJWzIXdOtN8P6wubydpocqyhWQ?=
 =?us-ascii?Q?gjPYkqTXKgXoJrac248mWTyfLefuuHHs0zMsOJfFphMU9NTgt92Kd1+7Uktl?=
 =?us-ascii?Q?y4CrVR/53M7PfIKAo9scqQOZTqT/AULYOGMIDxnIwJyNJ/CX2EQeQoTvse7c?=
 =?us-ascii?Q?U3exzEqn0mn6tVvFfxLzoJXVuae5nG10h2EMi8gaE9l8DWcjcQJkwlHfMasr?=
 =?us-ascii?Q?JCCpnyUr881xcijJ+nkFyw2r0xxS2qgbddXTG2g1UZNIW2XuS7c0dCrazbk2?=
 =?us-ascii?Q?OVH26CVKoFoOIcqtoqrJ6DW7QRJiiOYYaCM9BdXyTHeXfbi2QdhIFte6Qm4x?=
 =?us-ascii?Q?4nGRsk6SClx3AKU2GQg9m4/SI+Vhbvn3bnAFUZRLVPM1v0jUPbc40l6IXSLu?=
 =?us-ascii?Q?EBedvVkf58Uu9cxziNz/60P5pL94c23gMJxNOJWG44qD64M2mw8x7kcQlqbc?=
 =?us-ascii?Q?ncUfcudsHY13i5Itg+4y93bipaRj5tEB00Dg8yjoWOpUIw/9pzIVyiWcMGDS?=
 =?us-ascii?Q?KUodiUW/ArFqkvZ8IxsK7r6W3LEIF7ua23hNTZfjXqhPbnwsKo/T7EHTQSP3?=
 =?us-ascii?Q?ONK6RoWeEn8PDCpjOzPnkriQYI0ZcPMJUCpUfT7ZSg9lPGfDM2yVndGkYhzU?=
 =?us-ascii?Q?H0Wj4PwKk6HvJdgKpA88w0TMxomvEU1kUPVI3QJlg/VjBnmgvGjbHb0lbmUt?=
 =?us-ascii?Q?BykruK6eBq7GDd4OQdddZ+wnF9mCbF/PuYR9GJmWrhVuM16LxNcDlmS4swkE?=
 =?us-ascii?Q?RbUk/fO1ZurS4CirQmOmQxWf/mJfaFA7M2x4QLbOODcN0MmwuX/9WgzJoIfk?=
 =?us-ascii?Q?+h1bjJ/APjUdRPyu3+NphbPUIwubw8YNgHKw/VpRLeGnY6IgYGhLdkeIXGCw?=
 =?us-ascii?Q?Ker6u9qary+5h0G+KIVJdZziroyOudmTxWtgypEYEOOm1cpx3qHbsV9KyLrn?=
 =?us-ascii?Q?sH4cCdF3lgivRyKwQwXv/5etOB10yVcGgwcA6uR3fkTK8gq0Q/5uJ0JHME+D?=
 =?us-ascii?Q?GUv/QlRgNRCzp9hS0ZHGMdWg/ooI89i4970Fbn5jqYfMwdm0D+csbIT1NneN?=
 =?us-ascii?Q?R/HpogoL7PExZQjQINfSDl73AxJELLEZrlhRYMHT0n/GVjxNeKsefDS3D2O0?=
 =?us-ascii?Q?CdRztqOWEo3zAG6YNwrk2H8stBjYrdDVdkCKlYfJGMimAYhYyYVDMdwPQF4S?=
 =?us-ascii?Q?RH2m7VsNpUPBpK1Gk7uM8FDIfiiSQhMh5N7g4nu7TcT99AXObzpIWdWV+rEs?=
 =?us-ascii?Q?tyddZqQEfIOjn9GnTeZFOTS008j8/8CVa/OouGskG7k6w78OSDoyoqH0PjLo?=
 =?us-ascii?Q?bCgWj9vPgHlOMT1LSqUzo24NYmarT1IMIngJqMZaybLo68VZr8pA3rEevocp?=
 =?us-ascii?Q?vvbaIXey7/abo3mLlIZoOOZmK8sQAIb/pRzsKxp+fsISn1Rpp2NbxWKmc8n4?=
 =?us-ascii?Q?PJDBS+8Qscc7lVf/Ug+ylFPvmTLByZ7bvTh1QwHssG8CiGfXE43cGXL2730b?=
 =?us-ascii?Q?AeMIhZsLRWvcd6sEeWiAyDa/xjQ1MeNJlC0UX2jRVzltV/3PhGBzGoC41vUO?=
 =?us-ascii?Q?A2hA+IDY1Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 625421a2-ab71-4ad3-e6c0-08df33233a83
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:37:31.0582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i0UAfyD1erhPfrDqADwWk8Uvea5ndrCRB2jsxRkyC3nsIhYEjEoY1K0yVlqBuIZv1S8WHzQMj3O30KvpJ5YTYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7442

From: Jason Gunthorpe <jgg@nvidia.com>

vmwgfx is creating a DMA-buf that cannot be attached by providing
always fail functions for dma_buf_ops.

The attach/detach callbacks are already optional inside DMA-buf, but
dma_buf_export() is checking for non-null map/unmap callbacks.

Instead use the mapping type interface and provide an always fail
match_mapping(). Remove the unused SGT and attach/detach functions, they
can never be called if match_mapping() fails.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_prime.c | 32 +++++----------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c b/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
index 598b90ac7590..90e4342a378d 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
@@ -35,41 +35,19 @@
 #include "vmwgfx_bo.h"
 #include "ttm_object.h"
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 
 /*
- * DMA-BUF attach- and mapping methods. No need to implement
- * these until we have other virtual devices use them.
+ * No need to implement these until we have other virtual devices use them.
  */
-
-static int vmw_prime_map_attach(struct dma_buf *dma_buf,
-				struct dma_buf_attachment *attach)
-{
-	return -ENOSYS;
-}
-
-static void vmw_prime_map_detach(struct dma_buf *dma_buf,
-				 struct dma_buf_attachment *attach)
-{
-}
-
-static struct sg_table *vmw_prime_map_dma_buf(struct dma_buf_attachment *attach,
-					      enum dma_data_direction dir)
-{
-	return ERR_PTR(-ENOSYS);
-}
-
-static void vmw_prime_unmap_dma_buf(struct dma_buf_attachment *attach,
-				    struct sg_table *sgb,
-				    enum dma_data_direction dir)
+static int vmw_prime_match_mapping(struct dma_buf_match_args *args)
 {
+	return -EOPNOTSUPP;
 }
 
 const struct dma_buf_ops vmw_prime_dmabuf_ops =  {
-	.attach = vmw_prime_map_attach,
-	.detach = vmw_prime_map_detach,
-	.map_dma_buf = vmw_prime_map_dma_buf,
-	.unmap_dma_buf = vmw_prime_unmap_dma_buf,
 	.release = NULL,
+	.match_mapping = vmw_prime_match_mapping,
 };
 
 int vmw_prime_fd_to_handle(struct drm_device *dev,
-- 
2.54.0

