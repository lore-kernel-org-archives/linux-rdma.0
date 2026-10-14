Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011026.outbound.protection.outlook.com [52.101.57.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E4F4E0B74;
	Wed, 14 Oct 2026 12:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982113; cv=fail; b=iSUE8FDZ4NFw+iTNTw5l1K19j/fwkVHfMG/lqkNrHSRcgBjpfdwM54f3Xbh9zlS6AWRj14mIrcCvQTPkEfGn0hU56dUKBK9EpnrzXt4ahL7aJ9AgfrHFPyJCWnnAN02WNVeRNpHCrR6FnsUHhcr8ziXKV1ad/NbFqLKWgYy/T68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982113; c=relaxed/simple;
	bh=g8Nt3XdRIcGMiR9KGIknlyXw7xQH8O5JSu7JSVpsKD4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Aa0+hxS+tB1loe0/3Li+RkTQGPdqMkGKQ2g9ivhNhddZ2II2f1FF1dSxDS5IGwTZo4MjU9QhqcBM10DDOa4OXYtdR6h4Luk0HHiYltwQ30cMxSnvFqL2OGWdgL+08xZR7vN5kbSJoFQtftA+OokITCBimcB9m01rltmG7+YuVSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m7lgXlh5; arc=fail smtp.client-ip=52.101.57.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m7lgXlh5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xqAXL/mixZcI7DJav3kwrPZy5vlcrnrW9IDhQHrcav2Z2+hlcvI+EzmUCoeURUokas6Xr+4qbQiB+fJAh0u/fk/TDc+GiM2YCni9coUdHNd7ErJ/WOCZGoza4g715YJJgCr6gSPLMrrBkr38/CZPk9u82SMxxA1MT0LO9IrwsqUHCxuJUMdbSKb6l1OIUXjJWMV6v+TlPwFttx8xOAXQb7M1SfV05LW77Nr/Wim5O8+IywDW/5OkrqwmyZPx7p1hvTjbVcI7bYiWPQjjuh3vz2P6/Dto4Qawc4T2WedWD2s816jbaOuPYdufHSZIktl9jYFcKtotdyGupvabi54Eqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1BYtWtbMqRmRcubqiTLSwHBoKYTvYoHAXXRN8URWbI0=;
 b=b/zX9Afmvx3c0JjpY+lVCrD1vDiTTa4zSoEzt1dQu7fwgil3ovaXZHpbgfUdHRlFgs5H1KafBIs9o7ZN8mKiwne/Jt+VrC1uljkGnAJIH4ntVS/ciIFglsQWdYwIvqFwMf2JONgdbAf2KOtcVnxZpToaDaMv6i5Ya2Rw9jotWNEq05t7GCoMctta2Fa06PUMALjxpJ/Y0OOJhgcP81bbFSa7+OulKACClBmEvsAoSjnNOuTac3S1HcMU0tGzVSIPsEVM3jSXiN/RT6T6Y98sepswqBlQwBVCFVF7NwabUYKHHkEXbZ13Q+HpQKSoN652o6k/odKPJ55irB9apI/BrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1BYtWtbMqRmRcubqiTLSwHBoKYTvYoHAXXRN8URWbI0=;
 b=m7lgXlh5RDbEzxgLUtejKkEDtO3Akg7R8BsIZ9xalDIxY5JeGsVo1+kcQf0GQCQV5Y84ql+wpMtnCtGRuC3EMF62zVxi/OCFU2EG1mNCWjE1Kl05NIPZdCxq6DlAuiAoXOdJ7tODMzOC7F/vPvoWoA+TR7S4efK47GLLJQ9FzCJ6vg8s44tmCzK5tZ3rCZZAHe0YgYJIxdvNhvwSO3Pwk67nd33wRQB6yMuuWuKYH+iv8sBAgfn+rBiM6wNNUvJWP7phKT+w7uBy5QvRmvbmCNr83Y4JFlJPQE/+UvzOQYBEXg58dF6Mfo5reVZLgM3E8CX+ylqsksahHj+z4//jXw==
Received: from PH8P221CA0066.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:349::6)
 by AT6PR12MB925810.namprd12.prod.outlook.com (2603:10b6:170:111::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 12:48:02 +0000
Received: from PH3PEPF00059618.namprd05.prod.outlook.com
 (2603:10b6:510:349:cafe::95) by PH8P221CA0066.outlook.office365.com
 (2603:10b6:510:349::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Wed, 14
 Oct 2026 12:48:02 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 PH3PEPF00059618.mail.protection.outlook.com (10.167.243.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Wed, 14 Oct 2026 12:48:01 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 14 Oct
 2026 05:47:42 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 05:47:41 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Wed, 14 Oct 2026 05:47:37 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Joe
 Damato" <joe@dama.to>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, "Nabil S. Alramli" <dev@nalramli.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Yael Chemla <ychemla@nvidia.com>
Subject: [PATCH net 0/3] net/mlx5e: Fix CQE moderation mode reporting and control
Date: Wed, 14 Oct 2026 15:47:01 +0300
Message-ID: <20261014124704.1017782-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH3PEPF00059618:EE_|AT6PR12MB925810:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b9c8269-dd35-449a-6bee-08df29f16206
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|7416014|1800799024|376014|6133799003|18002099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	iStPPE1j49nsOcbR0p46G9eQTUfmQKdmNt6QQjNNhQH1M1uxNGkjBI0H27UuIpNydS7gQ+um/sXp7IAh4Y3rAJbp4ramhm0tIKCTfO20DKox05RinIHDlqx6dvlLOuWxxLlvHSs4Ftr7OfH3HLN3Yb4By+RTnBVFgxYom8dQ+yt1p69OKuTf4Z5OUFCqUf1bm4af1G5Vcr6ZhaQ9NErnHHZtDTdqZFJ8IoQpiJZxgLSBkpVVc9dmsgJDqcRtsrez46EdbwWD3DN5VUf1w/Ol5APAntGUKLOLRUxktN7FJWRVpN6iOeVKU3mkbSsqlIOmQLMWqtttN0zU5Hv8wAZGRuOeKeYx/+FWFOS4Z+/I5wfv0XqC0pRtALtASUB0AliB9bEKGAgSePqjrERTGR7uwpaTiww7yuWO92uOMLfn4aKA5Kfj+mD/7KogllEKr/eJD8xdT/PP3YL40TfuvkzIHv662pZt09FXji7WbeGJ3AV2CjSkZkzZeHBEC3bHiDzie+jsiEUpM8UkUHauxqM0HceG6Lpm0MuS6XvNcxD+X/excGkzabHvYuv6ZYZ6ACTL7feyXlT6aWvWfYnbVO86HmubxYwsM6x7uRuRyKTNoA3gJq/hIxV1G2P2QmV6WiyVKjsoJMvQ5dEnRRNuFZ9MfqrQ14S4kTDORVzi443Bh7UeHbS2m6yU7zKBa1IIw7lAQWfE0dtPJ/bopnPlOx2BiA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(7416014)(1800799024)(376014)(6133799003)(18002099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yUs8AWlCBST+SwuHF2vw1T65G6dWrFQM0fHt4iaGalebvkrkBA6lY3QZhG6GpmOu0y/jgALWDWijO7EPyk7HoYH6H8DdytFFnEHzl7fN0si/+1xXl0K2BOYR0Vj5fFdn/aUaWLLPHt/x1wMlF3wVwiHCl4oMo66mrzutG6NHWkyKqld/+OFxriVNSzWANPIe2OgK4SppMDo6C21pXPwZHPtVzSYlnxqZwK5n9v1nkTm5lG0WYly6CywdIImg6DYv0rBpcDqJ6oBWfOmzVWRASOuw/Tvg46gttlsGWeIap6thPK40M42K/sgGUGPQTTzwkrI7fugkM4EbE314TadH0Re8D9O9Uf20RIfRYJdZCM5S3rvez8IInSFWYi1XpWTSknQHRPFrXnIuO3N9FzKbJV86Wyk+9X4wD72t6bP7k5ZbUKHS3NK1cwHpkvJOk80v
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:48:01.7452
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b9c8269-dd35-449a-6bee-08df29f16206
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH3PEPF00059618.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AT6PR12MB925810

Hi,

This series by Yael fixes inconsistencies in how mlx5e reports and
configures the CQE moderation mode through ethtool.

mlx5e_params keeps two representations of CQE moderation: the private
flags (MLX5E_PFLAG_RX_CQE_BASED_MODER, MLX5E_PFLAG_TX_CQE_BASED_MODER)
and the fields rx_moder_use_cqe_mode / tx_moder_use_cqe_mode. Ethtool
get/set coalesce uses the fields, while the priv-flags path uses the
pflags. When the two disagree, the reported CQE moderation state is
wrong. In addition, commit bc541621f8ba ("net/mlx5e: Support ethtool cq
mode") added ETHTOOL_COALESCE_USE_CQE to the NIC ethtool ops but not to
the representor ones.

Patch 1 syncs the pflags with the capability-derived fields in
mlx5e_build_nic_params(), so that after channel attach or reopen the
private flags no longer remain zero while the fields reflect the
hardware configuration.

Patch 2 fixes the opposite direction. set_pflag_cqe_based_moder() now
also updates rx_moder_use_cqe_mode / tx_moder_use_cqe_mode, and resets
the RX/TX CQ moderation to the defaults of the new period mode, so that
ethtool -c no longer reports a stale CQE mode or stale rx-usecs after
toggling the priv flag.

Patch 3 adds ETHTOOL_COALESCE_USE_CQE to mlx5e_rep_ethtool_ops, so that
setting cqe-mode-rx/tx on a representor is no longer rejected with
EINVAL.

Regards,
Tariq

Yael Chemla (3):
  net/mlx5e: Sync CQE moderation pflags with coalesce params
  net/mlx5e: Sync CQE moderation params with pflags in
    set_pflag_cqe_based_moder
  net/mlx5e: Expose CQE moderation mode on representors

 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 8 ++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c     | 3 ++-
 3 files changed, 14 insertions(+), 1 deletion(-)


base-commit: af32da41b0327b9c6a37856ba82b6760d6c8d10e
-- 
2.44.0

