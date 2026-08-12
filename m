Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010009.outbound.protection.outlook.com [52.101.61.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43964746CA;
	Wed, 12 Aug 2026 14:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786546800; cv=fail; b=R+dXtmjHvffyMawwPS4GYFgI3BQIFvP4NijEBLiI3G9mo8/okcfpD8MmZ03eSXKBKEULvLVNASZfb7cL74lZW0MSYc8lZTvEvpVE6E6JwcLyQ4lDd21piSDssGD2JoEOLfO95BugJh6O3iyHEpdAYgWyILa71vfC5jPe0LMMWu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786546800; c=relaxed/simple;
	bh=VfsO4hcdLx7ZK2t4VSlVcUHQVuzYaoZv92tXND63qzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JM1Q06YDvzoz90P5w8SqAQHy1DJRqLilnep1idjnccM8kREI7TA93GQ0BXTKYuAldX2xV6z254oJEXhBsj1k/PVvuMO9odhN7eScIDGW2CQEngRZUT/hKjuWSLaB4WhuOvADrL9+lf7UX0pVY1zejskitsn9rv3S4vPGa16w3MQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Io0kHxtR; arc=fail smtp.client-ip=52.101.61.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Io0kHxtR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v0GhHVFLTUr2iuSWy7e5kjmdRbchZuyHalgdij0GVQ8ETMVf7KgmQdx3gIWI91+Dz/0s7UTE840kMHIcDIFWIT7Ed1uXi8aUU4UhBWE6EjK7C+yz/ySo7Kl1EDnkbW7HFb+eOD0u1AQO7iZB9eQ5bODlhZ0IA5A3ashLNseSWomNFTP2VTvq2yyO54JBvRNgfdYxPLgKM9v5CK4scCbHnFexd+CsEVE4AJ0iUSCaWR8bf2CMwH6HKSGQuvrzzrOhREtfnN4JAgKPWZwX5oMZ5Mm9BCJzqrs3JkGHiPoNHA25xqsADg7y3uvf9gX/yOCnBORSbs9Y6bbW3zbpgvYKVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0I4ILH2uM4pfxmoBtm2U0QuqZwP1ujxiG/2/wu+rSws=;
 b=TqzRcVoEWRdjZMIsC9o0nE3b9uNzxGL1S2RxLNTX5faqfF6sbBMrxuQecwi+LWJ5tFEc4/Ihy/dZt+OTP0A94a88uJOc+/odIPGvqTguxsyM3JhqqgfG8QbOjU5VxwDsvbXyYqf8i/r2Ob4XaHfcdGNCOQb8tv6C8ZYRxu88Hh3e/4/JcfPnt2h2OOwsDRUB9//FXSjG4R13FUJDNHMMo4pp6Czg7l3xawcC7vRg/37WHkhI4kXD/y7AwvSoqqa4R3ZCDub5MkZbxlqQoiFWCnEPn+R4jbmE7TcPm9Kfr938kfXCgtdqhmeK51rwdcfuehpz4PI8m5vxrJg4BIoNKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0I4ILH2uM4pfxmoBtm2U0QuqZwP1ujxiG/2/wu+rSws=;
 b=Io0kHxtRO5CtzJ20ix0YuSgAW3jB28MJYcR/WCekDskP29MnIXJP7RjzaUZbbCELkOo6ILoXCsxEOiwG3n7IBX3AwT1JWAgvsPFBD9vOaDOGzg440bzP/NhzlSiiSmWM9wKCKu8SsFCJsXQcxfF1QP6BEfN/Lh7EPh68/1P8A/huGsJgmpVmNT24rnMsm1yq18krPhuRk24i9L197HTTDTUt74Xo5DI+Xa+knbSBycPEqFssQikvTFPz5RepWxGWshMQ8rPfdnLW2bIxoZjT5ELO7Moj0kOOJWsWUtyuJODLGI2FQNloI+8i8joH9aFdbzyzzF9OxWZsTJ1tmTWWbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9654.namprd12.prod.outlook.com (2603:10b6:930:ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Wed, 12 Aug
 2026 14:59:19 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 14:59:19 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v4 04/10] net/mlx5: Add ONCE and MMIO accessor variants to mlx5_ifc_macros.h
Date: Wed, 12 Aug 2026 11:59:02 -0300
Message-ID: <4-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0172.namprd03.prod.outlook.com
 (2603:10b6:408:f4::27) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9654:EE_
X-MS-Office365-Filtering-Correlation-Id: c8730297-7035-43c2-090d-08def8824552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|11063799006|10067099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	dX28axjN2gM0Y69+F2RqwD3osc0btktI8RH/6aPwCJHnxic4TiHS6Gr0BHXYXVqKH025YbRk5r+vTvyxvQBAvx3iYQq9pMNK2s/QKe2Gz2JHzyiO9YPRCDgz1p8WVsRBORJXp4l41N35SBSn1Uyac88vCPHlddAvYDNHq7PPU7sYoxX7HbnHWHwv8cIcqgylVvvy+eTJ/n6eJE+2UQe2h5Ov8X6utsQA9vGiFAmBmc9ox8K3Z40oIRb2Uxurm+/Myp0RoMUQoNCowunPpnO+/dJJzflPyNonyvZw1dMVvLh95bLaXkZyVtZrb9KsbrZ+EsKnA0kw13gHjNGEM9VA0CcdsrGwsIbbnQharDGOcEcCRsFGNzq2WOEs2EQqb0qWg77ouHqM1e6RKeF1z7ysOBz7rHn81IJI8c9Voy8y21MMsweB3ImTAKI1uTMvh3NbrOshsAn7xWQO1yyFvYpXONwfx7I7m+NUfGi6yI1f9/EW2IAAilfqZSkVd3xMoWVFuBB0hg4P/xneUueX1ROQHiE9IHzTn2npdAAMlpuhizmQuMzjvuIoMfbS/jZZx5RSANHBuxAY7SYKhUnemg+jzJSLWhFOAlvs97a3lbs/fiDkr0Wt5iUF0803LYlozkNmXKgXtAcT1EIr1yM1oQGMEw5iFfGzt32GDyRigiLS4S6N2mvw4ep/tLf/NqxyDfiAzCwoJJehh0uTpJwlJmnKnA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3hjqecAdTEyu1s1z5WKGR96gWn6djL55M2WnNV3YboTrFVsnL68RR/msspHB?=
 =?us-ascii?Q?qytQ68wz+vJhruNH5zEPfKiKGBKaCL2Qkfv/WAscczChy0t9TBTuQePvUBsa?=
 =?us-ascii?Q?0yfOu/VER21umssaK5EWAbBP1bLDyhmrj17qn1RsTmgCr1s4ZTA5R5jnJ+b7?=
 =?us-ascii?Q?5lWycDO+urvZ1NBjlj7AAHnKgSaebwnYnimbgKBcM8ntyx6yqnjMMpoCoMCt?=
 =?us-ascii?Q?TucuDVhbSAZjsgQeKB73QSJqwPcfIqtzGU26g+r9NGMEZWL2I0lFt6lug8/o?=
 =?us-ascii?Q?f/Ga5fYqWvc1w1ZnCFxghAhaLXVzN0rcEfAtYSLpaeT1MsZqqIBwnxnXBzlG?=
 =?us-ascii?Q?RkZR92YecJu8Dgt2NhcJnkzT0qorWyo9UPPpGsVhi/HtWnMDHXbZLPRcP58j?=
 =?us-ascii?Q?A2azfmfx/YOPYyHrHYjnY4NhUYNpdx3GcTBdL+KeCTiLEKkCKtl67LCd0rRp?=
 =?us-ascii?Q?xo9Pq4pKF0iqWiA+wicTBq9Lc+wQ3j8dEFO1Gu9P6GkFI2ogm36ocukYCTFh?=
 =?us-ascii?Q?t6PdN9Cz+BhMGcIq9oTIt/OH9g1+uSkPZlWBx6pIxpIMZrvP6B2FKDqJxfyM?=
 =?us-ascii?Q?KWLPeyRbgzoB4AH/TeIdD+LljnG27E+l6BI4Dt4WkKXGtvOIlGVOAurOOz2o?=
 =?us-ascii?Q?4iMLj6/rXBbrTIUc3/sGvT/JUEuCX74+SxgFM9SQsrWangVdixv2cq5YIGCx?=
 =?us-ascii?Q?FG1O0efkOQyU89Ro6/QtTvFjuYCaeE9fneX2vJkEloBIe2QKf6DopaN8gN+g?=
 =?us-ascii?Q?wrrd/iudiDR8XkdhAXbhZ0iUgYBHLRW3mn9ORvavKQ6dypZEFkY33sJR9ow3?=
 =?us-ascii?Q?TJ+9oJF5oYzPgk4cTS2YORgKwFkZCkVQn0kvDXpuiQ9WdJrZhnUPhiw50pPr?=
 =?us-ascii?Q?/rR+Imw+proJlGY96PCFScvglfcqytY4ipZJMmZ8zG4rG7+XjMTQopZjVOQF?=
 =?us-ascii?Q?O8FRpfCTZI/z0lfklGIcKTYJLeSerZfxQmqBQvbm1GAXhmjFskckMYWrmJxM?=
 =?us-ascii?Q?OL+VVWawrTcaLhIP1OefFxE9yTSk1/BJHLru4AuDbH5k6mD6/piKldq2qJn1?=
 =?us-ascii?Q?AafJ2wje+CdSWRiKyhDan0QAfeStzdeSLhhWrzC2ULNmuT5QdBFg6NbveTMh?=
 =?us-ascii?Q?I3Ajh/eJFBxBd2wDuidJz3nbrV4Rk97wOvxZJZIyH2Nd1W4/lCYktKET7qvs?=
 =?us-ascii?Q?TnhaGK5ij1VtCrq3nqCqqOHzUHKy+lXmYhwG0fuHzFWbHS0YxXOeqw6JLe+f?=
 =?us-ascii?Q?EInkk4snpCdES1WWqz75pTpQggSQcDbDA8LjOs3tztrT9GrY3DrRJxZxuH2C?=
 =?us-ascii?Q?mpUyZsT3EauSZr6qfKY/zYTUFaR/+n/tv2bJfkep2zIP7U5Php4TzRNifaO8?=
 =?us-ascii?Q?ntnpP58uNEBf3nyBCaocs1Zu+NpF06gERFjWDWHKgRNUHYYu9R0i6YoVGjSr?=
 =?us-ascii?Q?k7L8g7ef3i5L6RA+g6Pe9YVXfu+Tjsyq2gxvewVPXEI2j9cwksQeM15Y1qJQ?=
 =?us-ascii?Q?XmVb20EgZ2g44tFgNSglqWqiuGbrpT48J/FpfwjYcpBZZkQfjUj/bYdrQMtC?=
 =?us-ascii?Q?ephv31AIvYsiPitsrFsnIkPN2JcAFlRXeO/KHOclGqEuCVcnvb44WaNAEaOk?=
 =?us-ascii?Q?tsvCrEhjXQrNa4/7B/4Uv8Z4yqOj80r/QIzZc9tB3bvqWHZayXhAayjhFv0L?=
 =?us-ascii?Q?VQmAawuLNrnFQ+q8ku48SEUbCOGYL0H4jzpCrMYoUmNWfoE14xlgjXUCc1Gx?=
 =?us-ascii?Q?ZvLZHcVELQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8730297-7035-43c2-090d-08def8824552
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 14:59:12.8761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P8pONCdm6lfeiTzNcUbX70TY4XXkWtWToqY/Grcq5nWGYp70Z/AtB8A6Ypawp+ey
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9654

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

