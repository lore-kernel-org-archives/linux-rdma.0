Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013023.outbound.protection.outlook.com [40.93.196.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923B6490C1F;
	Thu, 15 Oct 2026 08:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792051418; cv=fail; b=EnpQ/5e7Lqn6Ht1Z42pwP33zpkPYhnTUIPF0tdo8zddrIrR9vOdbKuZQRZFaxPGH+9IR8E5lJqZ2duyQPB+iGxLZM2l/+eRSwUuMGYd1PH4o6ySROwC4yOx8FYl8HMVH8yQoWiyq38Lf4kWTeoMs8CEUKEJ3yDF8u7LulaF+LkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792051418; c=relaxed/simple;
	bh=OqgAWu8yx+sJwNWuWsYPVkAokGZBFOmw3+txLlppvNI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fkNJGFZXe9WOagdHyKSaFf7OSQ6/bmbw/O6kpPLWCGbpkzMOzkcDOxC6clj8eF/ry20fNFLrto2+ZiAi3qYpg/324q4yUyiHectX95+vAzq5M9RELltNQjZkGZq6DwNXP3dzppnhfgB0SPkGrFWC0E0bAmyYajRCAa3bCjU0Jzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DXwPT5re; arc=fail smtp.client-ip=40.93.196.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DXwPT5re"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t8Bp1a1NCPdTokI83gsyy38ZgPrK8Ui1+AlJjeClCl9xtJw0FcKfThKEwHpQlZZBcC9HNfzjXtAmLE1U+rliaE6KsJDFdUoygz7Z1hp5hQ/ZMKuAxTUj3ZolsopaLI3qKOLp64U583ygkeMMfNiM0/OeC3sttfrbJAIettXgPCq708jsFLW5LyuyVvLhDJeCKJUbMfVup42Ylku1PbYI00OLxOcYE/f/DO26MkEt1OvIiChXw3wPhDsODiBHrP3nF58RqauCREzPgXd13sCbkchwEr9eZAMXlG/6A7/2w+99U5IAMbP2cZhPF1b8QtScyOCgOdpaD3vQhnTavL/mOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VJdSM+aeIIAit74RAADM3DSNJ6zLFkGKmyMkcQo6ptg=;
 b=vjDNE586ufaAwJQEnX37b2oUPVzYNmRIg+ch4HVVKl05f9h3ZAiGereBwC4wSNyBuIWRmpHQeDyoyjILramYlT6oyLvGVre47nEGiHSs+ymfpO69oDSYQegS7zaYHZ0DGRYSgfLFyMCc8n1i6LEoUGj1OZqQNgite3dgmi84pBjVFp6/uymJhI7TOxO2eS1U23CY6DyGOlhgUe9e6QTKvj/UcA2/H7w9Ka3LInyo/KGEwBks3rp0uvcAVge7laQBoJv5la3N7efuTGvf6mJ5EtdHtLdFwWSH8qSGrUCRiHSCZQZb0Kj0nlUhqRPknpH9+kHcSZ06sKQKAqKdKgOP6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJdSM+aeIIAit74RAADM3DSNJ6zLFkGKmyMkcQo6ptg=;
 b=DXwPT5reW+ge4iE3Nt5QeswShbQGhOOrdKiYMi79a8Rl0EE59QPKi7P1p7OOSdR4d0V2svqB5MQFKLi2DbZ12czAKQn62OL01CaQYiDTb5gldHIPy293QDOTsM+RMzFRYVtBkcZrx/7r4WhPjRbNdTI6yHpSsfHTAYS6Ru1pMAV891UuKLldZ9YUKDOOiHnMGDLqLMwS+cptYjdd7E2mKBvE7KeR/cBMJaW4sjh6x6TiAkTLX2L1mktP3Oa9PCPvlIOq5Up1x7iGX8FEqK5gJM4UqDJ+gRTtyvHGBGmbzTLGKitw1xZY/Lrv8bk0yA/RW9Kl09qhG7F8GfRJT49kUA==
Received: from PH8P221CA0032.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:346::12)
 by SN7PR12MB6691.namprd12.prod.outlook.com (2603:10b6:806:271::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.24; Thu, 15 Oct
 2026 08:03:31 +0000
Received: from CY4PEPF000392DA.namprd03.prod.outlook.com
 (2603:10b6:510:346:cafe::a4) by PH8P221CA0032.outlook.office365.com
 (2603:10b6:510:346::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Thu,
 15 Oct 2026 08:03:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF000392DA.mail.protection.outlook.com (10.167.247.120) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 15 Oct 2026 08:03:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 15 Oct
 2026 01:03:11 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 15 Oct
 2026 01:03:10 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 15
 Oct 2026 01:03:05 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alex Lazar <alazar@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Richard Cochran
	<richardcochran@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>, "Shahar
 Shitrit" <shshitrit@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: Fix NULL deref in PTP TX timestamp recovery warn
Date: Thu, 15 Oct 2026 11:02:18 +0300
Message-ID: <20261015080218.1102172-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: CY4PEPF000392DA:EE_|SN7PR12MB6691:EE_
X-MS-Office365-Filtering-Correlation-Id: ebe9ed77-a1a1-476f-d0e7-08df2a92cd4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|376014|7416014|10067099003|18002099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	vqSTPE48J4pbZncrvPh+wy731s//Tx0NaDB/WMRnFIw41S40cbjE8NLKBDFoPtwltPMDGYuopRroabROWNRwmTqxAxyyTMRK9p+aWFKfMiLs+ZqSuP5UirvQf2G3iDd/g55iTpl9S9+oCT0lGdHkmIPOX/67Z/wEdrMxIAS9ptvp64Nh5km3aIIh6sFWFkdWbE7iaYIY+g8FCxXp9bgxE+oH6plkDS4+uLM1vXWGwzgCnr4eyZMGlegPoYCC7ApSm5iOEkeQ5FHG2Yqqa1epZ0Twl5WLEa8nn7doRmM1WRpqgEfia6gdJWe6KYjFh4P57btAnkzj8slPi/dxHTb3wEGH/af2bmM5jD1MJ25wZcQzxNMiL/YQ4TdZfk+BwKljJiAA4VaXvE8rttEuKpiNYdgrNBO/HW8wqYM9PQyXXmUssFctwn3hvHmlioInHkkIbvNr4I3bpeN8SgaTM8HBJuWx26TkRb+nFSf91LDQe0Yil6Qh9nKOAX7wsU0eRPeRfG+JLdPJg/08DGd7MDMAuQXEl/gxaPIp4aqb3yQXViq7hq+OEw+A5N4psgeiRUZSmmaT9tP0i7F+FS8oPYjkhhDu5TLTDcIOFYfTcUnDvbLQRtC+l2k53xw2BUuRCb+9sbFxlePtdaiudR10FuIPG4+75Yr8JmJmL4jzInSsFM8HGUsuB2LBE5lqZxkxlt2FznrKKbPFCGEI1EbQymDBdw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(376014)(7416014)(10067099003)(18002099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zfPZW9NB1W16ZBKqTC4aYweDFZvxKKwQUY/J/TpoM6UEDcEWuHP2IZ8y019WeC5LwQp5kXd/70xEIDyriWfVwhy3fx1kitYnfodgHKC8yr8v7mHwmj+E/yOBMTmPFVm569Kc3MGsFmW7GO3yHY/phTdX/aH8ZEsERGccxNYGxfmsdrueZ2nD/z2VWc/FI+0zNkfo5ygcJnBqqpFiiPjUZleCW52633fTZlJTsUNkuSZHQ5mdCnd8kJ04Fa/pguperBgFklkzI6OAcDysEFfgf0vJpMW1HEPsC6U8kRiloTkWDFOWsmmjjqddk+YaJ3Yigpn1f7FFTB5KjFzWkv27tZ5KZ+bBOCxEALTgC7MBTC0THpcIVlBHUkjt2c3t+Je1HjLjoSMKRpygiaJ6GTuXUAZ/NC/YpjSRmMh+ULMUCGtGPhyYWbXvjE6uuvolARWX
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 08:03:30.6509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebe9ed77-a1a1-476f-d0e7-08df2a92cd4d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392DA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6691

From: Carolina Jubran <cjubran@nvidia.com>

PTP SQs are allocated via mlx5e_ptp_alloc_txqsq(), which never sets
sq->channel. The excessive port timestamp delta recovery path
incorrectly used sq->channel->netdev for netdev_warn(), causing a NULL
pointer dereference. Use sq->netdev instead.

Fixes: 391dad2e686f ("net/mlx5e: Recover SQ on excessive PTP TX timestamp delta")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Alex Lazar <alazar@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 723f66a6bd63..2e1c3bb5a959 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -98,7 +98,7 @@ static void mlx5e_skb_cb_hwtstamp_tx(struct sk_buff *skb,
 		ptpsq->cq_stats->abort_abs_diff_ns += diff;
 		if (diff > (NSEC_PER_SEC >> 1) &&
 		    !test_and_set_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state)) {
-			netdev_warn(sq->channel->netdev,
+			netdev_warn(sq->netdev,
 				    "PTP TX timestamp difference between CQE and port exceeds threshold: %lld ns, recovering SQ %u\n",
 				    (s64)diff, sq->sqn);
 			queue_work(sq->priv->wq, &ptpsq->report_unhealthy_work);

base-commit: 513444cc62e231a11c9b15ea88de0890da9b2b4f
-- 
2.44.0

