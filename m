Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013004.outbound.protection.outlook.com [40.93.196.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E4D4A0127;
	Wed, 23 Sep 2026 10:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160074; cv=fail; b=WEAnq2DQQFEcpURMyetcZALmXhE1/I4dIPVCVAXuOl8NXxeOCB1Sk81ClebRqg7+tklvEHN4pd+ZII7GJNNPI5PmVMFNjA9fxiEY4WAsN2C6dKEo2902W3R2aNsFqhJxys/40LZhdSIFiDIQn+Yn8nG2yKvJr99mFj+6RSo5a+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160074; c=relaxed/simple;
	bh=9Yl5sijg3see7UdELRttZXAgRJg3eG+Fup19QBtcFhU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S69LSw7E0VvCVyF1zwOHRnzDeGLEcYmSB60xhZwYzYl6QxZ7zfnJ6TpGkXsWqSV4BRwUWD1jKM0j2h4oqRThC+NfK4VAuwMVRw99k9IDfecccQfkGRKtaoOh1yurRWON8bkAkY+iVqXQ0kIVcmuk+apAQ4/K6rb3u1bXdTD7AJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IgVTbkma; arc=fail smtp.client-ip=40.93.196.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IgVTbkma"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T+igexlwI4YIRPfDWpOY+YiAZ7l/CGH2VvpEjrps4oEa3dT5Abi36/BMt7f2Dhh3ky++T2eebSJlGh9Zs59qTl9wVTwMOS5BB2VCVNgiKATsVKieTztvkX97rEBayyOOyxKKyJipq8CxNx9+HaISM2/BiA2MwZJfVpXMrkBOj9GowGRPrfvwSz04XG+W0wRmYxvJ6VytoXaeXo6kgqjDkCjpOMV1H0BFK6rxvP9dxVjhmbMmqjXIol3gNFfVb0wwuNVLEcXwTdY7yJWLYHJifFiyOGb9W6C16cVAj7l9rGXAzm7Pm4OqBSajBgQepVaHTi4FPiLlD13Qh/j0OclRBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YmDhGFPuUIAzPFXBk9Nn9YO1zRIgdQgAjGpHbJUfYsY=;
 b=PIlgRywlHp+EimFkyZoQZi+8YsGSXetXO5wkiimbhq8dbkSVJ2Pm6QQ4blCxn66/CM9gHew7tzpYJ1PZYpNY/WACOmW/kOjQmKIV7CHwmK32gI+xTRcJPOGYGN6y4K8T8s2ECYIxgVGzlkLNEeX+BzyldfE+BC65SGCU+Zs/fXr8YuirZ2UZ4eqdJIhKHeJLRhhb8oAULKA9lJQyrY5PCl3Fikura96d+EsX3ijtbBPeGy/SAME9KzepTT8lop4VHvKbgBgF2JsPMkKc039YNCLfsfcJk4G12/jhw83hTKLUPIsBUMPC64gDzjw0f5VihJqFUSqQstJ437E6v5sGiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YmDhGFPuUIAzPFXBk9Nn9YO1zRIgdQgAjGpHbJUfYsY=;
 b=IgVTbkmaopJtDAdAt4j4KUCN38dWsjGEZVkt9oezKwr5ZsmOY0ICL4oZhyGhjCcDloRYG8aCi72W4KokvgYSU4S0vLMDeziLHhTjuJe27+3ji33SQ2CIy2p0nyEOElk7J9xOGg8wxyU5VUKjEOnoz2eZk1Ve9J7d/VCKYKrNH1+eOTpV03fwxKoZ7dOtjsNN7GLgnxX16wjkNCo1lotXkz4/DmUfTCEEOLd4Kv6CtvVazZHrTY5yyzGFMwK6Rz/ggftBI1kTtNOQqI1Im5G0dbRVFyncjVyAMqbXTRjZPdSfXTKf1f3nJaFrhJvpQGkxUatGopWyvJOgJ6z1OoquXA==
Received: from SJ0PR05CA0086.namprd05.prod.outlook.com (2603:10b6:a03:332::31)
 by MN2PR12MB4127.namprd12.prod.outlook.com (2603:10b6:208:1d1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.15; Wed, 23 Sep
 2026 10:41:00 +0000
Received: from SJ1PEPF000023D2.namprd02.prod.outlook.com
 (2603:10b6:a03:332:cafe::20) by SJ0PR05CA0086.outlook.office365.com
 (2603:10b6:a03:332::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.6 via Frontend Transport; Wed, 23
 Sep 2026 10:41:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000023D2.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Wed, 23 Sep 2026 10:41:00 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:39 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:39 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 23
 Sep 2026 03:40:34 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next 09/13] net/mlx5: E-switch, derive manager vport from device capability
Date: Wed, 23 Sep 2026 13:38:26 +0300
Message-ID: <20260923103830.1183-10-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260923103830.1183-1-tariqt@nvidia.com>
References: <20260923103830.1183-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D2:EE_|MN2PR12MB4127:EE_
X-MS-Office365-Filtering-Correlation-Id: 42687e3d-f101-4292-59e0-08df195f288d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|23010399003|82310400026|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UMqJ8IQUlJzq0JHcvs4qWwSC+4DqIqWxdHiXj+WjedjkZ8aS77GHud4ga0083i3dYo4eP/unHXnahKQjOWTj8LlU3SEhUSH9f/Pophyf7taTLb3Nqzqy8mxyaNqrl+KPDMRaDTWoCH3H6J8L0k6eKzQ+KwfB1553hMrlwSINRa/oR+2kepxOG3JlVr98RQd1FyVYhdzZk2XvztLDswOtY+msBCKd9bseO9OY8774xbvKQ0HtBThC75wIt5zC0w/hu6WWZR3EaKoeHLsRMdKSrC/Z0VqGbx81eT7yFBp5osMAuTgFeMv24tSWvc2IHyuC6Tf+oKzfp0FL5wqh7QG5S5gXyw3aTxTo1jELDIYmhhOonHbhwJLoT7FcFcAengNcbzEJD0zIvodq0PxH8tXmvk/tBEboMhqYNhU0kcXg7JZ70DYmMqXFhrIVxnIba66FawaZlIAX4xcfaiU1E+LwvdLK7QQz0MlZ4L1wBOIzIsZmGUZqAXpwxiNR0A/jeEcq+ABT3ckCsYVYhd7RpuJotwLK5zomz8JIxHi+0QPVAXmuZyUmOqzMI3ZrQqW8+DofNWrnrNz+Yj6JZ7bdGvjyXJl/DXn2dy3YMkTXP4wy6W2BXDVnphZdsu7xnps2lf1nICAdCzki9y4yWrcdTb8vLhLufExYVcyGz3xrvGQe/Jz3jzxE2HgluWi2Ikrp7tt1AA1nxZlBeMFBLGQvdzSYsQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(23010399003)(82310400026)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dZdp2UpWB/9OCJGXFh4J3jLipSCX3Y4TamU13l6NncVYyPTeDqG8WUA7w3UP0XiWDjr+YP/+Fx+9lzFXpc6Pfn6jmDQXYKvDYrz5AQr3gM2a7QmpSQ6D0zRS09yEfrWiNgOIkSyPQ+F/6fXhiC1FXKt0jsQCggK64coyhwNA2/n8hC0jpJyQTVGeqOeYJZyyGcsH8g7CyaT/I7MH8hNPGWM9Y0cgxsU/nVVSnyp6RfbwbUEoQicvqXeJ6mRL8E5Xc8bluzZfUByV5olqCVucmIlIbKv+Tg7xWVNj+ac5vCD0qPZZHX1buasYoV8Z8OIGgou20zyIodC9Y2RBRcUuLrLDrar2TQg0qk1vEi3V/L94s1ha6w2t1XhKvB+ItUV3t/QQ+ZxqL4TTYPXgsqtMmStu9s96OkBMm9GpF2WC5T31ojnWVjpVTtIHEqmy8z5i
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 10:41:00.1487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42687e3d-f101-4292-59e0-08df195f288d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4127

From: Shay Drory <shayd@nvidia.com>

mlx5_eswitch_manager_vport() hardcoded the e-switch manager vport as
either the ECPF or the host PF. Read esw_manager_vport_number from the
e-switch capability when esw_manager_vport_number_valid is set, so the
manager vport can be a VF - a prerequisite for VFs acting as e-switch
managers. Keep the previous mapping as fallback when the capability does
not report a number.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 11 +++++++++--
 include/linux/mlx5/eswitch.h                      |  3 +++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index fc197d1dc9df..e7561f0f89b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2460,13 +2460,20 @@ static int mlx5_esw_vports_init(struct mlx5_eswitch *esw)
 		}
 	}
 
-	if (mlx5_ecpf_vport_exists(dev) ||
-	    mlx5_core_is_ecpf_esw_manager(dev)) {
+	if (mlx5_ecpf_vport_exists(dev)) {
 		err = mlx5_esw_vport_alloc(esw, idx, MLX5_VPORT_ECPF);
 		if (err)
 			goto err;
 		idx++;
 	}
+
+	if (!xa_load(&esw->vports, esw->manager_vport)) {
+		err = mlx5_esw_vport_alloc(esw, idx, esw->manager_vport);
+		if (err)
+			goto err;
+		idx++;
+	}
+
 	err = mlx5_esw_vport_alloc(esw, idx, MLX5_VPORT_UPLINK);
 	if (err)
 		goto err;
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index a0dd162baa78..03d3620141c8 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -222,6 +222,9 @@ static inline bool is_mdev_switchdev_mode(struct mlx5_core_dev *dev)
 /* The returned number is valid only when the dev is eswitch manager. */
 static inline u16 mlx5_eswitch_manager_vport(struct mlx5_core_dev *dev)
 {
+	if (MLX5_CAP_ESW(dev, esw_manager_vport_number_valid))
+		return MLX5_CAP_ESW(dev, esw_manager_vport_number);
+
 	return mlx5_core_is_ecpf_esw_manager(dev) ?
 		MLX5_VPORT_ECPF : MLX5_VPORT_HOST_PF;
 }
-- 
2.44.0

