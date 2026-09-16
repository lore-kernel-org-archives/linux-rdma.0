Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010022.outbound.protection.outlook.com [52.101.85.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DAE4D9908;
	Wed, 16 Sep 2026 23:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602657; cv=fail; b=LiMtXis1L/m4XPeQ43xu2kx5ztZ4NK3tkn+WZRgmxJhFfFQUGcy5w1QEHpCSjihbna+t7ghFx7o6zZ+SgkyxLHQSj/1+W2xDCqAfnm/anqZe5E97SPh384d7n99DIFNmWn4ImlEkG1KroQ08jp4uQ13oB2SIejBcZNfZUTBZQDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602657; c=relaxed/simple;
	bh=nROhSdID9rtuFbMhRBkvHRX3KWOs9SCSl14QS8T0ndA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R87M0XWzqCzw4IwQKSGePbIG9XbGmQ5i2GWyEFW+lvEg/MGSLWiChdHLsw1e0sVNKImu3r/JBoJqCTbyjIiLgLjoQoPPCjR2aKdmMS1JnYZNCtOO/27T/4LEzFcwRItkJINO+87G52Izu6bODa8cJRDSmGY0SpwYzSesRRnC/Yk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nGU0fiUJ; arc=fail smtp.client-ip=52.101.85.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nGU0fiUJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ihDsD1JQJRjGVQP3Ue/18e6FiL1b409f6TCg+z/fMRyXBJo/kQ8dpj4bAYK1adG22UhTrUVpbdWNms+Se94eeJJrp4AhNoKwuQpGRld++6/eHdyAHnnVwAYQOLC5CH4fP3fQWGQ9bDdmSl1vruSD1rVRpo8bni6gSY9lXwMuncE8ax2cj4VFPjHUmQ+gUoXwLdvdiw4f+7oUA+4El12T1akt8msLmibLSuUNEzhpQFD2plkLGcP+y8HJvi0Hcq8NzUG3ulZRnq6uwkuGn7+tF+qnI36iT6Wa5lZRJXbMoYBOGI6vVE2J381UqGLVpEBlZ+NgbQpf5bx2UMX89+XxVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHlhszfoLcDO8N4YgMUHwbXPVKa0ql6Xjos2u9xf7QY=;
 b=JbnQt4aA7niqVE9tgCE/gyhC89Z95hK/gtU9dEKvarNaoXpq6X9pfciS7oiGDnVKJ4lSTAcBuY9jM9xoRAhZL6bDi+hViJk/bE7fvflfleh0C9EmruNLNM6bxAuIwuDp6U0Q30vRhVZE3Fe+kFnKW0My28STL9a7PUfEoDWZXPOagkWa/NbuOgq5CES66VQ5wWWA7Q/aXXmELTF9UVPUW+l+ygi3EzrNuWL/sivyOlmrbk8qulsBsiHnbqeHRWlq56PU6yOrDM2VAhGtqSZ2dqD92MQrJwYmmB/X2l543jfp0XD1IQtuEZ1oEhlOigPJbV+aAC+1zGd751VKNjw45g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHlhszfoLcDO8N4YgMUHwbXPVKa0ql6Xjos2u9xf7QY=;
 b=nGU0fiUJF+Arm8pRhQWAdZ6mkNRr7/HuJJ7Ubw5xKJnE/ojiRKpYCnq9TxRz36pKVpb2iUq+ayF6OitNhPhin08O2+a9NjSMr8IZsvLyBT+GJ1R2vi84f/eH2R3eEILddmYuoqVk9UZcbCfXviwilpzwgXKf6I4YYJN4+YIZtAq7OmhqrzxZsfMdTvfIKGIypxJLIGlvZ9naCuM45oC+XGL8OcXLrkLZS1gNOfQt8qyE8j+zLRgKUkkKU6VJo2hDw8xsyzqUOinF/j0cumLo6x5dVJnXJbBdcbssKleFGkCbNuAukNtTicmfX6f9YpBqK/rjQnY/ZAzY+B0N/j0X1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA4PR12MB9787.namprd12.prod.outlook.com
 (2603:10b6:208:54d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 23:50:02 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Wed, 16 Sep 2026
 23:50:02 +0000
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
Subject: [PATCH v6 05/10] selftests: Add additional kernel functions to tools/include/
Date: Wed, 16 Sep 2026 20:49:53 -0300
Message-ID: <5-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0014.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::26) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA4PR12MB9787:EE_
X-MS-Office365-Filtering-Correlation-Id: 62186b17-f0cf-450f-4522-08df144d38a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|921020|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	LXFl9d53LrEeJsHPvBZ3/wkZplqO2VDbAH1hRsK/kpjAUeDSRKHgvSJMvEoqDYQ6AbAfcA5sWBKHTy1bmZi+a0/YTqUWLjUaSx4t2GP/wCJggjvk5EAIzDL3VQopcBDUUmJX4/CdFtQak0wsjkwBmEcKEdni22teILeiiV0d6OSkPRMb+H5CMdA5JHz0SkaFarOo4O7wGjLAhO11lTija7cdNFwXLVZ93qA0U9BWNqm7pM0wgRib8iknQ9aU6+/ypCP6lMOBwaddYG2EsSmKx7VJmU6A84+nMD9RgEj9xGD/UfwUP3nyRtk3IsHcr9+zXKk95PMW+jciyUM1F5sh1BfDZKNG/PbQlDT+lXJNMrteXTHJELX5Ez9VNaeVs+T+DQxtYn0GVRiD1D1BR0JccDlnX/hDh8tEinwKEI95oNOQ61PnDc+BtFLFxJUeuB0gZBu4HxkB1lbkcMdN1igm8/ls11N3S05o7Vancwx+Ey+Vk2ZsVuzT7LcM5UQOx9du+oo68xpdEAWJpwJTp/ls6VlI3LqoLFilUum2DT86ejMyRlmW9QVMzginM5ejDDCIU0KoDKfLDGAnIaH0ChfGQ/A0unxwWc4HCOnxIKcPxMHLxJJoHT5EEFDKxBq8xV8nj8Uhh73St318XuZkNkrxjEYY661dsf7iPHfrORPZ+ei/00oP2AyQfof7aeV/fpyMTrOiSH++8nTHgpEpewvzpg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(921020)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XNdAv2hp4wNoQ6u3fe1Kq3tsf9ErgwV2LEtsVMnAEpe3/1K9ulvSBe4Z4WBd?=
 =?us-ascii?Q?jJvHFZmCXwFdf/4RAFfzLNpTn85gQOQxOkLJtTR3oqYcAmqATZ+Ydn8zHC/B?=
 =?us-ascii?Q?4kj0edMGUgsbb/ChvgH8fMZyG1bBkYVadZlLNAw6k0BXs+7tOOf4MILO7lKO?=
 =?us-ascii?Q?OR0ep6y9fb4GATpHx8t9KZvfapAkoA5+vWrBybyEK3Ej4ula6m/GuZn2ojLu?=
 =?us-ascii?Q?VfGmXj3R508Qhau2J5WQe2s5mXf9AajNv85plqlTPMvdjblj892lhGWNX9Qc?=
 =?us-ascii?Q?SEZzx1D2tFrorPdd8ubPqv4FOlXX8cp9hao50N8jRPBuT9+xoqybz8Vl34jw?=
 =?us-ascii?Q?ydaV2O/5xAPs45Oz4D+xRYwlzqKDRvV8FvPUYDSZL+xMyZVfN9PGlqG8JpBm?=
 =?us-ascii?Q?xQ+DJKTX5MCNF0UJL2ncr3w77O0ERcDoXd4zzJJqLmildVOOT8c/66eGI641?=
 =?us-ascii?Q?0qqZqvAXERBL+hQV0/0kNs5rzipOWrOS0eMcoCVB3epStCH34l3qSeGoJ4Mo?=
 =?us-ascii?Q?4UFBuxy9/aWicIzmQ7QN7EKgMH7GPO1g3UU4lFeKviGE4T3ckQ9Ao9IEjhTC?=
 =?us-ascii?Q?CRzit+RTXmzvWAdLw31TuVw1nPMlVvIKwKr3IgnFDUqB28iIf6XxiKPFHcpR?=
 =?us-ascii?Q?RNb3oJXxfQD8VP7pqdo7DT46NJDEpT32F3kWTU2Nqpi9v4VqmKHrb3OcPqAR?=
 =?us-ascii?Q?o996mUYsKcX522p/9eL1drzgB+zI/wwDWVZwSJ/wcY69VF92jPe3sedtngrq?=
 =?us-ascii?Q?noURLhpLBQ0JCZtOLJDSo9NopanU09mRlnnJqa2pdVLmlj51bVYKWX2YOwex?=
 =?us-ascii?Q?wNhja5MYUpbhirQKCByoWGwmCVQgFAYQaDrn8eb1YvEi1cseE7q2bMnzhQ6B?=
 =?us-ascii?Q?HmtXusc8SsYk6Q/JkWEdPj1MHu+0Ueh3oYcc1plQGqRMw6AREaJxCE+a9Ryd?=
 =?us-ascii?Q?Aguwc0KhMZ+jCsXbS8Ia3+o3d9uVCAhzPfEqyXiF6onbWr4Sh8N5Bk/8sAsT?=
 =?us-ascii?Q?EMR7f+J3ySgx1OZaIBIUb7Wazamq+5HTrMt2Dy+zfm+LuWZWYbpB5cqZRF/k?=
 =?us-ascii?Q?oYEGDllqfT/Fp/n/eFUcAqKeT3QGpu69s3yGvIAFr/s2QzFTluyPfSEZXE6W?=
 =?us-ascii?Q?KLHtki+lRZ6+De4MOCQnQaF8tO7p48jFTjBnBP4EqyUp7QD+wa1Nqr7svLkg?=
 =?us-ascii?Q?ifGNFaUKm9sYf+5merJm2QGkauOi6YopeER0500CEUm1FjTIgUWjPPqx2zSo?=
 =?us-ascii?Q?qyqbyxUl9dqNxY1I6v8IdhGr6za+YAOpEnGqDPl8D7pKaoxQt3Y67ZTt+FQF?=
 =?us-ascii?Q?Sbu0e0DuyCyIMsn0zvWntGPannYyfD2v0+DKQClu09ZDLCCqBUwSiMBNRPmO?=
 =?us-ascii?Q?2Pf9RJ+hWgLSwUdYPqqXiEM3bobIjrZhjKp03bCunqOSDo8mBuolWT5rJ8Kv?=
 =?us-ascii?Q?1EUefT/5zJFBkPtPeo8ZMDNQasZddeB8EwMq4dyphA7Ye3Btsbm07sOZKMWf?=
 =?us-ascii?Q?oCagUHyts5Umdwr1MmW4eob247RYjM8HptD1LWXeYoUpNslhxLdh9RhHAW/6?=
 =?us-ascii?Q?Lkfr44xluD59tneKT4u4EVW53jimcF8Fsz5VEc3vfQjFDCDAVucTWMbeJRyp?=
 =?us-ascii?Q?3PMprgs+wSyy0eJciEI1zGpTdrbVHuewfiHxdNhI8j2E1ybW7kRcgghHJEsU?=
 =?us-ascii?Q?Gu04INP0cyVwMdWR3mlZce0w91ib+fmetMRz/dicQmMMOiiS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62186b17-f0cf-450f-4522-08df144d38a0
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 23:50:00.5606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iXi3vLlbgLAd6sTwhaaBdzMatSeXqMjVvg9GJka+GbmlwmAK2Isddjr3Kg9bkF3Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9787

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

