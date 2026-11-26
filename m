Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795727512;
	b=wqIkr/P3N5O7khCANrB0af/pUNPXomXFi5aIdMV4JV8/rZ+dMZldw0vTr+jRCHQK4h2G
	 13Ifd0ky95kwB1OUItuDOvxmVYsvqaBpz2RaDC7+ECrd/G8NrSgMwYOhSIT57tzMra5kQ
	 nfTI85XtCAfoNldwYavkooYRV6rFXd7SrJcXViovcOqHGPA6R4d7qyf5KrIohMEeSOVIu
	 SN/VwwhKFZUYdcrVhNIFiouI7NnYJCNBYKW6CYPpxO3E35IO4/0Mt5HmBLyc0WZvokizz
	 bwq3pfWkW7kD1/VpVlT4LkmUALGlKS5PQCV0Li1oyLw9UoLNR61lq9ZTFGhJ8iJqtrg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795727512;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=iR3IU5hPGc/jxcTrQ7wAKg2WEoBeJa/lhpgJrdPBG1A=;
	b=4lZrTC+pg/fBYu+aFAUw9LHWdPwyIFNI39cu7xeZgf8UlhhJ+QirbQSG2+u0iSDJ//+Z
	 +yv7BbVohG44zVWmJJSbguBZGQV1Yfo1xG2NV3Hw8tZYcZnD0Sla3yXyyJnmWrN3l8odG
	 /LDBrxR2Ay96txTayeSZSkeDOXoKhgflduaUsMlDlijfvT1GIcNlLXc4b3vEh1d/9BK/+
	 VQfmrVMKaSmrlEQFakGslCjxf+NUBQbeW7ZPZbDZWm/aDHelk4H4gyVymHtGPner8pd70
	 iaBs+xR9EGKpyk7ZWOTrVn23rCyaNet98rEL3MvYmChwSYht+AxCU7P2ZrJ5E9hfrSA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=H2rCl6de;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.28
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011028.outbound.protection.outlook.com [52.101.52.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DCF606A321;
	Thu, 26 Nov 2026 21:11:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7DCF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=H2rCl6de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JDlxeAiuYRzgkW4IaYO8LQl8ydpaZHMoYir+cGSe3+eEdUFH9AADMQV157/W/4qG7AJWcFs4Sa0sEBYZ4wfkrtZg5JgSRCO/09hKjTdnSp3PuHIPSuhRHnnlOagbNTAqZeQAbjohmN4W/HwUqrn4+Yo5J8VV916tBHIweMZsTqN7uOnYEr3t+asdjjrr1ezQB0tkJDMl00yf3lxzzMoKfGEAKY0qLXJbWL4yt4TlF8Y5Vc7jfHciaFpyxBgdD9eoFa27mq+q1YrJModrNR77Zvuu4zA6oibzwLPF9PGAUSwD+Ua79PSzD8tkHj5X8u2tD93P9DcGzxjBM4eFMYUiXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iR3IU5hPGc/jxcTrQ7wAKg2WEoBeJa/lhpgJrdPBG1A=;
 b=bqtVGFf8kTHvJB14dXsVvsYWEu7AdczW50vCmzyRiz0HXwrzbe9Q7q2nyE3F8tsueK1DD0CZXo+DmsffPKza6ewtF4VlLgWJY8LbRebM4bJ7owHIlUYulJ7Xis5k9RhqYuxZW6fiZzEBbAg7BwsDHuBkUh3vlNlDX6Tc3NDDxnGxG+8+HEvkv1wJX2kLGYTpOD/d2u+gSDYGyLEgllADwek0bp6/WuuHJ4gObpg8pf4sjpT7jvZ0+vshx65WFMS2FmW5YwOrUmlElfvLaf2mWzCpGMztT04iJplKxzWIemQ9fS1BzdmGJXLXq7TJBG5LTd8QomBdObO9Jv91O+qcWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iR3IU5hPGc/jxcTrQ7wAKg2WEoBeJa/lhpgJrdPBG1A=;
 b=H2rCl6deIqCdoy225t4HD7prlcW4Q+KoiUrdSzHvUNudH6CpH/l27BTxvCfjQ6HUWF4SiQES6spCCR0J6wbOdo/O0Y0UBGfhGp/FRAAld0L8j8StH+d9CL7/zylv6CxU7ZPXprnN6TtbNNH9navyoTEFCwDZgAhxlX6S75zWegFZzx+EjmrTVFT7XCf1iVshl02RLRFPDAu2zORiO/j1mrd42BQrpIUwr56jMUBCpgEb4NCqV3qeZjZh0wrdvY5OdJhD1SM0PSRskD3hzD4eV5Tr+wz+Y63Qx15EKqUBfg6KxBNdurx133nLCuuqvPNHBeeyVBEKkjsY/Mnpl/1mew==
Received: from MN0P222CA0005.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:531::8)
 by IA0PR12MB7651.namprd12.prod.outlook.com (2603:10b6:208:435::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 21:11:48 +0000
Received: from IA0PEPF00000037.namprd03.prod.outlook.com
 (2603:10b6:208:531:cafe::4c) by MN0P222CA0005.outlook.office365.com
 (2603:10b6:208:531::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 21:11:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 IA0PEPF00000037.mail.protection.outlook.com (10.167.249.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Thu, 26 Nov 2026 21:11:48 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 13:11:37 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 26 Nov 2026 13:11:36 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 13:11:31 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Boris Pismenny
	<borisp@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Zahka
	<daniel.zahka@gmail.com>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: psp: Fix stack info leak in PSP device stats
Date: Thu, 26 Nov 2026 23:11:15 +0200
Message-ID: <20261126211115.767481-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PEPF00000037:EE_|IA0PR12MB7651:EE_
X-MS-Office365-Filtering-Correlation-Id: 145d2e58-71e2-4b84-2902-08df4c01e245
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|1800799024|23010399003|82310400026|10067099003|56012099006|11063799006|261026140227099003|261021121427099003|261022105027099003|261021123027099003|261028144727099003|261102123227099003|261009223027099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	u/SNe47AOiU2MB2PFeb7IKgfmAuDL2GEglbt4vfVYnUOaBK56cmJE3EGT8vYMQrEY8nOAO27B3hc3adLKDO2nBQTmFx0JDOVseX0GJFiTbLG7ucq/aTtey0jQyxSdNMLLNPBR1A8Asfnv33jDJUSuPV0o1otntZ0Q7eFRcSndJZFB0z9v7BvpzT8OaMP0jU/ptwmlEFadp50QzdT4HBc4voxq/nHhu6zV3mnWo0joRfcaz/9E9J13NzWbM70BFrN0wXZw3HM1nqw5tDTEsOa5h0eomY2M2ujYCAwL8ktLtaxqhHieA6xDMD63qumZ26cOhgNaNg1anwW7RNlhkOP7LwxNcLc4rd4icLwedkPFUeaJwENQt39ZoBQETYMqdQofKlu7AtVcUdhetsq7DDWWnjx7lGb4nvbN1coPEacxFqzO8tuIMsuDuwRjf+jT1dQxvCCpfEMg5v11dKKoarbchccMb0yIp+SK0H7468v+a835lltJX7Yin9eDN8KpG25gjjy9kTarJqqHhG3M0z5F81/SXPjG5k61iVRoMSvf9GW+gKDiVWQ/iw8P9uoAmWMJZc6dmzqr9SoOJM51QHyiCLOeirOKv+3Q0N7PtjI7AtDUdfMGsxaNCGfl2fo8bKeQAlr3j0Gl8aZF0+FOpu8hW+snTrkEhU1vQ4HGvq4BZ64qP9prVM7jG5zyZNmyEtIgJiOOzkCr+1d4QZMJ6oIUA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(1800799024)(23010399003)(82310400026)(10067099003)(56012099006)(11063799006)(261026140227099003)(261021121427099003)(261022105027099003)(261021123027099003)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jNrfEEUhzzVlTibqcRsbDa0tDKfpXBE7VUz07AwiISo6Y88J/dSGf4KA5/0++6wlvf0VEd4gVqklzlZHcc+N95SShTAjRzH1RFIaShvUaqNRqqPN4giSBw5v5e7hceS4PPPTA/W9LrIGHtmXkjiAABbq9EDNvhPleDnRa+wHPq1ndD1Os3S8U6bZ5G23aqfvg02EbkG3KvQvhBm3h9FWxuQyRrdGVgFfmsAGX5eNg+acKhOKUvs0BME6VtyFKzghp7lmcC3rxsWITjdBCo3S1v8jSAI4XkTpzftG87OZEjaaK8f53v3SzkLuSPb/28N0Cl2MvNeeu2fkDfR0k3sT7ZKXYu6CHxdRE0SZxWBfoiKf2ezh1dhCVlZ/370bkXotEvePSCiAXOhvxNeK//zDtiZOFUniF9AQIjvegtA8HZ71w6GvB7o44zAg4ayWXK+y
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 21:11:48.2799
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 145d2e58-71e2-4b84-2902-08df4c01e245
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF00000037.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7651

mlx5e_psp_get_stats() reads the PSP flow counters into an uninitialized
on-stack struct. mlx5e_accel_psp_fs_get_stats_fill() ignores the
mlx5_fc_query() return value, and a failed query, e.g. -ENOLINK when the
device is in internal error state, leaves the counter fields unset. The
uninitialized stack values are then reported to user space through the
PSP get-stats netlink command.

Zero-initialize the struct, so the counters of a failed query read 0.

Fixes: b1346219e535 ("net/mlx5e: Add PSP stats support for Rx/Tx flows")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
index 73b232379263..4aacb4173b1b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
@@ -995,7 +995,7 @@ static void
 mlx5e_psp_get_stats(struct psp_dev *psd, struct psp_dev_stats *stats)
 {
 	struct mlx5e_priv *priv = netdev_priv(psd->main_netdev);
-	struct mlx5e_psp_stats nstats;
+	struct mlx5e_psp_stats nstats = {};
 
 	mlx5e_accel_psp_fs_get_stats_fill(priv, &nstats);
 	stats->rx_packets = nstats.psp_rx_pkts;

base-commit: e1055cbfd6eb578417f3ce983cf44462e8465267
-- 
2.44.0

