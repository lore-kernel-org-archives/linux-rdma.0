Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11022074.outbound.protection.outlook.com [40.107.209.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F3D345EAA
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 16:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785772991; cv=fail; b=ag2rQ3jw9yA+Q4H/00CL0KL+mtDF6S4tWoEfgiBP1hLQY/EAu7YkfEWNtfIrCSV58W5tiKdHJtE1seEr+jDA138WwW/aRshzNEpS1m843fJsWOwmKudWBZ7LM1NseDkdnh7wvob6WzkglxAs2SDmjG998NZDa9MRABzRVBj0qDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785772991; c=relaxed/simple;
	bh=lNKK+746xckFqHpEbJu2uvekFyLVTXVIIvtA4KXHXU4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DZlXgnIJqmqIGHNADdmXDHU8a1QuMzDs1c3lRU758HIlXlnaRb3mg1YRNv3D34BF4rLXV/VPZQp6qm1PEGQ06JDsksyggJPBZDTeSP45G+c2/atnhOeu8lOxMbdFi2aIxawkTUFPdqfadF+15QsnX3uNPQR02k01q0EO49Y864I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=U7k0i6pG; arc=fail smtp.client-ip=40.107.209.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="U7k0i6pG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E3rHBELJIbVsXU+b7kjtkF2/xfmMqBX5VPhuL+JqReXsL3anJ9vT1aqmnPXo8JOx1Z0U7diTgUYLZjeK/ezmt1kT0TN825s3eZsuC67tVZIJsbP8i4D7dJLx+szvp/NlyK6zze1lMh9FZD0c/tVOcz78GhlZdUczBWptbwO8LDQXR2p70zRLB7rJyRyLcsTcpPe/NIMV1Urqa24c0FttBAW9q5OQnpVL5tgwTZZVL4/EITr12+KsRZ2/mtcR8DdZ2YuGEPP31Vjc3mk5UhbGmLl98BT4A10qlDCWHYqR6JVbX9DyY4eonxfguaNMoIFiZ8WFfAKc1sJbcWfA2lq8xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWbeAzHrBbrkyDUYGc3FlNYNJGrRRVhB4QedK5GP4OI=;
 b=Y3ElV7z9MQZSVCX1MjlUaBoU5H8fMivqeqYm/eEYaZs3OB5G8TIW+j5z+gQgBwCW6jIgA+5o/6oeeZxuu8M/3NXdO9nXCYpZlLwoa4GFE2hM/zDuMKe+icHVV8ymq4UDPGP46Ei18iljaJDddqny0vdZGKo2cFC8kOJ1y0ITr94ZqNzwFjcEFcRzyZhAMTm4Pgs9jCzLd2JfpVaocM3mOEz7R97K5wyIWneoJ+rbUiLZvNcxNj4YgfSi34q6e1s89C7to1CdstWrZgpA2LvJ+e99OEGIa2C5hEQNH2s9oL7wnbmBGTiUyNPsQYfqT6H0wpkBMuVQPP3qKz5+bJBwyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 208.255.156.42) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWbeAzHrBbrkyDUYGc3FlNYNJGrRRVhB4QedK5GP4OI=;
 b=U7k0i6pGSvPjFdNwuNWO32kV1e4XMgn0ze+0P14VS5lGnzuIH3Q4psy2Hpt3XbqMTv0oJhQ6g3z2BT1QDcXhzApcHIy0KGVpJpGet+Qe3BM2JfJOYHqc94b7jcmLYLAaRYfj4XkIccXlniNLoRPfl3S8+MzyVy6/mNFE7HZ8tc8iQGNVbAfMBCafy/8uIyfoQMvIv32RAAeClc50lHDTo5krYUhOOu5NEudPTOh+qIWq6T/ypkPL7fgmxi+YdvUisRcQQ7Yr0XEl09eDkqr5/qecVa3+ueLYXfySElHethSWldTpEWfyjGTBdPBzGABjSR9K846lkAxAFp5Fsdh9WA==
Received: from MW4P223CA0027.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::32)
 by SA1PR01MB8109.prod.exchangelabs.com (2603:10b6:806:326::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.18; Mon, 3 Aug 2026 16:03:02 +0000
Received: from MW1PEPF0001615A.namprd21.prod.outlook.com
 (2603:10b6:303:80:cafe::50) by MW4P223CA0027.outlook.office365.com
 (2603:10b6:303:80::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Mon, 3
 Aug 2026 16:03:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 208.255.156.42)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cornelisnetworks.com;
Received-SPF: Pass (protection.outlook.com: domain of cornelisnetworks.com
 designates 208.255.156.42 as permitted sender)
 receiver=protection.outlook.com; client-ip=208.255.156.42;
 helo=cn-mailer-00.localdomain; pr=C
Received: from cn-mailer-00.localdomain (208.255.156.42) by
 MW1PEPF0001615A.mail.protection.outlook.com (10.167.249.85) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.0
 via Frontend Transport; Mon, 3 Aug 2026 16:03:01 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id AF1411BD847;
	Mon,  3 Aug 2026 12:02:59 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id AA7631810DF01;
	Mon,  3 Aug 2026 12:02:59 -0400 (EDT)
Subject: [PATCH v3 for-next 22/24] RDMA/hfi2: Make it build and add TODO list
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org
Date: Mon, 03 Aug 2026 12:02:59 -0400
Message-ID: <178577297964.1792062.5385248730559737249.stgit@awdrv-04>
In-Reply-To: <178577280181.1792062.14134152769069940570.stgit@awdrv-04>
References: <178577280181.1792062.14134152769069940570.stgit@awdrv-04>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW1PEPF0001615A:EE_|SA1PR01MB8109:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cee5732-0412-479d-3aa5-08def178b205
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|1800799024|376014|56012099006|10067099003|3023799007|6133799003|55112099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	zTChGBJ4q7itMc5K+pEXSEZ6QuLjfRv8oAjeE1TB+66PiJ9TchDMqJLHSpj21YSUDsH96AJXTK0EKWlhLE6/24Bz+F4NgNSFEwkgtQReqBU/l6cZryJ3q3nB8HKvijLRHisCk0VOX31kCpHGNSqcf996f2G6oh2U8MVTdUP0mKFyZOZ9RqxBTAtFFxjJ/VdNQYqE82S/KoGbCPLvmlYn3cvdINiZVf3ftK22XJdQ29eZj/nDoZHxfaLMBW7MXDK1gxUBWc4rodhSlIPqsuvf+Brbe5QZnjSv+MEtW7p1tcAb6jxfKA0xJloIcZ/8ttGHm/JCuq1mPj+HFf6yD/Rf31q9bdi30O4caFK5ObyZ2ZpiLX/LpYWTTGRCv/7vHQ6bQah/45W4vtpaqQt0BreKDuTLMK87ftVv/pBj/gfQdFb3TtfkVnAGNbLW5tH44W1k/BM6Xhh4+G9aq3Bf25i+5nCHcZ9QuVV6ub3Nw02FmCpCKnLtGh9KdxhH2fghcZSs6Ku4gvDJ0+XDaDbJF5b4hsA2E2nq1mf2CC7aXj/rqogCwrHx8pQ5VWselprv4UTgA1aPaZ5Ir8GRN7WD6pcd0WS9ki+0km7q72RJwfifA/J/YnGGL2nlLRaietgX8it8tG1phdhUPBte9qDjrGGo8e1uTM0n/ZTKXJi9L4M3VaIWQFX0Da0fcesJqBRzegEbNAN+s0lyjCcaeFEuxjRrww==
X-Forefront-Antispam-Report:
	CIP:208.255.156.42;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(1800799024)(376014)(56012099006)(10067099003)(3023799007)(6133799003)(55112099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WEIwqnUqRYa3M6pbwuupB2ZN25Qa+DaNYzmoOya3Py7pzLzgygqlM8qmOYlanN0XhLTJFR657ZyHXE9/UbyA5NfW4PQ8v+GyreFnUlC46z7qQJgArSOzpGSHqWHk7LbZsEpKDrUJiaTsU05iPc4zYzv+IkI/onVx8iPT3I7lraZEFPgly2uA6u096XVwYl1QWeS80snl+H4t3/RbZP5ld2gswhQX3eIG8+TZu6pSsI2k8fqBsVqIc7HvRL16LndyXAa0ASd6Obm2oUpvVkaQzQRqSdO87VbTII8XgyPjaKsPA2sPetVceo/K5EacUiXIxZFBajx1Nt5j2kUfZEzo7Imhh1naA1jg7KYx//8IqKC15v0ADy7pYCTvTcC26AEFo8e4RSLwdaVf4F9aJ46n+hiR+WThkIb6N2KIZrbCIEwhrpkJjKFBN9kXq7BWeEaJ
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 16:03:01.5599
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cee5732-0412-479d-3aa5-08def178b205
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[208.255.156.42];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF0001615A.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB8109

Fix various compilation errors found when building the full driver for
the first time: correct kzalloc_obj() dereference calls throughout,
fix miscellaneous type and reference errors across multiple files, and
update Kconfig entries for both hfi1 (Gen1/WFR) and hfi2 (Gen2/JKR)
to clarify hardware scope. Also add a TODO list file.

Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
  Changes since v2:
  - Add hfi2 to kernel build system: add 'source' line to
    drivers/infiniband/Kconfig and 'obj-$(CONFIG_INFINIBAND_HFI2)' to
    drivers/infiniband/hw/Makefile so 'make M=drivers/infiniband/hw/hfi2'
    produces hfi2.ko.
  - uverbs.c: remove old mmap entry before overwriting in
    hfi2_mmap_entry_insert() to prevent leak on repeated USER_INFO calls.
  - Restrict PCI device table to JKR-only hardware IDs.
  - Update Kconfig title and help text.

  Changes since v1:
  - Add TODO list file.
---
 drivers/infiniband/Kconfig                |    1 
 drivers/infiniband/hw/Makefile            |    1 
 drivers/infiniband/hw/hfi1/Kconfig        |    5 -
 drivers/infiniband/hw/hfi2/Kconfig        |   32 ++++
 drivers/infiniband/hw/hfi2/TODO           |    6 +
 drivers/infiniband/hw/hfi2/chip.c         |    2 
 drivers/infiniband/hw/hfi2/chip_gen.c     |    2 
 drivers/infiniband/hw/hfi2/cport.c        |    4 
 drivers/infiniband/hw/hfi2/fault.c        |    2 
 drivers/infiniband/hw/hfi2/file_ops.c     |  123 ++------------
 drivers/infiniband/hw/hfi2/file_ops.h     |    5 -
 drivers/infiniband/hw/hfi2/hfi2.h         |    2 
 drivers/infiniband/hw/hfi2/init.c         |    6 -
 drivers/infiniband/hw/hfi2/mad.c          |    4 
 drivers/infiniband/hw/hfi2/pin_system.c   |    2 
 drivers/infiniband/hw/hfi2/qsfp.c         |    2 
 drivers/infiniband/hw/hfi2/sdma.c         |    4 
 drivers/infiniband/hw/hfi2/tid_rdma.c     |    2 
 drivers/infiniband/hw/hfi2/tid_system.c   |    2 
 drivers/infiniband/hw/hfi2/user_exp_rcv.c |    2 
 drivers/infiniband/hw/hfi2/uverbs.c       |  264 +++++++++++++++++++++++------
 drivers/infiniband/hw/hfi2/uverbs.h       |   24 +++
 drivers/infiniband/hw/hfi2/verbs.c        |    6 +
 drivers/infiniband/hw/hfi2/vf2pf_lb.c     |    2 
 24 files changed, 321 insertions(+), 184 deletions(-)
 create mode 100644 drivers/infiniband/hw/hfi2/Kconfig
 create mode 100644 drivers/infiniband/hw/hfi2/TODO

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 086195758a8a..c05a04a15125 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -89,6 +89,7 @@ source "drivers/infiniband/hw/cxgb4/Kconfig"
 source "drivers/infiniband/hw/efa/Kconfig"
 source "drivers/infiniband/hw/erdma/Kconfig"
 source "drivers/infiniband/hw/hfi1/Kconfig"
+source "drivers/infiniband/hw/hfi2/Kconfig"
 source "drivers/infiniband/hw/hns/Kconfig"
 source "drivers/infiniband/hw/ionic/Kconfig"
 source "drivers/infiniband/hw/irdma/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index c42b22ac3303..d32ee79464a3 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_INFINIBAND_OCRDMA)		+= ocrdma/
 obj-$(CONFIG_INFINIBAND_VMWARE_PVRDMA)	+= vmw_pvrdma/
 obj-$(CONFIG_INFINIBAND_USNIC)		+= usnic/
 obj-$(CONFIG_INFINIBAND_HFI1)		+= hfi1/
+obj-$(CONFIG_INFINIBAND_HFI2)		+= hfi2/
 obj-$(CONFIG_INFINIBAND_HNS_HIP08)	+= hns/
 obj-$(CONFIG_INFINIBAND_QEDR)		+= qedr/
 obj-$(CONFIG_INFINIBAND_BNXT_RE)	+= bnxt_re/
diff --git a/drivers/infiniband/hw/hfi1/Kconfig b/drivers/infiniband/hw/hfi1/Kconfig
index 14b92e12bf29..a006dd112966 100644
--- a/drivers/infiniband/hw/hfi1/Kconfig
+++ b/drivers/infiniband/hw/hfi1/Kconfig
@@ -1,12 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config INFINIBAND_HFI1
-	tristate "Cornelis OPX Gen1 support"
+	tristate "Cornelis OPX Gen1 (WFR) support"
 	depends on X86_64 && INFINIBAND_RDMAVT && I2C && !UML
 	select MMU_NOTIFIER
 	select CRC32
 	select I2C_ALGOBIT
 	help
-	This is a low-level driver for Cornelis OPX Gen1 adapter.
+	This is a low-level driver for Cornelis OPX Gen1 (WFR) adapters.
+	For Gen2 (JKR) adapters use INFINIBAND_HFI2.
 config HFI1_DEBUG_SDMA_ORDER
 	bool "HFI1 SDMA Order debug"
 	depends on INFINIBAND_HFI1
diff --git a/drivers/infiniband/hw/hfi2/Kconfig b/drivers/infiniband/hw/hfi2/Kconfig
new file mode 100644
index 000000000000..7e3d80b3c459
--- /dev/null
+++ b/drivers/infiniband/hw/hfi2/Kconfig
@@ -0,0 +1,32 @@
+# SPDX-License-Identifier: GPL-2.0-only
+# Copyright(c) 2025-2026 Cornelis Networks, Inc.
+config INFINIBAND_HFI2
+	tristate "Cornelis OPX Gen2 (JKR) support"
+	depends on X86_64 && INFINIBAND_RDMAVT && I2C && !UML
+	depends on PCI_IOV
+	select MMU_NOTIFIER
+	select CRC32
+	select I2C_ALGOBIT
+	help
+	This is a low-level driver for Cornelis OPX Gen2 (JKR) adapters.
+	For Gen1 (WFR) adapters use INFINIBAND_HFI1. This separation is
+	temporary; hfi2 will eventually support both WFR and JKR hardware
+	at which point hfi1 will be removed.
+config HFI2_DEBUG_SDMA_ORDER
+	bool "HFI2 SDMA Order debug"
+	depends on INFINIBAND_HFI2
+	default n
+	help
+	  Enable this debug flag to test for out-of-order SDMA completions
+	  during unit testing. This option adds extra tracking to detect
+	  when SDMA completions arrive out of sequence, which should not
+	  happen in normal operation.
+config HFI2_SDMA_VERBOSITY
+	bool "Config SDMA Verbosity"
+	depends on INFINIBAND_HFI2
+	default n
+	help
+	  Enable this flag to turn on verbose SDMA debug logging. This
+	  produces additional diagnostic output useful for debugging SDMA
+	  issues. Should not be enabled in production as it generates
+	  significant log output.
diff --git a/drivers/infiniband/hw/hfi2/TODO b/drivers/infiniband/hw/hfi2/TODO
new file mode 100644
index 000000000000..ffa423a95d52
--- /dev/null
+++ b/drivers/infiniband/hw/hfi2/TODO
@@ -0,0 +1,6 @@
+Items that still need to be done post hfi2 initial acceptance
+-------------------------------------------------------------
+1. Absorb rdmavt into hfi2 and mark rdmavt deprecated
+2. Remove rdmavt
+3. Remove hfi1
+
diff --git a/drivers/infiniband/hw/hfi2/chip.c b/drivers/infiniband/hw/hfi2/chip.c
index e3ca732bff40..64489c117b65 100644
--- a/drivers/infiniband/hw/hfi2/chip.c
+++ b/drivers/infiniband/hw/hfi2/chip.c
@@ -12193,7 +12193,7 @@ static int init_asic_data(struct hfi2_devdata *dd)
 	int ret = 0;
 
 	/* pre-allocate the asic structure in case we are the first device */
-	asic_data = kzalloc_obj(dd->asic_data, GFP_KERNEL);
+	asic_data = kzalloc_obj(*dd->asic_data, GFP_KERNEL);
 	if (!asic_data)
 		return -ENOMEM;
 
diff --git a/drivers/infiniband/hw/hfi2/chip_gen.c b/drivers/infiniband/hw/hfi2/chip_gen.c
index 9273ba66a8c8..f8f1a69e844d 100644
--- a/drivers/infiniband/hw/hfi2/chip_gen.c
+++ b/drivers/infiniband/hw/hfi2/chip_gen.c
@@ -146,7 +146,7 @@ static struct opa_smp *build_cport_mad(int meth, int attr)
 {
 	struct opa_smp *mad;
 
-	mad = kzalloc_obj(mad, GFP_KERNEL);
+	mad = kzalloc_obj(*mad, GFP_KERNEL);
 	if (!mad)
 		return mad;
 	mad->base_version = OPA_MGMT_BASE_VERSION;
diff --git a/drivers/infiniband/hw/hfi2/cport.c b/drivers/infiniband/hw/hfi2/cport.c
index 1dc9f6c78b85..cbaa788a9f5e 100644
--- a/drivers/infiniband/hw/hfi2/cport.c
+++ b/drivers/infiniband/hw/hfi2/cport.c
@@ -187,7 +187,7 @@ static struct cport_work *cwalloc(int flag)
 
 	cw->flags = flag;
 	cw->n_mctxts = 1;
-	cw->req = kzalloc_obj(cw->req, GFP_KERNEL);
+	cw->req = kzalloc_obj(*cw->req, GFP_KERNEL);
 	if (!cw->req) {
 		kfree(cw);
 		return NULL;
@@ -923,7 +923,7 @@ int hfi2_cport_init(struct hfi2_devdata *dd)
 	if (dd->params->chip_type == CHIP_WFR || dd->is_vf)
 		return 0;
 
-	cport = kzalloc_obj(cport, GFP_KERNEL);
+	cport = kzalloc_obj(*cport, GFP_KERNEL);
 	if (!cport)
 		goto err1;
 
diff --git a/drivers/infiniband/hw/hfi2/fault.c b/drivers/infiniband/hw/hfi2/fault.c
index cc65bc0495b2..2c2f4763f318 100644
--- a/drivers/infiniband/hw/hfi2/fault.c
+++ b/drivers/infiniband/hw/hfi2/fault.c
@@ -212,7 +212,7 @@ int hfi2_fault_init_debugfs(struct hfi2_ibdev *ibd)
 	struct dentry *parent = ibd->hfi2_ibdev_dbg;
 	struct dentry *fault_dir;
 
-	ibd->fault = kzalloc_obj(ibd->fault, GFP_KERNEL);
+	ibd->fault = kzalloc_obj(*ibd->fault, GFP_KERNEL);
 	if (!ibd->fault)
 		return -ENOMEM;
 
diff --git a/drivers/infiniband/hw/hfi2/file_ops.c b/drivers/infiniband/hw/hfi2/file_ops.c
index 32490d5958de..096062e6b752 100644
--- a/drivers/infiniband/hw/hfi2/file_ops.c
+++ b/drivers/infiniband/hw/hfi2/file_ops.c
@@ -12,6 +12,7 @@
 #include <linux/bitmap.h>
 
 #include <rdma/ib.h>
+#include <rdma/ib_verbs.h>
 
 #include "hfi2.h"
 #include "affinity.h"
@@ -23,6 +24,7 @@
 #include "user_exp_rcv.h"
 #include "pinning.h"
 #include "file_ops.h"
+#include "uverbs.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) DRIVER_NAME ": " fmt
@@ -93,7 +95,7 @@ struct hfi2_filedata *hfi2_alloc_filedata(struct hfi2_devdata *dd)
 
 	/* The real work is performed later in assign_ctxt() */
 
-	fd = kzalloc_obj(fd, GFP_KERNEL);
+	fd = kzalloc_obj(*fd, GFP_KERNEL);
 
 	if (!fd || init_srcu_struct(&fd->pq_srcu))
 		goto nomem;
@@ -167,19 +169,20 @@ static inline void mmap_cdbg(u16 ctxt, u16 subctxt, u8 type, u8 mapio, u8 vmf,
 		vma->vm_flags);
 }
 
-int hfi2_do_mmap(struct hfi2_filedata *fd, u8 type, struct vm_area_struct *vma)
+int hfi2_do_mmap(struct hfi2_filedata *fd, u8 type, struct vm_area_struct *vma,
+		 struct rdma_user_mmap_entry *rdma_entry,
+		 struct ib_ucontext *ucontext)
 {
+	struct hfi2_user_mmap_entry *entry = to_hfi2_mmap(rdma_entry);
 	struct hfi2_ctxtdata *uctxt = fd->uctxt;
 	struct hfi2_devdata *dd;
 	unsigned long flags;
-	u64 memaddr = 0;
-	void *memvirt = NULL;
-	dma_addr_t memdma = 0;
+	u64 memaddr = entry->address;
+	void *memvirt = entry->memvirt;
+	dma_addr_t memdma = entry->memdma;
 	u8 mapio = 0, vmf = 0;
-	ssize_t memlen = 0;
+	ssize_t memlen = rdma_entry->npages * PAGE_SIZE;
 	int ret = 0;
-	u32 cbi;
-	u32 cbc;
 	u16 ctxt;
 	u16 subctxt;
 
@@ -201,56 +204,20 @@ int hfi2_do_mmap(struct hfi2_filedata *fd, u8 type, struct vm_area_struct *vma)
 	switch (type) {
 	case PIO_BUFS:
 	case PIO_BUFS_SOP:
-		cbi = ctxt_bar_idx(uctxt->sc->hw_context);
-		cbc = ctxt_bar_ctxt(uctxt->sc->hw_context);
-		memaddr = ((dd->bar_maps[cbi].physaddr + TXE_PIO_SEND) +
-			   /* chip pio base */
-			   (cbc * BIT(16))) +
-			  /* 64K PIO space / ctxt */
-			  (type == PIO_BUFS_SOP ? (TXE_PIO_SIZE / 2) :
-						  0); /* sop? */
-		/*
-		 * Map only the amount allocated to the context, not the
-		 * entire available context's PIO space.
-		 */
-		memlen = PAGE_ALIGN(uctxt->sc->credits * PIO_BLOCK_SIZE);
 		flags &= ~VM_MAYREAD;
 		flags |= VM_DONTCOPY | VM_DONTEXPAND;
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 		mapio = 1;
 		break;
-	case PIO_CRED: {
-		u64 cr_page_offset;
+	case PIO_CRED:
 		if (flags & VM_WRITE) {
 			ret = -EPERM;
 			goto done;
 		}
-		/*
-		 * The credit return location for this context could be on the
-		 * second or third page allocated for credit returns (if number
-		 * of enabled contexts > 64 and 128 respectively).
-		 */
-		cr_page_offset = ((u64)uctxt->sc->hw_free -
-				  (u64)dd->cr_base[uctxt->numa_id].va) &
-				 PAGE_MASK;
-		memvirt =
-			(void *)dd->cr_base[uctxt->numa_id].va + cr_page_offset;
-		memdma = dd->cr_base[uctxt->numa_id].dma + cr_page_offset;
-		memlen = PAGE_SIZE;
 		flags &= ~VM_MAYWRITE;
 		flags |= VM_DONTCOPY | VM_DONTEXPAND;
-		/*
-		 * The driver has already allocated memory for credit
-		 * returns and programmed it into the chip. Has that
-		 * memory been flagged as non-cached?
-		 */
-		/* vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot); */
 		break;
-	}
 	case RCV_RHEQ:
-		memlen = rheq_size(uctxt);
-		memvirt = uctxt->rheq;
-		memdma = uctxt->rheq_dma;
 		if (!memvirt) {
 			ret = -EINVAL;
 			goto done;
@@ -261,9 +228,6 @@ int hfi2_do_mmap(struct hfi2_filedata *fd, u8 type, struct vm_area_struct *vma)
 		}
 		break;
 	case RCV_HDRQ:
-		memlen = rcvhdrq_size(uctxt);
-		memvirt = uctxt->rcvhdrq;
-		memdma = uctxt->rcvhdrq_dma;
 		break;
 	case RCV_EGRBUF: {
 		unsigned long vm_start_save;
@@ -274,7 +238,6 @@ int hfi2_do_mmap(struct hfi2_filedata *fd, u8 type, struct vm_area_struct *vma)
 		 * as multiple non-contiguous pages need to be mapped
 		 * into the user process.
 		 */
-		memlen = uctxt->egrbufs.size;
 		if ((vma->vm_end - vma->vm_start) != memlen) {
 			dd_dev_err(
 				dd,
@@ -320,43 +283,11 @@ int hfi2_do_mmap(struct hfi2_filedata *fd, u8 type, struct vm_area_struct *vma)
 		goto done;
 	}
 	case UREGS:
-		/*
-		 * Map the part of BAR0 that contains this context's user
-		 * registers.  RcvHdrTail is the first register in the hardware
-		 * UCTXT block.  The TidFlow table is contained within this
-		 * memory range.
-		 */
-		cbi = ctxt_bar_idx(uctxt->ctxt);
-		cbc = ctxt_bar_ctxt(uctxt->ctxt);
-		memaddr = (unsigned long)dd->bar_maps[cbi].physaddr +
-			  dd->params->rcv_hdr_tail_reg +
-			  (cbc * dd->params->rxe_uctxt_stride);
-		memlen = dd->params->rxe_uctxt_stride;
-		// hack: accept a 4K mmap for uregs
-		{
-			ssize_t sz = vma->vm_end - vma->vm_start;
-			if (sz != memlen && sz == PAGE_SIZE) {
-				printk("%s: UREGS override memlen to 4K\n",
-				       __func__);
-				memlen = PAGE_SIZE;
-			}
-		}
 		flags |= VM_DONTCOPY | VM_DONTEXPAND;
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 		mapio = 1;
 		break;
 	case EVENTS:
-		/*
-		 * Use the page where this context's flags are. User level
-		 * knows where it's own bitmap is within the page.
-		 */
-		memaddr = (unsigned long)(dd->events + uctxt_offset(uctxt)) &
-			  PAGE_MASK;
-		memlen = PAGE_SIZE;
-		/*
-		 * v3.7 removes VM_RESERVED but the effect is kept by
-		 * using VM_IO.
-		 */
 		flags |= VM_IO | VM_DONTEXPAND;
 		vmf = 1;
 		break;
@@ -365,16 +296,12 @@ int hfi2_do_mmap(struct hfi2_filedata *fd, u8 type, struct vm_area_struct *vma)
 			ret = -EPERM;
 			goto done;
 		}
-		memaddr = kvirt_to_phys((void *)dd->status);
-		memlen = PAGE_SIZE;
+		memaddr = kvirt_to_phys(memvirt);
+		memvirt = NULL;
 		flags |= VM_IO | VM_DONTEXPAND;
 		break;
 	case RTAIL:
 		if (!HFI2_CAP_IS_USET(DMA_RTAIL)) {
-			/*
-			 * If the memory allocation failed, the context alloc
-			 * also would have failed, so we would never get here
-			 */
 			ret = -EINVAL;
 			goto done;
 		}
@@ -382,43 +309,29 @@ int hfi2_do_mmap(struct hfi2_filedata *fd, u8 type, struct vm_area_struct *vma)
 			ret = -EPERM;
 			goto done;
 		}
-		memlen = PAGE_SIZE;
-		memvirt = (void *)hfi2_rcvhdrtail_kvaddr(uctxt);
-		memdma = uctxt->rcvhdrqtailaddr_dma;
 		flags &= ~VM_MAYWRITE;
 		break;
 	case SUBCTXT_UREGS:
-		memaddr = (u64)uctxt->subctxt_uregbase;
-		memlen = PAGE_SIZE;
 		flags |= VM_IO | VM_DONTEXPAND;
 		vmf = 1;
 		break;
 	case SUBCTXT_RCV_HDRQ:
-		memaddr = (u64)uctxt->subctxt_rcvhdr_base;
-		memlen = rcvhdrq_size(uctxt) * uctxt->subctxt_cnt;
 		flags |= VM_IO | VM_DONTEXPAND;
 		vmf = 1;
 		break;
 	case SUBCTXT_EGRBUF:
-		memaddr = (u64)uctxt->subctxt_rcvegrbuf;
-		memlen = uctxt->egrbufs.size * uctxt->subctxt_cnt;
 		flags |= VM_IO | VM_DONTEXPAND;
 		flags &= ~VM_MAYWRITE;
 		vmf = 1;
 		break;
-	case SDMA_COMP: {
-		struct hfi2_user_sdma_comp_q *cq = fd->cq;
-
-		if (!cq) {
+	case SDMA_COMP:
+		if (!fd->cq) {
 			ret = -EFAULT;
 			goto done;
 		}
-		memaddr = (u64)cq->comps;
-		memlen = PAGE_ALIGN(sizeof(*cq->comps) * cq->nentries);
 		flags |= VM_IO | VM_DONTEXPAND;
 		vmf = 1;
 		break;
-	}
 	default:
 		ret = -EINVAL;
 		break;
@@ -443,8 +356,8 @@ int hfi2_do_mmap(struct hfi2_filedata *fd, u8 type, struct vm_area_struct *vma)
 		ret = dma_mmap_coherent(&dd->pcidev->dev, vma, memvirt, memdma,
 					memlen);
 	} else if (mapio) {
-		ret = io_remap_pfn_range(vma, vma->vm_start, PFN_DOWN(memaddr),
-					 memlen, vma->vm_page_prot);
+		ret = rdma_user_mmap_io(ucontext, vma, PFN_DOWN(memaddr),
+					memlen, vma->vm_page_prot, rdma_entry);
 	} else if (memvirt) {
 		ret = remap_pfn_range(vma, vma->vm_start,
 				      PFN_DOWN(__pa(memvirt)), memlen,
diff --git a/drivers/infiniband/hw/hfi2/file_ops.h b/drivers/infiniband/hw/hfi2/file_ops.h
index 7330992163aa..4404631104d0 100644
--- a/drivers/infiniband/hw/hfi2/file_ops.h
+++ b/drivers/infiniband/hw/hfi2/file_ops.h
@@ -20,7 +20,9 @@ int hfi2_user_set_ctxt_pkey(struct hfi2_ctxtdata *uctxt, u16 pkey);
 int hfi2_ctxt_reset(struct hfi2_ctxtdata *uctxt);
 int hfi2_get_pinning_stats(struct hfi2_filedata *fd,
 			   struct hfi2_pin_stats *stats);
-int hfi2_do_mmap(struct hfi2_filedata *fd, u8 type, struct vm_area_struct *vma);
+int hfi2_do_mmap(struct hfi2_filedata *fd, u8 type, struct vm_area_struct *vma,
+		 struct rdma_user_mmap_entry *rdma_entry,
+		 struct ib_ucontext *ucontext);
 ssize_t hfi2_do_write_iter(struct hfi2_filedata *fd, struct iov_iter *from);
 
 /*
@@ -41,6 +43,7 @@ enum mmap_types {
 	SUBCTXT_EGRBUF,
 	SDMA_COMP,
 	RCV_RHEQ,
+	MMAP_TYPE_MAX,
 };
 
 #endif /* _HFI2_FILE_OPS_H */
diff --git a/drivers/infiniband/hw/hfi2/hfi2.h b/drivers/infiniband/hw/hfi2/hfi2.h
index 7ff6b0bb9e91..5ad8cefc7dc1 100644
--- a/drivers/infiniband/hw/hfi2/hfi2.h
+++ b/drivers/infiniband/hw/hfi2/hfi2.h
@@ -1815,6 +1815,8 @@ struct hfi2_filedata {
 	u32 invalid_tid_idx;
 	/* protect invalid_tids array and invalid_tid_idx */
 	spinlock_t invalid_lock;
+	/* mmap entries tracked for rdma_user_mmap infrastructure */
+	struct rdma_user_mmap_entry *mmap_entries[15]; /* MMAP_TYPE_MAX */
 };
 
 extern struct xarray hfi2_dev_table;
diff --git a/drivers/infiniband/hw/hfi2/init.c b/drivers/infiniband/hw/hfi2/init.c
index f9b0b16675d7..5b859ae7ae1e 100644
--- a/drivers/infiniband/hw/hfi2/init.c
+++ b/drivers/infiniband/hw/hfi2/init.c
@@ -623,7 +623,7 @@ int hfi2_register_cport_trap(struct hfi2_devdata *dd,
 	trap_val.traps = traps;
 	cur_traps.traps = dd->cport->traps;
 
-	entry = kzalloc_obj(entry, GFP_KERNEL);
+	entry = kzalloc_obj(*entry, GFP_KERNEL);
 	if (!entry)
 		return -ENOMEM;
 	entry->mask = trap_val.dw;
@@ -1350,7 +1350,7 @@ void hfi2_init_pportdata(struct pci_dev *pdev, struct hfi2_pportdata *ppd,
 
 	spin_lock_init(&ppd->cc_state_lock);
 	spin_lock_init(&ppd->cc_log_lock);
-	cc_state = kzalloc_obj(cc_state, GFP_KERNEL);
+	cc_state = kzalloc_obj(*cc_state, GFP_KERNEL);
 	RCU_INIT_POINTER(ppd->cc_state, cc_state);
 	if (!cc_state)
 		goto bail;
@@ -2161,8 +2161,6 @@ static void shutdown_one(struct pci_dev *);
 #define PFX DRIVER_NAME ": "
 
 const struct pci_device_id hfi2_pci_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL1) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_CORNELIS, PCI_DEVICE_ID_CORNELIS_CN5000) },
 	{
 		0,
diff --git a/drivers/infiniband/hw/hfi2/mad.c b/drivers/infiniband/hw/hfi2/mad.c
index cbaa94f0cbf0..314e95e03b1f 100644
--- a/drivers/infiniband/hw/hfi2/mad.c
+++ b/drivers/infiniband/hw/hfi2/mad.c
@@ -412,7 +412,7 @@ static struct trap_node *create_trap_node(u8 type, __be16 trap_num, u32 lid)
 {
 	struct trap_node *trap;
 
-	trap = kzalloc_obj(trap, GFP_ATOMIC);
+	trap = kzalloc_obj(*trap, GFP_ATOMIC);
 	if (!trap)
 		return NULL;
 
@@ -3822,7 +3822,7 @@ static void apply_cc_state(struct hfi2_pportdata *ppd)
 {
 	struct cc_state *old_cc_state, *new_cc_state;
 
-	new_cc_state = kzalloc_obj(new_cc_state, GFP_KERNEL);
+	new_cc_state = kzalloc_obj(*new_cc_state, GFP_KERNEL);
 	if (!new_cc_state)
 		return;
 
diff --git a/drivers/infiniband/hw/hfi2/pin_system.c b/drivers/infiniband/hw/hfi2/pin_system.c
index 949f12e6406a..6816f31026fe 100644
--- a/drivers/infiniband/hw/hfi2/pin_system.c
+++ b/drivers/infiniband/hw/hfi2/pin_system.c
@@ -192,7 +192,7 @@ add_system_pinning(struct user_sdma_request *req, unsigned long start,
 	struct sdma_mmu_node *e;
 	int ret;
 
-	e = kzalloc_obj(e, GFP_KERNEL);
+	e = kzalloc_obj(*e, GFP_KERNEL);
 	if (!e)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/infiniband/hw/hfi2/qsfp.c b/drivers/infiniband/hw/hfi2/qsfp.c
index bc3c16c31f7a..de73829d9ef6 100644
--- a/drivers/infiniband/hw/hfi2/qsfp.c
+++ b/drivers/infiniband/hw/hfi2/qsfp.c
@@ -108,7 +108,7 @@ static struct hfi2_i2c_bus *init_i2c_bus(struct hfi2_devdata *dd,
 	struct hfi2_i2c_bus *bus;
 	int ret;
 
-	bus = kzalloc_obj(bus, GFP_KERNEL);
+	bus = kzalloc_obj(*bus, GFP_KERNEL);
 	if (!bus)
 		return NULL;
 
diff --git a/drivers/infiniband/hw/hfi2/sdma.c b/drivers/infiniband/hw/hfi2/sdma.c
index b799b16bf254..a48c548fadc2 100644
--- a/drivers/infiniband/hw/hfi2/sdma.c
+++ b/drivers/infiniband/hw/hfi2/sdma.c
@@ -999,7 +999,7 @@ ssize_t hfi2_sdma_set_cpu_to_sde_map(struct sdma_engine *sde, const char *buf,
 
 		do_insert = false;
 		if (!rht_node) {
-			rht_node = kzalloc_obj(rht_node, GFP_KERNEL);
+			rht_node = kzalloc_obj(*rht_node, GFP_KERNEL);
 			if (!rht_node) {
 				ret = -ENOMEM;
 				goto out;
@@ -2478,7 +2478,7 @@ static void dump_sdma_state(struct sdma_engine *sde)
 	if (in_interrupt()) {
 		size_t size = sizeof(struct hw_sdma_desc) * sde->descq_cnt;
 
-		sdi = kmalloc_obj(sdi, GFP_ATOMIC);
+		sdi = kmalloc_obj(*sdi, GFP_ATOMIC);
 		descs = kmalloc(size, GFP_ATOMIC);
 		if (!sdi || !descs) {
 			kfree(sdi);
diff --git a/drivers/infiniband/hw/hfi2/tid_rdma.c b/drivers/infiniband/hw/hfi2/tid_rdma.c
index 9a4ba2828554..a11a39cce17c 100644
--- a/drivers/infiniband/hw/hfi2/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi2/tid_rdma.c
@@ -232,7 +232,7 @@ bool hfi2_tid_rdma_conn_reply(struct rvt_qp *qp, u64 data)
 	 * * at the responder, 0 being returned to the requester so as to
 	 *   disable TID RDMA at both the requester and the responder
 	 */
-	remote = kzalloc_obj(remote, GFP_ATOMIC);
+	remote = kzalloc_obj(*remote, GFP_ATOMIC);
 	if (!remote) {
 		ret = false;
 		goto null;
diff --git a/drivers/infiniband/hw/hfi2/tid_system.c b/drivers/infiniband/hw/hfi2/tid_system.c
index 8d0f065047cc..fcb8a805c6bc 100644
--- a/drivers/infiniband/hw/hfi2/tid_system.c
+++ b/drivers/infiniband/hw/hfi2/tid_system.c
@@ -256,7 +256,7 @@ static int sys_user_buf_init(u16 expected_count, bool notify,
 	if (!IS_ALIGNED(vaddr, max(EXP_TID_ADDR_SIZE, PAGE_SIZE)))
 		return -EINVAL;
 
-	sbuf = kzalloc_obj(sbuf, GFP_KERNEL);
+	sbuf = kzalloc_obj(*sbuf, GFP_KERNEL);
 	if (!sbuf)
 		return -ENOMEM;
 	*tbuf = &sbuf->common;
diff --git a/drivers/infiniband/hw/hfi2/user_exp_rcv.c b/drivers/infiniband/hw/hfi2/user_exp_rcv.c
index 313336cc22dd..4e8d461450d0 100644
--- a/drivers/infiniband/hw/hfi2/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi2/user_exp_rcv.c
@@ -230,7 +230,7 @@ static struct hfi2_page_iter *tid_user_buf_iter_begin(struct tid_user_buf *tbuf)
 	if (!tbuf->psets || !tbuf->n_psets)
 		return ERR_PTR(-EINVAL);
 
-	iter = kzalloc_obj(iter, GFP_KERNEL);
+	iter = kzalloc_obj(*iter, GFP_KERNEL);
 	if (!iter)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/infiniband/hw/hfi2/uverbs.c b/drivers/infiniband/hw/hfi2/uverbs.c
index df3703f2fed0..76f462c1efb4 100644
--- a/drivers/infiniband/hw/hfi2/uverbs.c
+++ b/drivers/infiniband/hw/hfi2/uverbs.c
@@ -14,30 +14,42 @@
 
 static const u64 zero8; /* 8 bytes of 0 */
 
+/* rdmavt mmap for CQ/QP/SRQ fallback */
+#include "../../sw/rdmavt/mmap.h"
+
 /*
- * RDMA mmap token: <type> << <page offset>
- *
- * Expect type to be less than 256 (8 bits).  rdmavt reserves the bottom 256
- * tokens for the driver.  A type of zero is always considered invalid.
- * Types >= 256 are used for rdmavt's dynamic token generation.
+ * Insert a driver mmap entry into the rdma_user_mmap infrastructure.
+ * Returns 0 on success and stores the opaque offset in *offset for
+ * userspace to pass back to mmap(2).
  */
-
-/* convert RDMA mmap token to type: the first 8 bits above a page */
-static inline u8 rdma_mmap_get_type(unsigned long token)
+static int hfi2_mmap_entry_insert(struct ib_ucontext *ucontext,
+				  struct hfi2_filedata *fd, u8 type,
+				  size_t length, u64 address, void *memvirt,
+				  dma_addr_t memdma, u64 *offset)
 {
-	return token >> PAGE_SHIFT;
-}
+	struct hfi2_user_mmap_entry *entry;
+	int ret;
 
-/* calculate the token from an integer offset */
-static inline unsigned long rdma_mmap_token_i(u8 type, unsigned long offset)
-{
-	return ((unsigned long)type << PAGE_SHIFT) | offset_in_page(offset);
-}
+	entry = kzalloc_obj(*entry, GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
 
-/* calculate the token from a pointer offset */
-static inline unsigned long rdma_mmap_token_p(u8 type, void *offset)
-{
-	return rdma_mmap_token_i(type, (unsigned long)offset);
+	entry->address = address;
+	entry->memvirt = memvirt;
+	entry->memdma = memdma;
+	entry->mmap_flag = type;
+
+	ret = rdma_user_mmap_entry_insert(ucontext, &entry->rdma_entry, length);
+	if (ret) {
+		kfree(entry);
+		return ret;
+	}
+
+	*offset = rdma_user_mmap_get_offset(&entry->rdma_entry);
+	if (fd->mmap_entries[type])
+		rdma_user_mmap_entry_remove(fd->mmap_entries[type]);
+	fd->mmap_entries[type] = &entry->rdma_entry;
+	return 0;
 }
 
 int hfi2_alloc_ucontext(struct ib_ucontext *ucontext, struct ib_udata *udata)
@@ -61,9 +73,18 @@ void hfi2_dealloc_ucontext(struct ib_ucontext *ucontext)
 	struct rvt_ucontext *rcontext =
 		container_of(ucontext, struct rvt_ucontext, ibucontext);
 	struct hfi2_filedata *fd;
+	int i;
 
 	fd = rcontext->priv;
 	if (fd) {
+		/* Remove all mmap entries before freeing the filedata */
+		for (i = 0; i < ARRAY_SIZE(fd->mmap_entries); i++) {
+			if (fd->mmap_entries[i]) {
+				rdma_user_mmap_entry_remove(
+					fd->mmap_entries[i]);
+				fd->mmap_entries[i] = NULL;
+			}
+		}
 		hfi2_dealloc_filedata(fd);
 		rcontext->priv = NULL;
 	}
@@ -149,7 +170,6 @@ UVERBS_HANDLER(HFI2_METHOD_USER_INFO)(struct uverbs_attr_bundle *attrs)
 	struct hfi2_ctxtdata *uctxt = fd->uctxt;
 	struct hfi2_user_info_rsp rsp = {};
 	struct hfi2_devdata *dd;
-	unsigned long offset;
 
 	if (!uctxt)
 		return -EINVAL;
@@ -165,37 +185,158 @@ UVERBS_HANDLER(HFI2_METHOD_USER_INFO)(struct uverbs_attr_bundle *attrs)
 	 * the context's credit return address is mapped.  Calculate the offset
 	 * in the proper page.
 	 */
-	offset = ((u64)uctxt->sc->hw_free -
-		  (u64)dd->cr_base[uctxt->numa_id].va) %
-		 PAGE_SIZE;
-	rsp.sc_credits_addr = rdma_mmap_token_i(PIO_CRED, offset);
-	rsp.pio_bufbase = rdma_mmap_token_p(PIO_BUFS, uctxt->sc->base_addr);
-	rsp.pio_bufbase_sop =
-		rdma_mmap_token_p(PIO_BUFS_SOP, uctxt->sc->base_addr);
-	rsp.rcvhdr_bufbase = rdma_mmap_token_p(RCV_HDRQ, uctxt->rcvhdrq);
-	rsp.rcvegr_bufbase =
-		rdma_mmap_token_i(RCV_EGRBUF, uctxt->egrbufs.rcvtids[0].dma);
-	rsp.sdma_comp_bufbase = rdma_mmap_token_i(SDMA_COMP, 0);
+
 	/*
-	 * user regs are at
-	 * (RXE_PER_CONTEXT_USER + (ctxt * RXE_PER_CONTEXT_SIZE))
+	 * Replace the old token scheme with rdma_user_mmap_entry_insert().
+	 * Each buffer type gets an entry in the xarray; the opaque offset
+	 * returned to userspace is passed back to mmap(2).
 	 */
-	rsp.user_regbase = rdma_mmap_token_i(UREGS, 0);
-	offset = offset_in_page((uctxt_offset(uctxt) + fd->subctxt) *
-				sizeof(*dd->events));
-	rsp.events_bufbase = rdma_mmap_token_i(EVENTS, offset);
-	rsp.status_bufbase = rdma_mmap_token_p(STATUS, dd->status);
-	if (HFI2_CAP_IS_USET(DMA_RTAIL))
-		rsp.rcvhdrtail_base = rdma_mmap_token_i(RTAIL, 0);
-	if (uctxt->subctxt_cnt) {
-		rsp.subctxt_uregbase = rdma_mmap_token_i(SUBCTXT_UREGS, 0);
-		rsp.subctxt_rcvhdrbuf = rdma_mmap_token_i(SUBCTXT_RCV_HDRQ, 0);
-		rsp.subctxt_rcvegrbuf = rdma_mmap_token_i(SUBCTXT_EGRBUF, 0);
+	{
+		struct ib_ucontext *ucontext = ib_uverbs_get_ucontext(attrs);
+		u64 cr_page_offset;
+		u32 cbi, cbc;
+		int ret;
+
+		/* PIO send buffers (write-combine MMIO) */
+		cbi = ctxt_bar_idx(uctxt->sc->hw_context);
+		cbc = ctxt_bar_ctxt(uctxt->sc->hw_context);
+		ret = hfi2_mmap_entry_insert(
+			ucontext, fd, PIO_BUFS,
+			PAGE_ALIGN(uctxt->sc->credits * PIO_BLOCK_SIZE),
+			dd->bar_maps[cbi].physaddr + TXE_PIO_SEND +
+				(cbc * BIT(16)),
+			NULL, 0, &rsp.pio_bufbase);
+		if (ret)
+			return ret;
+
+		ret = hfi2_mmap_entry_insert(
+			ucontext, fd, PIO_BUFS_SOP,
+			PAGE_ALIGN(uctxt->sc->credits * PIO_BLOCK_SIZE),
+			dd->bar_maps[cbi].physaddr + TXE_PIO_SEND +
+				(cbc * BIT(16)) + (TXE_PIO_SIZE / 2),
+			NULL, 0, &rsp.pio_bufbase_sop);
+		if (ret)
+			return ret;
+
+		/*
+		 * PIO credit return (DMA-coherent). If more than 64 contexts are
+		 * enabled, the credit return spans multiple pages; map only the page
+		 * containing this context's credit return address.
+		 */
+		cr_page_offset = ((u64)uctxt->sc->hw_free -
+				  (u64)dd->cr_base[uctxt->numa_id].va) &
+				 PAGE_MASK;
+		ret = hfi2_mmap_entry_insert(
+			ucontext, fd, PIO_CRED, PAGE_SIZE, 0,
+			(void *)dd->cr_base[uctxt->numa_id].va + cr_page_offset,
+			dd->cr_base[uctxt->numa_id].dma + cr_page_offset,
+			&rsp.sc_credits_addr);
+		if (ret)
+			return ret;
+
+		/* Receive header queue (DMA-coherent) */
+		ret = hfi2_mmap_entry_insert(ucontext, fd, RCV_HDRQ,
+					     rcvhdrq_size(uctxt), 0,
+					     uctxt->rcvhdrq, uctxt->rcvhdrq_dma,
+					     &rsp.rcvhdr_bufbase);
+		if (ret)
+			return ret;
+
+		/* Receive eager buffers (DMA-coherent, multi-segment) */
+		ret = hfi2_mmap_entry_insert(ucontext, fd, RCV_EGRBUF,
+					     uctxt->egrbufs.size, 0, NULL, 0,
+					     &rsp.rcvegr_bufbase);
+		if (ret)
+			return ret;
+
+		/* SDMA completion queue (vmalloc'd) */
+		ret = hfi2_mmap_entry_insert(
+			ucontext, fd, SDMA_COMP,
+			PAGE_ALIGN(sizeof(*fd->cq->comps) * fd->cq->nentries),
+			(u64)fd->cq->comps, NULL, 0, &rsp.sdma_comp_bufbase);
+		if (ret)
+			return ret;
+
+		/*
+		 * User registers (non-cached MMIO).
+		 * RcvHdrTail is the first register in the hardware UCTXT block.
+		 */
+		cbi = ctxt_bar_idx(uctxt->ctxt);
+		cbc = ctxt_bar_ctxt(uctxt->ctxt);
+		ret = hfi2_mmap_entry_insert(
+			ucontext, fd, UREGS, dd->params->rxe_uctxt_stride,
+			(u64)dd->bar_maps[cbi].physaddr +
+				dd->params->rcv_hdr_tail_reg +
+				(cbc * dd->params->rxe_uctxt_stride),
+			NULL, 0, &rsp.user_regbase);
+		if (ret)
+			return ret;
+
+		/* Events page (vmalloc'd) */
+		ret = hfi2_mmap_entry_insert(
+			ucontext, fd, EVENTS, PAGE_SIZE,
+			(unsigned long)(dd->events + uctxt_offset(uctxt)) &
+				PAGE_MASK,
+			NULL, 0, &rsp.events_bufbase);
+		if (ret)
+			return ret;
+
+		/* Status page (kernel virtual) */
+		ret = hfi2_mmap_entry_insert(ucontext, fd, STATUS, PAGE_SIZE, 0,
+					     (void *)dd->status, 0,
+					     &rsp.status_bufbase);
+		if (ret)
+			return ret;
+
+		/* Receive header tail (DMA-coherent) */
+		if (HFI2_CAP_IS_USET(DMA_RTAIL)) {
+			ret = hfi2_mmap_entry_insert(
+				ucontext, fd, RTAIL, PAGE_SIZE, 0,
+				(void *)hfi2_rcvhdrtail_kvaddr(uctxt),
+				uctxt->rcvhdrqtailaddr_dma,
+				&rsp.rcvhdrtail_base);
+			if (ret)
+				return ret;
+		}
+
+		/* Sub-context shared regions (vmalloc'd) */
+		if (uctxt->subctxt_cnt) {
+			ret = hfi2_mmap_entry_insert(
+				ucontext, fd, SUBCTXT_UREGS, PAGE_SIZE,
+				(u64)uctxt->subctxt_uregbase, NULL, 0,
+				&rsp.subctxt_uregbase);
+			if (ret)
+				return ret;
+
+			ret = hfi2_mmap_entry_insert(
+				ucontext, fd, SUBCTXT_RCV_HDRQ,
+				rcvhdrq_size(uctxt) * uctxt->subctxt_cnt,
+				(u64)uctxt->subctxt_rcvhdr_base, NULL, 0,
+				&rsp.subctxt_rcvhdrbuf);
+			if (ret)
+				return ret;
+
+			ret = hfi2_mmap_entry_insert(
+				ucontext, fd, SUBCTXT_EGRBUF,
+				uctxt->egrbufs.size * uctxt->subctxt_cnt,
+				(u64)uctxt->subctxt_rcvegrbuf, NULL, 0,
+				&rsp.subctxt_rcvegrbuf);
+			if (ret)
+				return ret;
+		}
+
+		/* Receive header error queue (DMA-coherent, JKR only) */
+		if (dd->params->chip_type != CHIP_WFR) {
+			ret = hfi2_mmap_entry_insert(ucontext, fd, RCV_RHEQ,
+						     rheq_size(uctxt), 0,
+						     uctxt->rheq,
+						     uctxt->rheq_dma,
+						     &rsp.rheq_bufbase);
+			if (ret)
+				return ret;
+		}
 	}
 
-	if (dd->params->chip_type != CHIP_WFR)
-		rsp.rheq_bufbase = rdma_mmap_token_p(RCV_RHEQ, uctxt->rcvhdrq);
-
 	return uverbs_copy_to(attrs, HFI2_ATTR_USER_INFO_RSP, &rsp,
 			      sizeof(rsp));
 };
@@ -628,19 +769,32 @@ const struct uapi_definition hfi2_ib_defs[] = {
 	{}
 };
 
-int hfi2_rdma_mmap(struct ib_ucontext *ucontext, struct vm_area_struct *vma)
+int hfi2_mmap(struct ib_ucontext *ucontext, struct vm_area_struct *vma)
 {
 	struct rvt_ucontext *rcontext =
 		container_of(ucontext, struct rvt_ucontext, ibucontext);
 	struct hfi2_filedata *fd = rcontext->priv;
-	unsigned long token;
-	u8 type;
+	struct rdma_user_mmap_entry *rdma_entry;
+	struct hfi2_user_mmap_entry *entry;
+	int ret;
 
-	if (!fd)
-		return -EINVAL;
+	/*
+	 * Try to look up the offset in the rdma_user_mmap xarray.
+	 * If found, this is a driver data-path buffer mmap.
+	 */
+	rdma_entry = rdma_user_mmap_entry_get(ucontext, vma);
+	if (rdma_entry) {
+		entry = to_hfi2_mmap(rdma_entry);
+		ret = hfi2_do_mmap(fd, entry->mmap_flag, vma, rdma_entry,
+				   ucontext);
+		rdma_user_mmap_entry_put(rdma_entry);
+		return ret;
+	}
 
-	token = vma->vm_pgoff << PAGE_SHIFT;
-	type = rdma_mmap_get_type(token);
+	return rvt_mmap(ucontext, vma);
+}
 
-	return hfi2_do_mmap(fd, type, vma);
+void hfi2_mmap_free(struct rdma_user_mmap_entry *rdma_entry)
+{
+	kfree(to_hfi2_mmap(rdma_entry));
 }
diff --git a/drivers/infiniband/hw/hfi2/uverbs.h b/drivers/infiniband/hw/hfi2/uverbs.h
index cac1fbda942b..254e64ac5eb7 100644
--- a/drivers/infiniband/hw/hfi2/uverbs.h
+++ b/drivers/infiniband/hw/hfi2/uverbs.h
@@ -7,10 +7,32 @@
 #define HFI2_UVERBS_H
 
 #include <rdma/uverbs_ioctl.h>
+#include <rdma/ib_verbs.h>
+
+/*
+ * Driver-specific mmap entry, embedding the core rdma_user_mmap_entry.
+ * One entry is created per mappable region and tracked for the lifetime
+ * of the user context.
+ */
+struct hfi2_user_mmap_entry {
+	struct rdma_user_mmap_entry rdma_entry;
+	u64 address;
+	void *memvirt;
+	dma_addr_t memdma;
+	u8 mmap_flag;
+};
+
+static inline struct hfi2_user_mmap_entry *
+to_hfi2_mmap(struct rdma_user_mmap_entry *rdma_entry)
+{
+	return container_of(rdma_entry, struct hfi2_user_mmap_entry,
+			    rdma_entry);
+}
 
 int hfi2_alloc_ucontext(struct ib_ucontext *ucontext, struct ib_udata *udata);
 void hfi2_dealloc_ucontext(struct ib_ucontext *ucontext);
-int hfi2_rdma_mmap(struct ib_ucontext *ucontext, struct vm_area_struct *vma);
+int hfi2_mmap(struct ib_ucontext *ucontext, struct vm_area_struct *vma);
+void hfi2_mmap_free(struct rdma_user_mmap_entry *rdma_entry);
 
 extern const struct uapi_definition hfi2_ib_defs[];
 
diff --git a/drivers/infiniband/hw/hfi2/verbs.c b/drivers/infiniband/hw/hfi2/verbs.c
index b715abc19ee5..8dbf3fee4a31 100644
--- a/drivers/infiniband/hw/hfi2/verbs.c
+++ b/drivers/infiniband/hw/hfi2/verbs.c
@@ -1764,6 +1764,8 @@ static const struct ib_device_ops hfi2_dev_ops = {
 	/* keep process mad in the driver */
 	.process_mad = hfi2_process_mad,
 	.rdma_netdev_get_params = hfi2_ipoib_rn_get_params,
+	.mmap = hfi2_mmap,
+	.mmap_free = hfi2_mmap_free,
 };
 
 static const struct ib_device_ops cport_dev_ops = {
@@ -1798,6 +1800,8 @@ static const struct ib_device_ops vf_dev_ops = {
 	/* keep process mad in the driver */
 	.process_mad = hfi2_vf_process_mad,
 	.rdma_netdev_get_params = hfi2_ipoib_rn_get_params,
+	.mmap = hfi2_mmap,
+	.mmap_free = hfi2_mmap_free,
 };
 
 /**
@@ -1933,7 +1937,7 @@ int hfi2_register_ib_device(struct hfi2_devdata *dd)
 		hfi2_comp_vect_mappings_lookup;
 	dd->verbs_dev.rdi.driver_f.alloc_ucontext = hfi2_alloc_ucontext;
 	dd->verbs_dev.rdi.driver_f.dealloc_ucontext = hfi2_dealloc_ucontext;
-	dd->verbs_dev.rdi.driver_f.mmap = hfi2_rdma_mmap;
+	/* mmap is registered via ib_device_ops, not driver_f */
 
 	/* completeion queue */
 	dd->verbs_dev.rdi.ibdev.num_comp_vectors = dd->comp_vect_possible_cpus;
diff --git a/drivers/infiniband/hw/hfi2/vf2pf_lb.c b/drivers/infiniband/hw/hfi2/vf2pf_lb.c
index 3dc3323f8576..1e2ffed14ab1 100644
--- a/drivers/infiniband/hw/hfi2/vf2pf_lb.c
+++ b/drivers/infiniband/hw/hfi2/vf2pf_lb.c
@@ -483,7 +483,7 @@ static int lb_init(struct hfi2_devdata *dd, u8 si)
 	if (si == VF2PF_INIT_ALL)
 		return lb_init_vfs(dd);
 
-	lbd = kzalloc_obj(lbd, GFP_KERNEL);
+	lbd = kzalloc_obj(*lbd, GFP_KERNEL);
 	if (!lbd)
 		return -ENOMEM;
 


