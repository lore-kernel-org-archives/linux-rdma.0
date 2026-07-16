Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012037.outbound.protection.outlook.com [40.93.195.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5F043C7DA;
	Thu, 16 Jul 2026 17:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784221430; cv=fail; b=sIR1I0tKc4BZki++O/hUhI2VXQ5ynDKX+/K8de9uvW4hsiL1K7LHK4WaCOAvfj0MSuTg8fj1JrTjofntwirSFuH4N441vEgR1ZBXrwUrNe+Mzm056zAUMP04OfIJDEBIz4rGVNOqvixYVvsXv/x4M97R/Qiso5QdNP9rpITiy44=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784221430; c=relaxed/simple;
	bh=E8Y22OXWk/W9Z4t/wVjnLmHo2kV3n0qBr44bEXVNQak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CO0FKSccskG52LOzXCppznayIPOoLaoMQnefiLWSDeLQUiJQgTXWCKu2akWjLZEkuFZgs62GKxnQTt0jsh1tqledhMBLfHEGarm8ITgvdl4OV20rtEOTQStic+wuxL1pKMBi7FWlfGDjhMsZEAFz4I6qmJOPadTg+trARqwNkbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TResHLtG; arc=fail smtp.client-ip=40.93.195.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TResHLtG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XrLaDDVX1R/WQG0yMt22FaqQ4swSIv69rrW9ouZJAhLJZuJsG+BrV+ur/wgXI118rNANJqTHjiXrfag8bwt5/eriwsvXNJxNU8Uc1mUy36xnpNpZB1c10KIdREV8xtvft5Gvaz3OEYwi0JIz2t+xomHhO/Fm5Kw6E6+10XHLWO3hLitPTlUocElHpRDmhXkRaCOcehQ99X6tAeJhm2YNuZsoMRaL1Dy5HbtkFVJnzyuoH8c3dVDZmMZ7Qwp12Tu3JpCVA/xLtX8hqaP1LucSU1iQ+gfHBpJapIGbSGc0iQM3v7/yGekdghj9jDjVjVFNU4bvOG/tUHP34UsNksMbbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BgNR8JKn3caYPqzLozD+4F7DAdvQW4I7IRDZEnhYpIo=;
 b=W1y4PcnoNPWyAvVt2UglF4shQmqu+0NKXyE5QvNgkwn0cHHqF0K2vL3If9zqh5C0Xohc8FjyH1iQnszlm9/wWn29roIpE0pBkv3vsmVGZJDUs5wwYtTGCWdxAZwxsEOaL/Uv1TRIJqZ03Q2/dr8qOg/JLJDz07Ag0QnqgxDcb38RFoCqApj/huWQpOcfwZywO3kZEenvkO/Ixq6wVrAilO8vxrhmWidw7V8boDXeS+adzTNIRuLGiNpKT7ornufKd0iVuxLE9sA8umB37FGRYBTKGW9clCAtD8wJv6xllxh8NEbN4dlPtLXdt27hWZdqrgerXbEQvrt2tFVDFNUJnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgNR8JKn3caYPqzLozD+4F7DAdvQW4I7IRDZEnhYpIo=;
 b=TResHLtGefd2Wolf7i8nHHRqzZUS92Fjh/5yeetE1+o7nEB4KwN/2BzfcIaY5N+64yR5olt79RiWhX5uDjf9HNjOSLv4MEOuQrlCdbqngVClxmVFpkrlmNSSV+Rf0i/J1S1S1F35MLbE4k5+2qtxt7k7ObYyvzTd91f2S1YqDYoNHIw7Fn69BNpFumWXx/cjudhTJ4QZ0Yq4DxVyhO5nQQce0y6iMLh7v8i3IbE+kpF/HVIPRfs5ffvCtyuijblpAKoKCfv+EauukNhMAr0qRKoHQr5DKUROprnZTQ3Aba9rHd0pQg9bb+w5t0KO/V3HzY8UygSEYWzkYq05hINi4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB6216.namprd12.prod.outlook.com (2603:10b6:8:94::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.12; Thu, 16 Jul 2026 17:03:33 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Thu, 16 Jul 2026
 17:03:33 +0000
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
Subject: [PATCH v3 03/11] net/mlx5: Extract MLX5_SET/GET macros into mlx5_ifc_macros.h
Date: Thu, 16 Jul 2026 14:03:19 -0300
Message-ID: <3-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0102.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::21) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: a1aa73df-b999-47c4-dccc-08dee35c29c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|11063799006|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	zJ7Sy7brFmn0oXY9opN6uNGUBBtcqM4c8Q3k40Ncn9TounGqZEW5cq27shiZfTYfg5Zip7YDUaO8nl791c063lZTACq7wL8LXJ5vlmiyFQBfHFbtv3HG3Mb36x25N1j9T7uqTtF3iGqCeWwDrmn92dTyXYfIgms+7qkL5qrwi1U71fo+Ol1dQinforhwC6gVH1SG4eYWwJ5iKpuGSLrxbuNbGQL5O5ewCM3a485pEhzJ+bbs84lh3OHT+PQWmMMdpQU6rr6Q2dTOjVd/qPcU2haF3KUP+r2DWAUw3VE6EbtoltEXT7JhgWcQJxdtXKc6zGrFfl66iRX5H+0yYX8ovClvfX9J/gvZo6RHox+5XQdYowCPM4d+WP8pMBpS0R3/gCkjAPjiTmWiZQnYqIuNe8vysyEzsbuAv1entviprNUGhnDerhJYQyNe1K2JowQse7OM/GZTRY/RXa4xTCmsJkidwZ680plqg54wIpKSczm4CchXBHMXIEW2NpdU5o/vX4RmvbOme0f890mUca8eMDLHr7L5vOG4gQn1rixxlopLGTSnhE3cqUJ+m5u6oTW2UlNKQXt+bPIsHiLCR4Fre8SElqUqXqgcSFyl5j/RfOYvHak9JPEmdWGY//vTjEc1/QEkb9rcJMJwh2ttNSzRuVlAHeXWnMOEJLNzP1LlquirtmH3CIHPg0g0NMBze1fJySMmR3SB9i0Vq5sr37IZHw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XJ65KjQQj4Jh4GGkL+FtmdSIpTVYzRm1JcAQ9EIhV8KecliggVaxPE9OBIUw?=
 =?us-ascii?Q?YqBb/4tcH+qesxVjTm/oDOPPRaHecmqtK9g1XsPVrfhb2k1WUXpE23s0KBOz?=
 =?us-ascii?Q?DIzdB266uS4n9K39AWnrWPQIgKABpvq+bql8WKyUylEhvhsbohbxsYBZcpel?=
 =?us-ascii?Q?2F3ncSEVsFW3oQbgodsh2pQhrX80NfvzdWq/XoSaMpZwCLT8gJxHTJSB3eNf?=
 =?us-ascii?Q?XifHCKM4g63E4HJsVEByNK+RHXaBu/7IQStpLcq37yEk27zowwzQnNF3coNA?=
 =?us-ascii?Q?nVXEb1j4FsulQhsOOpwTWZ4iSINwuc3qUBhSAPkliWt9ITR6nO/HTVL6IGlM?=
 =?us-ascii?Q?0Xn2eRcw2jR/AQfgrWmL2Q8PeDHGkLuYMc90GfYVWR22MVYjnWoXM/HAObBO?=
 =?us-ascii?Q?CiOwFu53xS/cKCX3rpSPqbSzZdaG02hgY2tzdOfzrh0F/FR2ghAaIxqt4SfO?=
 =?us-ascii?Q?vhwaufVLvUm46kEYF1DnAYa3los+wjnmHJPtCTph6M/yfrZhUnnCrexPY2h8?=
 =?us-ascii?Q?bwMc5QveHPihxaAK31Tw7EdMG3EXPQB40AA/UuZUUkRIAntVOI5ZLipCmg3x?=
 =?us-ascii?Q?7giP56Atm+1LbFIb1984F6spE00XZoYWSl5Ej/XJca3107hL3nq/A/w87Z4V?=
 =?us-ascii?Q?z9Ji1xHwmS+rbQfHFgQcNDZODkYpdvLjptKMl8ToZHW/6Ohq6Se/fYZ/Tmy1?=
 =?us-ascii?Q?hwWVCJ3zvHEsY83cgyZ6pWlCZ2u1Kz92YgrW2Qw+oPZriNjeHygx3FI9JdAJ?=
 =?us-ascii?Q?F/oqUDhCZpb3yUJY2gWVTi1hJ4Dyynf+dL0zz7e5RsHj1ovPdoplZyfhMcAr?=
 =?us-ascii?Q?eB0w13lRjo1UNNZVx20Shq12lU3dCtDY4Jq14vwvHPyfwfL8VD0qhNYgPc7T?=
 =?us-ascii?Q?BKpiSoZIkXFL6nFbqhWzPmUUiG7gZ/++3eClYzgWBaYAEl4ZDBOWEubMOOi8?=
 =?us-ascii?Q?1TWupChw5JAA7hDJzK+TzkiVO0JEnFp8s7HXmmsSqRm7MitjEP79SPqiwMY8?=
 =?us-ascii?Q?d+bymJx7l2XcqZSTCkjb64d4FZib0hoT7HBQu/wH7f4Wtf1RGEvfSNOuX6uA?=
 =?us-ascii?Q?2p3DZGHCjeLdDeyR/AySrpo2nwzeJJJXlPcFBqhSdctZLe+Zpi9CUefLF3Z1?=
 =?us-ascii?Q?OsBL2fdyFCtbgeYUy+v9b9xBoCWrwM0kTV9pBexmqi0wYUtauyOD4kRVywdz?=
 =?us-ascii?Q?WBFq+oAgjWSfexwdxS2PMyQxZbSwryz50C/jVuo5PT23Z9kY0dLR+szWRgUe?=
 =?us-ascii?Q?1jETW7Cf9IfvN5tuxX+DlTYsv1zvbPyRAaYHHf9zzfgVqY1h+tRxOmroCO2q?=
 =?us-ascii?Q?wjDlYrHjSm1g327+fx10O5wOvkAetJzd4gTlKMNTlSGdDfiq9wfRqVNkO7Ti?=
 =?us-ascii?Q?efem8oOaczqSfmDgLeeUzGjxns3uAxUjjQ5J0tT2azaW3xhiUPz8e/wOcLWO?=
 =?us-ascii?Q?SZAlOmxdUzg3MvNL/l6izaJhX5Xy6ssYxJO6WyVEAr4FM6+rocRriZq1G6Ng?=
 =?us-ascii?Q?WNuRADez4eZ+HhSFQwMeZ0rfch2/BV2KxsZH5mRClCihlmoMuHUYN7cgKJda?=
 =?us-ascii?Q?gZYWmGy2aRNWgjvXHdKyBbX47JTDe2TnigdGlEglRjuJwKrIGwlE+97LyTof?=
 =?us-ascii?Q?7AgrssOW7mMjRLO3Fhh7AnL1tJLUldEGi/6D6y+HEpxBdbsareiW5Vkewnxj?=
 =?us-ascii?Q?Jmz60TiGCb+V2td1qmFU7gfk6bQKSYs5NFvMnxjuZX+Xq9fV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1aa73df-b999-47c4-dccc-08dee35c29c2
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 17:03:31.3003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rS+NsXi0URCvc0RQgSH29zc8olhgvzusziRHXE+LaAHlZSM12GCi3gXJwZ9LXNia
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6216

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

