Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795730269;
	b=FBASqRGyHkYzQLFB1fzjZ0b2vayjhA2i+jeCzhjCm7pI2FcmySac5tHi7k5tW6s0ldeV
	 X5ZDKU1g5dro1xbRTS0u4xFatbUPtJSzPJhZLzcw0C0qWHEhAK3sJNwh+ppC880ey/6SG
	 NjxWlfY2tpjl1xDJVKZp+4RXJJm6JGYI2HsPhHFKseBRNzClhguuAf6ZvyDYw3Ol4XiBx
	 KN/gQRJYUQAL6OMhzGrSVJdctwxk7QIRlEuCUkfQVOwj43lH+L5zOiuh75ti+eU9qIiWN
	 drqsFj3xQv/aMlQwojWoYZk/vV/8YYxBobYuac0l+FREu4n+OpbM8bBcp5x2SYHt7yg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795730269;
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
	bh=SRdOXdsjXNjNP0koVsqfvBpwG12nTobCAq//CuDJ1D8=;
	b=ODmsXHki7ngaofd6dR2Dsvgww8vqaSqL/I/vQA7SMF8AZRCw6eTvh6cJA/9Qm0sd6hOZ
	 bwBw51S3a3d1or3cwOckET55exz94CHNQo9MzCFMiV6fArJbT3n2LNC5TrLT7e7eEqJVG
	 lg9ro9UO3C5MQshzzqxhDLulM0sJz/a4nw9+UWx3wRgOXsVQcK0s2H3nDTB9OQp0hBkDb
	 yUXs1D3leDCQpDGPN+HUmnDwUIoA3YzxpZqqmtzIrJTS8bvViFu5UM7atZRY7/Rx0Jq0H
	 IJA0WUns/Nbi7djWQyAwhdcJm08zloCP/N9qumpKxcIMggdQ+glamz3892IDh7UWaMQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fo1j4zjc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.65
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012065.outbound.protection.outlook.com [40.93.195.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780BC606A69E;
	Thu, 26 Nov 2026 21:57:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 780BC606A69E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fo1j4zjc
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ftPY/RxOSa7aij0gn0I5Ipj/oLqSDLumwV1xJqz+le+CulgA31RWIr/K1+SbD9TtXcASBIzblqkLTWEn3tzR0dOn1/HGhBWXWmWw2R6MBxV7uN+pn2HzOWreQbrBRVx7NWZQ1Nifl8igQR2kunPpkq0Wd1uNty8bwFUOnb+9K60rwQfsoCxynnyzDIjXn0XU9wyCoYHqC6N0ulW0v4G6g03fIOWCaubgEgXTlCQxlF9AFMIl77bFV6bj+QnlitwDrJyUEZINmVmyuI5+4nYBB5c7pqL+l1AlJ+nLZQ7J/SoWTtfUF319gLKjCBVIAEyxCTgbhhaU6IcYdggUjz/ACw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SRdOXdsjXNjNP0koVsqfvBpwG12nTobCAq//CuDJ1D8=;
 b=sX4F4n7JldxNDbFb3PejW8Iup0VR6h6bHO5olZ3oSJT9HJWjb6dR8a9ayxn9KM5ZM6oxKcjl4vdTBP9Ec9dm3EHZSrU6d0cbIsVra7s6o0GMdzDzCo0hIOy3SlW5b7mzo0XKC2OqNa0LUzPHAWWAMtEb6zfzb7oEy+nbXfz7Hpf9ijlFsiWr5ZZbDjRfcRQSmN2mbqmjM2gh8CWcyw+w95hqGda6bRlZZkJfek9ZQoFhACxl+Eq9aziVdfWqFc+pNVsXrlHHzXO/XW5v7fCcVjX30hYsTwdYG82myZvqMp4N9UU4kObIdbG6iSoK9tv1vb8zHMQfHzQBrZVl5HT/cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SRdOXdsjXNjNP0koVsqfvBpwG12nTobCAq//CuDJ1D8=;
 b=fo1j4zjcKTClpTtJI6N/Af7/tC3EFYEfzirpNh23E9Kgw3AvWyJTCXNR47hdnHww9+G7u+6vZo4b4QaRDgQOnmqdcGAcSf6wLqyFwR19q7QeNFIAYfsn3YJB7nSzlS1LTbdW0GIBukh0tIYWO7GhoAVNwtTM67HK0jyj8820YFlOknlI4GkC8/n0zJiqvDE0nMveZjOCGhYroaY+icc/mYdYubwnZJmMu41YAxomUh1dZJMUlYToxo8X0ez5EUxpUzdGIGM52t2JjIpeDxK8+PcfvlXMhlHaz49tLPgbWH76fyO9Wo2Lsiwmf0s87QV8fkz7D092Sy2YHt5Ix/OI8A==
Received: from DS7PR06CA0022.namprd06.prod.outlook.com (2603:10b6:8:2a::10) by
 MN2PR12MB4128.namprd12.prod.outlook.com (2603:10b6:208:1dd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 21:57:41 +0000
Received: from DM3PEPF000265BE.namprd04.prod.outlook.com
 (2603:10b6:8:2a:cafe::43) by DS7PR06CA0022.outlook.office365.com
 (2603:10b6:8:2a::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 21:57:41 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM3PEPF000265BE.mail.protection.outlook.com (10.167.23.251) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Thu, 26 Nov 2026 21:57:41 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 13:57:39 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 26 Nov 2026 13:57:39 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 13:57:33 -0800
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
Subject: [PATCH net 09/10] net/mlx5e: Serialize IPsec netevent MAC snapshots
Date: Thu, 26 Nov 2026 23:56:13 +0200
Message-ID: <20261126215614.792598-10-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM3PEPF000265BE:EE_|MN2PR12MB4128:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e42a2d8-1313-4c28-78f9-08df4c084b0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|1800799024|36860700016|7416014|376014|22082099003|18002099003|3023799007|56012099006|11063799006|261022075727099003|261026140227099003|261022105027099003|261028144727099003|261021121427099003|261009223027099003|261102123227099003|261021123027099003|10067099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	9Wkjv6M62wxhb6YFZVZD4v50pURlYUgHxWOrLVYRwZGLUuNg619iK+ZzZ7dalalZjCn97fN1xmIbKCPXCRzNDJ3CLQJtOFSN1djsUn8St4/sh03fvftzkwKP6ab3ox32sBImjFNyWq8VmBH8pgNiNKB57l/Mxor62kDOZXMRXfSvWblvL7TFtQ2Tr6s0o1jL7RRy8hXVO6VoN9dgEIPPoPaVUJ5uIpEydT/FuN3itnsuN6oJc7nPLQ/fmS346VjD2z6IePB31xCv9A0VJ0wklirHFt08MiDtjnGY+6Ffw+chSTiwW4IlziIWQxx5S71gYSaJfzwUSUQSY0+Ep3ebuFwBWWQBUyt9tjLHqb6FVYqyxMfXhtpdOri9XXXmMRIozNCjHLzMn73lxPB/UZIA20W679DgKfxq1fvKakMhhTKV9gfdgjptsNLTIgxR3wLcw/TzP8EcXwuhATdGHEtYaE7l3qCiM3MkazPl7/eF0Fos5i9CeBffpKEr2AWcE9Kc4DOhupnBwbpDTAidqfuLhCkrEXHRhVNKabSkW2wve5CvqQCStJH8wfQoy+BgyhRLoZQhNi5ZcEKIPe0kCYf23SrBsygfCeKshTUfpx6uLh1m+wJy7WrQslQ/hHH7qMXzB2MDvsZDMJRuDNS8TWHqRaud8c3Agtp7HSQexEDjHzi45q2nZBDtFCTfbrhG2rrgJZc1UvFbvEovtb2MfkCScQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(1800799024)(36860700016)(7416014)(376014)(22082099003)(18002099003)(3023799007)(56012099006)(11063799006)(261022075727099003)(261026140227099003)(261022105027099003)(261028144727099003)(261021121427099003)(261009223027099003)(261102123227099003)(261021123027099003)(10067099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Iezman3aG6uAg5cFTjm1+LUhneatj+wqM2NkEJS0eYCzOm99a9jpMD/2tSGr+mYNGjh27X1nAqFpz3L59o+fpOzHd+7YAQhgDV9N7TcE20inetePJO9VNFJx6BIVtbwLjYAOSKi5ifG45MroVE3WSLG8x8/aDJYEvtDTVUD7mbT074PyBCg+47VGiHkzrJJK+rOLG+xk69AgtLaOArT87u5NV3LztT4bNX/Vhg4QZdSLtfj+pFEpKeDvi3AcNKg+WcMRmaXbRl9GfX5rNTFRzsbfQJSpvI7L5kBkJXp1W6mjQsbjmROy/6OJM0NjLxOb3Z1WrSfHctwV1aRKgbcgRMlZzqOd/PcdLYGGZnT5wi78HW5Wa8EmvSEw54ZlJ1IpLE4JRBsTA8F5lRub5qUVwWGSMNL1FyEqRVH49xoBAdK++dTKdjwhje9erVPjI4gB
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 21:57:41.1131
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e42a2d8-1313-4c28-78f9-08df4c084b0c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265BE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4128

From: Jianbo Liu <jianbol@nvidia.com>

mlx5e_ipsec_netevent_event() runs in atomic context on the global
netevent chain and snapshots the neighbour MAC into the per-SA work
data, which mlx5e_ipsec_handle_netdev_event() then reads from a
workqueue. The two are unsynchronized and can tear the address.

Protect the shared address with a dedicated spinlock in struct
mlx5e_ipsec_netevent_data. x->lock can't be taken here, it may
deadlock with the ASO event path.

Discovered by Sashiko. Not reproduced, the window is a few
instructions wide. Tested on ConnectX-7 (fw 28.48.1000) under KASAN
and lockdep with 10k neighbour updates during traffic, no splat.

Fixes: 4c24272b4e2b ("net/mlx5e: Listen to ARP events to update IPsec L2 headers in tunnel mode")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   | 14 ++++++++++++--
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |  2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index cc75fcb0aa15..60f7dc3df355 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -701,15 +701,20 @@ static void mlx5e_ipsec_handle_netdev_event(struct work_struct *_work)
 	struct mlx5e_ipsec_sa_entry *sa_entry = work->sa_entry;
 	struct mlx5e_ipsec_netevent_data *data = work->data;
 	struct mlx5_accel_esp_xfrm_attrs *attrs;
+	u8 addr[ETH_ALEN] __aligned(2);
 
 	attrs = &sa_entry->attrs;
 
+	spin_lock_bh(&data->lock);
+	ether_addr_copy(addr, data->addr);
+	spin_unlock_bh(&data->lock);
+
 	switch (attrs->dir) {
 	case XFRM_DEV_OFFLOAD_IN:
-		ether_addr_copy(attrs->smac, data->addr);
+		ether_addr_copy(attrs->smac, addr);
 		break;
 	case XFRM_DEV_OFFLOAD_OUT:
-		ether_addr_copy(attrs->dmac, data->addr);
+		ether_addr_copy(attrs->dmac, addr);
 		break;
 	default:
 		WARN_ON_ONCE(true);
@@ -720,6 +725,7 @@ static void mlx5e_ipsec_handle_netdev_event(struct work_struct *_work)
 
 static int mlx5_ipsec_create_work(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	struct mlx5e_ipsec_netevent_data *ndata;
 	struct xfrm_state *x = sa_entry->x;
 	struct mlx5e_ipsec_work *work;
 	void *data = NULL;
@@ -754,6 +760,8 @@ static int mlx5_ipsec_create_work(struct mlx5e_ipsec_sa_entry *sa_entry)
 		if (!data)
 			goto free_work;
 
+		ndata = data;
+		spin_lock_init(&ndata->lock);
 		INIT_WORK(&work->work, mlx5e_ipsec_handle_netdev_event);
 		break;
 	default:
@@ -1023,7 +1031,9 @@ static int mlx5e_ipsec_netevent_event(struct notifier_block *nb,
 
 		data = sa_entry->work->data;
 
+		spin_lock_bh(&data->lock);
 		neigh_ha_snapshot(data->addr, n, sa_entry->dev);
+		spin_unlock_bh(&data->lock);
 		queue_work(ipsec->wq, &sa_entry->work->work);
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index d60c72df0bf1..e70189f81ffb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -172,6 +172,8 @@ struct mlx5e_ipsec_work {
 };
 
 struct mlx5e_ipsec_netevent_data {
+	/* Protects addr shared by the notifier and workqueue. */
+	spinlock_t lock;
 	u8 addr[ETH_ALEN];
 };
 
-- 
2.44.0

