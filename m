Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011025.outbound.protection.outlook.com [40.93.194.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442D3369236
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481486; cv=fail; b=Y7PYfBtOotvN9ITht02s0lyyiDpQLcr18Sk5Zg0VaTbV6xFlqacOzhAstVpfj+9fGjHbh9CJqGgr9yrdIxFnNpMZvMsdVl6yk5D6C53HufAKELegeCxm/vYIK28akIVp9aVuvVbknTGXWdIsIYqEBrP6mJP46W9h/uIgRP4IiVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481486; c=relaxed/simple;
	bh=HPdCbvfReaAoXToJl5O8AzoRsAEHqD2friIw49Xvrtw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PDLlGjlOKfRZ9rT8L2zlNamy/pEtLPIIH16KTP/wTKdfS2p/SH1tpTd6+vNb3csHw8+crH8UArwXmLrwEWgShGnaIjTh3rN8en5BmfsaztcCwVKqPjenfffPA8NGEzdnuq3sCD+UVwSXa+2vNePx3+KYQf5hCKUNo0UputYy5HA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GxuplJJv; arc=fail smtp.client-ip=40.93.194.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GxuplJJv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KX+tAOfRCe5EQ0IBrFqTqcKFE0s61YFqnTMQK3UNr14dWgMWcGNqKr9xmZqP86u28Zb8DvPHkmyI+ymzQNNlRsebxVKqp9p1B1g1lvgJGZdvwRlZ1lI0AZUuXgO90Gmlu7vnC0RRQEQcrm99BfSIJaw7QRAyoqvTWMT4XY+W8LGm6cmw6au4YvY/NvHxNICnSAvPSASS5KFp8nW8BZ/6kQAHGd6uliU5wo3lfY//zM86/mt/bs179ekqhJF+gS18dne7gZypeu6JTo8Y8xjx3bhVnnv1YNdJOVrg5nDJTOQyBfeHOCNswdx38eDzRsKUYS1oR2xsX+33KjpY6MDihA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+Dh6Q/EBJx2S1UPOWo2tebCEdv8f2Gfn4AR9CDPZl4=;
 b=OotY64bPnoSqjx0IBlxZEwe5x7wq8wJcIXjgE18ZgmJyAyeq7AIkyYQDkL9pVVtC+180q3t472SAn7Z6DBzYCIp5Y0Ns0M78IemesJ92yydv3yjl8+2XHUWuRBDg9LRaOvM+YCrpKoMQ1Um2yCo8ALhHUbRXEkpU05ApWm2BCwLgsJv6igE7PM28mbP4PTflOzuimuSi2xGU+TpRJs00csEGTNKwWqpEXQB3LETYC5nuBY/gw8iLKLtS2PsP/JxvBaCdJq/Vb6jK0SgQwQ7Ny5cuaCK4DaJTnq+jwtDllIGkIlQ1kobFIqiq0bNjgLGluYb1lJOfs1jWhk0lry/6Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+Dh6Q/EBJx2S1UPOWo2tebCEdv8f2Gfn4AR9CDPZl4=;
 b=GxuplJJv1jHom2sxSW8ptFboYpu1FNQaZUxBlk7P24PPF4E7vh4+bIqJu6w+TCsBK61Z+8Ki2+uWRsQUFD0b8cyvkkg029sWDbCpV1O3qUGseupxbnf3LoGQtXtsiLeaD9GcdQPKKtrN+QbM6VES1S+JXXiu1O+dX2FKgeXPriYt+Sn+w5RmYsXNTT7UuV9jhTUHyomF2RGt6HWws5kMUX+3bDy8hLyJrAVb53bv0IlQxBIofIChRPCnp7Jdd8lr51MEMHkwL1I118dTLOrSLvMoFHDaOBnnibInX3x8dfT63fZV63WIUA0NEjYKtD3SdB2D6u1xsUB7FFBsFA6+dA==
Received: from CH0PR03CA0330.namprd03.prod.outlook.com (2603:10b6:610:118::22)
 by SN7PR12MB7787.namprd12.prod.outlook.com (2603:10b6:806:347::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 14:11:14 +0000
Received: from BL02EPF00021F6E.namprd02.prod.outlook.com
 (2603:10b6:610:118:cafe::5) by CH0PR03CA0330.outlook.office365.com
 (2603:10b6:610:118::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 14:11:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F6E.mail.protection.outlook.com (10.167.249.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 14:11:13 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 07:10:44 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 07:10:43 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 07:10:39 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 07/15] RDMA/umem: Derive DMA direction from IB access flags
Date: Tue, 15 Sep 2026 17:09:25 +0300
Message-ID: <20260915140933.40580-8-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6E:EE_|SN7PR12MB7787:EE_
X-MS-Office365-Filtering-Correlation-Id: 38e6e936-91a5-43e4-ab60-08df1333336e
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|23010399003|1800799024|82310400026|3023799007|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4POE96njLGUuZsrEzrTi7F/NSmA0DYKVWR9mlKF8XmXbMey4Ioent+YR76xv94cJAphDQ1CZU99PONyJCScpsk/f3G8dAc88btVx7EqotkyMM7DSreGQOAj4rWbHviNhHKZ6qc7U4KTvSw3xxHNn7g7tkGt7OohzVQDEbGzG9pq2EFnHFz/YRzw0iyGPIMiRJhYwaTR0IBJ4zitQS45TsA/b6og+TTH57hNrhGiyP3GyqUCHLzSTpn5RCATvqe8Jsjyuj5wXfbv+WbP9bIHqJXIE/sIi4QKv1z2/2zJYh6WswiiKTBfg9FxsuEID3867++KIogfThHT9qqsVfCyW7gbb/abK0Owbpm9RKbwgvK5Me5Ja5+aD5yoWMaRzTedkRHGNiqYRUOCqKIlN8C5Fi9oeJcI+yAjlzOSmR/+/1fZ+4ocxDETCMazZFrjnpGOeMQB1h4b4zPdk5eEr1IbBJBJHDzVuGZ4asnAJC39hHngnf5sIbpKC0yrrQXnHPNa3Zsr2CJOVKWZKO1e3yFVMLhP9VKDpGsQQ/6mDDZ2XM5yCEOdgcAJx3unfWkLXPjYE3NDhuxfyAgX8fJ/QIOXxUTaAtQA9Coj/6wFApZnFfATs1D4T6CapV/s5QLiyH47Z5CCkK+shkrbxJOAzCMa6YFobJQbBXZMc/S/H1e5peSUrsRAK5Re56VPuBlRBGzqkcYdHFvaLaD1O4mhtoi+bMg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(23010399003)(1800799024)(82310400026)(3023799007)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TJEemqYRKT5iAQjuBxqruizmdJucVSIZhpaZo/ho4043udLS28ZsAGiM8sscYSCf5ZBOvdpPhwotHaEN7Ca2qhr/QSoIQNhWt18uGXkwITltVLSN8RZxbYAu3nBEzqBPRRabUVFQqtiLqADn3xXnRchLpdDxcGERVTS8XGL3M8G2DYnd6r55Q4sl+z26XA1iBYnG9y0SAynTMm1ztYnovNHfH2irLz3pZyhfMCxMUXn0+CewAzTYF3jys8Eh3Z134R2gJJa4oojzm/kycQyu69RbvMXqqI4IR0GFl7FStqLY6RjZEQIc+6kocT86c85XH5O/wcNLy96NXIp7B9GotuaS7dDWuQh96AxoS9GWzcS6iC5EGzUvfg+tTf+YwrRp4jrdefGEIQc+ltpIAlfFPk5y0Oz3iu8W3/JVSpYJ0qHhP5vqUxgGhTcBa26Qi6Ih
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 14:11:13.5157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38e6e936-91a5-43e4-ab60-08df1333336e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7787

Map non-writable user memory DMA_TO_DEVICE: when no write access is
granted, the NIC only reads the pages and DMA_BIDIRECTIONAL is
unnecessarily broad. Where the IOMMU enforces direction this prevents
the device writing to read-only buffers; where it does not the mapping
is still semantically correct.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/core/umem.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index f1da70c4e352..b1ab4f0359b0 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -159,6 +159,11 @@ unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 }
 EXPORT_SYMBOL(ib_umem_find_best_pgsz);
 
+static inline enum dma_data_direction ib_access_dma_dir(int access)
+{
+	return ib_access_writable(access) ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE;
+}
+
 static struct ib_umem *__ib_umem_get_va(struct ib_device *device,
 					unsigned long addr, size_t size,
 					int access,
@@ -329,7 +334,8 @@ struct ib_umem *ib_umem_get_desc(struct ib_device *device,
 				 const struct ib_uverbs_buffer_desc *desc,
 				 int access)
 {
-	return __ib_umem_get_desc_dir(device, desc, access, DMA_BIDIRECTIONAL);
+	return __ib_umem_get_desc_dir(device, desc, access,
+				      ib_access_dma_dir(access));
 }
 EXPORT_SYMBOL(ib_umem_get_desc);
 
@@ -482,7 +488,7 @@ struct ib_umem *ib_umem_get_attr(struct ib_device *device,
 				 u16 attr_id, size_t size, int access)
 {
 	return ib_umem_get_from_attrs(device, attrs, attr_id, NULL, size,
-				      access, DMA_BIDIRECTIONAL);
+				      access, ib_access_dma_dir(access));
 }
 EXPORT_SYMBOL(ib_umem_get_attr);
 
@@ -521,7 +527,8 @@ struct ib_umem *ib_umem_get_attr_or_va(struct ib_device *device,
 				       int access)
 {
 	return ib_umem_get_from_attrs_or_va(device, attrs, attr_id, NULL, addr,
-					    size, access, DMA_BIDIRECTIONAL);
+					    size, access,
+					    ib_access_dma_dir(access));
 }
 EXPORT_SYMBOL(ib_umem_get_attr_or_va);
 
-- 
2.18.1

