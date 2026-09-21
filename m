Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012033.outbound.protection.outlook.com [40.107.209.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C41D5226BB;
	Mon, 21 Sep 2026 22:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030173; cv=fail; b=VnvUpUtiLMRFIU/wNB6u5zRzKdve0iEqkJzMcRmaKO+Db9y9ENOacbTUwJOPGj7vyCti19X8pRXpKElPlIZRHCD1d1Z/CtBgStSVatOOHRNpV+efyXCsWyzBYvmN0EidkBeYvq2Yunpq6HOvMX1YpS9QWxpCfOVccezIRK43z+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030173; c=relaxed/simple;
	bh=n7HAKCn+EfFEf8EUvqDrDiL6qUPbpBECZpH1JrupbgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fkSoHt4BsW67yhdrszw8fyUs9hJ6XFNGAoBxYTlPcHtCKzFU1aTkAEiRiWmZILKKHX6y+cmmwue9mmGodiMwX4miWXlySHAd9B1HoPVpf3VKy1HZFZN8bDXSgt3qYXi2PfqpnMntLaH9zMg3bHwq3ZUimmZDhhv4s+2C+PE1AKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qDH6036W; arc=fail smtp.client-ip=40.107.209.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qDH6036W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XzeHGJlWvML+3XH9vRrMoGfJetBE/WjR7JaFjGifO8kMl0acORHc+ViNo8NdFP3WGAy5W/HzlTRF43bwIxynFBBbOEj9u0Q5pW9FSWMvO4eQeaElDy2HVmuJ1GJHOdIjAsCSxkIHhcPuBmYHkr8U8OBChUNhAli0SxPnGha+bRpqluNmep4swdlo8fBI53r1UAn4tEGCRm7puJ8IFoP68/RlEUCmt9RQh4K1DMdJyGpjXPH8O9UAIU6oTF8Pu8/0ExESNLLn3qcxuDZpVWX0vlMmBPTfzRgMO9p+Jo2QfSXY4XffV790pXFwYwr6iVLDqvFaMIKd2JGcUg6AHHwLbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kn+UuJE8+sU8+yKaCUEebu/zTZQcMa8du12sg429z8M=;
 b=bd5+Rx+wnONzfjTkLN/3nxXiLKmAG3wxnqGnKOxrJ5XvYCKOIz+js8VIwzyA6P1oymnyUOz/n52AaczOuKcH8pnurypLX3zYAI/rdhMk9pp3P4dyQI0wUDBv+eIyPcwk0AVxXd98nB78rmlNs1ntl/M1/Rm9sDa7ZR+lzDI9saxCHbGWsofyEntBOcrb8r43OHddmn0AhL32iHewdpE4d30o/06lLPziQLBp7qJkk0udxn4mkr5RvpS0Byvsqi7F1vIFN2WcCOgNV+01GIsiSxsEXtbJLoS9oVVzhGpaBO09wI8ef40ksZ6B3E/I1P9d54TpfuxoNfqr6mbQr6Z4wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kn+UuJE8+sU8+yKaCUEebu/zTZQcMa8du12sg429z8M=;
 b=qDH6036WH55FHS/va0hbvoV3cLZo/ebXDP6ACn6HNTxy25QGz0mKSgfDA1jwKEHBfCKu5n13KqSJGpkJKeHlRxm1SoIRALoMiodpdYAEttwFlGIbzoy6of+K7TbHTh6T3lvp51D3KGtIScA6jJF5ESRi/LKQRHQKqIZ621RHVQ0/U3oz5PMXVVPd6fL7y7Co0S6Fuow04DBGOsHMiIDKvAPhXAdryrdN4mfjogvN6Q58fdlFnMjdfZNQs2eULETWlG7hb+6CKtIAAyKaDD9eI0NRkJ1O2eiQHNu+IhhP2j4wN++Bl85JRnAKONlyIyWvKzc+jeTbfOKHqRjOJudJXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9144.namprd12.prod.outlook.com
 (2603:10b6:408:19d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 22:35:58 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 22:35:58 +0000
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
Subject: [PATCH v7 06/10] vfio: selftests: Allow drivers to specify required region size
Date: Mon, 21 Sep 2026 19:35:46 -0300
Message-ID: <6-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:8:55::32) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV3PR12MB9144:EE_
X-MS-Office365-Filtering-Correlation-Id: f491af4c-32cb-498b-63eb-08df1830b20d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|7416014|921020|56012099006|6133799003|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GVZwWvFGjho4pGPiLhQ7nwcRqBI/Xniafn9AYZMjTXDr47HHc+/JVMl9r+pKVAXQtQzgnHWdwsSDMLuJX4pTtshP7aIzrol7oHvrUyUu39x0ClMm7b6C59YyGDsLk/icUjo/VNcsGm+5GzNMUFlrMpSeRdh/MF2jHxHL7E6Z/9zSOMg8HlzPB0/uV7EAwj1uOTSbcF0RCbZaCWlbgyLU9Ij5C5RSSYcrZZcpt6oegu6euk7c3MLTQ3BK+nGFHUv2VEP7ErObUSQ1xWBTF3yQbjr/yj3nMywytWeVw5VymumLi9bfmGzS2L68ugCbewTtXBrrpQNerOPuFvsElkL6jjb02SQw6jtbG1hgCE1Ve2Z2DPMU7hmOQ3GmZjWTSKWZFVGp7UpkrDWzsvpO3WdA9Rppuyi+6BoQ0LENHuVyJahqnVJu37SHUu3QPWNhun7073g6fW4Di3ZyzI+z6m1jFhvRQTiUNYtWgt86umOu2kDobqYcR36wVr0L67mPvJm247LoL5Axs0H8Mc0TmwzT0FQKHgYYwfJ9kSRE9H6uhLiz9eQQUGe0hLgVtUjNjAmq7qmyCKAaE3gkLJvisSlQya6XyXEfkMRc99bfvn9Kqn4vsCg7/78enJWjxecTket72Q15uGvYstSwFDtjLHMNfbiq7mzUDcRqby81o3zus2qMcU2zixUhHCXFJs+c/avuceoZzY9g/I1dMKnlBpzPDQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(7416014)(921020)(56012099006)(6133799003)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?27rxM6I/jiGN5BuL0jJmIVpgEiFrgldzMD7dFgdU7uV7vApf2+PardPGyWyp?=
 =?us-ascii?Q?/FKIVvPiYvCtFg08yQfWfOHW7XTCVfRLggUTWd/2vy4zsIh1n6SZ0puYjUxa?=
 =?us-ascii?Q?Uh6NkFeqsGHGdgD8/ZzwENPDovuameH3fPx/saw3uG2VgkiU6ad83kCHsIYO?=
 =?us-ascii?Q?yzizfZiGbDujn9EcvZsAyXCs91Zfvkzh/gQUEn7uFGBn32nAeTwkRAMBjmyP?=
 =?us-ascii?Q?8kpAgWeYxUNNraCGjCxp6hbzOOIKFWINQ7W5kBA+PCKOuDlQIlfRonSK0gL+?=
 =?us-ascii?Q?1NpCcDcXuBPQCAyAx8EhBIzB581HTP5eXqiWjIc+shbUr5U1KNhbHtcXCQkl?=
 =?us-ascii?Q?t1UqZV6x6kCCuaNGEFGDICaiz2N/oYrfrDMJpF+pzTtlC6LpGDXbUQkl2XZn?=
 =?us-ascii?Q?UL4tDfChEn69XwcJbN/RPA41IYvAHK+XQdRpnMKGSUqksjBsPAC7KqG6+QhE?=
 =?us-ascii?Q?EXLXkssfdp3q16nAkIu5NYP5AHKJaQfH3uO9i9tka8GdHdMBNNWOBV1+VSVy?=
 =?us-ascii?Q?jqscp3wfzJRMbd/yh8k8g66VtDmkOBkadkHu+L4UlcnIFCtBcCnndUXR+pJ2?=
 =?us-ascii?Q?f1PrwgaG6f9I5/1xYXfEeNFQoErNKJY8sT19fOMLqdeB4IOzqltiRHbAV94Y?=
 =?us-ascii?Q?ZJDHd5/jF31++PZpiiAtI/71As0H/WkL4fwk4DyjSp7ertUVamy5TRT5gTcB?=
 =?us-ascii?Q?Ka19Y4gpO4DvU5ukzG8SzHFaKnXBNto2+2HfFi6LoLPWd+x4teSM/k7vqB/X?=
 =?us-ascii?Q?G9UDx01HjeCWjQjrsiPH2N/U5RLJ3q1RXXKjwkxmm6mzFpammapQPt9T8d6c?=
 =?us-ascii?Q?uXjsHbASORzbS21jnBnl15+ocSc7DfJIT8NcANYHege9qfx7FpvQXTwBdcPk?=
 =?us-ascii?Q?mPABGp9gxVLUpQlk5skZ7D0pC1TD/nxQfiRtPSKi8oTGddZ2hbnHqf/xbf7v?=
 =?us-ascii?Q?R4SgyuRaBhQzyg1y+eJnR7+cJxB7u/fGPwQ8zu5Q/JDVrv/O7QJeokESjSCl?=
 =?us-ascii?Q?ujvFZRFPzj75MPvmS0TNVuaXK/bTrSOES8pFiIMP5outke9WqEh2FzZ2+bfa?=
 =?us-ascii?Q?TacgFmf/IzEbrC0ro4PTFChJ7m/LGrdBIO9eKxbWSRuyahgex2PAlaum7aTf?=
 =?us-ascii?Q?tEHHFBF2nmcW5bzbVINJ3svQyKOxPS1jJIwtifYn6q9PB9uiXSCvSx/XgDPX?=
 =?us-ascii?Q?ufHKRE2sS8qdn4mlscl7gOYSiz/mXZLJQRrcCBOXExsXQAQ9dwkQqybkEmuP?=
 =?us-ascii?Q?UKRki5oy+CkULKiOQjaseBhlSIcsbDizCuXam9HUxP1xms6NKPSNEFLuu/rT?=
 =?us-ascii?Q?LVdN5QLI+J/XC4ZPiri88CxB1Fj8XtR4oavSCwbVPZ8sONy9MJKvEHFd3DOR?=
 =?us-ascii?Q?c+kaODvnhuxpCR2Xi4bWtQolOhtY/4HInnuJRfk0z7ziJfWQvkmIzqtrwX60?=
 =?us-ascii?Q?n54S+eo4UXpTl1TvxJN44BGqmbx2nVPwR19+wf7sB6UsXhCcr0gUaK1j/K22?=
 =?us-ascii?Q?tjblR3rDX0WgbZBRpOXRUW0i8pl3GGg5CBWySwRc7LoR83/zCzRZWwl7V32F?=
 =?us-ascii?Q?RPOpqwFufFQQGtva+jpKAATJAcW3IzR5BFzTHlWk4vpwbP9hDcRb1OVDisok?=
 =?us-ascii?Q?cP5skO70QWywEWj9oRtzgkW1l1nUUxjQFMPTPcrWJdon+Z512uzC/dy1uZpr?=
 =?us-ascii?Q?/2xlcK6minjMUW2/kSKlCFUkalqTTgOyXUfxLmu4DZMCrDhk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f491af4c-32cb-498b-63eb-08df1830b20d
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 22:35:53.5934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AlZ7r+Yi+XNqSHBBqYBLPCMlob85xS3Yngc9z/QWr7nlFvsQE3ZvLvIneBpEw9Hn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9144

Add a region_size field to struct vfio_pci_driver_ops so drivers can
declare how much DMA-mapped region they need. The mlx5 driver will need
~18MB for firmware pages. Existing drivers pass in the sizeof their state
struct. Since drivers all use only their declared state we can use the
value directly and remove the SZ_2M hard coding.

Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 tools/testing/selftests/kvm/irq_test.c                     | 2 --
 tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c         | 1 +
 tools/testing/selftests/vfio/lib/drivers/igb/igb.c         | 1 +
 tools/testing/selftests/vfio/lib/drivers/ioat/ioat.c       | 1 +
 .../selftests/vfio/lib/drivers/nv_falcon/nv_falcon.c       | 1 +
 .../selftests/vfio/lib/include/libvfio/vfio_pci_driver.h   | 6 ++++++
 tools/testing/selftests/vfio/lib/iova_allocator.c          | 7 ++++++-
 tools/testing/selftests/vfio/lib/vfio_pci_driver.c         | 4 ++++
 tools/testing/selftests/vfio/vfio_pci_driver_test.c        | 3 ++-
 9 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/selftests/kvm/irq_test.c
index 168c52734fef5b..791e576c334cdb 100644
--- a/tools/testing/selftests/kvm/irq_test.c
+++ b/tools/testing/selftests/kvm/irq_test.c
@@ -6,7 +6,6 @@
 #include "proc_util.h"
 
 #include <libvfio.h>
-#include <linux/sizes.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -101,7 +100,6 @@ static int vfio_setup_msi(struct vfio_pci_device *device)
 	allocator = iova_allocator_init(device->iommu);
 
 	region = &device->driver.region;
-	region->size = SZ_2M;
 	region->iova = iova_allocator_alloc(allocator, region->size);
 	region->vaddr = kvm_mmap(region->size, prot, flags, -1);
 	TEST_ASSERT(region->vaddr != MAP_FAILED, "mmap() failed\n");
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

