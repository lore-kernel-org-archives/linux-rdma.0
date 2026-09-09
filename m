Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012068.outbound.protection.outlook.com [40.107.209.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7264652ED40;
	Wed,  9 Sep 2026 23:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788998272; cv=fail; b=uR0YpAnIj2AqmQVmbgNIFg8/W3nCkEWsHIL5iMNYIfhKne/IM6nM6S9FUUu5Ar9fOsel8txCr4NcCAu6xX4TmpwIUEbrZ7e3+tj9DkZhbrnntUXi+srbzREUVTs+lKqMYTBNceHKjlKigS2rpP+3OFDiAwAAYEImDtfNHlYjxBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788998272; c=relaxed/simple;
	bh=6f6di254hmTN9eqg8Pl6cJXZAZOevbNLRnXxzXOZgpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A5AGniUVpMa7cgRWTppnyHU0Z5tkKeoXAkKSnf6EAR8gd3F76SOOTJsK8ILQ3Xlw6nGHGN62WU0yxyUrgB4MbVHNp/hgwc9S/8II+Dz7dE8poDlZG6SAbyRr66YvngkzbaTtxTZH71VEJ/sdr04vSV9E9UsoO1WSza6yD5Q9WoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KwzMbQIv; arc=fail smtp.client-ip=40.107.209.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KwzMbQIv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SFPVKHFvtyMUApzUPEXrzVCEgyOFFMseRZTc5iim5am8i9LRGyLrwxBCXaVLsAX3A5YDEh6+ylegmM08dAzhEq1sTczkhd81JOgquG9UpzKvn3Uz8PVRU7wSR6cYh2/JSvzXzEDkO13icibN1jHdkz8S/2/oYoCBWubdknzxmb6dV3W4jJpQz5sZWa2dTdmU6r0oJGCbeXKzJ10DF5g8Cm0V/WtUlOO385lP4E16WI9Hziy5NNpUl89vrsyqyQSdLVJuU1tey1OdC+iCTQwHTRGfANUJT2sKzBacPNrIksj1Tnmf2KY3EYsrAAMTJXJuqnXmVgDpoYMsNj8sa6EZSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e8Pb5DHq8Y5nOLvjaFv5w9DkGUZdXXHUZ4nF/aoHjBw=;
 b=oC7F/L90k/of4kg0kzouFGG5NwmaosYNwUojlI5E8IWm9AHCe/ttXJ6CL09GgFO/dae+/qN5sGRnkuMKCDR/CUHeVSnn2o8agi4t1iEnEhWfQpR1aXbHEpwRmt33Ynh6u6OAAL5DuiAeCLXIYo9PJeLYNa9gfazD4djzPBPcPZoSxHYZI+A4RWmXu3wZmNP0V4CT3Z8IOJ4Bcx0C7Wa6uHTa8134zITXwnJ7dmkW/WL/Hg079Lk11pNZg5su0EeC2dFa2VvVf9wMpdXMadHp3TtetLX7BDgZf6l6vwjU+dJvIDQCNq0C1XMXW3YpdzwXS0Nqthjt/R3XKhq+c4+87Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e8Pb5DHq8Y5nOLvjaFv5w9DkGUZdXXHUZ4nF/aoHjBw=;
 b=KwzMbQIvtyYzv9/G0780ak/Sp1Xa4DUIrnkiAwkTx3xqMoh7G9KqopdsqA/dAkLZOiaQdCzx0I3lOvUidTOB5tli5axQi2zlL45wBmIqIwA1AUp4B37LyWasxlW0IsVLHeOe2BXSATF1mOwYLwVDUSmWQpFk+mZVZ1lzIf0bn3gEzL/+YinAuaSpuBKAFZHTSzfQC4XljWnKoYUtVIK/QqvLKIJ0bJs3sjYzBRsxsgECACXsZRBVUBPUKP4wdQZtcWTbseihGiRIRyDCvn4DH9bpK2K+BdEGHqQUc1RAoY6F1ivOuLatWMne4Y15wH+s47dKfAj/1jANdC68zpga1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB8418.namprd12.prod.outlook.com (2603:10b6:8:e9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Wed, 9 Sep 2026
 23:57:40 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 23:57:40 +0000
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
Subject: [PATCH v5 06/10] vfio: selftests: Allow drivers to specify required region size
Date: Wed,  9 Sep 2026 20:57:32 -0300
Message-ID: <6-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0448.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::22) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB8418:EE_
X-MS-Office365-Filtering-Correlation-Id: cefeebdd-1c24-473f-81da-08df0ece20e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|921020|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	f5Zg1KGBbS/kIQAEGusb/N27ldll1Mjp/qW1xxrzk7JruEOFg4NSyoiZ9uWwrhF2AWiyxfmcgi70Dul2VDC8C/qQjkAm2FwZCiIncRKWayReLNatQOrIM/vSAsK0fzHxIgrDt8P6+LPlz56JsKnWngWUDswY9mvOH74Nutb1JizZl3RhmFAA+tyAUrRT9TvAlTXsoVsFBaXZtwurB5oMuGx6MVneBlVu4BSfH5eKZa8TiunJ66qoJPQ/8Ju1ZAcjg/V/TaW0ddJTB300Fjw49eZ8ZCTT7TZ6mmerZmdLhC91KW32NZDY7Z4lShEwc5hj6O0krVyUOc+h4gcVzThGFsmIaVNmr61xxLniHW11GPxh2bWEGkKF86qHYLFxtjQ3YexB/mPMaSoxHT31DvbdgBJ+Ga4scKXDhcd2nglj9lArrOSXYJ8vcBoSceKp6FcSrveXQfqXU1+EOvNV8H4IXFAYLU+qZ/7uTzWL3mCDvqjeH9FSw6A6F/gD0joY87NA+j/njcKU4ciFfpH7iNyquoBGtQURt46mDUkDjr5hyy3+1fe2cvwJsyps/y09LxNIWECCFiD6lbSgUD93tnSVqeeJIGS7NzlnxWrOUXFrPfOj7oVcDUXgj85h/Xhyu8ncd5ciS6ghdx5mNhHyRh5U7yrqsytjbtWp6CYfGjO0VPAFE+i/X1bMBljt8TMmK0NOm9UiSjXVIXUTr9yQjfHVwQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DjLwulrF1LkROG4PvC5RKmWhoSEYCPAMPyn6PHekSuNZTd8drlYgCaLieiau?=
 =?us-ascii?Q?+MgER+ojw83605cDUkM5uWaQnwQkcpf7UExDgsSerpgoQR1zhDVwEfNDb2eh?=
 =?us-ascii?Q?M7VAXUt+f5K2AzxVlfMifYsvGSg1r5HDNm1DIIwS+vLrTeDuYfcuc+sIL9bj?=
 =?us-ascii?Q?/UMrAfyNt17XW2XH3X1G12iJS0KKyzd8hiUCjKIelauLtQL0ORQMhXCD1Z8R?=
 =?us-ascii?Q?ydllTmv07qeuQSwv7AEeWct6uj/UK2UgMKk7vpceD5l1sGUl1qE4GoeLk8qd?=
 =?us-ascii?Q?yYdL2H9b8uyF4/ykTfbHfX+zjETnBmbwhIWXsDSV7/n0hGn4AjMI3m0YmEVX?=
 =?us-ascii?Q?lLuiiYJ1OMosiC6f6gCaIHH0axIHSvhteawhxWZa6+1V0eczaJuH7mFtH8OL?=
 =?us-ascii?Q?yNLUn6i8BapjbN00EhdwLbgHtZMjyp40bPq4xSRpaR/1O+JUNdr7Q30SpkjM?=
 =?us-ascii?Q?ro/m5Pi5J17QezHPzaFq6faQn5dwjyCh/wG4xuxYuqjJXG8CCsH29zYRt62M?=
 =?us-ascii?Q?Nin5DpEWByodBV/1aal6mPSAXcQHZfesGUcG4pWS5F5NbTSdB/q5GiTNApGJ?=
 =?us-ascii?Q?OwY2nORV6CSFqTopqd3GVPP44pShmrGavUjdeUsIi/hNSJfj2t4soEUFASm8?=
 =?us-ascii?Q?I+iwmX+NEnz4g5d0yXvYKNbrTsQJDDMwf8XCweBAXzbSiMXTjIFxdbXj45jm?=
 =?us-ascii?Q?fcJQ3WSSW2BPXYJ/cAe1csI3gb2GgFlUZjUmen4eYvM7haNlqiRInKjQWpqW?=
 =?us-ascii?Q?PjRphIQpTStLPHy0tqKGqPgrFQwlW3F4VdFauhmgjuIY7sQ9INMCS2uW2qqU?=
 =?us-ascii?Q?I5jb3G8t8NRqampvBYZn3UswJgoT4+La1dAoU3Qfqqa910a6gwcRF1RfYmcp?=
 =?us-ascii?Q?+BBLLtYSnjlN8fUcmZaThtqnxSGTxNFmaQspA4EEeZm9lW7PDdo0YTcaWbDf?=
 =?us-ascii?Q?HVMdt8JK7MBHrtFpBAaHdBXVvqjELMW3PVJFm68CQaAW+uK2dBXOMKk73Zxn?=
 =?us-ascii?Q?xim8VoMQPGFOlW6YJmB7OsxypHGY0uyVkhDMEQUN65omLADzLi9YbbnymUFJ?=
 =?us-ascii?Q?cc4ywLTAHBcLTHSi9NkD2sA5T6LVKGDTuIX5m7F6ErPDU02l4nTqvUKnsGPM?=
 =?us-ascii?Q?dUISkkqgaz+vwTA1nZvgUQP21teEBEUUHwxC5qf7U1vT7tekthiz0i588vLC?=
 =?us-ascii?Q?/L2v+jtWjfaizDC+nR+MTjaQDxRxMQqB8T41B0N8LbE8gGf51TiSi+7r97iV?=
 =?us-ascii?Q?8zp+J1eebFNh3Sli7IqX8Bf31JDuQlWGHo7wH7vaGMIYGQi4fZhYvzrP0iXf?=
 =?us-ascii?Q?jsWinmU13Z0XXSk541CDa6PlODYWetMtSfmemb0JX6V0jtESGOLxjotYV+eF?=
 =?us-ascii?Q?Kk7UCHux6fFkhj3viNl6YWFuUMnLgrZ3y8TIDAM/KzJzYABYIHXmcGcinT5E?=
 =?us-ascii?Q?nkqaonMJNnho6ja6Djc8xpmzLG4wZjM/LeowQfi3LiLskdxzYB0aZCiN9fLR?=
 =?us-ascii?Q?xUwshJLF964ujmrgXOOH3Mgdec6kuArWl6m1O9I38/PkHX+dD6QLud6k6Wtd?=
 =?us-ascii?Q?aZp8LFxs7hHlX0QnzNXDir5YcvrwwJD/rD5Z92kLbK3yzMv2qLKdo5b9tuy3?=
 =?us-ascii?Q?D+8YU6+PJtiQo4MQeLCypwx1NKlT45ZrI/L2w8APBxDqQbFJJ0xhnBv5xOCj?=
 =?us-ascii?Q?IxGR44Hsbdf3GWmsXQsozdFiR41mJXr1s/eFUMCuf8cOHZyd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cefeebdd-1c24-473f-81da-08df0ece20e1
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 23:57:39.2947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ukoUsTzaL8MXBOosxnbQ7tdOHzI4LSqMhbTUEoch5W7yZpmqv/FYMHq2l1TWPUbT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8418

Add a region_size field to struct vfio_pci_driver_ops so drivers can
declare how much DMA-mapped region they need. The mlx5 driver will need
~18MB for firmware pages. Existing drivers pass in the sizeof their state
struct. Since drivers all use only their declared state we can use the
value directly and remove the SZ_2M hard coding.

Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c         | 1 +
 tools/testing/selftests/vfio/lib/drivers/igb/igb.c         | 1 +
 tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c       | 1 +
 .../selftests/vfio/lib/drivers/nv_falcon/nv_falcon.c       | 1 +
 .../selftests/vfio/lib/include/libvfio/vfio_pci_driver.h   | 6 ++++++
 tools/testing/selftests/vfio/lib/iova_allocator.c          | 7 ++++++-
 tools/testing/selftests/vfio/lib/vfio_pci_driver.c         | 4 ++++
 tools/testing/selftests/vfio/vfio_pci_driver_test.c        | 3 ++-
 8 files changed, 22 insertions(+), 2 deletions(-)

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
diff --git a/tools/testing/selftests/vfio/lib/drivers/igb/igb.c b/tools/testing/selftests/vfio/lib/drivers/igb/igb.c
index fd9e05d77ea4b4..2fafcc9f51c020 100644
--- a/tools/testing/selftests/vfio/lib/drivers/igb/igb.c
+++ b/tools/testing/selftests/vfio/lib/drivers/igb/igb.c
@@ -576,6 +576,7 @@ static void igb_send_msi(struct vfio_pci_device *device)
 
 const struct vfio_pci_driver_ops igb_ops = {
 	.name = "igb",
+	.region_size = sizeof(struct igb),
 	.probe = igb_probe,
 	.init = igb_init,
 	.remove = igb_remove,
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
diff --git a/tools/testing/selftests/vfio/lib/drivers/nv_falcon/nv_falcon.c b/tools/testing/selftests/vfio/lib/drivers/nv_falcon/nv_falcon.c
index c08aa81c44f417..6958877ad4638f 100644
--- a/tools/testing/selftests/vfio/lib/drivers/nv_falcon/nv_falcon.c
+++ b/tools/testing/selftests/vfio/lib/drivers/nv_falcon/nv_falcon.c
@@ -775,6 +775,7 @@ static int nv_falcon_memcpy_wait(struct vfio_pci_device *device)
 
 const struct vfio_pci_driver_ops nv_falcon_ops = {
 	.name = "nv_falcon",
+	.region_size = sizeof(struct gpu_device),
 	.probe = nv_falcon_probe,
 	.init = nv_falcon_init,
 	.remove = nv_falcon_remove,
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
diff --git a/tools/testing/selftests/vfio/lib/iova_allocator.c b/tools/testing/selftests/vfio/lib/iova_allocator.c
index 4a660f636f4972..f70172f9ceb959 100644
--- a/tools/testing/selftests/vfio/lib/iova_allocator.c
+++ b/tools/testing/selftests/vfio/lib/iova_allocator.c
@@ -13,8 +13,10 @@
 
 #include <linux/iommufd.h>
 #include <linux/limits.h>
+#include <linux/log2.h>
 #include <linux/mman.h>
 #include <linux/overflow.h>
+#include <linux/sizes.h>
 #include <linux/types.h>
 #include <linux/vfio.h>
 
@@ -50,7 +52,10 @@ void iova_allocator_cleanup(struct iova_allocator *allocator)
 iova_t iova_allocator_alloc(struct iova_allocator *allocator, size_t size)
 {
 	VFIO_ASSERT_GT(size, 0, "Invalid size arg, zero\n");
-	VFIO_ASSERT_EQ(size & (size - 1), 0, "Invalid size arg, non-power-of-2\n");
+
+	VFIO_ASSERT_LE(size, rounddown_pow_of_two(SIZE_MAX),
+		       "Invalid size arg, too large (%lu)\n", size);
+	size = roundup_pow_of_two(size);
 
 	for (;;) {
 		struct iommu_iova_range *range;
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
index 5e65434d2318b2..64135ac43877e9 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
@@ -32,6 +32,10 @@ void vfio_pci_driver_probe(struct vfio_pci_device *device)
 			continue;
 
 		device->driver.ops = ops;
+
+		VFIO_ASSERT_NE(ops->region_size, 0);
+		device->driver.region.size =
+			round_up(ops->region_size, getpagesize());
 	}
 }
 
diff --git a/tools/testing/selftests/vfio/vfio_pci_driver_test.c b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
index 761bf117d624f8..2bd949aafd7316 100644
--- a/tools/testing/selftests/vfio/vfio_pci_driver_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
@@ -87,7 +87,8 @@ FIXTURE_SETUP(vfio_pci_driver_test)
 	driver = &self->device->driver;
 
 	region_setup(self->iommu, self->iova_allocator, &self->memcpy_region, SZ_1G);
-	region_setup(self->iommu, self->iova_allocator, &driver->region, SZ_2M);
+	region_setup(self->iommu, self->iova_allocator, &driver->region,
+		     driver->region.size);
 
 	/* Any IOVA that doesn't overlap memcpy_region and driver->region. */
 	self->unmapped_iova = iova_allocator_alloc(self->iova_allocator, SZ_1G);
-- 
2.43.0

