Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795727360;
	b=iKXM230dUto2K4Welx0M2qctOoVw8wUdl/Aezd4rmOyxYVbnpIB6pK/0AM1PX3WMqpga
	 Y6UVmYa5v6jEqzxMDGB9ixhEH4tySoiekR2GLlcJ5Y9zcN0QTU/h84uH57mVnc4dsc8Zt
	 ijMKgfCcyiDUnKsGMq4F2DqfGsj7IgiGwOLXjmYO12WCoUcyfmJ+aBhzdsaKPMO4JyfRU
	 O7zwr/6/yKwyuvsBRhGIdHFqn/drcaSRQaTQkEN49qrVkTCvUtUuiXz/1FnUyTyafKYzj
	 OCegd6EdRuWoYhlLPPv1tINjbysbkih+maGwWrFVXIfSVYstW2wFabXCU1J2gAHuDCg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795727360;
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
	bh=nauBhQlJ88xcAlQ2ov0CaD/YcMbBDp9dCz1p3b06wYA=;
	b=AIB70XpHFE/ATKQnUZqdfMEaE8MJyshXQxPUTdny4valCrOGkB6E23grD1noLdjXR605
	 VZXqWoQOPad7WKfSx5Q4J2vVo+FyvEvEI2pUHPQ7dsF+KAdLie//UMSnM7zbzpYPVYYJj
	 lbcUNqUtz1GyhiMKoYf5TgbYAx+q+n6It/RuwNvyYysy2AOFhAA91eiB/DIsqcrd+Xgvu
	 bn3mGEXWm6/haRosvy9ZEgHu44B3M4a69syeSS1ZqLvCQJzZNSvJxgHZyzCcF9Afij7WF
	 Rej+NBxN86M/3EPCa2CDTvczg0ujHiBx4u+jlzmUXlnDpz4vI+omzWl3FppuPA2XOYg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tbwXR3bB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.45
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012045.outbound.protection.outlook.com [40.93.195.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BD4606A31C;
	Thu, 26 Nov 2026 21:09:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79BD4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tbwXR3bB
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U6lq9khdW96Lw+eKk3uC6oxIjgyxyjGq4VbCEW7iuflbg5RhJR+LND8jkbY3wp2e7bQEMGWEqVc4LWbPMykdWOWUZrJkC+QH8hf/jybqT2opxRFNxoPA1FR4deczwyeDFiFythliK4llFl3F0+vSdugZm5zWeQPygGtHOlWZyc2WAmhl5v2Hue1esn/lmc+qtP11Q3NYxL8C6jDKQ5xGMeW1cCezSwv0ndsS8Dp32pm423qNHRPOqhOL6152rkvxletWv3SXvgpDqjuhK0VM5Xuyk57yVZA0oUirPtwgRszbTvu4YHjlZ7KgnzfAbNAjnj4RySANBqonIo9KhUJOeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nauBhQlJ88xcAlQ2ov0CaD/YcMbBDp9dCz1p3b06wYA=;
 b=YzCqUZQ1AcvdgS/MuptQraybd3Cfo+Bx30NIXrJO0XBFsGKdgYOb8T93Gf8Q6K0ACDrGTQX0ihJ2ZwRapBEpC1qg2PBOK4vJZlSXPhVQlc6Y7tz/PIIJY2npG5tO1UgoQNr1l67ceVeMU34q9cVhPillcqfeRgO+BB6MAKMz6yezlnjnYtm7hIIdX1JKqLqjNmw3RVZLpAyd5E84/9IFdD/qkXgDdvC0NJ1coWtog+BKS6vt2Pon6ZHsSEMNr5U5cYiWi4WUkT2xjfW4x1pxZwY8EUo1cG+vurg6dqL6OiLIvVyWXxR1Sfc0qrAQfsOIpUyyFlL7MqnCgQPWWyN9xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nauBhQlJ88xcAlQ2ov0CaD/YcMbBDp9dCz1p3b06wYA=;
 b=tbwXR3bBDh10PP9ga/iLV3mqKRSyh4LVwx7ia/9rE27VjiKxlBBOrQ9kR1GpNc00hh+h48znoLQ+Qt+5kDDdwz9yXecPEo61M2WobajO49TZVcm9xIYRvm2nLeHVZuh68ApgbDF/wi0QgUWxrqYI46iUaJ2adkqGU0BI9xk/EMyqUktbBD9iJSGeKhtYLBylEwEUkPi5tnBmhHaUPH0drMlSog+Mc5ao5oFf6z96SE8AA/WPoWdQFI4ZWbNdhgTggCR4ZlmEaa+ljgjMhkrNfznNDGz1prQouIFK+XgziZp0ev4gqT9W1ON/s5K01j95NTH1dtpUKE5NkFllu4y3Xw==
Received: from DS7PR05CA0089.namprd05.prod.outlook.com (2603:10b6:8:56::6) by
 DS7PR12MB8369.namprd12.prod.outlook.com (2603:10b6:8:eb::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.7; Thu, 26 Nov 2026 21:09:13 +0000
Received: from CY6PEPF00000048.namprd03.prod.outlook.com
 (2603:10b6:8:56:cafe::9) by DS7PR05CA0089.outlook.office365.com
 (2603:10b6:8:56::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.688.5 via Frontend Transport; Thu, 26
 Nov 2026 21:09:13 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY6PEPF00000048.mail.protection.outlook.com (10.167.247.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Thu, 26 Nov 2026 21:09:13 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 13:09:00 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 13:09:00 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Thu, 26
 Nov 2026 13:08:56 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>
CC: Amir Tzin <amirtz@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Parav Pandit <parav@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Vu Pham <vuhuong@nvidia.com>
Subject: [PATCH net] net/mlx5: Fix left shift overflow calculating sf_bar_length
Date: Thu, 26 Nov 2026 23:08:49 +0200
Message-ID: <20261126210849.766754-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY6PEPF00000048:EE_|DS7PR12MB8369:EE_
X-MS-Office365-Filtering-Correlation-Id: 523d98b5-0e9b-44c4-a0d2-08df4c0185b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|1800799024|6133799003|261009223027099003|18002099003|56012099006|10067099003|11063799006|261102123227099003|261021123027099003|261028144727099003|261022105027099003|261022075727099003|261026140227099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	pNX4rA3s7tVQuR8VcZVCgTU0H+6H3FwvI4X+b2QY8GD0oPyp8h4xQo7BAtmYmTR7CxDIwGo3soNaddXIyth7XHvCP18lD7zWdaWb9WKy9dyGmZh8tR1f+Iqlm5DAk0jOudTab3aWjZlsdmMrY7weph8AoN1SUXpotC9BaI1Dd2x3heL/vv9SRSuRekV1E+Hw/ZsyOROSWONyjq78uQZXj+I7InNIQYrA7TIEYTh9OMgG8UygAzAXCrvyGUajI/FlR6VyeUF5uJZcFvd/qcrzn7ESnEUtHtzDEUy/YbbiHHJL4S8QU6ZluVee1cr+wdCD21tkJufqQvfD9/K5ubHRmgnVlcNT3qbZ0PSIcfgW1OmrWp1n8nY8m2waCuuly9pOeiJlqYciUW0stp4RR55wWNVRcSs29eKejA2tBkkusyk8xpObRkPtHYV8xJ2LH8PMqT5CuefxheUAwvkoyBAtkC2UsN4u6jChtSGJG6LuT8N7PoUirVJpSOY39pvI0lozCkyYw+mTwuzIrXxnp5Gg6f75lIQy0YdThvRUcs8T56yfm6uQVvewj5sTMLVFXq6uJY9stkGUrd8meYle1278H7arqUihakAJGaJryGsGYy2p6VCPS1IioPu+7Ayobx992K3tBQwu5ra/zp4W2Dg+BQJd3ZqdfJfjIO5e8G8aks94PTUpKwOVFCMHn2SAS0BZMDpH66tup37OMIAXUflZJQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(1800799024)(6133799003)(261009223027099003)(18002099003)(56012099006)(10067099003)(11063799006)(261102123227099003)(261021123027099003)(261028144727099003)(261022105027099003)(261022075727099003)(261026140227099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gM2yzAYhr+oqDt5c7pVdWxKoWqsYJniIPJkgLbgeEHiL0qQZD807BR4R13ygZO9tSRQUSpzoB47j22PT1hGQeNr/yyhbW6CNCXWOq1mzzQGFcWlkbtu+mRN3AUQeDvQV26BBi/5PlnsfeTBPvOBGshnILCzt+GJycp0tdHRMUajM6s7iplua24YZvs4aw5IqwQz0yhG9TO/lqqX2YwtWjuQ8Nyb6REuZfa8Kf9bFPHyaYaf5lb4CSRfgkUV5fSrNkR/mKY1namakcS8kt2UsB7H11flxRVdDCBxkelA66AVcQy699AJDyHbgR4MNlcXNVXDgm07pYB5eJIGVB1LP8MWpPOQxuIldKNcDpoC9IdTRXQ9Mkuh+SgGwOwAfEEbKmlG4eCTmvFI3FBU76bfqPZMQS9JvNGGPw+Lu6CfHUCBNXcJKmVK1enjH7qsp7e2P
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 21:09:13.0777
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 523d98b5-0e9b-44c4-a0d2-08df4c0185b5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY6PEPF00000048.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8369

From: Amir Tzin <amirtz@nvidia.com>

If the log_min_sf_size firmware capability is >= 20, the calculation of
sf_bar_length overflows [1]. Use BIT_ULL which cast the calculation to
unsigned long long.

[1]
[] ------------[ cut here ]------------
[] UBSAN: shift-out-of-bounds in
   drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c:346:27
[] shift exponent 34 is too large for 32-bit type 'int'
[] Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
[] Hardware name: Nvidia BlueField-4/BlueField-4, BIOS 26.07.3 20260708
[] Workqueue: events work_for_cpu_fn
[] Call trace:
[] show_stack+0x24/0x50 (C)
[]  dump_stack_lvl+0x80/0x140
[]  dump_stack+0x1c/0x38
[]  __ubsan_handle_shift_out_of_bounds+0x154/0x260
[]  mlx5_sf_dev_table_create+0x4e0/0x4f0 [mlx5_core]
[]  mlx5_load+0x108/0x3e0 [mlx5_core]
[]  mlx5_init_one_devl_locked+0x3d0/0x820 [mlx5_core]
[]  probe_one+0x444/0x618 [mlx5_core]
[]  local_pci_probe+0x4c/0xe0
[]  work_for_cpu_fn+0x28/0x58
[]  process_one_work+0x178/0x430
[]  worker_thread+0x310/0x430
[]  kthread+0x114/0x130
[]  ret_from_fork+0x10/0x20
[] ---[ end trace ]---

Fixes: 90d010b8634b ("net/mlx5: SF, Add auxiliary device support")
Signed-off-by: Amir Tzin <amirtz@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
index e75cbf333898..12f70f640006 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -343,7 +343,7 @@ void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
 	}
 
 	table->dev = dev;
-	table->sf_bar_length = 1 << (MLX5_CAP_GEN(dev, log_min_sf_size) + 12);
+	table->sf_bar_length = BIT_ULL(MLX5_CAP_GEN(dev, log_min_sf_size) + 12);
 	table->base_address = pci_resource_start(dev->pdev, 2);
 	xa_init(&table->devices);
 	dev->priv.sf_dev_table = table;

base-commit: e1055cbfd6eb578417f3ce983cf44462e8465267
-- 
2.44.0

