Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013066.outbound.protection.outlook.com [40.93.201.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C6B369985
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481475; cv=fail; b=d23NCOrpgBQFKC+L/UiJEL+U4EOsWFYO/J+2iOPVr+83xLMLPlKp8uco4x9zmwyuD/XUCsLYTisQ/7OhdF+fLv9z0kfvkuoXAiSVlzG8JmcgXT5KDuN93UE4s6vYImoXgF2JKeoE2AIu2TYHOIdj0Ps1zBGISVwjDLm35Dr+M3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481475; c=relaxed/simple;
	bh=C8SMAHKcGz4gieoISEJhmfd7+Ye4xYJGxg6qmMiERZY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uCZbv0rvc6Ox4aYDSU1rTSrP1OuKl9DTzvxoEHzP8Bq8hdWt3ZeX5zWZehxHZOHkL2tYNYKHwhTiVS3AZbaF9FF8O67IrVGeRI+JcCVTix4nVrxZUJNt/mMtQLW18aC8jKGfANwXjUK7nFUbdo4kk2lahSW5gWi1DiS5jXSjyuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b307Xbgp; arc=fail smtp.client-ip=40.93.201.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b307Xbgp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YcWTvxMH1ZEoN3YMRZr93ggUzhqgxsT82FKwpUDMwtBArJzsL21jvGe/wHTj125LCN9ZgznpHMaaRTAw+SlNBW8cKPHshhF02DeNraj3VmuLP341+PxZ3R5z/5JinmbbUM62MS0GgLP2Hwhuoy4C2f50/kzvI6xokdb+2i2MOB0f4gc0Zh2BOpOTMBHGkJslPS11UF2kWitQp6zePFPDtFxIY7HaBshAa/E4Bs6UrbMqXm+cftVy2haeg7tc4qo0J7XjK4U+woTQDELft1WaYyuYDcCgyRn1qmZxPoisZFZ8L4GMVb/4yr/4w+JXTgW85LPeO5txWFR0CLdvnpqSmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sI8oRgeCZxQWIa+9vNDzayiUFH2JZjZcZWLLld1HHRc=;
 b=U/mLjMyypGV3er6a+HjixX+tEAkUPB+wdUj0sWmfdIwtReS6b5slqjuxIU5GwZWLbLQB+9bjGRMy0RHUopWpiKUYH9ggb7Ke1sqWQVKrQC2FddqWufrEpYqvKb0nQsSoBleJCccj3e3epETq/H5PnSY0hSrR9LLV6XWPMlB/ty5mcFsUsXv/Lta2j9Zh0pQnTq4ngEgLNg+Qbhoro2i+bxqEhIhi9Kp+epjMw3y0B0xj5fv785UToaHmd6319ULeuqGD0vum3o7wJvCNVYLOHVZfXEhohggBLenvXDEN6x/X1KKC/+PWfkpBws64MaQBcil09/WowQQxmQVe6+4+rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sI8oRgeCZxQWIa+9vNDzayiUFH2JZjZcZWLLld1HHRc=;
 b=b307XbgpdBvB17b32KIjf8H6zoyKxtmP+UPzZtdX13ZiD7fk2kYmCMW5zVuoLtFCF5W3HBReNNOVt7QBW9m0WRxA46JMXZmJYq5tvoaBQWxMAcpulCxSPt4SQdOmuFMQrsodF/dD0o445g142opfZ+h5YdFTN2dMwuvL8T5wcMhGAmXpTfMJlAPX/AlnAQdGsYIY5aGROaTKaLFhN03msR5F4JZTgpgAyLTnC89kJTzn1E0NNwLO0WkolD8ILPvDq4MVBNUzKs/PgCgPYY9WjMeS0HH+DOEnOQ7seh0vMYz6md99CdeY3bW4oCe/iEgNu0BhEReuagVqOTEph5/W/w==
Received: from PH1PEPF000132E6.NAMP220.PROD.OUTLOOK.COM (2603:10b6:518:1::26)
 by CY0PR12MB388677.namprd12.prod.outlook.com (2603:10b6:930:132::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 14:11:10 +0000
Received: from SN1PEPF00036F41.namprd05.prod.outlook.com
 (2a01:111:f403:f90f::2) by PH1PEPF000132E6.outlook.office365.com
 (2603:1036:903:47::3) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Tue, 15
 Sep 2026 14:11:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00036F41.mail.protection.outlook.com (10.167.248.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 14:11:09 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 07:10:39 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 07:10:38 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 07:10:34 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 06/15] RDMA/umem: Map CQ buffers DMA_FROM_DEVICE
Date: Tue, 15 Sep 2026 17:09:24 +0300
Message-ID: <20260915140933.40580-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20260915140933.40580-1-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F41:EE_|CY0PR12MB388677:EE_
X-MS-Office365-Filtering-Correlation-Id: eb8c6f6a-13a7-4740-5155-08df13333129
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|82310400026|1800799024|36860700016|11063799006|56012099006|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	gxzlWUFawtgtqlbp2xmtsm390TdrCW4CMz6iJ+IJYHjWGgvQ/w7MBxuEwqRjnmfzaREDlwwal693pg00RqleWR39t7zMkJb+SPhOl+0iJFjTqniPzInSXxLmJgkgQDt7lI+IUH6xP3UHcSyF5KdvW8TYhWjKUX9xJ/fMpono6F1vgdWEW+U12T0AFr64t7ibLWxfTgrwVh8iIwS16GMeTxZ61TJuSWq81TJtCuVclkhhftNQK8wCCA09lPO8ouf2DCq+tuzm3MtoYHVYHcsXh/TBprsM+ZajCgSIKa6zZcpsxD3E0oLKYKorxYHE9hw4TxNbjB5m4cG9xN06dm23eMKOyaOb6SBxRP7XuELZCooPUpU7mGgoaU1KUx72RO7HF545D+PyFuZp3OUbafQwDIS5tnzOnnrUMdAzLRG885xFBHafjNas5AmB5iozSIzuKib8+QTeYiApsdNgDuPZ2fV+XcEY+jmlm6Vd5JqAF0LzgdV1ebFKLCjZHYiRcOt3dPxcbQRPrx+GzBOg2+0VQLTwJ3yscekCJ3e4Fpoaw4dXKsUH5YCvbOxvkFdSOkrLbSBLb+sBn/5WCv7FpRtbVbKPX4Vjrie7vkGvzm2nRNDCLzpghDG79D4oepIMA4C0lmQCQ2fkdmJltQ9oPxVSIExjiDVt/UmkfiQRH7kpUvTTFSSsLflGtkJQpLg+2Nx2PHoo4voMMfkfZkwwWZf0ng==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(82310400026)(1800799024)(36860700016)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LYf7Cs05H44CZGbiTKiKlyZc5WFgPWdwuCu7ye/Uh3J6ystku9vT9qWhNTnif5XVO/RDw8s0dDe6fbwlXiNtIxuIlCgmSRLxW8Hl2+/yl3LT2350itbV3VjvxykHWgxaNyS3I4jCuhryY5hGltPnrmiiSh6AjXCzwQfHooklKOLuOiKVzQMJUbsXL5R1a7yqEJvNaXc8P4kxtEXbgIObX9HcJhDMXG2f7mHGiTtSB4M9s5CJdNbZLvJ6oJTx9esHWysaE9npZuTHyjCpOyOVI2N/T6hky5yGsfaHYUJlQeegBK2SznqzRSJ2/kvvAdxU2gKwX/q6d0+7/N/XI5UdV1bl6t2Cxt1mtKfRybrpca1bB6JQxAbhpST2GIFNl+aeMbc8/PBlWQ0aFXHxFF914eI4qOg9Uvzw5FTbpQzjEac2VrLATe90T2jut7KRQ1Va
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 14:11:09.7402
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb8c6f6a-13a7-4740-5155-08df13333129
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F41.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY0PR12MB388677

For a CQ ring the device writes CQEs and the CPU only reads.
DMA_FROM_DEVICE is the correct direction. Use it explicitly in
ib_umem_get_cq_buf() and ib_umem_get_cq_buf_or_va() rather than deriving
it from the access flags: CQ callers pass IB_ACCESS_LOCAL_WRITE so that
get_user_pages() pins a writable private page (FOLL_WRITE), which the
device needs to DMA-write CQEs into. That flag would yield
DMA_BIDIRECTIONAL from the access-flag derivation, which is wrong for
the bus direction.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/core/umem.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index c2f277ada042..f1da70c4e352 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -587,6 +587,9 @@ static int uverbs_create_cq_get_buffer_desc(const struct uverbs_attr_bundle *att
  * must arrange its own backing (typically an in-kernel allocation)
  * when no source is available.
  *
+ * The buffer is mapped DMA_FROM_DEVICE: the NIC writes CQEs into it
+ * and the CPU only reads.
+ *
  * Return: caller-owned umem on success; NULL when no source supplied
  * a buffer; ERR_PTR(...) on error.
  */
@@ -597,7 +600,7 @@ struct ib_umem *ib_umem_get_cq_buf(struct ib_device *device,
 	return ib_umem_get_from_attrs(device, attrs,
 				      UVERBS_ATTR_CREATE_CQ_BUF_UMEM,
 				      uverbs_create_cq_get_buffer_desc,
-				      size, access, DMA_BIDIRECTIONAL);
+				      size, access, DMA_FROM_DEVICE);
 }
 EXPORT_SYMBOL(ib_umem_get_cq_buf);
 
@@ -613,6 +616,9 @@ EXPORT_SYMBOL(ib_umem_get_cq_buf);
  * Like ib_umem_get_cq_buf(), but pins @addr/@size when neither the
  * UMEM attribute nor the legacy CQ buffer attributes are supplied.
  *
+ * The buffer is mapped DMA_FROM_DEVICE: the NIC writes CQEs into it
+ * and the CPU only reads.
+ *
  * See ib_umem_get_attr_or_va() for the note on @size's dual role and
  * the migration path for drivers that would distinguish a user-supplied
  * length from a driver-computed minimum.
@@ -626,7 +632,7 @@ struct ib_umem *ib_umem_get_cq_buf_or_va(struct ib_device *device,
 	return ib_umem_get_from_attrs_or_va(device, attrs,
 					    UVERBS_ATTR_CREATE_CQ_BUF_UMEM,
 					    uverbs_create_cq_get_buffer_desc,
-					    addr, size, access, DMA_BIDIRECTIONAL);
+					    addr, size, access, DMA_FROM_DEVICE);
 }
 EXPORT_SYMBOL(ib_umem_get_cq_buf_or_va);
 
-- 
2.18.1

