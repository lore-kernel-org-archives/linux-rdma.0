Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010030.outbound.protection.outlook.com [52.101.201.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA40652FE37;
	Wed,  9 Sep 2026 23:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788998273; cv=fail; b=ABjdyY1mG19I2JqJW4xOOvqngsAettDiKYYg6E0BAtadguepxPKK/XMBkRVHkGTvlB23N6KDyl0QweLiA7R2IRS+ropl5RJ/6oggMXuYrrVx679D6dBYycDlRgNSM/Klw/pnPPlEwDlSGM8nDglkWzuyAZLdU/pppNhAGQEy3n4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788998273; c=relaxed/simple;
	bh=VfsO4hcdLx7ZK2t4VSlVcUHQVuzYaoZv92tXND63qzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h25rv64iuzfYcqLkv0ibeeRceQEEISJDAqAj4kW1mzfzv8XqtN1O/oaPlMCL3IhfbfgpUvfOqqMAU2aBc6py/yvqB1zSkVm0WX/pU+slH+2T92wfw00y5MBxPWweRoC2F7Qm1gfAY9wNgELd/hlTGqy0wsqtwJJeqwdMbge0wD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=htnOA4RZ; arc=fail smtp.client-ip=52.101.201.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="htnOA4RZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tQhbVIKfQDpMRDarB8jicXc4L2MERytTa5D8a0pjbCJ6Kk3HheI45q7kQYqBJV3Fwd30+2fNuVVe/xfAN0yoqd3TnEo/jl+b439fhbFCy7n/U+aKyMKmNQpsKwuCD099UC6jmsItKSd03RCr9rgio/s9aRxUTaSVOxztBcx7Vn9tmKhlGy8arYwRSIYjPAPFGkG+wpoYWGklflzkmRn/6+6c7rqf+Vfe51zN/GFtZDuAPF/py6ekcL7nCS0JJAeshLEYok7sFoDhgrKZLMP2m/8dXdanRSdWYxnC5Y3wAA1xrrPjlWq7CanbT/0xuapx3SqfeEu/RDKRJ8HMCCC1xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0I4ILH2uM4pfxmoBtm2U0QuqZwP1ujxiG/2/wu+rSws=;
 b=c01mfEtLIpkEgjitKPaSa8h3uRARSYTAQsDtx4T3PdqKQjJW3IOQHaWL218GIA2pi/bQAOqEvftcV4WYdIknsaqAgriTFHk6CDHDO0kRJRNV1FSWu8DC/Oc+REHx1HvokBCoMPwjSTDk7G5h4MMwmbpyAo40ulBwk/YnI748LHCrfZLeUeBiMrZ2I+TffbppEtZpxyzj1xX8rEBba9PIsInQeO7Z/pu5nOWMlRllViAU+kTDUjePlYo8R6rxa31heg6ZxhFCoowRnnnV9ZaH3K53lXEKmgvk2Nvxo00o5Qy4rr+ueSWd7dQ1nwFOOOiFtFhvUzRvWVbgCk2CvcmeZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0I4ILH2uM4pfxmoBtm2U0QuqZwP1ujxiG/2/wu+rSws=;
 b=htnOA4RZCGx9e1zbuRa0tNtluk2wL1a5JVsp41B6M920wB/hnlg5BAQhwdJke3Gfjwz1a2KNgZxaO908uQJlLfzJB5vEyKuYP6Ii+BHGOAfkZhPe0I0HZSKba4zIbCUv0Qc78+K/12YnxMoerbjqr5M/H5HrKtYgGW1AFi3LKpGnTQW9hmAKW3OGffMjJglo/PPgi8e9TBRnKX/NfHEXkoJb3jm+zwHa5v2bdUyrjekQPYBl1RtHYLvT8wv2jIOU5IB5eWZIQOS6uB2+MW2OVe8ZWZH0f52ExNjqR1C54gsJLIa58LvfZUE5P0qz5n9fZ/jvbRu3hjdHVDWgaumplg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV3PR12MB9440.namprd12.prod.outlook.com (2603:10b6:408:215::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.14; Wed, 9 Sep
 2026 23:57:47 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 23:57:41 +0000
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
Subject: [PATCH v5 04/10] net/mlx5: Add ONCE and MMIO accessor variants to mlx5_ifc_macros.h
Date: Wed,  9 Sep 2026 20:57:30 -0300
Message-ID: <4-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0444.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::26) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|LV3PR12MB9440:EE_
X-MS-Office365-Filtering-Correlation-Id: 29f4593b-3dc1-44bd-e476-08df0ece2187
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|921020|10067099003|11063799006|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	GpH/BUVvHgcKFxBqRJ39FznmIU53wV8/4Rr3B/Dw+OFLKamWiOMDJJiLT6i85rqiLM07HhfJbrzTYHAK09jmFRKVhJ/gbPYM5/aVyiLeFOw+e/KU/1c4M8PM4FkgV2RXjGXbbnAmkandjVVydRBXUlW1LGy0ZaFWGZi4rzj/dCeKkHlrDKKIV2K45qDvulMlIezIz7cle3KthP/uAk4LoW688XdQcLORsbquCeXTaZlMLhtdTVNvszHr2JTTKlTAoiGeaVns5L2J4gpVG6WMFHwcfgzqeqFafUi2g1yU/Qfe3aap+oPg15b6GKudnrBH3MrFRmyJOGzkrksOs6Jdyl6SaBgLOPvdzUNcZt6qcI6dLTu4vw8VLIC4oVsf4JaDi1kHWsWLpqO+NYsYxuzCcOH+MWRjThDAKyj7hLL0Pq+W6AXPZkcylkssStwNlYUVNEcZUQVPZpKPb+wqL5H7Ct9OCx5V28BbIm1pS2i/By9WjxoHrUhhAB2MqEVWtYFlRMpZg3R/lFzXk9wMx9SadlNMQ0SrLcaYzgenInD0hWEUqgrHzWUXsJgyb9X7CL2PGsKVROuj9sE+qRu6WY3ORU2zmKV5S1dSpCxoCo1CUByqgS8B1ySnSQ2921/D7VPQsV3vvaZedXC5YI2TEx4x8e9cVsaUaFKJ8WUvOgXDLH4hvP4AXhB0Ay1i3hbV4ylL8QrO2s2ykQNU1rWBukpUWA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(921020)(10067099003)(11063799006)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BumlkZNt7pvlOxfr0jKf4AsOKF/DIgvphceeeJlo1wZNMBU34RbHaPPBpmdY?=
 =?us-ascii?Q?U3zaBvzK2UQyZTk3VTb78CzuIKyslA+uUxBGVTHTx3UhYtcjsrvVE/g+HsFu?=
 =?us-ascii?Q?7xaoEXONtw5COwBzmWbSmk1/6ckF6eYBLWNrAIyFdZIxssxTnsVQk1ATAYD9?=
 =?us-ascii?Q?3mLZMJo2103Eo3gFymak1zq6cKyCwZ9Gx1SdOycu9FmNJzfbOkeHTGKrIE+x?=
 =?us-ascii?Q?YNL8ffJ7v6FfxOT1QwIs3oOuWmgOP96TdRS+/UjRarrf11MYl0LX1pxT1Cmr?=
 =?us-ascii?Q?33aXcrwZk3d30ixNrnGFzE85ktJyy7Ao71d6iAk48XvIrreW2u0DLG8pmUTa?=
 =?us-ascii?Q?DXqiXD2vR9auXr4DPYN9BGZVlXBqFznV/n9mHjJnuTYxGkIPKrOE9LHL9DHf?=
 =?us-ascii?Q?eKApuFQiC663PuL2TDjcimch4fhwq5rxx7nC7uKFal1V2n82XZ9CLDriYpsp?=
 =?us-ascii?Q?CfQYa1G6lQexU3/+6FtQK8y80yNobp1PCJUduwkV03y3tQyJnxXSnMof8FeJ?=
 =?us-ascii?Q?msk8HH3FkSQiiVJ9m0L5JntZREG45kV3+e9gtcu9JBynAFIPIe6spTmaZUNR?=
 =?us-ascii?Q?OgtNwi5a5lesRgbLRICX1NN/qA4QiIcNbJcnuo0zfs2OCpTFjnioihPj4Zv2?=
 =?us-ascii?Q?HS0RILh8TX2bokO3XTGPlpFFLIS2huDfCowDTZ010pMo6RT6rqFdew5rhFQn?=
 =?us-ascii?Q?jm9a3CS9l8Zzxan1mX/zqDw0FR41Ndob1+qpk7lUbjHU7M6/sWY3/PsIaek0?=
 =?us-ascii?Q?NURhlVzKtL19fSmHvSDXBY0wefDtggPyd7KGH5KjMJ9yYBo4Tdw87yrbFYVz?=
 =?us-ascii?Q?43ger/dQomUj7FIiHZEYNiqT77/unlPHEJby5fbjRZAB/ZK/NQLjKzmzpmcg?=
 =?us-ascii?Q?f2OMnfZ2Kp+Q3bDzbzU183f/IsXlc9pPKAHAQjuBhXRufmV3HVKWOTul3yl/?=
 =?us-ascii?Q?BcJAfK07G7h/pMJNIVaboXM/pjY2EppleISpIRKYUGOeljS7hJTvs6lgAIFL?=
 =?us-ascii?Q?EEzQwJWZ2nnfXUi1qSdi5KNTQsyQLqQpplIaBaJIjf1qbQBKOCE+AMj1G4fW?=
 =?us-ascii?Q?wi88Dk8KgvohELJv/WKIm/3wxudieFIvFqpb7+ntMvrSYmbxwPUnP60Lc004?=
 =?us-ascii?Q?4VjKors/8q4NVacPWcA1tiztbCnrCfhk+yYlb7tkOHkTYxRpcm/VxZbsbCdY?=
 =?us-ascii?Q?1552ezWLN8rPc7OaSZTEje3LGgTnLV3Pcsqqs6WEwu1ru493kXcfs9PfQ+yH?=
 =?us-ascii?Q?ucovCz+fUW+f/YuuU4h/1JoI0J8/VZcczQDZb3LgzCbGia5gLxQw5KNfwmkt?=
 =?us-ascii?Q?DiR/phXOk+/QGHJ1MXJShwxHrmYdqzcSwuFfFVAzXFZomScvJ7xNir1/I7e8?=
 =?us-ascii?Q?3szxxx4+FV1zMPFbd6t5wAb57QnuGXowDEkKQPlGgO759EKjFrL7ZV/Xr76y?=
 =?us-ascii?Q?iacDuHeT9y9YjAjBKynypZYDvLrwXtG/a7ugpFuYybLKb7KirxAqyq4UApxy?=
 =?us-ascii?Q?PukdHWw3txuw5FRi6XelmDvvtN6pdrTW+PCpZF+5PPWnsAzX/5P62psR0TTT?=
 =?us-ascii?Q?VC5JZQQx0ZwRsG8qfVJnn1Q0mvQrxhgWVf5wMejMPJ/zpjTVhycvTMNtxvMG?=
 =?us-ascii?Q?9dGUiT0XkfzU9H5R/R8pK2rML+EF5o4eNmTTwc/YmoeIE0fEKW0dv+uX5mnz?=
 =?us-ascii?Q?CjL+Y992GQrfy7xNvVtrjx+fZGioTedIOSazXFt+ZrrNeOO5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29f4593b-3dc1-44bd-e476-08df0ece2187
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 23:57:40.1297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XChQve0YZhrsr26w7FVC51Hf3SfBK0MHux9koP5w6xXMvPrfnzXZu6dzkfSc7Uur
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9440

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

