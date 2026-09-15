Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011026.outbound.protection.outlook.com [52.101.62.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359D1368D7B
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481494; cv=fail; b=INro0U+1dnNuk8KeusYQ/py6gbqct543yMP1Dsg1pPY5KbcfEQRgYxFz4RO+36Cj+PaPM5+eX/5UADqec41pGjmxOFWZd58DLQJ1iCzkbS5UvukE+p+hVQn8LCyiSHgnZE5jgeuVA0uLR7m9vaDpuBKbQaolqDX/biDu4jIBeHc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481494; c=relaxed/simple;
	bh=OtIxLhtDhgvJb7G2q/wW1U17JyfQtC/k9Tnu8HYk8EY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iIcBtmecZQnal9h9ODFxMPWFO3NwmxviEb0AmBCIqdFxf9oC6sGGxmCb8GquO99HRJGtsHhnKfitlrvMRHyLsN40gv4y86Gjw+mwnW4HR2dPnRiO0GSy86fFuT4/fYtlPcGxzJBUkEs9p/is8x8yo2xWz5wGJZexQZxmDmTWhng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DpG1pgZ9; arc=fail smtp.client-ip=52.101.62.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DpG1pgZ9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GPU60i5DRMtn0RLyhRU/kizBTz0Ee2w9OvGetOT7qBDfr6YuZMMBB6WO0rDAUbQFoyvJ5a9bN/grrzt6AY1tta7WT12sNb/AqyU7XC+JmE7pPzP321lZ7MJv9QKeZi9BCyKLCgjqgfJEyvS17aAH3G+jVsK6RKbapv0GqfXECBKVy59uu0EhmYWqubG5W4nqZI87b1WLBQD3cRXGHAD+NX4t8nGQiqcA8MHtVqCEbR5oomWhWwCNZ0tq1aeRQes3qN1jtNgCpGy9Dlvjbme9gyZ683Qj5pmObiq8lXHjIc3sHV+0vsahdPRo7FrT2bbnHvPzwHZJ50vd5pI1OV8+fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJMI2zN0UeckGHgzrPkjPxaNqtApbwN6Cue5/O/ZH08=;
 b=ywBfiPyDWsoAiRZeCXeyAmTOkHBKiXozxHqIoVdWrCOghKvPF1gsKy9zjqRk44brk1Hgm3E6yw/Gx8+yjY8x4DFjUIG5q7DfghfGdbOP2vHgKYozZ04HJd7Tgy90OWwDlqpJwj5zd+1AWCdBM+tYOttDY1LOia8wJEgW+uwR9Nh9+n/5edgh/P/Lue++04rWJ1lChSrWXxi3vIipmZ7NmEhJ67WSuPD9tJXg+MUjN2BS6COGarwUYavXUf/l8rtCWdCWwfbsj8LkgCbXwBRrUvQlBoCjmLKzdJhbPe3+ZtpeKi4Cj2yekTT5MnzMJzWfzy8rrxGDj6XkA//yz4Dviw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJMI2zN0UeckGHgzrPkjPxaNqtApbwN6Cue5/O/ZH08=;
 b=DpG1pgZ9hanH1Kv4Zgf9FsaCK+bz/OT86ka9E8yAcU+jDtaQ6S5z5BK1Z0BTaiZfeiP6e3rD+IaQdJOHYMq8Bl+t89aOttUD0EqOO+eDpBRVlC94RMj4PRXCNSDFyeuZCdlJ59ysVHS1OKoaiLBDtvaGxZl+GkSLGB+lCdELreXO6czqorDpQuod5F5ij15OViEJFkOonANhHoxnT5cvrR0dSAvQ+pp1sDyoVwF4+kR0n5SbmwRkk3S651/3W2nfy5eqrf9aoCbqmdC43ctr83mMFg9ajjk6mB6nLUjwn8XSJqUITt4BCp4OZAbw/MFOo/OeeWeogP+SpEArnZgzfg==
Received: from YT4PR01CA0049.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:111::14)
 by DS2PR12MB9614.namprd12.prod.outlook.com (2603:10b6:8:276::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 14:11:28 +0000
Received: from BL02EPF00021F6D.namprd02.prod.outlook.com
 (2603:10b6:b01:111:cafe::a2) by YT4PR01CA0049.outlook.office365.com
 (2603:10b6:b01:111::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 14:11:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F6D.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 14:11:27 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 07:10:59 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 07:10:58 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 07:10:54 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 10/15] RDMA/mlx5: Set WQ event handler before firmware RQ insertion
Date: Tue, 15 Sep 2026 17:09:28 +0300
Message-ID: <20260915140933.40580-11-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6D:EE_|DS2PR12MB9614:EE_
X-MS-Office365-Filtering-Correlation-Id: f9e8d924-42ad-473e-0685-08df13333bab
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|23010399003|1800799024|82310400026|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MSvyNSrOLD0iUeneo1iUDaStpiP6cJM8ARrDj+k3hqPUKKp6dsU/iUtPGZUVpi4ti6TDNDk2c669o01xVwiyV7VFCtx7+1u+r4Q4Gw1QS5CDu0bzL0L22U4Fpsb3GuHi66COFVfDVeoWXXS0mQMU8F8kLcI7ErDQc2tSViuzolUj6LRZN/Up56xU5s4biHahbfdqZHB1eu4ZdyKV8N8lEswJu9bRKGnLyCbsQlmbOFemx1f8ho72w9croREKm+zf+0k+cVNNhjBSTpX2tWtfA+ZnfqVnfptvzoqsBDUp1FV2Q5LDHkQfinXmHS/Kc/kp+r2eZtD+doqtKU2h+kJqShTspxpgope45k5uhY1MQsKVDLXGm+BlAUxabO5ZplxkYDSRbl243WkQx368GZYPO2CCDVWc2yS2hrXyn5zmxpNsjU2DkLez5F6u+KKQOmXCEQEvB5iEiWkVErjuetdrn8thP+eqQWbpAkpmaGGK0t4LL35MvdcLyHYE8vIY1zZCeJvZorPE4zYa8+kI30gwnlK275leZYU5nj2DLcGzfQpGTynIHJfddV2CU1EPW7DFTqG4gzEMoLbuDcONr0PsYj/h+sFK995/BSPFM9N0AfOMIVaT48sZI+JUfP2QSvoYortz0IvohTDaZ9IBMxTziB1UkFV63Kwt4xO69PkVv367QSiEuZWS4zqPWB6yR5iSFe/Zd5V4IPasrHSEvDjOyA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(23010399003)(1800799024)(82310400026)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9Z0ssK2+VW82/pGzJNo78tiJHsEMT4vKnmMQ8gEi7GdYGOFX9aLZ1QOydw14MboRqL+usxqHTebAsujzLPt0aax8adxE+D6ESCfajAI3OsgwfnWIfMh2lUjW4wICJgQbfj+7HbUDRybIKdtzRkUZRLH1DURO21skxwjR3TsxkyP0P30CHHDIGvxfdaeUwq+6hkVZiAH7pjy7Q9ittJuRCHXi5r/YcpQMbUkkbM9+Oo7urX3ynqP86hAc+syysKrvWYB5U6f7CEk3BuNX1sO0GBoGtwCxnzOt6MXwaUV9vQhHtBAoAZOgjeIMPHNWih1C5i1BmyLJS9WUU6YvkC2YrdVlswUIMpLr0L77IeXgEAL4sj9h3zODJFYmzQl/Ca3g3j7RD2hMK031ctRcWX4Hmmda4+EhRHBXFUMj76KUeon8PKHSEU/DW+RCidsRGNzR
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 14:11:27.3415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9e8d924-42ad-473e-0685-08df13333bab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9614

create_rq() inserts the RQ into dev->qp_table.tree, making it visible to
rsc_event_notifier() before rwq->core_qp.event was assigned. A firmware
WQ_CATAS_ERROR event in that window finds a NULL event pointer.

Move the assignment before create_rq().

Fixes: 350d0e4c7e4b ("IB/mlx5: Track asynchronous events on a receive work queue")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index d4d439ebb595..d8e8a84ff3f1 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5618,6 +5618,7 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 		rwq = kzalloc_obj(*rwq);
 		if (!rwq)
 			return ERR_PTR(-ENOMEM);
+		rwq->core_qp.event = mlx5_ib_wq_event;
 		err = prepare_user_rq(pd, init_attr, udata, rwq);
 		if (err)
 			goto err;
@@ -5641,7 +5642,6 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 			goto err_copy;
 	}
 
-	rwq->core_qp.event = mlx5_ib_wq_event;
 	rwq->ibwq.event_handler = init_attr->event_handler;
 	return &rwq->ibwq;
 
-- 
2.18.1

