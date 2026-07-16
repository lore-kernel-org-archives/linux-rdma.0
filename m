Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012004.outbound.protection.outlook.com [40.107.200.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6670438463;
	Thu, 16 Jul 2026 17:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784221425; cv=fail; b=EX92VRQWdUrVi2cVmInNDwzDFnkZmpx5W62WQfV9vlnggugvFjdgYRTTKbIAuZr2Dw8AsP04b+TZuwXWrfqkBw0+9AmjTwW/a0Td/ept38LtGicZtNZU2ce9+Ii8S8pYpllkELjJoVPFDbSftEUhqqF8h5zzKsvlZiT/VzcZzFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784221425; c=relaxed/simple;
	bh=VfsO4hcdLx7ZK2t4VSlVcUHQVuzYaoZv92tXND63qzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KJKmXJspMVjlZGjV8KFHaLtqWt1ccGuQpwiGDWiEWmoOoSRb/c7REqYgl9gbfYEyF5OScoZsqHDccQ9qmBVeuoaqRB6qTkuKCPMz18PKSd4x3RCwVROrpSTkcA+Pjr1QNY+2Pr8oqQmC8n/8ajgnBJG9CV+vo0b3bUiv1H0dFdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FTCeYsTY; arc=fail smtp.client-ip=40.107.200.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FTCeYsTY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CXV5tZVAkjoDn3g+28WOsqpVAOc395riQpCjUqwq0Ce1OFs6yOCMvRAgE5awfwouAT0rV7+h7koFHRrMEe3FeF8mVhiAaEGczCheN/AtiVxTYSin3v+vDCgqno7mZvMpl7iV97u07kI2ON4QvwrviC2I4YIrlrmYD4lw1FSupeOphjshOB4ZwhZGKE9DWUjExHve1E6m1ddLK5Z4CBR5VaTy5dI9UHzVeV5C92sn2EWoN+fmN0ZUsGFjkhppP12/x4sFE/1LuLOPK7F1gItqHetqU1270Y4UHEY1yGbMrpjDXRzHW6wpkmXoq+3uGhaPNc5mQpncq5Uv9ae/hvfkhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0I4ILH2uM4pfxmoBtm2U0QuqZwP1ujxiG/2/wu+rSws=;
 b=qY+cZBKK6BScSi3zjrDi18OU8sYDfPvczrnzLf9wiewQKgBVcTEO9lgvr1mrnjS8XQMY+DJ3g1aSbtVowwC/fRaVtTvuEr3iVCESyeJZD1n9bURZUH1zbPSX/ibJxQjG61b82aaQ8VQmo16xlSkQF9IMvwyun8vd9Xr6avcQ7CO2Uk+NX6wNKyMp+siOHUd2b18PiG7Ard3ch480qa9Tm/IX5V1Vl21pXCilbTEhsV4HVk+iDxwQ1Mvf5TJOywZhv9Bdca9B7X4g1Q2r+igAPKpCsAcpiQtgiHzXLurnQ06GnqXkV/HSbmBznwmAn1RKTURGHZcNLLi2h1Jx9LPflA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0I4ILH2uM4pfxmoBtm2U0QuqZwP1ujxiG/2/wu+rSws=;
 b=FTCeYsTYm+oBuFlsFDrnpa5D9X+qW1vR6CcYb0HrUdWP73+o/URU09MgZZq1NR3LPYCmckbwXIe3h8ZSw4BCxN19g1/njwi3f0X6AsVXdyPqLC23u2eztQE+fI80VQKf7pEgnoZx0rni69Oa8Wb5en5/Akkn6aYDi4HEZ5Y96HEge7DfHcxsra22QncILBcAFZRxyC5FgJ/CcuXq5HMkAsz10hvVPNV6kIBmxHy8EkFP9m2crtcbvwGU02R7XYHyCz6QWiiaz18Oakbk9kEt7yhifRwuMuQv5ZEta9gPhIHPf6//D4C1ML5Tcei503vszB7LEKOIzNIQA/XnhMB4Zg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB6216.namprd12.prod.outlook.com (2603:10b6:8:94::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.12; Thu, 16 Jul 2026 17:03:32 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Thu, 16 Jul 2026
 17:03:31 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	Justin Stitt <justinstitt@google.com>,
	kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v3 04/11] net/mlx5: Add ONCE and MMIO accessor variants to mlx5_ifc_macros.h
Date: Thu, 16 Jul 2026 14:03:20 -0300
Message-ID: <4-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0130.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::13) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: f69d4dbf-f5a0-4562-0f5b-08dee35c28f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|11063799006|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IHOZvGRuipDiPe2jtk61KycyznNjlzBj78wt+sHhbM5+l5mz61T394WjYWqC2gv8JEl3P0wdejycV6HhW+s7awDHRj5gn/gREaW9PUNW/Jp0h6UdKYwLga1maM7/GFYThh+r9fFIYNBgFGBPqMnnH10dddmI8qvuwSLjaDlDJS+Rf6ivga5DU/7E6rf4sxsVkt8h8LPsTMKJxzgQvVWn8+zy7+ULuNISVIZ3nTwWxI6RFkjBb1obi/hvOguPkXhEa/f6qBwaiw1ZlvETa4a6XZpXXkabNvUFSW765vzXdE/gxkcZ0YUIBzM8zReSXs8wClFiBCiQ+c78NRjkLct8Ye4bjsEnKCkMlz396awSnJzFH6h8HPrDubW3JMN2wF1ppvJAEZrMrxLmmfsaFNrPcRJ3K9D0Zt1ZMv7jqjES3A9f3llv+mAW3HEYYts9FURvFbOM9HDY0x2nnJdz31NUlKxexVTuAZKCVNV3o4Zd1A0dUQs3WytdFmSEWW8ri6pN7MJ+Y1vgdaIjwhm/N2h6PaZsNtMmynY0Ft3H8jz0lgiP7yppZaRPZ7l4OeA7bHdEbS3bR/gDnIcB+uopQVdK9tGyeIClBZAFQAeqrIIn0FhqJ21ls46TZ6F8kamvafZnZyCdVlC+4OlwM32jVRun/raKZO+HugfAdVeZFYCLMOz4ziQ0v2AjYo+KF/kFIMXJf9PS3ykAKvlyWDvcLCRsoQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/I+nIrWQFUG4UgNfTX9yTAR5jjVHPgZLXQV+tDxvFvOnWw7n8L+OaaTIrCpj?=
 =?us-ascii?Q?/BMQ2SnDMtfuoVK5WfwfUl1pB67X8/cgDaqznioAbztVeLkMemncwveM9xAQ?=
 =?us-ascii?Q?2dEiKV2oYsIDSAHUALkKY1y7MstDrPWCi1xhnp5oka6tQNTcLcDL+PGyowEk?=
 =?us-ascii?Q?MMv4iE50qitwYyb19XyTwhKnmW9edFO6qiDXajpSKZMkBjc/9bIqks7gqO7Y?=
 =?us-ascii?Q?GJQEvpB6s4Zp06YrBOoEOreW6tP4sdjIPOWLXNI3QpV3iPkex7Ubl2CEk1Aq?=
 =?us-ascii?Q?2p5PnYhTftD0fWBsve7HbgmUJtKwLFM2F4YhmK47mVbDgj4pHRXdv1EBc77I?=
 =?us-ascii?Q?OqYZoP0AaoHHgEzOE3QdPZWIc744toHlprAebIvar9kWjIZLd3rNHIwRwroU?=
 =?us-ascii?Q?H+lb10kbUJscEvDfZChjAN0Y/d49wkOjgumFwCnpAWgqrFKsZ4oVminJVnbi?=
 =?us-ascii?Q?tz68DMj/4JilgGjI8ZpXY2FTpwpXv/S3++FWqdU6xYSqmOnyCQ4FXzr7HWUo?=
 =?us-ascii?Q?JNdQsM6G5COxyJFy+F7kxJM37POTFGrdejerWdFi27KwKug14O+/AUdYxZD/?=
 =?us-ascii?Q?amrBBtRmlZ0edO/+BSe5NaAfLqNR3tTUXFeQofv259HEs7H2Ri4YWDfGTCAz?=
 =?us-ascii?Q?rxO6y+jn4Cw/Axd/9Cgyz0kOTzRdIsNmfznMoNcES1ARTlJfZorIoIMp9wij?=
 =?us-ascii?Q?FpyrJYHWB96THeFMR7x/zV2iv8y3nHcW2bQdcGAZX+0thVDIEXQSfDEq74Mr?=
 =?us-ascii?Q?BM9nBgR9+m39vW/w/NnALDZqQ56hxC7FpKUqSK12TCVEtGpCO0VA1nZsNGmM?=
 =?us-ascii?Q?K4AZz5AI54Wl8W9dC9C7y6a86i+9UDry+/HdlL9duHnKvVELcG6DWxnnmx9D?=
 =?us-ascii?Q?dAS/K5m9kLV1n0KGqu/fBKME+T2cbEJqh8GZkAKIPuT5DxCqXuhd+gVlVVw6?=
 =?us-ascii?Q?qlhHVHEhCoN84TQb0G4n8ATtEaCS40OYHPU9HiQu94L7EzaEcreFTZUDaB94?=
 =?us-ascii?Q?5/TVE73kVo2GRpU99co5ArzNTQlGZnEcKmeRKhBREYJjyaBP7h41S+8+JKdC?=
 =?us-ascii?Q?yCoji8JWqOwfBx0pVCxZhVsF8E/0GHGMbiHrv8yy+0jaMNVaqFqrV3LURp0h?=
 =?us-ascii?Q?Sp9W+fwKtVcMYPyht0h8ZcaStCyvrTwNbUJBFHjxEn8KCltKZ7U8q6vQ+FFg?=
 =?us-ascii?Q?z/IoiarBT2faaUZg8WxSLrPOvECqOs5c/SoGwyjlNkAehaWVs/3xWK9FcDT8?=
 =?us-ascii?Q?1RSIKosGVqTWpqcEpvOcBfwBjb9S7YnpZreDCSrXx1at0Wq3wrcSWu74y9/m?=
 =?us-ascii?Q?GweZV8ILBqr0PtEULMNfye6PYdM27vXaqBxXVRAq6a6XN2ia0WKAojQOh+Ep?=
 =?us-ascii?Q?lMK+KbAeK9bIUZQoaShM7Unm4Ab61S6Oecy8SXoCGoK4SJ/XygT+l5NNrJgI?=
 =?us-ascii?Q?U+iLxSkteAWDkdINGRNwlnDjm/DoeTEOq8HV+70Uak4RIYZ2WmQ/4jrORc90?=
 =?us-ascii?Q?7uBNoEywc4Bl3UQpK5EP2QVurB+ufgSHJqOiKGnU9cbOWE4Sgouhd/8GEVP6?=
 =?us-ascii?Q?t5GvdgNnHjxetX3hT9cZh53fRyZzuiVKyq/rgG4gDox81wPmePlYfzyr08y/?=
 =?us-ascii?Q?lLF3wiFM4Yu6OodPbV1GfTYFuXlFdx1bH8aumPLNtEQEDvWeuPWxVGodICiX?=
 =?us-ascii?Q?JqAFCASHduz3NfX3mUpITmnm6g7UvHLwP2soM3/YJrl+kSSx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f69d4dbf-f5a0-4562-0f5b-08dee35c28f2
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 17:03:29.9744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /QMYeZC4K28SM8fGQo5FovRLgfYL73o5dbIhWKmQ4c25kslluRYkrPNwHh3RgkXp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6216

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

