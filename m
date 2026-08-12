Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010009.outbound.protection.outlook.com [52.101.61.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED8A470447;
	Wed, 12 Aug 2026 14:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786546793; cv=fail; b=BWpHAP/SKrqBAlL3ACqTIqXAXh76RwbSCy5mp3qOaQlTIeSJabbAq7IsVBZrSpImBmTsaJP5wMI5dGIp/MpVqYHm0R8yls+e7dn6/skCZogRJ0y6n49XBhZLPbyKFdDYa+faBRaiH8kx198mN4/N7PzIPbRCByHx5ABN2/RY4p4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786546793; c=relaxed/simple;
	bh=P/3ESIMNbleyye4T94++SAlquPb5/QFJ9ZN7p5KZy7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=co/68FgWEjQ0oS2v/9O2A0eVeMweffbceLLueyFduBpnA0Eyl+VD6YpkPKgrRwJsum8StRrBLYhNEorY4u9uF5E7ZzMhCsplyMuhvPW5bZ+sXTnWhmkxnBIq5sCjqozHP3gmUZYKXbT/4GeOY+AJCjaXmfwEPu4DUieLAoyhevc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NylvVhf2; arc=fail smtp.client-ip=52.101.61.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NylvVhf2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MVP38LJiPobpj1K4V6RZm6ONv8EntaPj7hZ7lQxiedJ59WMag5rHQxkHalyVStr6QhTbuanLOOgP91Jb8rg0mgWOi0ytpxwJzTKos6oe1lZrHYGG+le3qNQe33Rpx0JDoYzHE1JpoTDsCwuydEfInwq7kGP7zpemaSuzSkvjtMWkC5expMX8bIh/WsVYJJDPpsIitFSAZIAG4123taQ5tIg18bTyIvkzycRxNWMG6Fsgum///QFEfG/rAs11ZpA67tRXlE+SamCtYNWLL6+dxcWfsdP7OtHbV+vTeuVfzY2GOLve88R7LNcOMUb83gWjduFzLxYhGJ78jhzDdF4rhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BamDaAGeNL11L1iusaRkuWGgqwvqBeFAXZo4PpeTCSs=;
 b=FmyCBmjw32cBExO4FcIKPp9ZNZaFqgkvz0LS8N3IP/MTTSyCXXeBnJnB35XM9Y3xaJsZspJ32cKqKC2kqmOHH14YS1FNgctBVwFfzPjX/AEMKOov7n/EumNUVtbgEG8/UA93NtXAuerMk3fPeUySIUL3TKV16iKbkGHtIufFi4BQmEvSW3yKzy6JBMmKBosot2BSeo+dLTEMv7WZ1Tm/VGWTQLC3ZH9xs0PsDfEgccCD38IWmgyyXvOZjqa68gXgpDxLYIwzLsMkclmN+JqCCz3uc0Sv3clgX9vB7HVj1+UJnR69snDPMsOVkWiP9gHALKR9h9vJ5p+D8+mO0vy0Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BamDaAGeNL11L1iusaRkuWGgqwvqBeFAXZo4PpeTCSs=;
 b=NylvVhf2yjvgh7wYugHepAsDFF5IqcFZ5y8seGYB8m1LwhFVD8zUueFwl0V/H7/dEkV7ulSG2Tgbdfx4dvNtYK09+oK5hRc49ZNx/bF+tAy2ejsTecgFW8BZfnQLYvC5AXoP4M/vWdGrhXRdIlVxyuOblw8cUUaxt4KOMupnrhnJLSU0junwN+cPciK6FbYN5+wDJEOa9xDcv02TZ/kqQdC3t3ce1X+1BiKTv+Z0wkG5DTiKb6mLXqCiem4tg64wcSNHqumJI3mKL0RPxXSVrnsL8Pp69+DcSqD5gGz0NayqISJTlYMgX8Bcka8NgKHfOMYyTy9B8hphayuEJSh5Mw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9654.namprd12.prod.outlook.com (2603:10b6:930:ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Wed, 12 Aug
 2026 14:59:18 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 14:59:18 +0000
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
Subject: [PATCH v4 06/10] vfio: selftests: Allow drivers to specify required region size
Date: Wed, 12 Aug 2026 11:59:04 -0300
Message-ID: <6-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0917.namprd03.prod.outlook.com
 (2603:10b6:408:107::22) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9654:EE_
X-MS-Office365-Filtering-Correlation-Id: c8f71925-3c5f-4c89-cbcb-08def882451e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|11063799006|10067099003|6133799003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	/kjLFzwG43Bn6u6VVaj1uxGa9X8bxxf70nJNS+mEWPDYhm6FzACSwoVJlDhuq+1+e9ZfwzEaLTyq6vXreZx7kzEkHLTvDayct1mqRds7N2V3GijmzlZMFNkeVpo3xRecW3VA2kL7R2PN14WtxpE/483WAL6Btcyv81PxPLVoFeUNGNTZr1OBB6CYUR+BtS76N92v4xNmSpIRWtk9LNCzS0jVn6hjlhgcW7nQtVEOuKmwWRBSxgn0I2TKvnAugrBTBIrozEQZSsIHhrTE4Eh3Wowgn13fslLg0h/m2EkP3iOVuPY3mAlgaRmQZpOIikJTRyDA+aAbanGXCuCW7vCPV2BoG9Zobmu7oUnGox3zxgN8vGVDuNnQqCXvB5ias6/W7lxV4HhfiOO4tiUzrvTGyWUAo171EQjsppucK8vVYnBpPD66ZmvLWn4TABhpC5X7A3GCOhlu7EaE2s5+jgWJjOu+dEABz9YQCHtL1R/ySSx4LZXUlxtsywvrhHbDOTsKOLTOD8jDp4llFF1FKXezAuiEIDWQUcjrRC8kcjW6dalKCXcIMXdp7/AwrYo/YJmzh8k9bmToSs5I6Vtui7BD54bWOOotMPusxfpha16juRJncvymNJPChFvaXBxmH9B+tm7+/C4+W0jl/2DY2fFwTSs16UN5rRoEJam/9vEyfypKn63H4lyxY1K7vDHRcrXuZwuBDdvknzDnOzbjt6Rf8w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(11063799006)(10067099003)(6133799003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iQAFHuHMmnPQXLbVXcmxbpy8J1jeHmseKGYVjiY8Qf4S9/XT44S7O62yspiA?=
 =?us-ascii?Q?5P/ijrE1oQS/EEAeAWhde8VyfibKtkXfl63rBepoNnnCjVLfeJ08VFPtNBoE?=
 =?us-ascii?Q?pt4JFerLjZJ5aihH/UBZ+3n5CFBEVpGy6gsd/yksUwuZKyihtqu6n5BPLugx?=
 =?us-ascii?Q?ZRQABjTEIlQZ15DvkOoQc1bqrLzbQLrHn4b+vl4hupBXKXWYxbyKr4Aj54xc?=
 =?us-ascii?Q?4HKaNTKI+bL9h5WGVGhWxnReSYtDLS1/IvQcFCfAMVB6V6kdRS1k9sB1oAjE?=
 =?us-ascii?Q?+dxAzcEB8NxGl1UxNEDa3beY/K9okL8WhPFpbzzrncSyiRGosJaQCug5ywYR?=
 =?us-ascii?Q?6o/a4JacmDVU1JXAqiU4I9UmBDetxoBcR+Q7MlCNuCAO/xpdZnIpM+4avTjl?=
 =?us-ascii?Q?rBwW9wHl3YoNTlLZGDL2cCTJmcks/Ih1IK/Ko7N9UfMXrL7/naKtZsrDl+nY?=
 =?us-ascii?Q?S0m3U6quBw6mKhTzdzSZi3GR0sHBpacmpGW/pDsEG+/Eu4t5403GVZC3S/2c?=
 =?us-ascii?Q?PuEsxPckmxxsk5Jsvf7KK9omyEoWse8eWdBF/89TjFsBxFTbpuW3KSr0qlsB?=
 =?us-ascii?Q?rX77PZUfeCUWkqyDoyTu/Ly69N+uq58Bnmr4+BMYPZk/TKi0+OirB8EP716I?=
 =?us-ascii?Q?w4anKxi0vkvwu6m1yB2P0cLiK7v0Br1wv3maVUjUu8pVfS77pthmHo/dj+bk?=
 =?us-ascii?Q?aGzlIbACU7dVR+rdOUAn8Q0gRtYj/2dq0eb4N0srGrpbn/42YtZdsia/SAOB?=
 =?us-ascii?Q?UG6iVR9Wdfswt9fNDaYvdd1xjOGTHpNhphTxo0qdHj586C34OwRW/2/24Ipk?=
 =?us-ascii?Q?x9FoFKpN/nyFHFM7z4lZOUx0liAvQIf1nLUxDu1Bx8ojPKIMKNaIkcReUaql?=
 =?us-ascii?Q?/kxc55NKUmUCa0txMwhSnfYNU1hcrdxG6s7CaX6ulin1BJP7zef6OcxJ2Juh?=
 =?us-ascii?Q?htShbfHjx1dLQoK2uFdhOrZOEl+VYcRExmrdyLJqVeLa14RUf9VfOdE41fKd?=
 =?us-ascii?Q?P6tVnJlN+HO4OTdw+9fOAuwKff6DmDs3WumBYm8p8g3WviKU8FwX5Mux/+ui?=
 =?us-ascii?Q?DjJe7lld0+17AvWd1+I+3uxT4QYSY8IWNfQPMy9V9cgpjFoktGhWmY9bvkpZ?=
 =?us-ascii?Q?cxpumOlb8fVFfjt6pEierXOHyC3Hf822KBI/K7DFxISWKObn3egXP0SV93jf?=
 =?us-ascii?Q?8lAEQrKzdAWArgD7iXdWsge5kUYeuB25gcNCIZ5g9IRnVL2gtuFaxm6Z56M9?=
 =?us-ascii?Q?xRZLu+lBxUDq4LG1IucpyYm4TfkTNK1TN2CxN1iRFwr1O+X1ePHqI4XBeOAz?=
 =?us-ascii?Q?nLsmdu/RdSEScR8tFGwChdeFOyATxLBLA4jum32iZMgCPmYt//6XuyRBLLR+?=
 =?us-ascii?Q?otyL433+cajgrwwekmfHY91fsJd8BSHpWqWGc6Mt/OSmmGgifp1HvJVHwBoo?=
 =?us-ascii?Q?PVgybYiCWwRH0ljmiqSunDxY6XjVNRPoDo6ob7XGhq5CqhaRKSonolU8kRpn?=
 =?us-ascii?Q?vAuG++zRNjAfasIQWiYztPNNYY3FDtYeUwzy/XYGw4Dtm/MnE6iO14wMK5lc?=
 =?us-ascii?Q?LBkuJMj2RBMuKWKgUB/2X2/x50GpefiT//OBrNgd7uEqdXdfLAbYSL7JhGjx?=
 =?us-ascii?Q?bYBzV4rn8vsY2+6bRfoqU7WsYqlW2D7Ewt26V8HYS6rOa4dcDdMAwkzq2ZhL?=
 =?us-ascii?Q?/9OoKaCbKHDpZ6DetbUlGoUl/7Yzz/6SQj4KqfsCOjOXHd5EXJkYOzVUEyAX?=
 =?us-ascii?Q?To84QVY3Nw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8f71925-3c5f-4c89-cbcb-08def882451e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 14:59:12.4766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k6ifgh9lHKjob65dZADEo7HbGjEpn4mp29n4y0XkZVyIZP2cFCRvA3KNAhSdzPUg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9654

Add a region_size field to struct vfio_pci_driver_ops so drivers can
declare how much DMA-mapped region they need. The mlx5 driver will need
~18MB for firmware pages. Existing drivers pass in the sizeof their state
struct. Since drivers all use only their declared state we can use the
value directly and remove the SZ_2M hard coding.

Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c          | 1 +
 tools/testing/selftests/vfio/lib/drivers/igb/igb.c          | 1 +
 tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c        | 1 +
 .../selftests/vfio/lib/drivers/nv_falcon/nv_falcon.c        | 1 +
 .../selftests/vfio/lib/include/libvfio/vfio_pci_driver.h    | 6 ++++++
 tools/testing/selftests/vfio/lib/iova_allocator.c           | 5 ++++-
 tools/testing/selftests/vfio/lib/vfio_pci_driver.c          | 3 +++
 tools/testing/selftests/vfio/vfio_pci_driver_test.c         | 3 ++-
 8 files changed, 19 insertions(+), 2 deletions(-)

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
index 4a660f636f4972..c8075575e9131d 100644
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
 
@@ -50,7 +52,8 @@ void iova_allocator_cleanup(struct iova_allocator *allocator)
 iova_t iova_allocator_alloc(struct iova_allocator *allocator, size_t size)
 {
 	VFIO_ASSERT_GT(size, 0, "Invalid size arg, zero\n");
-	VFIO_ASSERT_EQ(size & (size - 1), 0, "Invalid size arg, non-power-of-2\n");
+	/* Adjust the size to the allocator requirements */
+	size = max_t(u64, roundup_pow_of_two(size), getpagesize());
 
 	for (;;) {
 		struct iommu_iova_range *range;
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
index 5e65434d2318b2..52b9c2a2bbb9b6 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
@@ -32,6 +32,9 @@ void vfio_pci_driver_probe(struct vfio_pci_device *device)
 			continue;
 
 		device->driver.ops = ops;
+
+		VFIO_ASSERT_NE(ops->region_size, 0);
+		device->driver.region.size = ops->region_size;
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

