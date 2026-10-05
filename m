Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012050.outbound.protection.outlook.com [40.107.200.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C8D400DF6;
	Mon,  5 Oct 2026 08:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791189693; cv=fail; b=k0ssCylwgxRJ0PRu1MaMBgXLZgcTtRPYOerNNoAzvFwOt1nOozCqF8yTV7zMviM3P9hJW6nUhu0q0ALrQuVRMQ4ZsdsiuS0FxsjXSbhpCpc/jKEzsXbpMxA0oti2XS+q6Eb1VMEUuii/JQWDmO0BLv4CIHcrxKDV2OL5+U5csOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791189693; c=relaxed/simple;
	bh=CUBJvT0ae88/WHxOv34x59tLPckTdvrpxLM9esTciV0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P2LisdGFJFAyJj0A9sMSi+7hMWJzSVx1YwXLJ8MkshSIX7eqGAh+qOtqsLBDBd/JRolvCsQQfvULeAz17RpPTFFRUkVWmLNnBIQxWiRCgGWsy2F3pPVFh0ArOK51VgFAZOhvIo745WbA3hKexWLyDwSaXmx5IYKRZ/mi9FEggxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XiIa59oA; arc=fail smtp.client-ip=40.107.200.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XiIa59oA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OjzdsliUYv4ODYh7/mVjulZjVQqNrXDpXCwwI5N0fVs4EnmDPY44xOJJyM4axIgl2Yjl8g9OSD2QA9FqseSpHQHMe7unJKhyjSCXCcMUV7r56MYVZ4JBUNGXAzqjKkoH6GnwkufqSOeVWnr29Ts7CpOrEWY56e1jLQSvgOlgeV1fF8vvL85RjtirqYt9byjP/rXduvyuts5nCBVfBwfo2InLm4dbeh4d/8BqXHqdCHdCTep7bfiz/0+5DrQKiUdEG4FMH6UkQENp6mn7bxRren8WKxRmO9YqHhrBsnhSEIbZdLp7vqbDojX+TjHZ5u3FWJucz0h1xvF26o6lxoSIeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zu5cddppdpXh9wkFmRxrB+1CtaKDC22V9fcS999CzDM=;
 b=DZYj6Ru5tDYEHMut2rOLRBgkwH5eP5O/3U0CoNX2l7/GG5J7xshtUk6IkkDlAwgNdQtDqFruT5XxGWr9Gtdw8dWWasTxi4N2QVsf4qaG95KkvT+Rr7UVxQX/JczJIyjl967X7b6n9plc2zjLXen6CO8WV1ahrECdnEdoDWpD7daM3Vq4jZM976ujkXp0KNt4fB8GWoZ4oxGcqT58gYusEV0pZwXVPOKu6DsoBuJODyLtUtd1aDxZIacf/gcW0Ply/HJYUlJz/2oO+0B1CFwp77PzMJe4z2BlWBrdFXBlAVN/nK7a21/W/TYsVnSNnwpwv69JsI0KgkQyW96lTL3nVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zu5cddppdpXh9wkFmRxrB+1CtaKDC22V9fcS999CzDM=;
 b=XiIa59oAAqSYKl5Z1eUZHSA6jttnP+saou/65Gnbker5gsjheZVKP7Od/rAOjdnxCOEeFqe1xyjYVVzDXz169yvCaowwx3TzVJo7F3B6mb11DSrxX8NziqJtITjjtVE7rYU4pwgQWpQJEMJX5ubeZXTOrw4MDGMWGzI6tsxd8pOfu7qWGlRl+/N/Ao0siFVM4+dBOnNI8CyIvxq/Yy2BLjN7oQOmiXkF6+To2/l5HiBCzJIbwIjK0sgSpwT2L6p/4D1QzqEUVL90lMhmKDelnL+fOlzMKk5cT7q7pDiTDubb3UgQ4KRpynYKqeIl4AX0K6GGTrAhhdazVVpO9eyl9A==
Received: from SJ2PR07CA0018.namprd07.prod.outlook.com (2603:10b6:a03:505::22)
 by CH3PR12MB9284.namprd12.prod.outlook.com (2603:10b6:610:1c7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Mon, 5 Oct
 2026 08:41:25 +0000
Received: from BY1PEPF0001AE19.namprd04.prod.outlook.com
 (2603:10b6:a03:505:cafe::25) by SJ2PR07CA0018.outlook.office365.com
 (2603:10b6:a03:505::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Mon, 5
 Oct 2026 08:41:25 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BY1PEPF0001AE19.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Mon, 5 Oct 2026 08:41:25 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 5 Oct
 2026 01:41:12 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 5 Oct
 2026 01:41:11 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Mon, 5 Oct
 2026 01:41:07 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>, "Mark
 Bloch" <mbloch@nvidia.com>, <netdev@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Gal Pressman
	<gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>, Nimrod Oren
	<noren@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Paolo Abeni
	<pabeni@redhat.com>, Shay Drory <shayd@nvidia.com>
Subject: [PATCH mlx5-next 2/2] net/mlx5: IFC, Add capability bits for virtual LAG
Date: Mon, 5 Oct 2026 11:40:47 +0300
Message-ID: <20261005084047.237081-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261005084047.237081-1-tariqt@nvidia.com>
References: <20261005084047.237081-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE19:EE_|CH3PR12MB9284:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ab29306-5249-4db5-5877-08df22bc70cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700016|23010399003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	v/uml/Q6cxKderRBQcgyfr5oTKXVRu2x7qHQ/i0dWXERTQ9Vy5F08/3iOnd9G9P44+AmOA+6VTWUbUS0HmFURR8fecvuoBzj43VqRrQsdXeaD24rXwofp1yYn/i8vk8r78kyCgKXzfYVDt/5JcNoKFyLFN7b1V2QW8zNRqWT9B6h7dbI0PsyVhGXgeYsMWDonUyXSpHrzWLDxyiigIwkds1Ea0DNm8XeodNY8qqr9M7cvzanxfaey/gNY6OLSSdze4OoJC5xlJZaFZBOuPuADNsv6zEVV0fI9U2DfjfhGxCbqQw+lxCLO51w3RoqLhxjW6mX5dsftkhwHuBMEUCUb5isuUY66VQCR2X3gyg5uvLqKewaCeHvN1qty/lhskGhB5bfPqybXSiR3GGInZjgNH/rjYurHShx4ZQBSvIdrWmhUMsIBD73r6oKB3iq2tWJEXaw3QkJdqF5t7S81F2ff6xuwHflNvtjbK63M6QmFPgv6xkUuTajK5gvlx0diq0UqShGWaleXDHqniCN+6cBevQuoZ3sSWmIF1bFiY1WCKNaU3WRFSimUo7SLyrRRmuft9TEIECJ4o/mfyVOkiOqQ3bpdYwX6aBgZKkAUYo5O9JCtqms3OicwYddT2QpC81/Kb1LIKlziTlx0zlZpJHgQR21q07sKNf8D6DvA9c1KjWDbrnnwgF0VTduitvc7FTuXtDPmTg/0bZbLKqOzUOr1Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700016)(23010399003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1XnjxO46lDpT51i13lwlbLm0EFI5nSc1qLnTrrK/LnZ5lRZ5RGm81Bo91Qa12y7tjUzBKoXFchljaxy20IvbrKNQIsSVKDJzao9NnkxzZSQtS+y75SOHfJPR1pIQNP0ESiKAV2wu/A9KjxEuQ+zKfbKsXZdx1RA13suzsjgT1ECMWjYnvbvxix5Ro52lk9vOP96a7wwRrfutDN+83mgW+mi6m7CI6sH+jWKokVjGDYBk5E/+WTQy4rAjJISkV/GXNeBZ+3UWJte8WWWTGETCbzaUJK208FSrt2OIrf+lCAoG6cVXptUJdRPhYFEjy8BNS3l2E5q6ApF0fQ1trRMdPgPTnZgCbFANkMK7yRgnyxOwfrzlQ40ARtK2B6OnBEB/D7HTyOJK1Edzsn0MQCjLXWCujAIAEXgujPRKj5j9cQIbZ2rk7JKLbwiziBntmU+0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 08:41:25.1072
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ab29306-5249-4db5-5877-08df22bc70cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE19.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9284

From: Shay Drory <shayd@nvidia.com>

Virtual LAG can also be built over virtual uplinks rather than physical
ports.
The support for this virtual LAG is indicated by multi_uplink_eswitch
and port_select_eswitch caps bit.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 989408764e1b..f1ee35aa884a 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -929,7 +929,7 @@ struct mlx5_ifc_flow_table_nic_cap_bits {
 struct mlx5_ifc_port_selection_cap_bits {
 	u8         reserved_at_0[0x10];
 	u8         port_select_flow_table[0x1];
-	u8         reserved_at_11[0x1];
+	u8         port_select_eswitch[0x1];
 	u8         port_select_flow_table_bypass[0x1];
 	u8         reserved_at_13[0xd];
 
@@ -2010,7 +2010,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_3b0[0x2];
 	u8         qp_latency_sensitive_disable[0x1];
 	u8         log_max_stride_sz_sq[0x5];
-	u8         reserved_at_3b8[0x3];
+	u8         reserved_at_3b8[0x1];
+	u8         multi_uplink_eswitch[0x1];
+	u8         reserved_at_3ba[0x1];
 	u8         log_min_stride_sz_sq[0x5];
 
 	u8         hairpin[0x1];
-- 
2.44.0

