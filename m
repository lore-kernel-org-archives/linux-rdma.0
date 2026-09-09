Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010052.outbound.protection.outlook.com [52.101.201.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DB753444B;
	Wed,  9 Sep 2026 23:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788998293; cv=fail; b=Ifu7ndrb/Dp9U/jeqi2nTNfNlIJoDL8Gyq1ZUd5IU+BL0J1rwy5qh4pWcwRgNvrW5rMf4Rxp8E+npsygZuCPLHIN+YRUav8rdVvwQ46MUAqTmi9iJw3VyOqo5gSIYo7jGAQVzajSADqGy5mlt4+1ZYkOoA5R2J1UIBQO9xlM7Pk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788998293; c=relaxed/simple;
	bh=nROhSdID9rtuFbMhRBkvHRX3KWOs9SCSl14QS8T0ndA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=buIp+Y/uRKaO4Ew2Lew5y9RZ8yuKkqYWa4k97j815zZ6YIrJQv8TxXKiRYuZe5g8Lm+swtwv8Mm2j51HkiK2IXgHFIhEqICPZ2v3cHtXeySwCkHgRWoE/D0/SRQMcRfqOwaMRQgUI/6LOzYgcaieFR3fEwckcX9e7qsixwfzhak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S7P0aGQa; arc=fail smtp.client-ip=52.101.201.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S7P0aGQa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I4v3H1MDoFSp0undLOBViIN0ZGETa4+hWOqbUDuBzaamxE3W5f79OFLIgDuAMfOxtxaTs6O697hhpIVQ/OvsdAOQ7tGK77VFBaHqBkQ/eQp0C9R4EzmOqmdpOuwYx0GZeju3NMZDSQQqhsU8cZaeH3kLBmTtFbT8UGVedr+XZlHxeeXBu0A1RngVlshq2v8BoBmRj7MV9SsxW4lEoDRGJqO33/B5n1b93cseOXpwxb36rQ/SWGzhpZSYgIGTIWfwd7rnGFgiWdTR0bvhPBt0mWlCvI780pOtWRqJYJlr8F5/ZoJNaQbTJgQrDJE3qVkE/lawMLkPqIAKxk69YbXgCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHlhszfoLcDO8N4YgMUHwbXPVKa0ql6Xjos2u9xf7QY=;
 b=JAC3Lu1HvkCGUVVH7+CYdteoCtGLscHyiA3rLvK7D29MKm59G8vBB7AAkLxX2/zboD9/StYHIubuXRlgZ5UVUdIeAzC4zbgm1m6Fn9Qbsidbmuc1hsn5jNZmyl7z6M59ULNxbW1X6fZONvauSlbvoC8nf0Nw6CtJiuD1/wICulo3W2BvBzZraS5kI47IuRhUH1BP4h3BHNAgK5kFQeIKzZxqE3mndNoY9lNs5RgcNGyvBW2crKdbiKd8okpu2kgn6d1MxrE2r3bjPMV0AeqQSUB1zSMptyNn9eR/gJKpWvY5UERMokglhLPu3gqvMl9Zfl2GhLpRIohSnaYEw0hqcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHlhszfoLcDO8N4YgMUHwbXPVKa0ql6Xjos2u9xf7QY=;
 b=S7P0aGQaZpY7oMsobfOZC16iDrTcPX8/xmdv0FzlYKUcTVgUIGlUCmwoSM5HbuQASISkhtKodyBiFaNbANSAqNOfEI4kJefqA96jQ2u5kNP8E2EaT+LjHFYODMZAr8Q8aSRiYz3VHdBo0MVCna5cgH2y8ml1jp7ffhgVIWGqHUi5jS9eQCrZSzB9RYi5aqEwa+sUoTUThXgFHWZ79A5KGIqGTKaRl5nxgcFqYgNcjJpp1N9WEtfryFgbxwkv4CA4sMcUQGLiLBIx9FH1iFynuVBtUN4Z6xdyXpmYiTZYQxYguprY/hjJ0GSbj39pf1UzLVKzM/VORFA93HCJ5w5xwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV3PR12MB9440.namprd12.prod.outlook.com (2603:10b6:408:215::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.14; Wed, 9 Sep
 2026 23:57:52 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 23:57:52 +0000
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
Subject: [PATCH v5 05/10] selftests: Add additional kernel functions to tools/include/
Date: Wed,  9 Sep 2026 20:57:31 -0300
Message-ID: <5-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT2PR01CA0026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::31) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|LV3PR12MB9440:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f2e8eb7-f462-40a2-bc32-08df0ece2278
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|921020|6133799003|10067099003|11063799006|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	PutfddJsu+cudPAqpiLOLA6UooGln5SkQp6b9fxHnU8XibtdQGUliYlCQSUatneJyx7sfADJutBl0WGbYx/tb7/Pq3dvc0Zk/ABZMIE1jDBISsV76gd6orspzl/JcwHYb2ykmKasYnMkaVUpg9fcgCuPorSiLwJGJhMuOBR36g6tVpMYlh2FlRXRtHslqeWrzvC2tIIOQ9Gvgwl/UYFDR87UA4c7baW9O5RmExQkZLAEBPO0wdodZ4u2NasRzfXnvBxuqaqP7DMYA8B9DnjPZRa3Ogbwjgs/IkMtFCmelYrQC7DlTcXmtDR3nOaeL70aNjsQDgu6XCEphBU2nh8nXTpehFfOCpOK+j9o3HwDIOeV4aHoWmmmjGPCCT5AUeAOfnha4MCCs3SBY4EuDfVzHWak15JtLTfD3LMWXr3JcTOuebcbsZolGRiwjBpk0p+UQttnklUTbLBe0XHJQZHGcp7f5dDxiPkLm48KgwwIvLUzez3r79zcP4ZIgd6gUpeynD5KbN5brGVNobgjNZF5nRn6ZjzfA6UJ/RU7wzb7P/Rlj0Na0uT9X8wAtR6HkfyDqr58dLoPlKgvyYfQW/RBZ36CI0iU7AD36ZV5Gr462Ai8Yz/e9YIiPmFfUt9QAt5u1SnVYkMHKxF6dHUOuZeVrFy9vbXkAAVhvkKCif/nsc8EjWwjsNj5MfCbfyGZ3pS5o1bhoDNc506rRfJXtpU9Mw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(921020)(6133799003)(10067099003)(11063799006)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?us4L+RixflfM2G3jAQu0TSFYJIV/oz+/ZvaAwA1MrZKFauXUcTghNHW2kn3U?=
 =?us-ascii?Q?ASYIdCUxwJzSKcAYafNctgNA3sHcTQCM/UzWc2NNaLAS1XXUGMXAak3MPShu?=
 =?us-ascii?Q?c2bPxdNW7n29tXB4VZHW6T4XXe/QwIOTlz1TP3iQOPd5/khSf9hV6Ifu4BCC?=
 =?us-ascii?Q?3p/heLE8AJH4UQTxB5BA99bzM+3ST38Su410wbCrORT652aNE4MllKIFHP+I?=
 =?us-ascii?Q?7559eQDhZ82+e25xzAnXZCBeU1DITR3YX89n/8vZCrg+0nhJzlfyCX56mm0q?=
 =?us-ascii?Q?Xd0+cMHubssSizskjbynQeKOHNo53MRQn5xNynuCSizO0dwK9qVFB+/rYRbi?=
 =?us-ascii?Q?L+eJdlUf8EAxuwfIO46/g7Snhq8zfiRt2lbgZ9Zwp5IzFtWIZJr67apN+4YS?=
 =?us-ascii?Q?So3TTZ1+P/jLvq/AXSxLFClQnm0oh8aFjiICyPpHVwO6wZdSp2pHgiqqPhvT?=
 =?us-ascii?Q?E5BXfI90CFZH2/xnZDb7VhVfA0kvrRHp2oI6sbVlEUr9jUJAojAKXQ0faGgJ?=
 =?us-ascii?Q?2l5GkkkKlV1cQo9VJcpUT1vva6Kvu9TejJORkhmvKF5kGp3eF/NLnJ4L18fJ?=
 =?us-ascii?Q?eYIWsQXqmANlavubQn+h/Mi/5tFwZDU2eJJGB+uNm4Y8WHe4cjOLNfLDcsM0?=
 =?us-ascii?Q?JuTYR0+Ulj2BSsu7op/VgTzCZACqXDU0NeM5dBqpO1QW1nNEMFTB2IEyd1X8?=
 =?us-ascii?Q?yIfDj+6PkwTiYFCyWVvWFZLk3AXNa3XsPjpSW/6vN/dxTwkmqyHyBUEa4pVF?=
 =?us-ascii?Q?ugUfL2mSuMwCY9jzNo6UVyuNgtq/vt5f+ljIkbT0d6ZvheQKOF/+IXV9rQxx?=
 =?us-ascii?Q?TBSadmsyw25vTNexRrRzKn1NjNFjlTwGw6DScWDoeXcB+DFik684knWex5h6?=
 =?us-ascii?Q?APR/wkznbSV31iX+62haYgQg0emwU+YoWJG+l4CgsdDi0YpDn55rDGWj2U8t?=
 =?us-ascii?Q?OX72YceLbbaRu+mX30jUNV/Qtj+gKDqcmI74Vh8lmQl6XdY9dpNMAQrQ6eub?=
 =?us-ascii?Q?OV34lW2Pnks8UAsZR4C77qpLXaVeO/dT/vCon6J01d5u937jGG79I2HQElw1?=
 =?us-ascii?Q?RQE2xddjgVQpErHsMYTFfZIvM5DGuxR0Ka/fXxndNeAAFbkG5hwErlxePX/7?=
 =?us-ascii?Q?F321z3bacU1RMNolm9xry0L7+bFDJcTIMIkZMgJy2FM28Rk5754pEIrwoJTK?=
 =?us-ascii?Q?+dWsYh8/1TebHISAXo0ZV13wMYcDQde3wQNAYHloSiijRq6IfwySHDFbXeBg?=
 =?us-ascii?Q?atrJMqLddGHeLKWUb0ORlyvBiyT2aksQqmNVr95uGErlBVlIMBoPHF/86cPH?=
 =?us-ascii?Q?FRlDIw2tteTAZwdcyeicY5G/CARe9j9+eFs+a/RG+x+GZXcXMv3Sk4L3W5w6?=
 =?us-ascii?Q?/EzhUTZwv4ggUJNy0bbyRugtAvZSm2qfyClwWyze19+Mzvpd2t0b0ArnhnYY?=
 =?us-ascii?Q?O6ihjvaTrj9S6mK172dJW0zBF3k9DexUa+RWbE/0k5vU5UENRLHx3cqm0s8h?=
 =?us-ascii?Q?LlWK1xartsn9uKMUaijfiWtNNjf6Y97UuNfLybAYl31xPEKFJ/5rE8v/Hr75?=
 =?us-ascii?Q?YrsyJdOzhWoERE/BRRTlys8IUVt4f+RkwGWI9jyHL09bqs8tOR4I5fYp5PDp?=
 =?us-ascii?Q?wFoNjvMqkmhwehHI2x3djxtGaj6VKHiTDkHI1in2aRj0mh2vMu0nKEWPtmf1?=
 =?us-ascii?Q?Z2Tl2zyUJjKuhue4Y0P1zb93cWYL+aX60bynXaK62wGBqY2r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f2e8eb7-f462-40a2-bc32-08df0ece2278
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 23:57:41.5802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PTZQdH1tR24+vBL77bchmbdPEmtdrEcqLywoR4brJ5fCyxpgKttA0aTkNn3TcHsK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9440

These are needed by the VFIO mlx5 selftest in the following patches,
which includes some headers from mlx5 and also needs a few more
MMIO-related features.

- DECLARE_FLEX_ARRAY in new tools/include/linux/stddef.h (wraps
  existing __DECLARE_FLEX_ARRAY from uapi/linux/stddef.h)

- dma_wmb/dma_rmb barriers: x86 uses compiler barrier
  (DMA-coherent), arm64 uses dmb oshst/oshld (outer-shareable for
  device visibility), generic fallback uses wmb/rmb

- ioread32be/iowrite32be in tools/include/asm-generic/io.h for
  big-endian MMIO register access

Assisted-by: Claude:claude-opus-4.6
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 tools/arch/arm64/include/asm/barrier.h |  4 ++++
 tools/arch/x86/include/asm/barrier.h   |  5 +++++
 tools/include/asm-generic/io.h         | 28 ++++++++++++++++++++++++++
 tools/include/asm/barrier.h            |  8 ++++++++
 tools/include/linux/stddef.h           | 10 +++++++++
 5 files changed, 55 insertions(+)
 create mode 100644 tools/include/linux/stddef.h

diff --git a/tools/arch/arm64/include/asm/barrier.h b/tools/arch/arm64/include/asm/barrier.h
index 3b9b41331c4f16..abdc64fc3c70f0 100644
--- a/tools/arch/arm64/include/asm/barrier.h
+++ b/tools/arch/arm64/include/asm/barrier.h
@@ -24,6 +24,10 @@
 #define smp_wmb()	asm volatile("dmb ishst" ::: "memory")
 #define smp_rmb()	asm volatile("dmb ishld" ::: "memory")
 
+/* DMA barriers use outer-shareable (osh) for device visibility */
+#define dma_rmb()	asm volatile("dmb oshld" ::: "memory")
+#define dma_wmb()	asm volatile("dmb oshst" ::: "memory")
+
 #define smp_store_release(p, v)						\
 do {									\
 	union { typeof(*p) __val; char __c[1]; } __u =			\
diff --git a/tools/arch/x86/include/asm/barrier.h b/tools/arch/x86/include/asm/barrier.h
index 0adf295dd5b6aa..0b51431fa530ea 100644
--- a/tools/arch/x86/include/asm/barrier.h
+++ b/tools/arch/x86/include/asm/barrier.h
@@ -43,4 +43,9 @@ do {						\
 	___p1;					\
 })
 #endif /* defined(__x86_64__) */
+
+/* x86 is DMA-coherent so DMA barriers are just compiler barriers */
+#define dma_rmb()	barrier()
+#define dma_wmb()	barrier()
+
 #endif /* _TOOLS_LINUX_ASM_X86_BARRIER_H */
diff --git a/tools/include/asm-generic/io.h b/tools/include/asm-generic/io.h
index e5a0b07ad452a6..0d89decdafb818 100644
--- a/tools/include/asm-generic/io.h
+++ b/tools/include/asm-generic/io.h
@@ -479,4 +479,32 @@ static inline void writesq(volatile void __iomem *addr, const void *buffer,
 }
 #endif
 
+/*
+ * ioread/iowrite for big-endian MMIO registers.
+ */
+
+#ifndef ioread32be
+#define ioread32be ioread32be
+static inline u32 ioread32be(const volatile void __iomem *addr)
+{
+	return bswap_32(readl(addr));
+}
+#endif
+
+#ifndef iowrite32be
+#define iowrite32be iowrite32be
+static inline void iowrite32be(u32 value, volatile void __iomem *addr)
+{
+	writel(bswap_32(value), addr);
+}
+#endif
+
+#ifndef iowrite64be
+#define iowrite64be iowrite64be
+static inline void iowrite64be(u64 value, volatile void __iomem *addr)
+{
+	writeq(bswap_64(value), addr);
+}
+#endif
+
 #endif /* _TOOLS_ASM_GENERIC_IO_H */
diff --git a/tools/include/asm/barrier.h b/tools/include/asm/barrier.h
index 0c21678ac5e65f..e7e0c7de5a2ffe 100644
--- a/tools/include/asm/barrier.h
+++ b/tools/include/asm/barrier.h
@@ -47,6 +47,14 @@
 # define smp_mb()	mb()
 #endif
 
+#ifndef dma_rmb
+# define dma_rmb()	rmb()
+#endif
+
+#ifndef dma_wmb
+# define dma_wmb()	wmb()
+#endif
+
 #ifndef smp_store_release
 # define smp_store_release(p, v)		\
 do {						\
diff --git a/tools/include/linux/stddef.h b/tools/include/linux/stddef.h
new file mode 100644
index 00000000000000..99182ea4a1419b
--- /dev/null
+++ b/tools/include/linux/stddef.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TOOLS_LINUX_STDDEF_H
+#define _TOOLS_LINUX_STDDEF_H
+
+#include_next <linux/stddef.h>
+
+#define DECLARE_FLEX_ARRAY(TYPE, NAME) \
+	__DECLARE_FLEX_ARRAY(TYPE, NAME)
+
+#endif /* _TOOLS_LINUX_STDDEF_H */
-- 
2.43.0

