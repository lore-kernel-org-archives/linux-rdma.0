Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013030.outbound.protection.outlook.com [40.93.196.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5323AB496;
	Mon, 10 Aug 2026 09:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354076; cv=fail; b=qDPTrxAzEm9A8ScQqmy9RlcyrtAV5b4mEJR9XbreNdLknvPIAS8eWvMOIZx7px54L2Y3AAyNKgdEHh8vWHyioIe9g7/hSu3KpvCRpPWgMMZV/qDvaBZIKw0Oi6PMRnV0swmLqeaw4zVdvRTBsFUkxpixHUjosihUJuZvHgRMcMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354076; c=relaxed/simple;
	bh=BqdBky2MpSvkGrYn8twM8y154qItT/kJtjkfI/3F3vE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u2GpVlGkNk2j7M5G9hENLXRkIaF6e/GxOUzJypzIHziVCQpVBhuQ5kSwOuncnA/qDpT+AEVpQ6qmOWs4pjXKSUTK2gwJZ/tq31uqf2WewRPOVLtNkC2BrNj6j8JZ/phZVC8YnGyJ1+1e7hrFZDf8ITdHFvPvd2/hnQmLgCX/I/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NB4cFGTb; arc=fail smtp.client-ip=40.93.196.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NB4cFGTb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vxaza2TL2zKAMQTaRn+NXVIzHzbtxFehlAX4dcv9lgZsCTx+xZwQ5EZq8DY9A6ToAavNSxWYXE66E3eG4Oo+l9ULl13gpzTdkNiWd04jfsYNs9129nqslXHoD5rFCFbFWcCE1W1dNg2jt9M1iyJHQGMQwUCdlnfKouIFRPSQAxXAy7bZgu9oZygchlYt/L2WYDHW2cR8MT4/Y3F/V5+zAeDaEdTCcQt772HoNU+rXcSeH2t6ilq0KXJgp3VQhaaD2kHSkJnSJijlu2DqOJiMMegGm4YX+9u2kR3BgH5codHjkC3ZKJvN2jOE8gP51dZVJwY89mA1ZpVY5y1Ds5FUsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=waAq3pvXpaIpOkJbZrJVLU1YE3sH/BXHRAoWZqWHDQ8=;
 b=LhC+it6BNfZsFhVAmGGl/EQKpTnzHnA0CS7OZfRq798/4lcisBzJAPdw3O3/91c8YNrrKm/qwP5bj+MdTRm/UqAUIxLH+oFckT6qP59rZYrePuiL6xwExiqJD6MWHSwrHI+7Ans+mhRpa1BH4uQpQLnzJjrAEIHYHElu6QjtqoTQqI7yBV1F0NvrGncHfYVGnv1v7P6M4cpK8cwVzR2g+3jp1TvqhzEtalguOmxPxV2NmgJV+R76/3JSBWfyxPR+jpiBgdYuF9LUt5CYzp/gH/kV5v2g7zulXHPml7LEbkBBORliRfDjImLRLyC+0qcxb3XrXvv/uOJbL0X+51jCyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=waAq3pvXpaIpOkJbZrJVLU1YE3sH/BXHRAoWZqWHDQ8=;
 b=NB4cFGTbJ7BO56SRUayl1IlcQg1UeWgiReC4Wy9cTSJNJR16tNBxnz4CkUmln5LEtWLdZYuGtzHIitDCIhPsO40K/eXNlpYVCCdl7LtuGkO5m8PzQKHdgR5BRITm7ve22i9GsTRZUc57+G8yJZtJzYPuNWJdAsWZsug17s6S31UFKG/ZgnBLE2jeN6SX6jcsfKOJa7MpUN6PQQkhIusQMytAzQwOBnDgZsPA6kDQHVvd900IcGDRyHWgMYtKZp9zrIkpS9P0C6IhlJB1enze/BVzrJV0ru3EWt6A1JEFRGxKxOf11eYBpKrL2bv9yQO/6Pjn6Tgsub6UBVO2X70PRw==
Received: from BLAPR03CA0063.namprd03.prod.outlook.com (2603:10b6:208:329::8)
 by DM4PR12MB5892.namprd12.prod.outlook.com (2603:10b6:8:68::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.25; Mon, 10 Aug 2026 09:27:45 +0000
Received: from BL02EPF00029929.namprd02.prod.outlook.com
 (2603:10b6:208:329:cafe::13) by BLAPR03CA0063.outlook.office365.com
 (2603:10b6:208:329::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 09:27:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF00029929.mail.protection.outlook.com (10.167.249.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Mon, 10 Aug 2026 09:27:45 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Aug
 2026 02:27:24 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 10 Aug 2026 02:27:23 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 10 Aug 2026 02:27:17 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Alexei Lazar
	<alazar@nvidia.com>, Alex Vesker <valex@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Erez Shitrit
	<erezsh@nvidia.com>, Feng Liu <feliu@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <jacob.e.keller@intel.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Dogaru <vdogaru@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next V2 4/5] net/mlx5: HWS, Remove redundant MLX5_SET in RTC creation
Date: Mon, 10 Aug 2026 12:26:29 +0300
Message-ID: <20260810092630.3137666-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260810092630.3137666-1-tariqt@nvidia.com>
References: <20260810092630.3137666-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00029929:EE_|DM4PR12MB5892:EE_
X-MS-Office365-Filtering-Correlation-Id: 75a7503b-3191-46f0-7bc8-08def6c1a2fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|7416014|376014|36860700016|1800799024|18002099003|22082099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	lsd6FdT63fELhtjXjI0rFDrb4Xmcmd90dM27T3BdwL9N/q8XMhBrc0RdSpdOzYVYRt3snmkj0/Fa8pLmH4D+GgHRgD+Wehx4oq3L6TFeGyS/U4e70beOQXOwqsCeVSIOoGc2mz3Av0SDNbIGVuuYkqVs2eKSIkIN1wB41UIFfDmxzOh+DCS90pjysm8Wc88sQfR/xINZ42CfQh7/d+rWZlWgZ8zFgeMDT90llvb6+/naw8SI5ZfDNP6k2HrmesJ1DaEGsSynlICmrRZRmz5abdeULZXKDlyND1IF1APOEAJdm5QHxGXvw47keE7WMc5Ek4Mb8SItcE/lu1gLxNu8MEUcCxuFFHrkjmuFOvd4a9KYqBBwrkuIYA3LPhY/sRoTNmtLQX3XLIWcsxvYPMI/PNLKLrM+fMEDPj8CVLOzJ4pJEK50JUtHUY3pRyjqu8NRfTZARomSnVz52mt8nDGxIu27SqjWHSP8HnupwuxZg1o4SifUvvWlooTYoilhEzDaMhyCYss1ghzkS96vfAL6U696/3WIc4cxI3xVOxYmnOttt7iNwgESRvqSMUntWJ5VIZxP1ntERr2warD8ljaB+Ufm28cnTl1vDrRA1XgRwqWkRHyb3ihlKGmUrHztpEC6CTuRj+/fo8dBXSgm5wrdXDMHoc8/NDuzdMDHurcJinb6n+fKyhBw8tyjNZ/SkTCseu9BfMku6WOL0gsT/rsFSg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(7416014)(376014)(36860700016)(1800799024)(18002099003)(22082099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MUyzbVBcNhcv9i4svGDYgzgajIA3Dsf9H/KBcLi3tVW7VWLLdisY9ROvlIO2gkF9tTPQoBK3dsFJlc/DdvNqjjSBwBXqzl20mWya4IPaMlXUMTvhlvrOEGaQoaAzesEgNk+unOfpeONDBzaPky9t/yPAesYIqgW2j5WMkhRPyZBHgXfTkeE8EHJDP3FxC/JvDb2ZgEHkss+D3u6UFoAqPVJhFzeUp54ZRu+BsTLwx9joRP595ByfH8Ff3sAP7XEGotGtdvdd6oSZZqaLeCyzjKCOsN7RskJeHMGejNgGzUKIli0LrzHc5qslWEK4x02xycTLNrvbu7C2qzVRiwdVzxkpfZntM/oEx7LcySRNydwvou1Dwnh15iQuvgM2Y7tnTLnzLmIVfFcw9Q+FAp4Rl/JCX/NzBP6cQKiLiK9d0GBXF1eE0cVvdpcHHcxVKPi+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 09:27:45.4822
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a7503b-3191-46f0-7bc8-08def6c1a2fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029929.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5892

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Remove duplicated setting of field in mlx5hws_cmd_rtc_create().

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
index 2cdc03421433..3782d793550d 100644
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

