Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012037.outbound.protection.outlook.com [40.93.195.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B694A43847E;
	Thu, 16 Jul 2026 17:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784221425; cv=fail; b=HZ7eVHaM+7NZUweDacuHUH8koCPNf7DvS3ArupQgOqik35vuuSiNGcGaY3j4t8r8JTM9zuTarCXyakM5zVV+rGQGZAEUAaoei71kROmiSgIFJkNh4KU/4r4byuCQLQrR0hVsc85ll6rdOmPCIN0VuU/yPojBHWOqon6KnqbKeOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784221425; c=relaxed/simple;
	bh=nROhSdID9rtuFbMhRBkvHRX3KWOs9SCSl14QS8T0ndA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T19t3y86I2anUrCID/TUpq41wFJ/RPxD26yLMrQyHhxw9yel0t04EWhhoB/BL/2p49IwwrAi9o8fedG0uxg5RJgzeaq5ZEzf1/M0ZP7hHtxwt0jIzJB+luoh1iRLcvLW/KRtEG8azLL40/lU4DI4hbFl6zfLNlGeGMdMciC7T/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B3bgcA7R; arc=fail smtp.client-ip=40.93.195.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B3bgcA7R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GvVVvlQVxqXy+WcpykRcXEdCpquypuXf+KWsZbD2sQTAUtDgiaJFWCfWbZdefisUfG1PJvSrrA+b92bMWDY/ErtHYIGbGryGsGf6hwGNVYWC41HYuEsBjYWkJtfl5lzuxDGWYtvsC8tn/oQ9Pz1txxUwHtPvVUaXM55tokKeXoqamjoL0ZjAnYxNwRBoLfyhbDuohZe+H5ODRPtdUAHu4ibZs72j1qJyA6W+B+P5M5PPfWrnZiawOY0M23nj6YykJDXc59cnFlcx+cDZk/Cxcg0lacY53W5vg8L0DgqdOIU2ZdCm4SBbwXfTXlM+6PWgPImL9pT/1ayi7T20Kunnqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHlhszfoLcDO8N4YgMUHwbXPVKa0ql6Xjos2u9xf7QY=;
 b=UhOPYdgMkaZaU5crsbLSRFJSCoyb/mzSdbvkmyUOmeVXDMqEnxv93mDdqBELKmg45HKHVt/3Bwdqjsal1BbyiQcwi+NCgBVilAj6Z8oxGkODDVk/i0vjnCUQzKXkLv4U7S63RLAvqokV7j21Cq/jTpw847iNn/g48La5zy5oQBKND3PMlCb4jTKFCPxG1uIb+2UE0uGTLrZXGKZTr9qt5THb3SJinTdqfIWaD4oJfC0OKqAe63mCFAI5SVIcJhWCImb64WmHfruyDWMY4FMt9FyR2exrlGML+FdFazh0T0k2gpnaLWKjRVb2W+goNuTkTk0GdtkQlBmXYe8CeIGYlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHlhszfoLcDO8N4YgMUHwbXPVKa0ql6Xjos2u9xf7QY=;
 b=B3bgcA7Rk63lHkIQ/9vyTkXCWl0DrtvDHJ0xfvEmiOLktcTyTcQAyiXgv9N0HEGZlAaaa9n19Fz0PxMlTtVn7UzsmAkRMehrx+v/07BXLDkayGg361X+aiZ2J8v36miWbi8BawN81jDLM7FrAAPKh5DmCWcEINXSlyhDCI1Cq2ZgKxZEo6fvZGzBrxcLaMVHYLui+RWZlGgXvdZyuqWqH14T/VBbJfC0q2YlxGZghlDNFk4L6WcBfAEECB3ZZNTvjHEkDl3u6zunZKaOSSMviRH9hgLaEZYs4zVP/iwccCdo+1xIlhi1USepG3yq9fq9yJrkoTjWao9knqEV61XHZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB6216.namprd12.prod.outlook.com (2603:10b6:8:94::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.12; Thu, 16 Jul 2026 17:03:32 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Thu, 16 Jul 2026
 17:03:32 +0000
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
Subject: [PATCH v3 05/11] selftests: Add additional kernel functions to tools/include/
Date: Thu, 16 Jul 2026 14:03:21 -0300
Message-ID: <5-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::14) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: e5a62b2e-ff62-41bb-1017-08dee35c28f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|11063799006|10067099003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Rl6jFtMqfb79lzwMg3WHpNBG/6JY1q48GdlcvwLA09nxjoodPSbqelEP2vVxO8vcRvd1rWxLt1f8t6ecI2f9D4+u5BXDSiNm7aQD5HQgXcIl+owDcnXtqQ7Sylfi8upR53tANBKqObf7o7gEKOMyD4vxazVQKH8J6UHERjSfX+hvy1GlXRVMOxzJE+F7LMy3fxqzOP8PWgpAefLm15LG1f/4N392JjpeH26Vhzd2WUpFH2v7TNQqTmmNBvnoYLVFs882Mpb2eRMTVMogvjIcId0eBUHjErl5JrQ0xXY0TuZ2nLFC+EO9oulhw7AM1aN1zc3fAy1n3EnBG+ln05x93O3vIfFWEq+zQQBY2fcFcH+YKiUwonAS7sbFkNRNmph2/NHOozsZb5/9E8XHyHvmflYkxvHknDHNdBmydVNJiACo4voDq3/8OBza+nXRApKGULUsrAKrIhOk/OeffJU2dUCM150GpC4oxpiPKFuA104V7G60/JCm2qb6kqP2GigHd7MFyNe0lUGTcz/lSVxkeLg9FILIBpLRMSDmqyjK6OvCQdXy9+jcUCyte/wM56Lg+Lx/22TwwjTm+IJcF3p6MSSgUko92Vc/AeB6aio9RwvXzezR6d7zEa1lnmCiQ1TkWS1L7lMbB6EU5Kky0FvAG2vanv/ozKY0YPRqoLrZbs2CHRh34KNHzC46UI7oIs72ly2xxMn7ifUm2W28TX4rSg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(11063799006)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pl32ZRJOuAIABsDYYUiZ/4x+jK9ayYeYz60xwLsv5AhZv7toBmid+WOMn5me?=
 =?us-ascii?Q?Az8H80UaiHVcpL74K0ftOEFGO0+KSgrYDxpPez4NeGVtHt+GKHcHOuSNIX4L?=
 =?us-ascii?Q?Z/U+zQLfiX0pW4FEojW0BUYHB/EMlBI6xyS2W72gsOoRsg6IgWMYLAZDSPqK?=
 =?us-ascii?Q?EEofZF2LjymYyGmRBaFELw80Xt6+ourITtWdmQORw6jozisAMTmHhAt+bI9X?=
 =?us-ascii?Q?B+O4c9Zc6+p6veG6WqlJA752uivmxiPly2SOJFz0hNbp36EH52tD8i6a98VN?=
 =?us-ascii?Q?piY0YgzM0Fih0nrd8SluyX8iVqQTd0AmE+jjdYmQlr+usX1kJwScV5jr3Rm+?=
 =?us-ascii?Q?n9DDacN47alrsFdB+ntcS0D9kbQXhLBX6u6JS31lqPfJnCFHPpWG8zoKA3Hl?=
 =?us-ascii?Q?JhkfuqgAR2Amrz+1t0yj1JatOTQqIUOUS6tU8YQodz3uBrD0MXHEKwUIoOfp?=
 =?us-ascii?Q?MTKR+DXeI2seGgRBhOnewwUtyzXtMakzrr7Zvn89OqJ11dKyE1k85Fr1Ebgb?=
 =?us-ascii?Q?ajrSiyqGPP8pov3OelCtqdSm59fiJy2TpyyfMGfCkp9JCO6gVHbvsWfcUIck?=
 =?us-ascii?Q?DVpHWNJ/LpyyZI4KnJvl8bK94qfx2tt4z6rerZjMu8Wr2XqtYCRBzz0YNSnT?=
 =?us-ascii?Q?OfgmsgQyV0OIWTkIt7gHie4vnrIOSBq5IcZd/2LXCXL3bhq1awfJLG1AHlRz?=
 =?us-ascii?Q?As1NQHj81yiE7phyDY54dJv2on3yH2N1Ehjvbe0SA46qB2tqNYhcde7bqfiU?=
 =?us-ascii?Q?A/I6vegbHCvw9zX52LTABtJOcro1pxYolPIn8bALRsFx/yD85luYsWXbqbGU?=
 =?us-ascii?Q?8T0rzBzZPZHcJNvmZ+ECnh0olInRz2C0vcCUPEZGGoxPDxIH1cnoOOYraIer?=
 =?us-ascii?Q?TrawNJdIlEdAoX+mx+5iEslL2yERbNk810tIKTaNjflBwX4dDiGbVzTNWc4l?=
 =?us-ascii?Q?cocZJOEIcxbxUv2ePBxIY9z9Olz3sUDg/+pRZQjoukjFCglbSJo5+fsewUE8?=
 =?us-ascii?Q?3J004p6oj9+G74JGGi6wK8Ihf7c8Qi/xr1PtIp+M8HzgFLsKuuEvHtmQE84w?=
 =?us-ascii?Q?BNHEIvLo841YE5d3TSfrWsAUE7dNrAdJI707jg2+BLyJgOMX09f2t0F61nEF?=
 =?us-ascii?Q?uhTZfkTlS8tHvP5QX2oT7shO0dvv+TftHlJOtpcPOAkYG0XffhmSipFZmOk7?=
 =?us-ascii?Q?cRESUn3DMFPUC8SUO347n2Dg51pAA5NNp8Y1C0x2j3PWZfHYbj4KYg7bbqbQ?=
 =?us-ascii?Q?cJeuswWpkqEgRXaY7gB1h2T8c8sdzEVoALg0MpRS3JAAuvGGRuQ9Nhjc8Rcz?=
 =?us-ascii?Q?4UrCxym9G5lP7xmfrrCy5czsBMh5Q/TEnsulfNSBr+rLrwZWVEGrDFuXaJJi?=
 =?us-ascii?Q?AF0FpvhxAw+CM1+YlivwqsuKDxwmHXRtc1wHfHOuAIu1BHlLDMO+SaRrgP1A?=
 =?us-ascii?Q?RS+NTnfjHha2qyvdTWcQqbI6rXSLIhxHJSv6SnObeYexm3QSQZdpp2NO+IOy?=
 =?us-ascii?Q?WgXCYuPpqHkq1ScK+9GWETw2MjfqXPzyzDfymSSlYHHivN8X3PRABvjAaodQ?=
 =?us-ascii?Q?IEFu9TXeYX/mhtqJH9/W8R6h0rSTgbYzPuDsmM1FcXjNPRLdwyYWOOVsMHcL?=
 =?us-ascii?Q?fixmq35umAXBrNj6/2Fq8DHpc1r0hWd/n47+1KHlkvvoXoeXfns4zh/soO6c?=
 =?us-ascii?Q?OBOGe8bE0ryqGBwt0P/n5ghmSlokLfP7rWge84pDAYEI7sD+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5a62b2e-ff62-41bb-1017-08dee35c28f5
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 17:03:30.0801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NPndnPqFfd4dR2QvHDeMZKuGDOAoforqTQDS81b41WBeP4/ix/C8saWwmZykcV61
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6216

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

