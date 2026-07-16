Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011002.outbound.protection.outlook.com [40.93.194.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B4F37F8A5;
	Thu, 16 Jul 2026 08:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191780; cv=fail; b=c5Qa5P03+kIIfoBiRzFZ7sRdhc/3BTgPDv87tddejlF904QOhdkp+3FqjGhXRCrINEcmbYqPlzkdgs8Kmi4oz2dtqGPppDI+kfFhGDgV/AN3RT18byy5EQG/s4dygkoFemaLoQJRAT09PLS5uT78g1Pb939qU72Yc6DZO6YqNUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191780; c=relaxed/simple;
	bh=RoW1xLNqkr6WVJSgd7G78abNw+yVpijwdETVHxNBDkw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cq0CuFDG7y0Ju+FrBH4yjmtxtbcWoiPqdiNeSCt9KO4jX94VTRn4zwoFrxgL+oKkpHyv/ZigEvQt2qCGbXXjHiZzVNMPYTUnfEhmYkK0I0arR1ffaNpLHw6YgdV4PpHSJjUm5ID+0Cq3TxXmiGKDxbh2eMuv48ctFwFIQ12uTIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VZ5w52Oh; arc=fail smtp.client-ip=40.93.194.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VZ5w52Oh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=az19UvTueNAlQSeOfRZ9/47w24tOgsBamJn3zI/5Vkr6w+c3Z1d7uvk8Mi4zLki5GHV9XrZvD8lMjCGYj8AMPgtMje4x9N8EkP2jS5Bv407mM1Z6UNvXSuFM8W2/b37hM4jS2mvDcVqPVbfzMBI0LJDLkpRMghRaBGdjrqSHoeDUrdQ/03/gxf6oWE1U0uUbTRmMOVNrv2b/80NzJGmSIBVG8hFU9GzF0fWs/I8N/rpp3YqlND8YECcOtVeNIJuzvT8SFJK3AcWeH0au4IfWl0Rt98zlKmmiPj3dtsPd4vWMVNw/L/pEfTJf2qIAxDuDhymivWVm6n9N+sU29uGVig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2rQj2u02+BlzS7ShDyNMjWS9LBoOsUoIsCoVRGDz84o=;
 b=BRnYiorbn/kSxHm23jvG8qulWEKfjk9EBDzEtDIkCi4xYCSbDYvdw7ATv9Zf6iF1EZOF4+hUU1NSO+ySLBYpOpBLifYWQu12VHYttWSwgN8xsb2FVUdSQtZDZcuigJs69QKEaDMvrskkb26z3qGnqkvrXSw8FKmTP8162mJxoRmI80lWNLOUgPEdXeuplMyvLzvIzI0zLkvtpNCkhbHMQdpdP58F4eW+UQ0uZViQG3UpUO6VWcWes4yGsJ/toIr+RfLZqgOGjLBDqMfQiE43YQoPWP2xm7RQj8ggQeAbsrh/Ca584+S2Rb/hafVfcjSELMUP8Uo8BlkbZlu/YzDlzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rQj2u02+BlzS7ShDyNMjWS9LBoOsUoIsCoVRGDz84o=;
 b=VZ5w52OhkiVNLpzngM+CIxOvVvKAkqIEajtf2sfup/8DPE3KDTKxQVsWd93JN78aORofUyvNRShcQTxYCWS+GmYYQvlusjnKpts77wgeK7BCN5fw7WCJbWnDyK/NmQs+wwlmmiGH1R79RwWkLKRwbH7RwbCR9GdbFIJyofCyg95AtSSAShkzJn1wsFuecyexuBOv5RE/yRwHOPVV1JOxXiUftkVwG9GvNFQBOFzDqi1jCmL7yUr0O6hoTp0G3Pm0vE5vekSdtHOmRAX7d9aCvDjTowM2gUCUjzgrM0sXMkFa0T+pxOGlafipd7AhFYA9tMStYUNr6SA40h+NVzpBhQ==
Received: from MW3PR05CA0003.namprd05.prod.outlook.com (2603:10b6:303:2b::8)
 by SA1PR12MB6821.namprd12.prod.outlook.com (2603:10b6:806:25c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Thu, 16 Jul
 2026 08:49:20 +0000
Received: from MWH0EPF000A6735.namprd04.prod.outlook.com
 (2603:10b6:303:2b:cafe::a0) by MW3PR05CA0003.outlook.office365.com
 (2603:10b6:303:2b::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.5 via Frontend Transport; Thu, 16
 Jul 2026 08:49:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000A6735.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Thu, 16 Jul 2026 08:49:19 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Thu, 16 Jul
 2026 01:49:04 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 16 Jul 2026 01:49:04 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Thu, 16 Jul 2026 01:49:00 -0700
From: Mark Bloch <mbloch@nvidia.com>
To: Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>
CC: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next V7 1/4] net/mlx5: Clear FW reset-in-progress bit before reload
Date: Thu, 16 Jul 2026 11:48:49 +0300
Message-ID: <20260716084852.549909-2-mbloch@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260716084852.549909-1-mbloch@nvidia.com>
References: <20260716084852.549909-1-mbloch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6735:EE_|SA1PR12MB6821:EE_
X-MS-Office365-Filtering-Correlation-Id: 850634e5-aaa9-4458-97f1-08dee3172055
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|376014|7416014|36860700016|1800799024|10067099003|56012099006|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	7wBtXMm7SI1whARalnp3vPHskanVQaiPg+//ds0jgEIBRz/At2iPynpymLxuRf0QV08S1W1ED5Tm2nDHT65L7J8FjsQM7WAa6wa8HK+jpTj3OvfuRyb+mfd1LR/X3PRwtrp/S+XErMffsT6uWSOu3ALhnGdJssdhIcwSa+AQrOWIB69FCEueeCbv27lyD2GlM87WI1QGJr+RAdqG9hC1LqNiDpfC70LhwD8EgfjnJjSFc7/h2NkRWs+E2x2JQg3jrhrg3uMesWEi5KJlxj4ZBGLZV+VDXqsg7LJIVP3OekjQOB/89uhTouXxVHmoZAYo3/OZBIScv6vsemBVZj+oZvqLFH8oaxbI9SaiK2V1PFITZ21NPAiz7raQZy/0nlu3DRtNtJsL7XKI5r0uzey+3NHrvkaUGJCRaCH33MqCToe7N2S9FlXuxCDK46IkwVolcWm1W/arP7p1BIHFkIzf6V+fy1M8ba1jr6UHoud3+/CZxU17eJa1HybLgbZx3GzHUDgmwtlOB4dTQHUBRzRmBtlQlFLRf9ngvF3ip/v4fljBgPuXScdN0GA521CdDTUsCCpANz0/xapEiVzMJqKls4lzZLhcDlvReuhkY/4GD2638DjX0xvJpWxFLi55RFOcBiZCGXr3NoP3j/nNHXmTtFCrW3Sxi+f5MjGF3PYSuY+L5qEiWhrohUX043gsacHs
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(376014)(7416014)(36860700016)(1800799024)(10067099003)(56012099006)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9dem8+YhAn5FDf2jl4sP/uZHZabv4ewSKpBmh2l8bj56+XxkuXW8D+xO9RNET2Ponnmv7nbpYhvIQKW/7YxmT8sIbnp+DT/+aF87Kpg+YUCGtwjz4rKAOE53lpqfNkjS7P6KCA8ULEgajx3xmYsKjpUgVMBXgRmXIWkxvKV8Lix14FXeFWVEC6/4DhKFL3J57UepH7W7kj9L3Yi0H+LDkNvPEtq4hIqfNf1v38e7j99TpQA8KQfaSV52odmwbU/sM+PApQLqyMxjn0DNjSgpeGnPaL4JTOcGxB2NAFUY7KwBI07QgbhPmPcfcL30WLP0hkPk8a1+SJ3KmZKHErYTdGDilQlsdMw3OMpRJTOum04BJrrKnW7nsvkac2cQMAsruMNOScI0qnvqk1M+Q8QxRKcx5MXSxVrKQZvM1Dxv3T//vZvAYkrsd1XUFty8UMdM
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 08:49:19.8397
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 850634e5-aaa9-4458-97f1-08dee3172055
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6735.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6821

mlx5 sets MLX5_FW_RESET_FLAGS_RESET_IN_PROGRESS when acknowledging a sync
reset request. This bit blocks devlink reload and other devlink operations
while the firmware reset is running, but it was kept set until after the
driver reload finished.

Clear the reset-in-progress bit once the reset unload flow is done and PCI
access is back, before reloading the device. For a reset initiated through
devlink, clear it before completing the reload waiter. For a reset reported
through an asynchronous firmware event, keep the unload flow outside
devl_lock, then take devl_lock before clearing the bit and reloading
through the devl-locked load helper.

Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 28 +++++++++++--------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 07440c58713a..7283e5b49eed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -238,24 +238,30 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
 	struct devlink *devlink = priv_to_devlink(dev);
+	int err;
 
 	/* if this is the driver that initiated the fw reset, devlink completed the reload */
 	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags)) {
+		clear_bit(MLX5_FW_RESET_FLAGS_RESET_IN_PROGRESS,
+			  &fw_reset->reset_flags);
 		complete(&fw_reset->done);
-	} else {
-		mlx5_sync_reset_unload_flow(dev, false);
-		if (mlx5_health_wait_pci_up(dev))
-			mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
-		else
-			mlx5_load_one(dev, true);
-		devl_lock(devlink);
-		devlink_remote_reload_actions_performed(devlink, 0,
-							BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
-							BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
-		devl_unlock(devlink);
+		return;
 	}
 
+	mlx5_sync_reset_unload_flow(dev, false);
+	err = mlx5_health_wait_pci_up(dev);
+
+	devl_lock(devlink);
 	clear_bit(MLX5_FW_RESET_FLAGS_RESET_IN_PROGRESS, &fw_reset->reset_flags);
+	if (err)
+		mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
+	else
+		mlx5_load_one_devl_locked(dev, true);
+
+	devlink_remote_reload_actions_performed(devlink, 0,
+						BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
+						BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
+	devl_unlock(devlink);
 }
 
 static void mlx5_stop_sync_reset_poll(struct mlx5_core_dev *dev)
-- 
2.43.0

