Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012063.outbound.protection.outlook.com [52.101.53.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABB444781B;
	Sun, 11 Oct 2026 13:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791725614; cv=fail; b=ZVO4un7x+I94uRkV7QJMH2TsepSgliFBLLfvd8TcG23nf+Zo2Ynt0T8MKMBlh8lRUPbiKwT2HMWz7Qu7D0DNmfmpKLj0FwbcunYT+S+ikXd8dFEW64UsHol0GJU4N85j21RzF1GrFRblFrgGss9lEeLcIhhPUDPf11Jpa/3wks8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791725614; c=relaxed/simple;
	bh=elq1Nnw2J63M2tK9xQud0Rdh03Yq9t/T5+4G65yLFIs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JUs37351cl3dCcVq781ZLUOKLPMyhTEO85nQMhZ4bE4W3oInkgEvvyNw8bcl4rwRds2iwUMWlxbMI0lyfW1YBPG3FrRfz7SXCtSLBlG7YGV5TqsqmpGhtPqyhKss7wPRWrSbAe53js9OWHMKtDC2TmlZFIvdnERpI5LWTc0K4NI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RBgjEx+p; arc=fail smtp.client-ip=52.101.53.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RBgjEx+p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L8iF4UngmdG3iwkehSVE56GVv4DURPwyw/kigXGll9A11Q4eAFcmgwFgywSAnY+Dv2/VAxynjATG0B+2CpQFhrV7msImbOiEqN38QIS3r0I0RXHkIAiMLgik/CIx6pVdMATH1l7vD0q01VHJTUNMjvG1gHXo6airgBy3qpssduLrA1lhNSrxqX3ISCDTKc4ju3Xw5A49EPUZzQPN6D/eewdg8s1RCP/m9cdiFTpNJF8hfwY6IxXYPborZZ98tCP2KjHXiG4shtZtyuWHdvqT5qIvT+D+9YI3bHxfiJwardFVvjY9Cy7MTfcgcgEYcGFPUjbl/buE/qYdm+4Y4jYjyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=emdCEx4AyVfEEJiS5fxAN31pCT7OD4EF6bnUNHctlCA=;
 b=Zwp2btLyUD5cqL7udQrYper+2RzVFr8p5o+/gKofFiLhqLWENKthemlOY8Xbv8UuJSG++IcTd8Jy6NUnJCmRW5DcGqXDbQNYlgJ96KLY1KW5oXVjahiPxLTWoVBV6oGw/DbZ0hSBkmDnBnGpiqiuTBgQJHVJyd+nPSh1ho0dEu3lL79ADtkqbF7QsAgddy71GNUHkG0yRyv1uGfpiekCTUyoT7WJRRwDSDWyESFgk23cyXBFzvhgkSw2VVF6K9K/yqJxeDYjY1pQi/d5zNGR7znpzZGTrevRwXi0oW0OpveyXQX+YxoH/h9VMYOKNwMO1k9l4S8ncXej6GOYp3H8uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=emdCEx4AyVfEEJiS5fxAN31pCT7OD4EF6bnUNHctlCA=;
 b=RBgjEx+pun2y/hkS0MuIEUyvaeNJXIIN145ztISSpDyoT3lVjk0/HCvKNcF8ncs0sjpKd0DXVYu+CTJQWVFVQBokYm93aFJtpJxjOmCHbaCFZPtCywEuMtXCBeiFSujjZgoExi8P4BR5rpzQQCz+wNgEcmootcBDEFH/kEnpnxTivf9fkh0VVU4VEK93UPBzFKn/bgrAxYz6hGDvwBb24s9EJLtFKJJt1PPduxcla4TWnFgdkQpFYQTBAYeqngX6DibDiOEfSY0SXecbXsxBjdCNy3O09SGvfu0f1TLgeRdpWikAG6NYfWfKO6mvApSRFVRfUqVXO0pQAZFCsGJCcQ==
Received: from BN9PR03CA0066.namprd03.prod.outlook.com (2603:10b6:408:fc::11)
 by BN7PPFEE0F400A9.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6e9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.20; Sun, 11 Oct
 2026 13:33:27 +0000
Received: from BN1PEPF00004680.namprd03.prod.outlook.com
 (2603:10b6:408:fc:cafe::5c) by BN9PR03CA0066.outlook.office365.com
 (2603:10b6:408:fc::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Sun, 11
 Oct 2026 13:33:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00004680.mail.protection.outlook.com (10.167.243.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Sun, 11 Oct 2026 13:33:27 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 06:33:17 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 06:33:17 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Sun, 11
 Oct 2026 06:33:10 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexei Starovoitov <ast@kernel.org>, <bpf@vger.kernel.org>, "Carolina
 Jubran" <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, "Daniel
 Borkmann" <daniel@iogearbox.net>, Dragos Tatulea <dtatulea@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jesper Dangaard Brouer <hawk@kernel.org>, "John
 Fastabend" <john.fastabend@gmail.com>, Kees Cook <kees@kernel.org>, "Leon
 Romanovsky" <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Li RongQing <lirongqing@baidu.com>, Mark Bloch
	<mbloch@nvidia.com>, Richard Cochran <richardcochran@gmail.com>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Shahar Shitrit <shshitrit@nvidia.com>,
	Stanislav Fomichev <sdf@fomichev.me>, Tariq Toukan <tariqt@nvidia.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>, "Adrian
 Moreno" <amorenoz@redhat.com>, Michal Schmidt <mschmidt@redhat.com>
Subject: [PATCH net-next 2/2] net/mlx5e: Batch ICOSQ trigger RCU synchronization
Date: Sun, 11 Oct 2026 16:32:12 +0300
Message-ID: <20261011133212.807979-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261011133212.807979-1-tariqt@nvidia.com>
References: <20261011133212.807979-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004680:EE_|BN7PPFEE0F400A9:EE_
X-MS-Office365-Filtering-Correlation-Id: 8600a066-67cc-42d7-3aaa-08df279c3b48
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|376014|7416014|82310400026|10067099003|261009223027099003|11063799006|6133799003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	SNUDGuX4uWIYr4965kUU3qwYngBt+Y4uYC6QXNsXkdWEl0hPOYH4IFNVBdAUq7jO05snAgVdPO/owlWuDxHNvmBdOTzxt/viCWb5bo4sN8tcmGznnio18+KypJGq5J+X/zWAaftFSELRibFWwrt4XEYHtD7gn4JH+XnyozxCUunW0viBbsPgdaFwNobrNAcqwkZtmTear+2NwAzsrJNA0RcOfesAdtiJiI4MdvA1fBxK/oHvgd6SRlwekdfimKO9JydZc8UHKFfaC7lo1uPzs2ZRTZ06ol5Pt/oGyg1Htt9V8Ox8Qh5URIPtLl8WOB65jYpXHC5Neq7YwyUgVpQ9rffVN5vVOsJXy175D6sXX2L184B2HVH5ZHtthCF+uEjn3cg0CNP3zMXvtNjiGeRDg5LOcHU4uBRIgZRjUcuwgMPY3gN8WJJryD67NHxSrVpSaHi87m0sBsDx3tZih29lh0csFuSWivQcTqX0hcnmab2UptQIfNJgh+7c72GJQOBEsa7Afyv6ExO7VwZbH7h9HLoFc1XRR7ttLpM+Rlh5Nw7ysi5aqhQBf6SyXBwjlyGXMHy0UFXY+CKfO3XPJIkZ5l7z5FN2BjtTtsmjs7C2AKZSvGekfwLk/E89Obu8Qta3ZuGSzY/GMcaqppVz3f8TpdEj0t/jA2ROB0GKBirqhufeDHzZFLig6N9eRQLk27ByxQuj2UxIaDZJNQd0PdQdOQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(376014)(7416014)(82310400026)(10067099003)(261009223027099003)(11063799006)(6133799003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WvAl5n9D/b+QX7DgfkohCdXUF04e6qvLy/plUw4fAx4qCQ3qrXzuKCD4Qfan6rILSfO3Ccw1BSO3krGTmlyO0FoUJWNzYJFjIUCwW+GFFVxc7n/1lYGL3h/TwKTFjHsh1k/Z5xKuxHqgHR5nnJIyWy8DLpxmLDLb+ej2WCmJ/VSl8K256IFkWSoR08hKT1DKmq+NrMwoQAzAQ/kwB6sV9pDHBIGu9kgfAkTD4iOPdh4Nl9C2R2b/Hwtz5Z4/Agn8SVBYxE66uN+4RxoyQCjHX9YrBHm55ZVYm7Fh+qYoRv5p2d27mMgVq4O/KjunUqGggE6uLCEyh+VsfrwagzLuLxzDX+Pn+Tugx251Evz5nPkbUNOR8QtnepPMwFiQKTNCDoNJe7WELXNaIIMM1mLp4cXYKCgMckx8lOiixC51HCG0oIh5AUyO7tfOToBCnoLS
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 13:33:27.1048
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8600a066-67cc-42d7-3aaa-08df279c3b48
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004680.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFEE0F400A9

From: Carolina Jubran <cjubran@nvidia.com>

During channel activation, mlx5e_activate_channels() triggers the ICOSQ
once for every channel in order to kick NAPI. mlx5e_trigger_napi_icosq()
sets MLX5E_SQ_STATE_LOCK_NEEDED and waits for an RCU grace period before
serializing the trigger with ICOSQ users in NAPI context.

Mark all channel ICOSQs as requiring locking first, wait for a single
grace period, and then trigger all of them.

Keep mlx5e_trigger_napi_icosq() with its existing synchronization
semantics for standalone callers.

248 channels, rcu_normal=1, ip link set eth2 up:
Before: 3.095s
After:  1.794s (~1.7x faster) 

Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 28 +++++++++++++++----
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index fe4e5d0b2e9a..58e4874b664f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2837,14 +2837,11 @@ static int mlx5e_channel_stats_alloc(struct mlx5e_priv *priv, int ix, int cpu)
 	return 0;
 }
 
-void mlx5e_trigger_napi_icosq(struct mlx5e_channel *c)
+static void mlx5e_trigger_napi_icosq_post_sync(struct mlx5e_channel *c)
 {
 	struct mlx5e_icosq *sq = &c->icosq;
 	bool locked;
 
-	set_bit(MLX5E_SQ_STATE_LOCK_NEEDED, &sq->state);
-	synchronize_net();
-
 	locked = mlx5e_icosq_sync_lock(sq);
 	mlx5e_trigger_irq(sq);
 	mlx5e_icosq_sync_unlock(sq, locked);
@@ -2852,6 +2849,13 @@ void mlx5e_trigger_napi_icosq(struct mlx5e_channel *c)
 	clear_bit(MLX5E_SQ_STATE_LOCK_NEEDED, &sq->state);
 }
 
+void mlx5e_trigger_napi_icosq(struct mlx5e_channel *c)
+{
+	set_bit(MLX5E_SQ_STATE_LOCK_NEEDED, &c->icosq.state);
+	synchronize_net();
+	mlx5e_trigger_napi_icosq_post_sync(c);
+}
+
 void mlx5e_trigger_napi_async_icosq(struct mlx5e_channel *c)
 {
 	struct mlx5e_icosq *sq = c->async_icosq;
@@ -3099,6 +3103,19 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 	return err;
 }
 
+static void mlx5e_trigger_napi_icosqs(struct mlx5e_channels *chs)
+{
+	int i;
+
+	for (i = 0; i < chs->num; i++)
+		set_bit(MLX5E_SQ_STATE_LOCK_NEEDED, &chs->c[i]->icosq.state);
+
+	synchronize_net();
+
+	for (i = 0; i < chs->num; i++)
+		mlx5e_trigger_napi_icosq_post_sync(chs->c[i]);
+}
+
 static void mlx5e_activate_channels(struct mlx5e_priv *priv, struct mlx5e_channels *chs)
 {
 	int i;
@@ -3109,8 +3126,7 @@ static void mlx5e_activate_channels(struct mlx5e_priv *priv, struct mlx5e_channe
 	if (priv->htb)
 		mlx5e_qos_activate_queues(priv);
 
-	for (i = 0; i < chs->num; i++)
-		mlx5e_trigger_napi_icosq(chs->c[i]);
+	mlx5e_trigger_napi_icosqs(chs);
 
 	if (chs->ptp)
 		mlx5e_ptp_activate_channel(chs->ptp);
-- 
2.44.0

