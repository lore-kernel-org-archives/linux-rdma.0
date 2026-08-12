Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFE046EC7F;
	Wed, 12 Aug 2026 14:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786546779; cv=fail; b=DbFuERhQgIalOCeQGy8EfjhVOL4lyxtX9qQDdbc940NuXX7N9b2MR7aGwXd96eLmPNh+EnT2VhNx+y7oaENGjtr+A9X/cNxM6kuie1KCghY/XW+rIcG3FqlxREEd8JyN4bSKyn9FsTfAWncchiu5yDzU18cfdzL5voXXOFsez08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786546779; c=relaxed/simple;
	bh=E8Y22OXWk/W9Z4t/wVjnLmHo2kV3n0qBr44bEXVNQak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=twYM6zTiMrbyNOzqd8zEH1hKsPRV4E/ho5jdWgNfeZ7QavSf499jLaaeFiSTpeqQ9JEPRVS3l5iFS10U9Ci/tYTPE2334LrpWYNUgbK6ot4EyoWCiPXuhRcPyr87ZQMfPrqsJpx6KWRMt4ZaIHwXaEco8xikJLvyzR8iaDzidwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IrUNgFtU; arc=fail smtp.client-ip=52.101.48.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IrUNgFtU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=upOoDdvG6XzGQvLnyKmfmNfzwlLcWS4fi6peSz+h4Q9TvnjKhNEZ4E4GFKmr/9nUMToFbtIPDE1jowdXhWiY/h7Iz7Cha1JmTR9IWaYJS9JL8rQUjeXOwk/pOnFgpizA203kJFdLSNxT0eobUyml5L6QJ+fGpuOMAFTBQZxCqfGi4Dj3keFAyVVOAIh8lc3Fo1O8Tqi6L9YISALBHc43YljutggFGq4Rxy5KjslFbnGc+cHGcLtYcy0kVU5N+vU09DLQ7671dby8K/uFwXlvEp4+telrfw75IXTgX3c3SM5N+kN3qF6QQ8MsQihZBu+y29BnHHROACORK+ExTlhRTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BgNR8JKn3caYPqzLozD+4F7DAdvQW4I7IRDZEnhYpIo=;
 b=GpNKG0C1ohWBVJ7ow9ROb8tnGdpW5cKwbtze/P1NmvplfbCl1s5NU/UsPzCD18WzRmhJCo9pvgZ0sNIgpEyLhs6arBoBxoRpR0rPRJnqxYeht/gzbH7e7bz7hdCJ0iY45hlPBe2gEWph4G9mUv1mrmGcf4QHQ9AtLSLGOgiPUF6te6x3nraYNwtknZvpI2TWX3Vq7XdSitfKcEJSWkrtpDzbeRcOL6mvI/c8BSCdmHO25pL2am1NpoYhfjbTifobx96oVeqQE7B0/UovrtoDmFylIrDKBp6grIhtG1RWsNVfaZpRaEAmnT/1zsrHAHhUg7v+6naNofDUXJtbUTxY7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgNR8JKn3caYPqzLozD+4F7DAdvQW4I7IRDZEnhYpIo=;
 b=IrUNgFtU3lswxdGtxXWmHfbXYBxArTVRhj7g6fShcTFeqI5kw+WLvF5uHSQtXSQVeP52DVO+cNjDqqqptb5texHty30RTsK3r14QpJL3H3TtESMTNP9Bst17G+cFYXsUwjX5LLywEPLHhEA+3CwHJYduRcSa/eDSwc53g51NKIWdBnmiBvb5W0ne5t4CnGoe32DXTK/tTVCZOJ0pE+6qCmbSXTvbCzPaSoQHGCRQSpaU/VUvyG49HoO9kWwRBezsCfpDLoFIHmkna4zpblHbz5HhghAsbhScY2uEFxk8VmwnFUwH1LtonJeQF70y48tLzRZiesm8KAqnIW1A8xIEMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9654.namprd12.prod.outlook.com (2603:10b6:930:ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Wed, 12 Aug
 2026 14:59:14 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 14:59:14 +0000
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
Subject: [PATCH v4 03/10] net/mlx5: Extract MLX5_SET/GET macros into mlx5_ifc_macros.h
Date: Wed, 12 Aug 2026 11:59:01 -0300
Message-ID: <3-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0164.namprd03.prod.outlook.com
 (2603:10b6:408:f4::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9654:EE_
X-MS-Office365-Filtering-Correlation-Id: d3b4c718-83b5-4711-d07a-08def8824462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|11063799006|10067099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	Qz8Fn3n4m2oCbAPmzBw9cL7rW7UnGgiu7uZZMTEtw0+9WxCUmzi2iNcc4sEj1U6lUiM7CT6OQzJv3my1wj9p3ce3IPtjCLJVsk9f0Ix/DJpR6Xh4LB/KnDVNVfj6UbW0ZO5VHESeVbcQeJd6hOvc+8VkmNqvvX08teQr3fetRq6B96GIEoYqKXZLMfV+oMsiykFY805qbwAKVlqmfgvelVFhjQbESrZrdDj404QOqUmM/lBiHE/LGlP2+ojCYDMrH/+PikQ+L1pGM51mVL3pAN+k5W7zOccqv/fJIgIr6DaevQ8pFjh0u2W9EnHOluQCp38nlIRWW8Wxv//flrkpLzMFdcHFgkHRK873idGYr933IMZ47Q+ZxOAtYZArUTZz0CXPjXaIcj/6/MslWBO1xR8Ax8x2LZk+wNngWYEL7+VA30fNL4cZiPWJFilV1jmtWpNwFUCgIzwgd5MuUan8MVSCGjV6dA+p44Z23QIN1XXsXv7yCy2yNn/FMyrx8B9eD0NtubQjJDr1+PQzrm1aGBzW5qemW5+/8aQ6c/c22VjUAI2sHxv+zqDJmC+Pcun70FYFe1GKZxgzCu82v/TsZ4E1YPoWJhLWwSB5LG67IeluXesOr4MCqvlIAc/5B+tAjQM4Cq84RJk5yqcstxxZ9GgKsac1KTMFDLkYmrxQGgjKwWUlB+h5q4s+WzA2PZgw/8Kkj3K8UD8s9EGiQWbH9A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OBD/6NUHc/BnEveJRkP3x7ryM0YvQWSHho0UM8DcIXBmssnaOFSgOviabeyl?=
 =?us-ascii?Q?/MSRIUczLWYnpAcX4bUk9U6Mtm1e/9qFb9RLrFCkUq2EatJovoXXgnaJBDSb?=
 =?us-ascii?Q?mcre0HZgUdn0AbAA2F7buHP0JU2VlJz/syTDeLlzHyrIYQYDRrU2VBwRJvVK?=
 =?us-ascii?Q?q8/kBU2jIah654IDfQywr3OCGVzis/e2RdkN3JMC6NywzHggseK9YpcCZL43?=
 =?us-ascii?Q?mAS1Ru4cQkV63BBfMk6lC5wKiPWRq4YbfRTq/GiBfX+rppKUb6FKRZFL01PG?=
 =?us-ascii?Q?D4jEXlGMVBDjZzDwvydOqOd1pw3BiExxIT+ETfE2qZ5NrKxObrJFnE/P57SN?=
 =?us-ascii?Q?iWYs4oHnxxdU9Nu7VZz/1XSpPuCEVQXwI0pvDZgzJYkc5Ac8Ufk95LaS8EyL?=
 =?us-ascii?Q?GxRY2uwmFVXgwScvSFidf2RQbBuyQveBPzXwpGM7X74eevbr5ct3NDLeHmmc?=
 =?us-ascii?Q?p+H5Nlc+hQs+MN9tYHa7WDN1WpbAtGPjrZVRvRtzieDAv8G19lnaWGi2zo0H?=
 =?us-ascii?Q?A7mEALKgpvGpBnxkBXg0l1a4GZ++mCmTiX317dT3kVcymvzerSDiEs0qXWeU?=
 =?us-ascii?Q?Mp2qDZvJskIF0aOmFEBniNd0VzB24nzyVcccfa0cejDJVX26Amg+gR2qG6/U?=
 =?us-ascii?Q?viq18O2sDMJG06sA5/Wdm+NV4LkIrlNv1gMrJhiLkqzn8rQIUOMN39yqAb3X?=
 =?us-ascii?Q?MP8UMk8bLJL71rA/P9crU1djAm3/9RU4J/hPf3huGa9QB+WgdaiQCe3uY9A3?=
 =?us-ascii?Q?ExcZtey1b//Jll/JppNpPqs6HChEs4mUnXCi/kjElw1wYDDMTxqWfsjB2iBN?=
 =?us-ascii?Q?kMc3VP7CjFFCXEIRkWhJOrxBML7+6CsueXbzou+js3eMh/5Odmz/Tmc5rxSj?=
 =?us-ascii?Q?UR/ubgL1HsrOnu+iANO5uYPInH7GxmV9T0J7vV2c4nAqhK+N2FriEGtxiBRH?=
 =?us-ascii?Q?o5nzfL/gQdaLOizOAPIACB/884H/rt+qql+Nf67CpUZ/V3Y2QlEYFLlcpvfQ?=
 =?us-ascii?Q?+TkknBQFsYogU+mHo4Ox4mhvrGyO7k+IDf5DPH8YJ2BAaRLLfdPWEvacg8B2?=
 =?us-ascii?Q?z9YxAHV+k5kw9udyN1AKwvaHywsdLVkhSGhFWg1dRJM7Dj7qY4dFMG2jj7X2?=
 =?us-ascii?Q?YLp799K7cw601fqsH8lLrDKiaGKmHg3UefvAI2FGBRRRFYvJmGPGP1kbEj7f?=
 =?us-ascii?Q?eVm0MKotxtEpWL1xwhzi6HXe+CcNHMig/f0nSoWN6+44/HkcDqEoVDMZqQ0F?=
 =?us-ascii?Q?Ruiuv+qB0Z5a9ajOc8hZOg8TdtW4Ru/JBMOWHlE1TCKKBqacLpmL5B7ZfKXs?=
 =?us-ascii?Q?HoVy5C9eAvd76kbILMsMxjCwoEBQcBYbKj6FWzDcfu/qTgvz3SIHot0q+8L5?=
 =?us-ascii?Q?UBEZpZTR7iAozeYxHYW+2V0A+uqp/Ibhvwua2qYGHs3bnEEAt1MAf+zBrS6K?=
 =?us-ascii?Q?/1bgjmj34qRAH6jm5tbg7JHhmkQ24EDPzINGwPPJ0Te3p8EOcqof8UC2UTRu?=
 =?us-ascii?Q?3XEcahYzBchcov/5Hs7JnaWPkSH1jt9X9RjNjgCCXNtYf5Wz2F08Y0wH9Kin?=
 =?us-ascii?Q?3bK3E0uFMbVexj1mX1hB2fz6+lR7v/Fk/vLfoF21l0uM26mbLc0WeQHIluKj?=
 =?us-ascii?Q?iDDtG4/SSV+ewvzU1mWCtMxnHYpBOQdbxqWbVurkfFYrdSy6vLO0btiGTZWW?=
 =?us-ascii?Q?mwYwrU3y2D2xeO6ruXVQFyKah/k1T/qHhcclxGscGKLl1uprHc+UFUgvM+mT?=
 =?us-ascii?Q?u8IgOWeMVA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3b4c718-83b5-4711-d07a-08def8824462
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 14:59:11.2466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s6ZaVJbnPtCyKkCRZlmOQjN73uGM1tq5oYSFsQ5ZDgmvL433gi1VSgDv0qupHc84
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9654

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
index c739a1f578dc44..2de2640d830bd6 100644
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

