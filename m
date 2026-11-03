Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.22
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793726001;
	b=RuZSDlH92A1ld/452hbb2gx06klKNvSRvChmcPl1zDxleCXW6G2dlteK8PeuCpdz0p5v
	 A5g+nwTt4ERa/PdTDbcWw8ulkpnkLwUczQAxNioptvW8hx46UWhml+DQtrUyOjyXFEpN7
	 OKr8JwLoAPODEU6URcGLi/LqXPmK1zsG4uHe3hIh5+hE2xq4zaydH5LKA2fBrIMmXclSj
	 EGhTsbJW5oFVqfRGaBo7oAxd61dRisgBM4QuutJD2IK2k2dyWK0H7muVq6worz4N8IHwM
	 1E2jDWvBBj9SHJsRU21XrZ4Ojspf15NWAPVG2/S9CFCZ1nRBSZIxtxGJ8QQCB8yv/4w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793726001;
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
	bh=q+lOEGiHK9SCOnX6ryxUSG3cMJAReApXNcBpmu81uRo=;
	b=49oANnUNw4sCCYP/iUPmiL4N3H5mAbtU427W3IWXlmcAmoaIZU2Cr3KONsoK4jyJa1Et
	 k4wU+Cco508WVNiym/iIKba9dxTo3ft/umHYyQo0v+WcUtuqF5KNhGwsOVGO3uoPItI7h
	 pWFH6e8FapJ10REb4g5idLC9ZA7/L9kLIbPY5/tLmRXraflh7mI6HQPAJbJIkKdyW/lO3
	 G+J5Ik/58RtpjS/d9NYfp8hawcDOlxbIIPmZ5RhtO8BdfQjHF4MJUcou3YFnzt5UwiwSn
	 3CJxEcdyeV5iIyAs8u1FUs8PmbsuHBqtDNIbcTnhePKCw218LzBNZ3M4B9sY6AG3PZw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Wpv9Hxh5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.22
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011022.outbound.protection.outlook.com [40.107.208.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF7C606EE94;
	Tue,  3 Nov 2026 17:13:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7EF7C606EE94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Wpv9Hxh5
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kw2s2+h+A98g2C9pTs0NXTIUGnS018V/t8WVMkYl+YPbwmrioxvuyW87JFah2SGMcHSaQ3mU73rdOvAyK6Avegi1wsos9l/D2TKeyDw00/y8wNp1Ht8tP87KDheppydx12toW/y1cAaUGhmzVYleSHJCwqu34rCONmBwcU0/EpIh6MJBWuBJZIklFDubL/wZZm4W2GiA1EPPQDP5Hl7AdDCjgAfs1CUUjSX4MNuqd6VZNuB8yt6BaqH0dmmzKLdizaxDvHF53lEB5u8wnj7MkLWo/JWU5xjegYEz74jNGON1VTXYMecOs33esX9dHOhVriKOZvidTlzKenSWDxOPCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q+lOEGiHK9SCOnX6ryxUSG3cMJAReApXNcBpmu81uRo=;
 b=kfhOP6VshxRl06eXXqHERcd847D7kQ3amGgOFdgfDklcyK0ldz5mkYF9Lv/J/iIVfwjndXg7xYHhV5e883Hh8V8FbAqqEkpqr1TmwLcUTfSZy8mo+CCCZApc+uV/YXuANWHfrP5wipnn5c+IMwaksxl5rMHDh51R4GOB+rE5e6FfTRDWI0P1VxE9z4h9MIFigfA43czN0uEBFPFx6xjqHOptpMq/B/mu9/bRrJxYK6dfXLsAUCkHKY26+J36M6HF5Wyz2CMF89hRHZqOxyebJJvglTHM2YT5H66CYV1E9SSt4Uqqk0I4gViIT8GIIrk9AW/tBb6g/dF5cmskzSecog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+lOEGiHK9SCOnX6ryxUSG3cMJAReApXNcBpmu81uRo=;
 b=Wpv9Hxh5BINzRr63DvdDaQlTkBRt6MjYZsSpaTBWroYyWvjnwv6NJxF5OBTiT/RFNWY/drEwuoChLmRARtqfM/oAa/Z6Agvk9Dydusi8mGF79BOnxnPZtSt14rgX8D/9MmMjGolip3e8X8yNCY7M40ifi0N5P3pWNTol9jN7KvTO2otsZ0yQk6lB4HoeggPUl1jrAjK6TTt7V0taKwI/YMplHUgPnRdAScV5mq/OpoVzhuOV8mKe7gpbrNJGWo5ZRQ1UP9PEgSOvJhBC4ygt6DLGqpqRGtu+c99LP6fVnoczT7IiCteOoqMTz8Xu7L9MEVU1rS6jUSkLZLj3o/aw7Q==
Received: from BN8PR04CA0043.namprd04.prod.outlook.com (2603:10b6:408:d4::17)
 by SN7PR12MB8103.namprd12.prod.outlook.com (2603:10b6:806:355::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 17:13:14 +0000
Received: from LV8PEPF00000068.namprd03.prod.outlook.com
 (2603:10b6:408:d4:cafe::39) by BN8PR04CA0043.outlook.office365.com
 (2603:10b6:408:d4::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 17:13:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 LV8PEPF00000068.mail.protection.outlook.com (10.167.248.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 17:13:13 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 09:12:30 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:12:30 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 09:12:25 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 08/15] net/mlx5: LAG: replace fixed MLX5_MAX_PORTS arrays with dynamic allocation
Date: Tue, 3 Nov 2026 19:10:02 +0200
Message-ID: <20261103171009.563034-9-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261103171009.563034-1-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF00000068:EE_|SN7PR12MB8103:EE_
X-MS-Office365-Filtering-Correlation-Id: d96db8d8-65c5-4ac3-609b-08df39cdbe85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|1800799024|376014|10067099003|22082099003|18002099003|261102123227099003|261009223027099003|56012099006|11063799006|261021121427099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	Xd2qzu0c3KCojC8E48nwsr3Xx4HgSmi4Ge9EKdVBQfBasoejm6OwSIcEXtX0opmFe03oCrEROzPPJO/Q8VOv8toR4AIe4KTztxonCucTRJaJjI6sma4IMrrD2/rO19XzoBZa0pIs66gK2wicniCUqHMAZLWUNEfGyKVoSbgxCwXpgdQspQhSmDvb3oAYDBgaVPbsAqYrUSPEuQ4il6tL0qynEsshysOYN4XEuNH462sXJeBQVnEJxNJuDfhbEYDhuHKNX6mHRJW/hZIiv7dUDNaR34kNy3PsumBaZPVNW8Z4v0dQPj/HM2sI1k7jAE4gqi0GmfqLR7/bFzmNYIjdOM8eM4wcA7m7WHkjGO9eddlIg2oT8CtW/ietK/zhkf5Y03zB6kJ6fbosuZp+KvM3uIgfBr3UclXmjwCShnBlbkxt0wIkqIbNw6PZuDKYqzwF3sp11qEFNiB7sbQsEwVT79nkwC2+Mnb5ZaRZ55McfC1tRk9kemoZAKEGXIxTrAESFZ3mIphQ2TzY62F5GCewpLmo361/1+aCnQOPWSkmCYh4gxwlOpnVGpQZuSwDVzSCO1Dagc4UsyywujfKPrMWBLUF8BhlZsAVWdjFQQEbrRJ/mPsNDWJjHN0wSxUtP/U4BtM1+/qY87eHT95HkSWkRUWCPI86RoY8EJFzYAs/oJdEh7l/R6G8R4fWOeyhvDPei7Cc/oB+p9t2cQ4y2HXbwA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(1800799024)(376014)(10067099003)(22082099003)(18002099003)(261102123227099003)(261009223027099003)(56012099006)(11063799006)(261021121427099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GQ3ZPP8Q1ebSESQG16MSy0iylpwrQAPxrH5UYq7DJezBVkiI3agN9fRMBFcdVswZBTASDzAe98/DVD4BdMKbAzE1sKJc3NLiwl2jxgMukGghgf2lXzJCewllDK5aDce3OaPrKYZY+/alwpdyZdjjt026gd6ZmbigZX2r5ybhqF3kd9ohxDYgdw33op6aLVb6bPFeXRCQkXHRQf0b908rGuBsJQz1FlXT1r6m2OmAdqjul/2EpJhUqtG7LZh6w/wqzZmJHVP2Ho9HerAzCQoCSMO0K/6eAYayWYXqwCLJCtsnCyOjBAjKilip9mH1R3Sww68hZu2I0FvFKzUgpBzfQeNwk0j/ACi8++CumepRKYwE86gSfZxXFHy9mHdFsF20uZbs9CzOOQ4Qygfs4GCGrm8ZR122hCCL2qkKZJ9RD4J/se9rJfNkR8XOzSC/F2rx
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:13:13.5550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d96db8d8-65c5-4ac3-609b-08df39cdbe85
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000068.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8103

From: Shay Drory <shayd@nvidia.com>

Converts two fixed-size arrays sized to MLX5_MAX_PORTS into
dynamically allocated pointers:

- lag_mpesw.pf_metadata in mpesw.c/mpesw.h, sized by ldev->max_fns
- mdev array in mlx5_lag_query_cong_counters(), sized by ldev->ports

The cong-counters array is sized by ldev->ports, which is fixed at ldev
allocation, rather than by the LAG mode, so a mode change between the
allocation and filling the array cannot overflow it. The query loop is
bounded by the number of entries actually filled. A virt LAG is not
aggregated and queries only the given device, as its members are not
LAG ports.

Thus, removes the hard dependency on MLX5_MAX_PORTS.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 15 +++++++--------
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c   | 12 ++++++++++++
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.h   |  2 +-
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 2b76d119cfa6..b873eb91fd0d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -2917,7 +2917,9 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 	if (!out)
 		return -ENOMEM;
 
-	mdev = kvzalloc(sizeof(mdev[0]) * MLX5_MAX_PORTS, GFP_KERNEL);
+	ldev = mlx5_lag_dev(dev);
+	num_ports = ldev ? max_t(int, ldev->ports, 1) : 1;
+	mdev = kcalloc(num_ports, sizeof(mdev[0]), GFP_KERNEL);
 	if (!mdev) {
 		ret = -ENOMEM;
 		goto free_out;
@@ -2926,20 +2928,17 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 	memset(values, 0, sizeof(*values) * num_counters);
 
 	spin_lock_irqsave(&lag_lock, flags);
-	ldev = mlx5_lag_dev(dev);
-	if (ldev && __mlx5_lag_is_active(ldev)) {
-		num_ports = ldev->ports;
+	if (ldev && __mlx5_lag_is_active(ldev) && !ldev->virt_lag) {
 		mlx5_ldev_for_each(i, 0, ldev) {
 			fn = mlx5_lag_fn(ldev, i);
 			mdev[idx++] = fn->dev;
 		}
 	} else {
-		num_ports = 1;
-		mdev[MLX5_LAG_P1] = dev;
+		mdev[idx++] = dev;
 	}
 	spin_unlock_irqrestore(&lag_lock, flags);
 
-	for (i = 0; i < num_ports; ++i) {
+	for (i = 0; i < idx; ++i) {
 		u32 in[MLX5_ST_SZ_DW(query_cong_statistics_in)] = {};
 
 		MLX5_SET(query_cong_statistics_in, in, opcode,
@@ -2954,7 +2953,7 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 	}
 
 free_mdev:
-	kvfree(mdev);
+	kfree(mdev);
 free_out:
 	kvfree(out);
 	return ret;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 6e3bef276611..584436668a5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -15,6 +15,9 @@ static void mlx5_mpesw_metadata_cleanup(struct mlx5_lag *ldev)
 	u32 pf_metadata;
 	int i;
 
+	if (!ldev->lag_mpesw.pf_metadata)
+		return;
+
 	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
 		dev = mlx5_lag_fn(ldev, i)->dev;
 		esw = dev->priv.eswitch;
@@ -27,6 +30,9 @@ static void mlx5_mpesw_metadata_cleanup(struct mlx5_lag *ldev)
 		mlx5_esw_match_metadata_free(esw, pf_metadata);
 		ldev->lag_mpesw.pf_metadata[i] = 0;
 	}
+
+	kfree(ldev->lag_mpesw.pf_metadata);
+	ldev->lag_mpesw.pf_metadata = NULL;
 }
 
 static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
@@ -36,6 +42,12 @@ static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
 	u32 pf_metadata;
 	int i, err;
 
+	ldev->lag_mpesw.pf_metadata =
+		kcalloc(ldev->max_fns, sizeof(*ldev->lag_mpesw.pf_metadata),
+			GFP_KERNEL);
+	if (!ldev->lag_mpesw.pf_metadata)
+		return -ENOMEM;
+
 	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
 		dev = mlx5_lag_fn(ldev, i)->dev;
 		esw = dev->priv.eswitch;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
index 5099723ba0f7..6296e3edd38c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
@@ -9,7 +9,7 @@
 
 struct lag_mpesw {
 	struct work_struct mpesw_work;
-	u32 pf_metadata[MLX5_MAX_PORTS];
+	u32 *pf_metadata;
 };
 
 enum mpesw_op {
-- 
2.44.0

