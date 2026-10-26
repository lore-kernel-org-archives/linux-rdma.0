Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993090;
	b=pjJGYxp+Nh2aj9Rk+PqNituXqdThkvcAfM2wucTAS/5JBBLES1XWRQBZb6FFb97fDu1d
	 hz3G9dOyh6t6d/a6nH5k61iQ2Vtydsqz5RTm4OAKUuTf0R31lOjbR3KmYzlL+sL8A4hUU
	 q6saf60pJUs76YeD5LgZeAMc/kgExZaUq+02OX8uSJqVkVdu2j8RFkhnkwFRR5Clf/rId
	 OinkHc0ItIHytywDRUDDWUcUWxmBausVW4K8ubfWoL9T6YGIWNeyEhcAZnoW8DONGshu7
	 WzHL3hxWjF3KSfh2fIsiv+JekKL6Pqba5N8Lw93X3+X6e1J0Xtjgx1UuBFR7HbKvK2Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993090;
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
	bh=DEFTmH25jZl0Udq4wEX3Jf6BphgnZKvgZXZZ2HXqpTs=;
	b=DZfxYn6G2Xi2dVd60EOrKzSR5hOivHsrg0zPhkVRY5taf/2lR3qtC2BgT6aUfPi6YcCO
	 cVxkqWuPpV6XAd2EihOWO5twUqa0zb67IyND28sMq8D8Fn7kaqyiUcl1cnVD948nLlIoc
	 1ump8cNo7Y1Hknqx+Dn/6Et773g/Qa6iWJfBdHj8IlVXx38qm+Kntp3xj85K34k03Ccvk
	 TmMhTnmwLNniD2ltpuma3GSEzZpmuQGkOZHhS2+GC0qDc3M9/GBBXxiVJFtTwbeO3gfu6
	 Ip/jWrpFw7rYuRwIJZaoAQ38h7jH+0no8Bo3dFEzW0/dNF/V8Urm/En5u6yARetKF2Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GFoJ2Edg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.41
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012041.outbound.protection.outlook.com [52.101.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADE4606A32A;
	Mon, 26 Oct 2026 05:38:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DADE4606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GFoJ2Edg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o23cTaSdvA5iGl3mXfYBIbxdJy+rH2CL7l4iDYdyadtCuUT5Hihl+t0PzFNfCJJ9Er4vTvDq87uTgZxjm5FUQ4CBJ3+VP+JbBVDgfcMzYPLnSWQbhxcRAJBhFwxs2SmKvwN+ejlHR04NZv5w0eVzwVGOP3tN6TcdrIS0eNTfk1nvcOTA2D6+4G9vMqmUthg5UST62uUbn76oSjvKuQoU92VxUdh61R4BX1tKQTOdDP1kk0ybxGB9qjntsniFQIQoMHkj0+RLjr4bo97sqU0f/Lu0pDo8ZyeAj24qCvpBEX58NHLyfgl3uVtgsVHid2RaVIeRfERmzKocC0of8m1Klw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DEFTmH25jZl0Udq4wEX3Jf6BphgnZKvgZXZZ2HXqpTs=;
 b=Pqm+GGJPN64hMztmA5WaO5mmV8e1dbAiDPDN3kp0FO2IKcJXnKg/y+ytCk1xXVyaqPughzM/r+zlQFKxxMhVK3Z0pPUOUhJeuFHAn+M8Sy3KenneH0a72DZBxVHr7xczdVdADWdgFzhr+y2lEfqOHsvmmbNJ5WDlG/wljI0jjKCMmSBpFGUVv7F0gZjUUkZ91LWglZKsNC9UxmZuqkxgXGOh2Zu25uG5efd71rspFwhE7jICU9et3edEXUiii1709WD1FDDguB3POVOXZTimyxFdhGkx/VgET4tLdfhVdOFkcLbATV+/gT2JLBSyiy95+UmVNgMJBJdZC9nh6b26Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEFTmH25jZl0Udq4wEX3Jf6BphgnZKvgZXZZ2HXqpTs=;
 b=GFoJ2EdgCWJknjDZ0OUxceNPrjlWHK1FrNiBWmbRGKeovBoWkz7lheYLvnkNB0VDV7+6hNoi1loz1QRQnmPrTHsS9CtUKDNJySa1b2Web18N4WNkVQCgShq6rrVi7EsvzVPvT944IUalkJo7aXUWedmlev3LeYoXPWRiL8N1W6bsBVmhOa7L+R1G6cEzUqHbn4xtlUFIcZ9brnimWwMTKT53sF2FTgrFMQDXy18v0z0jQyUUK/mETT5jOarG8oPRHpvXc58/7oSPA8qjOjrUUQuSPgmOnYPv56IAGboAQ6HR74a3nuya98z8nWkDPgJgsg4AcBlNI8yQ9BM/gtZ/iw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SA1PR12MB7442.namprd12.prod.outlook.com
 (2603:10b6:806:2b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:37:41 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:37:41 +0000
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
Subject: [PATCH 13/26] drm/xe/dma-buf: Use the SGT mapping type
Date: Mon, 26 Oct 2026 16:36:04 +1100
Message-ID: <20261026053623.202642-14-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5PR01CA0083.ausprd01.prod.outlook.com
 (2603:10c6:10:1f5::17) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 3add736b-017b-49e5-4b35-08df33234093
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|56012099006|11063799006|261021123027099003|10067099003|261009223027099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	3zZqMXWddjlg3MS1ESOMSujocvDtgczBtiEH7uK6PyfDxiwfTBAyfq0MdiUneTroJTGuMXjZ/iwca7m8zc8x3Xw7X8Gu7MDVl913i/0ephNkt9A7rnYmj0vXdNpKcePeWTPc5FagHu0p18LHZm3bCVp8Q91eqRkn+3G8IjnoaXnnjUiHm0+6a3gYrr3AOcH0b7X7RUgUqH3xOMCEgh/9TKTmVlPim8x7BKmbljTt/++AtfjI3/euJaVdw49k9jr5vvdglegszK1jUnD6DEBwceRsZlB14R/YizTeLMZGtdeOBVc/CPKsujoOkfsOpAzGOz1Fs0coPoq50/RWlMhEeEGBrn6RL0SlMzFBsLu0i3doO/ctHzC9Y1bt8C/oFbwgXeaZn+3NZMpnGoaefV27yg2mbOwhUmlwyB7b7Wt03LSVtwaaP9H/9e5jTlytyxs2xvsHlSYfjZnvW+5UTXHxAfH3eu3SDauszMSSo1/GIDM4jqELgoTsA1ul8AFx3V9G/3vCBO7uHiHnHlwaB9UEv7jW98E4M2QCTzbXdeb2QiBhSUH1a3jPRzO+K+p1GdA48fGBqxq3c2f5u2vNO8MktCQvYA+erwFRVkoBIJBSCa8td4kmu8fTTFrh8v7n814+MrTrRil/9XopppSQ6izPOQ40CuTx2+LWsGcpqaomxak=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(11063799006)(261021123027099003)(10067099003)(261009223027099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V1fUeh8DJml2oLE6dpTGQdf99NQsVxPjhiFMgZmBhV4qLZXLQEPcSwjXgFLA?=
 =?us-ascii?Q?E0Tt/JjW2np16jM6vYIVes2jMPbXGmvPy2pEoY1ENjJDYl8yHs/n88HpGpwm?=
 =?us-ascii?Q?sE6rwunip9+wx8RsDjnVcbLa6yD+EK2Szk1QqMvHXHeI5vwis3g1njJ6r9/l?=
 =?us-ascii?Q?PH1WIWXeF33InkCwMNHhJ46q2Tou60l/0xV1uQ98aXyN0llnWHFdpuXnolF2?=
 =?us-ascii?Q?Sjj1yNgZJq8hlsdsYLtWHk3JTx29lcilbkhGoI9v173slY4R2N2SHLTJJFI2?=
 =?us-ascii?Q?i391oaCELkRl/7fjvayySSbKvFJjct2A8BZJag1lURa35CRwePOzZze0T0pj?=
 =?us-ascii?Q?vxAYmQ+KS6byqWL0GFArXKodw/fsPUwyyiWJvRhAUcpw8VVsFnP1w/d9SqfD?=
 =?us-ascii?Q?biapEgiWuYsmkVMTmPi+7fHVq0dAVZhRdv7ErVIAB6ccq4WXY46C6Ulq4rBy?=
 =?us-ascii?Q?wSxVcHBPvUj+O/G+FkHPqeDbHgWxU6cd1N5sva4OcwAp+De/6LozeK1K1KcI?=
 =?us-ascii?Q?5gZsK/Uh/Vxxhl8gUjbl3F6n4TjmGXTx3Yc+Tl0HjmC7mfPsDnUOwlHA36f8?=
 =?us-ascii?Q?alHoIRFG8rGJoj5eWdLAtie+BjNZr1YL0eQ2keYMClQJ7pl7q7KW+3MMWa3L?=
 =?us-ascii?Q?7GDiddBXCzjHN0iIiXsuANL5hwWDgH9TBxE1MJujZsRlL++G27XvNl+USmLq?=
 =?us-ascii?Q?QWgW0QImX+g5loafF9fDu3VB6lbZMjMW2fk/piJWHe5VS7vbFM5KOmDSPoFI?=
 =?us-ascii?Q?rj6oAZrclzU1BAHP8YGTNpkymDJPTw1ELB1WyqttyNlFFG2n5yAUUkTjLM1v?=
 =?us-ascii?Q?PUVB6XaNVI3jwfTRh+Nnn5zr5Uiv+3odXdWF22ishgG6lSCArR0FX3ee+Ifz?=
 =?us-ascii?Q?tPXeIMUUJvAjsLmWFCiyrzIT0c3eDyg/LJ/Gl3woy9+Ri/cFGVMm/ydQoN5D?=
 =?us-ascii?Q?4SRgKrqGSTiSucrjuuFyvZ5xyCVXZTpDIXJpevhUYCsmSgzKSp4mFBq5XjFe?=
 =?us-ascii?Q?zv2qX+DBOeGXMq5+Zm/2/gkL5HafYdZRWTftQ771sFtPDcVhCG6Z0aLhhUxI?=
 =?us-ascii?Q?ILUiHwfatV2S5Zgudyy4fxu4/FqEtj8C0kOI6I8Z8W9hjhjlKFUE31amkhAs?=
 =?us-ascii?Q?ALYNbfXauwhNT4I7/P91Aw8QLVquTpajzv1oUHkv01SqtX2AxyizZy9Szr2x?=
 =?us-ascii?Q?j+fewTJVyjFanUbLHKI2KjfPbX+w+rOYZIN8GqK+XhU19ssY+9OYZcdo2VOj?=
 =?us-ascii?Q?jEVhvhkXAad4s1C2jKw+R8REKS1v21uIp6X6g4/BoTjYCXodYWr9QfHo+PHX?=
 =?us-ascii?Q?tWFTRke/kR3qpRyhaINjG+fJHPZg3vu6vJAWL7r2A3/alKBYXQCBwN+44we6?=
 =?us-ascii?Q?MUqC6AFlnQ4eSpn1Re9/LOX6j/itKY8uBVfU046wEgG3MwAJ7TndFL9UeUGl?=
 =?us-ascii?Q?KUvtTP8z3Tzq6SX8tXmtJ6deCVscgQp0ADhOYDOIAATbKvFf04m2Nvw8s4De?=
 =?us-ascii?Q?gVtQY9VENsp5Ct5exx5SzZBr76u8F1jsOJ83vzaTme3U6q0QOLtKip1r19l/?=
 =?us-ascii?Q?oHuVVxaRry5a263zbFL+PfO70g+92dxs8em5WQLmk8S832nFdmanFU+SCBfA?=
 =?us-ascii?Q?tjzAgAaI+ZK6/qUf/ogsJB3R4XkQl6NZWvjzdhHqXIiMk68O/MlWkcJwoe3v?=
 =?us-ascii?Q?qZNn2H8NMtPH1OReocbTdju6W450gNeYBJyhZB6DOyt0lNooZ8mqz7Dnm/oR?=
 =?us-ascii?Q?v9fIESrwjQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3add736b-017b-49e5-4b35-08df33234093
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:37:41.2396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lTFU+vCwCvlvW9IRrr/DPv4F7w0MPl7cqkn254CH69gA4YCD+k4V+wl5+xhgLbgJRRfvEXfd8mBGeuJzR0nKUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7442

From: Jason Gunthorpe <jgg@nvidia.com>

Like habana, xe wants to check pci_p2pdma_distance(), but unlike
habana, it can migrate to system memory and support non-p2p DMAs as well.

Add two exporter SGT mapping types, one that matches P2P and one that
matches all of the non-p2p. The pin and map code will force migrate if
the non-p2p one is matched.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ rebased onto v7.3-rc5: CONFIG_DMABUF_MOVE_NOTIFY no longer
  exists (609fc8766d68 "dma-buf: Always build with DMABUF_MOVE_NOTIFY"), so
  the IS_ENABLED() guards are dropped, the P2P match is always offered and
  xe_dma_buf_pin() only walks the attachments. dma_buf_match_mapping() is
  passed num_match rather than ARRAY_SIZE(sgt_match) so an unfilled entry
  is never read. Upstream's xe_dma_buf_release() is kept. The pin walk asks
  the other attachments what they accept with
  dma_buf_attach_accepts_sgt_p2p(), since those may not have selected a
  type yet; the attachment being pinned has just been selected and uses
  dma_buf_sgt_p2p_allowed(). - apopple ]
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/gpu/drm/xe/xe_dma_buf.c | 62 ++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_dma_buf.c b/drivers/gpu/drm/xe/xe_dma_buf.c
index bf0728838ead..3ca198da6ee8 100644
--- a/drivers/gpu/drm/xe/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/xe_dma_buf.c
@@ -7,7 +7,7 @@
 
 #include <kunit/test.h>
 #include <linux/dma-buf.h>
-#include <linux/pci-p2pdma.h>
+#include <linux/dma-buf-mapping.h>
 
 #include <drm/drm_device.h>
 #include <drm/drm_prime.h>
@@ -27,13 +27,6 @@ static int xe_dma_buf_attach(struct dma_buf *dmabuf,
 {
 	struct drm_gem_object *obj = attach->dmabuf->priv;
 
-	if (attach->peer2peer &&
-	    pci_p2pdma_distance(to_pci_dev(obj->dev->dev), attach->dev, false) < 0)
-		attach->peer2peer = false;
-
-	if (!attach->peer2peer && !xe_bo_can_migrate(gem_to_xe_bo(obj), XE_PL_TT))
-		return -EOPNOTSUPP;
-
 	xe_pm_runtime_get(to_xe_device(obj->dev));
 	return 0;
 }
@@ -53,13 +46,16 @@ static int xe_dma_buf_pin(struct dma_buf_attachment *attach)
 	struct xe_bo *bo = gem_to_xe_bo(obj);
 	struct xe_device *xe = xe_bo_device(bo);
 	struct drm_exec *exec = XE_VALIDATION_UNSUPPORTED;
-	bool allow_vram = true;
+	bool allow_vram = dma_buf_sgt_p2p_allowed(attach);
 	int ret;
 
-	list_for_each_entry(attach, &dmabuf->attachments, node) {
-		if (!attach->peer2peer) {
-			allow_vram = false;
-			break;
+	if (allow_vram) {
+		/* Other attachments may be unmapped: ask what they accept */
+		list_for_each_entry(attach, &dmabuf->attachments, node) {
+			if (!dma_buf_attach_accepts_sgt_p2p(attach)) {
+				allow_vram = false;
+				break;
+			}
 		}
 	}
 
@@ -97,6 +93,8 @@ static void xe_dma_buf_unpin(struct dma_buf_attachment *attach)
 static struct sg_table *xe_dma_buf_map(struct dma_buf_attachment *attach,
 				       enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
+	bool peer2peer = dma_buf_sgt_p2p_allowed(attach);
 	struct dma_buf *dma_buf = attach->dmabuf;
 	struct drm_gem_object *obj = dma_buf->priv;
 	struct xe_bo *bo = gem_to_xe_bo(obj);
@@ -104,11 +102,11 @@ static struct sg_table *xe_dma_buf_map(struct dma_buf_attachment *attach,
 	struct sg_table *sgt;
 	int r = 0;
 
-	if (!attach->peer2peer && !xe_bo_can_migrate(bo, XE_PL_TT))
+	if (!peer2peer && !xe_bo_can_migrate(bo, XE_PL_TT))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	if (!xe_bo_is_pinned(bo)) {
-		if (!attach->peer2peer)
+		if (!peer2peer)
 			r = xe_bo_migrate(bo, XE_PL_TT, NULL, exec);
 		else
 			r = xe_bo_validate(bo, NULL, false, exec);
@@ -124,7 +122,7 @@ static struct sg_table *xe_dma_buf_map(struct dma_buf_attachment *attach,
 		if (IS_ERR(sgt))
 			return sgt;
 
-		if (dma_map_sgtable(attach->dev, sgt, dir,
+		if (dma_map_sgtable(dma_dev, sgt, dir,
 				    DMA_ATTR_SKIP_CPU_SYNC))
 			goto error_free;
 		break;
@@ -133,7 +131,7 @@ static struct sg_table *xe_dma_buf_map(struct dma_buf_attachment *attach,
 	case XE_PL_VRAM1:
 		r = xe_ttm_vram_mgr_alloc_sgt(xe_bo_device(bo),
 					      bo->ttm.resource, 0,
-					      bo->ttm.base.size, attach->dev,
+					      bo->ttm.base.size, dma_dev,
 					      dir, &sgt);
 		if (r)
 			return ERR_PTR(r);
@@ -154,12 +152,14 @@ static void xe_dma_buf_unmap(struct dma_buf_attachment *attach,
 			     struct sg_table *sgt,
 			     enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
+
 	if (sg_page(sgt->sgl)) {
-		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
+		dma_unmap_sgtable(dma_dev, sgt, dir, 0);
 		sg_free_table(sgt);
 		kfree(sgt);
 	} else {
-		xe_ttm_vram_mgr_free_sgt(attach->dev, dir, sgt);
+		xe_ttm_vram_mgr_free_sgt(dma_dev, dir, sgt);
 	}
 }
 
@@ -205,18 +205,38 @@ static void xe_dma_buf_release(struct dma_buf *dmabuf)
 	drm_gem_dmabuf_release(dmabuf);
 }
 
+static const struct dma_buf_mapping_sgt_exp_ops xe_dma_buf_sgt_ops = {
+	.map_dma_buf = xe_dma_buf_map,
+	.unmap_dma_buf = xe_dma_buf_unmap,
+};
+
+static int xe_dma_buf_match_mapping(struct dma_buf_match_args *args)
+{
+	struct drm_gem_object *obj = args->dmabuf->priv;
+	struct dma_buf_mapping_match sgt_match[2];
+	unsigned int num_match = 0;
+
+	sgt_match[num_match++] = DMA_BUF_EMAPPING_SGT_P2P(
+		&xe_dma_buf_sgt_ops, to_pci_dev(obj->dev->dev));
+
+	if (xe_bo_can_migrate(gem_to_xe_bo(obj), XE_PL_TT))
+		sgt_match[num_match++] =
+			DMA_BUF_EMAPPING_SGT(&xe_dma_buf_sgt_ops);
+
+	return dma_buf_match_mapping(args, sgt_match, num_match);
+}
+
 static const struct dma_buf_ops xe_dmabuf_ops = {
 	.attach = xe_dma_buf_attach,
 	.detach = xe_dma_buf_detach,
 	.pin = xe_dma_buf_pin,
 	.unpin = xe_dma_buf_unpin,
-	.map_dma_buf = xe_dma_buf_map,
-	.unmap_dma_buf = xe_dma_buf_unmap,
 	.release = xe_dma_buf_release,
 	.begin_cpu_access = xe_dma_buf_begin_cpu_access,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
+	.match_mapping = xe_dma_buf_match_mapping,
 };
 
 struct dma_buf *xe_gem_prime_export(struct drm_gem_object *obj, int flags)
-- 
2.54.0

