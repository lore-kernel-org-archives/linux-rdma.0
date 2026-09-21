Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012033.outbound.protection.outlook.com [40.107.209.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189C7521212;
	Mon, 21 Sep 2026 22:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030165; cv=fail; b=lMaXtXAa7mjS7bT9X0F/nEkksvdhDZ4rqbho1wiSgn9XJVOlZoXoXhI5uduaSG27GL4kmmyg7kD23DSb5y4670Z4X75h3CuegzXyEmBg+BbqYblXD9H4g+9JO7owRpNBGjXykmqvzmYAVsw+3iCMLllfyeanaZqmVbrjRJy/wjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030165; c=relaxed/simple;
	bh=rLroGep/rC3eOvI9nuSa6YQ1xjdz2tgL1HcP1sPaVC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FvVgX8G/+JykPCxVAnjdzW6PNuGYmDN8jraLkEfezdZf77XNiOFrEAtv3d3Lu4cwgO5FybpbTSNvEVbiVhfXUQgxBHvvw/4EmL7ic5LMZu5+IRkgyd0fdnTGnI2wqKTrqDM2GPZs7vOJfI+n7VjlrZ1mose2dC7SHdZnbtZ3k9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hi9hNgPv; arc=fail smtp.client-ip=40.107.209.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hi9hNgPv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nKWyIrLMaA9fkoBvrjcGPrxHHoa2l/wbK6tAqysRPTXqDMDhqWs7apvTEL8U8CPh4OtGgzTCJ9itaVp+RtLT4gYpo9NdHJqhNVV1u3edRBycztMe0kRAoR4n09X8FJ5HvzcgnNoSxfySdL53IkT0/LM0sciXRvpHL3o1rnTbtiTOu8oQ7tbT1c+TdrrEhyt6CrUfNEmUx0v18Q2yJURO63yhRppKdou53x5TUTixjgF5zp3DuK0UfXRu97hwcq6F/TZic/CNqZLYY7cWg/iocriSaA2kybF0x7W2tqgs8cbUTbniVFnjv+WQ69DgIFlKZsIP4xZQ1i1qnHl02pVTSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FW7Z4YDC3ysJJdOVPNKRrKuMen84++d4RjEZfPoJAi8=;
 b=xECaGh0Pf+QHf7Slrp1ZLcHWdQDgTKyighOvft46H71rvLgaqJnqapvIWETrHCqsvR65yFOUV6/F/qy2Ag4qSQVSUC0kMTWurpovvxsTSC3fxHhSfwEvOjxAVhPDvtl8PYM93B1uXTa0N4QgF6nO/r45CaA2e1fzvJ1NgkNhPQPVjEf/9J/XQTV791JtZgdxvqD8gK8WWItTh6KGR060oOOLygLGJYmS9gT5Hn7TkEmxQT/6v0JkNTpvE9LvGbDxAk4/bvp/6op/mlyDN7OuBSboZTMZtzMMmEUuuL5GRhSJwW2Ky64rAVCfY2QmkX1qVfzU3T0XrZxCx/uhbc7ohA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FW7Z4YDC3ysJJdOVPNKRrKuMen84++d4RjEZfPoJAi8=;
 b=hi9hNgPvwpwsV4Gf04pft9SBkK6XYBycoJM37+RTHEw7v+uAc1u9JTZv3MGyahNkTcm4ywsU3ZQpDsrsQjfEhIJcaEvz9vhHLmywgx9savcKKG6Wb9rVQTlr3gidiJxRnW8ZMzieVUL5nVGAwBF9v796i8EnpY3/JMG1jfkyjc3zUthl9SUIOTAKBv6TQRWJuZz3hHLl3wWhX5aiGokpaNXdJg7XrcL7IxRt7KDoRCKz7hyvwoEJHf5wWJteIzGXH/EZ/JaI42GJUgUg0dLD5TSFdmYUULrzKJ9dIQFliSH1kN2aKuBeSorp/DFd8W969deFj4ZCmfdIMcWKhpPuAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9144.namprd12.prod.outlook.com
 (2603:10b6:408:19d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 22:35:55 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 22:35:55 +0000
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
Subject: [PATCH v7 05/10] selftests: Add additional kernel functions to tools/include/
Date: Mon, 21 Sep 2026 19:35:45 -0300
Message-ID: <5-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DSSP220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:3d3::17) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV3PR12MB9144:EE_
X-MS-Office365-Filtering-Correlation-Id: 14ed856f-4bf1-454b-60c4-08df1830b129
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|7416014|921020|56012099006|6133799003|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	pvzTMLngL8X28vUrWehOQ5Z+YozaA6DwFHeH9gzEolp5Rv3SrvUzXa2uxI7Ue9Bjx4t84tmRgEPjlQa9idhBbP+gairnMbaJ9FGMoAo7Red/ZS8QqTbIThF+4WX4Sx3mHSTfGAq6IFoQd0ulmEj58UBhqvJ4JXbQHSmtTR36MqzpQSARv+gNQgIQZ62jSMMjgw4Y9uZ6UCXyhnH6pVgQV7yorS479NXElcoRnCGpern6Wmizvm50KhKjh5J/hH3CuAYuMwK2BdxY9lOkFuV3EIk/rpP48phGPHECCwaObPLM48/uDrCXdb3n2nPjXjQZfHwNRZfhTK/KUhcBz/3Br6Eg2qfEAN8mxV4cYn1qVfrEQuxsN0oGP4lZMFqI3IEU27XBbjMNbW7EMGzVInagQd/BHg8Em2h1pxLeltGqL7gdzrgz+PKXklqJ1/0LTGybKbtpYzhsnHaDJ45oKpmxlioa6hX9EPSnNaZ3ASm8VZvVP+AAzWWpAF/KHVro2ALmsrctkLVGo3zwEviuUJvj0XpW/f+P1O/2WpUMMhLIk4hHF7+ZSWD9Pys2hMfKIyYXcvZYisNM0aqlgOmL1rsOV/NDlHK9EFgfRA2V3f4YCCqBhVBwmAblQRFqsXX0GBc2LU3jnfub/UW2ChabJn3oSxzz34kSmrCVne/lc8xMKU4EIeKC5gk6YBygFrG0UJOdZzfbska5qgIr/f5EwY/7RQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(7416014)(921020)(56012099006)(6133799003)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CyDWZKe+VCymwHIgUsEEBZ1TWuoi9ZHUfaj7MqCjHa4MkZTLPUUl3gSCpjqu?=
 =?us-ascii?Q?7o+AhmPQ5je02bGXzIPfAsqgORGhNs4mgZcIaWV/MqpqaFMJXva2zELMIuG9?=
 =?us-ascii?Q?kxX0vKFW//ke+uptGQS2UaQzbqXZK/ge1gdk/fvUKHh0w1nelenEog0WJzjk?=
 =?us-ascii?Q?LwlEi3mApaR1Mj/nOVwHBxxCzFvLUgAPD8hOdXvFxvF82uI7RiqvwXEH5yOZ?=
 =?us-ascii?Q?w7ci1Px0uPq7gP3ru9wjUeTQ24iBdQHp2Ebq/WKzjYGv0LuIFpBgM91OuS+c?=
 =?us-ascii?Q?S0JPvu+occlgjrPjdxAL67uFlOVN40g3/JTzpY5w1KEMd6Q2plg79LDUoXi3?=
 =?us-ascii?Q?tHsT2dJ5VdAEsUqFc9vxc2aoVsQsFEz8fgOvRbWldkVl/YkFFWq9nXAP+DKK?=
 =?us-ascii?Q?rog6FIVeA78/rwtjeGF/WJBCav3giU8o+11vHKlxhIkSeA+Iyxt3edzsxE7H?=
 =?us-ascii?Q?RbLGzdpwk/4VcCJVWANTNDEY8IQ2wRXR5gYtVDCOHxjdQhDsK7sm8+uo/KfB?=
 =?us-ascii?Q?aJgJ2zhlCsn+/nAM9WwLi6arTh5M9XYsYhT/zIezjXISm1ICpLq22pKnAk56?=
 =?us-ascii?Q?r7qDwCZZzyy59wrJJxsX8i7ab9/1Xh4osR8rC6KyjBB8cMt8XRR6CGorl/e/?=
 =?us-ascii?Q?PkTfsnRnf8hoI+kGuPVZyfuURM1uZ9LO2KJDhZt8XaCCt7baNfEHgkcbx3fa?=
 =?us-ascii?Q?MiPXLw1rHkpAM8LCjb6dJRGiTJghNT0vFjdw0grOTpx9WPDvz5Lc4gg/EoBU?=
 =?us-ascii?Q?AzGxVYsbhBVSokiWc5WtjKevzJ3FHSNGzXP+/2pJhEOWVJMeNmKAh77GqISU?=
 =?us-ascii?Q?eDqcKQOdw/+BrAGDaXR9poA007cAz2ytDl9YrFNlhmdDShAqNiWSiRSDbIM4?=
 =?us-ascii?Q?1Ch6seM9cLuMJxSSzDN90B1YqPb5If20h/xMB0tETIT2Rx2e4bE2nU0/e03b?=
 =?us-ascii?Q?04Vj+m1/+KOijgwu1buIlTodcvm7CHwsWjqC/7K0IISIDSFyHC/bzcHeYXCo?=
 =?us-ascii?Q?nbaEIz7HW4cy62dlgcSfXU0PeTqWAVZnp2XD/WnJR8hAQKphxlHkyP499iG6?=
 =?us-ascii?Q?KYR/OdfUfLSsZfMAu3V+bZqW0yv0Kbon68bq9btvvO8hl/vjBtYFQFB4Zm0x?=
 =?us-ascii?Q?bP3pNFTgiofcv3kgoksvdRYiZ0C9A7IfPIvxyPw0or66YtNnThBfOskDddSq?=
 =?us-ascii?Q?d0aCEMKtBFErg8JlVv7uL5GCPOqIrNQC+rqO53tLPDarp8/OdZg7ushS7v5y?=
 =?us-ascii?Q?7GyIYf3nhNNa7mIE8OtM8GBqO6plMhOydgtfCZ6/M/caXa+krzAezqVcSd66?=
 =?us-ascii?Q?scdIJpBvLBW5VS1hEozTDkS0tYKgdZYwaIcvyO9qqsmoXBq6W0S4jc1sTDLr?=
 =?us-ascii?Q?4wOwEHGRHrnILkwyjtD91hHG7Wm1bl0RKzA8EHA/9uGQKCX+s8kZQ9JwfR1i?=
 =?us-ascii?Q?qGTdGut5OBVmOH3km5cf8i9jVVB1YLVRHo3zD0rbzQH3cUNeauCYdfXuLY5l?=
 =?us-ascii?Q?R5xVzNKQsM1ORIoMOwb5lm5yRUKpTfg0TZHGgh6KnL6WXl7xCqfTWySUZEhh?=
 =?us-ascii?Q?OJ+4vL5A68B3bHCrTMqfdfNnMedKaO+RZoYRDOSxkAtW2MhpvPMXGzxxOWgb?=
 =?us-ascii?Q?MfJEtqychecGf17EKcaqGaE0bTZyPl78XYaIA+Wdm/2aRNQ0e/UeLV3gfBfn?=
 =?us-ascii?Q?4AHgS0Zt+75mkHrug8l86KvOg0s6dFgrHt8LOWiw1ri8n5vO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14ed856f-4bf1-454b-60c4-08df1830b129
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 22:35:52.1137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z+zowVpl0DgLDYwo+syzi+z1NZczfbXTck8cXaUTn1Dh2Y+GvnGE2k6uTZGT7YS+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9144

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
 tools/arch/arm64/include/asm/barrier.h        |  4 +++
 tools/arch/x86/include/asm/barrier.h          |  5 ++++
 tools/include/asm-generic/io.h                | 28 +++++++++++++++++++
 tools/include/asm/barrier.h                   |  8 ++++++
 tools/include/linux/stddef.h                  | 10 +++++++
 .../selftests/kvm/include/arm64/processor.h   |  4 +--
 6 files changed, 56 insertions(+), 3 deletions(-)
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
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index b8a902ba8573da..5878a6abdf20e1 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -12,6 +12,7 @@
 
 #include <linux/stringify.h>
 #include <linux/types.h>
+#include <asm/barrier.h>
 #include <asm/brk-imm.h>
 #include <asm/esr.h>
 #include <asm/sysreg.h>
@@ -191,11 +192,8 @@ static inline void cpu_relax(void)
 #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
 #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
 
-#define dma_wmb()	dmb(oshst)
 #define __iowmb()	dma_wmb()
 
-#define dma_rmb()	dmb(oshld)
-
 #define __iormb(v)							\
 ({									\
 	unsigned long tmp;						\
-- 
2.43.0

