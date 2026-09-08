Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012062.outbound.protection.outlook.com [52.101.43.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9354F558216
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881490; cv=fail; b=nfENgg3UE3+GsYwFjmXT+WZrRNT8K1sqP3vaACmdPeKsRTOAXIEgHoZDCpI/Zji2Swy4EEXyBGpnF5YHRKER4TrFq/u2pyMREtDn/CBa35T518+i42m4wS2cGTg7DILklK1PEuQNLbF/h02W5iltR4PlsBrwTzXth6MNj5gR630=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881490; c=relaxed/simple;
	bh=V8HHksr3TO7CGgphCf6jBAV7RV7O5EXC+GYLAlKYheY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pmMX4An1bQhGsMe2IWaVz/5E7EIruoNqAnE2yNwtMY1rKPLP+ofL997ErlzUnQ/EjYrv90doqTCRIjwFIEQUbOGLioUMOM2Slnr2FRqpwkPRaTi/O1Jg83mSFlihq31HoxgnVlAyQQA9q22n93aSmTKIR2tranRqFL/26gebO6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Wd45wTyk; arc=fail smtp.client-ip=52.101.43.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Wd45wTyk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uF2OZdnbPGVeFwhqipsjc5CO16XBa0hCq7o/bv1dMdfySapEA3w+zGGki/CsP/+aTPPcYkg2p7BXaAQeptbFIhYItBhgiScerqtmMn+j/We+x2If3DdLhMtL/q2DkNRL+yr2eGPk2EQdb8Hn7M9i9fVcwvF/XLEjtLzy2hHA8C/E5CUQfs/hoUBosFFYwyUkLgEY0yzTWZQ2KkipCVZHFMXKjYGo+vuB13c2EouUouF6yAuVcA6qCqEHlckQ3fOOTCL9TSQ8aWiMowSRnLjjlkiGQKSvzdL81riJeIYo4CQL+UXYT6A7diWKNae6cU4OVO01cN1o0mqvPZtasB8txw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=81IRKp0QzKF9tppHSpDR4c1a418QJw3bKH0fXbE53I4=;
 b=CMAFO+ST7bDmiK0pipHalEl9R4EjnA9yq9PJfu75ic7LjeKHDGDZRuTDFlGkkIU2vyOtb1gobK/z5EfcQqQ22pRK4HN9QZtjPoy/APpK1Y/pSG/uLs1Hi5yAqwC6SJPUkDQFDRtvWImNJivRzqWD/mzCgpT6663DXiSFWYjG7Ba21edxl8Ytbj0zzD3gZcct3m8cViFprR4P8OusgH+BHCCZ+xk6K6GahrvyyVwZSKyXh0dUckpV0+WKtO7wJPtrS3hpXgT2oEsCWiVJBY+6kAarCu/sxd56ftdlljuzgYSExLm3SyEDrOFdtIxyzVRV9SxsCP+GXCn/Os7FsOxKQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=81IRKp0QzKF9tppHSpDR4c1a418QJw3bKH0fXbE53I4=;
 b=Wd45wTykOBe8aFZsQ26s0QXJXT25ylIPuIyr1pGY3eLNET9k302+85F5yi9u4SZwU7hnSU8SgoZybWNLERj2As+xVETYOfXg+S/REfbP/QxANRJZHvzL/JrcFDXGv/2si71zsc+QVe6tNzMw0QZ/7T8kUdLl/mrJT/Eat9+cviLrBUmEQGyM/sj3K6bm0pp+sT2CgpKhejGCe4ocUH1wiiTKTYccVe8M7gzd9X4Yfy0BMmIocVttIbPPsB2BTJuAdBJOLlGLV4lZiL4l3QVe73g4kcZsBBKxHIdgZpY4y8TvD6iC6mxqyjiVjU5EZzqysk2fcetVk5CHN1g24uYl/A==
Received: from CH0P223CA0006.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:116::24)
 by IA1PR12MB6580.namprd12.prod.outlook.com (2603:10b6:208:3a0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 15:31:08 +0000
Received: from CH2PEPF00000099.namprd02.prod.outlook.com
 (2603:10b6:610:116:cafe::79) by CH0P223CA0006.outlook.office365.com
 (2603:10b6:610:116::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.6 via Frontend Transport; Tue, 8
 Sep 2026 15:31:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000099.mail.protection.outlook.com (10.167.244.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 15:31:07 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:31 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:31 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 8 Sep
 2026 08:30:26 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 12/15] RDMA/mlx5: Set RQ event handler for raw-packet QP
Date: Tue, 8 Sep 2026 18:28:48 +0300
Message-ID: <20260908152851.1307294-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260908152851.1307294-1-yishaih@nvidia.com>
References: <20260908152851.1307294-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000099:EE_|IA1PR12MB6580:EE_
X-MS-Office365-Filtering-Correlation-Id: 7330f26b-c0ac-41fd-9315-08df0dbe3403
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700016|23010399003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	txcX4GajhYV1/SkLmApZvwc7EN+ujGZblaGwhvWFQxrLlSoI1eFm3FbSXaE+qTgQlztPNdOanNyAHYgW6tiHwHlRdDQ8Ya0PBiFm+aqEcfbTd2kUb0skBuEp7duGaxQGXMCYQ6ZkgY2xCfoPSj/u5aUQXLQu45PyGO3W/oTpbwfXN89XhvrQu6EyFQCKbYwd+TWPvsvdJIpmufgXF0/jMWVBOC3FtDvTl+mDRdXNdGMlDUYBA81tCbgo6rMpkDSjVa3SjhTNlqhaKU+opZuwuBkBB7ENXUl7ha7dLwYamD0iVi/QiNXHNW9JZSAqpgMKtIpDoUDY9Ou+4iDgwlfoIQ/FTiqhKRzqFAKcWEyN+yuF2A0xzk2/cwW0lgSGPOO901WAg8D/1ZzNciNKb5etezzHypG6QLu+DfUzqD1ad7P2LBnNDLj/zZSxSZvnbbQFl7qnp/Fow8WZW5EdRxR1cVwiSRxB51ghKk/CxECxCEjEUwPtrf9PcI+ELRyFwqBQR6zaYpDaIPS8fIUHbhH85Yz1lIeg5h2btz3sfSPYIWzZWzICci/amfTqF7ozw4v7xvu7WLns0mmTyOg1rZHCEpCEZc9dy5W46UrwIZAC274QkSE4IIKkoLRNY/hLiGJtRpl3x8Yu8pNEjurpAkiN+dOeM0/wrM0jzjEYvGATtoti09UoJAhQHDmQ8HFNsK2chMT/FLEo4PJ9Pt7ZhnmXLQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700016)(23010399003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZT/NctZVnzYAnlMU8w06PtLQ9PJo5VkMkzjan918nv1t3+ENQ0gYfde3af4/W9/1Psexb0SxfFJG8L3FtC+hOF8Llwm0mfo8L4VW5Ol7zr/BLS2/pN7S+vMGWPVDY8g8o0NPPyApUAj34m7fWkiWLACoWRs7UxMWDDAV/B9zuzYd983q5tqQ5IF1oSzaArwAmBAovLn8b8PrtVKRcNy6nbP92lV/GLiBVxysv/d8hWB4kiiV51epaGg2e/eUbTixc1V/6EUX4fd5ngXUYBUPUDiS58UTpErRx2AxvYPgUDWhm26m68pAektpuWn2m3YDP1GkDufQYe/zGH7l8qf2E9qSyWtluRBB70bUEoi4dN1ln0urKThDUQsDKmeYhRQ2h4mLilbOXgjqUE+z8bmOVGC0uAkX07BYQGsy9HNcf3roIch46Rx+JegvgIer9+tO
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:31:07.5804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7330f26b-c0ac-41fd-9315-08df0dbe3403
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000099.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6580

create_raw_packet_qp() creates a separate RQ firmware object for
IB_QPT_RAW_PACKET QPs. mlx5_core_create_rq_tracked() inserts it into
dev->qp_table.tree via create_resource_common(), making it reachable by
rsc_event_notifier(), which dispatches firmware events by calling
qp->event().

rq->base.mqp.event was never assigned anywhere, for the RQ's entire
lifetime, not just around creation. Any firmware event on a raw-packet
QP's RQ resource (e.g. MLX5_EVENT_TYPE_WQ_CATAS_ERROR,
MLX5_EVENT_TYPE_WQ_ACCESS_ERROR) unconditionally calls through a NULL
function pointer, crashing the kernel. This is the same class of bug
originally reported and fixed for the sibling SQ object in commit
1d31e9c09f41 ("IB/mlx5: Fix Raw Packet QP event handler assignment"),
which never covered RQ.

Set rq->base.mqp.event before create_raw_packet_qp_rq() is called,
alongside the existing rq->base.container_mibqp assignment which was
already correctly ordered before the resource becomes visible to events.

Fixes: 0fb2ed66a14c ("IB/mlx5: Add create and destroy functionality for Raw Packet QP")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index d8e8a84ff3f1..7f18ff364e62 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1647,6 +1647,7 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		}
 
 		rq->base.container_mibqp = qp;
+		rq->base.mqp.event = mlx5_ib_qp_event;
 
 		if (qp->flags & IB_QP_CREATE_CVLAN_STRIPPING)
 			rq->flags |= MLX5_IB_RQ_CVLAN_STRIPPING;
-- 
2.18.1

