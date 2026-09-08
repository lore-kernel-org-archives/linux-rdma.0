Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011010.outbound.protection.outlook.com [40.107.208.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901F5566C7B
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881470; cv=fail; b=hSwycaIQodL9HmKUBm2rFrM/y7NMsoNHjpmi8rm0sIjCrvvBwMQ6KJNMcKeYovMuiXVQ6i6/TFa4NaMUMBSaJoY9Wdu2XBurG0jHLCo2wpqz6BAv5B80bg4bIx3EwG4l+Oo8n7ugHIEUTzNqQfrqcIxiEj0kSy0h0vKHTtRzh3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881470; c=relaxed/simple;
	bh=ph/xWhpMWDuqyPq2ETO4JwoY2Lhv4vxQLb2+vKLv1AU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C2LKUhoF+g5QLvVyv+YiM28Twr5KZV3UgFHP+6f5ZFyhKFlvBsP72VmPJF3oxKnhpfo2v+QPsd6y+9zISRx2C5HnpDE6TF6sbdE+FyItuP1842ZPt3gz644XhCmnXifzxanPnRE/NRq0Nt62uz5li+iNDxwZYo+cha0RUNug/2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dliUyGvX; arc=fail smtp.client-ip=40.107.208.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dliUyGvX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FWaDhCIf98tD0CNwyk4JacUhvxHJwrFIQ+WUVtKSlXqZeuEmi8mWt6fhrLx52VWKjCMp4XLIWnyKPuvJqHBynQhaEB0vLd78I/ds3CKK5zTiJHbX3CZZLpimM4CogDV0TCCAGS2BSrIPIWD29tD2x4hz6KhCYkqaYqjtjZKROAaxD77QJV1gfzxUWIbc+dKdIwa+coiKTOB0RM7KUCYlIdqc0pAtjsvdlfcfAOjO4wkTkMi1/D++jL1ut00u4VX4RuS1V7JAhdfdbDo4ruSZe1FtL6hjldI2pyz455EITFvHqqnZxOI7Zb3EeIxlEPnjF5RZarcYHb9viCpa+9i20Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rOA7w2++llhE4qNA9UqGSu00drpetgiLBfdoTXyfjSI=;
 b=Jiwg6CmxBvaZlvgXtsYqRlJ63PVmWHZxNmt5xx6BEV6ODFDsg3rS3as3RPvlIaSPu66om6oWfScB7Z7SwhLWpO4dXNda5O/E0k3UmL5UxXVD4YlPyx3GaDfx9c2a2Bt8BHzTMd6meKIbElPe9c2KaWpdhc7QKPELkpDgCAEOmPc4x8C0JPKsCrIIPgY+fniM/JmVPCHLIxXipdshT0JvB6PqQG3Ev90EsQ8Ry9mj2LuiDpQqqzoQDGUdrUVPl7Q3EJwPcyp6y85MMoLTkt/DOoW9DCcwERi5YdOowctD0nnBPsRw7FsqrZZJmnMiuJiRZ9NC94ofT+ppoldQwIuEbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rOA7w2++llhE4qNA9UqGSu00drpetgiLBfdoTXyfjSI=;
 b=dliUyGvX3sR/5Oq6XC7Ih29iR+z7/eODqM0y7CeqJtLwVKxY/LRhYL4cYwrQRG67xrMulAwia/pqv7eux/uuRaSxT0e7YVO7OR/ali+dMMbRNqvayJ6knmm7SmKFk1phlnjfuZakFFPWlxAsYJFbiuZuy8NI44wixzqzbgMR9bE6qkn71HfaHwcCwCz8dCGTLRqL26iPjsAsjk+pFmjg/cqZEznXlu4F6zvhX2AoLVCwI1uQKztubpZN3lLsyJ2jYMPqqFBulyrDZVVvKLi883lHFYWPAuk5b5rHmWybxdB1OnzpTjnBxExWipUJUw75av2XM+WkY1MA9aZ/iTsfXQ==
Received: from CH2PR14CA0035.namprd14.prod.outlook.com (2603:10b6:610:56::15)
 by SN7PR12MB7155.namprd12.prod.outlook.com (2603:10b6:806:2a6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Tue, 8 Sep
 2026 15:30:41 +0000
Received: from CH2PEPF0000009B.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::41) by CH2PR14CA0035.outlook.office365.com
 (2603:10b6:610:56::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 15:30:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000009B.mail.protection.outlook.com (10.167.244.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 15:30:41 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:15 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:15 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 8 Sep
 2026 08:30:10 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 09/15] RDMA/mlx5: Put resource reference in mlx5_ib_wq_event()
Date: Tue, 8 Sep 2026 18:28:45 +0300
Message-ID: <20260908152851.1307294-10-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009B:EE_|SN7PR12MB7155:EE_
X-MS-Office365-Filtering-Correlation-Id: b6a32614-e4bb-4435-d4d9-08df0dbe2459
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|7416014|1800799024|376014|10067099003|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	svSuOGBkv4Ld6+GAi3ZdXFb73jnzvIM2Vb/+SvY3GUCyUiw6vSBxF5bd1YkBUx+qPZVy782XQ+JuH2nhiMLVJQMOyxeLHla7SqWQDiaENezYUmwQvLSh0DqYx+JHwvqftl2vMD97peHheOwm7TkiGr8Rk/VW8/6FS710vSUWlh1knNdRrJXz/PA9/YcjodBefAZZlnRp+WLddOjvfsEPTJuNRZfNDX+23/Ec5o8tm35stQW3mXlZhCHr9KVuUPBCRba7hppRoecQkwqFNnuozntyBD8yKe1MiuKS8kraZ87RGpD2eVqHcWgaAOqpwR7ZF/w26Os87Lm+wegY30yM0FtldBJFxEdvZPTIgg9Ulq3VuyC88AP17N5dYgUp1Uz3fqZkX/s+fOIk8tWwoF5aUluzjssrrckYEbeIf87tCm70ZZ/Hy34RS7d57qQ6+JZ6ycRIx+2CXa7fucpphS1TyjSBPbII67BcOQR78EDnQAtcpzj5FXm8Ah6yiCV+73XluzHVz3EpnJgHbIa4EBqWGyKmRZIIb2GACNgIoawd8TRNfFMuB58AoD18fWYTGA+57hwiMJvkNvMum4MNsrtGJbOaTZrWEmpR/DdleZeBm+5KIxnYBeVtHKmdBtVqEZ1cBorr136/Zns1PBXgl2p3ba5pq2Grsk/Tiw/Ev/oUI3R81URRS/6g5UNtL8nfUXilStyoxPvrfFAwCVmJZzVUHQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(7416014)(1800799024)(376014)(10067099003)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	E9vgAaaWh/LHRUkNFlK11LyYssCC4phPHhpurFA2PeD8l8/XpHj9LDfdp8BeUvOEAQKblh8e+TUw1eqofWDiRyRe/L9/KtBHXs7qW926A81Pgc81X+qKs3vquobf6FgI0XHb/T2gm85b1vAS4X1mZaJz8riPWJEB7zSqaCc3usBgJgoQwzt5b/blT5UiJziNfySKSfp9CnKA2e6Grn8WKrJ99n1LFWZDaI2/sxt4rFFmTqhFFFzTVor8gIn6kIKbCel+lRXjNJB4UsJ7yaARQVJGozrEdw7gEMYAOlkh4gMOWqkHwkZkX0JvwSaqM3xW3p0fSEHjdi7fE7CauP9qkj8Wjeh1U/Lv0D2BnmAlP5q2tk6tGUVIR5NWFcLJfubg9cDNlY01dvFFaqN/EQ/nIHhRH6RAJOJoy6qL50pWTV1OIH5lxNbbAzBf519ZA157
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:30:41.3199
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6a32614-e4bb-4435-d4d9-08df0dbe2459
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7155

rsc_event_notifier() takes a reference on the resource via
mlx5_get_rsc() before dispatching to the registered .event callback, and
documents that the callback owns releasing it:

  qp->event(qp, event_type);
  /* Need to put resource in event handler */
  return NOTIFY_OK;

mlx5_ib_qp_event() honors this, either releasing the reference
immediately when it has no work to do or handing it off to its deferred
workqueue callback. mlx5_ib_wq_event(), registered as the .event
callback for standalone RQ/WQ resources, never released it on any path.

Every MLX5_EVENT_TYPE_WQ_CATAS_ERROR (or any other event reaching this
callback) therefore leaked one reference on dev->qp_table's tracked
resource. Once leaked enough times, or even just once, the resource's
refcount can never reach zero, so destroy_resource_common()'s
wait_for_completion(&qp->common.free) hangs forever when the WQ is later
destroyed.

Add the missing mlx5_core_res_put() on every exit path.

Fixes: 350d0e4c7e4b ("IB/mlx5: Track asynchronous events on a receive work queue")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 0d4f8b109ad2..d4d439ebb595 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5344,11 +5344,13 @@ static void mlx5_ib_wq_event(struct mlx5_core_qp *core_qp, int type)
 			break;
 		default:
 			mlx5_ib_warn(dev, "Unexpected event type %d on WQ %06x\n", type, core_qp->qpn);
-			return;
+			goto out;
 		}
 
 		rwq->ibwq.event_handler(&event, rwq->ibwq.wq_context);
 	}
+out:
+	mlx5_core_res_put(&core_qp->common);
 }
 
 static int set_delay_drop(struct mlx5_ib_dev *dev)
-- 
2.18.1

