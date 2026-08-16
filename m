Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012009.outbound.protection.outlook.com [52.101.53.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253F613D891;
	Sun, 16 Aug 2026 06:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786862617; cv=fail; b=ATorZiitU/IZ17qMdEUT5Og5ow3VLVdMZBQBTMrD6n4Z2zE2RTfnT1QjmwqnhwVCNkv6yI9GBIpswX0mZDwIz+O8LW6w52g0NAKwjHEVN5paEPCSp7JV9vfAUEWxaYAuYX9bHyO+zpXLKxo6CMivn1ePb5Q6RYGuB4d1reCHQnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786862617; c=relaxed/simple;
	bh=P4htu1gUEDhT44U6eY0p5bi3JXKa+N6pyAcXYhmX/5s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EtqFiw/isfkZV6B9bGnuyiZyqNOZcJYtbu2OGjf4eJxa8SnVoyOXybpw1eA/rcKFEjLcZyN2GMK9GrYCJZ5Lc54dobdh+ICKdRTP03JZbHyTgcoH/eevf/LwbekI8qK02w2dxKCkyMkoqIXZT/go5szsKOm1UFMshsD9RINsHpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=daxJob02; arc=fail smtp.client-ip=52.101.53.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="daxJob02"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VYGMCUNsmWXJb+S/lakiyssVXj7C/KNKEOIzcCq6paThcoLGPvniul5tGIgIVEwyuV8IGKMqRc9nrrz4N5/Xg/i3Lq+A0X2GYdjVgbMpDVSUSXCMEjqgdM1oWQalD0CxfZNl9AMtryN4FKrDV95K1q2nPzbgF6hEo+BupMRdzySHH9Km4ILS3MRXnbOibB1YvxWjIxnQePjkdeTZcpccscA7HC57JTJhT5SEeGZO8C12aqIcAoq3vI5tmTyg7JmE0vU4hXETMmq1r+UKT8O7wafbTwahWOEf2oAbEK3kukzwUc6QNc+gaOSNYEt5MtFBY8JkMwh3/LuVjxjVAcpCrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wQ6XAIkZBiPZcTW5iW07orGvVmdAzkRfE7dhMseytq8=;
 b=hcJn5bvR1bvyKujY+3oc2aLULv7kRJ+HRu6tx0uB2SRXu7AbGQaBYLY2c/zPekHSQ1b5+dHp0aM3w4Ymja1DCM7Xxvd2StB9E7vBA/eB1yxK9tDT/iy5HFernOc7cXxgaKnt+a3np+W+KqaK5kgWkPo6tuiOHSN+rvdDyLqAbVPtEAAgmdHr/HfxjsKhjPhIDfvcINzXfaXtvxNx4zIAmzdQ9cDwcN7R3rlEECnxSEFwFau+MDfDV6ldhjiqJpkJXTB65FzS7CLQ08tEd/t49cOZfJo14rCC+E/OUoygGUhHjSxzEUdBS9Hxju78/sxmberXeU1ais0qrfUVhBm2DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQ6XAIkZBiPZcTW5iW07orGvVmdAzkRfE7dhMseytq8=;
 b=daxJob02RTKKDjGyvtrZB1Ggz6qqSCcI5ZDKo5h3ODKXmQ7swge2bMBUYMNldcxJfjtlnpdptszQXso8qHYdVAX0nUeBGMDCH8YJb1PMpqVyY4SurguJY4jM52nFlhymtfjCRsdyelv7vyG+0xjTN4lfGCBBN3nw31lKj/2MXzuiFBH6SUISQwyKU5pctVtHG5VAwOQkBl1hQ4F+YYpFyAR+tKS3Z0Q8sBCeUVu7ZzczKuyWcgA6PbtKuhSyqx6cPnMxfJVtEhCR0CGZFJbwfsMHvUu8MfbjGElvmVDmceLbChbEkXyT2rwcgSfuKuOWO/1C06yq5AiK+x4H6DpZrQ==
Received: from SJ0PR13CA0012.namprd13.prod.outlook.com (2603:10b6:a03:2c0::17)
 by DM6PR12MB4387.namprd12.prod.outlook.com (2603:10b6:5:2ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Sun, 16 Aug
 2026 06:43:29 +0000
Received: from SJ5PEPF00000207.namprd05.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::38) by SJ0PR13CA0012.outlook.office365.com
 (2603:10b6:a03:2c0::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.7 via Frontend Transport; Sun, 16
 Aug 2026 06:43:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF00000207.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Sun, 16 Aug 2026 06:43:28 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sat, 15 Aug
 2026 23:43:14 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sat, 15 Aug
 2026 23:43:14 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Sat, 15
 Aug 2026 23:43:10 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Ben Ben-Ishay <benishay@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Glenn
 Judd" <gmj@meta.com>, Khalid Manaa <khalidm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	<stable@vger.kernel.org>
Subject: [PATCH net V3 RESEND] net/mlx5e: do not HW-GRO coalesce small frames
Date: Sun, 16 Aug 2026 09:42:59 +0300
Message-ID: <20260816064259.3279548-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000207:EE_|DM6PR12MB4387:EE_
X-MS-Office365-Filtering-Correlation-Id: d400d50e-2db3-4c91-e8e7-08defb61ae44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|376014|7416014|1800799024|10067099003|11063799006|56012099006|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	LAJrKwn64fi7JT0gYG2hY6hFN9B9T/F55zTJ3qk5Q+q9UZyRD3JEaRfq8iug+EBLcJOyt2QO0XaETaXJ/MMnW66TW7Ci4BmYZdTwMdSt1rgbYTlFN9wJDpQQV1aLC4gCxBiqOqRMbXMmfzus4/6P3mj4OqocmhQvhtdu/pw30ushdJVSmx7eCCoEhOMUE0r0EKuF8uW7/e6xOdhlVMoIgFtzn1JLDuMf14QSOENPDHewRSvwGZ0Ee8MgIEP6Lq3Hb+vPq21BbisJ87PuAJtE8WbMJg+n61eU4INtlSHsLoQKNKHFddVyvTSeBoCHog7RLUPWsgc3oDjGw18pfOW+461++sGjZjxR8zsUeEVgivu2MngzLk0Wy6M8AdiOIKy0r4JUfkCK7+zeRq9sVKnnZ+/l7AJPc3fjxw4JDvgU9iDIAG7rHwNMVWduYzAk5T84qE1OPU9NT76umg4vs8TplKpluC8/+upf9w17aRq3IqdmJGrTWtKNI6I0yzlJoXbW520Tb0z1j8K4Szn6NWsv16hxbJSWTv0HRE4ql2FGiEDPQdmLfPUxgwWrjGXdm3yWPkUPzL/y9/50jqRDn4DGID1efKFjit/5SN++u0DaUw/jQrycHY7+mwHhmy0WJB6BvLe78/QJdnYlUNI56/y1Ky9NC9t7dyLWEOs2fDlIaCDm+VeRA6fEkyRlx3NalJK5t7YPBxYzl0RKgRwC5DuKFQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(376014)(7416014)(1800799024)(10067099003)(11063799006)(56012099006)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	B5EWHEZLR9AExHeBLURY6wRn3Cv0XGrGHpEiEKX/P/TE6d48gUZsTe4o7tBdrGlrHXbl1KrM1tYDrvdKsxBlcXpSQ43NshhORPIPexOJGasZwJQsypy1EHDaOtC3h+xNV4xz8Kp7xcFsHxCsODNU4OLWvL6LzemZ6QuF88dJ26DsYaqrj8ZgMkDzxuKP466pRKMMXvjLqJQl9ier02QCNVdTmTpVIhkdLzF34wS4VTsXQxgO8Ag4lgMnGIbOqFmwydgB5cpyIvRfYqFLnw5BLr9JDRl+E2jkxPKtcdldKIBkPGQ/bTI8j8i/NTfaOiWbREBimILNgEA1sZpDBQNwCa9sa+LWCLCHNq7SEZ/WunwGSunm8PImXu9csC2726f9GthMzyLjXsRag1+gzgMmixsbfND1TAzsbS1NREAQFZX8Lp1fyET1hHipBm6AepEA
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2026 06:43:28.6089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d400d50e-2db3-4c91-e8e7-08defb61ae44
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000207.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4387

From: Glenn Judd <gmj@meta.com>

When hardware GRO (SHAMPO) coalesces a small IPv4/TCP segment that was
padded up to the 60-byte minimum Ethernet frame, the trailing padding is
folded into the merged payload causing padding to be delivered
to the user as payload.

Detecting and reproducing the issue: the selftest
tools/testing/selftests/drivers/net/gro.py subtest
hw_ipv4_data_lrg_1byte sends {100, 1} expecting to receive {101}.
In current code, it receives {106} (100 + 1 payload + 5 pad) instead.

This patch avoids giving the user padding as payload by simply not
coalescing small packets (which fails the subtest; the same approach
and behavior as sw gro). This gains code simplicity at the cost of
more computation (passing an extra skb up the stack) for small packets
that could be coalesced.

The threshold is chosen as ETH_ZLEN + 2 * VLAN_HLEN. This is the largest
frame that may still contain minimum-frame padding (+ 2 VLAN tags), so
anything larger is safe to consider for coalesce. (We do not include
ETH_FCS_LEN in that threshold computation as netdev_fix_features()
drops NETIF_F_GRO_HW whenever NETIF_F_RXFCS is set, so retained FCS
can't reach this path.)

Fixes: 92552d3abd32 ("net/mlx5e: HW_GRO cqe handler implementation")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Assisted-by: Meta:internal-AI-tooling
Signed-off-by: Glenn Judd <gmj@meta.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 6fbc0441c4b8..6fc6605d2054 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2263,6 +2263,11 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 
 	data_offset = wqe_offset & (page_size - 1);
 	page_idx = wqe_offset >> rq->mpwqe.page_shift;
+	if (unlikely(cqe_bcnt <= ETH_ZLEN + 2 * VLAN_HLEN)) {
+		match = false;
+		flush = true;
+	}
+
 	if (*skb &&
 	    !(match && mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt,
 							 page_size))) {

base-commit: 24ef02f934eeb48830cff6b739abc3c62b1d107b
-- 
2.44.0

