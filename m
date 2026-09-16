Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010022.outbound.protection.outlook.com [52.101.85.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194694FC8E0;
	Wed, 16 Sep 2026 23:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602652; cv=fail; b=V5kVORz5J04YD1Eb2wS1j75POuACVAItmASi7IEIs4sxLMJz7mpanMBduX0U37E+tSNc9MtmRII4TtAiR3ECgaD/Y06o5EWtjQj/KROlWQGzbCGgC2cn5tn/up6FleyNPe9rUwlC8h990u3HRwCTOGvZn5bpq9YL53aHB81u1Oo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602652; c=relaxed/simple;
	bh=kKy+IqKAL9NkdwMsK/wc6XuAGGswAQ4xv6CzmeoLDR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W6u8o85XIRlvb7XopHNJQ2h9PduaJU0YwBNWbGq2IuOnv1GKsSN3qkgAJP9Zsu3tFB6w2mTF3tYgPXHiuswnxMbby3FVQscUmPue+sKmf/H8+8Wfd28d9vys78XlPajm9qkLzcwvTZ48dgR4gJ2KsP/Rm/0mu6c1r+X7G2apoj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UA+NEHrH; arc=fail smtp.client-ip=52.101.85.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UA+NEHrH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zDNbWCyOIkzACPrGWY86BUq25+X/TEN7zExhg3YRKiwKrgmEWsDapmHed7Lt0oKzObH51KRYtvcnR+exCWup4UnS4YuPHO0RPQIoNIt12FJMAJbMhtxLfSlrkSCtpyKTs8HGxQvLDN3wVS6qmo4RibafFhNB5dk8daafbPGe5DtUZnGHRLzUXk1vd23Q7MTWNMVfarwQ6FiB4DN4VV4MIZbYaxbMtIDq/ktRTIrWT1xmAiDQbS5l5cTyFvMrD0M89DI4Z5oE+712jSWxpeatOd1PD6v7X1coBaz9dmYLcZyjsGEgr9RUvICwHSKf6wsW7sgfXB5vRD0nOY3beAi9+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/KbU5x46LhEyhl5GFWFr2rmIxkoZnDsntlJ2PWkl7hM=;
 b=CQk+2ldjVTg+hENJ0e1z/fzebLkqjcRZJF3Nwa/iEr9cFYW1gM2VSGNkQB/AhDUT6GS/rqtaoEs/nXH08gS05cEdzs94LE/crXuzcktQUENf7hi11XWEASqNVwnKXfhKqK7OmKRC2qBIsH2HAFZ4XBjQXC4G16K3Cvhpm9N400puekYS040g9N/tbNsGie0rvHM6fJv35j2zNhC1JvBaw5W5vFmBHM2rwUd8zm/covrwRVzpUxX5j93KyfL13NJNX5bKaSzXmYyvLTOehuRVEV1eFdCvOZF51yDbHFFPZANlwjcTHzJRMFkE+jgPRo80CgFgB8PMRWrZbSyZPG5Ybw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/KbU5x46LhEyhl5GFWFr2rmIxkoZnDsntlJ2PWkl7hM=;
 b=UA+NEHrHcy3ePQFbkesrJ3I9WhDf8xdYAmhf7/dz3jjHrWdOoXI3G4hHewVg7AJig5I4bRFdhMAANCgexnZuePvFoSMsNfMUVE5n0Adt7B99fTRKWtu1Kd9Ca2LpFKCTHyCTtzUvi+rZ8YPsyrinGjJWi4u4TnoKV4Qbfh18g3X7bUeW7fOfWHgOnxV5ISg3L811Bzf08CPAPbu/+xBo97e9VlvmfXhXRdvfXV0ShsIZZAG0lL0WGKRIwT968xgh5xnL8f1L1zdZ+3t2J9rJjQdCVWt3II/aYrY6Bkr1R9sp6vWuGZ+dQ85469cd/VRvT49XQOtW6W9gzXRTJMPxOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA4PR12MB9787.namprd12.prod.outlook.com
 (2603:10b6:208:54d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 23:50:00 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Wed, 16 Sep 2026
 23:50:00 +0000
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
Subject: [PATCH v6 03/10] net/mlx5: Extract MLX5_SET/GET macros into mlx5_ifc_macros.h
Date: Wed, 16 Sep 2026 20:49:51 -0300
Message-ID: <3-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:208:52d::35) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA4PR12MB9787:EE_
X-MS-Office365-Filtering-Correlation-Id: f9939266-a19c-41a2-de45-08df144d3811
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|921020|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lwo00mhNVZ/xwSX1f4hJP+O0OsAkEWQXLKIqIz6+FJpjS8NMmUYJhAk/8yXkJDD4mC1LiWQJfW+LO6gMCDZgDRPoDHqTtTx30e5UDVUZUiMMTflnwCLUxkxNLwi5JrPi8JTP+zj7lXpD1OQP2+I/Tm3K/z3P4ZwipY85Ljki569vb5xfsZn4K9uCpPLl+v+jCql/doSI1rVPDYlS8pIu8YhP/1C3BTzALh2+909JdE94LSUYPviS2RSdGYbJLm9ESYFJLPMhKJgli4nmFbvwMZoiIiJrgW4HZgbyHai2GkqHAdyBgVKPl1nMhvYq2VWjNAPL5bYTAU9P4c991q/DaiU2IuWe0VjJY40lqDmf7TFEwtOxBtJDFUMulSvKgcXm+x4Sr01C0MMJK7j9Z9P4LBERC7UHnRdskS/+Hb/fEHFPIGm4NFwlsIyapSeJPi5jkpOtXF/SiAZ1iI20s1VImpYXOCYNb3Egz//BFZfJ7abUboTetf68UKU6w9urQhyvNkamHE+mm4m5lRH50rsq+B50PzMAKwZRBm5J8E7ybOGtqyhOZn7uJEoMOlvB3qP0YIbBH1hAQTHLRkChrqhtHJtHdL/gqxjhMGrIah5GRbSN1brp7rubejuI6Dwts2jaLmHeko94DtNPv4Gb+35rMPDykGx2MLiuMeIdnFtGL1G4cNLiTBoffc7nG2z/JAcjxXAnWAeZw99BUnjMpbr8Lw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(921020)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+fUCRqQ3Bx3V8r2HwCzq1AAkbJCP3PMcbIk4YxpJ2W6JXni/DLF9Sv1BJDSc?=
 =?us-ascii?Q?W6KWecQY/c2zpTE6435RYXbdhukTKz4L+UYLF75QHbJ+Iq0Ux7d/Ow4f/YkI?=
 =?us-ascii?Q?NDW4ljvunwtIAspyiPEKltgfEfoqBnvo9Lu6qDaf3i7tHGqx8XT1koQlH/WX?=
 =?us-ascii?Q?jftOLhC31k7uYj2CbIST490rWecX1BKqeQ5GgqFmXzifVVLc3s7HjGwov0uO?=
 =?us-ascii?Q?/9WjmoGTxoWUUV79pl6A8a5ZP66NMuTvPxk9YZjWKAdAx5QWTBdvPMHYjUz0?=
 =?us-ascii?Q?5XBD5dtAn8ilAJuh2oh8wlayry4CnCdQzEDYu45ZFKgluK4pm1+LEoHnOOCu?=
 =?us-ascii?Q?WX5+aG6M+uwz2R+DXMPZY7ZF+4peDeUIceGex7kwTg0VEyPokzj60hcrLbQE?=
 =?us-ascii?Q?jpSou8V0YZeZcMjVWfqqoCXRZy9lPzrbFSqVhuZu0AwRTzJ7pdBku7SJH9tU?=
 =?us-ascii?Q?brR4P31EbekLENwYQ0fu41aFgf5jtj5kO+QgBMgWz8veE0ZE6K0PVwEP6cnj?=
 =?us-ascii?Q?MX9WSmr7XoOOrQNCO2+rbSnksbH4/SkZ1INRu702xep3noliJmlGfAP1yMG+?=
 =?us-ascii?Q?uPzHziDubSm1V3N37lpyYmXG3Qip2MhxAHVftYai3a9nkrOLjKTv8nQtKhm+?=
 =?us-ascii?Q?rAvg7nwyzdSYGrNB6zf9mxPXzp9K50kgMaBG8KB66yHouOX+FvPVMAZbaClz?=
 =?us-ascii?Q?rOdDgAda0NxnwVc3QlbU2Ub66tHpzpjEZiuiPNfE+dJ+IwAL0vXwKcHTrFPT?=
 =?us-ascii?Q?GRH/7rGlB3dFPCkgfRqosuQNOJVUtdnYpjur/S3XDs3phbE8vzYbeaD/m6b/?=
 =?us-ascii?Q?RX28sE27TIakL0UoqCYtqIqG5hvlhsPZxQg726yT2AoO73LtLgjxsJ0SMBkW?=
 =?us-ascii?Q?jdVvX5jxRndZMe8evOGAiaMSopb+K03nGueiU5nHiD+heqWS06DwMFg0R4Hq?=
 =?us-ascii?Q?C8anCrBGvgNqiRLBAnhyJZK3xWYqH/SfDS4DBmMRQsc0bduGVZq8Cf4DZnSW?=
 =?us-ascii?Q?Qcinx0wu0T1jOGNewJOEXgzC8SOSOupOQxN8cCEnt1LnyZJ7Q63+BtGbvp1/?=
 =?us-ascii?Q?SwlEwmmgya1RzZsQzXx6M4bj2YpO2kEyW5qi+7e3iHcbO3PPADRa2hc6XASY?=
 =?us-ascii?Q?imgYzRpQ3ZWaanRzLhPl8+kh1PNFayr9bd3rx95kCAmgK/U62b+bFCgdwpcV?=
 =?us-ascii?Q?Y8AvE3d6lcEDxOf2gQRw6rD6acNV8RaXY8kXxyS4x1AGMlSn61o68wjsjkxh?=
 =?us-ascii?Q?Y0TCu/lgwty7kkFT8eOVMxiQefJ15RuwDgDK987XLqX3kRKyqCjs0zfKRv8v?=
 =?us-ascii?Q?JbaMCCtQebYkmMSiZS7fcbvmfnLxk3t6e/KSjsjuB10eNkx5RSS+qG0lYMdO?=
 =?us-ascii?Q?ennIEzTGvBUKuSikGuayN8HRp0vvorBrpVKOFeoxnEvIKPjDYfdkTBU1gkPb?=
 =?us-ascii?Q?w78knkEBQAbDKyDHnhewHDIoaQ1FsfHYHGMchJo4i54ttYbbS/FvIVe+omwv?=
 =?us-ascii?Q?eJT/jSQOis88oifDM/RUyEgbTFU0Bjbicqu2v13E50NMe/m1Z6iEao+NhBoL?=
 =?us-ascii?Q?6ycHuaOrCQj8CiqtO0u6EAwt2/Pvkc/ln/9IWRsm0TY6KZmySvbvK2M8Hqa+?=
 =?us-ascii?Q?SzUTJrIdSAGPNGhw9utF8LbiuGkUKlyKEI/V/Oa03wneNMzX1gMD1rsQ25Bz?=
 =?us-ascii?Q?7HQNv4V9HpVz78eJSWt6jmx5vAD823Om3v+fqvMN5S5Pawi9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9939266-a19c-41a2-de45-08df144d3811
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 23:49:59.7188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJDY6IifDo8vXL4AnDgfLY4f9AdS/jADlWJGglZ27RarDX+OM5hIYuI0uv3AMGfK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9787

Extract the entire MLX5_SET/GET macro family and their internal
helpers from device.h into a new lightweight header
(include/linux/mlx5/mlx5_ifc_macros.h).  device.h cannot be
included by the VFIO selftest because it pulls in rdma/ib_verbs.h;
the macros themselves depend only on endian helpers, BUILD_BUG_ON,
and basic C types.

The moved macros include the internal helpers (__mlx5_nullp through
__mlx5_st_sz_bits), all size/address macros (MLX5_ST_SZ_BYTES,
MLX5_BYTE_OFF, MLX5_ADDR_OF, etc.), the 32-bit accessors (MLX5_SET,
MLX5_GET, MLX5_SET_TO_ONES, MLX5_ARRAY_SET, MLX5_GET_PR), the
64-bit accessors (MLX5_SET64, MLX5_GET64, MLX5_ARRAY_SET64,
MLX5_GET64_PR), the 16-bit accessors (MLX5_GET16, MLX5_SET16), and
the big-endian getters (MLX5_GET64_BE, MLX5_GET_BE).

device.h includes the new header so existing kernel code is
unchanged.

Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/mlx5/device.h          | 117 +----------------------
 include/linux/mlx5/mlx5_ifc_macros.h | 133 +++++++++++++++++++++++++++
 2 files changed, 134 insertions(+), 116 deletions(-)
 create mode 100644 include/linux/mlx5/mlx5_ifc_macros.h

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 8646303b029de0..37727b5ab78f25 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -36,6 +36,7 @@
 #include <linux/types.h>
 #include <rdma/ib_verbs.h>
 #include <linux/mlx5/mlx5_ifc.h>
+#include <linux/mlx5/mlx5_ifc_macros.h>
 #include <linux/bitfield.h>
 
 #if defined(__LITTLE_ENDIAN)
@@ -46,122 +47,6 @@
 #error Host endianness not defined
 #endif
 
-/* helper macros */
-#define __mlx5_nullp(typ) ((struct mlx5_ifc_##typ##_bits *)0)
-#define __mlx5_bit_sz(typ, fld) sizeof(__mlx5_nullp(typ)->fld)
-#define __mlx5_bit_off(typ, fld) (offsetof(struct mlx5_ifc_##typ##_bits, fld))
-#define __mlx5_16_off(typ, fld) (__mlx5_bit_off(typ, fld) / 16)
-#define __mlx5_dw_off(typ, fld) (__mlx5_bit_off(typ, fld) / 32)
-#define __mlx5_64_off(typ, fld) (__mlx5_bit_off(typ, fld) / 64)
-#define __mlx5_16_bit_off(typ, fld) (16 - __mlx5_bit_sz(typ, fld) - (__mlx5_bit_off(typ, fld) & 0xf))
-#define __mlx5_dw_bit_off(typ, fld) (32 - __mlx5_bit_sz(typ, fld) - (__mlx5_bit_off(typ, fld) & 0x1f))
-#define __mlx5_mask(typ, fld) ((u32)((1ull << __mlx5_bit_sz(typ, fld)) - 1))
-#define __mlx5_dw_mask(typ, fld) (__mlx5_mask(typ, fld) << __mlx5_dw_bit_off(typ, fld))
-#define __mlx5_mask16(typ, fld) ((u16)((1ull << __mlx5_bit_sz(typ, fld)) - 1))
-#define __mlx5_16_mask(typ, fld) (__mlx5_mask16(typ, fld) << __mlx5_16_bit_off(typ, fld))
-#define __mlx5_st_sz_bits(typ) sizeof(struct mlx5_ifc_##typ##_bits)
-
-#define MLX5_FLD_SZ_BYTES(typ, fld) (__mlx5_bit_sz(typ, fld) / 8)
-#define MLX5_ST_SZ_BYTES(typ) (sizeof(struct mlx5_ifc_##typ##_bits) / 8)
-#define MLX5_ST_SZ_DW(typ) (sizeof(struct mlx5_ifc_##typ##_bits) / 32)
-#define MLX5_ST_SZ_QW(typ) (sizeof(struct mlx5_ifc_##typ##_bits) / 64)
-#define MLX5_UN_SZ_BYTES(typ) (sizeof(union mlx5_ifc_##typ##_bits) / 8)
-#define MLX5_UN_SZ_DW(typ) (sizeof(union mlx5_ifc_##typ##_bits) / 32)
-#define MLX5_BYTE_OFF(typ, fld) (__mlx5_bit_off(typ, fld) / 8)
-#define MLX5_ADDR_OF(typ, p, fld) ((void *)((u8 *)(p) + MLX5_BYTE_OFF(typ, fld)))
-
-/* insert a value to a struct */
-#define MLX5_SET(typ, p, fld, v) do { \
-	u32 _v = v; \
-	BUILD_BUG_ON(__mlx5_st_sz_bits(typ) % 32);             \
-	*((__be32 *)(p) + __mlx5_dw_off(typ, fld)) = \
-	cpu_to_be32((be32_to_cpu(*((__be32 *)(p) + __mlx5_dw_off(typ, fld))) & \
-		     (~__mlx5_dw_mask(typ, fld))) | (((_v) & __mlx5_mask(typ, fld)) \
-		     << __mlx5_dw_bit_off(typ, fld))); \
-} while (0)
-
-#define MLX5_ARRAY_SET(typ, p, fld, idx, v) do { \
-	BUILD_BUG_ON(__mlx5_bit_off(typ, fld) % 32); \
-	MLX5_SET(typ, p, fld[idx], v); \
-} while (0)
-
-#define MLX5_SET_TO_ONES(typ, p, fld) do { \
-	BUILD_BUG_ON(__mlx5_st_sz_bits(typ) % 32);             \
-	*((__be32 *)(p) + __mlx5_dw_off(typ, fld)) = \
-	cpu_to_be32((be32_to_cpu(*((__be32 *)(p) + __mlx5_dw_off(typ, fld))) & \
-		     (~__mlx5_dw_mask(typ, fld))) | ((__mlx5_mask(typ, fld)) \
-		     << __mlx5_dw_bit_off(typ, fld))); \
-} while (0)
-
-#define MLX5_GET(typ, p, fld) ((be32_to_cpu(*((__be32 *)(p) +\
-__mlx5_dw_off(typ, fld))) >> __mlx5_dw_bit_off(typ, fld)) & \
-__mlx5_mask(typ, fld))
-
-#define MLX5_GET_PR(typ, p, fld) ({ \
-	u32 ___t = MLX5_GET(typ, p, fld); \
-	pr_debug(#fld " = 0x%x\n", ___t); \
-	___t; \
-})
-
-#define __MLX5_SET64(typ, p, fld, v) do { \
-	BUILD_BUG_ON(__mlx5_bit_sz(typ, fld) != 64); \
-	*((__be64 *)(p) + __mlx5_64_off(typ, fld)) = cpu_to_be64(v); \
-} while (0)
-
-#define MLX5_SET64(typ, p, fld, v) do { \
-	BUILD_BUG_ON(__mlx5_bit_off(typ, fld) % 64); \
-	__MLX5_SET64(typ, p, fld, v); \
-} while (0)
-
-#define MLX5_ARRAY_SET64(typ, p, fld, idx, v) do { \
-	BUILD_BUG_ON(__mlx5_bit_off(typ, fld) % 64); \
-	__MLX5_SET64(typ, p, fld[idx], v); \
-} while (0)
-
-#define MLX5_GET64(typ, p, fld) be64_to_cpu(*((__be64 *)(p) + __mlx5_64_off(typ, fld)))
-
-#define MLX5_GET64_PR(typ, p, fld) ({ \
-	u64 ___t = MLX5_GET64(typ, p, fld); \
-	pr_debug(#fld " = 0x%llx\n", ___t); \
-	___t; \
-})
-
-#define MLX5_GET16(typ, p, fld) ((be16_to_cpu(*((__be16 *)(p) +\
-__mlx5_16_off(typ, fld))) >> __mlx5_16_bit_off(typ, fld)) & \
-__mlx5_mask16(typ, fld))
-
-#define MLX5_SET16(typ, p, fld, v) do { \
-	u16 _v = v; \
-	BUILD_BUG_ON(__mlx5_st_sz_bits(typ) % 16);             \
-	*((__be16 *)(p) + __mlx5_16_off(typ, fld)) = \
-	cpu_to_be16((be16_to_cpu(*((__be16 *)(p) + __mlx5_16_off(typ, fld))) & \
-		     (~__mlx5_16_mask(typ, fld))) | (((_v) & __mlx5_mask16(typ, fld)) \
-		     << __mlx5_16_bit_off(typ, fld))); \
-} while (0)
-
-/* Big endian getters */
-#define MLX5_GET64_BE(typ, p, fld) (*((__be64 *)(p) +\
-	__mlx5_64_off(typ, fld)))
-
-#define MLX5_GET_BE(type_t, typ, p, fld) ({				  \
-		type_t tmp;						  \
-		switch (sizeof(tmp)) {					  \
-		case sizeof(u8):					  \
-			tmp = (__force type_t)MLX5_GET(typ, p, fld);	  \
-			break;						  \
-		case sizeof(u16):					  \
-			tmp = (__force type_t)cpu_to_be16(MLX5_GET(typ, p, fld)); \
-			break;						  \
-		case sizeof(u32):					  \
-			tmp = (__force type_t)cpu_to_be32(MLX5_GET(typ, p, fld)); \
-			break;						  \
-		case sizeof(u64):					  \
-			tmp = (__force type_t)MLX5_GET64_BE(typ, p, fld); \
-			break;						  \
-			}						  \
-		tmp;							  \
-		})
-
 enum mlx5_inline_modes {
 	MLX5_INLINE_MODE_NONE,
 	MLX5_INLINE_MODE_L2,
diff --git a/include/linux/mlx5/mlx5_ifc_macros.h b/include/linux/mlx5/mlx5_ifc_macros.h
new file mode 100644
index 00000000000000..d357acfd351de2
--- /dev/null
+++ b/include/linux/mlx5/mlx5_ifc_macros.h
@@ -0,0 +1,133 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright (c) 2013-2026, Mellanox Technologies. All rights reserved.
+ *
+ * Accessor macros for mlx5 IFC structures.
+ *
+ * Extracted from device.h so that code which cannot include device.h
+ * (e.g. selftests) can still use the MLX5_SET/GET family directly.
+ */
+
+#ifndef MLX5_IFC_MACROS_H
+#define MLX5_IFC_MACROS_H
+
+/* Internal helpers -- 32-bit */
+#define __mlx5_nullp(typ) ((struct mlx5_ifc_##typ##_bits *)0)
+#define __mlx5_bit_sz(typ, fld) sizeof(__mlx5_nullp(typ)->fld)
+#define __mlx5_bit_off(typ, fld) (offsetof(struct mlx5_ifc_##typ##_bits, fld))
+#define __mlx5_16_off(typ, fld) (__mlx5_bit_off(typ, fld) / 16)
+#define __mlx5_dw_off(typ, fld) (__mlx5_bit_off(typ, fld) / 32)
+#define __mlx5_64_off(typ, fld) (__mlx5_bit_off(typ, fld) / 64)
+#define __mlx5_16_bit_off(typ, fld) (16 - __mlx5_bit_sz(typ, fld) - (__mlx5_bit_off(typ, fld) & 0xf))
+#define __mlx5_dw_bit_off(typ, fld) (32 - __mlx5_bit_sz(typ, fld) - (__mlx5_bit_off(typ, fld) & 0x1f))
+#define __mlx5_mask(typ, fld) ((u32)((1ull << __mlx5_bit_sz(typ, fld)) - 1))
+#define __mlx5_dw_mask(typ, fld) (__mlx5_mask(typ, fld) << __mlx5_dw_bit_off(typ, fld))
+#define __mlx5_mask16(typ, fld) ((u16)((1ull << __mlx5_bit_sz(typ, fld)) - 1))
+#define __mlx5_16_mask(typ, fld) (__mlx5_mask16(typ, fld) << __mlx5_16_bit_off(typ, fld))
+#define __mlx5_st_sz_bits(typ) sizeof(struct mlx5_ifc_##typ##_bits)
+
+/* Size and address macros */
+#define MLX5_FLD_SZ_BYTES(typ, fld) (__mlx5_bit_sz(typ, fld) / 8)
+#define MLX5_ST_SZ_BYTES(typ) (sizeof(struct mlx5_ifc_##typ##_bits) / 8)
+#define MLX5_ST_SZ_DW(typ) (sizeof(struct mlx5_ifc_##typ##_bits) / 32)
+#define MLX5_ST_SZ_QW(typ) (sizeof(struct mlx5_ifc_##typ##_bits) / 64)
+#define MLX5_UN_SZ_BYTES(typ) (sizeof(union mlx5_ifc_##typ##_bits) / 8)
+#define MLX5_UN_SZ_DW(typ) (sizeof(union mlx5_ifc_##typ##_bits) / 32)
+#define MLX5_BYTE_OFF(typ, fld) (__mlx5_bit_off(typ, fld) / 8)
+#define MLX5_ADDR_OF(typ, p, fld) ((void *)((u8 *)(p) + MLX5_BYTE_OFF(typ, fld)))
+
+/* insert a value to a struct */
+#define MLX5_SET(typ, p, fld, v) do { \
+	u32 _v = v; \
+	BUILD_BUG_ON(__mlx5_st_sz_bits(typ) % 32);             \
+	*((__be32 *)(p) + __mlx5_dw_off(typ, fld)) = \
+	cpu_to_be32((be32_to_cpu(*((__be32 *)(p) + __mlx5_dw_off(typ, fld))) & \
+		     (~__mlx5_dw_mask(typ, fld))) | (((_v) & __mlx5_mask(typ, fld)) \
+		     << __mlx5_dw_bit_off(typ, fld))); \
+} while (0)
+
+#define MLX5_ARRAY_SET(typ, p, fld, idx, v) do { \
+	BUILD_BUG_ON(__mlx5_bit_off(typ, fld) % 32); \
+	MLX5_SET(typ, p, fld[idx], v); \
+} while (0)
+
+#define MLX5_SET_TO_ONES(typ, p, fld) do { \
+	BUILD_BUG_ON(__mlx5_st_sz_bits(typ) % 32);             \
+	*((__be32 *)(p) + __mlx5_dw_off(typ, fld)) = \
+	cpu_to_be32((be32_to_cpu(*((__be32 *)(p) + __mlx5_dw_off(typ, fld))) & \
+		     (~__mlx5_dw_mask(typ, fld))) | ((__mlx5_mask(typ, fld)) \
+		     << __mlx5_dw_bit_off(typ, fld))); \
+} while (0)
+
+#define MLX5_GET(typ, p, fld) ((be32_to_cpu(*((__be32 *)(p) +\
+__mlx5_dw_off(typ, fld))) >> __mlx5_dw_bit_off(typ, fld)) & \
+__mlx5_mask(typ, fld))
+
+#define MLX5_GET_PR(typ, p, fld) ({ \
+	u32 ___t = MLX5_GET(typ, p, fld); \
+	pr_debug(#fld " = 0x%x\n", ___t); \
+	___t; \
+})
+
+/* 64-bit field accessors */
+#define __MLX5_SET64(typ, p, fld, v) do { \
+	BUILD_BUG_ON(__mlx5_bit_sz(typ, fld) != 64); \
+	*((__be64 *)(p) + __mlx5_64_off(typ, fld)) = cpu_to_be64(v); \
+} while (0)
+
+#define MLX5_SET64(typ, p, fld, v) do { \
+	BUILD_BUG_ON(__mlx5_bit_off(typ, fld) % 64); \
+	__MLX5_SET64(typ, p, fld, v); \
+} while (0)
+
+#define MLX5_ARRAY_SET64(typ, p, fld, idx, v) do { \
+	BUILD_BUG_ON(__mlx5_bit_off(typ, fld) % 64); \
+	__MLX5_SET64(typ, p, fld[idx], v); \
+} while (0)
+
+#define MLX5_GET64(typ, p, fld) be64_to_cpu(*((__be64 *)(p) + __mlx5_64_off(typ, fld)))
+
+#define MLX5_GET64_PR(typ, p, fld) ({ \
+	u64 ___t = MLX5_GET64(typ, p, fld); \
+	pr_debug(#fld " = 0x%llx\n", ___t); \
+	___t; \
+})
+
+/* 16-bit field accessors */
+#define MLX5_GET16(typ, p, fld) ((be16_to_cpu(*((__be16 *)(p) +\
+__mlx5_16_off(typ, fld))) >> __mlx5_16_bit_off(typ, fld)) & \
+__mlx5_mask16(typ, fld))
+
+#define MLX5_SET16(typ, p, fld, v) do { \
+	u16 _v = v; \
+	BUILD_BUG_ON(__mlx5_st_sz_bits(typ) % 16);             \
+	*((__be16 *)(p) + __mlx5_16_off(typ, fld)) = \
+	cpu_to_be16((be16_to_cpu(*((__be16 *)(p) + __mlx5_16_off(typ, fld))) & \
+		     (~__mlx5_16_mask(typ, fld))) | (((_v) & __mlx5_mask16(typ, fld)) \
+		     << __mlx5_16_bit_off(typ, fld))); \
+} while (0)
+
+/* Big endian getters */
+#define MLX5_GET64_BE(typ, p, fld) (*((__be64 *)(p) +\
+	__mlx5_64_off(typ, fld)))
+
+#define MLX5_GET_BE(type_t, typ, p, fld) ({				  \
+		type_t tmp;						  \
+		switch (sizeof(tmp)) {					  \
+		case sizeof(u8):					  \
+			tmp = (__force type_t)MLX5_GET(typ, p, fld);	  \
+			break;						  \
+		case sizeof(u16):					  \
+			tmp = (__force type_t)cpu_to_be16(MLX5_GET(typ, p, fld)); \
+			break;						  \
+		case sizeof(u32):					  \
+			tmp = (__force type_t)cpu_to_be32(MLX5_GET(typ, p, fld)); \
+			break;						  \
+		case sizeof(u64):					  \
+			tmp = (__force type_t)MLX5_GET64_BE(typ, p, fld); \
+			break;						  \
+			}						  \
+		tmp;							  \
+		})
+
+#endif /* MLX5_IFC_MACROS_H */
-- 
2.43.0

