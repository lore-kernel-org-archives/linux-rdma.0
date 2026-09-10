Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012013.outbound.protection.outlook.com [52.101.53.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91E13DAACD;
	Thu, 10 Sep 2026 10:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789035967; cv=fail; b=IaZQe6a6GkAyJ7Z43Q6dL87PQdGReOunHg+tuibqYizRTX1QBwKQWesuR857dnvc12giljlfEbJk+vzgt0/TX+g3wF12cg4+LrrbvFWpeMyifxXpXjVQVoBReYMWiAiQ8jTXYM1y8ygyrTVfp01Asv/JFLnKMdcxZ+VGPREIUiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789035967; c=relaxed/simple;
	bh=eQX+7/DtAAJzih7KM7SIYCIGOqlqICJc6Zqf+zvLx00=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KLJatqfYCKb9GPB7mFsfMuPn/xBY9x8JzR5OD7yIzdnv+fkx9/Tlz1LZ6bAqCVFCARINA7Po4ucDbsINxSDAgdkm0BzHidNRlIhAlvKfXvq4mZTHtJ3S+gssdeLZFFj3vKEKlIkAAbNH0dwi+WuKedwGtUZpNGIdU1+q7lilEM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FV5WFFLB; arc=fail smtp.client-ip=52.101.53.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FV5WFFLB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O7KKETV3nAflmD/Vr+ZeICWOqty9kEMd/XEqDGv6znx8u6oVKSs4TmgFX9i+CQ5lJQSytoCFkpy+exystxJRwLjrMdBCWXENlwXp5HRvorigTq3m4pwLeECEEI0YvI5znH+rXHIfYM3ZSW0yht4WaVP6VupVFSq5wUABQNioRtKqM+Le6dkkxz0YBu0uawLcv9DNWDB0gvZaSqjMr6aZ43oR9jmdBKnaGlT6iPCsj6fv+LZBAQSNvI5tlmxr0sYJzAz8h6BCbYvDjFsPdtrrRrKukoEHB2CcDXiWeHdsoCUXAa69GbcfoJGWOTl//ADTlnfZBIYvZ8u6XWxlMyPDXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1etMKaDhnQILo7a5/IXrRBn966tDjwM1z3S5/W4MfY=;
 b=aHUMmMIfpMrC53YRGQe4FMq7D70U6Rfmb3WqOW+8dHNwwV0Uto9P0pziKyEtzulVQBisfk93AbmSZc3uLMR+PjTa57LQV+UWVQ53shCnpF+eGKdCvaELqzd2jHwv6g0w9vOQGKdPb9NtgdeB84x9+ZFBGNJEJAiTLWbWITvy0vKJ+BMIYuEAuyWCh+pEAwRs3aNgIpdIpDiUYKvaj7UT4eRHnEwARSFL1CItwiubF9z5IiTcofZQFT7YpCqQMENd1ejsnxLlie4FfdxZXjli6Fy6DVCyWYavCGpP63kW0ZLkrSSCtBUsEeWdnJiroY+D+LtNtH9/CUvNOAN/eJYYdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1etMKaDhnQILo7a5/IXrRBn966tDjwM1z3S5/W4MfY=;
 b=FV5WFFLB+zbfDaCyJztXCPQwZoVsUKy5ytilVOV76viNKx+P9fOBHhrpBvVDBki2OAlDZE9kfjQq+LONYAALBOrJuqkK4/0NGkhxfH8KbzC2iwTqa8uQDYfwaU5wDzR8u3yXOBVCMFelNIf0hVx11t2tmYQidoqEoyaHulkWpM1AR/WRHn4v1IQ6ozdxxiYAyH+jYa4QQ1u2YpeBHsGUJ6Kz07lF7DZ717Zpcvdv0pJwf2y8XzS4gKsxk+IkRARS+7D3MJE+v1cJvXYQKcm13Z6h5l1zmAkpiqgCWbeSqYwjl848/hyEFv0bh/TMeRgYKDukuR+PgbmB919FsV4wkg==
Received: from CH2PR02CA0019.namprd02.prod.outlook.com (2603:10b6:610:4e::29)
 by CY3PR12MB9680.namprd12.prod.outlook.com (2603:10b6:930:100::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 10:25:47 +0000
Received: from CH2PEPF00000140.namprd02.prod.outlook.com
 (2603:10b6:610:4e:cafe::80) by CH2PR02CA0019.outlook.office365.com
 (2603:10b6:610:4e::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Thu, 10
 Sep 2026 10:25:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000140.mail.protection.outlook.com (10.167.244.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:25:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 03:25:33 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 03:25:32 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 10
 Sep 2026 03:25:28 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Edward Srouji <edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Maher Sanalla
	<msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 5/5] {RDMA,net}/mlx5: notify RoCE LAG speed change via driver event
Date: Thu, 10 Sep 2026 13:24:32 +0300
Message-ID: <20260910102432.3845360-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260910102432.3845360-1-tariqt@nvidia.com>
References: <20260910102432.3845360-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000140:EE_|CY3PR12MB9680:EE_
X-MS-Office365-Filtering-Correlation-Id: 60536e14-1292-4d82-e05d-08df0f25e101
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|82310400026|23010399003|1800799024|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DAeExlZxdYMv31YrJrqUdLpxXQPI72hmyNm4Dn1wXxfyzr0m7L36FPk27NpzpH+hEZKfV1bE+9JFSHxalScLsPOi+nNnhwD5za7ViaJ7kZz6UnnsOyLeBV91Jwje4SzEDH0o77a8mMIUaDfMT9O/jvU461Wg4kJNz/QzHh+zx+6jHrqPU4ABsqZKISY0RvMyBewl3wwJmX9a2YpJ6nJn66UvPBa1pawjqMWQXt1wbpUE2U/vkUzdphqw/9PtLt8STYO7EFlfIfFgthzqrZl8x7D1kCuY4UEq5JsLxgmJXCCRlvtwQBP1hrUus7+DVpaEjwMkrLFUDpCMk8PaqtVUC4Pk57Fx2hla4rpfZwhR+s7vXs4a7uzIlDn8tj7XV2HqEAFIHzyYidNayyi9aruMhs+nxVq98KcoZa+V/QOS7aBXi4+y5DU79sCMsLJUO+POeiHTa51R8YcDahg2eiI7y6XeA1CitjlOdRtTJK4mb9bnmGH2OPeAD+jXwdqn3KLKchBG73nDG8Vy4nKnpCwHk1CU64LWb2EYq316hZn7Y6fJ0mXtCVbNzRnJDqKLNkRc/YHC1tWdVoaVC0CRs5jtrZkDhx0B8bQABLHskfC3nSbE4z3KcWVwO790YHCVkFbz+I4+74HXpiscdB36raxw0ykFpMvXm7YgfBTdbOddbKrRp3kbqExQ0/uBOHMPvIchGqw9Ns+BdtcbZi8wRS3KwQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(82310400026)(23010399003)(1800799024)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PBb5ENnH9rN1bbxYUuWsddkGmyr9J9F8z/SpDPc+koa0TjRxaV2H7n0sucpcTCegXd+Qma8wD1WjK2C4owFEFqfRWDZIGvgZjeMeY3I95PAdSpkcuHTeiPeee3NqoAYalt/veko7VhrdUNgVjE0KSg9+P84fVaLEcZJV1ia/0P1/BmoDGKT7GFDamChyD5NGU34q3wwihoAY3gpni/XVSVtrmNk4f+hSyPbMK4z7el7z9jBS52z+fuhjEgaT+xzybIkKpZIMNTKihQaHSK8ElGObgMMjO/SB6hkfM5Cey8EKH9So01C/UuWPEOMTYzfVkRLGOEoMV4/xSd/S9OIm3z1HmZ8efulnShipCANWiwHuEEc1fVxs6SdkAvU+WLhzejRGRQ1+sA9L4aRd0yEfTHPVQLbhRziQgxCrWu72rVfQ+laSXvCD9cvULXAnM5Sl
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:25:47.1542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60536e14-1292-4d82-e05d-08df0f25e101
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000140.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9680

From: Or Har-Toov <ohartoov@nvidia.com>

In RoCE LAG we don't modify any max_tx_speed, so no
IB_EVENT_DEVICE_SPEED_CHANGE is ever fired.

Raise IB_EVENT_DEVICE_SPEED_CHANGE from the LAG layer, in
mlx5_lag_update_agg_speed(), right after the cached aggregate is
updated. That cache is where the IB layer now takes the effective speed
from, so a consumer that queries after receiving the event is
guaranteed to read the new value.

Fixes: c6df9a65cbb0 ("net/mlx5: Skip disabled vports when setting max TX speed")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c             | 10 ++++++++++
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 20 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  1 +
 include/linux/mlx5/device.h                   |  1 +
 4 files changed, 32 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 6ab7f945e712..bd54af47eda7 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3693,6 +3693,16 @@ static int lag_event(struct notifier_block *nb, unsigned long event, void *data)
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
index fd91becd6848..5e70ca3b09ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1503,8 +1503,24 @@ static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
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
 void mlx5_lag_update_agg_speed(struct mlx5_lag *ldev)
 {
+	u32 old_speed;
 	u32 speed;
 
 	lockdep_assert_held(&ldev->lock);
@@ -1516,7 +1532,11 @@ void mlx5_lag_update_agg_speed(struct mlx5_lag *ldev)
 	if (!speed && mlx5_lag_get_devices_max_speed(ldev, &speed))
 		return;
 
+	old_speed = ldev->agg_speed_mbps;
 	ldev->agg_speed_mbps = speed;
+
+	if (mlx5_lag_is_roce_lag(ldev) && speed != old_speed)
+		mlx5_lag_notify_speed_change(ldev);
 }
 
 void mlx5_lag_reset_agg_speed(struct mlx5_lag *ldev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 744fbf9a0078..2b15a0b70fdf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -259,6 +259,7 @@ void mlx5_lag_rescan_dev_locked(struct mlx5_lag *ldev,
 void mlx5_lag_add_devices_filter(struct mlx5_lag *ldev, u32 filter);
 struct mlx5_devcom_comp_dev *mlx5_lag_get_devcom_comp(struct mlx5_lag *ldev);
 
+void mlx5_lag_notify_speed_change(struct mlx5_lag *ldev);
 void mlx5_lag_update_agg_speed(struct mlx5_lag *ldev);
 void mlx5_lag_reset_agg_speed(struct mlx5_lag *ldev);
 
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

