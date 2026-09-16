Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010022.outbound.protection.outlook.com [52.101.85.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32CF493642;
	Wed, 16 Sep 2026 23:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602639; cv=fail; b=n9XTTQxaYg5HuMS7y4g0ca6Gl2GlsRlB3laWZ56Mo61TIe9O3nm3XEEUiutOTi8z31JL2RhFkNyCsGhaHSReWgiwXtHb6u5Q/auDmA7+bhQwgTwiGOK/vkvUZFN8q/XSGRThnlVHATigw90gsrs/H4BuGWcMtcINThZowi0u/S4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602639; c=relaxed/simple;
	bh=Iqjflo6TX46WeHN1KS5E7XcLiGqysXxYuCsVOrhhJzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cStg6pFJF/IhDyuazmXaYhPvCBalT1p4p6QJYp8fzQ3DANQ1x49VPuk76/zcODl2kxj6Sgw/X6wfzGPvzXb699FIBK9jJ2WW6iUn5yjUAJz7tI4AasRUEiSg7knWZsFaguc5gtlqFRnAxKJzP05nkqGjVedyDz27QSn7acfCrxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UWpz1PYa; arc=fail smtp.client-ip=52.101.85.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UWpz1PYa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nV3g0Wo6jE9k5gM2AJL9dbZd/B6EeiFcidq7ZAwTI2QTY4t9QDaAmttREkbaEZdNeNC+jbPSbl1sZwSEk/3MvZJeUTlY1DNGtvWRp25BWBwg81y643EUibRCDZpordfsGUo/nar9c/WS0jBqe+KvNaz4KNyoMrgDLCVHbGALM+X+cuNQ/WzKlU+7HEnvFmvV4oD5rA2Evsr1ONvTVcdnT4nsRL6g5JFA1xl2IyDNtamz6kiX93WNu1vQCgkErxc1DxAymup/jNz9OYPob4eX2MtoPnokQw0Sz81okfUo298OWH5YHOFcSnNixAtzSzNsLFUHSHCY9Y/w9UCkNARlCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=860bdk9Pb/Vt2uOrYuT0CkTJWSkcidH1oqBzCGWFwOY=;
 b=Y4fslPCXuhXAd0rKIExvkf4RWzFSUXJCSuN3H14oOKHQabUnU/fqsDNa+q/2A39zG43YwTFa7w7NJDisFiBZUtq2mejJf5VMzPbX1XQ+2sCAC6WxAHS+EvY35d4OWr/uNvqEpkcaPt80vyokj0r+SNaNsmhn2P2Bb9tU7QRVmwLf40JU2hPqt14cFe/wMxU5jTA6386yTO0sRvT63BiXCf+dmhp/h7EWbweF6QI892d9UDDg7eg8oD7fN9pFaVtwAGMLFRX2zvsMS2SsXXEZwTKl4FOyLq9kouQziccOYqtu/TmyKxpm9xwdQ8yAqYqIW6if3HhlVzqfUdQx+XyvlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=860bdk9Pb/Vt2uOrYuT0CkTJWSkcidH1oqBzCGWFwOY=;
 b=UWpz1PYaeZeBta1ZlT2AM6cn6Hye+pSeHYD+60nw/q23l8K1dsYGvqn3meYqgg0EvMW+vjqDNM5tT9TEQlj5NHOOV6paiB1kcdiazegBn85DiepI60wTmYuo5EneDCjyuXh/kNGr+MTsBLdE6agCkbiD0TzIzj6DS9L85kgyX1UyLg7eWAZeGyxC9ynqzzsJdQikY6vkdiLGCn7OrT6DKthQWkVVHMBcwQxfINPhsW7lz1Ct4qFs6wZxgCUW9j9gQ7c1/0aQVbr8Pc7rF/RAWBLnnLVFPnfmTN2nVNa533HKAVRXfU5ZaVlUqtZ/ScV/zvfuBX6Mo9PjsvMyFBT/Wg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA4PR12MB9787.namprd12.prod.outlook.com
 (2603:10b6:208:54d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 23:50:01 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Wed, 16 Sep 2026
 23:50:01 +0000
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
Subject: [PATCH v6 06/10] vfio: selftests: Allow drivers to specify required region size
Date: Wed, 16 Sep 2026 20:49:54 -0300
Message-ID: <6-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0600.namprd03.prod.outlook.com
 (2603:10b6:408:10d::35) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA4PR12MB9787:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b3211c6-9bcf-463c-fc2b-08df144d3833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|921020|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	HXaBnyo642812nBnXpCk2wk12Lf/nYvh9RL8p5/FzC+C/LGoMViRq7A7ODvQIihadU2JWFcOgHhhsU9W99T5KcAWRfc9vANd2E9L5bkypVKjGR2p7Ah/LgBoJ1pZpdKpY2fLdYGCaqyMVcmyqekXL0etJ5lELYESiQx8+4TcbtDh9JC48J+JpU4grHm2gpaPsOvb0ybxQEHP4QeUfthSfe9+QRj1ppORrs7xyPCzKlKysQpXJBTt28DTqyGrzya8XN8nC1/F0jeE9DANzJaJva0PTJXCx+SOAUTLcmaVD6w6f9UX3v8zxkIlCMVUCesFq2bfaFWWEMgrp++Pbn/oaSzUlSvFgmE41ws4t9Q0khvhbOlI/zbW2ljZOazRUjQj5XbWSyC4q6T1zagmsWAGrtU99SVDfiZ9P7zNB5Mjaj+lGoutyIHIm8nC3n9ARwnMgBH7nZCi8c1PWKnSJcuUKKWX4DcYZKjjlvLVc12q6jzOhTJccITAFfk/W8KnxINSLsPuyEqBK5LOBE6DeJGq2EKhc7mf/KCrCrRadbRWczrCX90sFKhtEFraHbVh9Mtbg/5rmS2BX4RY8BDk7mejSghtSUYyRgyVPFAzHsYLm4Dko8THv7unVFrEO4eNDKdsRfu6BNlL5nJSF8wXHPvK3isnGiefWhasdHMPLtZWIPtuxluIYUIDfyf98ErG6/TpPRdfnzDztCJhat6AlAJ0Kg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(921020)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vg781n3b0mGnsksTHKTFuB1dmsr60pgOyhKQdNAQlE+GwN8K7O1evWIMfgLX?=
 =?us-ascii?Q?ioGNnpA6uA39IVSgyI/Y3HfwddkWoTIvUyYKXRSvAfsv6+lgYdlT1HI1D0gj?=
 =?us-ascii?Q?noRriAdXSg6mNKmN58znVKpnPUEM1cAsuzso7gP7VUr6N60/+lNAhOXWRLuL?=
 =?us-ascii?Q?Hu0ttWBqjPwXSMoy8gpqkovGr8aGU14Buzjw5w+vTViTChGAyjGVIQsnhzrb?=
 =?us-ascii?Q?pq1UpndrJ1Sg7FOXUHkWXA2VA4i0dqZIBtw3TyI96QmGLO9+7HkVxcQsaXkA?=
 =?us-ascii?Q?ZnL4j6tOzP7ftGnOw+zxJGvdT4Src7GKEOrvFrNYR52ogKyHy0MEJXBU+eA6?=
 =?us-ascii?Q?7InYtY/LsDuieBDrhTVSJKJLhLuzvCDrjjK4COr+ytdvU1+KGWqjm9xI34Gb?=
 =?us-ascii?Q?kxV+F/6cEBjTnPs2GQk9nDn7s+HArwEa6qRUPbGFepMi6iMLHJb6GMJg5JKj?=
 =?us-ascii?Q?UhgMEQmsNEdEBccPcDFANdMu7NkpIFSN6SzWu3p2QApAIQlkhV2FbtVOoJf4?=
 =?us-ascii?Q?GsQW33Ys1pexjDznjZAI2sQDt5SMEAvaJyFIv8O+AaWEiMe30YGzyVKYv5Ag?=
 =?us-ascii?Q?Oaci7il9RF6gaE6Ed88sdHVA0tv9QKW95SsxRylcPWWjJFind68tqhJ/PgUs?=
 =?us-ascii?Q?bCDeNT7Lm+nVnQMwcy7k7VtOdMLmReQdSCq5YY9BxNNpZllN64j0k/ZOGJiE?=
 =?us-ascii?Q?6T4aRrL4Y8uakGed1dTpRF6s9gQXN7DWyky0PibXazQZDKcrYPPksOdqzsRw?=
 =?us-ascii?Q?buLFQduUf13IyvUcXThdBSvUF8Rxj7yN4F7Q8S2Bin3lPRmxYAuxhmvZ+G1i?=
 =?us-ascii?Q?V2bc1zWLbEoxjfgIP6kmOoT4IjQCoUcWzVIVcjjriaWRS1xOlX0pCRylSTcc?=
 =?us-ascii?Q?RtJ6hyqMjbOxZaMGVfJK09PP6O4eBDCcex2lTXrIupZJH+uQKarJTwFetdJw?=
 =?us-ascii?Q?RbOjahgbOItkEicgZVsqjwki0g+qgWIlEJOgJH4sYnHNQdxwKUj0cXL36EOe?=
 =?us-ascii?Q?YlIv0/t4WqlfHXRKddFiSifF0tLKrBW20d6dVhCP4b+/D6wSrEQ80brUCYyN?=
 =?us-ascii?Q?dIi6wZQzwtA/LQ371ILUypSF0r8uRef6OMT12HG7A9p2ZA/NEq7BwXGVM94x?=
 =?us-ascii?Q?1txm4FOkCsCuHfhk6zuRZ6Hs13bBukTVMI4nD7YW71vqnx5J5Qmq0Cxh3SY9?=
 =?us-ascii?Q?SUG92GAwPN7IrnzGRYE0qJCA4ziaXEtzKqjlQcRPX7mVADlCWJFsZ9fApBV0?=
 =?us-ascii?Q?bmPcJ1cMxAfU01NFb3Daag6gzA8HmU/YnHbUaSy++oR0vnkkexOFcsP8xejX?=
 =?us-ascii?Q?y7jkxcqdZFRpzU536ftOoel/fvIbHHh9r5KXCO4+XzHTsv402lItXKQKjf7J?=
 =?us-ascii?Q?Ymv/4yLu3brbhmtUFRLpCd1LF+dSDuUgO2I9IT90mhsE4GGbI6kvGg55mLI3?=
 =?us-ascii?Q?7/G0P6WQ6P+zXyPupT83g7Ml5tpHqjCtEnXmWlfhY8u6mQM3lx3ufbK8herG?=
 =?us-ascii?Q?VDAkGKkZ8wYH4o0oWeH4W08WP8iSS4e4gTBM2ck5dw9YsvvFszqnT1jvB9xn?=
 =?us-ascii?Q?S1Xj6sJNNIo14MVLNJjP9B6XF41okL4VAyY5c6XP7iMLo7TsLdPBk6HDPLPE?=
 =?us-ascii?Q?DbVropQnZF+9rNsvVc1rOozwTkp6vLfm1P6X6JPVcDwd6MFzHsVRIHAOOenI?=
 =?us-ascii?Q?jNiBoHrbD3+KgoqEs1g77gi/agztSntU0h3mr1ZZamvL1kce?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b3211c6-9bcf-463c-fc2b-08df144d3833
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 23:49:59.8508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCaHnfyheHMHi3Tzs281kQhLccWgUnFjn0xQOSL3w3il5E5DY5pAHYajtVuPpO6H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9787

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
index 4a660f636f4972..a8e5815a1b165c 100644
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
+		       "Invalid size arg, too large (%zu)\n", size);
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

