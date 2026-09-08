Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010011.outbound.protection.outlook.com [52.101.56.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AD94A090A
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881477; cv=fail; b=pWzZCmUFW9/rZD9rqClVkDArPaOGpKuYhPDeGG/a1q7Lt4sSckUBxoKYu1nVw6c025q4xn9D/CJOIA2kbnvLEZfZqURiGqr0+ElfSNr8coMaNI5rx2kr/bElSeE7uZtKNr0XZLVUsl7rBwlfqchjHbKoZzm+VD1f1bPdVoIlGSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881477; c=relaxed/simple;
	bh=DCj7Gq3SPpt9XmWZ9JVNHYqrb8S1LRrwCv+H+m+RzdE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t/dHkIAcwnpgccpxva+6c4yzUM7PL8eOB/uileSPJJO4S0SUIOmb8t6sLBVBsQfeNqb0lZnRJ0Szsw+rZmOogtuWMRjeIfiDT9NtiB+AchMJmjPH/Wi2CljprjnufFPHU8WL6Jb23bWXQGZVYjJzZ7FQ8bTquw5hH91iU16+kqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XET2eBLP; arc=fail smtp.client-ip=52.101.56.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XET2eBLP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VE87vnPt4HVh0JhGAEo7gwkc6g2Do/rigQ+sV/f1mkuAkzlf5YDSaqVhOq9hz9H6D6+AQekgJphBEkLbKUHmrIu3oU5KGlal4ZiVIWrALwRRBXdeJjV4sJoED9+ZVitv6vXv090/f5+NWLYPi8hXn9kVvc72iqntbVfFDNP0u7WKY3aFTWeWLdJ4Frc5ZYCll+MKpApJVtt9iHJQBNBPBRfEHDU16T9siNnaYldc7WfIe2I+KLXI6tP2OnLRRw7MJckAKMfI9L96Dy0ZbditI417BqWkSuuEbXimBcSVpMEkO2wO/N4HsU6diVjt1N8Vd4KhpsqSIrPKM7801JCctQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXxOzOaioj8CMPg4mUIs4ViaMsNjss90zACbZTRfnJs=;
 b=x4xhCPCA94JsqxChFycu11guwQvjm+MgAamBaVdNHEmGh28X0R7BMucHdJM3pqWrIY7NUtRvr7qqVoltlJDQal0IqG8Zirib1jvMJ/lxi/OBjkRvZCZ23ujUrmG9rUFpCVao/8N3hYbrGqej4e4pXyswXFurlR9QuPIJ7Msk5f4rm+vkVGSecSVON2ATm89HDULA9InT2d5AoMaNp99r5KQeJEIPRhPz9HD1kTBcJ9JvhVyOoa76LkInxXfopHjZWSY7cGggvNmuvF6vqxUZdGK9ilbX8+mMFz+KBFQhjwLQBM5tdpPWQYqbje6eIyixPmCohakFsw6rl/LxcxTNlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXxOzOaioj8CMPg4mUIs4ViaMsNjss90zACbZTRfnJs=;
 b=XET2eBLPuMaaKC8zqNM4/wg/qkGENHvJG7Me8/sQGcTi2Uc3MRYNed1cn0Qp3XnpcJyaWHCaOSoPqWoFI0FQlVdkohRODKsAt6Q3p65jUH5Zmo8p/1GxBiSSF3teqwG+/JFN2lp75v7slYnbvQaW/HU72Me6j4BOZNNUDhdh0WPChII3QlkdeZQx4uRgJk3bqe0lWdDJ3/dsEMkd//W+g9YfaV3NI8qQjjJhNYdap7//98XIbXc8IK4OdKmeMZVBsUcfnUTQxfDwMrzVkfZOScVqtZc1yrXczQwsLsF9orW41rDcagFOYsYsVK0/+69xMUR7myNNQ9Zx4Y3nWF/MnQ==
Received: from CH0PR03CA0394.namprd03.prod.outlook.com (2603:10b6:610:11b::28)
 by IA1PR12MB7711.namprd12.prod.outlook.com (2603:10b6:208:421::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 15:30:51 +0000
Received: from CH2PEPF000000A0.namprd02.prod.outlook.com
 (2603:10b6:610:11b:cafe::78) by CH0PR03CA0394.outlook.office365.com
 (2603:10b6:610:11b::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 15:30:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF000000A0.mail.protection.outlook.com (10.167.244.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 15:30:51 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:21 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:20 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 8 Sep
 2026 08:30:16 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 10/15] RDMA/mlx5: Set WQ event handler before firmware RQ insertion
Date: Tue, 8 Sep 2026 18:28:46 +0300
Message-ID: <20260908152851.1307294-11-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000000A0:EE_|IA1PR12MB7711:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d410dd4-cbf5-4d21-d20c-08df0dbe2a54
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|7416014|376014|23010399003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZkJkrkj85JnYHH1k5LFz1njYvwg1rap9T0M8tLDZ5Wg0aDaEH2puRaE0wqMnqEXx4W/Vy6XsNadqrNv4pYjBkTi2b8J/IXUh/T9pMxbwOfEUSlHBhFWnPgqFkhsII+2gHxkec6eOxZ34QtlFnjmrAlylD5mn3w3vs8ESxK7QhC+MaJRSDlr6IgW3ZjjBDSK87dgOuDaE4bqbjqvvm8POg49goE/wavU5XWhWp6Xrgwu4q9QAfqG7h9Fd9Uri8DBC6JsZev+zMnj36Hhd4pBurVONu2Ce69wtnNnAKLojQaDkptwS6ptMLxpTSXm66byKWDdKxA6MLPwliT452jzt8OOs782fllxRu/D1VbbXJtiKNO4uIq5OFolaLgroZ7WjZi6DgTSNneeQMSPgs4jgfnKc0sRsEI0V4/v0QYoPX/kkbvrMqJcxnFCzaSUbOLjjaByXHO45OPouhWr8iyGbiT6X6/menbAk1YkXtNxeBREb2XMMa7BpcXVDK39oMNXH2PqYdMvrF2/S3Ahv/KO/7Mb74LPlZ9DuhgaCOXGBdMqRvuE7N0Dpjpf2M5D0ikh7JX2/98Y7KpSJDN/CTmoUSBqpFa3+a32IXwdyE2pT8kmbhnbW+qyxAPhZgMUyZkZXnySaz9yTmHkXjbCAr8TM5Xx4nal2EE6qBtkKV3rBNSJIMg8MQBz6egRC07TyM/3sf44c9+xBrMMrYuGMh4T/rw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(7416014)(376014)(23010399003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CkFzyO301M23prhBzELxrjCm7eG9b8M2gqKWqJBWGUq/0Ev+eYW1GmHP2VCffECTDOO/vjoulS/9thbuV30L0zNOjHXsjxAeZBcZAb8wPgGBrOOorDwqJmgjk1eGuwiwTKQiCE9+SKMdqLQjFbYmBZ2bm/uiXlEZWghh6u6JwlXyDnC1WZul/YtCIWvEutYvMmdy+w9ujc1sVDwHQM/vxSZfQ0/uEdIorJnP3J2XK/0gYwhtbr9ZOyJ6eJst0iSP3VogRaCQRghwEMOkOODethNZCax7PVhZHpxOkBF9QIB5PdPWxooajePt7CxVbXVx/9f+EXzu1Bbz8PjaCsWJgGTKyw+mPgvq14+i8NPKOs4ZQS01S7egeotFmWfizrqoBsb8pG2V74sWtNvARwopuRvLLxVmfmaoZvcFoyUHF4kjUXbMjyqmWkqzdC3Eb/1b
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:30:51.3683
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d410dd4-cbf5-4d21-d20c-08df0dbe2a54
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000000A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7711

mlx5_ib_create_wq() calls create_rq(), which inserts the RQ's
mlx5_core_qp into dev->qp_table.tree via mlx5_core_create_rq_tracked()
-> create_resource_common(), making it immediately visible to
rsc_event_notifier(). rwq->core_qp.event was assigned only after
create_rq() returned, and after several more steps (wq_num/state setup,
ib_respond_udata()), leaving a wide window where a firmware
WQ_CATAS_ERROR EQE would find rwq->core_qp.event still NULL and hit the
WARN_ON_ONCE(!qp->event) guard in rsc_event_notifier(), dropping the
event instead of delivering it.

Move the assignment right after the mlx5_ib_rwq allocation, before
create_rq() is called. mlx5_ib_wq_event() already null-checks
rwq->ibwq.event_handler before touching it, so setting core_qp.event
early is safe even though ibwq.event_handler is still assigned later.

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

