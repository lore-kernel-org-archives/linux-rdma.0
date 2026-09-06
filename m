Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010052.outbound.protection.outlook.com [52.101.201.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9F3382F0F;
	Sun,  6 Sep 2026 07:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788678900; cv=fail; b=L29qYYMcFXTRpEvpTLUPYDgwIAhcJahd/53HD2b8Hp0Zf3oTFSOWXlVg/W7v9B6cBj11SLopD8O0cr1cBTwyamrc9G48vLtYSVcG5EuVL369C9rPMrJamqCJ4NyFlQxzNVgpH8HzAHMdM2dnMrprVQQ4L7c5aGxhY3b5hNoIv/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788678900; c=relaxed/simple;
	bh=3C43RGCoijl5pSO+jK9JjwUAhH2khtERvFURnNA+q5U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RieU5Gt9b52cHsgoJIRKQApUUcvYxFt6oLOhEqMcIcssF7CqzVJF0MxeFq5YvRs4W5F8ZC3eY/yl7rbF8tb7ZLwHw9IHc6N+gF4OlziPe3onfdVMUIciB/sUOsm+p8O8sFe1wp73K2LUh+eIPhZq9FJkU9cidC8HJHWMj8BvXAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bpVhBsXa; arc=fail smtp.client-ip=52.101.201.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bpVhBsXa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kPwVMAtgRnMgMTFJ53aw72gfzuVNXWU2L840OjEVP4je/MwZGn1NbhoFTxOgQXjW5cGgizfHEx2Bq0XZyGulEjGdBbTj3lm+yHdCaVKHrhBU18L1hVIGCdPfM0RGlH8fuhXgQsguDU3oItTOPOPG8+CZaFvzuHXa8RKEzwi//frTrsUq2b5uzODrf2YWuFS+mKypBYV6dQyuCTyOL2ZNnBbaET9YBZDW0HvGNVqgyvbj1wlSEzibQlklBIW70bCAzKk5U8YRHuycaLrKOcghQ5y9Fj6egn1FUbv2UTu9hQfCjhYL+7gJSqT4l+aCL//TZl+xxzAJHAwCyQGZgWHE5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ys6udKrioHTsVwcyOTFWipQwoGwGZY6EuzE+v/TWBc=;
 b=lpALhcmjIn9TgerjMDCaumE+y8Bqyys3s4Dl5bFmBysHomJNYyuOHDZZExctWCuBnkY/6295BdopXXXLT3rNNs6LnqlksV4YK2LkeJfG+ORznwTXQSCeMl2htk4u63GoeZ6WQb/H+esTS+g5OKbthnjB131S4RucKrGONeNjWtr+iNoD3WlCzDRhCJ5cIIlPx5jF7Oz7vBe5zSft0JUzqRjFe6PPH9LMrrXR+m/96HO0yjC9nyf6DzlPYKilAphPRZ3urJDWFySt5f7klzVprzYXFEJ3alxT4Jgnw84ehs3wwx7YX7AmyDZFez/D8pmWVsez5IenXA0SP1aZ85vUdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ys6udKrioHTsVwcyOTFWipQwoGwGZY6EuzE+v/TWBc=;
 b=bpVhBsXaMFI+pLksGA3mt6QT0jEXTjlqdDTiO3Q8lXBeVXEr8iqmeJMgfAB30gxZEw9Re+vRUWk03ZmXEr/p/Aq8eYjj3a8rTiDFP1J3d+PCpx7fCI+kLaB2Vr1lMhxAF8gH1ELA9u7NXO0W5zls5tO+QMtwYELdgNRtx4nMo7nbd2A2AC+vHZKE3H2yIv47w/GzwIm8FVIxi2OiKNf7VDCr8p2104icAInH/dMCFdoqi6llsOLSL8ES8lOTXZ9k4XlI4xvQjwAxo+6rSqNEsRC8DhXz2V9ZSB7+JIrMnBvSaYuSIOxyPlfkHsCyjgFszUlAG3jEFY9mCZm8F8tMzQ==
Received: from DM6PR02CA0131.namprd02.prod.outlook.com (2603:10b6:5:1b4::33)
 by SJ2PR12MB8883.namprd12.prod.outlook.com (2603:10b6:a03:538::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.8; Sun, 6 Sep 2026
 07:14:56 +0000
Received: from SN1PEPF0002BA4E.namprd03.prod.outlook.com
 (2603:10b6:5:1b4:cafe::af) by DM6PR02CA0131.outlook.office365.com
 (2603:10b6:5:1b4::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Sun, 6
 Sep 2026 07:14:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA4E.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Sun, 6 Sep 2026 07:14:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 6 Sep
 2026 00:14:40 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 6 Sep
 2026 00:14:39 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Sun, 6 Sep
 2026 00:14:34 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Maher Sanalla
	<msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Parav Pandit <parav@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net V2 3/4] net/mlx5: SD, unload reps on shared FDB create error path
Date: Sun, 6 Sep 2026 10:13:31 +0300
Message-ID: <20260906071332.3759199-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260906071332.3759199-1-tariqt@nvidia.com>
References: <20260906071332.3759199-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4E:EE_|SJ2PR12MB8883:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c1c0b4a-b982-4ba4-fa45-08df0be68daf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|23010399003|36860700016|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	fZrlc3EpRHoOzy5TK8ixn9V63mXwJ7P0AnTaegRO6mA02sQqvmGDDMI2m8IjoC/9xpHqKwiJR2K+v/wOmmhfXg724HydGepA6jckr140nwGuk+ylLcoerbErippOIj4KDUg3IOTLtAsgV9Q2nkTWp3yvoEJTN7KKe7u/7b3bZyKNXIlrCF1nNGfh9oKKDjMOGMWccZ6PQknskzA1Rz6OevLAZM0zGCouzv8+B7rfAPDmW6eqcveWgAKLnxZbUpFgxvVGJ1d9VFTGAPJiHru/+NwxbIOV/pEDYR6UVWPxDqpRaqLGMXS31NSFrhLbZqgmk9qMlUGN58oeHMlsc5pKiqDJIbeNCmuWvEtg0FJArExrKXCzkMNvlWvd6Ehtw5OXvTGI7RMXAPArZTg3F07erqn29PR5NEWoxGzsr1LfKtBE6V3epNreOoHJJZoiVWFf+lfIbPRj0LdTkFfWVqM0YYKC9Jx9vZaxioDP/WywaBdZQbZqngsJojfXmYXyLGbJu8L+ZD04SKyZdWCERd01BIkQEazYMvLbEV29z+grap0PUihXQB6KpKbB1yWYhtD+pU9vO8TasqsN1RJWr7rIhIbWL5eQK8LvEUMhniCEuGDNHjRNwueW6/xc6TIZ+4va3ALE6KtrxC6OWkTsi+xDBLIQw6CSyCiyfxN6VCNpI22J8I1mnvn7xEghDVKrZZKAuNw78EWUoHISS0WNCAtIgw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(23010399003)(36860700016)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CKPPac8JUc30Eh6/C9nKTqYLVlNHPyfsxJTvrUn1ZaNngxHwvzYy9SmFrP5vtj+3uL1x5yasp2SfPVxXpirrzfyT1zQU5FtO3UQ7kUg8vki2zJq2KitTmbtRC83MQ3LbGA8bXKTIjpJLNaM8xScpw330KmPiPka3gTRDD0BgNXTz69GCwTh+jIv8lLapxjSpUIuzbGXVOdYnOab0kwtrGULMAoeUdPMA7ZtyP0Pu932QMmhJzZyAlBFdBOLf7+lyZKBn6dzJwVggxgnREHUBbawGJb4a10XZkBlylIUCZr1nUKE6nyHUHtKREUCMNGZL5547i1KmR+40zOAMPw5Wbfq9pgmyt/ZqmU3m4nsHdIxkkNjsVXnVyOgB7DHoOFVtjr4EbVr3zgt8VdGFH2GwIZDGMZBJf49sGOXd96tCez24bVq5hw5x4svsxmNB9WvV
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 07:14:55.6046
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c1c0b4a-b982-4ba4-fa45-08df0be68daf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8883

From: Shay Drory <shayd@nvidia.com>

The teardown path unloads the representors; align the create error
path to do the same.

Fixes: 68c2dd59a6c7 ("net/mlx5: E-Switch, Tie rep load/unload to SD LAG state")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
index 6b4ad3c53f2f..424040918fa3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
@@ -270,6 +270,7 @@ int mlx5_lag_shared_fdb_create(struct mlx5_lag *ldev,
 			pf->sd_fdb_active = false;
 		}
 		mlx5_lag_destroy_single_fdb_filter(ldev, group_id);
+		mlx5_lag_unload_reps_from_locked(ldev, filter);
 	}
 err_add_devices:
 	mlx5_lag_add_devices_filter(ldev, filter);
-- 
2.44.0

