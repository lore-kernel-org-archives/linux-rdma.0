Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318334;
	b=buIn0nHMhgPieahZxEgjkkqT7iLtuQ0mtUSlkgvnu+Xuvjn4W8Q+lMxQmcuan7VIrrhe
	 8KYwMJO8BkTch30jnb02VTNBMM6giOh9eT6Iado3vDRMBgd2qlEGzd+Zgezp/gH/4z+S5
	 /0IRVCW0u3gsvcexJ5gsIDhCnlvEbqTDlMu/tE5jTGuvVbZOXPCzvp7VjQkD2WYTaK9HS
	 z6ZrcIipsiSBIhyh68eI4NozxF3CPaeZTpp+96RJ26JbVCO8nft649fedwq/c6jBWG128
	 8zwfXbpgQXBWu6f0v/4md5bPCEecAR+HB5FK15xk7qMsp6xIivNdzaBSJmKq7kB/KUQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318334;
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
	bh=lgNVDHvlsXP0qFee9iNlKYh+vDTSNypel9uOs/EIap0=;
	b=QJbl0s0/8rxstoy4kz3W++FwJ2qCRKP1NImv2IFGD0cLr1BM8vuhcxXTv0GVvlK5lik/
	 pjuNiK+ia67JSAqy8rez4kgu3buGT8lgRgeh9Y8dSbToU7ScBYzZqvNtb8qfhzE0GmQTe
	 pviJCqwjAcv9mNhWwnKcHio8g7xWkLXKoszew7U4vn6RIVjJm615+d5EiS/Nm92x0u8ky
	 Xc3zrbs3J5dMpsLGm8ki/ApZlmRBZUAdbUlW1PvllHx8FezsSkfeR1SZmPTyXDCojqr2Q
	 2fiXUBVgVhFQIwFgIQR+ASwrZ9pyr+gswFDlMmzsR/SfscbCHO9FyCuAs/g+tQg/CKQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=p5tckZev;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.64
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011064.outbound.protection.outlook.com [40.93.194.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2090960A2608;
	Tue, 10 Nov 2026 13:45:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2090960A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=p5tckZev
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uzKUzEXCD495kpcxiR6KNFy5eX3DPMxe/CKkjRBaSpJ1hU5H3XNc931VHf7o1XsrYWBW6cwI3haw00V8EfsCvu1pbFzTdMaHqrwOj2zAl6eDqRXKOcWv/mbH/BrJQWL9Cew3odPL+SKXv1fKenXtHFMdRD8/OhvzEjV1z4NqSYFKtUFGVct2Lb+RfMp5YQHPo0E8LpLSdRgIGeMmVPlm4AVSQW8NDxSp6XdEZuuj7LEk679KMfxE9jlj3t0HVYljzS+SL+x4PcCxUvrj8p+CD5lGECvW/vQUbLnIbp2wjgfu338zmqAuTnJcl1LO1E0ruYkk54SPhhwvApBXre52Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lgNVDHvlsXP0qFee9iNlKYh+vDTSNypel9uOs/EIap0=;
 b=ELzSHECROvItSUvTBjdX3Ek70eond7q5CzCXfCjXewQPrxlaNCfP41tF647yKKUrOvhFUrQEYc+7dSf6J/2ayj7FJVyo91cOV8VPwQPjVIodTKEi5hTvxF9YfB9W4PLby9jfVbcKv3+o3X5fa3914pabLRoejbmS+p48kjifcKKOh0rcsfpNydl0f1uKAsCS1Ej4laZGryeUCb7lPdytUoAU/nbKUy5cUpoBNj13OkvVT8KLCREgv0bdCwLsOc0goAvvBawzAMF8a2sSuKrKZRfJl5zPYcsZ1xZpaVyOovSziiPnqlMUpe4htvcQjbSqxwsxTWG2FX/ypiKbenzjbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lgNVDHvlsXP0qFee9iNlKYh+vDTSNypel9uOs/EIap0=;
 b=p5tckZevZs0DhV8kbGN/qv3cVJ8ShfqHDuChiSPCMAtlWlplkt94pUJ+kZHARu0ka83wroz3AKZs70oEc0r08AuLlU1HhP0IplAHAW0aVbpdBB5ViyXOP5bH3UgpbJ8hk+mc6jo+UUvy0VVU7vLLsOUfuz4FmwgtstkDNC5P60JNvckfImsEEyNfPA2NqCT4laNXKZy42gN6F9HgKFwqIOmqjyH+qGnxNjmgoLHXvBvjvz+l6qopEVdC00OAoWLnRTMG3CI9PG6yxgkHC8KXjm5ktOSR0lZQ1j0GkwkgLptobeNxuhBwD37iWU12uxMW3njWpRKpVcXi9RYQcK0YrA==
Received: from SJ0PR13CA0127.namprd13.prod.outlook.com (2603:10b6:a03:2c6::12)
 by SA1PR12MB8117.namprd12.prod.outlook.com (2603:10b6:806:334::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:45:28 +0000
Received: from SJ5PEPF000001F0.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::5d) by SJ0PR13CA0127.outlook.office365.com
 (2603:10b6:a03:2c6::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:45:28 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F0.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:45:28 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:11 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:10 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:45:06 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 18/24] RDMA/mlx5: Validate EQE port and GSI port before indexing devr.ports[]
Date: Tue, 10 Nov 2026 15:43:14 +0200
Message-ID: <20261110134320.34408-19-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F0:EE_|SA1PR12MB8117:EE_
X-MS-Office365-Filtering-Correlation-Id: f7b27da6-be21-4234-04c3-08df3f30e1a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|82310400026|36860700016|11063799006|56012099006|261022105027099003|261021123027099003|261021135927099003|261021121427099003|261026121527099003|10067099003|261026140227099003|261028144727099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	++udqMYk6DnfVC5rXep4fuzbw71K0kHm5SmO+hhnSrXw+dtBXxQiCYWXHSeGqwHVv9AEOqwI5Hd+0DCMg/klMuXFdbTcCU4hy90ZX7xs5XK2PkvYRf9kTPGhA/DtOfgXSukaRcMWL9XoRd8ca6AIVn3dBqihp5hm6Z0nDIWdd6TttpIjp8gZL02BnJhtXC3QTiAvaVDXpI9CnB5sit7cn6w5a8cC+NlAuRqxvHslPAgZ5+rt3HA/EjZbVzWH6IoQ7xeBVcm/XSpx1cfPpz47fzrW7sHrVhgs6aW2N9cdKeNHydeEMu9pRjCOHqOwvKQWOkWiod4oG3zssXl/1s1dS4gXZmeBcRHO97TXIDnPYfrYIPXiJXHUOYJV+iNB/OeN44Kh2jTQijBtKTcqhhsyxUh7JREtQeG6eLcxlue5bo1oC5WNC/VnujKky4G4y4wRs+188VOMVKXMZ3Q+XkpXtmQBWiKJz1YQquVEw5UXXCUzaiWCJNsPZWhAgAklf3ZgjqAwDfmYBd8CbKd+AaafNxbjJLBsZzBoBA49pwuvc9JbgBNhw+mCbiw9ZS2Rq38hYIMuRBnIZBIvbrs4HlTaP94vwjOMV5NWmyr/ooYZKRvGFr63An2L1rUKpEhN2CLg6bZIAYvWlPg6n5Mh6qkHyRWp0MJ3ry0fLjk1Q/L/kzXXGMthJTtRNfQuEmrWoh+mmtkqvuk29gRNGq2YxrhJnQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(11063799006)(56012099006)(261022105027099003)(261021123027099003)(261021135927099003)(261021121427099003)(261026121527099003)(10067099003)(261026140227099003)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VLUhCdNdBDIghaXOeUx675ToGPQiyXEHLbrnjkrCTm/gA+Cb7sDxgsw79VDGwkU1No91uTrbzZXq1pFrA1IHuHcq65LAJbXlt3Ud8ardG51D/+clD42E1pWvFXoojFGPqjBBNU/4JbZoE1YCB6iC8qxBlGXaR6HKDY0RcUEfNd0QGoTp7dfvcWX2a+u5peXFUTyTMuN/lsxsO7q+3C4/oQoCbf9eTvPWNDSyK9WbKLAl25jcSMC9MfKgzUqKxDhPJcX6dTfxgLGRkFzbatztfFdffKzn/Q9gTxcfM+LF3ceWA+N0j9GmsFzj4R9nxVok6T2n53LR3zxYzJ6oJwtps5l88N6Ce6jm/MXL50ASMH0/oqhf9vJbPf7t9c2QKVoXyvKEaQ8BqVceTCWWLVzZfolk6fXjfhO2WaRUToAHdorl+cb/dWGZ5mzSIhyufq5g
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:45:28.6451
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7b27da6-be21-4234-04c3-08df3f30e1a8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8117

devr.ports[] has 2 entries, but it is indexed by port numbers taken
from the NIC, which adversarial mode does not trust.

handle_port_change() uses the EQE port before any validation, so port 0
wraps the index to UINT_MAX and a port above 2 overflows the array.
mlx5_ib_create_gsi() gets a port already checked against phys_port_cnt,
but that comes from the num_ports and num_vhca_ports FW caps, which may
report more than 2 ports.

Validate the port and bound it by ARRAY_SIZE() in both paths.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/gsi.c  |  4 ++++
 drivers/infiniband/hw/mlx5/main.c | 11 ++++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/gsi.c b/drivers/infiniband/hw/mlx5/gsi.c
index b2e2a219639d..7ce390a2820f 100644
--- a/drivers/infiniband/hw/mlx5/gsi.c
+++ b/drivers/infiniband/hw/mlx5/gsi.c
@@ -95,6 +95,10 @@ int mlx5_ib_create_gsi(struct ib_pd *pd, struct mlx5_ib_qp *mqp,
 	int num_qps = 0;
 	int ret;
 
+	if (!rdma_is_port_valid(&dev->ib_dev, port_num) ||
+	    port_num > ARRAY_SIZE(dev->devr.ports))
+		return -EINVAL;
+
 	if (mlx5_ib_deth_sqpn_cap(dev)) {
 		if (MLX5_CAP_GEN(dev->mdev,
 				 port_type) == MLX5_CAP_PORT_TYPE_IB)
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f4f2ad80e76c..808c66c7afb3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3063,6 +3063,12 @@ static int handle_port_change(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe,
 {
 	u32 port = (eqe->data.port.port >> 4) & 0xf;
 
+	if (!rdma_is_port_valid(&ibdev->ib_dev, port) ||
+	    port > ARRAY_SIZE(ibdev->devr.ports)) {
+		mlx5_ib_warn(ibdev, "warning: event on port %d\n", port);
+		return -EINVAL;
+	}
+
 	ibev->element.port_num = port;
 
 	switch (eqe->sub_type) {
@@ -3140,11 +3146,6 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 
 	ibev.device = &ibdev->ib_dev;
 
-	if (!rdma_is_port_valid(&ibdev->ib_dev, ibev.element.port_num)) {
-		mlx5_ib_warn(ibdev, "warning: event on port %d\n",  ibev.element.port_num);
-		goto out;
-	}
-
 	if (ibdev->ib_active)
 		ib_dispatch_event(&ibev);
 
-- 
2.18.1

