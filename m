Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011012.outbound.protection.outlook.com [52.101.62.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AFB3E2747;
	Sun,  6 Sep 2026 07:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788678903; cv=fail; b=p1FWJ8rrd0XBm4zu9m5gs4kp+d5IVZ3Xlw0YDclRjm9IaEM+M0lAjovj9YE8goOADhnMHPv5KHxn27JzeksySEU0HYBYlbEPZWAWLYITJPx5Ll1OZrdfdPvmxoMnA60+v7c2i9y/iNsYBCP1nUXB+HkWs6C28AWqm08DR3ikOXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788678903; c=relaxed/simple;
	bh=5mQr5VFnELFhewAyxS51nhzplhS7+FZUqQCbzizsFF8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r/9wHkZGRq1KSgJSW93fz1qGAPYrpdzoUKcQ7PauRciE6vPuA6spWy3tR2/0WFhuOIDb1b8KCLuCxMMLRG10ws3OE1KY5AqZensKJ7RxQcQB4dB6bFRqk5+EUiwAok1cNg71WKhsPyLn33dw2kTNag6X1iB3Of2mUbG/IFityNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D/40ebjt; arc=fail smtp.client-ip=52.101.62.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D/40ebjt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wGpwj9l4V25Vzid3V2LsK6GV2o1zVIEjPuKPdHen+Zdec//wk6LcvMRvBq5wd+l/vDNdobNfxnxP+bSxccru3iGEd2IrqmtprKqhRmE7VE3zhJl/hFP77J2+qM5f0ibZ0+q6MthyfRILjk1T+OUXB7GPqgsr6SklbImzCsCYPq+BsYYqid4HoX7xjSlSvgBOf/B3/kObFZeoclC9zUOOAmHduIMIeE4rasGkAuZ3GgKBYqy/1dTAzW6h10b3GBImEBbVxFvB9x14WldMafundQN7fz8ghGa/KJ4Hzoux7AG4kNj/Vj+r6vhKKyhlNG8q488B8aQwsSC+IjzZR0URVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xftvjPCm+T5iMKs81lqZK6BF5KbIl1o3U7HEfGQVAmU=;
 b=mBP+iCBD9qtDpagZLt/fzqUCNzLy62b+2Ky+iE1e9yUGvGAfli/MvE2G7FEyFxLQ1bA17/mEKxNRsH9gk5NKIuE5Y/3/Qoq+ljmkgqWye3+au4FS7oU0M8a6dYQ4Ur9EdgITB6oCfvQQmLmSDeGKbXA9v//ld1xAXj57vMm5KYjoHCPqYYMOENBPAGsGYxeg6TD1CslYH5EwSzZLeqQ0M5Iz6feQR6Rlo+1AHLlyiks/knMU+KsA0cQHcpLxEM7Rp+feeg63NLrokPn12yeIokgRO/XG6+aAdK9JWmXIIi9RtFMhlHD8ktDkYPmR9D9U40Jt8F5kwxvMmwgp5B/e4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xftvjPCm+T5iMKs81lqZK6BF5KbIl1o3U7HEfGQVAmU=;
 b=D/40ebjt3GScmuQOwoot2GQm8HXv+oYzWMSu4Ct8l3UmVYTOmf6IzePsWjb190PbKVuOP/DF86Zj2Lz1YUGlTxq2qScCrkCgjRwxFAfdbsuofMxSslEYqmZA8KVU0UqzdhQ8CGwQGSe2/PN6lJffybNQc183tWxtklfK+1l0GoRiK2001QpGCODiUI2/bgmMZL4Ppu2yI+GAwDHbJF0T/l1eXSEvCY5WodwPAsr4dii0FAHrCxY7lcot+s5AKbPdox8duk7r54s3zjSffeFv0RvhzGBd87DASikRbj1kUp6yU0zwjBrmQ6BXCHG6/oh0ljT5UXVzl13hg/txgXZcbw==
Received: from SJ0PR13CA0209.namprd13.prod.outlook.com (2603:10b6:a03:2c3::34)
 by IA1PR12MB6577.namprd12.prod.outlook.com (2603:10b6:208:3a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Sun, 6 Sep
 2026 07:14:56 +0000
Received: from SJ1PEPF000037AF.namprd03.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::2f) by SJ0PR13CA0209.outlook.office365.com
 (2603:10b6:a03:2c3::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.6 via Frontend Transport; Sun, 6
 Sep 2026 07:14:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000037AF.mail.protection.outlook.com (10.167.244.187) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Sun, 6 Sep 2026 07:14:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 6 Sep
 2026 00:14:45 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 6 Sep
 2026 00:14:45 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Sun, 6 Sep
 2026 00:14:40 -0700
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
Subject: [PATCH net V2 4/4] net/mlx5: LAG, reload IB reps of LAG master before the rest
Date: Sun, 6 Sep 2026 10:13:32 +0300
Message-ID: <20260906071332.3759199-5-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037AF:EE_|IA1PR12MB6577:EE_
X-MS-Office365-Filtering-Correlation-Id: 68232021-123a-4cd5-4296-08df0be68dcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|23010399003|82310400026|7416014|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LiD0wkbrkgqDf08p9DMEZ5jz6wQVRKdxaWy9o6S7ri5flVetZMmouPSQOjFDBaiFgAzBy26SB6GwMWYIPGNQAR5xQ88CnG3BCjdCmVQreEDgKH+GOpSLFCyFYjSdyn9rjblgZT5IJ52gjAqQJ1ZRO4SmgfQhHMj8ljkaqKeL6AJOvp9f/yEcoWGkvL5nr2DylGcaGysyMnYef3qhrXpTRsjHt2aRQfCRQzLqLwdisR+oPLYtf7uNnTT5oTWbJlMMG1whqrCjscahyFUFMk68dAe+xul7WXXyGBgK6nDqfNwJjyYBYlxmprC6FLoepH8bPFPB+tJl7nvI7HW2arPACm6yi4vfDhA8uW/1t5oM+Z1TwUc7nDikaIsMiPrVhaGv6CzYWgSBI+dcFdZOMNr+cenuLEgYF6hsULveAGTRxMbigGzeGsTpcaQZLzfic3PiSYutinMHUq74UlzNxpX8SgRpe/iR/Esh66qpqRSjSXU29DgWMWmIStEFJ+2LbYn/M2iG8ASbcYXGprMoW1S2xuEWqcR382ieoz/0xhAayqxh4enTyv6lJIUVXzUjw5MhiNH/v3xSY96hw0lR7zqPGE7U98IonendavwzP3OJG2ORB5i8UNaEvA2md9wHjtDOtqsQhK67txTO4ZhFSqmJrLTpzU5TP/FLhfVfe7Ku8Xrt46vBMdz/DttuFTecdI0KKO2AGxE9EmEEWyEzuUy3HA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(23010399003)(82310400026)(7416014)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lnT/M0lkoR5zBbG2uZVLuMo6qiRFG/a+tpq8GE6VLLxMJrJi0mPInV7XKP405luale+oqOx1cr02re09dCmhMA/NHdMn88AX2m/BLDjG6KkYfPzoOrBjBySo1fL4SgvqTRRMnyUMYKstG9N1xPd/Vt/g79ZZxLzbfpTeuaNzOMItYcvKjKT3vkdNcjX3mqLGL7U08UxZHL9Bg4Ut0QVZ/cYFdF88LsgJNzWCwcyBEsYUePyxZMFoekTeN2K8ci4IAyFWDI9XGycBmUeGTKjKDmMyl4c4lHhryNh1x5eaM+Mk+zJZ8kkGqy41gzRiUCeXLKxuk4x6eQf4V9fANMoXeRWVX4haClsKx7VdpXnmxO4/LuG9FZLXdCyUrG5cXt9xEUc8hdFQJTWIoXb93Y3PvQ+x8qWA/h0ufxBXH+ig4Q3zhs84yXHVRyXZvuFwqkiR
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 07:14:55.8889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68232021-123a-4cd5-4296-08df0be68dcb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037AF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6577

From: Shay Drory <shayd@nvidia.com>

In a shared-FDB LAG the master device creates the bond IB device; the
other LAG members do not create their own, they populate a port inside
the master's IB device. mlx5_lag_reload_ib_reps_unlocked() reloaded the
members' IB reps in iteration order, with no guarantee the master is
reloaded first. When a non-master member is reloaded before the master,
it tries to populate its port in an IB device that has not been
recreated yet.

Hence, reload the master's IB reps first, then every other member.

Fixes: 2b204cdb1206 ("net/mlx5: LAG, use xa_alloc to manage LAG device indices")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 44 ++++++++++++++-----
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index aee5ce471eba..4984c812268c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1263,25 +1263,45 @@ void mlx5_lag_remove_devices(struct mlx5_lag *ldev)
 	mlx5_lag_remove_devices_filter(ldev, MLX5_LAG_FILTER_PORTS);
 }
 
+static int mlx5_lag_reload_ib_reps_idx(struct mlx5_lag *ldev, int idx,
+				       u32 flags)
+{
+	struct lag_func *pf = mlx5_lag_pf(ldev, idx);
+	struct mlx5_eswitch *esw;
+	int ret;
+
+	if (pf->dev->priv.flags & flags)
+		return 0;
+
+	esw = pf->dev->priv.eswitch;
+	mlx5_esw_reps_block(esw);
+	ret = mlx5_eswitch_reload_ib_reps(esw);
+	mlx5_esw_reps_unblock(esw);
+
+	return ret;
+}
+
 static int mlx5_lag_reload_ib_reps_unlocked(struct mlx5_lag *ldev, u32 flags,
 					    u32 filter, bool cont_on_fail)
 {
-	struct lag_func *pf;
+	int master_idx = mlx5_lag_get_dev_index_by_seq_filter(ldev, MLX5_LAG_P1,
+							     filter);
 	int ret;
 	int i;
 
+	if (master_idx < 0)
+		return -EINVAL;
+
+	ret = mlx5_lag_reload_ib_reps_idx(ldev, master_idx, flags);
+	if (ret && !cont_on_fail)
+		return ret;
+
 	mlx5_lag_for_each(i, 0, ldev, filter) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (!(pf->dev->priv.flags & flags)) {
-			struct mlx5_eswitch *esw;
-
-			esw = pf->dev->priv.eswitch;
-			mlx5_esw_reps_block(esw);
-			ret = mlx5_eswitch_reload_ib_reps(esw);
-			mlx5_esw_reps_unblock(esw);
-			if (ret && !cont_on_fail)
-				return ret;
-		}
+		if (i == master_idx)
+			continue;
+		ret = mlx5_lag_reload_ib_reps_idx(ldev, i, flags);
+		if (ret && !cont_on_fail)
+			return ret;
 	}
 
 	return 0;
-- 
2.44.0

