Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.62
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993050;
	b=4ViTPPCEZscd2PsQabtEII2vpHz8e90rZrFaMvFZoHpoe3LenjtzsWOaIK70se4rWJr6
	 S7raXWG84wCfyNOn0KaWsJDjxJr/JpNApPJ3lwSsXAWxsKBlTwOJqzAcF2bcDxbJu6jg/
	 DgaNLwjPr1kFfa7/QeltN9viJ0PmEyhfNW+gG9j4pUJHnNhDefeI/nMv9JLdRVHXJZy2q
	 2CJ6wa0P0svNmuJhVQZvKBx7FzSYINt8Xp9zj9zlJbQ7/LVuaXdMqEzT+XiPYgEQ/vIbs
	 j3L/PUQHjYK7WIZrL0HHf5PqNmSYd2bWxfOFC4WbxAAuhmQ8Tk/c0c+0W20UcSeTdjA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993050;
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
	bh=ROp0qCyc0GHJQuLKwneDdupndz3lVlYF9NkWAmLh0/M=;
	b=Le8KRAVmmLDNDYDi6wMQVTH8gh9SVLlZaHBfDmyrjL/OSK9jGzrdgLzxoFlKUXeb0gIJ
	 +YAsgUtODjI/Uh2DvwiiKRRcDsVSHxvO6RXg59GWd5esMbtlS2Im4EHnCPcMLW/CjkA3+
	 0Ekd138sbR9x7rrfUFNnf9VVa1u5kDM2eX1yOsflispoiLesUDyTsDUkzZ2rTKOBpFj2X
	 a2u4OTK7xOtCm9Ofef5noG4f5jBJ7IAJb+J3sJgJaDjq1lfrnCwe3tvVbkgBknbj/mGIn
	 EkPg4pu+RKLcY004VoG2Q7BNCK8Yl2OJ7Wa9mL14mglsjgqKqXwfbnjbeGJNVX8okvA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="NlG/TLxf";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.62
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011062.outbound.protection.outlook.com [52.101.62.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A811460A2635;
	Mon, 26 Oct 2026 05:37:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A811460A2635
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NlG/TLxf
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b+72eaG6nNyskZtPIiHdX8hZ6x3ZDJFHsH+7xk9LieBRjhGKwFlhQ8dTt4ulob7sseGQCAAibsmAVHbjDcjlU0ThFZlzY18e1zJysUWvnlJLdU0wuA6B5hSU+ApmaANsutNxSnCPZKykv9cXENbHOVjO/55sctJ9L25lAmqB9rCsJNH25nsQ9hSwtzhad99vFpVWqchffr9Y7vu7FEnRINXoepr5LtATP8xDh5sSSeh4B/v68NbtZy5e80XRIGef0v1fuPuyqQ1smaNWUooZsmT7WBCCOqI171CYWPWlsCazlCKsIxi/dX9aV/mwF2BnXbL/och6ZudccbthSKdrUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ROp0qCyc0GHJQuLKwneDdupndz3lVlYF9NkWAmLh0/M=;
 b=qxiyPBydxm+8Efh2Z38yzYn/PJ4CS5a/U77WCvkL2cfRzCjFaK+tXTNH7jr99ARl2A9Adkrrfrh2GsNGW1PORzIFbKqRR2asIb4cyDDnMY4UyxYU7eYMy5Mcvrobpp5aud6kr9t404nfmNCcGno8h3o6ZlEs+Qx6UfWVtbMrA/YpM/f5rBXFLOc43ThAd1bVe/1JcPPhKFEn7p/yl1PmkTPzrIT6zt4qpKONl5akRHZ2L8rfqxPDKtJhRi+7cVujLJhA9bt09LBqWt/ZzjAmrsLUrQJDVjK3aaDat9TJ2B9w/VGubGo+l+G8u2kPN8FlOIZmWkpjw3kmD4FVffAIGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROp0qCyc0GHJQuLKwneDdupndz3lVlYF9NkWAmLh0/M=;
 b=NlG/TLxfN9KnEU1Huv42Kx8tsLqTY4Mgn8HlfNzU6bTkNCA20g62zeZqle6wAqzugBP8DQSGyTskkvS2jzdI4esO9P4tE++JI20+NPdJuCqedIevYXyLbm+5M+W6bau4YjzpBH1d+6N0QdE3PYbgVEOkmfMwFe6/2oEQHWc+iHI/kLpKIAE0z7DL4kY6jVj+f4+MqNTGweCWV+++wBqC9tkgUgE+E0Wze8b/o0HGsKSh/p2GmLRg5oNIo1sJX5CambmGR5ZKweUxzr2qRBVqSonJud8Jfo57MLAoZwE7Plc+rpZFObiQ+SvdO0bymX1LSFE5N0Hp7C4zSs8swv3s4w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SA1PR12MB7442.namprd12.prod.outlook.com
 (2603:10b6:806:2b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:37:21 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:37:21 +0000
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
Subject: [PATCH 09/26] drm: Check the SGT ops for drm_gem_map_dma_buf()
Date: Mon, 26 Oct 2026 16:36:00 +1100
Message-ID: <20261026053623.202642-10-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5PR01CA0129.ausprd01.prod.outlook.com
 (2603:10c6:10:246::29) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: d930bdfb-f4d6-4cd4-b96b-08df332334b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|56012099006|11063799006|261022075727099003|261021123027099003|10067099003|261009221227099003|261009223027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	TckiIvazT9Bbb22S0fQRHlzlp3WRnmyPWq9+8+TQBoHTcUNcM6nkA4oPDxO0JtooKhaDPg3DYMI1dQvH6RyTLwGEXnDnGx6F7+hjJGOYpBZlYA15+40uDsjLSdnLIHERYp6g0+dRT9V8Y4DavTrDOvl4m74CYXOyQhuToKQnHIuoZjB2S4Yiw34XZlnHQS95s/zj6xxHoaIinFwD0xgvknZyEqYAkeKZWwU6uMIlQYPinSjsP7vtPz3JPz3vjZMITZml+0RUwF5o+N9K0rwtW+lohljxU+77iC78s6rk5lSNJMCxTCJtYR3K7Pv5ja3EZXtYvx7q2GKYun0YaGVC+UrZuDjtY+csx1SZ6/Wbe7cG8bzU4g2pHSO8AmKHHnVWetTd54YvkPWnc0Qu0mwmb/m2bp5e2sDke4lN39gPnanWoCiuii4aAxlJ1WVwCdWqB7VmDwhtJk5GWVaMbGhWqeBv1UZIArV0PgBYBqQFtkwPqFOYtFSi/0osPN70Vyai/Olgn2jrn+AfOqUcbMax4KJpj9i4GhpEKnC/y6gM8ToZiKqhbAPwg+JYGgVMzSHu/4Ecg6DQZAggX11b+jlYxqyDf+hleSDxs8TXcnCidp0zjp7pDcmGf0krd1YgTZSab3VC5Y4co8YIAOZaPM4nKOPDfrPl4/MUihAeLQveMZ8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(11063799006)(261022075727099003)(261021123027099003)(10067099003)(261009221227099003)(261009223027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NRKJZeC1cgmWZUm4Jg08vohhBO0p8WTndx/nmLsL+vjEWDpytRqGIxSEVECH?=
 =?us-ascii?Q?c3NUT/B1L3Ia3bz4qI7x9jwUCXFRyaIx1H4KPJw6y6/+VKKm2qQvgN+hZGXe?=
 =?us-ascii?Q?iY90gnr1iBvB7sw6sguUtGtrNZ06qBv4TAiR4Eorcl5rURhJxi7ZpWpV+TXl?=
 =?us-ascii?Q?7j8SRADYE+mgwjNLCPUu5RK2hUxKMgVTK0gUld84ed7FvwVYJllHzIECUDcH?=
 =?us-ascii?Q?70hMsEmCftR1wo1+VyaE7GGASrG7NdHtH+jn6KRXyF2qwp1ITSY1BmR1zClr?=
 =?us-ascii?Q?PkoTxuJR1e+e4GgxtVqfwRYx0ZkqIUx2BEdDlY9GrinO9zq+9/HuyVkgdKuL?=
 =?us-ascii?Q?99h0isHItRQYs0px/2rZO5zhntQzYr8OFAjciQY0cL5/w/YsZBezQvPGSYxQ?=
 =?us-ascii?Q?UnGLdJLkrsiS60dKnCNn2VKAFXcWUjXPrE5EXWxSbzpDTEOFe6npTWPg3Tpj?=
 =?us-ascii?Q?3t9niWN3ZtojltrzSBGEJTZ4OIKlRaoVPPvdECeSeuOf1bLCHeDXy+nYeLTF?=
 =?us-ascii?Q?ACTOE9ohtyTLmOomzbI7hOcwMugXJuhjDvMIFE57ewOeXfBj26sv3TQykLib?=
 =?us-ascii?Q?zzeLbCw14kmVcSIdzOuGRiFHRk+X+5NOnfSm72NMTakRe7wWGS/584OzZ+c9?=
 =?us-ascii?Q?rHFZXdQIuhm4FiMtW0k9jA+oVI5QUkF0LEvIFgNWjskOpmkaimsbYjpGRxTG?=
 =?us-ascii?Q?CamejC1lNbTmOLF0ErIK76JatoFCa5E5Ggdc4Z5vb49rRnLBWCRX0BkesQ2f?=
 =?us-ascii?Q?T7LEWbDjiz8dZZGAsqa1l+vKARgGj7Wvxzs8FeYoUb4v4jVTfp4afz3SodDr?=
 =?us-ascii?Q?+hPM7lXQoiS/0A23xNaX6Ye0QXpiHzAk+y3mby1/jDHp4uuuk6BSy4uwa6cF?=
 =?us-ascii?Q?VUZ8Lu+7MUTEAIGiIi/IebFLMvRsIxeKZmpMYhaSLIC5lHiwlDI+K2HNSOqV?=
 =?us-ascii?Q?HSiH2fcS09XOSDlDOAZdG3bKMZEUhiBUbDedrtUpquCd22Gny+n0FSX/hLNa?=
 =?us-ascii?Q?HBMRDaAPAnjhSPrCnNHo1gG4PBpuhiazqPbCjLeIPEMf6Vx0BDHvzA98HniP?=
 =?us-ascii?Q?HoLNxd5TB64uvYIeyqxlX8lWpxhQXE3A/stz9edG/09zKOWyYSck/skpzEjq?=
 =?us-ascii?Q?S0vHIVNoofK17d1XzDHGvww8b3Ug1pXVrVHByX18P6lgKJmpBDO9RS04N2PF?=
 =?us-ascii?Q?JTXuWobLh8d5ybGiCub6tZIQ7UTyOtkArhkvqJ4HDrTNCtEEkQHNoQXWiKIo?=
 =?us-ascii?Q?fmEvdMRMd/d6JJ70pQC3yxViD9xfkPYStaXv22CQQ5hzhEb8axzN2CBkULox?=
 =?us-ascii?Q?4QLJW0bJQaqaWfH1xnv7DHB5zcWof8YosdQGVbu/hYPlr/Xls9ZAk2c8oV3o?=
 =?us-ascii?Q?g7oOxjrlxc6sDTGXYOaGVbbxrOElDxU91nWpecZPSTNTW4nyEo2GgU9CEb3Q?=
 =?us-ascii?Q?SyeUFLuBRpA2N2QcXEw6HIgV8T4trBHMzNmlEO8QLV/YCP0bJg7IYmZwBlVL?=
 =?us-ascii?Q?lj97UYvkshycjxN7kQpwWI1lAn+TUR7W2w3Pm4VRKRL9jSzcDh0bpvLQS/lo?=
 =?us-ascii?Q?Bk+5NBVOcL9GeLAD8TsQSafSydp40pu9uZ/TLSjOsE3vxs1BG4E/pJa5z1xE?=
 =?us-ascii?Q?Lg7/KnW+Jsn4XlvS+qwjZV0nzKAHe2jKLspvvrAMGJFXa/JuLIDopMxOts/1?=
 =?us-ascii?Q?iqANqsIhzv9LPao2coTdjDAOtzloPUEc42czG5fgQoCA8DTK+dcdHxM40GoV?=
 =?us-ascii?Q?oFezwSamDQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d930bdfb-f4d6-4cd4-b96b-08df332334b1
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:37:21.1350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3oIgskTk+/DGmvHlVma6gVRpg2X7dt+NEtvt9SaW7Ia+Ytk3yQ13sMTjdqkDumV+mcnz0yB0w7vd4BFyquR4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7442

From: Jason Gunthorpe <jgg@nvidia.com>

When the next patch converts exporters to use SGT natively, the
dma_buf->ops->map_dma_buf will become NULL. Additionally check
sgt_exp_ops to see the new location.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/gpu/drm/drm_prime.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index fe3436d1235d..cf53b8cab4da 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -28,6 +28,7 @@
 
 #include <linux/export.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/rbtree.h>
 #include <linux/module.h>
 
@@ -587,6 +588,18 @@ int drm_prime_handle_to_fd_ioctl(struct drm_device *dev, void *data,
  * option for sharing lots of buffers for rendering.
  */
 
+static bool is_gem_map_dma_buf(struct dma_buf_attachment *attach)
+{
+	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops =
+		dma_buf_get_sgt_ops(attach);
+
+	if (attach->dmabuf->ops->map_dma_buf == drm_gem_map_dma_buf)
+		return true;
+	if (sgt_exp_ops && sgt_exp_ops->map_dma_buf == drm_gem_map_dma_buf)
+		return true;
+	return false;
+}
+
 /**
  * drm_gem_map_attach - dma_buf attach implementation for GEM
  * @dma_buf: buffer to attach device to
@@ -608,7 +621,7 @@ int drm_gem_map_attach(struct dma_buf *dma_buf,
 	 * drm_gem_map_dma_buf() requires obj->get_sg_table(), but drivers
 	 * that implement their own ->map_dma_buf() do not.
 	 */
-	if (dma_buf->ops->map_dma_buf == drm_gem_map_dma_buf &&
+	if (is_gem_map_dma_buf(attach) &&
 	    !obj->funcs->get_sg_table)
 		return -ENOSYS;
 
-- 
2.54.0

