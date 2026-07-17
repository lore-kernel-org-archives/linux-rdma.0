Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011038.outbound.protection.outlook.com [40.107.208.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45808384242;
	Fri, 17 Jul 2026 07:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784273177; cv=fail; b=ci4VqVZufE+uCbF2rcUAi+SEQ/x228LlG16kVNllFtqNfx6BKtV/ZhjmfWCI01Vj0VvLMMkXOcfinoVuDmwRtjtu/dU48NoxSDSrteBCKTJ2McbIJ/oaLm0JhA50dk/vhSI3wcd11znu0MMY5kfKKNPgZ8UNmF3ueF9M1vv89pA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784273177; c=relaxed/simple;
	bh=l6+LdZitRyzcr/60pIJSskgYvRlw6hGaIBXUIm5hlMY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qUu/a+KR1Km/RWGfKqT/3bJy9m2raVYGSubSW5i3QokYW83klPsebbYioBo9Zr9ug2/1LDfSbl3PV6iBRtSFmmZQloZl9XdXPrgqWNRBBt0FulSfFk6uAVv0cjY6xg4C1hE/w1GjtxtnEAIP9W82pq42U0w7L/z0Wq+9d+EZa2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fMpHzhFy; arc=fail smtp.client-ip=40.107.208.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fMpHzhFy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pdtlm9zni94YgQf29bXh0zBPBbg4MKu4Mq/TslQj72FS5p0NPDIA1pPy1eTOwRqHSJRzQSTXhQE46NWIOU8aeQY3XBwHDZ/CTH+ET2jdXQH0IclSv4+cTzd6zCUwbyYIRylC+FmO2ELSa2kG5XAmn6B4weHI+IEegO1aLJ+jzwNFYIxbMcxZrEKtsVwo/fD6+HmCA1omwxSShg9O1FVZGwIcsNg6pMoBRa6Tvm1KqG1jI3eVfGhwckYWMpzcXZziwzwMyeib1RD5Wv1rgX1EuY5F81oh1bs9I1tG/Y1QJV13EVOEiSjignfUPhVzET1Q9CyPHtUVVL3yxPppw19WDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3sFaiZREPO/BWL/2RI8dALv43+/vn1l8G5eIS3HYc8=;
 b=o3kJNcCYvqfsNW0XOj3p8ZDrppDCgPOW7y+bHpjAb5cIit2emtixt2Z5QBFzuQP1Bg5KfbZXLvQZ/ni8wflI3A024SM6RsEfjwg9TDlKsBRK/OklN2qwSv4G6PLTHD1ALAQeG3OD6Q/VsBWbfuUdEzoqm+mqrfYl88NLEFXOtzuTrz63/erqt/E9wmM+En0PsOJTNS9mTB1da1y4XhpZahAWU8SGyl9a9kM7NQ8in6D54q93fSc2IuzhZEnznsmDigvWePLWH20L6qypzFktsvtrF66xQeD4TLeQDmic9nR6b6f8s3ezRkUv9GDLsQPwHEBGIgO5ytA4k1F5ra1Aig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3sFaiZREPO/BWL/2RI8dALv43+/vn1l8G5eIS3HYc8=;
 b=fMpHzhFyKxU9BWJ9YenGOXLNCDGCvkOBApswITju2u4Gg6GdBa9UrrLitPRajyvuPC0Jta3mrcxls2WlyS/2Wyh0s6tEZqAynjjPwwRuGTYRRlUlcJ9jjIfQQyFNWBCtgtsVSSjxLU6YcW+j1u42+iwmD+xgjHbJmRqdczEQFX1gbJXdYUq+PkaImzskuAF7AYwsEeec1yGv8NjBlkOIU5VXd2pBRvcF+9IRA8D86Z4TKv+6CPo24ULUuS3qGb61W9GuieY/50NayZTFGMuUJXirOyAxTudX3E8F/UZwjSmfvE0aof7sN+XvWS/jSorLGJ+r8v4gvxYXrYmcpAE0iw==
Received: from DS7PR05CA0069.namprd05.prod.outlook.com (2603:10b6:8:57::21) by
 LV2PR12MB5920.namprd12.prod.outlook.com (2603:10b6:408:172::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 07:26:12 +0000
Received: from DS1PEPF00017095.namprd03.prod.outlook.com
 (2603:10b6:8:57:cafe::8d) by DS7PR05CA0069.outlook.office365.com
 (2603:10b6:8:57::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.6 via Frontend Transport; Fri, 17
 Jul 2026 07:26:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS1PEPF00017095.mail.protection.outlook.com (10.167.17.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Fri, 17 Jul 2026 07:26:11 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 17 Jul
 2026 00:25:57 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 17 Jul 2026 00:25:56 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Fri, 17 Jul 2026 00:25:52 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Kees Cook <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5: FW tracer, clamp firmware-reported num_string_db
Date: Fri, 17 Jul 2026 10:25:43 +0300
Message-ID: <20260717072543.1241094-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017095:EE_|LV2PR12MB5920:EE_
X-MS-Office365-Filtering-Correlation-Id: 899c1e7d-9510-428b-2f0a-08dee3d4ad68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|376014|82310400026|7416014|56012099006|11063799006|10067099003|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	eIDSTNACit2w8VaaNbSW9RpBreUj00lxPm+1V7w52LD8i/MK++2UVnLoYhVLIOVmsUgXsimx6prcwTum73nFQvXLvqx4wkHF1+I8+lvn/cqqOILztuJ5QJqbtY8x22qkPoFQ0agfliZHesZ6cUZ+tl4axg9rtK1YHbvSXL5D8/AH6ZRRhheT7J4wICYPg5DSE+sYXLjkIvdi8QreWUGxPJgJOc6i/Yzc9YJVUvP7wr2mUwwupBPIl1J3DIY8oMD7scA5E8V3AEsPQ1fYXLEBhDqyuFbB5ygdIBehDugXS+b9jTt5OlMoCrbriuSASFiyz/8codHqIux4AHaQJBjw154J/4iUoiZp08UkUyxKg86qf/VnbFA8q9rg1TsE8lUwoIO5FOEX5CqTqTXioLmLNEQlC9KzSQvnVYoB2/EXS5myKNGdik7MbqGgzvaGKTu7NADsX+avbooJpUZ3TJxqg7gYTikD6onHqDpr4VOJbOEEleYnDatGpYX1zRZHsLnJ8ioxiTNkEVKZ5/m7jd1WVquuBKH2Ol7Jj+nuwNwGsiJeG8dq7YDbLuXZJonoTmmhBr/iYNy6t7vL6AJVcdKCoWNnGpkS5y5FFXDxnat3kZvdyRCEf/POcYCcq8Yj8BY07PR+t/68qWjkvkbofTJoY6aYzzG/rIXfGNKmn2MZv1Dogh77JyazYLHi3F2T5apBpXN6aPq4cEQF9lkLMKwzTw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(376014)(82310400026)(7416014)(56012099006)(11063799006)(10067099003)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sJjcQ1ZDj6g+D+1X0+XdyVqR116JW4Lzgnc+ikOwKRGOApLMRt+/zt7ltA6zKUvNX0AtU4jupZgIe4XzSXzGXFuntNkGw1ca2a4JcwiX+w+zf4myq2YhYuU/rylfFmXP2QoJZpGH+UJKb5BKXNnYw165JCumfp8493W7cZhvtYmTN6VYkEyYcsTUmOaZ+r2pPxfo1pTIRZLpwpniWCIaIfk88/SGE8k5Y8VDdGX+vZrsb1SAEbj8EvyknZa56es9NdT/n2pgvzCIsmB/XmNrUH3GwftDqj5IaFM82jh6a59KHoLbFeaxw2dFGjg/I1g9v8jkBuA4xW6bJWZYpjazRSaSHcF3YkmGdkCKlPr1Xy4tbBCjsfa6a1a0jhmu6NsPAQho0ZT0ykIigTO2DyblxOJ2TkA3skYYIQtRiY+VjSy7+fpl2OvqetERocOLevId
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 07:26:11.3568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 899c1e7d-9510-428b-2f0a-08dee3d4ad68
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017095.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5920

From: Akiva Goldberger <agoldberger@nvidia.com>

mlx5_query_mtrc_caps() reads num_string_db from the MTRC capabilities
register and uses it directly as a loop bound to populate the fixed-size
base_address_out[STRINGS_DB_SECTIONS_NUM] and
size_out[STRINGS_DB_SECTIONS_NUM] arrays in the tracer's str_db
structure (STRINGS_DB_SECTIONS_NUM == 8).

The field is 4 bits wide, so firmware can report up to 15. A value
greater than STRINGS_DB_SECTIONS_NUM makes the loop write past the end
of those arrays, corrupting adjacent fields of the fw_tracer structure
on the kernel heap. Clamp the firmware-reported value before it is used.

Fixes: f53aaa31cce7 ("net/mlx5: FW tracer, implement tracer logic")
Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index adcc73e2a5b3..404736c46adf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -64,6 +64,13 @@ static int mlx5_query_mtrc_caps(struct mlx5_fw_tracer *tracer)
 	tracer->str_db.num_string_trace =
 			MLX5_GET(mtrc_cap, out, num_string_trace);
 	tracer->str_db.num_string_db = MLX5_GET(mtrc_cap, out, num_string_db);
+	if (tracer->str_db.num_string_db > STRINGS_DB_SECTIONS_NUM) {
+		mlx5_core_warn(dev,
+			       "FWTracer: Firmware reports num_string_db (%u) > (%u), clamping\n",
+			       tracer->str_db.num_string_db,
+			       STRINGS_DB_SECTIONS_NUM);
+		tracer->str_db.num_string_db = STRINGS_DB_SECTIONS_NUM;
+	}
 	tracer->owner = !!MLX5_GET(mtrc_cap, out, trace_owner);
 	tracer->str_db.loaded = false;
 

base-commit: 3f1f755366687d051174739fb99f7d560202f60b
-- 
2.44.0

