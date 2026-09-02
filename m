Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FBA4AA013;
	Wed,  2 Sep 2026 16:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367281; cv=fail; b=TT6HtJhyQKIytaT1dGZyGTmmP2vU5IZ9BNVh1yMNyXVWt47P2UJjjNECm6wAviwepC7RGi+QFh4BQcV1Viaxwc7XzLi5eUJE+WXvjTakYzT8XGKmdO9a/o4/Iyks64KPU88AehvXYYCdxVJE2FUKbgL1nLC93MM50AuStWq7cGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367281; c=relaxed/simple;
	bh=5mQr5VFnELFhewAyxS51nhzplhS7+FZUqQCbzizsFF8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P83Tt3t1TYLVXnRcJ0/cOewbmkBauMlh0FtBPwClUwbteifrxVEZYb7qc3exhb07eVvYATVMTY3alJ7YNVQCwuGZcQXaEM/oiqDNZsOKtmpdoXyeqNjH8xJBG2n+p/6mGvR/olMl3iBRwbJivnNdow6byX306Tbf3aLb8pg6KL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qhgv6329; arc=fail smtp.client-ip=52.101.193.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qhgv6329"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v+7KoJcPMIEWUVPwXRRsRGEEizIMDRykJ3BpBwvNSAiwjwkwtzkuisOryv4OR8XdcXlVU6OksZVOoVYlcgmq9/pGRJKaisbBx2nSj27dQ9sCcYENBNDaRC5qMFplK9h7/P/pByAMuJ1NiQIEdm9OKFAMrgRcHo+Fpf84th9gTSAR+Tj7O0YCnYoPd8LBNbr/tT16UyvmuUV1aB3jA58MmhpuGjEFp0bGInf1krj3tS/b61I9YexORi+zTHCy3MdeIjWcpxmdbEn/Z67ht8brPBkpxAvIliXtDlDn4klkO/OTFgG15nQgjJHhVkJXbzpnc9XLIpBPYMrhB7nn5lVgxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xftvjPCm+T5iMKs81lqZK6BF5KbIl1o3U7HEfGQVAmU=;
 b=UBgPrxnQyy7OPWCk3Lcy7wJNfxItkA/ib26KhhxQbd1IDjPf6K9F1b2l25Qf+rvLc4pa7x5oTZUscoQmVaWgKK6wPit1a/zG9vS74brny13tpU4a9lAcV24nZAiwcHEe3grpU0/1kopltErcfpxjak5I4yDBQfRgQqJD6ZWDLvK8i1rUXBn6VEQ42F3pkNTxZxR6hVFWwG7Jc1YZ/7rZFJUWLmGvt/5vV4uIttz3HLWqoyCH70DsJRfQKC1KlBdUR1AyBQlQ1f84PdyinlnQHhK5eLFpHV78tTVfgXeFVCGvs+vVmxlwvdI4SFHIy0VZA0oIg1zPV4RXUV9+DnUCmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xftvjPCm+T5iMKs81lqZK6BF5KbIl1o3U7HEfGQVAmU=;
 b=qhgv6329rzf6dMrLfeEz6K18bFiqe8FcfBh26DvzPzDOCpKJlQeUzHqYqIRUO/oLIP2TtFiEVFbk+J9arfSnogwDZf6cIb6QlhNyEi7L7rDc5aN0SsUA9/vSUWkjspr1pUWEB3KcwEOXC0eWKL7tRWrwI0hv2oncOSVNbYs1+AvfIxQsFJkn+pe60o5CvjqVOVrMf+AD2XeGbm23LWQbEGdHoJqawiAO0YppYAUbgli/nG8wuKnHaY4TTAR4f2oC21ay2VDQCCpfk21UN1wv2DFbPeZ26S7tmblVJCX76ybpoAzNL9MnrdRQRqvPSXhgbridn8OE2Ljsu9rBKp5wsQ==
Received: from PH5P220CA0007.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:34a::12)
 by SJ0PR12MB6944.namprd12.prod.outlook.com (2603:10b6:a03:47b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 16:41:12 +0000
Received: from SN1PEPF0002529E.namprd05.prod.outlook.com
 (2603:10b6:510:34a:cafe::4) by PH5P220CA0007.outlook.office365.com
 (2603:10b6:510:34a::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 16:41:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SN1PEPF0002529E.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 16:41:11 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 09:40:43 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 09:40:42 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Wed, 2 Sep 2026 09:40:37 -0700
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
Subject: [PATCH net 4/4] net/mlx5: LAG, reload IB reps of LAG master before the rest
Date: Wed, 2 Sep 2026 19:37:16 +0300
Message-ID: <20260902163716.3656279-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260902163716.3656279-1-tariqt@nvidia.com>
References: <20260902163716.3656279-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529E:EE_|SJ0PR12MB6944:EE_
X-MS-Office365-Filtering-Correlation-Id: 700b4b53-59d8-4839-6fe9-08df0910ff0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|82310400026|23010399003|7416014|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0t0TPXqbA+Q8FrhyLGifx7Wv3Nu3BDKADIpYLPFavAHrqo7t1tFVwvIqs41m2GE12ICiDcgt8MyuVoD9cAiY0mXG7Lstujpuu2Z49/53hNK/fCbjn3aTyrDptN23ADUrJrIPWkTlnmtPCymE1G9AfOlJ6kvhHyD4dd+WtuuRdYyuSemzBEVQ2a9DpvyTYOPXn2tjbwMNyvA0VDVLpDFjPT7MsTak5Abww0CRzO+wqWvUhIieVJdFZqiQGRxzuV8zrXN4pMwQfzjz2XOSkTeeZJ2dJ9LtYpXOdhExis7tn+22SFk5ejvKXOfHjojMcZ//sCH7U5eETDpor8URT/DjLbUz05QWyn5+Ta9QdMQKVxYMlJdy0ZsWlVM2hVYPP8Vr9Jn53C3I8C/toQrj4YU3D6jKsYvdOM5kFVidHPcWcUq9BrbtoiDIB5k5bPzWXcoKMVHDlSsvA1NlSUTtppWPjzeX6LJMHCd3g0K+fZysqlLK7P+oO36f8yH4t6otmbw5a9HcGojs7owK4J+Th1PzqEPUjyT9upL6CL/dwkuxgshv14d/xK+jM/h5WY6AwL6o2OhNYP6ZBQvwu2QiFzx77WbjniCdX4Y5iW4vM9kmxt4tmmsrOljUWllWTKoUsukQocYfkktYgFHki3obyyjRwu1n84GhAQBue/zK6XvZpK1U5mfBGqy35jYWUxKpxkJx4EDKXVOzzibr7N2luvJ8lw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(82310400026)(23010399003)(7416014)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sY2r71yshw+yYzpK+hVew3pw9tzLxsBD9puiMiUFnhCz+uhFA03RnixmBpQICf7GaYtCKHNe+4HqcwtgmCNy5S/vEVTJZY/dbfpOgx+XSdwXkvWbWGI8SZMRAJV3TI/5b+yN9cAsXNhwMprNDfnepRc/S1yadraL3gRJWvCsmAHHBOlyFRGMeR0sEf6S4NKkWr54NJKI1hrbL2a41/6l6ooiPFKrVa2DAGdlx5eTa2EySWQ5PgldWDyaGoJRU2Sg+ZTaXk25ln/kUFKx+fDcUxVMN1agzrDl7nTHAC8eUsNTjocYk0b0zXMnXjPB/delStciSYIHqxQ0WUUIxllQhEkMG94uyVrlS3mXVKCgs1+apvcnZsvwvvBNw7BHbeYRQfFDSP/NMqPJP5jL5vEHp+CUTNnit4ZhgSWYJ/o6VWzkQUW4hAiqTBOAxz0+UD1t
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:41:11.2081
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 700b4b53-59d8-4839-6fe9-08df0910ff0d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6944

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

