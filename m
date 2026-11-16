Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.37
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794825109;
	b=1X0HTjrrgzDLHRrtqGPAGaEL2kS873S7f066UOA2S9zHcv8B+NXpuK7Wg8cWLLZh9l7s
	 SVblS4obfj7nqPQV9fdIyLmW2pRxNxTVyY3RDbYn7ebT7t4LmwKaVQKFiMEfGQdYY7ul+
	 Hq0pzAkF9rV5MevouMmBAu95Pdp4NOkO6F2DPUWC6f29jtp7OJXa5L1QqG/D7V7L3PQc2
	 N2QWv6kuNxZnzoZ7k4d+f2ONVz9c2W7JPieQSvSssGeBfB9lCvs8HciypA3YNzY4uTPbp
	 yfIbJ1T9AbRS6DGAUOJnbmPjWw85C3RMrxFmA1csB1N32zGkgsHd7TX1aY2fE6tLPyQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794825109;
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
	bh=YheRGpd94XiCFYq/3J0GJGDsrAD8BC2RtfHn56kvG1Q=;
	b=Z3uabESPPXcTPOaWJVdOQoKIbRCivJi0DG8jkHlfrPcZbHn3Qwj3BkVv7e9VEcAErIkw
	 KCOCTmlAuP/KRvoNDyw0xQrmfXVKOFuk/0jKCDO4j51bAFG7leND7wtTZxQKvrBm6l/2j
	 Vvl/whtFQH8JJFTItdoV4P9vKlaCp3dYbz3yVBCEuusM3oXj0kSXroShWG5xm9NysHpH5
	 B1AKWzOb79fjg1xyPrQ6JolplUsEPlhWM66kyuclyNgGJ29jrdoYCHMR38ZOPD4Mm9CfD
	 YqPxQEWYgKIC/mBA5DsFPL1ld/okB+NOLT1/Ix+0+eTNt8rfvjlto2CZrFJiwm1kwQQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Fcq9zE71;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.37
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010037.outbound.protection.outlook.com [52.101.193.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2521D606A32A;
	Mon, 16 Nov 2026 10:31:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2521D606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Fcq9zE71
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GnNPM89veLXTs/TgHIRb2p52rvD1tHTuAJavWVCoiqcnX8AaNE5vkilqwZue2o6XBJwBoP7w+R3LqMRdjqinMKSPISs5KudPSw9SRx3G9qt3jbw5qN6Q01uFxdAZTqCbGzM8an3+p8Beqy6JYIPDkXs0nr0oOMVeC07df5dN2+hN1I3Zu49V9TjJsXDCzJzKqony0+CN9kSpfK6XR8EvgyCy8Kp6fdCfShO9/ilFVAHZoYKnXTCZJHp6nzgw9WcAABH8CmBCpoHyZ0CR2YwU8nq3PvHeCtrH6RttmFOsPsBIC/tylrUeqo6ldQBqWvNE0JHc7WQV5nYFi2zYNqmhQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YheRGpd94XiCFYq/3J0GJGDsrAD8BC2RtfHn56kvG1Q=;
 b=oRi2xMGLNbXNJeYKmDIA2nVCxyj9JKuDR7VglOD+kcQ91YD6TFL2ofTzGkpPQ0hI8/yk93cipvsGuFqYIHV11ijOpB0fWMec6h/EOS4zWNmywfKpM89zqLI8Rod+c6LffFHOYcf1kj7Ou485mhO5uSmWIEuwK+iJxuAl9+aaac/h9h/wzJQktfNN+75EAFUlgZrZMPwLpHVxr3VAL9DTZ1LUFGjT6iS0uL5nD572X08OS6BlN0zRO5QG0U+JVqw0cMwuUQjbvMI2b6NnD+LZ1NXGhYasxMYZJxTA1XC8/IqJgsUv0xTwHlUb1+5cnJmd5EKWf9xzbyjQjCUbYRDlwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YheRGpd94XiCFYq/3J0GJGDsrAD8BC2RtfHn56kvG1Q=;
 b=Fcq9zE717UwUaNKnZYTdbfPdbRkUjH8k22Z6xzNhkRbEO8Y2wPnuGGXYJ5NjOR/8Y+E/rohRyk9aSvnBmcuF0vwkogHQGEcBirBNCRKKJAIC0Ef0brjD3qA0AsYwHCunzM2RMUlDLmNPK86v6irvExSyT7qn4NlLhloPXcHQ3SSoSAHUhSmq3Sspf3jbUD/xzScauMrXM2RkjA9r/0mHpjI8A0kwKpLxIE6KILAOYfYyi2sjKRq9VTK2i6qnL4IJWQS8uArz742jTWI0YIyaS+UtYyx+cHHjh+RtkL+CXcAmzGcXP8Z25d8ljiqbqYB9gF495lK1KsqXoMWqzy/MNw==
Received: from PH5P222CA0005.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:34b::16)
 by PH8PR12MB7208.namprd12.prod.outlook.com (2603:10b6:510:224::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Mon, 16 Nov
 2026 10:31:41 +0000
Received: from CY8PEPF0000005C.namprd21.prod.outlook.com
 (2603:10b6:510:34b:cafe::76) by PH5P222CA0005.outlook.office365.com
 (2603:10b6:510:34b::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Mon,
 16 Nov 2026 10:31:41 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY8PEPF0000005C.mail.protection.outlook.com (10.167.247.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Mon, 16 Nov 2026 10:31:41 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 02:31:24 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 16 Nov 2026 02:31:23 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Mon, 16 Nov 2026 02:31:19 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Uri Dar <udar@nvidia.com>
Subject: [PATCH net-next V2 08/10] net/mlx5: LAG: replace fixed MLX5_MAX_PORTS arrays with dynamic allocation
Date: Mon, 16 Nov 2026 12:30:08 +0200
Message-ID: <20261116103010.1129666-9-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261116103010.1129666-1-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY8PEPF0000005C:EE_|PH8PR12MB7208:EE_
X-MS-Office365-Filtering-Correlation-Id: e5058ca1-356c-4968-0249-08df43cccdb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|23010399003|82310400026|10067099003|11063799006|56012099006|261021121427099003|261021123027099003|261009223027099003|261102123227099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gErbI1T9WaG1XGwIbLLLqDQCOqGHpRv/qjVlUEzo3otrUhYJWfazUfA1h6jpBaSILGvIsKCfpwdGyF1EPG8HQtHI27NTrNm8cMMKf3RCkXJnT43Qor75mPrduAeMVmdpZPJkm6d884meGniyEucgos69DP6L8RAnFCeqbRdxvpL4eP2td93xADNa7cf1hGZNxIAxRGnLfxhCjEItTYyyEm0Sxjbmz5uUQHCax5w8McIDdSY38NxdNT9RnhoFBV30JdRD2RJ/lt1QqdAHGi5cqgZe/OfV7yv6FB01lpfh3VoepAg+FYJ0xUMSVcvX31jp9LFK2NDsivrqwmosqe7cFZkKEgkx/TStQKBDSvnqRowErve0GiJ7cUNb25xTCv+WiKRjjEJJ9FHaPZdW4XLGExTcln5UE/sfOnpNJVpoImHpEy5yxMxbP0c7g85U3Q0dnXE0DXE/xs0DozyAmjGVPWK2xAR+2Sz/sOvFY9kEZw0ijEN0CoyJCaLh+VXkeTGNWR0SJlNzX5H6fctaynhAEgZQcTOvzlKwOclKfRZf7vXRnlXozcn9gdZiWOw+efGYzFzoMBbWiSYHN+PZlMai0uuH/+NH3TE3247wu/bYBQhuXeuzp9a+yhid6GH6YTSQQ00n6r9U3DPo6dfSVxMbuuim0zGezhDo+4O9oMHyYa7hN1aGFnx4y4tpiVdNslwjbYpfL/tCYjSp64hOKdmHVA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(23010399003)(82310400026)(10067099003)(11063799006)(56012099006)(261021121427099003)(261021123027099003)(261009223027099003)(261102123227099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	h3Se5N6CWaDy18ntuv+Rj1bJnJvzdI2WXsMNRxGUc6Rp4AmiiqT6a+0Ylx9SsuFm6p9iO9m5AHYJlQf/LbpIhy1OgvMoFY4jHMAVtEbkbKwfzJxrraO3KnqA+O6cjsW1tl/mYh1/gxTyKHYgDNP9xK/m8XEqi7tfDFcrmF//OF7uXZYkqEtn80wwsN4Tkn6uxpvb1gaZNUiFFVBR5vABxVEFc4T3PKXDQscPOtEZMp/EGBQZsfhEng6Ai8hDlexQK9/+biiFIqsKi0HeEkhwZ//s4lbE1I9Cu474l5Ro/phpgBnRSLjp9sSKYdSr0IgJgV4qB5TuGWIW68MCJJ9MiobPsfz9oQQBJ6ciY/hlqfCH1WD4cmHtjYttjLgEycB4wfhh2XVAXmokBVROA5SHzJ2De1aWvbmx0mPiiKT4PHp0BzeobsKJVdOsfPqy/aAs
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 10:31:41.2089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5058ca1-356c-4968-0249-08df43cccdb4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY8PEPF0000005C.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7208

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
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 15 +++++++--------
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c   | 12 ++++++++++++
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.h   |  2 +-
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 5c9f200c9637..a7b12353b722 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -2916,7 +2916,9 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 	if (!out)
 		return -ENOMEM;
 
-	mdev = kvzalloc(sizeof(mdev[0]) * MLX5_MAX_PORTS, GFP_KERNEL);
+	ldev = mlx5_lag_dev(dev);
+	num_ports = ldev ? max_t(int, ldev->ports, 1) : 1;
+	mdev = kcalloc(num_ports, sizeof(mdev[0]), GFP_KERNEL);
 	if (!mdev) {
 		ret = -ENOMEM;
 		goto free_out;
@@ -2925,20 +2927,17 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
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
@@ -2953,7 +2952,7 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 	}
 
 free_mdev:
-	kvfree(mdev);
+	kfree(mdev);
 free_out:
 	kvfree(out);
 	return ret;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 49602f830615..8a867a04916a 100644
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

