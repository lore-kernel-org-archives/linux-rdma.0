Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010056.outbound.protection.outlook.com [52.101.193.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41081370ADF;
	Tue,  6 Oct 2026 10:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791284357; cv=fail; b=gzyKldwWuuyz+/nK1oK5Z9hT7g90iWtNr7yKhRmXPYsNyj0BbplXNzuLgxB9sKJ9r5aMxAvcc9ljNfiUBqzWYmbZSRGbFEfFXWGZi/9Eeoy+8ETwV80rO/PGpHM2aiS8kscD3BtKfylMNwldaBGbiVHRaNC68uY/14WHiCyj/TI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791284357; c=relaxed/simple;
	bh=jvJ1N5FaQMyNkkEIPOVSh4vM+aMw+CdUHEN1ZdjtFZE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UqYFCkSanwTiT2XbofvUihBGzB6NqePUYyYrpaL7QMSdncaLkVl2VOqgxewkz8fws1/HuPHib/02+pZoD5A4lbUv+h/kP8xDYscw/AojLtiG7qlvZENE7kHudGt8Ove8tc6ezE5qho661w670QZjVRkNBFElVAkUE5CiDhF3dE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IaydvFNl; arc=fail smtp.client-ip=52.101.193.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IaydvFNl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oD7SoWUZtuJ/iyrqczDxR83acpl9xrG2NByQIWg7fAiYFWjcxE5uAEVNGNQWpjnagZvZGmv0HVkLGKJzMfNeUIP/zpktXMJB0XpGRrhvJZvT5JULC5D9Kq3VziImQznZUXTN8EOqBnsS56cRvHjSqqR42hsgGlnp6QeEsFjDQWcUswTlvAGlF9Px7uvU3BvSAhEJ2fMZs9DWO97meK09PT65W5mmkCbxZPUkQwdJhWiwxoJAgc7LyfcC39DrPUWgAQl986RDyfMEaQjBdf8Z9zy1M4ZVmh0+voPHJynyckCYb/t8eOhsMDmOh+z2cKakRZtJsMKwuHgIywHlPeHWRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PktebZg0Soffw0DD0/W5JXBRUhi81XRqGK4iXiBbKOo=;
 b=L++Y9RekGnfk1ac49CmbnuPZsXabSeH/m+QhcYQh1id+KrH4zXuaK+JBa1i4h17BkgpqO67CEq6vnn/iiNd6VHI4sgPhbtlTedGROQfAYtxV+bm6aGKA6DvgjQ59waMUzvKKSuB1noSqgLnEk7p+GYctvudzGgbXPGXrEkbolfow7iLRr9LTmpiflOmtmbro1xm/fVhSfm4mIVB2QzDiVIGChiWtPlCzEv+/UbbFsvYDE4iHJTP52xkZFGua5wCa7u78jAbLU3LamXzJrNHJsAdhsm17wvQlNiNXseQ28scMruS94lNxHv5WwLlLnCZcHzukvG1qDHsb7e+lt5KotA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PktebZg0Soffw0DD0/W5JXBRUhi81XRqGK4iXiBbKOo=;
 b=IaydvFNl67AalwdnJsRQedgZ10KWhU5V/XQ3GC2G5ia8hEuK+OUM17oia5dsrHpxf9Y8XoAU+ABhAw2m+gtdTDwtb9Lvw5w4JewCzxSy6pV06wMtNygAL8xcDMSikD+qumh9g5IuG1gtxukf8SQ9+Eo8nRKXNaQSdTI4fwUqWvBbteuVAh9HOotA22tQ6S8zec07YX0bI5u4LERL0/RXfSzZ52+QQgk25LAKvuGXfgV5CjAxJ0QXZHrGWDGZUixCgeqiINGxdCGQ1z1/Bto8OxSK61RYohHeGRytF6I6qVhC5cZQ3P3oP0Gn+B82NCHu6Tzer4ClsOQA5jyep6JJTQ==
Received: from CY5PR19CA0044.namprd19.prod.outlook.com (2603:10b6:930:1a::24)
 by CH3PR12MB7497.namprd12.prod.outlook.com (2603:10b6:610:153::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Tue, 6 Oct
 2026 10:59:10 +0000
Received: from SN1PEPF000397B0.namprd05.prod.outlook.com
 (2603:10b6:930:1a:cafe::53) by CY5PR19CA0044.outlook.office365.com
 (2603:10b6:930:1a::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Tue, 6
 Oct 2026 10:59:10 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF000397B0.mail.protection.outlook.com (10.167.248.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Tue, 6 Oct 2026 10:59:09 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 6 Oct
 2026 03:58:41 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 6 Oct
 2026 03:58:40 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Tue, 6 Oct
 2026 03:58:36 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Li RongQing <lirongqing@baidu.com>, Mark Bloch
	<mbloch@nvidia.com>, Saeed Mahameed <saeedm@mellanox.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@mellanox.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net V2] net/mlx5e: Order ICOSQ cc update after CQ doorbell
Date: Tue, 6 Oct 2026 13:58:20 +0300
Message-ID: <20261006105820.257208-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B0:EE_|CH3PR12MB7497:EE_
X-MS-Office365-Filtering-Correlation-Id: c4d26b33-a0ed-42e4-8b2e-08df2398d961
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|7416014|23010399003|36860700016|13003099007|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+4tyLM+yUrfcuDKYoc5Dl3BsQZbi2l3szK5jN2IAoD6k0I5lS+D0sXaPhLMstWwji/nTXns3I9/cm/i4+XlwcPTJ+Cyr1JxjHVWl8wnNHpixUIOa6+/px9V9nvvOooy0RH/1dBLuEG6cHn5SAtA+Hlb2LBwGWNSXB2Pv1gpsQUnvB6DTwUdHMlc21T7pKHu6c23Q6zGt6oJlOWh+iB6O9LnyOWGha2uZD68+wUYBH5SsEEEs/IcczgzRaI8KaydFOdG94Utq0ONBYYTAaunsIWw91RL7jMtUNQVEluwDUqH5i3JCCLP71qJDm7fC8g8kFQSY5aRNmAioAAbVP1vFV2jV/u5zRqU+66GnOqR/FMaEwJ6XNvFB8J5ZJ2CnK+CBElwbldtA31chmBdkgbys8TNUBIH2UPG7dH2osG5Asy5DoCkNNwT/EySeYwWMsoDcj/5tHgC5KHFUupn9NBz4jH7TFStascoKOsSvZNbYwX4YnwB+lTHk3cBT3Y1zCzJcaBOQLDAxCXtv8U9QZd72kutOml451W6/qc0eyA2JHXNDDkmPzFwMzpANBzo9WVaIrzXYAQo8fVY5KPXv9G8eXwny9Qd72ZIxoh/QRpXERc4eJga70xE5gbXKtRzQ53HwXcNZo9Ht+MKAgjL3n6P9i2QiPTCWdBj8VEc5LvtZbpxuURH2NSgtEgnANMxdSE55VEeB3kHQeeiZfvlg3MeMzA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(7416014)(23010399003)(36860700016)(13003099007)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gA7HHO3j1Aa8ZA5tS5vsc1WAStZhJtbrWHgfqTKp0Ply2hvWFev6ClVgDJi9Jtqy62Gx1jJpAKcWL2u66grrjh42tv8JcWqFgivjCinhbnFcWeF/Pfglm64U/nRMmU3CWWCkbV3Hedp+Ft9DKQeGTE0eYfTcfV13PsokVvIdAmpXczHmlBYuttcqwDnrIV9z+yRBYZeuGO1ltYO0vi/nsY1mxjqw4dh68ohxoSSxPxetlPz00wKXcmZj6mrtoSryv6SlnyVYEjdlPLz3BNSIXSREWzKhIeYinV3A1NLb/ohW75frk0//mwWFiKOEd96D5xXPF9NyaQ2AsENj5rEPRU2ZOKPL/e1I/FTo43BnrHNnEwqPR1yJev5fBilDvdtDS6Vq42UTJk4dUJRCMPz0DFzOyGht5EoEAlbW6ZvsJmgfRHGM0U3trzJQDzH80LIW
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 10:59:09.7454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4d26b33-a0ed-42e4-8b2e-08df2398d961
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7497

From: Li RongQing <lirongqing@baidu.com>

mlx5e_poll_ico_cq() requires sq->cc to be updated only after
mlx5_cqwq_update_db_record(), otherwise a CQ overrun may occur.

The current implementation updates sq->cc before the CQ doorbell
record, violating this ordering requirement.

Update the CQ doorbell record first and use dma_wmb() before updating
sq->cc. This ensures that the CQ space is released to the device
before the corresponding ICOSQ consumer index is updated by software.

Fixes: fd9b4be8002c ("net/mlx5e: RX, Support multiple outstanding UMR posts")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

V2:
- Resending, after verified.

V1:
https://lore.kernel.org/all/20260820030821.1731-1-lirongqing@baidu.com/

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 7bd0606a5253..903af3b3e779 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -908,10 +908,12 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 		} while (!last_wqe);
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
-	sq->cc = sqcc;
-
 	mlx5_cqwq_update_db_record(&cq->wq);
 
+	/* ensure cq space is freed before enabling more cqes */
+	dma_wmb();
+
+	sq->cc = sqcc;
 	return i;
 }
 

base-commit: d5a007b9b457c915ab1a53227e8939e4018aa97a
-- 
2.44.0

