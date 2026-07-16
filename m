Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012037.outbound.protection.outlook.com [40.93.195.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6766433BB2;
	Thu, 16 Jul 2026 17:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784221422; cv=fail; b=grnRU86+CRvLP1zRDD4c5RRQo3z3XTJ+3gBaHos5w5bRRMs7GEeE6DeNj3x5cpobZpwJg1owZp3I1B9/N3ZpgHi2xoRWW+XlwKX/TW4xFPBdaiPB6lxg9Dw2ZWa4Js/19yEytipVbC7kWOhxvz4jjWBwzRYmDvrffBrMtbXo9ec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784221422; c=relaxed/simple;
	bh=oOOcHSx2qlUQcSEuf2XLOol/PWw6kcgT7Ln9pkUVbUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bLSJKD65fyXgD0nwqxkZrzcMiVvU2UArEX3Stv8vpUGccodJIEjp3j4PCY/7qm2J/bzeojTpsOKd1dEOR6/+Y3x2KfJ8xmksNtgn6RUnIChp3Z4Dguj5ZGasWgpYyuZp1jWLHiQCajfzJfqCS8FNaJoQ7hrNjbWpj/DqwwLBfQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qdPWZRRR; arc=fail smtp.client-ip=40.93.195.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qdPWZRRR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M4jGU9dWHtEKxi1bCKhsLRkJPWKRpvWbUr/rXJYMO197hDe+9OFmfbZNhedXsp0dpS3PaVhYWfiFdM9tPOZmfa+HnoSJAERTTstwsLMA0oM/4+2xBfIz5/lPVmqZwTpPF0fvooM1nxPCVkJrHD+joMt/f5IG74I2vkKpIusSwKyaro/LhxqyTBQ+pq0caEFvDr1K16czpLssEbyZTE6wTXCJQsjfsK3MVjgwzYeR8nMd7mvAnP6kZLGHnfIb6WpTIZaDrQFPDjN+nZdstnEbP455jpB2eb29LQCO3xyLNLtrZwVb2V1lHfqecG6P1aAZG+yt/X0GjuVJVdk49xYtkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zqW5lNkQGWPEV40Kswyj8RFYtCdPTTApDQxuHmL6owE=;
 b=WURmepXJjZhtZUvqnKcq1KxbW2/sGV/4fNiDbIm9pVB2ZUH1wgv4LHsuQUwaRJA75+kooe/xJnXatq2/QDltlcAFkkmCdvb8GGFYIijxsmwZ2ZfenriNV36TfmF1dYas9tHamQdf0ChtWDIXTeGlZose9qazaoqtFPIEsKG9Az+G55bETRhX08+M6PRSOXZgAeHc83+5czt0sV5r/7FtPUkLMIad124VFBpBdKJ70b8hqui6Y4t58FcZyvXnvEeAFQBg3qJK/49yBl9iYEQC75+hed016oaDXBeOWMbEi3hSRq0BJNUBO7BPaYIVBEZIZWJ95T5roZ5OCywQn9lOdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqW5lNkQGWPEV40Kswyj8RFYtCdPTTApDQxuHmL6owE=;
 b=qdPWZRRRjyg4Fca6zaNIrl595d4kWXh/D0+mt7EMxf+tikXGreWlAjiQwDePbBQeuayyg4IsuoXD6SxymcoVxTPKTn50qE29fcJoPVcORigd6sCnGohP+kVgcLNuGwcckHuZCQ45VG7nzfTJxEYOqt7as6anF0oP9Yq6QJDvuKvl29Cq3aBjbV0BmYGCS4dD0aDn+2EGdUvlyWSWqM+MThkHHZvBXqlj8XsXnF7uaVzLLvZqYFocNUEedf2ykrS8fG4FZrQ30JSuDV4WCrzMlDfLDBF3o1guFa29qpX8bSEz9LN2mYd3eBhqjcDufhMKHp8fYx2fdASoZ9ktQR3SHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB6216.namprd12.prod.outlook.com (2603:10b6:8:94::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.12; Thu, 16 Jul 2026 17:03:31 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Thu, 16 Jul 2026
 17:03:31 +0000
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
Subject: [PATCH v3 07/11] vfio: selftests: Allow drivers to specify required region size
Date: Thu, 16 Jul 2026 14:03:23 -0300
Message-ID: <7-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0022.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::26) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: f2894d73-df77-47f8-c84d-08dee35c28e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|11063799006|10067099003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	fAvzqtIHl5nxQAKcx18IrXCcSG5JeSxLlR/2SRcPanB90nrjJA1sZTuOzmU94HORHjNFAjZU9mKlykdE2ikDqAWPvtGsvYxFKUuFhGAqlcx6UE9YHyf+N2qw9pLgsn0aR8HIYnrHzI39RUTv+Auu5HRB85tyL15cLeBZjDzzfIbG2mQiv1W4j9/DQpYP7pm5NJt9V5Ub0jcaTUetbn/vK4sImntOpTX3losiqPwkGrww9fS5UBVH/2+ler9mZMu9CF7W6EWm4YJ+xxWVy/hy1r9vpmbvL8kLI41/ClHRH6eDKXu9SBPBOiHasHc8nJY2CN6tCYRIbUqLoKHc7g7I7AE+Kxd6xhbeNd5Z/T2BvUmRBHoHbX8FF5Qwy+tg42ci3j9JDFhBPL9IiTshHZF9OEefFobCuQh4HFaguR1QMIWg4YO8xnTFQ66mCq5+v5dIamth+2Od97jhWltS4fO/6fzgQf0hqO8+ljXvXsRPbf+AAmNSv/nf7UGO98fkltYUz9zbELF0OV6AYmYuCJtXqmUJhNSQMlxxZYy1YgbWCHnuX9rwdH0ie4Q91i4lmAnXi22sg21g0srhjFb1IZOvv+KrDw+foOO2agNsfJhBdWiEtdLtLvLhjZ0q39YQAx+LGboBlMSOmBWJSxpNS7aYrC2IzuGtAEaQRd0cQoJK4YS1sC4T/f7v+cpH7q7rxcPdvsYzMIxm2Lc5ynlI84CYbQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(11063799006)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mSsucpXBwG+kR4XbpbAhJE58ZUvMAkXiZKa3LhDNBvD/XFJj3KYv95SPLTTY?=
 =?us-ascii?Q?NziLWXtgG9fClfvQoJ0myQiDTLPAiRsMnnx5+krOJN14xWgNunadXn5tUAu3?=
 =?us-ascii?Q?BW9L/xzRg1huJ7ineIVZI1uEgUWYnaC9D/U8qtJ+r4vgkCwtwOD3liFo+JcX?=
 =?us-ascii?Q?311yhUnzelYiLiEFSflaC7kVXMeYCnjFMUI0foyl5OYHbcTeR6lehOP5Hf8Z?=
 =?us-ascii?Q?Z/t4J33Rt5jDHW0GgKKXTEDfI96vUgAm6Y30fA6cJ8nQiyS7vqLbtHW9BoIe?=
 =?us-ascii?Q?bzi1iL8xUJNLkvgyCj7b5aAKSJ75ehypunJBMwx9eC9tWD7ouM4kwjBB1Z+0?=
 =?us-ascii?Q?lztrgUAsONsmIaapv/hxTn9cRxsF/W65jDLJhBLO4/cmojfiIxEHcm/BhhsO?=
 =?us-ascii?Q?/sdebAkN5MlXdn/Clv3Xx/dhNvzNdQtjgmVVxK1Fmj195n8m0NPlDw2unSK2?=
 =?us-ascii?Q?hUqHTjkdyXsMQPxlVP05vHJShvofhqEgBlE8C6/tmpddHgAIwG3UIGW8XYrt?=
 =?us-ascii?Q?HTD8foSQU1bPwfFOvItrACUO2Nw0igZTkBBxA/+lsFM08y20/1jG0hmXV9MM?=
 =?us-ascii?Q?GvgY3GdOiJpCVdLdxYxSGjZOOJOkwniy3fwCSmfvVgs38jIFcta92db6BMVy?=
 =?us-ascii?Q?txIOHXB0xcI3pXbCtAV0wT3vNj1ukBgbNZPMq9dCgOyOcv8S/u9WSTXVpQ3z?=
 =?us-ascii?Q?mVAHcHo7Vi9tSa4jHEbkmW8egQ9MJDh+tFwm0k+VShdUXiE8Bb4rqwphsRby?=
 =?us-ascii?Q?sADSDDyPRKbVTuIdWWqQlID9s19kYShppTijkig3qL+/UUrLO3Bw/zafEkjk?=
 =?us-ascii?Q?pWpCMInAONh2H98bEMHrWRKppUCuSesCpxHXkQ8X802inKvL6zN6EEX1iIip?=
 =?us-ascii?Q?Ikoa/vkJtDIC3QXUI76PHGB9tXk8eXB39NCUPeWGzi+vaevOGKSimDvuznW+?=
 =?us-ascii?Q?Nnt7DtlvzpRTyvUjcd2MWr6nZVSLpF5e9avu9GLOV9pVdadwQphUKcFcIC4P?=
 =?us-ascii?Q?2v06i47ROflk+rWGKWbfSV9Iux+MIVbFwJZ4RChxgYPRPM7zsNKwwOW03YqM?=
 =?us-ascii?Q?OW4fY4B4l8X6GjI8oR9ZgvMGJXJoOYhjc0JKVavonaI375OI0CnwPzwSM8ns?=
 =?us-ascii?Q?0QsrwLVoGz9v/cBmEChZpp/DH2PHGCKh5WaD2yh4xjRBMo9XHxiGbJrXYyum?=
 =?us-ascii?Q?mvEFNrnYjAC3a5CKL482lTs9J0bJWUnYNmNzb6YA5IXjTfnTD8KjFIJ86DMV?=
 =?us-ascii?Q?IWDY6yvgJZZc3s/NjrIhfntUKq+kLSX+++6QTwaNXmzupOwYBGPnAYbAHzse?=
 =?us-ascii?Q?QaORm9vZNwuAGhKTOZIK/Qeo84lB1Av+efc86oQoBnc8FQGxuuKmnQCWlMp/?=
 =?us-ascii?Q?2AHeC4UeH1U0+HhQXqvDUMb+G7ipBdQlxy2Rg4HtScRw2reAAkox10R+5clx?=
 =?us-ascii?Q?sbOgSVl4GcPQJgGKjO8K8x9Xib83J4/YLf80OMEPGpZRu+O5XUL0DmMdwNL5?=
 =?us-ascii?Q?Z/3u+RoYc+UlxSHGE/rRna3CGTV3RpHvNcgWwfTlWl6w+Yqg4DKbV0gikPWY?=
 =?us-ascii?Q?TOWYpePxnPyiuGBvE5vRGWsvMewGpzlFJZozCaZB0vL2aq5WlJzDjIMkmOPY?=
 =?us-ascii?Q?ZkBxCSCLXXQ+9hlzxPRZknt+fCDRYu+Ncd7R3vB0zxUFX4kKe48c+KzjuKdj?=
 =?us-ascii?Q?5Y6mCksc+VYMjJGa16qtqdjPr1hiRhnGrHVeAb4y2ViWsTF7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2894d73-df77-47f8-c84d-08dee35c28e9
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 17:03:29.7664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fDLh/11ulqbal9EzTBCUFCfwrdZBjjLUrr8CvXuICJuVjEqy0Ug3f3zllLXbZQMk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6216

Add a region_size field to struct vfio_pci_driver_ops so drivers can
declare how much DMA-mapped region they need. The mlx5 driver will need
~18MB for firmware pages. Existing drivers pass in the sizeof their state
struct. The core code will round up and minimize it to SZ_2M so as not to
change any test behavior.

Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c         | 1 +
 tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c       | 1 +
 .../selftests/vfio/lib/include/libvfio/vfio_pci_driver.h   | 6 ++++++
 tools/testing/selftests/vfio/lib/vfio_pci_driver.c         | 7 +++++++
 tools/testing/selftests/vfio/vfio_pci_driver_test.c        | 3 ++-
 5 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c b/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c
index 19d9630b24c23f..40b8541b588eee 100644
--- a/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c
+++ b/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c
@@ -418,6 +418,7 @@ static void dsa_send_msi(struct vfio_pci_device *device)
 
 const struct vfio_pci_driver_ops dsa_ops = {
 	.name = "dsa",
+	.region_size = sizeof(struct dsa_state),
 	.probe = dsa_probe,
 	.init = dsa_init,
 	.remove = dsa_remove,
diff --git a/tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c b/tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c
index a871b935542bad..c9b28365c5eb6b 100644
--- a/tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c
+++ b/tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c
@@ -226,6 +226,7 @@ static void ioat_send_msi(struct vfio_pci_device *device)
 
 const struct vfio_pci_driver_ops ioat_ops = {
 	.name = "ioat",
+	.region_size = sizeof(struct ioat_state),
 	.probe = ioat_probe,
 	.init = ioat_init,
 	.remove = ioat_remove,
diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h
index e5ada209b1d102..547369c5cff95a 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h
@@ -9,6 +9,12 @@ struct vfio_pci_device;
 struct vfio_pci_driver_ops {
 	const char *name;
 
+	/*
+	 * Size of the driver's state structure overlaid on
+	 * device->driver.region.vaddr
+	 */
+	u64 region_size;
+
 	/**
 	 * @probe() - Check if the driver supports the given device.
 	 *
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
index 6827f4a6febe99..e13bbb7ee423dc 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include "kselftest.h"
+#include <linux/sizes.h>
+#include <linux/log2.h>
 #include <libvfio.h>
 
 #ifdef __x86_64__
@@ -28,6 +30,11 @@ void vfio_pci_driver_probe(struct vfio_pci_device *device)
 			continue;
 
 		device->driver.ops = ops;
+
+		VFIO_ASSERT_NE(ops->region_size, 0);
+		device->driver.region.size =
+			max_t(u64, roundup_pow_of_two(ops->region_size),
+			      getpagesize());
 	}
 }
 
diff --git a/tools/testing/selftests/vfio/vfio_pci_driver_test.c b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
index afa0480ddd9b2a..f68239da574f5a 100644
--- a/tools/testing/selftests/vfio/vfio_pci_driver_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
@@ -80,7 +80,8 @@ FIXTURE_SETUP(vfio_pci_driver_test)
 	driver = &self->device->driver;
 
 	region_setup(self->iommu, self->iova_allocator, &self->memcpy_region, SZ_1G);
-	region_setup(self->iommu, self->iova_allocator, &driver->region, SZ_2M);
+	region_setup(self->iommu, self->iova_allocator, &driver->region,
+		     driver->region.size);
 
 	/* Any IOVA that doesn't overlap memcpy_region and driver->region. */
 	self->unmapped_iova = iova_allocator_alloc(self->iova_allocator, SZ_1G);
-- 
2.43.0

