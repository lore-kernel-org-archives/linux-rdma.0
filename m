Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013040.outbound.protection.outlook.com [40.93.196.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6D34302F8;
	Thu, 23 Jul 2026 09:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800503; cv=fail; b=TtCQsD9AHKs+Vd9UsfLx7zbsy02jxWs6tzU1J4qYgAoQKFzvewjm8OpGNhQOB3Q532qTnLS1NVkvyUveSlu2W4GmTC+dL5dEiwdOzg91HVJf4ovXYfXIzbgh31hpUXrE6JWQ3oI0XKnIpuwA04OrOZbV8VWpSevrY4ItD2Iu1zI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800503; c=relaxed/simple;
	bh=TnylFoKrmjv1eYeTz5k/jvMBwAyLEYOnEr5M3WVDU+o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=skJ8hsHPO5ZQCx+YwfNQHN7cMJsOtdmJBtGa6LzcUZRNahAldk7Ps6SnFuvLGxqYvpnSiVyABcd65xjn/K86dhgSbQdXIqtKr7zpobeMLBwV+Z1OEp5dOX1cp6ZdvQc1ZzGc8UmLWEHkhJZxKwEgYEw0C/CjevHXZszArUHpOz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Lb9rtATD; arc=fail smtp.client-ip=40.93.196.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Lb9rtATD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B+kgD4meIiT8H6NrcoM9IuEtsebfPXkiFRkHGklvsXRGeBlL1Ogaor9NeKAJ+GPWSNFiLMSjtmS4zI9z6OwBFijzlYsBpZ+VyLuQ4QJKy1wiS6YwThXlmXDICZkTbpPh+B9hT796CpaRlPRrgFVBW54zMD8icjoUjipnGrGBWkFJwMRFdzXBNsWUyTkz5qVtdELNMRSavZc/thWSCsvVfWjTeVUO9BDK3ftrpWexaODwNkKgWPoKb5cq/vPCKEddHLUq5Gnwa10Tb2sHcysgo/5Gw+oL9ysZcDTbo13e4VdM1SMjKwhudWnWubqJU7nsVEcP4l02G7ruzn00pjj3KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zBDhENs1EkY+1i1zSEQDPdkSJlEuM8PtoR7uqhiHFHE=;
 b=Pw+E2nQ4idxwmSBd5scCWa3JDZtpXDcWs4igym0fRRBR9WovtKdSUEI4PqkiJrx5JHuEt8fqJNh+jBKYheg3ZGcHdmSJlLqZQ8H6I7G7Lt2q9RCdm8LllH3ykBF8lM28Xhg+nUuJQjxx03dmY7YyAHX5degldu2SdR9MofLUaYeFNHn8CrjrRpKF7P+xSv/xkNkce7YA7SoLA7WIPgF6JkcmE2Z9hxjY/SRhDE5s07QWGNHh1K4f8RdM2Zw18kk+dml0uYCQCMSNb925RsfiZyr5O79P38N+HDD5DWLEk8KltNpfhWn0an2R6KWElJ5plaz88jBIBRQVMjQX5Ic/hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zBDhENs1EkY+1i1zSEQDPdkSJlEuM8PtoR7uqhiHFHE=;
 b=Lb9rtATDGBG5p7eAsiV5RyFUOr86HTyQMh9pdQPhPFUBG2GtfSJ2DoipSA1hd9Aep0N0dBrBuN3Zaol50fV3kGYTgP8bVgaMsXF4WjVzCn48NrS3JT9Fx4P+/pHed+CrS0quD+1m5f1a1fwUNZnQ5P/lma5/cV1GP8lnRzKKFH1yI/DxdCmw4Eaopihvk+OtHeNRNn4gm4dpq6fYC4Av0TJIO7Km3vQlMSVfjhGdgP6cfUSKA1t+nMEyBF20/RtWXRbqQK+uAiDN/1y/aZyJmDQb3hn/WQUjQWrfhLCZMT/DEgTLHG+lJdZIIUC3fZyWp/4lIsQlw5HRoOMvWVzJaA==
Received: from SJ0PR03CA0061.namprd03.prod.outlook.com (2603:10b6:a03:331::6)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 09:54:55 +0000
Received: from SJ5PEPF000001EF.namprd05.prod.outlook.com
 (2603:10b6:a03:331:cafe::7c) by SJ0PR03CA0061.outlook.office365.com
 (2603:10b6:a03:331::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 09:54:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001EF.mail.protection.outlook.com (10.167.242.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 09:54:54 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 02:54:41 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 02:54:40 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 02:54:34 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Alexei Lazar
	<alazar@nvidia.com>, Alex Vesker <valex@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Erez Shitrit
	<erezsh@nvidia.com>, Feng Liu <feliu@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Parav Pandit <parav@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Dogaru <vdogaru@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next 4/5] net/mlx5: HWS, Remove redundant MLX5_SET in RTC creation
Date: Thu, 23 Jul 2026 12:53:48 +0300
Message-ID: <20260723095349.1890983-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260723095349.1890983-1-tariqt@nvidia.com>
References: <20260723095349.1890983-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EF:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: ca3187b9-4e80-4255-d6a7-08dee8a072c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700016|82310400026|23010399003|1800799024|11063799006|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	DJeF4XH9BvniyjsnyH41GIy0WQ9ON2AkPU+Qus6EaEz5LgNjhgIBDqMy7ZV9ouNdTvVkRKcW5v3fYYNLCMLLV8uIAdik+tO5S8P5kOJqjStN7uvkiJYxD6m3z+4PiYu6B7XIOGtgFsQ6/+UOxEVi1mcGbtl1VZ66We3MKk4vbHEngz19PD49HvN/EPhTJlUUYAVCotVnforNbhen3r6tL8TRy6GXOWp6IBYXx/5jEll48P/raynDBoci3xUMDnpFiDU4kNJqcrOul7LEIFfbBfcvP05fFcVuJoWrWV/B9dxqbcGkGMBuNCW+SiMW/vSrCVan8br0F+sFBwMRZabhFYBn1M2gQdoj/12nI17dG6XX5yql/JaFkYVoP8u4Gq7RziP/ifq7OI4210hHdkQBUYcsE9co30qEneLRYLxIG3izFQacHkRmDV7q27whO0PcHnceaf23GgZ5RZdL61+DOzlRPyMa2useVgQ+71FYr8mqbmzdPQnep+68kvznAcMRucn5/16PjE7TOBgkoolwrRDA0Vr5znIxTaswaWExJ9d2h91/i16CgvfDFxn6tC9AFZO5SdxDWs6SEXTwH0wzilVhpHXJyez2zi0fmLTkNKGCqrqK7125R/HAZnsHqFVTs6IC8SDFdIxXc2+vYNx9u0Ev/ivqFvwdK5vhBfuc9+YnQfbhXxkIoDFz4JSJNOOl5jHQ7ceidb9PRnLqdQSYEQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700016)(82310400026)(23010399003)(1800799024)(11063799006)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EAkBBtXVtaGRuL91z9NZhjMnxsYVWkop1Ik8Xg9+QYBl/bmIjeHyBD0uO0pfHNqVN7cAAM0kYy4DhxZL/+0h8UyHsWTrCYumiiqSQ9sB3cgTUxYdJT8TjlA5bt637BG23KIDl/hJyJxBewg9GW1N0dVVUK/0Jxww3xSOfhyfNsSr2LuQUF8mPAB8WP6trRuFLojYvTptkVbwFBybQf99Nnst+MslUXy1d2ze2UlHXCN12fFak1g4MZr0TccJhpI6AGvn8xb2YmlSn+ejdZdezovNslHfmpqkaUzLjVS8dbt7G25cb5pw2l9GQIxAosCs7ykEvJSX47T2F7IiSr3x9EYbIQxIS81fNCMKC7qZA0dfahQtmbnjSq39fmjiqE446jOnS7JQHhqEK/sYvJbFijc86AYID5BhQIqb0J2n5fDqkytofzYXT15oIUwHnFj9
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:54:54.9560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca3187b9-4e80-4255-d6a7-08dee8a072c0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Remove duplicated setting of field in mlx5hws_cmd_rtc_create().

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
index c04ac970705b..c645b7e4bd98 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
@@ -398,7 +398,6 @@ int mlx5hws_cmd_rtc_create(struct mlx5_core_dev *mdev,
 	MLX5_SET(rtc, attr, update_method, rtc_attr->fw_gen_wqe);
 	MLX5_SET(rtc, attr, update_index_mode, rtc_attr->update_index_mode);
 	MLX5_SET(rtc, attr, access_index_mode, rtc_attr->access_index_mode);
-	MLX5_SET(rtc, attr, num_hash_definer, rtc_attr->num_hash_definer);
 	MLX5_SET(rtc, attr, log_depth, rtc_attr->log_depth);
 	MLX5_SET(rtc, attr, log_hash_size, rtc_attr->log_size);
 	MLX5_SET(rtc, attr, table_type, rtc_attr->table_type);
-- 
2.44.0

