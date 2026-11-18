Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.59
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795023217;
	b=4rte0+wMa3gWh5eQ2Wj/98P930KIh1gICu8UUuswYOX6pGUpf8fYk2fUG9hqajrGMzNU
	 XGtO4vedugkgK0D+x8skheHPDPStVEdtbG9ZWzGarZBvLbbQGfUrwTgBvlykVzwwzooZy
	 6rCgfoSwfH+0IYVpAxkA5BpI5UpPhXckRJaGDYLWSonvF5q6Rv6AYNEmEesaRF8EdHQxj
	 dOqJeZYF2OrWXsTbnXrtaGYNNXrSKdcP9+SkV4+N2vgZp25TW5P+amwdd3GW2FzMRAR0Z
	 kRSahyfzJ8nLT5GjB6EhEX6FNjROB/Hqm4VcPloaHAjimkwWXod09oqgf4aRBD8iyZw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023217;
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
	bh=z8yuW0DEvRGeG5n/vMlKLLDZ+N3hVlRWgkr8WDg5Bl4=;
	b=w5Bq6Eqok+WRRKaAVfW9twcakgUmAr3op9JPuzLpYYPu07uAycXg9IQCX9j+OzCQnhGT
	 S6K7j3v070fBKVeASa6BAeSnh2+K7GMoAT4OBr5m8rgeVlxy+7YQaS0S/pDiJM/AUvxVB
	 nhM36oFtQssTUYkGpGMv4gOAWVlJxHIaTpIwo7A+s7GO/aOCWVLyiSnYadebKQMuW5nuf
	 CMP/ebIh8qW8ukM5tnxq2JEgzgNOgKfoPMHaUIl/lhSJtsoWvYibcT6HOZEp1P3aOS0DD
	 W+Dm/s4Lx9r9vw5iRU/L8VqM0Qvw6nlZNzXvBrXDENfrIZpcT1MZhgP9bEZRw7PqSGg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=T4vDpPl6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.59
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012059.outbound.protection.outlook.com [52.101.48.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3270A606A31C;
	Wed, 18 Nov 2026 17:33:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3270A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=T4vDpPl6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZFAfg9si5B+bC037B1A3M/IpJ9Kew++qqhomA8IJpm5NOI3YS4KEmzH+MSR0HJUiHpieWyNv6bblCWr9spPvDbNdBt3hMz4YQseF7a90L0A5IYHJppjt47l5cdlUE6SFnYGBz908ZSAG+zqNQqax6vzqowH7Qo54mpuvhUZ77T1e6xhGYBzf/QX292qvn9aNHnUpCM/nJzVyxUAokrHHlgbx/LQ3EKE/1g3od3xbtggwqu6i3/AnyQMsuPJEBWY/QEryZG8ejJYIYMCU4QOBWPJfu+4MtOe9Z+Tg+iBfiRA+aREgrLTJIxAZ4tsQGbHhk5VQRn/+n/etx8lJE4ar4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z8yuW0DEvRGeG5n/vMlKLLDZ+N3hVlRWgkr8WDg5Bl4=;
 b=R/UBRphqJTVpx4UxYiPLgMRz4sE3o6FkjjkPwu2KHm+EedaKs0LvNkNVmRLY/0r/SIcKxny4ElOimxGAwmTHR/fii1ohpIEoIShfJ7807LBXb5RmzjgSgBSjQGIp17PPH+52clnz4pG0e+mWyTkMBBfPlm9+APWkJe9297iT71vejDuGjXXsTbTUb5UIEIq5//h5x9EiNeHA2iKz4JZy1wt2SGnmYRO7GGF1e+HJ6ArJcUT4TxHjlsCZQEgruwSWQ0aq4EvFUh3viTv1ZwaOTWDtQWzvv5bPsZSPzhhIQ7DFnxfVqDelGwRtN7RxSfzhaiKqm2B6WcW+aO25C9JQOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8yuW0DEvRGeG5n/vMlKLLDZ+N3hVlRWgkr8WDg5Bl4=;
 b=T4vDpPl6/qtNtke3ReEb0cC3sdXFfV7qciloCADygJYGNNXY/Zy3u/cWk336CZgXP/keIbSzWuLLEdRtkNwyyiqtqxzR15/j4ejmK1020+zvInYrxRkvxvRCWj82uLtep2nEpA3mp7CwDtG4SIt1spX4RjtbKeGeJqlDuqHxLkGA6DAaZ1t+qpapaVMkFr+q6pGwJmSJd51HwIaEAPMM7dygu+uAuVCY1SjnNxRWRGwidkEexnmr3TGA6rlPLrgRjitvZruAvW/0HH8pRamRHRF4aN4rYwbDv6AM083boJdSVarOJaMvpd9Bl8zoWkqL+YXk5zX5jU3xLCQuzgxHeg==
Received: from BN9PR03CA0424.namprd03.prod.outlook.com (2603:10b6:408:113::9)
 by CH4PR12MB780039.namprd12.prod.outlook.com (2603:10b6:610:516::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 17:33:29 +0000
Received: from BN3PEPF00022BD1.namprd03.prod.outlook.com
 (2603:10b6:408:113:cafe::5e) by BN9PR03CA0424.outlook.office365.com
 (2603:10b6:408:113::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Wed,
 18 Nov 2026 17:33:28 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF00022BD1.mail.protection.outlook.com (10.167.248.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 18 Nov 2026 17:33:28 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 09:33:05 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Wed, 18 Nov 2026 09:33:04 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 18 Nov 2026 09:33:00 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexandre Cassen <acassen@corp.free.fr>, Alex Vesker <valex@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>, Gal Pressman <gal@nvidia.com>, Kees Cook
	<kees+treewide@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Prathamesh Deshpande
	<prathameshdeshpande7@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>, "Simon
 Horman" <horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, "William
 Theesfeld" <william@theesfeld.net>, Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: [PATCH net V2 2/2] net/mlx5: DR, Fix out-of-bounds write when sync to HW fails
Date: Wed, 18 Nov 2026 19:32:27 +0200
Message-ID: <20261118173227.1957670-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261118173227.1957670-1-tariqt@nvidia.com>
References: <20261118173227.1957670-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD1:EE_|CH4PR12MB780039:EE_
X-MS-Office365-Filtering-Correlation-Id: 0056fc10-18bc-4a2b-ef4b-08df459a0edd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|376014|82310400026|7416014|261021123027099003|10067099003|11063799006|56012099006|261026140227099003|261028144727099003|261021121427099003|261022105027099003|261026121527099003|261102123227099003|261009220027099003|261009221227099003|261009223327099003|261009223027099003|261009221727099003|22082099003|18002099003|6133799003|41080700001;
X-Microsoft-Antispam-Message-Info:
	u8IGRaLAbci63zDVPasCqjBTeXVSE0JEqR2vuRrdsVmk+nT191l9QKxrIyX4YA+/swKLG0QtUJh7Gyilsp3A1gXS2qBbvXGgnMJwM+cH1QupI6xJEwSnygjg0LD+XRRMbARfXS9l4KsvjspcPOuSKLmi1voaPBuZJvzANj5doaPiPVolC0jny86/6bkODDoVTr2RB7bBr0zJVzGv9MpIqWQ5VMsAUWQQNnzmhzNsBJsDmW4FXy4ujhTQsyenF1zmwWLjYgi7nCTcdn6+E6zQ2TXarpzPfuj+RfNpx7HTIgZCKcxnszif3A6A3k7T7AUVxEnZCeZqbHn36gj28Bqb+QaRV1w1kChIXuUMOxXeAzJW/8YJweuaUJNoB00w5HbPku89B+JQgDvBhmkwAUPPDN372Kj47tVVlt83Jp8BP1afHNaAq9+/uF48N/qWCp+lZF7xHFjN3yMGbpYxN7IiSUh9ZERQjuaYCmWKqljbGzX4O1BAO6fF2wCEX41gd1jOJP/+eC/CzIhAYLxLBwZQEgENJoSi2iw2uMFB8FdagSLrvP/WuANdG4ruw8cqsi9gZlS7y724L2r3b0aFwjMr/QlHZ0B+9np+ac1J5LmemYHtNW4BpoCqfq3JRgNAH3ZuVcj8ddVQsNHfVarnc+GllScoeChRQ46iqFug3r1/ptEO3CzljdKJIAlAjCaLYP/uCBke7z7sP3RcynWxo1ElMlxm+AOph+3/1HTf5DFtWXPdx2n6UkEPV1VE0PU9bK3r
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(376014)(82310400026)(7416014)(261021123027099003)(10067099003)(11063799006)(56012099006)(261026140227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261026121527099003)(261102123227099003)(261009220027099003)(261009221227099003)(261009223327099003)(261009223027099003)(261009221727099003)(22082099003)(18002099003)(6133799003)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9Xow41BxP872/k1mS99dUqrswh/pIQ7t0ZJ00uyNoEOtRmDL8E6892+4jG9q0eJEmLrp3/UX7kGi4lU0ltDXTql6qFGFhDbTDRQrY43zH0iVv5miFDsYNOF5IZNaABh9E/l2PfH0CqrH+j6nk0Hr8B0X6y8V+dPuw2bAGthhM/sKpXeWxDcf3aXuwUdZd+CTGtFx7XxCAmOToMIm5V+wsDwr0hRQv6Gr6NmN7+99KXGeGc824IFxBqn30hjVvM4Cu+qUq0NsAxuIZHPq6BNP657H3xnAhSngpDRdROXVToIidUXDjd/rSCCK+iUrdmkeCyi89mlN9yNGOjq2hXpG9RxfyfxOPTGX7cIe1eWdwYUX+1I5+5DsZ+2leRXeVVZOBSDj5V5JIs0BmfWz+iQd8Vlp9QeqQ7MzrMjHTjqipLV2kWltDemh9Amw6DOwlaVh
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 17:33:28.4762
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0056fc10-18bc-4a2b-ef4b-08df459a0edd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR12MB780039

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

mlx5dr_icm_free_chunk() moves a freed chunk to the "hot" chunks array by
writing it to hot_chunks_arr and, once the accumulated hot memory
crosses a threshold, triggers a sync to HW that flushes the array.  The
array is large enough to hold the chunks of a single accumulation cycle,
and relies on the sync path to flush it.

However, if sync to HW fails, hot chunks array is not cleared, and every
subsequent mlx5dr_icm_free_chunk will write past the end of
hot_chunks_arr, resulting in an out-of-bounds write and kernel heap
corruption.

A failed sync to HW also means it is no longer safe to recycle ICM: a
chunk's memory may only be returned to the buddy allocator (and thus be
reused) after a sync has confirmed that HW no longer references it.

The issue was discovered by a fuzzer that repeatedly triggered sync
failure, at which point the out-of-bounds write was reported by KASAN:

   KASAN log excerpt: BUG:
     slab-out-of-bounds in mlx5dr_icm_free_chunk+0x4cd at call 2
     (hot_chunks_num=3 > cap=2).

Fix this by putting the pool into an error state on the first failed
sync to HW, reporting the failure once. The sync is not retried, and
while the pool is in this state:

- mlx5dr_icm_free_chunk() doesn't queue freed chunks; the segment is
  left reserved and is reclaimed when the pool is destroyed.

- mlx5dr_icm_alloc_chunk() doesn't serve new chunks.

Fixes: 4519fc45beeb ("net/mlx5: DR, Keep track of hot ICM chunks in an array instead of list")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mlx5/core/steering/sws/dr_icm_pool.c      | 32 +++++++++++++++++--
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
index 1b928b40686e..a906a72601c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
@@ -33,6 +33,11 @@ struct mlx5dr_icm_pool {
 	u64 hot_memory_size;
 	/* hot memory size threshold for triggering sync */
 	u64 th;
+	/* Set when a sync to HW fails - no new chunks are served, freed
+	 * chunks are no longer queued, and their ICM is not returned to
+	 * the buddy allocator.
+	 */
+	bool error_state;
 };
 
 struct mlx5dr_icm_dm {
@@ -368,7 +373,15 @@ static int dr_icm_pool_sync_all_buddy_pools(struct mlx5dr_icm_pool *pool)
 
 	err = mlx5dr_cmd_sync_steering(pool->dmn->mdev);
 	if (err) {
-		mlx5dr_err(pool->dmn, "Failed to sync to HW (err: %d)\n", err);
+		/* The hot chunks could not be flushed. Put the pool in an
+		 * error state so that no further chunks are queued (which
+		 * would overflow hot_chunks_arr), and no new chunks are
+		 * served. The sync is not retried.
+		 */
+		mlx5dr_err(pool->dmn,
+			   "Failed to sync to HW (err: %d), disabling ICM pool\n",
+			   err);
+		pool->error_state = true;
 		return err;
 	}
 
@@ -443,6 +456,10 @@ mlx5dr_icm_alloc_chunk(struct mlx5dr_icm_pool *pool,
 		return NULL;
 
 	mutex_lock(&pool->mutex);
+
+	if (pool->error_state)
+		goto out;
+
 	/* find mem, get back the relevant buddy pool and seg in that mem */
 	ret = dr_icm_handle_buddies_get_mem(pool, chunk_size, &buddy, &seg);
 	if (ret)
@@ -475,6 +492,14 @@ void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chunk)
 	/* move the chunk to the waiting chunks array, AKA "hot" memory */
 	mutex_lock(&pool->mutex);
 
+	/* If the pool is in an error state, the chunk must not be queued.
+	 * ICM memory is not returned to the buddy allocator - it is
+	 * reclaimed only when the pool is destroyed.
+	 * Just free the chunk's bookkeeping struct.
+	 */
+	if (pool->error_state)
+		goto out;
+
 	pool->hot_memory_size += mlx5dr_icm_pool_get_chunk_byte_size(chunk);
 
 	hot_chunk = &pool->hot_chunks_arr[pool->hot_chunks_num++];
@@ -482,12 +507,13 @@ void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chunk)
 	hot_chunk->seg = chunk->seg;
 	hot_chunk->size = chunk->size;
 
-	kmem_cache_free(chunks_cache, chunk);
-
 	/* Check if we have chunks that are waiting for sync-ste */
 	if (dr_icm_pool_is_sync_required(pool))
 		dr_icm_pool_sync_all_buddy_pools(pool);
 
+out:
+	kmem_cache_free(chunks_cache, chunk);
+
 	mutex_unlock(&pool->mutex);
 }
 
-- 
2.44.0

