Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013055.outbound.protection.outlook.com [40.93.201.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FFF54707E;
	Thu, 17 Sep 2026 18:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668755; cv=fail; b=gu8173TKylZIZF4ddn+qXNZzpYYJTUDwy1xHDfbnx20c36zawt8mX5z6cQBuyERxqIzN7iIABzQWrVwfUj+eJhR+cUo+wAz08WaRh4M4k/20/rXpR9LD82yF3Uxn7BcNdJs1BvpFAHrHnCI6vlNgFdXzNmFQe21eHSL1jnZZCYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668755; c=relaxed/simple;
	bh=PRvlz8O77LAlSYmvTMnIJPRJK9SrptuSrnJ2PJRJTo4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mYkAppOOqf+qzLi+9yKhFAG17n8+SocLKVEFF20cob/f2hcm3GpBQbDo1vvK9tQb8QBrfRjWqC0e9t4qsMOAHpkzTkRo+ZdW6eLAhdFXz9Xh5L1fkl5/L9/Bw0FLemWIj2MJ9chs11F98aBInJxHS9V10oBccO9qLkT8M1Na+lA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HM90mBrI; arc=fail smtp.client-ip=40.93.201.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HM90mBrI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HnHrgsffpVEkYbi5MWgmlgcWVkwP/KtSanC00SLMzGjcdqPzs9MhXXsj3Qm2WSINT4KNoPDgDFd4kerrN8Gph4ciyxkGX/AEmASJ5Bwoo/hU3SVWmMTwxZtUf/ErzS03RCtoZaltjjlX+a3/lhkAEi7PXpeaM9bbPx+UVDu9TtvoxFW6jH2P8yGlpfobmdTHr4qU5k24fxAEsUKPT0+YzzhZlD9lfE3kJko53y5LjFwUtbCvZd+L9Fpw7D6N//rXv135YtBMqF+z9mSd2MZGMxXLU/SCSCz90VsX5SDKOWwiKrf5jgTqCF0QUl96IwEVZ9VFpEpRwzmi+ASyzUUrMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+gktVwIRHfqEvzHQygtkfgvF600EDrKS62Me591WB8=;
 b=LExg+pLBmGOgffEEPXwjg02L3RGepM/5hPKKz3nd6jeub6eWI1CwTl/NW1qlChvFrpbI5VPbrkJ782WFYrHxolg2rxqzfYUKG+GYKWpaszMuPWx/qDVyN752LM3PgZlvDUrLBW3Z/xb4XgjKyFfRdp2MZcrrOUmJ4G9zZ0WtGdU+OTS+exJX5qIMm46Xwkj+1OTOQkVj8+lwENWK0Ni/7H1NtT+da6QvKmj2xk6QMBpfdFgz+UuiHA77ZY9ojo8Nbm77wtpi/cLVLeQQjvMbL8X8MQGX1a3RwrH26baRqvrXUAaMtQFeFkl8PjG7f9Pprz5+rOLJs96zShVw0GyDpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+gktVwIRHfqEvzHQygtkfgvF600EDrKS62Me591WB8=;
 b=HM90mBrIhRfHt3qphMCtmYOXyajgUXoZXfHbUqdYiYllnmXKEwU0IRwWS96R+n8z9UtmiGW9//+pzIFr1JGiBrM9up+1LMXyUCeqYWkrN9U1DjxWk4ilK6STMQwePpdD7OxmNqwUmSMdf6qUnchu8yZGDxJaMxstQPcG64h9VbEqu/bMqDoMI7/bgYca8iwczSKaobq2Gu9lVZllXZ6hVp4u5yVbLRpclCX119W1i1pXL0zlW5jnXCU19Sb/H1FgjE+m6OgqB5VlgS8oMZ3t3JoR6yNMuy31GT7xrTicm13uG4Xo1bhrOJN5YWR/5mKHlC0OcQWMd9q49Lm0ZJK49w==
Received: from MW3PR06CA0015.namprd06.prod.outlook.com (2603:10b6:303:2a::20)
 by SA1PR12MB7127.namprd12.prod.outlook.com (2603:10b6:806:29e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Thu, 17 Sep
 2026 18:11:02 +0000
Received: from MWH0EPF000C618E.namprd02.prod.outlook.com
 (2603:10b6:303:2a:cafe::4b) by MW3PR06CA0015.outlook.office365.com
 (2603:10b6:303:2a::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 18:10:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000C618E.mail.protection.outlook.com (10.167.249.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 18:10:58 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 11:10:29 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 11:10:28 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 17
 Sep 2026 11:10:22 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Boris Pismenny <borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Lior Nahmanson <liorna@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Parav Pandit <parav@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Steffen Klassert
	<steffen.klassert@secunet.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 5/7] net/mlx5e: macsec: Delete remaining SecYs during cleanup
Date: Thu, 17 Sep 2026 20:54:31 +0300
Message-ID: <20260917175433.4090878-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260917175433.4090878-1-tariqt@nvidia.com>
References: <20260917175433.4090878-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000C618E:EE_|SA1PR12MB7127:EE_
X-MS-Office365-Filtering-Correlation-Id: 7048d741-d595-43fa-69e9-08df14e7068f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700016|23010399003|6133799003|18002099003|22082099003|5023799004|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	hpsJQa1BiuUSR4pa+sJ8AWHPkbarf1YeGQFT2T4a1AaQ3ZZXsVLvztYkRlrOyEsR64gGqo0ACPfvJkhPnPkNepQhBpRCEY7ma1YHFSNukc1gP2rEdShbnWtcADFY4pAwCxaYe6T7c0cyGHhA87W44LFBFqybuylOJ0kIyJqnDF0Lc4nkWyob24ojlGXbpIZbNJkeIPEiX4K+hJXwTaixIPKTF58JQtTTzFXSCU7spJgFrLjd71HkWU/sn+lKF9C7zOFSi/JngaL7I+XQaGGYjKGfPJYEqCKpI4gFOQmtdUUpz49l1WHec1PtDriu/EKHJH8V/FQzxEQXyvutb2E8WuAs5yjv9X2MNNhfLlNBDXcozFxzKBmkmrFmzLc1l3XZHUZ2rixNS5PV7Nux4Lj/q/I+W6QF5ircFvsF+LGUeLrK/KCgNC8/FR/h9IpnsX+36LZGHR6+lB8h5gdh8kONoh9yyuM9ReFwQNoWBNKurdwjt3KPTPI1FmslsJK4UubnbRgiOkFhVllpp4sVmjnpdpgh2mXiTlZQnVDhNw5ICKIYzzwWAZyRkylD9SHH/DFG9Yh+9yjfYQ/vTUt5sSTAZsNliY1OpwYK1P12hbLI0RpYcuJkIRB1/pIKas9x/3F5pdfuv4KDn/rK7UAFvriUcSrCXA7KeLanZdlagGQXX1BTslfF1LwVSA/IDJ7/hKHaPQgHThh8bQuPgRVisnR36g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700016)(23010399003)(6133799003)(18002099003)(22082099003)(5023799004)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pQijS6vLcdKAjZO1DcVTw4oD7bOGe41BoqKzY9ctlIISke/e/tKhkTvkw6mDQg2Jmh4X4rjn2XhedoHS7tfsBAFtP3r9Q56YXQPVAOznKX/xS8OHaTZZN0SAZNZPtuDiqEbO+U9eSD9dmif85UDA2+30ZvixTkBg5YlE1ST/Tchk1Ry2q3KdBNbrdliE0V+U5I7cXt1SSjSyeOijI5MQWyQ5yeWFcizJQa/T+yTtKp4AP9isSuZStecmIPM+fXM4HjJEWPowlnzWGN84yK6Y97clcNqT2G52fuMEC5cAxp+Fi9h6YiSfv80YUG09bkVuAmAkaPZEN/qG7luzUCAwUcGcu2ZFSXHe5CggjyWsJ8MoJHz0JnRFpf5eT3LZxRn1pz4rrwpUz7C7ySUxoVoBIVYq/dgayE9rQ5l2oyoUgvcS9nrnl2tT+kDKZfBan8a5
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 18:10:58.8562
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7048d741-d595-43fa-69e9-08df14e7068f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C618E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7127

From: Cosmin Ratiu <cratiu@nvidia.com>

Suspend invokes MACsec cleanup without unregistering the netdev, so
offloaded SecYs may still exist. Cleanup frees their owning context
without deleting them, leaking driver state, encryption keys, MACsec
objects and steering resources.

This change deletes all remaining SecYs, which releases all HW objects
and avoids leaks.

But this only fixes resource teardown. On resume, the macsec driver may
still potentially have a lot of state it considers offloaded, but the
resumed device will have a clean slate. Fixing that is outside the scope
of this patch.

Fixes: 3fd3fb6b6b88 ("net/mlx5e: Move MACsec initialization from profile init stage to profile enable stage")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/macsec.c      | 53 ++++++++++++-------
 1 file changed, 35 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 20eec345b36c..84ce388d3846 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -1238,33 +1238,21 @@ static int mlx5e_macsec_upd_secy(struct macsec_context *ctx)
 	return err;
 }
 
-static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
+static void macsec_del_secy(struct mlx5e_macsec *macsec,
+			    struct mlx5e_macsec_device *macsec_device)
 {
-	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
-	struct mlx5e_macsec_device *macsec_device;
+	struct net_device *netdev = (struct net_device *)macsec_device->netdev;
 	struct mlx5e_macsec_rx_sc *rx_sc, *tmp;
 	struct mlx5e_macsec_sa *tx_sa;
-	struct mlx5e_macsec *macsec;
 	struct list_head *list;
-	int err = 0;
 	int i;
 
-	mutex_lock(&priv->macsec->lock);
-	macsec = priv->macsec;
-	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
-	if (!macsec_device) {
-		netdev_err(ctx->netdev, "MACsec offload: Failed to find device context\n");
-		err = -EINVAL;
-
-		goto out;
-	}
-
 	for (i = 0; i < MACSEC_NUM_AN; ++i) {
 		tx_sa = macsec_device->tx_sa[i];
 		if (!tx_sa)
 			continue;
 
-		mlx5e_macsec_cleanup_sa(macsec, tx_sa, true, ctx->secy->netdev, 0);
+		mlx5e_macsec_cleanup_sa(macsec, tx_sa, true, netdev, 0);
 		mlx5_destroy_encryption_key(macsec->mdev, tx_sa->enc_key_id);
 		kfree(tx_sa);
 		macsec_device->tx_sa[i] = NULL;
@@ -1272,7 +1260,7 @@ static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
 
 	list = &macsec_device->macsec_rx_sc_list_head;
 	list_for_each_entry_safe(rx_sc, tmp, list, rx_sc_list_element)
-		macsec_del_rxsc_ctx(macsec, rx_sc, ctx->secy->netdev);
+		macsec_del_rxsc_ctx(macsec, rx_sc, netdev);
 
 	kfree(macsec_device->dev_addr);
 	macsec_device->dev_addr = NULL;
@@ -1280,7 +1268,24 @@ static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
 	list_del_rcu(&macsec_device->macsec_device_list_element);
 	--macsec->num_of_devices;
 	kfree(macsec_device);
+}
+
+static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
+{
+	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
+	struct mlx5e_macsec *macsec = priv->macsec;
+	struct mlx5e_macsec_device *macsec_device;
+	int err = 0;
 
+	mutex_lock(&macsec->lock);
+	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
+	if (!macsec_device) {
+		netdev_err(ctx->netdev, "MACsec offload: Failed to find device context\n");
+		err = -EINVAL;
+		goto out;
+	}
+
+	macsec_del_secy(macsec, macsec_device);
 out:
 	mutex_unlock(&macsec->lock);
 
@@ -1796,6 +1801,7 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
 
 void mlx5e_macsec_cleanup(struct mlx5e_priv *priv)
 {
+	struct mlx5e_macsec_device *macsec_device, *tmp;
 	struct mlx5e_macsec *macsec = priv->macsec;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
@@ -1803,9 +1809,20 @@ void mlx5e_macsec_cleanup(struct mlx5e_priv *priv)
 		return;
 
 	mlx5_notifier_unregister(mdev, &macsec->nb);
-	mlx5_macsec_fs_cleanup(mdev->macsec_fs);
 	destroy_workqueue(macsec->wq);
+
+	mutex_lock(&macsec->lock);
+	list_for_each_entry_safe(macsec_device, tmp,
+				 &macsec->macsec_device_list_head,
+				 macsec_device_list_element)
+		macsec_del_secy(macsec, macsec_device);
+	mutex_unlock(&macsec->lock);
+
+	xa_destroy(&macsec->sc_xarray);
+	mlx5_macsec_fs_cleanup(mdev->macsec_fs);
+	mdev->macsec_fs = NULL;
 	mlx5e_macsec_aso_cleanup(&macsec->aso, mdev);
 	mutex_destroy(&macsec->lock);
 	kfree(macsec);
+	priv->macsec = NULL;
 }
-- 
2.44.0

