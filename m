Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010042.outbound.protection.outlook.com [52.101.201.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FB93446CB
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481451; cv=fail; b=sUJugZQtIvm6G3HYcg2fcesD9AvIJZHWV/qtR+sfiWni5cdh86wpfP+vgwfy9VnlnJjaePcJjPpu2Xj/PvbemJqBwdDT8WqUVaYAQMkxwZytM61d1H1nRs3kNkEd+9sRe1CfaqKmXUzn5W4cubs5ZIzLIFupLCQC8eBOx2Ea1VY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481451; c=relaxed/simple;
	bh=nxGWJkLQMbpXz2SygYSjoYoBz7RUT2irl5HKvMY1Dmk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dFGG3pE50L/X2h91NiwrpWTaXUegYV7YDz8Vp3iYbbMOBp7L3hy3qz5iafL/4yW8xecRw6x+LKV1A6vQB8DXgwnDOF09xAOMThaSGKTvFFSZhBYHp0tYIRVKAxCJmddfrE774LRCGMz0Yt7CTcJw5o+Ii5lMJ3eZTmxoHyTvfLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ostftogD; arc=fail smtp.client-ip=52.101.201.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ostftogD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NufAmd1Hpw6sTpW8RX7zZpf/UZx3pZVyVHkTQ7vHaGkCCrwH77t5V4lHDPaKpbTkMAeGEF/t/FEH9mom/DsNRNXZ+UoyW51XghI8AW65AmDMqMHb6zaYZzN19TK3eSfZQ/9dAUy+i0SGaa1yORjlPPicIYxu0zrU9prS1kIylb+9EVUAjoiWj+7msZsaAvdlsDOvX9h+blNLHalXwNnAc8xPxHaM0IVxLuOc+K4YSVQzyVxAYceXe/ZVI7hf8/EqmFXWy8Eoeh85+VkPjRVdka1qxv7MBED1mhboNdmkh9on53L47h3A/XlsLQwjL/EUOdgqfYXoNVHPUhAOUChUhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5UeGV19iDaVinccg190Ud5P3z5OTzRwGu+Pxyi729Tc=;
 b=ZNFLOGv8X10m7QkuyX+j3OWQCmj6CZv3lCtHKoXQzTxC/BEJTztziRg06JU04W159vSRL5ItjSF3GG5ktDBNOr7CEHADcrBqw2lHTtDQpxRMTZlRsovEeBzn3ub7bJX8JsJc/OjtJzOFZo9ODfqfIXlS6SGYzH2qhM1myBo8SoVIEkWafhkdL7ibEEAxTm/JYF7IIc78Xi9Ab0hY4f7dK1R4Lwc0lbEKScHjuuVT/w6eDVxPix2IczkuD8hTLLRh5YncNEczSNr9ATLBzsDs2PxkV0j5+l/5G6qNR9/TBuJAmfrBzGVjyKwLVqw/nLsS3l8uTE/TaB5faepqfEgVOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5UeGV19iDaVinccg190Ud5P3z5OTzRwGu+Pxyi729Tc=;
 b=ostftogDPIqX0cMKcjBv9btpI7hUItaUxRQ+UYyzjJrZq3lQE2L3xZEZeEWgZjbMX8MVRz3LCTaHkSF4gte8v1v+79JWvCIRXFyb7KO8rrCpMFGVxvRMY5ih4QyGbxq7DLSa444dkSbfgDv2pLo4Tv+8WGxmTP0ii+1bszC8RzCMXrAH/YK4oy6WnejqvcC0GRWO6ziOjEbWlgdknq2FTZR2u9UxCRhpFZVhgecvPcf7mD+Dz93eL8zJBYarQDaDmrgWYlSN610WrATKTfmOOUO+8QoLTxevmGvkNk1mCYLzxb9Lxe8aPWP8Y5e9sWQ2Po7CZtC/KJTCvNCQGbtAfg==
Received: from DS7PR05CA0074.namprd05.prod.outlook.com (2603:10b6:8:57::22) by
 SN7PR12MB7954.namprd12.prod.outlook.com (2603:10b6:806:344::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.12; Tue, 15 Sep 2026 14:10:44 +0000
Received: from CH2PEPF00000149.namprd02.prod.outlook.com
 (2603:10b6:8:57:cafe::a4) by DS7PR05CA0074.outlook.office365.com
 (2603:10b6:8:57::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 14:10:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000149.mail.protection.outlook.com (10.167.244.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 14:10:43 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 07:10:13 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 07:10:13 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 07:10:09 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 01/15] RDMA/erdma: Pin CQ buffer writable to match device DMA write access
Date: Tue, 15 Sep 2026 17:09:19 +0300
Message-ID: <20260915140933.40580-2-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000149:EE_|SN7PR12MB7954:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e4f90ae-e837-49a8-002f-08df13332193
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|82310400026|23010399003|36860700016|56012099006|11063799006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	9xzW00lqWt96TWRHhWk2t2TQL5VSB7xNa4s4skylF5kZ0/8CFcMGe0FCLDQPW9eKWVEoeyltMP+qJMdyJOSujEOsSzQOMsmU4kO4m2j4hQ1rPUMSTkBmb1D/Yqnmn9kSYOJYyZuiKfzLyUsl3WpWWOZUFqvjgZ8fbEA3ffUI/WWRk6soB8Tn8af3BEY3fP15Mf3l8RoSnQG6X8lhJ1OqfLNiro4p27v+QMCMUhng5hOz+oRMS+CE/xStWF0Qp9rVPa4eq3gowiSoDH4ls0VAp8MWj1jjNYhjzMkXHoC2NLJriIh5kWKVM1V+hUcl/ypdkVchdEFZjrwu+/MHHq59RuU4iDdweJvaVPJWWxMDbsW5WEmvWNwDNwg2SJzInviDwVtYlgFSZyqRAgZN/sHCKGu02zWPZa1giVBL2aIPZzFfdWojioMlpQLiPcZ8y1z5b/0m6lykenWIOpsDGMokaoe0v9/XiWQCg4urUec2rRAyhzOtZT/1xO+vcYuMkFSLCUoWnHck9j15Hd+0QPAruKaTLd/D8PRkQoFIXZ4eyi4xmw2yi40Uu0gSnZ1kIiTYXkxvInhZCcbi+Ha3yM8AOMVJEeDcE3VSMv4tr8ddIwN6oDZctwARcNas+Hjjrh7jSflPwBLXvcPfa77sLczXlqZzTDy14jeZgP+B4Yt3G/3vY9OgDlBu9J3Ksg09dX0bVLGRHjAGnFjMnOkHl+VZRw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(82310400026)(23010399003)(36860700016)(56012099006)(11063799006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7s9wDlNmAwy5S5ybInm9CgGKN1dOJkY6xWBTPGNwrf83fIfs6ML+Z+YONcmFYq9rqEhf+tyiggwzG1L9RB3tJN77SzmYmnV/39FG+92a/prAh0w7uXEHvmn19DWzO9dALCgJgmPcYQhDfme1ePNCo1UPJTm6hFWaF7UAUYNhe/6oZ/cMVaeNcEPjELs0Au6k1usNEpeXDJHUxGjnItptoxxzUykF1LelUH+GHwHpiWdwIfdUxJBhKsIbcXIGtpSzo0TLP5n5GqyAqMge8XYA0El713zWxlMy0CL1S22nxZBKsuJnKonwzyaZzEzTJvfG0bWiM+XV6InPxjaxrn/O2iV2xyWiAhhAF+UjtWII80IxFaJgws04f188YKHIGVbnyX68EAd+XHytXC0IfINGtmHFjVlxO9Et1+1f7t1zIjtkJb/+BycCREV5IgPODiS+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 14:10:43.5953
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e4f90ae-e837-49a8-002f-08df13332193
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000149.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7954

erdma_init_user_cq() pins the CQ ring with access=0, but the device
writes CQEs into it. Pass IB_ACCESS_LOCAL_WRITE so the buffer is pinned
writable and marked dirty on unpin.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 65b1af1e6623..fca2553e47ad 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1930,8 +1930,8 @@ static int erdma_init_user_cq(struct erdma_ucontext *ctx, struct erdma_cq *cq,
 	struct erdma_dev *dev = to_edev(cq->ibcq.device);
 
 	ret = get_mtt_entries(dev, &cq->user_cq.qbuf_mem, ureq->qbuf_va,
-			      ureq->qbuf_len, 0, ureq->qbuf_va, SZ_64M - SZ_4K,
-			      true);
+			      ureq->qbuf_len, IB_ACCESS_LOCAL_WRITE,
+			      ureq->qbuf_va, SZ_64M - SZ_4K, true);
 	if (ret)
 		return ret;
 
-- 
2.18.1

