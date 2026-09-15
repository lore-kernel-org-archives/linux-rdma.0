Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010052.outbound.protection.outlook.com [52.101.201.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DBB369236
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481489; cv=fail; b=KC/RMCpzuVDEnriFXYzS3Gr1bzBftq1esPkskfJOzoZIYBmPdbS0ppyivOy4xhaffC0rWJr9Fp4O/QQGLGCvhmpl7HysMHgowxAh7ba6tJmaibFZwbMwME/VvdvAa1cmaxxAQfzZez5AAduGHjfaZ+tPpMGFczk+CDgbwnmHX44=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481489; c=relaxed/simple;
	bh=M+wg9hfjTS+UDDq25qHRFI5ekfvg7Ynj703TW2QlbbQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T6ZPiIdhMJP0xyQtq0NxaXzL2B18vpHUQIIa7A8Xrh1EkaJpWL1Oq9/7ky7yRvKt7ZNAN9tWFDobgUnrAI1E/9dsYr+QcNuUZaw6/OPM6J1oGD9kSVKf/JJBIS9/Ti1DaIOU/6HbFpbDjc7qoGtmWyHj3E/iSbZOY5pzh+HC1yM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MBE/4jUY; arc=fail smtp.client-ip=52.101.201.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MBE/4jUY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o9ZEGtYwf/hFgOjM1s/T00K5foMUtMI6kYMTTMrtidm74pjGnMOoSd8/C4VmHMkfthJyJ+GAcRJqQnxv3kiHktiBmuUoFs5Z8jvs1UXDY1j17eYAYuDnvTJkWl3bXE7sZKs5XdIudcODgTj9s9Rqmmi/WIriDFCvW18uqHhVgwZmlgTE5AdeeNE+PygRtx9npxijNGjs/ODKRYY1IRuCTf47dbwNN1S9LogdPy3Kqsgea2G2WuE/p30qiutYiQ9o2FHY+oq2a4K/JIx8vWUymgc1jt6KUJ5Q6iDDyE4YaxWKPWzggzHrUQti3EIqw0gGBs0yQIXj5A2uKsvI+wsjvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aPm+cnhEFwPdGXlxk8DRnNgcN29WPpKrTCS69FVrmns=;
 b=dMSUE38XwtN1i7ckrH5/WsucK7kbCUnaJwK5YsjxOozwD05GkuAQF7IFAFsMuBTpj9TfTDKCzx61i3V/SHDvcxYWTNjBzxbCZwq1JQyU9evbbFOF3iJT014z0IH8zhLE5PWDhKTMaI/oP+4WnKos/2URJXbkOr1/c1Lsw/bDlBNgdr3XXvNfOf9/vmL2FUv+PW/6qJwv2+Ebho9RDWHQE1eT2l5kAOQ7cW+Lt+mnFUj1MKkPyvBPXJpVrXeiCH1v5EU6ftyHApVRBGVtAAOSztaIh9lodhvc6XhyFRIklGfOUi/7+xuXAsu8GUDq7cwk0nJiHYB/rAQY2o3k9Brwog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPm+cnhEFwPdGXlxk8DRnNgcN29WPpKrTCS69FVrmns=;
 b=MBE/4jUYUT4RVkNgl3gJwyTX9wsiMsgYml0F5ARoCJAp6fEpc4FdJ43zolxQzwfO/szTtIc8ZsMiFxockIc4IwRL79+rP/xxwTiTlffl9BMPMHciwuNJOCLIco+9TPf/zBKCSjwGaXPqC5byjN3pUH2TDDRUzxS59LGOZXnmHYDGj/DpdqhdMq2yJVEQuVOoe4V+9cyS5nPRYo18RpTNOMRbPFRu4Pkh67Ldvl3fnaDqUjiI/n9211OnUzkJXKMSTBuj2qS5WCtby+mSjiEd1yNOMNTTwEwYTF9NfCuA7dWw8Q8KDFmZF5p6dCIECvhQTj8rt+oCCF35wK5zxOuW0A==
Received: from YT4PR01CA0067.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:111::22)
 by DSSPR12MB999235.namprd12.prod.outlook.com (2603:10b6:8:377::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.11; Tue, 15 Sep
 2026 14:11:24 +0000
Received: from BL02EPF00021F6D.namprd02.prod.outlook.com
 (2603:10b6:b01:111:cafe::72) by YT4PR01CA0067.outlook.office365.com
 (2603:10b6:b01:111::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 14:11:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F6D.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 14:11:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 07:10:54 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 07:10:53 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 07:10:49 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 09/15] RDMA/mlx5: Put resource reference in mlx5_ib_wq_event()
Date: Tue, 15 Sep 2026 17:09:27 +0300
Message-ID: <20260915140933.40580-10-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6D:EE_|DSSPR12MB999235:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bccb584-d100-4438-4c7a-08df133339b8
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|376014|7416014|1800799024|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	PxhxxNFOKMN3vKdG7OdYclPV58Pr8cPmQlvIDtnyjRrhQDRCy52VejqSnyMCTP4objVodrGlSv4lhCoCxgZtu1XnRhD2MOflKKq0ocbgtKAC+8JsHNzOG9a4wz0tLWARr1soFU1hBJ9itniOTulcbNczSBrGMVCvaJLKcbuh0eVS01KGPlY173f6sStCT7yBMT0KJyDxum2ZPmxgqJss1+EzCzgCFXF2VXfbTs26c8RBubRoXb2+oLAeDzwsxrCxqm43yhLXhDiZz4vLxXSGiQ5O+Ob6Fa8UHlPdzUHKPqMEm2A9JsSXieoFgE3/Ahp3YMF4om7fkv0bG+IUusmEpXQsnIriDrAxo5VPVrdklOQO6Uk7zQ2VBVDD18EdKMPbkKNwo35mKOEO4YblswqwTEcDdz7M1kJuA1mfZ+96nZEd0OawmXkRbflZ7mXGclMNawTMettEeq0W04F6JeGN2Mi4kqDPvjJoRPgg9NkTth0RnCQ9RFQxszMxsKnWcQ3ijJfSsq8CMx5F2I296d9kBCNhD+zHxgAwm9Wc7fV1XUBtGI9IYI8MIT9MnZ900iVfnLriKYTCcW67IEcswCjvzZLh69Twa4lPVkGLigPI6FiZNGVLY1GkKRG8tIU6q+33h9JZ7VLcqm2G/6oh5vymIdBh6cRHAnmE4DYQIJvZSNe5KIy2D3a3qfYqueDdq+t12Y8tJ33mi3RJqViAjGi3/w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(376014)(7416014)(1800799024)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+xhYespxRzXhVX/P+3LurlXP6fi2MUd1jd95iXQwwqDnJ+OwRHGkG8dAAMA72RmTOE50nFyeaGlv6CuPP49XxaPoUXgRBpXhUudWheoNMXk5TckSTOTBCiWHq9ALp7/Kd0qpM20cEtdOKc/upBuqDU6aK/Q5L/BkS/AJWyXa1ULGcHOCVra/fR8XqmDmAgBZq5Yi3kSQ8A90ztupP0JNcQSCjLhX29uN7sMua/r+EQ3uV2JKUwhJKgl4LQi2EgWUzfZHmXeGI0M5bLiZATCluDKr38erID75tDaeUrUxFRsVIAJsNsXAXV8OtV3Ih6xkWRntxBbpSnVPAA8Is9D4Vq509ttK3ibPSDA7pKljROqCnNjYe/op8DCK/glLcwkiFJdGqb4hbc8qwgjA2dCzK/bW9vAZOoHCwLRt8jUsiPjqbnPH4MODrR4if0ZB7YjJ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 14:11:24.0740
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bccb584-d100-4438-4c7a-08df133339b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSSPR12MB999235

rsc_event_notifier() acquires a resource reference before dispatching to
the registered event callback and expects the callback to release it.
mlx5_ib_wq_event() never called mlx5_core_res_put(), leaking one
reference per event and preventing WQ destruction from completing.

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

