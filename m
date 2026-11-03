Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724126;
	b=STSctnq/6ez6NSI2Rai87W4221DSXsGlYmwGdYNNy2Fda1GAX8+z1plCiy5md+mG0maI
	 +qpGgmdcJRuyDCdpWXjsahzE1qfsioJ3KAh+ACzSIYPLtYda0Pq3cGIXn6D4EGPiAlihb
	 05RBdZKmJb4JbiF1PjyHG/VnavCf4q/xtcDIc9D1/C6y7VkXx4kSW5b0uVlowGAkY/S/o
	 NBS0ys4xfXoTd/lsOUIImlG0y30D00o4XYN2hv3EOQb8+JLnldVcpvnbbY//guULM67T5
	 ajV5VkyDmsRC1n4yZYWxO+gyNK9i1AmPDWKiRuxFYJum7JDPMI9pzAMDzsImwH1kUAw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724126;
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
	bh=OQnd9Rlj9QqimKUAKfOCmUreXfGd+LBE0uBkiyUXNwA=;
	b=PJpw+m/BsV+uVMIgO/MORvTB6LrJvH6vX5XgfHK7YtwlAcGVsevau3piDfvamatX+m92
	 /RZf3VoPbk0IHnE+ONPtg5TtRZ3eYc2BThm3JfJnRfnaAnw0LmooOuJEafQ9LJfOg3ss1
	 hCBAsW2ulQtGl1+mHMNf4aqePi8Ut01vmpAL3WKF4BE85tNbBKtuuAMkQb6rcLCkHwQO0
	 YJsCCwJn1DKzSyhkv/LwI1B4pjxUVLAgpC1Y1ZmtQdmcLPwj8DacRBX/k3YfrKULCo9NE
	 5JTwrI3mtmUiDiV3XEkflTe7QqslJlQPCjTMtVwBYsMCTj/P+RhwkcqAA5hRPdE2JFA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kKkpGoGq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.70
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010070.outbound.protection.outlook.com [40.93.198.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23E16082BC1;
	Tue,  3 Nov 2026 16:42:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C23E16082BC1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kKkpGoGq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bwv7ScZQ3TpbsCNPNQpTSciJrKOYBDQTf366HqbkRw+2cmMx/eMIR794TR8ngd/15v9KG0EEq5QNEC1PZuXWebSyXRkyupFav9UAli7fh+lGcp/irXsAgyjpw2UgoFqLVizo1fni2lEeFUHoK93W55P36lEaG5Xbil7AjSITEt/ldZvR25D+iwQOdj4GDsiEy4+MwJO8U4sflw0yKyBUB0qTmvzMD+7vzIAnb09cq2rneM9Lx2uFKHY7nQaz9cGQDctuG4Q1Iju2Wddw63U2yJv5EIGq5lopexo0hsTzFeUSn96MWDaTYK7fzSxIlLZ312GMl0ogvDrInkbedBZtXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQnd9Rlj9QqimKUAKfOCmUreXfGd+LBE0uBkiyUXNwA=;
 b=V9XkINqyqB2LOuyaH1Uss77JGUuNAjQjr1hdQOR+8fi0uNFseTlGFwq5b4cEkrAmDutozbeH3BFeesDeRs0XfF4XoLE5j9P2CzoE0Y2dd+yeSKqvc7I57t0pIzD8d/FJ/AeskSX9RmEtAdSTADGXrWsysr9dP1WWb6iejqYQwaqWQ+tjs3CFLS38XmQN56XH7Q2FI3NY+TYRGEQi6dj2712nOD7PjwP7HezWE/3ru5tvp4fWaZK3P35dhFhJSmWh2lvjMQgafGLnGZJ+uzu0NJTvRSr2uwJpPErufXQ3BNlxGGY3+Rl+7hRQdPgMuN7IrSYUsnQDlMI5Q7lDSPXOdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQnd9Rlj9QqimKUAKfOCmUreXfGd+LBE0uBkiyUXNwA=;
 b=kKkpGoGqRwN+/kMUBdEG0a83kbr5eGgaFBFuAQSkJiTHv8lrvscwNnRL4dlx7MjccSidxkmjBo64gLDGYKhpz80sGkz2jZBY319sbmtVjgidBrnADr9rMxVEWdPd4FfaR0Cu6PtpwYchSKifwI9WrdFRZPfaLtSUWKiLVSWeVZPosBFQ/9LJl1zB3tFfDO9Ab+swjQ2X+CbUJ9emjg4owX5jUbtHSw0o+VDGW1aFWx11HExd9UBUL2F93JUBWwbJwkeS0XWjvYCUvH8qP6TLByLa1u4UpVFdP7vNOFFAhZYnI9lUUZorht9HGcwy8Dd6sPrWfLWQSypn0PR5YAXlbw==
Received: from BY3PR05CA0011.namprd05.prod.outlook.com (2603:10b6:a03:254::16)
 by DS0PR12MB6631.namprd12.prod.outlook.com (2603:10b6:8:d1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:42:01 +0000
Received: from SJ1PEPF000037AA.namprd03.prod.outlook.com
 (2603:10b6:a03:254:cafe::2c) by BY3PR05CA0011.outlook.office365.com
 (2603:10b6:a03:254::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:42:01 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037AA.mail.protection.outlook.com (10.167.244.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:42:01 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:39 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:38 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:41:35 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 17/23] RDMA/mlx5: Validate EQE port and GSI port before indexing devr.ports[]
Date: Tue, 3 Nov 2026 18:39:43 +0200
Message-ID: <20261103163949.1554-18-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037AA:EE_|DS0PR12MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: db371030-f5d9-4a0f-1522-08df39c96268
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|23010399003|1800799024|10067099003|22082099003|18002099003|261102123227099003|56012099006|261026121527099003|11063799006|261021121427099003|261022105027099003|261009223027099003|261021135927099003|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	cESv1o3BwslGj1+mAZMNz2/qHj2+QMPMhh3uarNtamukpC05qTBjj7+nH19HlM/i0NAk8pebpLv0TlTV5NBwtW2cArJqmF7AVeUzlMvuviHhWQLF0QhuyEHnkX47jRYHCbElmKqa+c+WiVnrH4J17e4aYwYVeTFvBiYabyqB6woR1mVsBB3STjrJ+E98lf7j3B50zgHiN39g18QecQLMNo9L1nONg3TWe7+lPFBP3pzPsf4R66OUSgOkzOCXsZ0WlL44bLhWF26TOynHJKY8pGwDWmdCLpAkMJzAaViXOYhmRKMIXQaOcr+cM60gDzNFIXGBqjjdLCBlaWG17WuuAOOOrYjt6imqPGnWibHPqMRF+BPk88NPWCyKeR93FgnJYbU7EF3CJlpHHwm6XHzqHy4vA/aytXlMuYIyAAbZ7WjObwqLhsrpr5z4oIifzgBnENQXF8T8BbUDK1FmVDZF8ziVN4PhtDkjo+nhHdV8fzphN97SdgDjfVcGyrKVR1U1dBYCwP4LmUX9327/SeOqSK/R22+j9E9bU5ChcXoHcZy4swVmdXTpFoeZ0lmx5mUgm7/h1a9IzhUVMycgNzfZ4V1izSAvuBs2hSP7RIJ1oW6oim771aDx8mhMAx8nl9GzomO8lQKTmVpvmmn1xJyKAQDd8FUZS6HK57xjGp6Zy73QLiXZhZWtSVgAIhaxNtvkJYzgD/iSEHYW+ZS35jeKAA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(23010399003)(1800799024)(10067099003)(22082099003)(18002099003)(261102123227099003)(56012099006)(261026121527099003)(11063799006)(261021121427099003)(261022105027099003)(261009223027099003)(261021135927099003)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YTCtJW+O7pJRzwprz+K3IdwVFRPmKGFnsPiX/FRM34SXUYRUEPaNQ/fRZDBKNtFDMArQu0pg7KxQmVEcPPzuCFsTkQ4Q8vuOZm5DJX3UA8SSvCY97yATkRavsnENCVsywYxy9kn724hcuxzowYZQk1Ne40UtWiM3/R/kLG9JnK7Bq1/gmhcCH5AI35QlFTY9/3EcKK4/gkyLCPqRoMgET5WDI5A2vnlTkE0YND8LCK/Ffc1aVYpcxRY7OqRMyHwUcLSklQrp82q9JcOKGOOXovAVsrVZmNvF5o3hCykKVKqHD6HwoIkFqQ1hRucfh4S5zZiQvPQlot0uDMQE5DZULOUsnbO8dwZ/dG/TtKKMjAbuMDW+caLokMD2jKzOU3BLCt9G3Rm9pfRk4I970vuP6QwWI8bRCVFxnCQ8iHa71gug8GrN6hkIt8rrCuDmKW6T
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:42:01.1697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db371030-f5d9-4a0f-1522-08df39c96268
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037AA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6631

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
 drivers/infiniband/hw/mlx5/gsi.c  | 4 ++++
 drivers/infiniband/hw/mlx5/main.c | 4 ++++
 2 files changed, 8 insertions(+)

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
index f4f2ad80e76c..c29102260989 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3063,6 +3063,10 @@ static int handle_port_change(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe,
 {
 	u32 port = (eqe->data.port.port >> 4) & 0xf;
 
+	if (!rdma_is_port_valid(&ibdev->ib_dev, port) ||
+	    port > ARRAY_SIZE(ibdev->devr.ports))
+		return -EINVAL;
+
 	ibev->element.port_num = port;
 
 	switch (eqe->sub_type) {
-- 
2.18.1

