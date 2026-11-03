Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724131;
	b=tn15k+AhnKrv/qj7/ZhY1qltVIdk+A33ZgFV8x8kTlikokau5mZtRueEtSGXRyqbzOu5
	 pBBNBf+hTH8PjPWgfi3oQzNzir+vqejKz5ixuPmhQhT44gudRLzm4h2K3tktb7q8n1ogM
	 LwzI8IxixaAvrJMx6ybBdNtDx7cEID4+7rsYMNvX+yU5zOTBbdOdTxe/WS4ht1h9sC+b2
	 kCuJWkfGns0NNo7R8BFwFXcMLP4NGKjnuK8hjeGWRAUBLtFVs88AECLP/1nWe/qDr8Ma9
	 jBAzI7PziX/JZXgV4HmX/sGxfyQpIN9+T6O1wI27uW/RBWvsCRNNNYkt/fq+0QvfcPg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724131;
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
	bh=yf1F99gQOfEc0NX1DIQmmx1knSBC2soQJhYC2hY6fNM=;
	b=aNVbvPkbFm9ErveB6gKlWlUnPWdI6bxt0W8cTv9/3Osg+UAhzU0EvIO7qb9jpGM4DeZH
	 feFsLMb71NemaJDlm/l1EUY5E/VTSsC0KPA8KRCle2FcyTlbtgd1ijgkvjcvAJKfChrFv
	 Sta0rKtXk6xm/1QtH6ga6NoqOAscHnXnPU/dXWrcJTdcuf1xIWIr6l8xTtA4SbfUidbhO
	 bLTWUCZY3HG5scNyELIYV7k+koCxK87d9RPOXlN/DTwgxinczCL9X7b0vt4ThKSgCu2Cb
	 Iuoj20OlruheFnab5bNEdhcgTZLO9WUHg+kOtUMCh7xNa9ISo85GWpmJxyEd/MjanaA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="dxxKXe/Z";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.44
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010044.outbound.protection.outlook.com [52.101.193.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A209060A382A;
	Tue,  3 Nov 2026 16:42:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A209060A382A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dxxKXe/Z
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B+UMap3WbVVJMrc9dIUuReAGY8pO5Cuo36xADOMl9oarJ2OGcCBGJjtEbochgUnFgmzoQGc3WC1gA4tj7ZS/c6DGmoEju2du2oS3v00plzKDomzDcGOqiZmpE6XRkx45Ss7A80WC9Qgo70BIbuv6WlbeObYOZZsvWrj1iqvCzsCPLbes4+4UUbDtDokm72o4h/crm+RauxTt6UqyfxMyre5BuXZxdsOQzGBx9dJx3kRDDVMXn6zSy30HUjayD9DKADeNpcg7UOj1SUX7D1JYeZRE2ePdWUNh3Yuelj5F5XAEqd9ofsN7r8APOkKEcGbPqXswl+uhpg86QjYq2ab73w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yf1F99gQOfEc0NX1DIQmmx1knSBC2soQJhYC2hY6fNM=;
 b=yC2Ph8XLuZVmzfVx4YX6oQPud53S+ORPypstORPSu/wqNoDwflvZKswH3l/iAb/tUC4/SPFJmKtPPFmzpdVELeohbrrnQxKCIXDpczEU1uZJj+pu2LZ0NxIuPJ8XxmwQxgaRFZACjceYzidiRZm7icEjOVp/0iPEkQILMNJJfGDmdZ2yvL9Zms1u2EVd6UByZjDgecpjqjn2hVnhy7IHzWh/mhm7SH7eyLx4eABF4lKRfDwrtRp0lDi12uJrzB44WsG4NYMEGQBPWFirjXg0KXC3fKQA9v6Lkz5hni7BocNKNlopTVkAB3LLKd4Rj8glDLzLR1M3AVsA3bhBqGhlrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yf1F99gQOfEc0NX1DIQmmx1knSBC2soQJhYC2hY6fNM=;
 b=dxxKXe/Zg9IWIFsz59O0pqLSN5RyLSVV94up7AI83saE8qzDruOlQArgdGix+VaWe5UrHUTrfg3Qhw1nj1oH4p7XsPSwLPz9ixbDPYQ6wyyPLZRkk3nuvYhZXk/yPaccGVD8EEK2gkCbajWV7a90szMLx6guErEdF94+/iJF1hryhdpuGFSuuUX5CXrj/6oVuwv2ZW3Z3HtG5ZHzeUHKYKH7+CK1VRnekI/cFqepCfluzInkY/YazRU4HByNfgIgUwyWBhAdDNiHPb/XmQPNSMsToEOqlW/b58V02HK+mVRfi5g+wCKRxP4xeD05WDijhaFK5L6PqCCVJc99sayuGQ==
Received: from DM6PR07CA0090.namprd07.prod.outlook.com (2603:10b6:5:337::23)
 by EA3PR12MB172729.namprd12.prod.outlook.com (2603:10b6:303:30a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:42:07 +0000
Received: from BL2PEPF000352CE.namprd02.prod.outlook.com
 (2603:10b6:5:337:cafe::9a) by DM6PR07CA0090.outlook.office365.com
 (2603:10b6:5:337::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:42:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL2PEPF000352CE.mail.protection.outlook.com (10.167.249.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:42:06 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:35 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:34 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:41:30 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 16/23] RDMA/mlx5: Ignore completion events for a CQ without a handler
Date: Tue, 3 Nov 2026 18:39:42 +0200
Message-ID: <20261103163949.1554-17-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261103163949.1554-1-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352CE:EE_|EA3PR12MB172729:EE_
X-MS-Office365-Filtering-Correlation-Id: c279ab5c-1177-412d-757a-08df39c96595
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|36860700016|82310400026|261102123227099003|261021123027099003|261021121427099003|11063799006|56012099006|261028144727099003|261021135927099003|261009223027099003|261022105027099003|261026121527099003|261026140227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lnbkNElZ+lrPm0k6v89V7JWBBSyNitHhI1sH8MbzbCJ5Cd6an/XKwKuH6tFvPPU/yNbA3fnoSB0mWEiMpZyzr8gtC+c+jCzvyuDPn3f9x9w/A5/XtT/E6xZvT7ne4w9FNX4b7MiOsGfxahjWJtesvZDMOfnlXZhQ6SW5vjEHPdNrgM5iDrwLXHai0z7gO8fOHdu9mMEI73P+izNHAB1kC/G/0rWqvMG80erUJWUVw+wTnYgAxaEkIM31AzC2Y9RSS3gKsw1FRKHjr8TyuWwKX5ilnNYflsWnPmhBSZ1cCusFpCMUmYRroCxUFIjfKu8zN91w7R7MKtJhtPFPLedZEit/PbmGW7fHmCEEUvq/XSndynKo5qUi/b+Pmu0NzEFGyxUuxdZ608Lex6VneogWXHRySZZSwFa28a5KrxGMqsla3RYulPPPJpPyx4sEJLP7PfXeFq/4/CwUv4m9IpSTQzh52jdkQspGyJKrfTkhLRg9wMZhSYFXIaQFpKpFyVG63LMeduhHI1FiT1s76DAYznTpyiui+bQynTR0mvRqZg1e4E2+2TGhKofbe8UW6QXhUrVWm03Gh5OWxuajzagaQEEqIJr8vPHozETz2NI7GmlwTJIXzKah0QFCK6b7t/tv0ehiq2ttEGadRVxx90tUOV5JdxaNVHeO8olkLHJz1wDebM+x3ROhEPTVRWw8MW+ivskpOh6PuDbcx5o3jtoD/Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(36860700016)(82310400026)(261102123227099003)(261021123027099003)(261021121427099003)(11063799006)(56012099006)(261028144727099003)(261021135927099003)(261009223027099003)(261022105027099003)(261026121527099003)(261026140227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	w8HpuEiG4/6dfAk1eojfju2hArf1zw+PyASKGpsQTG9kSlk5ccACAAQiz1ZEVcPBYKzkgBx0RVZL9icNqi5TiFDRwd6/Qntq+gPJG0w+V8DYtjajlzfKe5A7EJEtFgVa3Ce89IfMwpiQUjHH+eCkbG+yVQ+BxZPdxrgTVR/EnrrJHno+kc+FMwoINrlDEzh5gGfpmduMjWoMJBA8stqniKx3DQvLSRxYvkDU50NZ+GtyDvxKffzU08cgO0WTGcS3XEVI43nCGBbH5ILxvAGGvMv756UkY+c8uLx6bStnLquzh/O1l7/ayOFjWSxYCOI28pONowJ5y81qJh/VWtf/zINS7TBsrX0xNKaKB5gcTyJ3PSq99QugczN8M6aXHnjCYhfAgXdg8aJvzSmAzCCb0EkDjQ2hdT0ptmnL+9/GCGvmhdTZswZadLL2scGF9DZH
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:42:06.3165
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c279ab5c-1177-412d-757a-08df39c96595
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352CE.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EA3PR12MB172729

mlx5_ib_cq_comp() calls the CQ comp_handler unconditionally, but
devr->c0, created by mlx5_ib_dev_res_cq_init() on the first SRQ create,
has none, as it is never armed.

A trusted NIC raises no completion event for a CQ that is not armed, but
a hostile NIC in adversarial mode can do so with any CQ number it
returned, which ends in a NULL call in interrupt context.

Skip the call when no handler is set.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 5cc86c3f93f3..f955eb762051 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -46,7 +46,12 @@ static void mlx5_ib_cq_comp(struct mlx5_core_cq *cq, struct mlx5_eqe *eqe)
 {
 	struct ib_cq *ibcq = &to_mibcq(cq)->ibcq;
 
-	ibcq->comp_handler(ibcq, ibcq->cq_context);
+	/*
+	 * A CQ created without a handler (devr->c0) is never armed, but a
+	 * hostile NIC can still raise a completion event for it.
+	 */
+	if (ibcq->comp_handler)
+		ibcq->comp_handler(ibcq, ibcq->cq_context);
 }
 
 static void mlx5_ib_cq_event(struct mlx5_core_cq *mcq, enum mlx5_event type)
-- 
2.18.1

