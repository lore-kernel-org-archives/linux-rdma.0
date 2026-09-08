Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011068.outbound.protection.outlook.com [40.93.194.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E454566C7B
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881495; cv=fail; b=MRGaH2i6lcmlrfD1Kc1PIrh8T0VN4IjsXlfQB/NzF6niHbgecth39OHGC2c0rzPZXkCb7O1EB9hFEXDH2auvOZLgsMU3eQFaFTQMyHtg/d8v2E5FQ9KN/irB/FzNHfGQgQS3vulFNxnFHsIHYjZ0mfeFOemsHCGQXazl92Ihgh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881495; c=relaxed/simple;
	bh=hZUK6S0s4DuIzj/R9arxkvH8khbSlEOBLswSmNhtaPU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CiLaQJcfbnDZrLKCNS45liOVsP8AIIZ4EhTSy2Ikk1hxwBT7P5CBk5bBRHUHC2QjgaI6qaawGEfzceDfKFsDuuTFrY25+z5eZFkuryGkeXD4kts74AEOEtKSVUnGuxxyy7S9Py7lWO08F1gV/KcnVLHNu5xsadZh8ErGYGZPv10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DJCy1N3m; arc=fail smtp.client-ip=40.93.194.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DJCy1N3m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wz93hPpygsBaDv3RnW3WDCF2eirYizsQozWlB465P08XKvy4tERpYCrosaN93Pt/CdhdEwDqAuMzTkX3cVMStp5dm7Nizubmv3sXuSPPTZkPpNtfnDrVssNsQH4TblJOg1SexU9J4H8pb7Paj/9wq3RnMHLwxVj1RQTL0tT0Ce4a150QLSYTXWMk1l5lDQdwGtYX0wDAcWmpbU7nLCScAC/kJ/YbjsyyqKMNPPG3BxkEtMlKJALcJR3ZF9KJHYh+NwAQRl7WlU5VC56pDvtEsTcyvjyIrrGfaiuHGrDlj8UN9//fQs7LHIfWcp3Yy6ftFt+6EnkT4A2XUhtVrbwVCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ciotf14cF30VRsDcLc4m9wvo18tFrhz0IpgnYjZc7I0=;
 b=JeJGWnF8fGLlJYJUyv0BhPyL+CUji+AFuWdmPx7102B5rweWQa4ANDfCACMVaTCuVMMyaWLj/rWi0+80EuQIviHtFTyN3tjdtGBUJu4h35iry4i2zn7312ZRnYwJK67nWZcWY6VMC/wxBlfhOh+LczDY3fZQsOyt/n3LZtEN2NIyXptKI+QlpC2xjVLiJZPJ2kJyWS88IJ/eYycpUKuUCWPSwQTXm6eh3YHEySmoU+JqUJbXgLbaX2sFAkUJN0fp5RkPImIbNTdDFJ7lM1STrDswyQsBDFmooG6cb914mITJqUwre+tzHWEnTwNV6GG2F+jIco4PtDkew8qE5vOd+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ciotf14cF30VRsDcLc4m9wvo18tFrhz0IpgnYjZc7I0=;
 b=DJCy1N3mfRbOhNCFr4XxC9bm3MJERbn3VJ9i0rokqe/u+mNxLsyyt4/Nmutye/+WUKVkGf5CBpcKFqZVTmFf9l2aZjSyRHMUuyzDfGI6E0Qjd6nExBBonapGDfnKaRbYcpphbC+T2dwaRXKJ/0qhd/CcgkO0N1pp8xTcTDsf1d42kAhNZFFEXm7hUTZsX18p1TY6waCCPAa3z7FQOokQy/RNk9ktBWaOZcRWQ6kBQ3mm7Y/08AOevzqDamBSQe1GEH8pTS0oZF771GsTU87U1dX6j6Ontg3IN06r9MsmlqlYHaVpFpsMyuWnnMnZyq/Zd4ps+ipS2zFzmDyucB25/w==
Received: from PH8P221CA0020.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:2d8::33)
 by MW6PR12MB9000.namprd12.prod.outlook.com (2603:10b6:303:24b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 15:31:06 +0000
Received: from BN2PEPF0000A893.namprd04.prod.outlook.com
 (2603:10b6:510:2d8:cafe::3) by PH8P221CA0020.outlook.office365.com
 (2603:10b6:510:2d8::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Tue, 8
 Sep 2026 15:31:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A893.mail.protection.outlook.com (10.167.248.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 15:31:04 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:26 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:25 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 8 Sep
 2026 08:30:21 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 11/15] RDMA/mlx5: Set SRQ event handler before xarray insertion
Date: Tue, 8 Sep 2026 18:28:47 +0300
Message-ID: <20260908152851.1307294-12-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A893:EE_|MW6PR12MB9000:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f6d7db9-949e-49ca-c39f-08df0dbe3234
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|82310400026|36860700016|7416014|10067099003|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Anm9W/H/c5iNt7gD+FRxfK+Gqzve2S8aZpbOP26Dw2hTZQR7F1fYHhYsZIL9mbpRLw3zLRGkXsFwIZBgDPeLxewODqnZQ+kXR15epDW/1jDZpyu5sE1NXSaUM6DAaIqyahu7PDyTkdDdorTE+CUNGyCdnqSIt9BDINuPKLa1HU48qAV0VR7txSHLvnZa55jBvElsC8ar826LJMbnCz+xosHCg3nWQ2idTYQAQzRMvilklG4MsLJ/jyPF8Ru+qar8+pDLjWldCby+H27B42QKLg49vZ00GyahfBcXMp0xTON9EVVm+eHpZjoeO83ig9Foq98vM+UrgEVXRGN3UIKwQMCoCrGBvQy6w+URYD+WQDHDGyQCc7aJZBtla5740/mqDap+fTKI8QsEN3c9lDXrH0w4PCbMshvrdhJSgLnRV0ubXMJiKS3lY1XVgPGQ9VCF3G2ZOGylSUdTTxbgx68XbESs4DYsYF0R5EgnlZx2iCLMtMOwJBVZTXxgneSBincU3rpq154WWnSTdjIDgJf0hoQDuBRh9eP210z5LdPfRAocXMfeH9T3IUp1GSvOQqBNSFHvshSXJvPCJwh63Qpm+hn1jefm8LTeCmIPHk6sxUNGQcSXQm6ESlaAOadVCRj/R7KCbTMIwVPZPDnNrSVcxo52HD4MSWbObSc9/sF1StyH9MLKvv57+Lr4lP5VdEoQfu5zcLYvB+w1goLMJja65w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(82310400026)(36860700016)(7416014)(10067099003)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Kku/ny51AdonZCljJ6WKg6q2EE1+fzc3PHMNZdaRGvDBbMnooVQ9HSAvq+rBKB8ZF+tFi1puaGK/qSDXIgSN+XakJd6fVXo8zdPy5C9+EnEZKvMb3fltqPv5+XAJsVL3qV7CD8mRqnM7J9xoC9acb1jTQD97g1M9URM1lR9ri6nYffYBo3AcNvQ+BdKXvPUSTAZLqMWUtQ22pvIxzBUk3vuoNYuvn1KaQ/Eridi2OldadOpkmyvflAdk5dE9FiNboPCmbZhGEGFsBIWNURcHpfaV1rRUhX4hBE1A/H+Q8pqS3k93LWrwQIMvlwWbUqR+uRcuSarfcw+jVdDGx4eLCnVetBhHpEJFFrJtmrirbGVcFXh/WMN7P/IfFtiSbYJMAZDOhROEfAMJvfY1XINM03JM9AzI7+If7b6yonn4J8EyKzEZLAlhCYDB1zvnsztt
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:31:04.5358
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f6d7db9-949e-49ca-c39f-08df0dbe3234
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A893.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB9000

mlx5_cmd_create_srq() stores the SRQ into the xarray via xa_store_irq(),
making it immediately visible to srq_event_notifier(). The caller was
assigning srq->msrq.event after that store, leaving a window where a
firmware SRQ event EQE could arrive and call through a NULL function
pointer (rdma_zalloc_drv_obj zero-fills the struct).

Move the assignment before mlx5_cmd_create_srq() so the event callback
is always valid by the time the SRQ is reachable by event handling.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/srq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index a973c1b7515f..6a4a937d97ce 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -284,6 +284,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 
 	in.pd = to_mpd(ib_srq->pd)->pdn;
 	in.db_record = srq->db.dma;
+	srq->msrq.event = mlx5_ib_srq_event;
 	err = mlx5_cmd_create_srq(dev, &srq->msrq, &in);
 	kvfree(in.pas);
 	if (err) {
@@ -292,8 +293,6 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	}
 
 	mlx5_ib_dbg(dev, "create SRQ with srqn 0x%x\n", srq->msrq.srqn);
-
-	srq->msrq.event = mlx5_ib_srq_event;
 	srq->ibsrq.ext.xrc.srq_num = srq->msrq.srqn;
 
 	if (udata) {
-- 
2.18.1

