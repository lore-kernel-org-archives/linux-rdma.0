Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795673987;
	b=wwnUrFxQ+4pBcH3X7ZWiI9u73grd03KeopVjv50zaRkb+X9Z/lQJy8NoX0rh9+jX4SS9
	 HEocNKPYM1XfONlVeZ4TexUq0bUhvwOsiNqeLkB3PygZMKViPR2PvSrARr5ZLGTnaIGXi
	 C7lETssUo82CrBRtjryO5/h3sWy9BUVxQE+u/lBHA3xdqmRquVdGmMdvVcjz32WgMrs5A
	 Yiqlfqg3/mm7uNDWydmnl9jx0CN7kzKVLiQRMGjwlI0liTscrE4KfdkDP9fMKhRYv5lvh
	 0a6FHY1shim/dJTHzlNIZgt7L0rI7X0VMVARwuzpsVBZn449snxzsnZN207QmTiKjpg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795673987;
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
	bh=iPEztNBnBEY97Hl5788iTkAXHqSPzRN4Kl2IQkYc+5Q=;
	b=ec3wQhMgTnEPUsjE2z5WWiE5jovv35h0myUy1egd+WU9ulp1VJ6d0G1ea+7xyjH6BWlb
	 Ybk0BD1uCbi0rlFfG6p/1w8j4T95ruK73EczFn9Ha9bkCkj4iBumnsGKPLQIegKaM7Dzz
	 HRE1k56R4sSbE/V0tQ3mUjZEB2qJRc3VzJnyZMGWRpwMsWnd5OxZEHDRKb2ytie25zzlh
	 a7tPyaTQ8RaR6pCGXvJe1lvjUGN4c1mYqX21xdlPeDGYVbqQzjoUqSuVXmkujRLBMp8aH
	 I20qVHSqoatJX5DGbr798CWM8RLnckokMWdcSyJQWJEoWrn/xCyPWmKnzODCFqH0trQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uUZhV2P5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.33
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012033.outbound.protection.outlook.com [52.101.53.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7070C606A31E;
	Thu, 26 Nov 2026 06:19:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7070C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uUZhV2P5
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cJWVtEWtm5rKe/+xUFcrao1hKSibgW2FXW3c8Cwim0hufKPbwKY6K4akdYMvmaMOiTNoEyt+vp1lZB0QvaNqCsdUm9gstQ4PHEhVFKvCsWwzyNhU41m6nmARbUZVkbHUAj2vURAmvydi2/JjXr3vYUvbFaKtW9FA+bsUOyIWYTGOWsHUU8E/dYNUdEwrPQT1gk+DFY+zkwKlHZV7qOl4Ho6NrNy9cd5Mqq0UNS081tvADGzAAu8ne3PtTNxcdV4smM/mEX8XTOJ7AOEopedIEwZmvfPvRql5Te23FE3CTXYQPYCKA7A3HlhDmA7aWbvcTefkJcSq/pIydH3MtgnA9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iPEztNBnBEY97Hl5788iTkAXHqSPzRN4Kl2IQkYc+5Q=;
 b=ECPSe1pwALC4z9BUSlujNMTJHCG8YjBQ/kB+8+CIoq3BV2oeW9Xe8v1RX+IYswDzakSpN/pl9NqicrtZY9NM6KUgJ2eFPEASgD4uHvCkd8++t3EPquTn+DXKiXevZRY1ZZ/X7xs1+ST5kJoyb29KkrtPLnGWyNBqNmfq4hLhxdHCDSJRDLSqex8r+U5Fox1PMm/aggUgbW9zwWWVxHo0NWAe1TV1W9tY5ltU/+PLTbBCrriALwQM/7s2+uh/7Eoc1rU5PEVoOQlqzQ9i/zth8aJHR7X07hSbKAwCykmP8DgY64AXsL1gQ1NFU1tQ3KbSgCG9XNW9ZslKHV9LRMq3jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPEztNBnBEY97Hl5788iTkAXHqSPzRN4Kl2IQkYc+5Q=;
 b=uUZhV2P5gPbVzh7Ka8if+x51AxX9ioc/Ve71iMPDQCVFD6M3TXNSQE18fSObGHxPyEHpukYD+vsdZ1L8W7wBIfMW+nk7TAeWHBYDum/cVmSFWW6UESFTmOLER5XLqI7KzvLYiwVlvzL+HqAGRtsTypJ3H4v5lwqf8rPm3MVkskUsB0D0xxaSGcB7DqHqFhcUwxceaJQuvaruI6QAVhm6FjHXQJRILJL5LU4hAcT/a+6vr6F7A18Ga7UgCO5DcOd4YKRkhelbekNb7Y30nqrxP4KdH5Blfx2xa/ItE7DgU9LUMjQNxndaqA5714UWAwYgwri3NHwkBth7bZzeqlFfFw==
Received: from SJ0PR05CA0150.namprd05.prod.outlook.com (2603:10b6:a03:33d::35)
 by MW4PR12MB7167.namprd12.prod.outlook.com (2603:10b6:303:225::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Thu, 26 Nov
 2026 06:19:40 +0000
Received: from PH7PEPF00000006.namprd04.prod.outlook.com
 (2603:10b6:a03:33d:cafe::1a) by SJ0PR05CA0150.outlook.office365.com
 (2603:10b6:a03:33d::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.6 via Frontend Transport; Thu, 26
 Nov 2026 06:19:40 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 PH7PEPF00000006.mail.protection.outlook.com (10.167.243.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Thu, 26 Nov 2026 06:19:40 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 22:19:23 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 22:19:23 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Wed, 25
 Nov 2026 22:19:19 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>, "Mark
 Bloch" <mbloch@nvidia.com>, <netdev@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, Cosmin Ratiu <cratiu@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>, Dragos Tatulea
	<dtatulea@nvidia.com>, Eric Dumazet <edumazet@kernel.org>, Gal Pressman
	<gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH mlx5-next] net/mlx5: Add PSP header extension length match field
Date: Thu, 26 Nov 2026 08:19:04 +0200
Message-ID: <20261126061904.387686-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH7PEPF00000006:EE_|MW4PR12MB7167:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f7aa514-d61b-44ae-8264-08df4b854116
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|82310400026|23010399003|56012099006|10067099003|11063799006|261102123227099003|261021121427099003|261021123027099003|261009223027099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	sKftBnEFPdHAiXdxA2StzhNZ+GGYpl5k3oIYxhRdZ6ps6v47hdhqNjHJT42sIlaeXLIg7gGnB5t7CgZmbZHTiKiXd7zVNEriiGmrug18lIFz22O0wQ4UOsKmIUGsvP6QP9wJ8sMOmb6J1QzUMPHBS3pw9Kg7INh4MZkEEQ0LheC5ePgc6ZKYooHTfF7Jbxayx8S9513kIBlDMW2U/pXVCwEbAQhgnd7WMQp/otyXkqq/W6LOehexkMpr+A4m7XNw3SculOfNl8o8xF+eLhuTDxEREi4YYY7YumoUS22uYRjHO2LpmGgGa8v0wEV/SzG8PLqtWRYv6VDexjGzKKaqo13Q8nHX8O89aD/ZaBr6jy6qrsRiUPH6EgRXLOW7Ls6hWi92jGjY77btPjSN1jfrY+pgNl+Ix7P4+iURemSqjk0Z/ARiuhZ8P/DyNu8CW1dsp8ngHWDhtDrLeKjkVK0075yn4fEZ8F9IQLeFQhCsHWq7A+HY8YjcK1EE1lXl2wYbjxy2V/kXo2oJnl9K2dXCrd4eFly3SvV98mmHGTULBg+igZT6meeKLmVfJ7HhKOLlLjAmTidpIBQACujfTDs/Z+gRiWfrrFKLm8eUeJ46z7vUQcay5p7lLmam+RbtRy5gaktfY/5MXEGLP4AaukseVwHu5UfVi8r8zmR07bYdueOyycQwbsE49oUHetRqCsaY58+aY2OvnnLjAu8PeeXJ1A==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(82310400026)(23010399003)(56012099006)(10067099003)(11063799006)(261102123227099003)(261021121427099003)(261021123027099003)(261009223027099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Dodk/UobMLHXZd3IjNDJXfw89EKxLEy97vufdcjM9dFDf6K4bZfloDu4GjcHxKf7h3Jqhf35VatkHEv9hGWP71NZwJlp4C/bm1+gRLaa6Mzvs7InCcSdLfDHJnlynbNGhM12Tr/WeGlYLzczyTSpXjNV1mRM9J2aOeTyNUL4Am7XH0GwqUo34uEyakLwZu/Fd7RWpq/c876kuxiRODdbGfH8pF8CBqZ/YiWHGxIikcv7tlOlVeU8aTAoPzfXupKEtlNIGf6b+GLdKYK6qDKD3ORgCiCt/c40qLIfT0n4bdAkOQwioBMQA5V96MbKqUJRXbChxsoJcfRmiJOfKvjTEX1Ey9rRw2YhUeAmy645kNBeTxiVp2Mt9/+BDrXAA+HYnINJThaxLjnyAw+x/8UX1ysSJ8Hx2blpy7rEBkDpFGmlntecvWDTEN2n6ajG7mkp
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 06:19:40.4253
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f7aa514-d61b-44ae-8264-08df4b854116
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH7PEPF00000006.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7167

From: Cosmin Ratiu <cratiu@nvidia.com>

Expose the PSP header extension length (hdr_ext_len), so steering rules
can match PSP packets with extension headers (such as the virt cookie).

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index cb9b8a908523..6617edfe2a30 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -800,7 +800,9 @@ struct mlx5_ifc_fte_match_set_misc5_bits {
 };
 
 struct mlx5_ifc_fte_match_set_misc6_bits {
-	u8         reserved_at_0[0x1a];
+	u8         reserved_at_0[0x8];
+	u8         psp_hdr_ext_len[0x8];
+	u8         reserved_at_10[0xa];
 	u8         psp_version[0x4];
 	u8         reserved_at_1e[0x2];
 
-- 
2.44.0

