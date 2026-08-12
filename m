Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0603314D1A;
	Wed, 12 Aug 2026 14:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786546768; cv=fail; b=dazMz05MUq8jvfjrobyrHDxeKytePuwgMJEGWBBMp27qMTxcTGLELmLND8y7q40zqZDC1xHJJIg8/px0Shc0ouXLhInkQivCVhHFYfBu8+RTk1PVr25K0r6DSIWSry3KCPQ8BHqvKWEM83qTcWZ+bwOpvV9IpaXFSdFhOGbz6Hw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786546768; c=relaxed/simple;
	bh=nROhSdID9rtuFbMhRBkvHRX3KWOs9SCSl14QS8T0ndA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RuLWc+Yerw+2y1ksQT0Cwh9IThWcAQO5Ps9/tcAWtLbQivSzSux5fp/6wKB578fta1/GZqe7rhcThKk6V8iSbnSjDbaepv1w1n5NdNPyKYYjtuKQ3PmC0OMgi8CVkf1IRaLNbDfxq3Ux2fOxCYTcYwPeCIHACCb6IZqmMG3qSHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ro5+JHo7; arc=fail smtp.client-ip=52.101.48.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ro5+JHo7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iMsvZ3XKsOE/YoIS68lSMwkeUoqm4Ja+YpaIqBA9EfnYZRx8nGeWYQKcFrNWaOtSPyQM/dnOzXt9rbQLE0uW2GWxsnjxuKcRv7XFLXrjbu89n6AyzahmQAD5ca9zKiD8h78ZiWt5bzvXN0cdi8Lm1aSPHb3v6thScQle/d4c4FMoYGy2WhmC2r237V9BaJYmbAXM0HmVNVKlpkR0A5Q3+rF0R6QB0Gsdiwy5Z/JsF3DkJNYS5q7xk0/qRH9EGoLQSjlTOQ/DrkgkFhti6Pb59AtRg9gX36k8RfKjiF1psLmST6TgaGbCAyVlMVqZGLJadZOP6+Y0mM5quMD9LXAVQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHlhszfoLcDO8N4YgMUHwbXPVKa0ql6Xjos2u9xf7QY=;
 b=GFBVuiaOdlDzUaLVLt72TU2QHe+iFJSDIAzm+sltGx1bLA//qeZ5EAC7kJPWKh0qCY9+2ci9nC6w9FSSboVrnKmSDd8lYGPXQFo3h8F4ZZQTI15XMS9N58N//0z0WLMczkZ+F1JvK9Pc5O5IRIV+E+FR3j+PzFyqsoKv7ORoYAqjn/05evgcPXwbclvXnJ0FCH28nCQL0be8ftcW57ld5WkaofckosSak6oe8aljVJxVscuijli1FVM2Be7YNwVP8MpYyykiTi5Ya5RFKvJ04+4PGskg3GH8bx4Eg+p35NZACshQNg+eL0WsOQYrdPeE0xWEks2HZ7e3p+EQJMzp7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHlhszfoLcDO8N4YgMUHwbXPVKa0ql6Xjos2u9xf7QY=;
 b=ro5+JHo7Wv5BgvFyUE8A/sLsI4AfaD+orYJu/X8KYNpUMPNZ0VDCMTQazidNwZbLOf8tC+ehDToa1P4shXZlT1Vl62b6CWCQTfUFpUiUNmziWmow6my8nXDMopHuadsXDUVkEpuP1VkFlprEmuA/lJB5MQ9HGAt7QzrRNKWJAhBY9nKTcTGhcWNDuMFH0ViHEyPNhXZ9VFsHcujcd0M+37GlhAJfTBhkd8MrG2e3RvOZ+41WByolvBIAHlrjDtfvTtvVQDU4+Qkz0Bbx91T+Y1yIhQWn6887rb53EU0tkcwpR8Cax7FYMulgriuBIOUUjl7UnaqogbOwgf3fgDNgBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9654.namprd12.prod.outlook.com (2603:10b6:930:ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Wed, 12 Aug
 2026 14:59:13 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 14:59:12 +0000
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
Subject: [PATCH v4 05/10] selftests: Add additional kernel functions to tools/include/
Date: Wed, 12 Aug 2026 11:59:03 -0300
Message-ID: <5-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN1PR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:408:e2::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9654:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f2d05d0-dc57-4b29-836c-08def88243ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|11063799006|10067099003|6133799003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	DQxyNKHvdadKnLguU34Ui8Zjk7zN7EfpvEzGxdEBasJl33x7D3PApI8N8jwKz5O9yrknM2oq9sn4SYHww1C8whJC8EuW30NQUgFcuVDC0BnSEUicBmxIslCwspUarNpes3LrxkEGRxZFJdz87g1ydbwkCd1H5IMqbUfSZBo/l8rGdMa0krTzvUGBZdsITRC5WSmPuFMzpJczBihioEkZjdjdxMmkUJ4Sb5jrFnl9+DA8Lt1MK2XzgJRWO5rlx2NVXov4xyKECpMy44wWRfuZ0N5LhFQP2DL1GHoUixPTvs79QrkBg9n4sqvg5SFrWqMPLBgp3Zj1MLb5qMQTFU6syEnWUNEt59AqACbMgLGWpUp0ggRelQQzHIbimU+0jyflHOy0ZyMGVI65Ki/4JQusN4S35Rr67ZMYI0Umo8CYfTXPEuKH8lphCJXNKZqbJHJGkxBc0k5ODP9hGUe+1bSyFh6VAl7spDPAwVzmRnpaqUw2kBhdsRd5GsEuH3aTUg4fGXvM1Yq8Es0sdQfpdDGu4DRl8FDTESZm5x/jkiRq7/AzaFLZdx8lw4mvRhmEgFhmEJc85KAQ/6HawDowUcrwQqk3ZB1gaRV9p+Ys+vQwr3RZ3mDuYJet/DCLobmTdfJtpC5TDDEQuPu5k29rjhrDP4qe3P9W9eZ+55dvIoB0rxOrXwpFzitRryfgsu1QKpdwIoUgHaWwp7Z5S7Cp3j9OpA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(11063799006)(10067099003)(6133799003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MI+N+p0JbjfINxUqUeAXdzL5DfrYO26jwknetYtkrMEfAp1j9XgkL/JA0E37?=
 =?us-ascii?Q?ipQnhihjNlZEjVDV3u9PHYx/LfHTQ2pdvO/0joFVTvZrDpe+kztrC8OxXL53?=
 =?us-ascii?Q?N8u0cldONEoGKthG9uAJXEJqyk8KyPL2EwHkMy/1KbkSXNp8jMmWC8tIcdie?=
 =?us-ascii?Q?A7ljxJYyPrb7KVlvXuZgakzbrcGq/RXxEqibOdA4Z/A/JU1VhjR3CKTuqbWC?=
 =?us-ascii?Q?hTaBu0tsivO6tGB4PFvgOppI26tj3Yu72A4/NXtAce+hAWn/ZGbo1yf961Yy?=
 =?us-ascii?Q?60mvxNjZGbVIsFld7SFVddMOfpe+uz236QKy54Jp2/OlMNRjV9Q+HPpFGuuk?=
 =?us-ascii?Q?vQNCrAvRQRKiW/1NXT/oUM+BK8axaQlQL4GzKKiwBiURYvPdW9tmjekw7vGU?=
 =?us-ascii?Q?+sRO+POo2PF2pkOygRWUbJTp3TkX+f3SzHcVQQfPgkWpuu251bSKguAhctZ0?=
 =?us-ascii?Q?OH89XwIWSrF3/5EcgBLgzZZKjoi2ZGQAxGsC4Kthg+/YAAAx1ElSeKSzh2QF?=
 =?us-ascii?Q?3N6nx1MCcrkxvxxGUNqfwW0zCccOZ+lg8kadwHhd8jgqBt2igtclk0XFBqmA?=
 =?us-ascii?Q?oLlSUqfCG8gs5KFkFZj/FSRDWkrZJfyfPsS2ms9B+MOGuIy1u2YDl8HEXu3b?=
 =?us-ascii?Q?dKCSewllohgkiQVmt/sE86JxZjAR1JZtdUZ4zaVfJhv5VCg9WCsoJOOF0bYw?=
 =?us-ascii?Q?IyTY8Uc6ZPNhbSobmR1wOpk0WP1xqQXCCd2XK+B94a1N+ibhiWT0qZorB5lk?=
 =?us-ascii?Q?5zhUfdHbv5tcEZWVWviDkVSHdmja2yLKFOICLp+5geK91h0YNCq/UWLneLar?=
 =?us-ascii?Q?BbqtqJi3lxuVVHYzsWJkunVEpus8uuKMx1GhJxunoCOCUrO7ACLIac2orIyP?=
 =?us-ascii?Q?2RM8/Z0Hdvr6sExLr88wLHwiuoGrD7h/7L3WJO/QOS7JGaWbLmDv1H9NKtSy?=
 =?us-ascii?Q?8QU4q6h7u26PXMsRb42W5AiGxcFCKsuLd5n/hp8ju+npqdNxzvk19nN2M81o?=
 =?us-ascii?Q?CM3qEIYQE/WxptpUogk3lZ2kXuPGlmWgC/W2bp/KqQjo7XO+HvJdMs6LCfFT?=
 =?us-ascii?Q?GiG7M6g256OnuGxuiyQH/T0c+mod+hONBuil0M/n7glcB96oWRMfzxTcbkKr?=
 =?us-ascii?Q?hJe0Tp/gtwn62+31Yo8cGbX8M2UQfU2i8O/8NbYfNTNqHRfpJ6APDjAaQOdI?=
 =?us-ascii?Q?e17OoH6iZF5auDYkbS92sq2aH5TBAdCqJNkA4fXHMdxStch1RVUxKXEJI3wX?=
 =?us-ascii?Q?JvqJ6vVT2wo8owcskyIHCMwS+LeFTXFAeP6h/zvrK9Lk8RBFDpwoCg8j4XsU?=
 =?us-ascii?Q?fatUsGzCchRBEG++Ogb9TLusrCIhzf8VDzFkHXHUMjogaW3QK6kuo++ZGwmO?=
 =?us-ascii?Q?ujdfZTplfCBHUxTBS3VjW9/GW/PSAHWun72kvLMTmrk9hA/OvqZzCNOY+fIc?=
 =?us-ascii?Q?d7es32eSW7qKHQdApGu1oszrn9Bcf+y4r6hQxkZ0ubwDG45rhr5b5WopiBA3?=
 =?us-ascii?Q?W8xA5YU/K26oV82EStw+/VtegkiQIuIm2gJUgitNIwlnc85lWZRHcV2I6V0W?=
 =?us-ascii?Q?V2DdzfLgoyYWHbAy5Tgot4rfmqQCvbJ43ao+TPTmfAAep8yc8W6GaxSyJUWc?=
 =?us-ascii?Q?1S9UWe8fnrCadaRGjaIF9dIShmfuObzZ5ZZFI8+Bi+5wvowy/4l3uPBsSiJV?=
 =?us-ascii?Q?mVE1WWsl3DBhchoUGlFPJqNApedxo4uHtxLuSf6Z0Kit6nJnCkgbTUBxCMVZ?=
 =?us-ascii?Q?od6vTEXwOQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f2d05d0-dc57-4b29-836c-08def88243ad
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 14:59:10.0577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cHswYSNThuIkXQcEPH70JkEd5XMWOr4JLRRTRnxOkWB9XUJ1a76Sx2Xl1dM59TxU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9654

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

