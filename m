Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012069.outbound.protection.outlook.com [40.107.200.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC35488202;
	Wed, 23 Sep 2026 10:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160070; cv=fail; b=SUDYMMJ8Q30RKnrsE2OPWaX8qdnkBf+gqPOeHRkS7wSjDygMoxC2nRFuqNxhbSlsaMptR8lUumRnfTa9FyKMnQj/rMhsaFyTJnPU4q6qpzOuaPSq9WMpPv9KBj7i73gFz0q320Duwjym0IZHI+7BJ1Lo3qd9pljJEf51kra7MK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160070; c=relaxed/simple;
	bh=ROKgm3k3Iy0J635iWx5C4mKFcqlMH0C1fNTwIeiY0cg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OvFs5mQZyTZRvNr/fOtPMT8YhBZasmSY+hLiMa4ESugJfBNYN7EY7qtUPPXMMrQjo/ng19Iyqs1LAjGQgQWwmkXXtchDwvlVV4jX5pjdnOHKeKbuXigyChokceig+GW4TXmbgNgwHesYQJzqqkK5EsMyc/ocpJE09NQ3u/zGfDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bqJfM/jH; arc=fail smtp.client-ip=40.107.200.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bqJfM/jH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oh5vimFRdxbUOTZH3wsiGJXxNzDB52NugdUZS7gVOKI6aMYlZ2KL84uCNX7ofah7pyS8N5ddH/ubtKepi+yLVpH8GZnw+51xX1VDjnNcG0RK5LlnXRA9IIrV5Cm7JBpHWm89Twy8tLoXVt8Vy01b9vVp0hIkJjx5a3BLWnFx3FUD/wMkC5xA1lrSK5QTiphYnrdPDhlHJgztbTk8g8mGzRvT2C5bOQpSUcCqXSaC8f4zAJuHFLUzbczBuQ+PLmN5kk1Jszk3tVA8Avhq7WAWyFlZlxDLh+Kw1F1dcUqXVYrCYMK/yn306nmujtMWlN5n3n4URKowgVM1SLdywS7+Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s4KEVFXn3ODdBhVXLg7WdxzRFCEEm/MKugK/QN5Rymo=;
 b=MPojqH5DjuF8EIT5/1TvgmrPs+1ugtAJJ/szChi0VBvtXymnhlKqFE4W8fSQlvPShznRrc2NFarj31LdMihjbHQcGRN2nm8cCXHO2VcaiPgbPHMahrCSPEOuwCxJDptMplS4YrARu3xmQVyiHkVb7JxsqFBS3o0A/ddL/K7HIy+tHkTTzZOoIJoQ3aURyKtJvdIVcZrx/o+7Rn1oi6SY9dqn6bjNX74grhG5NImHijeasoPgu3jSrgxms0tNriL+PWywcSj2JIER/HS2PhaAnzF3dthZCPMOroSBzH2a9DNbvYw67kdilNWnu3jBIsZsuanstoFjpI6rlbuwNcl0AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4KEVFXn3ODdBhVXLg7WdxzRFCEEm/MKugK/QN5Rymo=;
 b=bqJfM/jHkLniIjaSN+Laug52ECuwxVwDfB7G+5oQ9Tk5ESYatUFx8gknN0a7+niHC1E66qOrAKdAJPff4lxVWj48UX2G0eCxi1AhvM5Z2NeotBomrSKSOQqYWRIysNQQGCWx3++pHtZ7dGchoZCORN5NeAgl3qN/loj22vJ9WfwZHuE0FK517ShDFDOdWBeV+wh/+RYILjhW43uOyL6RFeKFrK9XXJIPGuEsVAf50gBaLpIGNMnmO3Cz7s8E5VUBh4/g2TTke+oyMQ6zx27zPfFbw/Dt6m0iqGfPfCrKFaYsl1YgKGmHxuCwdYo9HfimUKJ/nmC3HYqPacvzECtl+w==
Received: from BN9PR03CA0531.namprd03.prod.outlook.com (2603:10b6:408:131::26)
 by DS7PR12MB5982.namprd12.prod.outlook.com (2603:10b6:8:7d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Wed, 23 Sep
 2026 10:40:42 +0000
Received: from BN3PEPF00022BC5.namprd05.prod.outlook.com
 (2603:10b6:408:131:cafe::93) by BN9PR03CA0531.outlook.office365.com
 (2603:10b6:408:131::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.14 via Frontend Transport; Wed,
 23 Sep 2026 10:40:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF00022BC5.mail.protection.outlook.com (10.167.248.217) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Wed, 23 Sep 2026 10:40:40 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:24 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 23 Sep
 2026 03:40:24 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 23
 Sep 2026 03:40:19 -0700
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
Subject: [PATCH net-next 06/13] net/mlx5: LAG, size debugfs buffers by port count
Date: Wed, 23 Sep 2026 13:38:23 +0300
Message-ID: <20260923103830.1183-7-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC5:EE_|DS7PR12MB5982:EE_
X-MS-Office365-Filtering-Correlation-Id: 26538e26-3af2-4592-3756-08df195f1d0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|36860700016|82310400026|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Lh6Oupe5ScRja4LtNfz7qPythvgb26Ymvi1Y3cYaKjV7YB7sHMprUHXqMk4FQokHEtTB5a1auWYLn2SyRNG+WQQeSjLuyxyxZNW6opmaJIrVSdmc/aQhp/n1HsS/TjktGCxqabcRNCrPnjwIoYw8IxZLt+qzksvQrwpN6zsqh2N7Ji5bYy+yrNPwOXUQ8SG79ZQQxGvNifCFUSHr1qZU1MqoTCTe9uIZehrN91mP5FNMu8zrgJvnqwwG+YELaZBVtVywY52+bFB3JYqr9vlolC7aAdpzD1j3czAv/leMOIeFVcULuwv+tq/vmbimAd6D2lnpxek/97j3nH+AhsUWs/lhghdffJduGQowwkhfnrB0LKTRm9EAOQyGE6AqV98IiqYbye+zsrqVvz53bn5J3FIKI4fqPGkdxgXVFHRD0z+Vhf31sym9JMed/dwC4BAAAXeredmp+oOKIyyuzfLJTgLNecxHIhTlfvl8pXHiXLEvmU9zg76EhL2BRnHuODBhG71BM5JEO92kLuxnz5WS8hK/pnULrHq4bAG/2bub0DEkgz00cqxjvhiZB5iNfLytjdk/E/doXKSidxm3fUiGk8fSXMWr6/RF6w5HiUiZaCxil8GQgTIEdOuTvOr49kSCps/3HK2FqE6iIh3J2lb6NKRI8AbvQyKlWJLTka3XqjvN04iZrLqG1RTWxyD8f08SL+MJ+ve4baREx1b/fMkEwQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(36860700016)(82310400026)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	e+zS5O1GvwedCHBA7AdohmEy0eXQy2I8Hby8tn6qqffFYQWJ9W+fw7kMySymKnSb4tiLww461I9R9GJiExBOQSXbgWgv8mRXUfkXG2smBIyYyWENbzOR3Q5RCMoDAY/WtBfTAA/va9WBwkX/8ULctHvHluuLa7UWtlL8dp01hgiucc78fPrbkVVsRJShish6yFG7jEugqM1pFkYAJTnfg+E8unVjyC1CuMCLg50/q/d6VUYuNpYvxqRp9wJtBqg+8HYGPO9wiUiqeDjaj4zEzDGuIuskwKiMrepkBTLJotH9SCW9OyOWkAfuGKyC3zrVVsEPhOq3y/llVKwUjnM690iMUgQkKD84eea4yDxDXCKdjaneuTIG0f7JyyDkTGwsvAho33xmkLiUt3HIabvNXu4cg3c1Q7M1YqFqgj2RVUdyN5rbL9HCInZiPiST077Y
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 10:40:40.7691
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26538e26-3af2-4592-3756-08df195f1d0b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5982

From: Shay Drory <shayd@nvidia.com>

debugfs mapping_show() uses constant MLX5_MAX_PORTS to size ports array.
Instead, allocate dynamically using actual number of ports.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
index e9b8d79d2d21..44296789d656 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
@@ -101,14 +101,18 @@ static int flags_show(struct seq_file *file, void *priv)
 static int mapping_show(struct seq_file *file, void *priv)
 {
 	struct mlx5_core_dev *dev = file->private;
-	u8 ports[MLX5_MAX_PORTS] = {};
 	struct mlx5_lag *ldev;
 	bool hash = false;
 	bool lag_active;
 	int i, idx = 0;
 	int num_ports;
+	u8 *ports;
 
 	ldev = mlx5_lag_dev(dev);
+	ports = kcalloc(ldev->ports, sizeof(*ports), GFP_KERNEL);
+	if (!ports)
+		return -ENOMEM;
+
 	mutex_lock(&ldev->lock);
 	lag_active = __mlx5_lag_is_active(ldev);
 	if (lag_active) {
@@ -123,8 +127,10 @@ static int mapping_show(struct seq_file *file, void *priv)
 		}
 	}
 	mutex_unlock(&ldev->lock);
-	if (!lag_active)
+	if (!lag_active) {
+		kfree(ports);
 		return -EINVAL;
+	}
 
 	for (i = 0; i < num_ports; i++) {
 		if (hash)
@@ -133,6 +139,7 @@ static int mapping_show(struct seq_file *file, void *priv)
 			seq_printf(file, "%d:%d\n", i + 1, ports[i]);
 	}
 
+	kfree(ports);
 	return 0;
 }
 
-- 
2.44.0

