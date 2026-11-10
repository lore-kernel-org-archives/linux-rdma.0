Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318324;
	b=EIexcH5GXCQ94deJ8hzW6Tnz68jUo2uVkKrIJ2M0ywimguHQC4dtG7cYNHUovwYFCXbw
	 LCmqiGSClHbdGXnkCIZnmtz9ALnpucvpNGIesupdVrkY2Pd1R8S/bj7zRp4/pkpnH8Nej
	 tRWs6SyPB7osPMoZXFqeUXRqzUHufHy7RpHtGMIvqRq1Or3j4Jl6rLLAqwhHjaH795OTq
	 gPhkPJ3pZzkgV+OQ9DNW1juvKWn/DXaM3jxwxkhkJGDumfXY2z4e7EfCxXMI9/PfnXL3w
	 FLO3OPflkmDCLZSB/++ftm5v+mjjDpkt1czhR/0CsJKP/VV7UP1rohLoZqjjGsMhLJw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318324;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
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
	bh=IJYZ0dB8G9fJyYy8EteFiwfA12mhIsapwhztFKc1oA4=;
	b=0HEgn9gi/okL/fzep9dgiQvHKUSf1h/6PWJQVxRQh5G+L6uvIt3QbeQMbfoLWt5tAFFD
	 x+ip786uLJfqS74hLZOe7aDk3E8pCvQSSwKsr5nk8RkWjI78hA5EMC/jjUyfV846q7yLc
	 U+IQTYTLeLwErIssJSBGXj4jt22/prwYCEqp+/zdRmihAwD5Mpn3E6JdMribYF3vsCl+H
	 mXiJASnG+efSaX5hjIrEl7c28IGabYugHO0CNE89NWzU788Df+FKaktIegSP3O2bh+Zfo
	 Z6SuETqoR2gQQMcGvTT+RvStkvl7SxuTydBz7OoGqWROSipX617ep7q8jmLc9bF5d7Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mHaR0vee;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.70
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012070.outbound.protection.outlook.com [52.101.48.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DF0606A331;
	Tue, 10 Nov 2026 13:45:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01DF0606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mHaR0vee
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WoK7rVTm8+n0+HgMwJc12ON6rXlqrQWvDFvxHm0WBBfojHvwgGq60vySEoYgbmyq0xgAhBoB6i4Ti+DQ7D8rSXAp7vKZoGV5G2kOz5/5ZHMuen7B5SC+sgQ0kohaPSxSLawiAjYwIPiI2ehe6/EvK/xErSxRMOGLbvcy9VdSScSIsLOpgmDnKyTp3sP1k5RwIETerMLPDSlWVCOr97Zt9nZ9ZdJ/tatbMfCmYkYm2/xe9EVdcuZ8ijAUOiYxjbdF1kQlBTvx2PC3BS8vZNWsZxD7tllMFMfrGyF5PUcuGwFfYNPkmj6p8j1odFZl4UOpQon5WK3rLKn9TxsWzbhpMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJYZ0dB8G9fJyYy8EteFiwfA12mhIsapwhztFKc1oA4=;
 b=xNBM21QB0XuwYKFORWzzQStdPME/kweOmXlK5Lfzv7AIbY7x/m3tBvsYWceZkZWUezN+BBpBl6vHzhkEI7frvMH0tQlD3R3835iloTzMTwJE8dwQ6OcRCwaf/3VfSV1AJOPTwnH1a8Xl4SAtsr81NMECJnZfENRjfX6CMnJ+JcIuSf02dP6zpdif16zcyS4Q20ZSS5CD5l3smLH6GOCSUBgRqcFnR7Zy20LoyXN98CGmOUrIS+AYKVVyq3rkWkrHpjhzA55E45vU0EiNDKannY1R4KX/x541mrZOz8b+aVm1JljMfzt4K2R/gsxy7ICZjteQdMQaSJXI4+LLImHGjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJYZ0dB8G9fJyYy8EteFiwfA12mhIsapwhztFKc1oA4=;
 b=mHaR0veeVRe1McsguIBR2JyNn7V7hrkkBRsDEOpYdpBNgkx2l6pnXgdF9OZMZbSAVbfWSYbj3bEXUGI8R6Ar8hWvTA5wBX9QxdGMYTcjC4XKscZpR+R64BYUibNi5pNdS4m2EfRVUlt/N+mWT3oueCo2UBEa70Bwg9pyCOLGmRlg46iL8bDLvoDosF8K9l/W9gvy0ApppDbYiQEuGyfEfoW+0xxtnA0idR7yS8ccqVyTKx68+Q9tqtCeJZQeipX3B0FGBtNmiiE8lLmR3Z7EtTusW5Z1+FmnOq5nuok0X3cXSM2J2f3fIyvHmJe4vlnmptmWaf6gUf/U47JKFe6Kng==
Received: from CY5PR22CA0078.namprd22.prod.outlook.com (2603:10b6:930:80::25)
 by CH4PR12MB972801.namprd12.prod.outlook.com (2603:10b6:610:51e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:45:19 +0000
Received: from CY4PEPF000392D7.namprd03.prod.outlook.com
 (2603:10b6:930:80:cafe::7e) by CY5PR22CA0078.outlook.office365.com
 (2603:10b6:930:80::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:45:19 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF000392D7.mail.protection.outlook.com (10.167.247.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:45:19 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:57 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:57 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:44:53 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 15/24] RDMA/mlx5: Block generic CQ poll path in adversarial mode
Date: Tue, 10 Nov 2026 15:43:11 +0200
Message-ID: <20261110134320.34408-16-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261110134320.34408-1-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF000392D7:EE_|CH4PR12MB972801:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f9b56a3-3ade-41d9-b3a9-08df3f30dc3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|1800799024|5023799004|11063799006|56012099006|22082099003|18002099003|10067099003|261102123227099003|261022105027099003|261021135927099003|261021121427099003|261028144727099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	MTqVyrP0mqJYjn7QHEM+JapZ40gSRURdmolMQIsstnH3S4t/fm14m7aXlEx391xlRwW0XWTXrh7/yvLF72Xnw5i1H9GcHIKubWGP5hYBuLEr4rkM3oZjIJTuKrsUhd1URavmFWe/3ibdl7x5ON9rBlI1C0Blo5tPz9vocJD2W0KyPIKX1mpqnTMfPaLE15wvTRwI+Xe7frPOH5WrsTpb6FT/+gWihFC1LKeaXLW5H03v3bJYzNBvFylTvsHKo1HpZyMxeV2uYAMPBz6tsu7LOdaykEDLgu74UeUUL0XuKicCgh9nB63YrWOort5bir9Cju3jjgKuDCKO27F4Ksei09MkO4GFa1S8fGuxI5yQPz4eeSOLoeioezBpg087c8oTA8JekbQeOBw2q8NnzzArfpOvemL9zdx+fxk8ToS9ST4G5PB8lKjfEqMqnME6VKP4EXH2yRmr5DJp3ubB0nb3Vf/oWM9bRsq/54ZYsWgyOqYbMeCLCfcpsdcFgt1GaMKvbq2PX682OGqKpv9AfTdQEftq+ErMNBQyyOqjsMbl466kMj85DovCAeqxIv95aq4DWXNL8Zqh/suQKeNi1hh3AqfWLqLPe1r0ZhYpDMserAdzBJeraj7rjIufhnDJKnGN4cWhZ9lRJACGk7DPPkXIFAG5UsL9RuO4ePM+G2/C2OFu+GuWDpiczPyo2cbdZ9+m1PUy2WfylEamsllaa7Ph4A==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(1800799024)(5023799004)(11063799006)(56012099006)(22082099003)(18002099003)(10067099003)(261102123227099003)(261022105027099003)(261021135927099003)(261021121427099003)(261028144727099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pVMCNJRhyTK5A8cW/+vlHQtoIpZ2AgrWv0STqh9OZmP63SSzjil+K9sHT2ut+crXzT4ymnVGmc+7rsKmRShx9z+CsYBtiag1UQ0JEajOlc+z8e3m3X46ShdJkphJKtsqtpgYrdW7YZOMm3d11Tf9YuD8FrsBO/dhqmlrDXEdBjRosm/CeNQBAumpBGXSG1gheCWTbucUDwla84QpBVMbBexY8UdH+4AZTEoXFQy+2hGpwKI4vb6Po1UpXn1hhjyQAreexs8BtSM6M+GR6dbnCRGiPH+27huupJtKzxVqPpuFmrEFmhZ5DeaFaZW0EyUhvHGDaX+lFPCl/bV+EMgM11t1YIGvZj+NN2D3SU4ro/U3sBlcWwa9sMdSZ36X8mvp5zIKZJWobZDtVDX7n+jPc5F/rDFF6Jss+czdwDISYesZo5nShmwr40ytCJGG31PS
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:45:19.4655
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f9b56a3-3ade-41d9-b3a9-08df3f30dc3a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392D7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR12MB972801

mlx5_poll_one() trusts the CQE content, so it must not run on a CQE
from an untrusted NIC. In adversarial mode no CQ needs it: the UMR CQ
has its own poll_one that validates the CQE, kernel ULPs are kept off
the device, and user CQs are polled by userspace. Refuse it there, so
an event on the UMR CQ before its own poll_one is installed finds the
CQ empty and no CQE is interpreted.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cq.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index c6c3d02709aa..54ab85b99f45 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -464,6 +464,15 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
 	void *cqe;
 	int idx;
 
+	/*
+	 * This path trusts the CQE, so refuse it in adversarial_mode. Only an
+	 * unexpected caller gets here, e.g. an event on the UMR CQ before its
+	 * own poll_one is installed. Nothing is consumed, so such a CQE is left
+	 * for that poll_one.
+	 */
+	if (unlikely(mlx5_ib_adversarial_mode))
+		return -EOPNOTSUPP;
+
 repoll:
 	cqe = next_cqe_sw(cq);
 	if (!cqe)
-- 
2.18.1

