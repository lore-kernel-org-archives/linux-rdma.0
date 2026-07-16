Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012037.outbound.protection.outlook.com [40.93.195.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720A443B494;
	Thu, 16 Jul 2026 17:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784221427; cv=fail; b=ufU/42i03JoBHm1WJAZEoLbw/EXXZipMp4ev0oyHJZuSP219vgb57jcHIoCIkV2dsrYeZgmelVm64RDkZec8iK5owhTCgzS5jTTs9KcUXZBqp90b+jcyEh2cSSyqJIoNOt8zsSqe6HoKJj3pmHEo2fxEMODAWoRwMdLg5uKTA6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784221427; c=relaxed/simple;
	bh=g20GflVCdMtlCOP29hXHw30Wj7pUiGVoQ4SVMnedTXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Idpavwg95v2+QdYPc8fTZefg52yk2dgtfhYLigKl9884FROqa1Q2DWGBnffuXR633W/aMyTFPrzT2fVb8V1dejYmQfjvSZ/XboIdJMqE86Qm9eFOQ3Aora57n5YfOQK/jO4D4mj8tbRKegOSk6ry7XGcr7FGLpZ7uhc/Mb1QxrU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=s5zSYC/e; arc=fail smtp.client-ip=40.93.195.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s5zSYC/e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ppqw0RT7oNvj/sFQ201ITCxl14vAIJH3YCRUdnBooxjVbHPEtJe+Ai29zjto08X8wyxunUrtqsAAbEVTuBFflP5wGwxqQcJAFpXoGVFzKQ0FJsoVCWZny7pOinoFHuxhAR0dSpbgcCigUw3xOpegCvGK236WZ0QXxq+2tsJkBmNpqH/HqXWntHMCmFJZDCCFj5qSJw92KnkNUDsBVAzfZiT+RtqbG2s2ibKQ3vZh5ELHcUxO1Yb45ioS7afNdKqsQQ8uWA6/HOoxAu6hASnizJ4adQQYHv8hx9OkiiYyx8aG8UCMyZe+jswBdn0ene/6223Llo0caotONKzuvu8fEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKufnMG3CmHwZo9Vt58rtWA9hvjBV0WMkWJZ+4Mi1YI=;
 b=QNcA2eIBPNWpEtc0VOSygysD8W7BazkZh4HlKhX5OjIT8UDWzmIsU8vqAsoL2Hq1mp0kZxj6Wh55z7uqLioe47bPLzi5uDFQ9ni/KHyKSQQD4jaz9RpwzoHCtig0ET7FQ3ONxmfqtvVHJabDXi56Se04W7hVJpfWx7iXrDw/1FqtTdz1JJbkzIT8WU6ECf4WEmEi697IPgtNiDcpcvkhHESXsdnBPB8Rc21LpsR/rf1krT78ZWE1Y09Nh+HuwwRNzb/oSxFQ3Zk7X6KPiRq06jbkX3nrikY9m5fp01rFocaDR4CWGgARcyWE8rJGqVijDdYxi3G6LI4doHF+VvU4fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKufnMG3CmHwZo9Vt58rtWA9hvjBV0WMkWJZ+4Mi1YI=;
 b=s5zSYC/eFTHvEbahtTQ0zTQcFvV/r9MSAzcArBLCduEH+cr5tNHgkPdZAiWcRpFIT7wLjQvPagQ+9ybCaw/p3bMN51zHkAKApaOToEYKhGxGOnEpffkXlqfPjTPrrAtuNvHraTClEjYj8pXG2Oo6XIap2qALzmvliO1DVWf23TnPpFQ5keEFcg7TTj0eZT4Ww0979Z6/jCvSaYeCU+IhB34p9V7JO/QoAjjU8dn4u6Sqk5hkuswBOfeabA/I1QHgzhuNNZiIltzeSVnWXs51JRSdzfY5JZ/FlYRJwaT7F/DjGpmQaHQxAXRcSDPEa0t7QYX397bBV7d3ZqF1DxCZBA==
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
Subject: [PATCH v3 06/11] selftests: Fix arm64 IO barriers to match kernel
Date: Thu, 16 Jul 2026 14:03:22 -0300
Message-ID: <6-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0027.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::13) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: 6601fe98-d325-415c-4d06-08dee35c2984
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|3023799007|11063799006|10067099003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ENf7WkAL/A20WuiaJZMWjE+PuUCcK385lp7BsRdcDMOjDgquh2XfGvNfsaqExOjEjlowuR8OlVAUjvutOpokJ3RgW5/8uOHuU5jLJfDuUqxKe4iRkaJIC2Ep6zwbnCrmQ6edb5l1gWZ7CwFg4umzqKVTgkFc2jONJ6lvVVOTPZcp5Is3dFrMsSxOYLhFPjFXn62EpWR64fyeFGTk4ZtDGDBRHE1WUgeS9dCt1R4uDM6Zxl15l9+n5CVZHAgVDv75MPyzVGYWHqvSXZ+O9hLG6m99A2izL5hMiVKi25PdmIRnHCczE2e/HptZGBn36O/Wu2hNisaeHB6ryhn0yefY4w1R3JMQQGguFpJto2yyZBYBSsF6+5eVTJ0nu47gL57ZSLrsJxlSaIeQgY0D4Jbdt739yeHP1YfLEj5kOx8aa4cM3g+u0+sdOMgWLTO1VlqaMigQul4SCc3eAXKFtofQ4ieitGGyz2DkC9bx9NTYklgtYtAlxRFkMBJH5kZa8wNphSBAgQEu7vATZc57QSZr85gDCCrsayqA61HziHUFrvxLCZcUsg48f9N47YKRpxVFKrbq8udpgeJY5ms6N565ZcqWVst9HuZpNCBO80dZKC1SqU5/bJyCDL2sfnruY6Fw8hoD0NnaiQerseTkw/+dP51GR35O1AYi2CfVG4HqMtPDn6ejlZwEH4nXwyXfK54DdrhJBDDAok8c/tAyZ1QBCw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(3023799007)(11063799006)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QUzI2xowqqyykQy7PqWCXkYWTI0k9O1XYOdLhG4fwYWssFPSa77DJB7AfksS?=
 =?us-ascii?Q?u+kkoHyGZ0aopdhdqY+SSMdnzD5P058NHDRCdCg/vHyDHvWAfehs7wWvR2CX?=
 =?us-ascii?Q?/+1SbQ1hu31jiEMLLVYUvd2CQP0K2UfpyyKtSRaWnu8tqRBLUbDsclvSWFgZ?=
 =?us-ascii?Q?4mXzzKJt0/cvaoJ7kOzn5yaxjoeOf6bomw5WG3Vka2dO7VvLrE+Imezj7Ouc?=
 =?us-ascii?Q?VRgJ/R9FRgtiJkHhYn3Xarjoo6tHnqzu5VvGyqchd/RtuWKHUV5Ez8IfXHMf?=
 =?us-ascii?Q?Gc2ovqeE387bHADCheKIXEAk+1OUzXUNWvZEoX0T7+u/Ui7YxUfib7c+6YRY?=
 =?us-ascii?Q?jdJTd5AOynXZn+3ktAO8wHN8aAcONotm7L00FOCxdOAe6Cz4180mGxhoTpMa?=
 =?us-ascii?Q?jbzi9czq11arW1ziXT6r0htSYscO9sIWvpLhHiKpCDhI4RSxGbXXdfw9804Q?=
 =?us-ascii?Q?L/X4U57Z7vmfAF6MDZ+yzdTlJXJ8TXelDKKbHb5/7yoTIQB+CIq4480FGAjj?=
 =?us-ascii?Q?jcHYL5S1krGkbJL8LR843ebIGe0AKFfjHqWIkORNxk8eOUr58qcd2rT4Nljj?=
 =?us-ascii?Q?PnXmHnNnz+jVFq2oe3aOpNl8+ULwRsHQZ0MNu5aLKeQ5jsy/xs34jj0Rkyut?=
 =?us-ascii?Q?DPDB2MCymEMiDoo+KCx7P4wkybtdVgLOgegPsUEkqDgzIGo8oPVjKYFEuKrl?=
 =?us-ascii?Q?FD7mJVlfPuZGzTfkuk/4k1nDMl0385+Vn9T5iSL5DkRZGGMy2L0i3tkhFLnJ?=
 =?us-ascii?Q?e9h9ZbrkRDioJKIGL4DB+9Vc4Lb6L9lWXNrwX/BXOPCvPrc9c3iWcgdlYmlP?=
 =?us-ascii?Q?YK7Jqz6hivGJlqdsIXV721EfU5MdZYJ1/2uRGX/e+qz4NZUMSf17w5aVZ499?=
 =?us-ascii?Q?HlPtgm+nDwmAoJhApvBVOmnv/fJ//yuQ/wxL2KTP7ZOx63gaM1ChaPJndUKB?=
 =?us-ascii?Q?Ea7q5Q5K6dOWpVmkmKqJTbtw9d40nTLDC0FEla02MqONO2bL+64AlldVns+4?=
 =?us-ascii?Q?d/a06DlTOcdFity/V0alDlJEDcD5Jg1xezeIXTZs5+wdQS3g8RpBO1j9P1ZR?=
 =?us-ascii?Q?pD6AYbFRTBhFn4/zi3FdUWdMpwSA3MzcvoWD58IPwpLmL6azi5952wGgBMfl?=
 =?us-ascii?Q?vx1810UOZVSDCUJ37Y9iy5Ol1tmZASAdV3tBZDHruJKzS8RU19f/sUEv0S9T?=
 =?us-ascii?Q?WK9SkdxWZlYiHDVM8LrGJ4y2jSgwMUM4xu2vv2wxz0fdCIQZRokIE31yagNa?=
 =?us-ascii?Q?70V4DwmtzMbtn/+RraBucJlLJuAv19b7OoKXoOrN473g1tpumWqGchk1yDeM?=
 =?us-ascii?Q?O1E14aOg07VDxlIEXAVSvYGDNs+cnM+nR42dEPUVD/LFtpxufvvOtg7s0jRT?=
 =?us-ascii?Q?zdORIyX/Kx5ldUlpA+YsNkTzpcqgbZuM6rx68EyvQ90GtYBflgn+H8qWOFwu?=
 =?us-ascii?Q?DGQwis0toPw4Rcb1G1l/S6beSvk+UB9iQoTrjFJf/sZmTzc1mwWYYV0xy5fQ?=
 =?us-ascii?Q?MpgkEd3JejCDkWWomPAp2rIS/Copryg0betkRNkIGJVm6yEAiBX5dDoOpluE?=
 =?us-ascii?Q?HeAiHX7IsbaYlKFeCfqUGxXRECuJJUpU8ikP02nMDOLdSmQw7RjcArazzwXO?=
 =?us-ascii?Q?c+Q530GvBCwIVc1MzsuCZbsAPf7wS3RYF6OCFIARuF06tWHZWoTAZswdaREF?=
 =?us-ascii?Q?1zwce+JJCDfqezVSi8kbNthd3D1J366/g9iK/N6uiqVy4N0P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6601fe98-d325-415c-4d06-08dee35c2984
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 17:03:30.7448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jmetoMYqqvXK8aFmg9oTnI4FjRwEFpv5NbTII/LQ02rLRJ147Z+RKbRF55wB6Z7O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6216

The tools/include readl/writel MMIO accessors on arm64 use
inner-shareable barriers (dmb ish) while the kernel uses
outer-shareable (dmb osh).  Fix them to match.

Add __io_bw() and __io_ar() definitions matching the kernel's
arch/arm64/include/asm/io.h, including the dummy control dependency
in __io_ar() that orders MMIO reads against all subsequent
instructions.

Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 tools/arch/arm64/include/asm/io.h | 20 ++++++++++++++++++++
 tools/include/asm/io.h            |  2 ++
 tools/testing/selftests/lib.mk    |  5 +++++
 3 files changed, 27 insertions(+)
 create mode 100644 tools/arch/arm64/include/asm/io.h

diff --git a/tools/arch/arm64/include/asm/io.h b/tools/arch/arm64/include/asm/io.h
new file mode 100644
index 00000000000000..0d38f75a477682
--- /dev/null
+++ b/tools/arch/arm64/include/asm/io.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TOOLS_ASM_ARM64_IO_H
+#define _TOOLS_ASM_ARM64_IO_H
+
+#define __io_bw()	dma_wmb()
+#define __io_ar(v)							\
+({									\
+	unsigned long tmp;						\
+									\
+	dma_rmb();							\
+									\
+	asm volatile("eor	%0, %1, %1\n"				\
+		     "cbnz	%0, ."					\
+		     : "=r" (tmp) : "r" ((unsigned long)(v))		\
+		     : "memory");					\
+})
+
+#include <asm-generic/io.h>
+
+#endif /* _TOOLS_ASM_ARM64_IO_H */
diff --git a/tools/include/asm/io.h b/tools/include/asm/io.h
index eed5066f25c450..1090a2c387f40d 100644
--- a/tools/include/asm/io.h
+++ b/tools/include/asm/io.h
@@ -4,6 +4,8 @@
 
 #if defined(__i386__) || defined(__x86_64__)
 #include "../../arch/x86/include/asm/io.h"
+#elif defined(__aarch64__)
+#include "../../arch/arm64/include/asm/io.h"
 #else
 #include <asm-generic/io.h>
 #endif
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index f02cc8a2e4ae32..fdd22df9174b88 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -5,9 +5,14 @@ ifneq ($(filter %/,$(LLVM)),)
 LLVM_PREFIX := $(LLVM)
 else ifneq ($(filter -%,$(LLVM)),)
 LLVM_SUFFIX := $(LLVM)
+else ifneq ($(LLVM),1)
+$(error Invalid value for LLVM, see Documentation/kbuild/llvm.rst)
 endif
 
 CLANG := $(LLVM_PREFIX)clang$(LLVM_SUFFIX)
+LD := $(LLVM_PREFIX)ld.lld$(LLVM_SUFFIX)
+# Selftests link through $(CC), so point clang at the LLVM linker.
+LDFLAGS += --ld-path=$(LD)
 
 CLANG_TARGET_FLAGS_arm          := arm-linux-gnueabi
 CLANG_TARGET_FLAGS_arm64        := aarch64-linux-gnu
-- 
2.43.0

