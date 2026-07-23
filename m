Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013061.outbound.protection.outlook.com [40.93.196.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98A533EB06;
	Thu, 23 Jul 2026 07:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791744; cv=fail; b=WGypI+Z/FaSal575s5C8OVErRnWoQaBOkgMmZVc4wQKjGRlIfMlHOkb+lwFbOR+HKPsyho0FoYt3F+QFLXT6PqUh/QvYmX1Xru4FHvNRowCO+Xm744HBc5xnHVjxnyQVKu31sZZJTCL8VSUlGUu1ndkpIuB3PWNWyRQxwiiAkkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791744; c=relaxed/simple;
	bh=teb0bs53yS9Mbv4RRqYo+N7cMc1iukEG4M/OlZ5ODRc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tYHlAJ0oBsIn8+v0V7pI/4zVzD8/g8SsULzSMtgPSKuC73/0U6qq02OexTJJq0Pi9PKf1EpCclQQJ9qTfsi9GxzZEhyzRS3/CgVCp5OpdDxevvO0HKvInagMmWJeFkJZcjeOn+pQI1Qmz5hyH0jxxLm31p7Hp1qETelpksiJBgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IpNfP7en; arc=fail smtp.client-ip=40.93.196.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IpNfP7en"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XMfZ6cmnRb7BGMgLcd2QvPFsvB17CO8EMhCq3Xhlr1o389i2SFlCgdmQ+jF3iKP7/Khx/LjR+O4wZPYfV9kL2UVMU9WAgveKlJPaLII2dTrThRUEc4EVwnM2eM82whWxQqX/y548vCWG2bvjCsM2yTRwwrjMEMW88o1XS5I3CktQ0g8fGlBk4OtUXxFmZW8ATeoi3A1B177w4g1+Pvs3/BFjzwtu9lgdSHTFRDPQfiGn+Gzm9qAB+kNvdaYVx+btoY6Tn6PTg1DJwC5if0gDGriYtvqORwQux1pZPDxIO/5f26Dnl3MrAt2/Pw+teZ7z6fFd2WL4JPHhXoADimeH3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sjUxsI/NUUV93xCkVUcuZU9KkhGx0bNFTsPal45roJ4=;
 b=eXRJvtWvkv3EXjovQu6PHobkBgsRbETjNlM0vZP0bCPwnTCeHjqwdNMbx0P1/JThFVCLg+L68hQLfHp7kowGBpu8TywMA7ZUwvkZ+E9rR8ktLWbE7GMSVYcN8x+iQZQaSBzsYmcoEkFsCys6mYUg2sIi7nG7l+/8CAjKPXLw43+cUfWzzrwUf8Aq0to+MwLz/OxvcqmjQy6W9P3R/H+fIi4d+VDS6xwZnqkbTuXlN1wPmTxbnx5/GKCCWMjlBElYA60z4wnGjNgfZgJtBOx23ibIBxpcm3YRnn42vkl4KMJb7GL5V45WN7uZFQp+uXgI2pK9fzBsamaZ1Ad+LUDvFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sjUxsI/NUUV93xCkVUcuZU9KkhGx0bNFTsPal45roJ4=;
 b=IpNfP7enl0Jxy8HMu5VLQyDQi0CgmadUlNAuZcRV4K6pQWlK+hEvMhgPav812hsW+aK1YGBgm9Ig8eEnbPhju33KzY1Bj2RRSI+fivFWJQ1Ei8uuQDSdQGkXsvEhpuq5xZdJK/UVxQwmQ5r8/r68cQxbtpNQK8F5fmsyKnzUIolAnT6rVJio7EJRGLVKZtK6FIR+LrA6dBlVSgl5bG5E0LvEFrXPfb3GYEBWwEKduApw8aJ50so08EyLiNedMJp4/EmSDAhtP9SYobpeA98904N575NxjG2/r5OE5s6/5IS2xP2nm/fAMQCa+3p6dwlfIOOQ/oDh38Vp4xJT+ut9PA==
Received: from DS1PR07CA0026.namprd07.prod.outlook.com (2603:10b6:8:44d::11)
 by CH2PR12MB4039.namprd12.prod.outlook.com (2603:10b6:610:a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 07:28:57 +0000
Received: from CH3PEPF00000012.namprd21.prod.outlook.com
 (2603:10b6:8:44d:cafe::21) by DS1PR07CA0026.outlook.office365.com
 (2603:10b6:8:44d::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 07:28:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH3PEPF00000012.mail.protection.outlook.com (10.167.244.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.0 via Frontend Transport; Thu, 23 Jul 2026 07:28:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 00:28:44 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 00:28:44 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 00:28:40 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Subject: [PATCH net-next] net/mlx5e: SHAMPO, Remove dead CWR handling in GRO header update
Date: Thu, 23 Jul 2026 10:28:29 +0300
Message-ID: <20260723072829.1864366-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000012:EE_|CH2PR12MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: 33635a66-f2dc-4325-5c7b-08dee88c0e59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|376014|7416014|1800799024|13003099007|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	2rw/OfJsdHDCA0561O+ikLbGqWTRxidZjcGhbfWokIs2+5gCQvqQ5JjPAmM+Pc8gWRWckhInvrq1IXSIhcXAmE9W0/5BNLZQ6WIGf9M5bac+Kp0ezPJk0x4mWBzoQQREU958SZws37c4p0lVXfZxYYfxjwMwG+4DQ+WwWFxzuteuqpVd1poJQqK6BbhIXUVzlNpx+Ig2fIPtn+FGisESIR2KO4kXW8yN3acptaoNnN9ZM34O6gZyNWSzm+qpINp90JuFGvGh/tCqvAtpEk4IWMxw8f1CBKEKUk4OW0OP6Nw2/bfh6BYfVn3W9HzCtjw1QrTvvaEXakIjTm+CgOo/3oZV9E0S+JlBXYvnF+ttaAyVmErtDIWmSfEceFp1BPq/A+TFQh0LF80P+iwDFpw+Q8QWUZjDXhMl18OXKFpoQehCcWHigLNvJZWIbhoxYx2YibrSi+8GSv2+cmeqKGSn0RtDJrkgPNAW4O4kSyKIdpu6c1JoPQtRI6eUgsp9GD5mmBWmQnVrcl6Bj9M/1LTBDS+Wf80n8tE4btd8TVzk7MifgxgJC8TCK51dBVqz/osn2v12qH+f1dPDYwPSb0jLzxdXT/0+hA5hlIzVWOaTYAdkN1u8skxRWKSRyrSD1VASHCRZIvw0vZaYoaYu7pXMCt6itnVqTjglYVsJHfDpeTfN3sa4zs3HerJXR9thJ2d5s+8pPrD5S6A3cACKLfNLZw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(376014)(7416014)(1800799024)(13003099007)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Az3OsdH26Ye61sYxp7Xk0sGuVwgH7O7AXCAbjPGjK1UKycogHBI2YBYMd+7D/OUVOPTMsWkGYO5PyXCZERL0CykTuzhMUc6OU8koZpoPo/UdXocKxyQSfCxwnYEo/pdq8UxgQXi+MvRzIcxy16Ep83l9f+JLLlvnbHI8HjeNOw4eXtX2jOqxxgLy0MhSrS60KJavvNufVVSajIwTcrku8p50bsFsE1D644bOPLHZioIh29l+D0DoFb8Gh15YA/ft/lXWuEDEVdzM73BGArhV3skB6P1nIUMva1PFCDN4klP15mWzcpIWAPqngaceEDVFDNBO706My8vhUpglXh9W5SEN0m86fON8PIQzDqv++YmCeNtfPeVHnVuxarMMuyALd68dFrc4LEI0vYBrmG0pJTaea/v7Id+KpB2qA9FoqycRtHkN/S5LxXGy5kk4u6EG
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 07:28:56.5666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33635a66-f2dc-4325-5c7b-08dee88c0e59
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000012.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4039

From: Dragos Tatulea <dtatulea@nvidia.com>

mlx5e_shampo_update_ipv{4,6}_tcp_hdr() runs only from the
gro_count > 1 path in mlx5e_shampo_flush_skb(). HW-GRO flushes the
current session on a CWR packet and delivers it as a single-segment
skb via napi_gro_receive(), so the aggregated (gro_count > 1) skb
never carries a CWR-set TCP header.

This patch drops the unreachable branch. Discussion context:
https://lore.kernel.org/all/8b610e49-ff64-497e-8712-588b2228df02@nvidia.com/

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 04af54b704d8..fb7110b1b683 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1178,9 +1178,6 @@ static void mlx5e_shampo_update_ipv4_tcp_hdr(struct mlx5e_rq *rq, struct iphdr *
 
 	skb->csum_start = (unsigned char *)tcp - skb->head;
 	skb->csum_offset = offsetof(struct tcphdr, check);
-
-	if (tcp->cwr)
-		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ECN;
 }
 
 static void mlx5e_shampo_update_ipv6_tcp_hdr(struct mlx5e_rq *rq, struct ipv6hdr *ipv6,
@@ -1199,9 +1196,6 @@ static void mlx5e_shampo_update_ipv6_tcp_hdr(struct mlx5e_rq *rq, struct ipv6hdr
 	skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV6;
 	skb->csum_start = (unsigned char *)tcp - skb->head;
 	skb->csum_offset = offsetof(struct tcphdr, check);
-
-	if (tcp->cwr)
-		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ECN;
 }
 
 static void mlx5e_shampo_update_hdr(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe, bool match)

base-commit: 1df10cef2d1e7f9f2fb7eddb67fc70d3abf101f9
-- 
2.44.0

