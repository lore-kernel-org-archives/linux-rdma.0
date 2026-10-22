Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792697526;
	b=PanqeLdiFMGk7Vmcoq/LoC1ctOF8l6kw+S6oUQv8TK3uO9FA1z5d2JA5E/YWCakKt6Q+
	 xMiTG/thkL/x5bF2Kr3+WNCe1/zjEc5T3aQxZJ0YvStjHVs5pWJcxlR0a3eBYPX6B6LBu
	 ff5fYgzDxF/aFHNV7MYJRYOuN1LyyyKc1zWi3aqsYtbunRANUJYyB2nOHZlQ7XMr8h1XA
	 7shzLwtg6OjOOB8YeAs0luSATK0HjREe7/lhiW/Ir3xxN2u/XQHO+npeh0vsX6/+cPveq
	 tZDr1D2WhBBtFMrGCNw3ts8NIaqUWUQ99xhmiehMyzJoDgqK93fQlCnwoIsXKHc9JnQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792697526;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=govet5GmjUniL15umePT1Oha5A4DulR8x8nObTHKLds=;
	b=KITRWJHkYz6ZuxcLAde6edxAqZA6qoLQpEKPzSyM5vaTBT8FCt0+aqPg83jbvt3nSCny
	 YHhqb9hfZJg+fP9z/p/+KsiR/hJJOaHyS7lzA8ccSNMgZp6obq17aIAdKMD5l+o8DxsVH
	 U4WePmNqGFGFuK2+neQqMD1NDdrp0cMMCtaDLMJZf1ys+lbusoP0PRBaU6lb79r+/zRiz
	 ibn0nOHJlNg6tSB6ilPHUQuQhy/OC4K7gVemM5qxNuRbwxAam9DDE5piRxfqMZaiDBGoW
	 rWvmMHpNmEH7R6yvTrK+ruO/UQTEoVIdDngwAjsxeU4Y0xuI+H8r5RbQFpDc5RNi/3A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=OC0dR1qk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.44
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010044.outbound.protection.outlook.com [40.93.198.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26A2606A31E;
	Thu, 22 Oct 2026 19:32:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C26A2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=OC0dR1qk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DlBmTFFHel7wqd8WFSk6m07bhPXPPgtfwWX/GOAbXiy5EURGEtHd8gEQoJWkZGpToq+jVa63HZuUqpIOaYjpXqopR8zEEriaBhdEbZLvmse+hcspH3WkOSsLgsGZVDag6iuy/iwsubEQM/2bP8fGNNbLx4PhiCWwKicr2UbL7e6sHP3T+VYFVwDBXhjsEWPiMMyefpq5KKR7H6RFxIqrehhGQeJcbSqgMO3VNLCFbm3AilMJW9NEdULrr2i0hIawL13Ybi/UvYvmb7o8Rpsg9FwJGMpdf5S3TENRT+5oVj1WyAL6+EC4x5GZAyqdmT5IYrfJUxy/1oa0Jarjq7xkPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=govet5GmjUniL15umePT1Oha5A4DulR8x8nObTHKLds=;
 b=eb0rRVWrtf4SSjuA88hx0nK1w1wdql/JPKf1ncFRq3JhqaIb8cZ559nK6/HbvR5Ok/VPmtxvHyA93Ter30QZfzIzvrZsYMDl3zv5p3LDw5hE91ySSKJEc5txsVMugjRuuzhwdYOi6eS9M6wzQ6ob/xMW8MS/ZgIXjHuq1o6bBNM2xMHpSugYJF60iKkZHYwf/OXVczd3tpzK/gCLMfWtFwxQt2ukPzEOQPFiaPfSUG9vFJUInxr4HILLXT7vaE0k/NxVmcvlpGZp/SMIoT2nH3hoIHcAkAzdj9zBPQ0Hanns000XcBroVpkaJOw6fBJrfoCYVtdyiry78UPIclXJmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=govet5GmjUniL15umePT1Oha5A4DulR8x8nObTHKLds=;
 b=OC0dR1qkUMIpfjHGzG7GiJZAUeUpkxBejNxmqU6O2ysMzDQGkMtfX6b718NFyaS3Lc/H7u7mezQI3TdTg+CvVZuZW/6wY1ge+v8ycLjD9qzgaZljTzeYkqvAv6GQRnMS38+q055mbZbbYrGLBVS5ZMfjRIWZmtqvk4CBl3/6YncHjU8+dPAgo98LKA0l+U3SuZBMD/Ue4ylHM5t3U9MLC9VLpuTUQaHnJT+Hrf6So2qXMNK5ZMzuo3zjI5dklg7RORF8Lf4DqsUe6/dh2HiXyhMz0xsX9TwIXN259i57X0l6cP07bnTQK/WHQ8scEbgojPUJwXVSNH/YWB64MFYw9g==
Received: from PH7PR03CA0010.namprd03.prod.outlook.com (2603:10b6:510:339::27)
 by SA3PR12MB7998.namprd12.prod.outlook.com (2603:10b6:806:320::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Thu, 22 Oct
 2026 19:31:54 +0000
Received: from PH7PEPF00000008.namprd04.prod.outlook.com
 (2603:10b6:510:339:cafe::2) by PH7PR03CA0010.outlook.office365.com
 (2603:10b6:510:339::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.17 via Frontend Transport; Thu,
 22 Oct 2026 19:31:54 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 PH7PEPF00000008.mail.protection.outlook.com (10.167.243.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Thu, 22 Oct 2026 19:31:54 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 22 Oct
 2026 12:31:31 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 22 Oct 2026 12:31:31 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 22 Oct 2026 12:31:26 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji <edwards@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Maher Sanalla <msanalla@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net V2 3/4] {RDMA,net}/mlx5: notify IB uplink on LAG aggregate speed change
Date: Thu, 22 Oct 2026 22:30:52 +0300
Message-ID: <20261022193053.3815866-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261022193053.3815866-1-tariqt@nvidia.com>
References: <20261022193053.3815866-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH7PEPF00000008:EE_|SA3PR12MB7998:EE_
X-MS-Office365-Filtering-Correlation-Id: e22ce12f-b94f-4846-f524-08df30732104
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|1800799024|376014|7416014|22082099003|18002099003|11063799006|5023799004|261021121427099003|261009223027099003|261021123027099003|10067099003|261022105027099003|56012099006|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	jKBZKKTn6doTZKM0h8sDneGXlUPoIqZCcNHDqxpiwdfyJ2p7+U27buKeNc9ekIocFYqnrZHDvtdPjE95pHTLiaK88Pa1AU+wtNAmiGUcd6CYQgd6Cm015i0q4TLCbtxt7Xw/0p7NZ+c8xFfs1XeOkOcQj9E73bgiy2pIm0fmQ/BreS1xA2LZnvSX//RQymmFVBVzREtpV79mUq7x98ONFKwIIVBTGDVQk/vrDUyS1uD9jDykikMpJohtV+tMYZySHgRJwMCmfYFmT6M/jlwDLhxQLcZj5C1PuU96eOKWLdbtr6HrcnKlwn6g8GY+kKtzAyLJ4YieHJH2hHoXxtWvrDZwI7m3uTwGb9sFf6xqY+PY5eGyyZdiBL9E7kOShIHhDNcoF6ZoUxzmOZkJgHuwSA4aUnULFXlUfjFHFWEEY29AY2jOWDByMM8YSyVYjA8fogWzZeFMl43t+aayKzwXDs7gE74UhqZvHH2VrNWovHeOU5u3tpGFt2fSksFOqrWMlrLAsKsOqK1bK+udapXqgHiL37pppsQw3EYS41Cqtmcyxhd1sPlABosJdXWdlOg44Xz8nNXQo5+eMA0C2E/PLJFMPGxJcl/e2tqFPjaHnFgQSYYJlV+e97FiaaYoH/Z25gl/XROK0DM27mm6szdqKtOQ5abYj+qCbZh+NI64T/K3ExOVe9LLCoC96viB3CJvHp/AGX2du6psS5rlhdL14g==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(1800799024)(376014)(7416014)(22082099003)(18002099003)(11063799006)(5023799004)(261021121427099003)(261009223027099003)(261021123027099003)(10067099003)(261022105027099003)(56012099006)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ISpJSP4UWvDrJjERDO0MzAUx1TMekChwRRBRJh5W9Y+dciA0CodVlXeu61Bcm1OQlOYhHeOUNfntOGbI1HB4YSPDZ+NO+xouCYZHhmKxGQbWtAe7E7hXuVChbCF4p0rstEigArmw0pf5msSf4ROlKPfmY7F7npAqEXHNeFhAABadzBKLAu+1pySMKQ98clmO41GIw76coiG9kHhxqnFqdktrs11OsN4GxMsTdYSo4D15RSXaWyfXeQAb7lL9FqFlkwFlwZZTGy/TmdRsIxiXl4MIwcAb1aDG2AQwavfEYIFyoXvgIEgT9Ur5IdIZVi4bNqowOmIIFjX8CD5ZDfqM5jd/UbWF6oAGY5Ozafvb4vbsb4e0ESZSBxO7XSfetASeww9kRUJ8GzWyUmek6kt0g7JGvAPZfSGEqY4Qh6FW+ucoGdwiVrKkmf9S5aSwNFeI
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 19:31:54.2399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e22ce12f-b94f-4846-f524-08df30732104
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH7PEPF00000008.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7998

From: Or Har-Toov <ohartoov@nvidia.com>

In switchdev LAG, a link-state change fires two
IB_EVENT_DEVICE_SPEED_CHANGE events: the physical port fires immediately
with the port state change, and once the LAG reconverges and pushes the
new aggregate speed to every vport via MODIFY_VPORT_STATE, FW fires a
PORT_CHANGE event per vport, which is how VF consumers learn the
aggregate actually changed.

The uplink vport is deliberately skipped when pushing the aggregate
speed, so the IB uplink device never gets a second event once the
aggregate has settled. In RoCE LAG there are no VF vports at all, so
nothing fires after reconvergence.

Raise IB_EVENT_DEVICE_SPEED_CHANGE from the LAG layer, in
mlx5_lag_update_agg_speed(), right after the cached aggregate is
updated. That cache is where the IB layer now takes the effective speed
from, so a consumer that queries after receiving the event is
guaranteed to read the new value.

blocking_notifier_call_chain() holds the blocking_notifier_head rwsem
for the full duration of lag_event();
blocking_notifier_chain_unregister() in mlx5_eth_lag_cleanup() takes the
write side and cannot return until any in-flight callback has completed,
so no event can be dispatched to a freed device after unregistration.

Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to vports")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c             | 10 ++++++++++
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 20 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  1 +
 include/linux/mlx5/device.h                   |  1 +
 4 files changed, 32 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 6594d38cf199..cfa7c7ba2b73 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3690,6 +3690,16 @@ static int lag_event(struct notifier_block *nb, unsigned long event, void *data)
 			rdma_roce_rescan_port(ibdev, portnum + 1);
 		}
 		break;
+	case MLX5_DRIVER_EVENT_LAG_SPEED_CHANGE: {
+		struct ib_event speed_event = {};
+
+		if (!dev->ib_active)
+			break;
+		speed_event.device = ibdev;
+		speed_event.event = IB_EVENT_DEVICE_SPEED_CHANGE;
+		ib_dispatch_event(&speed_event);
+		break;
+	}
 	default:
 		return NOTIFY_DONE;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 05e6d0aa31fc..afe0b9909f2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1540,8 +1540,24 @@ static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
 	return 0;
 }
 
+void mlx5_lag_notify_speed_change(struct mlx5_lag *ldev)
+{
+	struct lag_func *pf;
+	int idx;
+
+	idx = mlx5_lag_get_dev_index_by_seq(ldev, MLX5_LAG_P1);
+	if (idx < 0)
+		return;
+	pf = mlx5_lag_pf(ldev, idx);
+	if (!pf)
+		return;
+	blocking_notifier_call_chain(&pf->dev->priv.lag_nh,
+				     MLX5_DRIVER_EVENT_LAG_SPEED_CHANGE, NULL);
+}
+
 int mlx5_lag_update_agg_speed(struct mlx5_lag *ldev)
 {
+	u32 old_speed;
 	u32 speed;
 	int err;
 
@@ -1553,7 +1569,11 @@ int mlx5_lag_update_agg_speed(struct mlx5_lag *ldev)
 		return err;
 	}
 
+	old_speed = READ_ONCE(ldev->agg_speed_mbps);
 	WRITE_ONCE(ldev->agg_speed_mbps, speed);
+	if (speed != old_speed)
+		mlx5_lag_notify_speed_change(ldev);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 45b0e8fd8f99..420655468d78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -259,6 +259,7 @@ void mlx5_lag_rescan_dev_locked(struct mlx5_lag *ldev,
 void mlx5_lag_add_devices_filter(struct mlx5_lag *ldev, u32 filter);
 struct mlx5_devcom_comp_dev *mlx5_lag_get_devcom_comp(struct mlx5_lag *ldev);
 
+void mlx5_lag_notify_speed_change(struct mlx5_lag *ldev);
 int mlx5_lag_update_agg_speed(struct mlx5_lag *ldev);
 void mlx5_lag_reset_agg_speed(struct mlx5_lag *ldev);
 int mlx5_lag_query_bond_speed(struct mlx5_core_dev *dev, u32 *speed);
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 8cb321a9fb3d..1ec2331c24ee 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -374,6 +374,7 @@ enum mlx5_driver_event {
 	MLX5_DRIVER_EVENT_AFFILIATION_DONE,
 	MLX5_DRIVER_EVENT_AFFILIATION_REMOVED,
 	MLX5_DRIVER_EVENT_ACTIVE_BACKUP_LAG_CHANGE_LOWERSTATE,
+	MLX5_DRIVER_EVENT_LAG_SPEED_CHANGE,
 };
 
 enum {
-- 
2.44.0

