Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010052.outbound.protection.outlook.com [52.101.201.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A83452ED5D;
	Wed,  9 Sep 2026 23:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788998280; cv=fail; b=MoZ+UvuVAQh3pQuVT9yEcZ+p86E07VYM5g5qyrzaICv7fO9Jj2RluwMSZOISv5RtgTSd6Kcrirh32eRH+4A7Hqyv1s3rW4Y84ZQr4zUp9sQ4oNFHFvKMBSrXHX0zuGbadc9PBd1Og9qmbyf5molAAQhJ0kJd41JYEptW8ICMSRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788998280; c=relaxed/simple;
	bh=kKy+IqKAL9NkdwMsK/wc6XuAGGswAQ4xv6CzmeoLDR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E2En8oBfh69K1NUkJfFmfpdX+ysRam6LLERmHNPnqNF6vlwGcy7dcNZjWBwZGFm3u23hPxpg5Ix7HsXJUXCu7Z+wBrWCeeSWRefYscoOrVKoC9lpalk2VlDtG6/sFt0LgDZ6gRqDtZBUlm7JOacmneNzi57Q+/EVpZOPUWySeog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pp8pMDsS; arc=fail smtp.client-ip=52.101.201.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pp8pMDsS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OzEIWLXEj8H8VWnKRI3lFk//Upd/pEKXUSHAnZTccvdp3hm4xiNThJK66Pz2a7rU9TdcdWO5FPnJK/k82RCW0hk9CGJw1FJ+K69WjopXMSH1v/lZwirBuNPYiyGT0/vKuM7pvcS/OYEsOFL7r5MbLN6guJXuii+Gs9PlL3j0vnipqzII4PNPvT87oSDIwKGoLnQrmPQ/azLYaUVoOeua1/5JjBYfAU4Z1ZxtqNx4+YrOMeJMp5p8L3m+TTiKMo0f+/aP9ChaCdN/aXtNBYx+3jsF2dOETFIV7N5RbLTbTpl/3t5vhq7luljhFDw6C03N2lbxD9dEGstqK0QXRGoePg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/KbU5x46LhEyhl5GFWFr2rmIxkoZnDsntlJ2PWkl7hM=;
 b=GkKExsw8/FwL1eWMoS5f4kyAIRVPDTfvrvtXJoib6xahix3l57xE77WnQ+dl/PuVZJbfk423z1JQlnk5w3WHyQ8c1lqGKu9GF/T5UoLbpHZV5ps+RMMXj9eTzm4YikMdxq7JRWVojIViDx1VgMsB5Baloy2EmW/V92bvxgNX6MYzVMQTRwHbIIBXISnsmQNQFNeNNrynlA8JZNlxqFIiHV7JlL1eESSSJk+C7MI+6jK3MyVuWmt4B+sdu/HU9PkyNR7QbENFx6oWhzXGM0di4FqeBQjRd/yXRJpGaiuak7Q+CJuvfICNQkYca0sPWfxr94i4MStqrJtexVCTnDLhbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/KbU5x46LhEyhl5GFWFr2rmIxkoZnDsntlJ2PWkl7hM=;
 b=pp8pMDsSu1U3qdBBUUvA9wZBvMnjArB6ypo/iOM/uPCDE6BVsvqe+atqbUfCrACbQjDdewbYvSeXZkQ5li/uPvjedcv8S8JVXXuHaCHGZsZCc+KdKFFJFwAYHpCNrCkNmJzV1sZ1w95rnr0E6phDEElF8uKyn1NFzk7CuJ75030dZHq0fQ/AuDJagYEDoNLJh4tyHgOfRJ3LdS+qJd9TsvuiHA60dEDlMjHUzQuXEKD4STBYluwSs45ozLUAqwrJwxEyX8/oscxVuTKuevlbPl2JIuNZ548wZHn4QF7NLgFasrzja3IPca0Y0nN70f/fkN4Q2fHuUqasa7UT5IN8+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV3PR12MB9440.namprd12.prod.outlook.com (2603:10b6:408:215::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.14; Wed, 9 Sep
 2026 23:57:48 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 23:57:47 +0000
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
Subject: [PATCH v5 03/10] net/mlx5: Extract MLX5_SET/GET macros into mlx5_ifc_macros.h
Date: Wed,  9 Sep 2026 20:57:29 -0300
Message-ID: <3-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0085.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|LV3PR12MB9440:EE_
X-MS-Office365-Filtering-Correlation-Id: 96e6f43d-b1cb-4a73-e1d9-08df0ece2191
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|921020|10067099003|11063799006|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	4ZNE3lvSAi7UDOsvSFJFVSLAVrNDEAFCKs9MJtAewkELQDy95OsPoGKPT0CNr5SzBvKI6aEX6/jc+1SQCIPMnKuS/ofTsdT8rp6CwNeb9wvk0/LoiS7O0lXTyVHX6j9SdVzNJiwkJ1bmRk4bAWPgAYXdUEymHnJsjuXIF0ix1MJdC3RzHNzlFxwmA76Qd8QEuUu72ttGPQ0zC5MYXShx24n5E9UQqqycJaE/C9FNjFG3h6vTszomHLDn/07yjppCCs4zpc2uCKsMxA86tUVZkpj+HEn6YZ3Iey+tSBYyl1QT3q3LVz2bAWVUQ6z8YcQLBM9wC3PebQWptUX4ANUkIYkiRTAzjSzr1OQsp/+bHrVxXiqLykotqkdw6HpKmE/DIDTWfYop9q0XKVpsyRMXEx8bYcsqb/zOXWPCJRxEMj+Ho1mrhaatlrWeevH8O9b9sFfTiq646UFyhVW9Xbwun+vzY/1xAzemcFxriTLnsjR//mskpSTufh2a+uWwmJ0fLTxlSvr5IVYF2eR+YnsP9Z2cKTr5gbV268ahfZ3JA31NhZBDhVSATuCKAto0hvfpqhrFP3OxVlKC8fNLJJOlXabSSqzGq/e6YWhNrBzXDeSSoNCVVNAkD+SXgd03IPsdpSkZ3ngwQDiQwyxvMuoXiIEWb1cFrwDfghspL+ZcggYg6z3K6X1ew1tAsDuRbMwbvLaOx5I/vpJVvyzLhGeInA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(921020)(10067099003)(11063799006)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Vqh51kWd+Do9G+RZlHVQ+j6QTGp636ebJmErbAwLl2R+SWXWTs+v+b5Y1Jk7?=
 =?us-ascii?Q?iM0dSQQC9THApRf8M9UFg/4CwzMpEmwr5IaHUNr1tVfKsO5jt7otLSTGRZHD?=
 =?us-ascii?Q?vhXax2i7bBvjNXX6WB8MG6sluKIcBkDzA4hxxWg9iOwub543k2hVCOLFNZI+?=
 =?us-ascii?Q?q7r/Fvu2D/GZRFz/OpIXuVDxbBT5/1eGOjNk+seDjLM+VhXoQ+dh9jAAPpUl?=
 =?us-ascii?Q?aIyJ4tI1G2dPNzsK0+zhh9CMYIyCEShbVXNcYHG4Ld4gh3d2rjfhbaHNLJMI?=
 =?us-ascii?Q?wjkh0qJJIKPjp51Lw7JbfHz6zMlWA6lCESaFKvONqzvjdCN6czKofD7nQ4HZ?=
 =?us-ascii?Q?Gb4FLueuUukskw7lSKm1kURDjFtmiK6RDDvfoCLlJ8U2xGRFFZsDIij7pq6r?=
 =?us-ascii?Q?E62QJ5S25tqeQvV8LguWrP87hgiamvPVFVrvQj41dDKUNIV15bS+opSQB8Nh?=
 =?us-ascii?Q?s9nV6SyCst5aoLhpnQ0cuaroQJYanGDeIHGmacwxofUtS1ObtTjSyX25UfZ7?=
 =?us-ascii?Q?mvrn1InDgUmiivqhB6QjQawVSqtG0f5ZMHUSpTB9ZeRp399G4Y3p2t0AkgRF?=
 =?us-ascii?Q?17YyJcqJ0ZR9qpVPjqm5a0dsiwk5mJ0PCiTqkGfZU70xTi0fLC5ORbYRk5lA?=
 =?us-ascii?Q?JnFEYb7hJJyqHKAk6mCa3OAAM9ElyhC1G2lyXybBOEqe/tmYVqbWeaCnhfxH?=
 =?us-ascii?Q?hfJ3wLNhXpzJSAjgqeVy+wwjlLXi4wynhPADvakTvxfxzJiFyLphwLatzK2d?=
 =?us-ascii?Q?PieXUsG0wUPVKvCwp78zPmLekA+qbXSSWNZm76U9qdGBCH2g9OfcvlZpzsFL?=
 =?us-ascii?Q?VbZa+CoHkrIt6FcEaO0Kqn+Zn/i9lIRXpuXthvbGz8BhkNKLP25um3TnsdpH?=
 =?us-ascii?Q?ZaTFTREs+U+t8Br1ahWoRKJ2jiOSc62Jm6dNqstaOwI76KfTS4W4z8JA0L9o?=
 =?us-ascii?Q?X+nxgi5sNk0pu2pTTNnVsGZjWB2H3LF+coIXVHVmVT4HKl1iJ3UPGy9NTyOM?=
 =?us-ascii?Q?wdNBIZtBdNyEbOwLv+KPi8q4+Jh3YSq4Hri0P2bQfRG3HW+5QxbeicW0tZDI?=
 =?us-ascii?Q?NOvrKXZQffmVvh0AAglXI9EGYAVOLBp3WIRgSyHJTUCZwdd07smHo/N+Q/WQ?=
 =?us-ascii?Q?IrvW/UPZhplXHrk3K5b6OD8dA5k79ChTIndV7pxaJmROSRIhRRXD0sYzqQ+E?=
 =?us-ascii?Q?ZXpub37XBnjjOV3lD9NoplPWxFI2dkWDMfKBMIbEIWCVH16rvl5u9hci4S7S?=
 =?us-ascii?Q?LtFzFD/L8tS6eFjHh/yyQsxA4B1oQW+WSFPRrS5/JAqngdM3/cCQpmqI5PVB?=
 =?us-ascii?Q?Md05Yo7CzZ9HyKoHbqeDECOnsSKbI/u7ytCds0jRdPO0fm16Trxc2SWVy6l2?=
 =?us-ascii?Q?0sv75j5UeP80MjHjkdv/jjszSamw72OLvXiuaOcs9AdFD9lqE2fe3FyBGxZF?=
 =?us-ascii?Q?VcQKuziSQVS3hMUFD1HoO6PPCAHgYp0jtCc+2ZyHWzFDTtEk4I89iDHrlwye?=
 =?us-ascii?Q?+M3AJsjaVvyZawPf93y5zDyBVRxqXeSic9YC2HdpTgPMCgSH8geKVinShEXH?=
 =?us-ascii?Q?BiP4IDEAd3WoU7Q63NJgdSF0Ip16FSL+TTOF1lHu8bYdNb7KoSSDHdPL+6bt?=
 =?us-ascii?Q?fJSRfICsQhSRZAlapOnTa58mEnU//aOuFBp96/mHDGbqOsceKd75whGVgv0n?=
 =?us-ascii?Q?hNQf+lKWuAfafsdG31MyNAHphYe3r91WQY0TyOOtvRanQl5S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96e6f43d-b1cb-4a73-e1d9-08df0ece2191
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 23:57:40.2350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jWsWJqNI+w9ERb4vueZILqa7YUXoUDw5E0EKAxOJW3Skht6XOEKHN+8Vf1ePQknK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9440

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

