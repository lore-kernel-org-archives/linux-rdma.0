Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011071.outbound.protection.outlook.com [40.107.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA594E56C4;
	Tue, 15 Sep 2026 11:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472161; cv=fail; b=myzwNEJAD5E5Qe5Tcw9gIbT0nMpYuzihsbCpAY0SGXrZQTmxW1gcdZSC7/jytwtoo6jV1seEol6+rxJLx0ZKJ2AIwl8NYcf5zc/y/I+82G4iLlJMKEHod3AfGfr01zFNOrdn66roxTPw13BhITlJarPR1xu6DM3U09k/RrhPHw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472161; c=relaxed/simple;
	bh=DjLkRMmzbPwbEUp+jrrCNmgNas/TvtYpLnNV4Ic1sOQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H92dkcPxdA5otA+uM8AE0WKcqGKARGm9XIVav7pqwwK/khY6BejH5AtKLSC6pxseq4UGz12KVU8xadGmImIKOgwlpUHhwirX8CguV85OWjmF7b7Z7tnsrJ17oGxyb0q8/UvuJw8W/EEfpwVxag+SE0rSKp/9XfZFAxWvJ2qgqT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j/rFRsKl; arc=fail smtp.client-ip=40.107.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j/rFRsKl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hW2tV993ZnEdFwd3z5729P5YvBELRvou0V+6Twg3nDTdLInqCWZGQUd3UHsptPsgCzwO/ePtCWDxH0KFkKhrMcQQogEcBlBGNeIKtByi9Rj3T9moRNmFt9TOrfJKVFXLq08tL+AAkMy46YS1sAEZ7lg5pvQhTir5evdBsFv3gtRzYoK3fp/t7LdmQT60jawt2J8hmgtYCax9qAowirYoMNxaoyP0UYVGkxxQiBkX3K51C5L+0YDcoOWHKBdWPED935nMp1QLJjt3sHEta0c17EmhomBwmXghbW7RhO+enG9u5vbNKvwb2T/vVcSTufScl8GqMvi174CllrEV6iAiqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kShrbD2wVwKXuBvgIHXYuUY+nVA5sQTN9H4cBfJqOtQ=;
 b=neY6Ei3AMQdlAhzubPppxYLEmYaxWKnAzVSkoQxUjKT+54yXJemHKjeBUsQykyqQ+COfOkzmxnpuDgVYn751Xi/VwnvSPDizQSa9Dg1cUlSV+/9iTuiFZjcRTwPSbMRnfYgFXowjy5Zhwc+Lkj1Dq7lXzU04rAx3NldGM1CPcSgSwoDAOuQj2lcjOgbQHf+CT8FCvMCqCzADlEDUhyDTk0PfjS7thix8bDDKPr5RoOcZK9ZTkZAz2V6KCPajVNLpfHWkCtxsyRVf9VmHXJaWSmzHE2O/yHpMY89hTUWNzQ5I9nA1cfyKCaL29q4QSDZ8JzctfXe3D8ES62tWYzo8MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kShrbD2wVwKXuBvgIHXYuUY+nVA5sQTN9H4cBfJqOtQ=;
 b=j/rFRsKlr5mLhZR1r2nZl9MDqM7l6nodN0IA2xWV/OGMAhV0K1jWvCcWtYPffcFvF/mHloihb6vskCtJeH1Zu63aR+6z98U5/UithbsxoYyFsMTXx4hdyt/v0s+Aroy6Gbxin0123ESs95w3KxJrCIbSbO84Uj1Ia3P4CIR+Xo9N/G4h+mqsPcynwtQd0rAJuKdvkjh2mTJhUDFdtwIMt9xHvPJEqPnPPOKa9Xz1cT+6cCccYQ7sMVUA1n1QPDkgWRwh8LpnXoEhGOJ2z/mCLfjFbxwb/g/tNlwweJTDzmJJ0nqy70ZK3nFTkTKcsvVWYeynCeWg7Lo9zmS+E7ayeA==
Received: from SJ2PR07CA0003.namprd07.prod.outlook.com (2603:10b6:a03:505::26)
 by CY0PR12MB825472.namprd12.prod.outlook.com (2603:10b6:930:130::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 11:35:52 +0000
Received: from CO1PEPF000075ED.namprd03.prod.outlook.com
 (2603:10b6:a03:505:cafe::7a) by SJ2PR07CA0003.outlook.office365.com
 (2603:10b6:a03:505::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.11 via Frontend Transport; Tue,
 15 Sep 2026 11:35:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075ED.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 11:35:51 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 04:35:28 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 04:35:27 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 04:35:23 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net V3 3/3] net/mlx5: LAG, reload IB reps of LAG master before the rest
Date: Tue, 15 Sep 2026 14:34:59 +0300
Message-ID: <20260915113459.3934760-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260915113459.3934760-1-tariqt@nvidia.com>
References: <20260915113459.3934760-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075ED:EE_|CY0PR12MB825472:EE_
X-MS-Office365-Filtering-Correlation-Id: 0556b786-958b-485c-57ab-08df131d7f13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|82310400026|1800799024|36860700016|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bdhMpgwwMH1+6cEx1fqvOrDUi37L3lXBP/svX0YlSwkGrfG05qI5h54AH5M6+mi71aM+vh90dcf4aSbVGNUy9A6L1+0j9NydQN7lz/gIAeuN7o4yrZL6/iPq+P2i7oaAXLICX39GtevkkoD3rfg12BYikOUuaPBna02zKIAmdlnm9U69K6QPODoN2xZm/aMUN9o0boBsmhGTJxriGpNB/cnn3mNfKLyHw4CxLthCQ4dXBh2uGnpgVRobHP1/sjuQFXM1TVOc2Ra/KBZ39FB8pcxUvj7Jx+K6ExCnp6gwjxQd62IhF4KDcQPxuomHEA0LkIs4S50ULTDMzuwJ10S5SjpAHRm+NZ0IyAk+kR2uxaRgNHm7f23X+vY3ArKPJijRlxk0W7OyFySwR+EMHJLrrDLYWzXIwJcmh63kpu9TppBi6XD+Bo0bRJuiF0Iuhf05nYnUWZFaVghs8OdSQ9llfJTdVIv+3aVc8wzZVJxQZIN2WmirZbZjqxWybALPRYehk62TwLGpzOWQTYU1cXBfS1z4M0rN0DNbwTB7sdR5jNjORdWFNYUV2wkmLfdhIl79+zSrqY80PG1quvyZ6N5HRuT8wd0k/VqyjtVzM68KpZjLmOZ6B3WycQOeD4F3AOexOQOMHtTCEa9KFKLEZNLHo36o6sDAI1YL6skPL2N30rAzpnyfbjv/OjQ6rGibQ5JCd5qCffY/N+9maOhz8DaYxg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(82310400026)(1800799024)(36860700016)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mlBcC81HQsD3GBrU5AHbaYqvkpmdStpDu9hQShA77QVp0A5GzceEAX0saKIm2HZNg4KKWJ8zDX/nm4IGk7wG/LIB+OJZ1vTUP5ylpRMI3Po90hM06j1xFJgQ6tglLTxR1+HGQNYke6ua4L7+H3yBuYg9/qRjP6hxRQycKV49q9MhsYmhvb+eex/4TqFZaMbjaNc06o7gD+jGdSq4CjwuNTG69WRHGNkMwQZ6PkYL5gjS4/GNg6zOffWpq6QXVCJ22/rJKi2Dw17zwDzPVkkmTKZnkI402kGQYp3SG0X6M1FjRwQHpulN/lOcykKpVjEiWaT2FDoF9cmg+PCJj8xtyL3pMOI/648AnKUpVPQr2cY7u6m/fXNPd+bf5fVDcjoM7viAJQl3zwHheu88PpfF3akJDHEqN+gk57Mngx/CjVUdB2MyZ5jTM3PQ6olfy9vL
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 11:35:51.5460
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0556b786-958b-485c-57ab-08df131d7f13
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075ED.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY0PR12MB825472

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
index c655f6e32e9b..dd14cdc378de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1266,25 +1266,45 @@ void mlx5_lag_remove_devices(struct mlx5_lag *ldev)
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

