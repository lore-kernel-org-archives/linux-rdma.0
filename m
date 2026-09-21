Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012033.outbound.protection.outlook.com [40.107.209.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6095237A0;
	Mon, 21 Sep 2026 22:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030175; cv=fail; b=fQR6iNdZSHtJO+ZaHZUxv9w293EFMUZJX9dFqLu/ya5UFjTuSX4Ma5o+tD17PLp7ZU/htLuQG4/FHUS36Ao620/jD/L/SS+glpxlpiZLj/mx/IP2156uvftRyWP60X3xinCd7Q5KZF/GoQiSPdkvQFMoBLPDPhB3SndOOnYYG+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030175; c=relaxed/simple;
	bh=VfsO4hcdLx7ZK2t4VSlVcUHQVuzYaoZv92tXND63qzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j4UslJFzbWBPQQ3in9FYU5GknSvvEExK0NFMmCVpTM5E8Eyhu1zEiv9NobsZGKZA0De7bInFYo5lAEM7dyEwWdgXWCoT63FXbET8nepeSteOk0fUnSb5nbPA9Hf+rNSXG+hQse/4u9onfKHQOtZP2q4wdZe2dLMZa6KQtqjWFFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OyOQ476z; arc=fail smtp.client-ip=40.107.209.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OyOQ476z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TMBztD9k7IAeV4na/rjydm/0WgA2OANPV/nsYmp1zNlirZtEEUsK12YNlbvMDiq+ZSbQOfdcel+lZSfid6xyPsj7XKbyhiuqaScxpOuENc7uKuYjVgT41NXEE0gKRfp5uQ6oFj4/epJAfTBtUTfrTfFQsp/RJdBvkj/ZXnFuAQ3rR4FGTAhEjp2kiOAhOX0tvyYHh46ZHgFcyZlk/ur57bFOsaxfsOJiq2tD/Kybao0kGvMgDF9kScQ+TIpaPVkLElOn79MywZ164tzuNGNH8Rs61PgUdo3a5GD9X+VNew0H8oMpxv8a9dIIyf3hP3YQYX4ksLydZUvVyVgV0YL/MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0I4ILH2uM4pfxmoBtm2U0QuqZwP1ujxiG/2/wu+rSws=;
 b=J2Gnvy25PkIiA5dzLr94NZgtbQFijW99qzmD8nj8QPisTBckCq2va/Yb14nT0mDLqsTOn/ydIK0qO+l9xDOfUHQDEabrID9gitnEGt9tA7pl4nN1OpJAB6F0wU6tfVhV9IItKTDS1IXS+VpZGHCA94ZnNR1mUYVvxYOpfMnRuckXtUsiEuKfei4sTZASMAbcxVqWOZWKS7e8QFVs9DAoP4OFInwHjRT1uFmDagNbCp19wA458HsNMK8uACJ2t08pAE6y0zWsEEN/gnMtBn9OH+VJ7lyS0HT2UiyLJ+80pcCvHxkx5NeXOzdiAYJZpM62HhWJnDsIlQGSIDSqxGBTgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0I4ILH2uM4pfxmoBtm2U0QuqZwP1ujxiG/2/wu+rSws=;
 b=OyOQ476zR1pQGea+QQYhvPts/6/Za3pA9VMK1EHhVEmF284Ymh8cDm/IkdagdKv98zWQsy04Q8SmhsxpML0Fsfe54k0ZUdpmgDcAYwamIPsVv+tryNAzGNWfykB30HgpwT7oXU2ywnqiNew07oarc+7+JV2xESXkrOnHslx3q6/qGFJMiJkk0ogenjvJiPVbMTMU4XUa8GTnVLxcDi1I+4zH/QgjwSVcHWLuTNB6YtLQAk45Pu9/ayEPan2Ykoa4H93L0QOwpVg28vt1wc6KWWsy4GOuon8sKZSZKafxcxrJz8Sr5zC89sKHoyjNoZ2yezZjuOx0jh3DPBUps9J48g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9144.namprd12.prod.outlook.com
 (2603:10b6:408:19d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 22:35:58 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 22:35:58 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Leon Romanovsky <leon@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org,
	Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sean Christopherson <seanjc@google.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v7 04/10] net/mlx5: Add ONCE and MMIO accessor variants to mlx5_ifc_macros.h
Date: Mon, 21 Sep 2026 19:35:44 -0300
Message-ID: <4-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0131.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::33) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV3PR12MB9144:EE_
X-MS-Office365-Filtering-Correlation-Id: 50420c9f-abd5-4075-d17b-08df1830b225
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|7416014|921020|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	VQ9vjnIVRkpNC+MmA3LBirqAKZsE8ryRImC/1Z25q9zLz9+OMEI6uwDFwuovdgdBU7wlkv7/PNGYqcJ2/rsPN/K0PZO3vni96Pd201er4P/W0YFSZCPXuaWUF1LDou16s929Cgt3GIPornoL7YlWk/sf/speD0QHganFgPAnGeDZlpcF/u4+9HxQYvNGVe/A62Y00ZAMYHXCMCFp5QDxpQvPJplBFvetKdgGB0nMXJcrC15awcsRUUBpxVqUG0aajVHiY4NxvIP1XHsrfV5ghYPtnLb5U9jj++Xk7O1ypqMXPmOQIblAtStQB8hcRds3Nel520qsNpNqmrIQYMwc013NW3DJGP9EPejLXIOvbg/t1LlwadoNTNaPGA690GbajojY23qJo+BwyKY48wR5essYoN9DQKb3uiiI4bz2mXClTDC4rSlNweM47SB7xEEnMaxVpoKgSagsveQ25PeNj3ssQ/HASMCJkDe5yoUOjCWF11SgRCSJ09dHcpxL10k4AUtggc4IMpkrPiXHVCdp2n7frWCoCKTEbQRqBsxKhUuFyug8142P4yk5q/zmckRgAhqohM2ef3LuJTtDm/jg6KLjGp8kbnvtK2slFJZyukyx338oN2yPzAL8p60QtZeZnCPoye/HhbzilyVGIuOUvxgoyAPeYx9SAow6Gk1xNuMRxcfgiLANvq+leSDMvKlr5N2uy6gvHyYOF+XyJV7n2g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(7416014)(921020)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LjE+sSTIqURohpZHelGGbebcv6cvwivpUfXL30nmyg/5wN64X8RSFNZzy5nb?=
 =?us-ascii?Q?vv27GVQ9jnAqxXVNvL3ELC/S6uaQpAkoS1TfmRrmmP4G12UaYBFqwyAEUedS?=
 =?us-ascii?Q?1b4aYOM+t0h/R9yl6GDpZuFBwDthT8URQSWuP5eNuVMIzZA86DjuiAPBG52Y?=
 =?us-ascii?Q?K4QqtgnGjceTftKzuhlEr1PY2xxRD/pc2IQGS2c2/3nt3izbqp/716uNERNo?=
 =?us-ascii?Q?FtpcIIyF75dR/3giTZUayw5U7bWdJdX9hXN9ukzvQYJYAEe0QFQE63uNLGzM?=
 =?us-ascii?Q?VR3TmJvARnHgpwSI/Q8sX3YqyDWH31ah61aWzWlfTR+O93UrmRlQqOv2XxbX?=
 =?us-ascii?Q?kQ6j8AXHa+sxTnrvNbtPc6rRTRDj7TnZgYChqZNt0jFcZelT9k5jK6B1T4TZ?=
 =?us-ascii?Q?JgIHdO73Z1BIMKkr1bVC7nGyK/fsuZ7hkr+9d9MqvqueO0Z4pyDJaFo3+GU1?=
 =?us-ascii?Q?eydC7tlYZ73Xr/t0qlNkjJsG/CMlii0/Me2BAYglfUrIxZbkNHoQDD5nzh7j?=
 =?us-ascii?Q?2E5ov3Ax3GkB17LieKOpXqebDF6Se/Hq08ook8wXz/a1pWE4dSrfS5xMyndd?=
 =?us-ascii?Q?uupR4UgnXdL85XYhNuJd303yqunRDs6MM8hLPja/yxwcfQt0q1ljvzzXFnPa?=
 =?us-ascii?Q?sJDanJti9awmOku8rWEuDAGKf5Oe3kHv7k7S0NZLd9r4cUWsPt8lia7dWyRg?=
 =?us-ascii?Q?ehLQN0GPkYCRX5w/hngJIIA6HUwwhe4eplgDMddKaMknponHbUMB2MOutLAu?=
 =?us-ascii?Q?kGw1t+bXYiZcxxzG5EBWSQXBe5rSUuWk8PFflnu8gDE/vUTnHyZIZuB8TWTq?=
 =?us-ascii?Q?6Na4Lyc663LI7vvxT5ecEyijoDBhv8jL/WtMGcaLJ5p5OX07rguRD3lHySWX?=
 =?us-ascii?Q?NTdEA/1KYIcdlXITogmapFEE8tD80BRgbO76yb7Du6GZDn4qSBjtz9LP2AbI?=
 =?us-ascii?Q?T2HfcZShzxtNCzOdKvXbRUAKyZ07GqgyHXL+6yt1E1wkJqkAREAYJjeQY/kj?=
 =?us-ascii?Q?ziIlWgBYN1dK1FGteAKpKYy9jLTv80Il12LzSC6tnrFQ5QczAM11LsDA4upM?=
 =?us-ascii?Q?CxxY83EvT/1FYYQQ8/3HpiEOjbvCNlSVFeSxK6nLTmNRzFIJqgu75w456Zpf?=
 =?us-ascii?Q?szco5JkzbjjOPp/+nRN2cLq89kM25JrE2UCmbULEPNKB6s5TA8ZimDHBLFmN?=
 =?us-ascii?Q?3AMbmY7iCw8zOHQutrX51+WHEM5IHL9G1EmgEi6vKt9VsrNKXg6xDbV1XE1j?=
 =?us-ascii?Q?dHf829lFHBbc/ViILynNscqCo9rumA5BX5/BAw8k/TTE4NBi1JJqzTnP8AkZ?=
 =?us-ascii?Q?No7o9NalkO+sMY/bda6Pkb6z9H7+tqZ1Yr8DbZY8hZXQU3y+ewM5/uaV1oF7?=
 =?us-ascii?Q?gDl3MizyMUyPLR26ToqozK+cmfY0vWOwq5WC1JIxb50vzlbzWSUv1Gvk3ilW?=
 =?us-ascii?Q?IhrSzx8Vf8qkbr3AZhdh4YcG10hgooiYBT2M7X/TrQB9V8o2Et9kP9nGWMNL?=
 =?us-ascii?Q?pMMPzIBusmS5/PVd/PjaR58EQdD5xtRWA3f0vXiXUzyqDz/BkG8GSql3Ia7z?=
 =?us-ascii?Q?37AVg8TeOWR5utUpcoFOf+hh3ApOe/dplHCjRik9N8gsPRdylH8W9tsW0LcF?=
 =?us-ascii?Q?QN09ozQg0G8VXMzCFYvsideWe538jC4bK1zdn314o0QBIeM2nddXGL48f6II?=
 =?us-ascii?Q?H9FQvRmGUOdEzO8vWcsPzkwQybJVwYk9WfEfK3+w9W38x7Pa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50420c9f-abd5-4075-d17b-08df1830b225
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 22:35:53.6944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GKmfkXTOGNMgPm8dqCOAYPTBmA8ac0KhD6xKgxOW6GfOXCIUjgrMvQOPBhKY6D+U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9144

Add MLX5_GET_ONCE / MLX5_SET_ONCE which include READ_ONCE/WRITE_ONCE
semantics for touching ownership bits that hardware may read or write
at any time. The kernel driver doesn't use the IFC struct for these
ownership bits, but the VFIO driver will and needs these helpers.

Add MLX5_GET_MMIO / MLX5_SET_MMIO for accessing the init seg using
the IFC offsets. They embed a readl/writel using the IFC struct to
generate the addressing.

Add MLX5_ARRAY_GET64(), the missing counterpart to
MLX5_ARRAY_SET64().

Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc_macros.h | 52 ++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/include/linux/mlx5/mlx5_ifc_macros.h b/include/linux/mlx5/mlx5_ifc_macros.h
index d357acfd351de2..1b9e39a509495a 100644
--- a/include/linux/mlx5/mlx5_ifc_macros.h
+++ b/include/linux/mlx5/mlx5_ifc_macros.h
@@ -85,6 +85,13 @@ __mlx5_mask(typ, fld))
 	__MLX5_SET64(typ, p, fld[idx], v); \
 } while (0)
 
+#define MLX5_ARRAY_GET64(typ, p, fld, idx)                                   \
+	({                                                                   \
+		BUILD_BUG_ON(__mlx5_bit_off(typ, fld) % 64);                 \
+		be64_to_cpu(                                                 \
+			*((__be64 *)(p) + __mlx5_64_off(typ, fld) + (idx))); \
+	})
+
 #define MLX5_GET64(typ, p, fld) be64_to_cpu(*((__be64 *)(p) + __mlx5_64_off(typ, fld)))
 
 #define MLX5_GET64_PR(typ, p, fld) ({ \
@@ -130,4 +137,49 @@ __mlx5_mask16(typ, fld))
 		tmp;							  \
 		})
 
+/*
+ * Use READ_ONCE/WRITE_ONCE for a single field that hardware may read/write
+ * unpredictably, mostly owner bits. All other bits in the DW must be stable.
+ * Usually a dma_wmb() will be required before a write and a dma_rmb() after a
+ * read.
+ */
+#define MLX5_GET_ONCE(typ, p, fld)                                              \
+	((be32_to_cpu(READ_ONCE(*((__be32 *)(p) + __mlx5_dw_off(typ, fld)))) >> \
+	  __mlx5_dw_bit_off(typ, fld)) &                                        \
+	 __mlx5_mask(typ, fld))
+
+#define MLX5_SET_ONCE(typ, p, fld, v)                                      \
+	do {                                                               \
+		u32 _v = v;                                                \
+		__be32 *_dw = (__be32 *)(p) + __mlx5_dw_off(typ, fld);     \
+		BUILD_BUG_ON(__mlx5_st_sz_bits(typ) % 32);                 \
+		WRITE_ONCE(*_dw,                                           \
+			   cpu_to_be32((be32_to_cpu(READ_ONCE(*_dw)) &     \
+					(~__mlx5_dw_mask(typ, fld))) |     \
+				       (((_v) & __mlx5_mask(typ, fld))     \
+					<< __mlx5_dw_bit_off(typ, fld)))); \
+	} while (0)
+
+/* Access MMIO registers, usually the init segment, using IFC structs. */
+#define MLX5_GET_MMIO(typ, p, fld)                                         \
+	((ioread32be(((__be32 __iomem *)(p) + __mlx5_dw_off(typ, fld))) >> \
+	  __mlx5_dw_bit_off(typ, fld)) &                                   \
+	 __mlx5_mask(typ, fld))
+
+/* The set is not relaxed so there is an integrated dma_wmb(). */
+#define MLX5_SET_MMIO(typ, p, fld, v)                                         \
+	do {                                                                  \
+		u32 _v = v;                                                   \
+		void __iomem *_dw =                                           \
+			((__be32 __iomem *)(p) + __mlx5_dw_off(typ, fld));    \
+		if (__mlx5_bit_sz(typ, fld) == 32)                            \
+			iowrite32be(_v, _dw);                                 \
+		else                                                          \
+			iowrite32be((ioread32be(_dw) &                        \
+				     (~__mlx5_dw_mask(typ, fld))) |           \
+					    ((_v & __mlx5_mask(typ, fld))     \
+					     << __mlx5_dw_bit_off(typ, fld)), \
+				    _dw);                                     \
+	} while (0)
+
 #endif /* MLX5_IFC_MACROS_H */
-- 
2.43.0

