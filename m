Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795730223;
	b=MFkaLEnJeaw4kOOLeBvjkjbBLYqSFF/UBkb1vkzaghE4vjOiNpZsz25dYO8M9BtRGVTA
	 TIC2freyZiUMpSFq1MKzfg4yVhiF1A53eBNp48aq3X61RMJOnANTNJu31SzFu843uPi/x
	 aW0jVIvCWQ9nF63NwZN98ZQRwwusx/4ptdwGApEdRxL5RGyhPN2tySh0KyhUcK5yk4thm
	 Ld9+8qjvWgRUmxJiM0vpbdz3h5cMUEviuahnNn612F4/7sMEKJRVXLBijUGy0xhdn5I9P
	 cFDvpOFPelbxCNYflaZrlP0JtPDcWtTaAQE3K6TrZRvxYP1NhKHvn1pHoG32G7/BhWg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795730223;
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
	bh=SU5KNsN4434e2Si3NsoOVeJi+oBOVYLXu94/C/HT8yI=;
	b=TAjf3gtw3P9WLHvJUtEBaYWAqOyuPsAkr0v9iQ8aHwLexlXIFjV2+niMoW7wPrgg25WF
	 iyPUH0LMpPN2qy8rcN/j5oSPZFQ2jRa/oiU8H5pM92Mo7SsZWTEPdiRVAGk8OwFZr/zHN
	 tbsrtQYNEZtFlfuPqbYQKj4Tv1y+1KozNfA97V1W1HpNLRuKqobYa3u6gw10AbySaX1uv
	 heWR224K54S1/adVTWgfi8hhlUNcqZEByS2T0ZyBu+zEwq+JPv66vjUyEoHFwK++/6+cB
	 y1PTIXEHFxiFIJRKvtjc/rGc9u9mh/QE5nm0q7A9pOyoeCUZ7cSdLVlM1hA3a8Zpn9w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="EvaK4Q6/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.70
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010070.outbound.protection.outlook.com [52.101.201.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B11C606A31C;
	Thu, 26 Nov 2026 21:57:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B11C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=EvaK4Q6/
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kTt9CjRENr5QvFmsRPt84gzD9BnVS0Klejxa6J8IEt+Y6emMGfoRfMsae6EuZ8X1xWakjrXpuhp2ht52pg/0T+xhbR9fsnGzwIKi2VFA/eutK1XDFGh551qIXEEzSug6fnX5//kNqCtxDb8GRM57j4zQsg8o4dsVm7hmtXNR504mas+b4x4kT5g/LZvWmavNKLgHgVJsgOap7chFo/MFNSQ6vmhNRb/ltYl1HeUZKqXQon7dA4sMIUMVqDAUBCX2wZh8G6dRGH1JUfZiP7d9+E3QPoKM7JlktKeXdWit/TIKxOCR7EEWtqCj6l/LzlBEFx3wasT/jCK1o7glHDTY9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SU5KNsN4434e2Si3NsoOVeJi+oBOVYLXu94/C/HT8yI=;
 b=NU0Ph7G2H6BgE0K974NSvuyTQTkjFKdSDwE1q2bXlCC9CGB+8UuY5D4vMjs2rvck9yo7HLLEXaiSxPPpQVtr7XTXFnxQABdVej7oKlwwaQuGX9TbuSp2HcqDVbQvGhizObKAX/uowRe/IecIQcOFk30X84A3iWg16ozAkcSVfuQ8wXcamHBSHZBmtLgH33HM7P3tLRlkqp3eDmcEvTbID/vZ08uZgaFWYWjxg8aCd7HQ4huXbABFIeSqKvJilbKbhpenaQbLccv4vBNd6Kj55Grq4sGA4oIJGiL3ixE8KdvP4cLXAeG6HBqVtYrSTN6rFyhLSy7/P4zOKJu6GO+s3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SU5KNsN4434e2Si3NsoOVeJi+oBOVYLXu94/C/HT8yI=;
 b=EvaK4Q6/Q3f8o53KvBKpdWXJ7Rjk06rvaCX9F+BBhpfKsVweRPlRyiriLPKDCPnFGvCTtOpyrqjO0CEhNWtUjcWzgLHtxX3d/uskLNRezhsE4ZQcUUt89G2o7wMk3M3ucfsprqSugF8+GczPImscVa0jEOBcIH/691WZ0Buz2XqfsFB8f0axOKzxCByjfDaMYyx8IaxcNJLDOtAVjC2J8i5Fz0XEq3sR+Jh1gnYXfvqruDnssNv6gfFmArUAXxbxwSxUhfaiAeP2g+0vG7D80/eKYnLlSBDi1d2gL9NYeLPd2hItfP494mu2s04orswFn9veT3uhsW6V+ccF41GSDw==
Received: from CH2PR14CA0060.namprd14.prod.outlook.com (2603:10b6:610:56::40)
 by CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 21:56:57 +0000
Received: from CH2PEPF000166BA.namprd04.prod.outlook.com
 (2603:10b6:610:56:cafe::2e) by CH2PR14CA0060.outlook.office365.com
 (2603:10b6:610:56::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 21:56:57 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF000166BA.mail.protection.outlook.com (10.167.252.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Thu, 26 Nov 2026 21:56:56 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 13:56:51 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 26 Nov 2026 13:56:50 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 13:56:44 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>
CC: Andrea Parri <parri.andrea@gmail.com>, Boris Pismenny <borisp@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Elliot Edmunds <eedmunds@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jeroen Massar <jmassar@nvidia.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kuniyuki Iwashima <kuniyu@google.com>, Leon Romanovsky
	<leon@kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Simon Horman
	<horms@kernel.org>, Sridhar Samudrala <sridhar.samudrala@intel.com>, "Steffen
 Klassert" <steffen.klassert@secunet.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 01/10] net/mlx5e: Initialize IPsec XArrays with XA_FLAGS_LOCK_BH
Date: Thu, 26 Nov 2026 23:56:05 +0200
Message-ID: <20261126215614.792598-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261126215614.792598-1-tariqt@nvidia.com>
References: <20261126215614.792598-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166BA:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: 755571c6-2fa6-4c34-9d30-08df4c08306a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700016|23010399003|1800799024|11063799006|261009223027099003|22082099003|18002099003|10067099003|56012099006|261102123227099003|261022105027099003|261022075727099003|261028144727099003|261021121427099003|261021123027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	gmYfmOcbnyv55VAJ/qiSU4WVsWkrxT7vfdk9yNlRcjoHcFdqQdymWEwj6M8/r/PdueJm3r4BiWXJu6+wL9c34ShRkginGc6vh0GCREV+XRpERlblskJYrIKHfA4qr7fmhCJ39Pw2J/OWOAEZny+mKX5D4LKyDsRREwixyKj+DyxCNrYWqqV+hV9LPB0+ygB0rTMR/uMZIMq8gYj+K5M5AKZ6b0I4/UjgqldwUP5tydMZpRXgALMVoQio3jSsyba0FF3xXq6rL0GPWcR5/3cMzI7uMFwpoE6wSWQ6q+cDCbgX8IMQpj9NeBSK/fsIhifWsu94kmIbxmqNrvdlilKgRNIDaOpvFONPsUaunMj2F1Z0mU7BY6vfghsaJCpbira7Mj4XdaSZL/UGEl8XTlM+clEJ44EgYzZBQ4J5imo2YVNmg4B2Y6oNP3/ZjeCvQPtmbMoMo0zOHnC0Tb4tk9a5Lav/MRzKTCJUytO0VwAjJsJYWeGsg9W1NwCnJEmz8h1OSW+2EcyZy+1ZotqLHqmzXzItObdF3w/l4GFe1F6LrHBhU65colukKClDzi6dKgt062WnA3o6bqo38R1JLbc6bpXi+OBDkLfhw+BnirYjpUTgGqYdiqsqfvoRMI/3/kitgkf+MD6AvY4Qb81C6dEm+U8/x46rgqCreyhlI5n7YwZBOI3/NVljLcEjvV28XTD4cB7YEM8gomkQQjq0NAYYCA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700016)(23010399003)(1800799024)(11063799006)(261009223027099003)(22082099003)(18002099003)(10067099003)(56012099006)(261102123227099003)(261022105027099003)(261022075727099003)(261028144727099003)(261021121427099003)(261021123027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Fgn2GBl1El/9IFExwVR2BOh0TXh3GhxfUlvW8vi8/QmAggAuv0ZYvyrXyi9hpjny29Obv+PbP7rPrlHxVDlTAPurh0S9bBczEiF1DH5F1PVq95lTYVH56TZWgADZa1EBip/MEvYhSdN3I7inZEYJRqUZhSf2LTiP7WYlGHhaXeb1r7hU8NVkMMGBBauqBPMZEC8Q2mRCZQsz5f2wR4/YbHXMyvy8jYI6gmPJIEkOPdFAtWQgTk3TlL/VzFdCZUT28mURv1q2I3ED9QhdNvMq7U8mfGOFg8z5NkRyxBrxjeMJmVUEi4ujCYtC2ngA53ThNyxX9RuQXqPcI5rqKF8vK9V0wIqpsC00fzLaiIUfr6Am3sbt8RCHAOMoPo4JHjPMIh0kLMN5ZIcTQD3QHZ61aEZGqTJOdCDfR+55wS/PD2o8vV65HtXf46fXE1zLNyLs
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 21:56:56.3923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 755571c6-2fa6-4c34-9d30-08df4c08306a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166BA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322

From: Jianbo Liu <jianbol@nvidia.com>

ipsec->sadb and ipsec->ipsec_obj_id_map are created without
XA_FLAGS_LOCK_BH, so their lock type is a plain spinlock, but every
mutation uses the _bh accessors.

Node insertion drops+reacquires the lock with the lock variants
corresponding to the configured type. Using the wrong type therefore
leaves bottom halves disabled during the allocation.

Fix this mismatch by using the correct locking type.

Discovered by Sashiko. Reproduced on ConnectX-7 (fw 28.48.1000) with
failslab failing the GFP_NOWAIT node allocation of the SA insert:

  BUG: sleeping function called from invalid context
  preempt_count: 200, expected: 0
   __xas_nomem
   __xa_insert
   mlx5e_xfrm_add_state

No splat with the fix.

Fixes: 403b383a3ce3 ("net/mlx5e: Store all XFRM SAs in Xarray")
Fixes: 91bafc638ed4 ("net/mlx5e: Handle IPsec offload for RX datapath in switchdev mode")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index fa6cb51fdb93..a549851c8382 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -1014,7 +1014,7 @@ void mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	if (!ipsec)
 		return;
 
-	xa_init_flags(&ipsec->sadb, XA_FLAGS_ALLOC);
+	xa_init_flags(&ipsec->sadb, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_BH);
 	ipsec->mdev = priv->mdev;
 	init_completion(&ipsec->comp);
 	ipsec->wq = alloc_workqueue("mlx5e_ipsec: %s", WQ_UNBOUND, 0,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 5c69e89b13a7..502d89a18f9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2804,7 +2804,8 @@ int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec,
 		mutex_init(&ipsec->tx_esw->ft.mutex);
 		mutex_init(&ipsec->rx_esw->ft.mutex);
 		ipsec->tx_esw->ns = ns_esw;
-		xa_init_flags(&ipsec->ipsec_obj_id_map, XA_FLAGS_ALLOC1);
+		xa_init_flags(&ipsec->ipsec_obj_id_map,
+			      XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_BH);
 	} else if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_ROCE) {
 		ipsec->roce = mlx5_ipsec_fs_roce_init(mdev, devcom);
 	} else {
-- 
2.44.0

