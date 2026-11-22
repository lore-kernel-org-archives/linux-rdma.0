Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795369189;
	b=ubbu8R1+7gCqVCjwRi5ExDbZJBQoCR6ZrzrFmrVbzbzrj6pP337WRd33X8mcX9e61mBt
	 2AlZ1ZN/pZ2IHzOyPV7nVo6PE7yV4QejS3akJK+L2kKza/Dr0biSyQ1uy086HbNmJm8o/
	 14Qjl5Q19kx1sVBhcZoTxX1di2p8A0Le0CdHkYzjal2duUCxTWqXY/uhVQTBJDEaosAKe
	 nR3yLh3lXgKm7riwmV9cSuTUQt8LlWrfvMbgnVj7au6I/gRWlzOngmSC8vMw1cuy7BstB
	 +UD18j6CfOlDW5fmLmpTMycVpxKusIboe/N9FUJxM8g8C+/Tg5ocQeZICgI619/JpKw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795369189;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:References:In-Reply-To:To:CC:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=fRyw6+M6Gqs5tlCt/UBhIWSejB+y6bjYGghJid5KRH8=;
	b=fcjw1vQJ+rPrkS9pMDzoXXGf4BVazMC7JqOcvmi1fzfXbfqji/tOxZjm8EWZ0wb2+EqA
	 7Pm9cz5Oj4SJxFmdG41G3lzNb5VJBaPgWkBKooKBzMsCTJ9ztkHCtcJqZhe9BpjrV36P/
	 MxFfMvLto/MMTRTR1IQ64j85ys1fqMj6dp+Gc4evQdXv2D+z89kVlRPYwhPTc2dTkw7np
	 5Qi6IFXS/LUpQUbkqHdqdRepR9TZsUfWdOO2UaPykG4SpoPExk1AzaIZnk+RGOE7sMwcx
	 NmcHNZSKy8tEcxNHDdhNr9OT/4kNV5XHOxW0dygzuzjWnuE7Z/tr+nQiu4vpUlWTu/w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=A4YgKewM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.16
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010016.outbound.protection.outlook.com [40.93.198.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9070606A680;
	Sun, 22 Nov 2026 17:39:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9070606A680
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=A4YgKewM
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RHM71i7T3Tbp4kl6JISgDcF8nc35yVDSCxKmXVPB89l3IdOCRzlF8OI4s5T96AKxsbL01kcPTlDQBFOoWK5nKnf1v9aHV+JDEH3XLexva37ZHUfQz7uShjNFQ7QgHSYKAp+RMLkUe7ZLAIu7ao8YB9twUy9QeZszOzlpfJkmzSa3rgN6AY7u3AFRzHFd+AXB8ziEuIVeCG+X+I+egnOlqeUEK59dYiSu3yEyozRVq5KgJHBaAMOJwY0mInrDRtc+63okpTTjh8w9XqhFvRcN8wLACZH1gbuvutUd5hDjND1w3Au06tfby7fEvvHpG7t8eNZKzFA+jl2Jsc+k5FPOmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fRyw6+M6Gqs5tlCt/UBhIWSejB+y6bjYGghJid5KRH8=;
 b=WYlOp4homM+BzStMB26HvuglCv9rYRdnNIVcu2bkPv0JfR8cdLHqe7u72kpDyw0l/dO0NwO4SPTXMGlkyoivZtLb+aRPsKf8rrL9qQV4Yrb/Djp/23OnlaeDJEHnL8ko+l7Ecy7GLqf3WqAuV8AskS9X/p0pXju83MhNo4J+/lRE/6urZ3yov2QgazmHDaOvXOfyP1y+MHY2k6VTq+Ciw2bEr/84CvD59hxhFh4u0z10tTaJiUINHJT06PQuJqr5Hbs1/AFoLeYSalQXTgRsrJA+YWyCXP3X2ORuVGekzRuHPFH55e2sTKQdzWo/Q4nmK7HqQ9Hx/AP8tZqlMfMOuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fRyw6+M6Gqs5tlCt/UBhIWSejB+y6bjYGghJid5KRH8=;
 b=A4YgKewMmVV2ocjUIJCgOWvHQKeO+AvOb9CP4VJFW7f1h21kuIu9QUA4TJ9OFEy7ROV7kC47Ezbr2oCoQe5rc7JkABR+RyXN/G2LejkNIBoRnD5TKfdTZ5owA57kYyrbZgL+ok5slgmbdSJJEPBBeht+O5rCGJTmORgoVDHX5n3nHkNy9pujWfkRUq8WbUw/5mG87hz6m2FPqqimnVd8ukIXlsoIrcRiKB+QWffe3w4Qe5FYOzKBH3JSdIDJA/pIKRAJsoCYF37uKqkYGNrPFIIEE1GkF4CJRFC51t9ieKKx5dBS+wBA7sBe+wu5VzUDJblvazisclQUTYGuzg55Zw==
Received: from PH8PR15CA0004.namprd15.prod.outlook.com (2603:10b6:510:2d2::15)
 by SN7PR12MB8148.namprd12.prod.outlook.com (2603:10b6:806:351::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Sun, 22 Nov
 2026 17:39:43 +0000
Received: from SJ5PEPF000001F7.namprd05.prod.outlook.com
 (2603:10b6:510:2d2:cafe::3a) by PH8PR15CA0004.outlook.office365.com
 (2603:10b6:510:2d2::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Sun,
 22 Nov 2026 17:39:43 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ5PEPF000001F7.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Sun, 22 Nov 2026 17:39:43 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sun, 22 Nov
 2026 09:39:30 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sun, 22 Nov 2026 09:39:30 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sun, 22 Nov 2026 09:39:27 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sun, 22 Nov 2026 19:39:11 +0200
Subject: [PATCH rdma-next 3/9] RDMA/mlx5: Flush system error and slave port
 event work
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261122-mlx5-port-events-probe-v1-3-0d54e3d53c61@nvidia.com>
References: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
In-Reply-To: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Maor
 Gottlieb" <maorg@nvidia.com>, Chiara Meiohas <cmeiohas@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>, Maher Sanalla <msanalla@nvidia.com>, Patrisious
 Haddad <phaddad@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795369157; l=2209;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=6GFq/SW3bD0GS4Tst10nEYQr9YDWSDc4V2ugejM3m58=;
 b=zhPsIj9eK0QheUqnsKec9H0ti+qZVsp4D3x4Ee/4EAdljJpHMy2Mv9zs3AKcLqw3gbYzLc0Zd
 rjYXxOyH0b+B1llhYC1UAU4UPZvQo7gAMNN5CaFIIZ580Dxx+Z87vyw
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F7:EE_|SN7PR12MB8148:EE_
X-MS-Office365-Filtering-Correlation-Id: 29d34ca9-06bd-455d-a38d-08df48bf97aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|376014|1800799024|82310400026|10067099003|11063799006|5023799004|56012099006|261009223327099003|261022105027099003|261021123027099003|261021135927099003|261021121427099003|261009220027099003|261009221227099003|261009223027099003|261009221727099003|261026140227099003|261028144727099003|261102123227099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	gYV0vqxGVt4pllVfZeA1hM9bHtK0qfBA9+kNHIvf3PDOnvk+Yjto7nDbeX56g6DQr2xhEIS13trUnQ6lmLkF7BRIzWu6pbPDXeXr0a32dWvQicHsYNHV6RKM1W0kNiLJbGyrbr88mGolgqIOkJIf4SX45+ARQYN58Iw9kfJcD07QzjmQP5GLBXixQkMKZX8fw5mkAHGDQcTe9pLTI+GNGyKi7uKIScEiDVQfVw0wif88bX3ues0jCg4mnuFKQVXRa1dKmrsvVpqPORZt3NFR0NFGkDGACPQpV1cBy3qAwf5xAsd/tqrzJ2pt1O0wTRhJsGZkx3pUbfzKUFPVxWlhbByyoSi7oUWJduXvTFILVG6m7OW8Eoqr63XSPr9WLpMDUXGMx0bcZ69m1W+mLSKfGfQQ/iisdJPqPuGMEJPQvm9OVI917S4vUfCCtl+XZQvMlCAuFqqacyhQrF29SZ59QDSrQn+e8VC2STGn2VEDlafA1Z0e/9sbuNa0v4EPDIsGD+D+WlNIFVLZzZWFowasLUoO3G+xLVCYft6kiUChM4PwzVC4d3xPFEoQgQej81WWiMe07wRisvAxDWei5MMuCo/nIBdwXlgmQksr42JaEPrdQle5tyq1DY56VE6prbxUhF017tkl16QX7bX2XGjGqCazyxmYIeoWRY2aJbiCpjhmYvop27W+2aFDmcJptyYAk0p3un2FKZkzIhINXwCT+A==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(376014)(1800799024)(82310400026)(10067099003)(11063799006)(5023799004)(56012099006)(261009223327099003)(261022105027099003)(261021123027099003)(261021135927099003)(261021121427099003)(261009220027099003)(261009221227099003)(261009223027099003)(261009221727099003)(261026140227099003)(261028144727099003)(261102123227099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Y/Cjn+dA6YYNVueQ1y7kU+zCYYgA6MGdU0erhlzHcL/EXSztcCTFQeTdnpj8X4Lozw1c+WnnB8ulFK5cm+g8Bxg6zGrOdEMZGH8GKZC2Tp0E20Bkber7w6mVPV82H8F1TJNpfonZ/KQ98cY44jte3/SzNmXCArl6xrNPczFDkZRGmqcgUDRCYVDQI/z9WUqXDlt7lIzjyIwUiT2Y7XWEDLfLgvTlfiCIiixZ+4VrzBF1rgXkd10juIrHkM7MnBpQ/qJjKAQW6XJY9EEvZD7ecPtRMY6AnOAFJWUk5nUarBo76GjkkGEggLpb/8O49Xnts6H1bOPb7gtJX7iYeNuv3xY/Dd4uAx3Zy/Besp2LuwHK+xbm9gxQHMCpq8XqHQ3pqb0WV05DkxoYGJlMWtTHpwifPLhq4CK435p3GSouFhoU0hzZMHHS7j2Ogw3LEUnq
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 17:39:43.0036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29d34ca9-06bd-455d-a38d-08df48bf97aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8148

Work queued on mlx5_ib_event_wq holds no references, and nothing waits
for the work of the system error and slave port notifiers once they
are unregistered. Their handlers can then use the device after
__mlx5_ib_remove() frees it, or work->mpi after mlx5r_mp_remove()
frees it.

Flush the workqueue after unregistering them: the system error
notifier in its stage cleanup, and the slave port notifier in
mlx5r_mp_remove() and mlx5_ib_cleanup_multiport_master(), after
dropping mlx5_ib_multiport_mutex, which the slave port handler takes.
The system error notifier stays registered until after
ib_unregister_device(), as commit ebc2164a4cd4 ("RDMA/mlx5: Fix UMR
hang in LAG error state unload") requires.

Fixes: 5d44adebbb7e ("IB/mlx5: Free mpi in mp_slave mode")
Fixes: ebc2164a4cd4 ("RDMA/mlx5: Fix UMR hang in LAG error state unload")
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4504ba112034f4a5cfad16183602f209941c8835..775c3612a427a66ccb597595e149e3eada486add 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3248,6 +3248,7 @@ static int mlx5_ib_stage_sys_error_notifier_init(struct mlx5_ib_dev *dev)
 static void mlx5_ib_stage_sys_error_notifier_cleanup(struct mlx5_ib_dev *dev)
 {
 	mlx5_notifier_unregister(dev->mdev, &dev->sys_error_events);
+	flush_workqueue(mlx5_ib_event_wq);
 }
 
 static int mlx5_ib_get_plane_num(struct mlx5_core_dev *mdev, u8 *num_plane)
@@ -4085,6 +4086,7 @@ static void mlx5_ib_cleanup_multiport_master(struct mlx5_ib_dev *dev)
 	mlx5_ib_dbg(dev, "removing from devlist\n");
 	list_del(&dev->ib_dev_list);
 	mutex_unlock(&mlx5_ib_multiport_mutex);
+	flush_workqueue(mlx5_ib_event_wq);
 
 	mlx5_nic_vport_disable_roce(dev->mdev);
 }
@@ -5323,6 +5325,7 @@ static void mlx5r_mp_remove(struct auxiliary_device *adev)
 	else
 		list_del(&mpi->list);
 	mutex_unlock(&mlx5_ib_multiport_mutex);
+	flush_workqueue(mlx5_ib_event_wq);
 	kfree(mpi);
 }
 

-- 
2.49.0

