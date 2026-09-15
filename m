Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010033.outbound.protection.outlook.com [52.101.61.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED483655C3
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481502; cv=fail; b=TWAYw7pGcgRjlCGJJ8/xVIRQY+Yjpf+1Y1xaO1nvG4G9Vk0JA+rJr5kVWVkfkKoXKezxoSb+MvH+oOxQ6dxJBRO8+AU8CXtMg77tMHvswGStWlLuwtWYKCwuwY+uYr6gVZYmSNjflw8z3daGnqCiHVoG1qdUaWjNMTZNyM9x0bw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481502; c=relaxed/simple;
	bh=rJ1a2SWAVRfHaVfGBDleZe54/ZqQdz95kkZNpug0Ca0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qMx0orFnsNEuP/y1t9f3RikiK8jc8cobdbSgC4lk6aD4+JYrD2Vn5LrNddN4lHnAQGyHqoEkE9+RsU6nnLW2MYqiN+1bFjTeUa9pyGQggZDovIFZaQ0BCEFur9eHcPgM2GULliPBbzkZKrquD1twYOqPzs26EVDMeE+VdHVTfPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=G3VlIT8R; arc=fail smtp.client-ip=52.101.61.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G3VlIT8R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c5U+w9SSEPvdT/YFx+vhdlVx2Eeg5g0/+aP5x8i1Yz0ZtWl3tcbDaSImwmaVH38C/DxGT5k+cSDe2/kHiqjUBe/gcbP2qQAqK+OmPsQONsXqOSD3K1qiBUfSo353QF+Kt2pQCSUK6jFnydV7xtMDnULIvUaBtvKD/zceC3QqNzndFcmhx9OhkUBgEMfR2CPMIpA8A9ZfM7/Ba3/uhAs40X1XFX9OOhUJ/zPJCj10P9fdMazh0YoWAMDkLPtw4V0Q9VdBhpwgZj5Vrl6Kbq9rUBuEzkiLh/Dm+A9XX5Dk3Q63eGKx3hlo/Ds40riCZvnGg2yDDhp/6RVwzJle3HrtMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HkjIkqrKVX/ed24biMtp4dH9tzilboBkcaPiPnH4dQk=;
 b=BnhlQ7M+FPEGAtVw2qsWsWW82Lb+rXZrMsJGUwfWc4F/GZO+QkcfqYz9aEMozvtYS1LEteZl1pdLmw3ZtgGuPgKGDKWHuZ7ijDxvDtLohEZ9k6FBL3fy6/wQWK9GICl8FC1u1mqI+DevHdi/vqZt1nG8fwb9EM7uSbSjisOcDUF1sbcuiMKax4PoGvpC8P0/AchMaOGIwOHH3qioFHPayOr5FS9ZfylYjxICNEqVM6a+CVl10T+4X+hqzUZPw5EPcEJ4vJfSrbZ2pJzaC996vs1gE8Ge+lBBXBXJQDCg9m4+OhkUzmVXzrBF4E2lQuivcMZQn7I5W/+M1wAV5i1Gmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HkjIkqrKVX/ed24biMtp4dH9tzilboBkcaPiPnH4dQk=;
 b=G3VlIT8RF1P0Cq+VgvMTRPAMQo4Hk4B5b0o/sLR8RMsNal8y6xYvv8v9E+FBRs62AR+6nurHg1c2QHpZcrTw7hiREmPfl6/iE5CprlUI/LWiTSo1nTxZBbEXYiXNJIuz7LXGvigX+JPPApvWaewYolQz3q0MgTL4WvHke9DlN0HxyN22tKmbMW4BDFkEZ60f7nQU2D1ksmxBxIrNI02HW4nmybeEWXDB+KHDuS5lIFw+WK9qtFbhyZUt4YlFtd/froP0whXSYv2Rv51tRy/sWKx3II/7DaDFcMCBhaejh//zu9uIzXj521TkOJbom740DcEc0YFbtkJAN0W5L2Tm2Q==
Received: from BN9PR03CA0312.namprd03.prod.outlook.com (2603:10b6:408:112::17)
 by DM4PR12MB6350.namprd12.prod.outlook.com (2603:10b6:8:a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 14:11:37 +0000
Received: from BL02EPF00021F6B.namprd02.prod.outlook.com
 (2603:10b6:408:112:cafe::16) by BN9PR03CA0312.outlook.office365.com
 (2603:10b6:408:112::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 14:11:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F6B.mail.protection.outlook.com (10.167.249.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 14:11:35 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 07:11:09 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 07:11:08 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 07:11:04 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 12/15] RDMA/mlx5: Set RQ event handler for raw-packet QP
Date: Tue, 15 Sep 2026 17:09:30 +0300
Message-ID: <20260915140933.40580-13-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6B:EE_|DM4PR12MB6350:EE_
X-MS-Office365-Filtering-Correlation-Id: 70c9f35f-b9f8-4d08-7898-08df13334050
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|7416014|23010399003|22082099003|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	e9pYn1WStzb6nb8/SJFUmNLhWcgepp7zCt9goZjD3bMHSPg6IstXincn8ZCbONA/Ut/8OOLwRlnZYL3flskUA2C67j/99mykSxG5va+cVt3BcNru5b5wxBnjMQWV+zmTZ/T83cBU+FloGsNkF7LYq/UdiELYyjl1sVxYQX6WbS8RxithFY3ZDXzFD2UcmQIu6s1k/JoQ/KF8Z3kIJgwliW46LYvuJmBCimnSHQd9Og5bidcZV6pBmGDN0lvKPgDLq+fnqi2cNLDifnhCkb4roFw5AnqiMxttIrf63BVN8ww48BzOrYqHkuy3HQQ34u59uTXdXVoPlge3Km5rT1YHCgk58vgVo/WQxzGKlS+jCDq1fR7PuJzOMwUJwf01MPD/dLagqi5JSZ7yOAd+Qx6C21d8cZ7KTTDPrjqdrfszAUukSY3RcupfddZOzQkPUt0mMABCUZcPGGLTrTTsDVDTf0dPI9BaoB03m1UBTWi/SSkrEsN8RO+4O79AHW7AMjUPhX1v0GtLKZiTrFQyvl2BYhKxMQXbZUcOLvinFVLlR9o1JujEHAspIP2y74mTaALRtZ2Ga988Wvr5s8EtYCorWXSLxuJvltzmhUX1dunuVzf/cuKUCjFzJ1Qwx/iNbKrC77ts9z/pL/MG9BIOBubyyNZXiUsiF9Q8qYk9JPVjt54b3QGnJfYkftKUhbHiul1uG8iZVN1ahX7dykugfiaN1w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(7416014)(23010399003)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	i1aaZlui404cGT1SFsqjuFHIq3S4rvxe84DkZXI8UQwUn60eZcrP9Yf7mZZ4hLMwNsQLTl0uG2qwh39Ctg0NCGysNxvSvAyDr3GRMNRu94/p4BV6xtNnoK0ObPoecCHvGX/Nn91HWNAXXSS7USUt8QxDHvpEtLYzGrQ13MKc0xaWyhCpyoW+kHnp5bB/nCvfo/8mVV/TO/2vUOwIhYOxi1xFJL6z0kz+LsdX52XtN48KvLRcTRZBuL8bSmpdUKMa5Q/MuJ4mU6IEk6wOPXy05+RZqWFohEWYhzYqAfJqkf2WQMWDXOeUwUGV2qm67n5mAPjj8Ffs+JvPZNaoXy3Ke9xX0EZwWxtY10y/wVTaihtJllu+GMfc9PkpoyifWbU10E8pi1JUyWxxU7hwfPSmmVYg2sr4d1MW9fowbDcmr3RlW7g+X6zj3h/qdVkxiGkY
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 14:11:35.1351
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70c9f35f-b9f8-4d08-7898-08df13334050
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6350

create_raw_packet_qp() creates a separate firmware RQ object but never
assigned rq->base.mqp.event. Any firmware event on this resource (e.g.
WQ_CATAS_ERROR, WQ_ACCESS_ERROR) calls through a NULL pointer.

Set the event pointer before the RQ is inserted into the resource table.

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

