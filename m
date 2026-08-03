Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012002.outbound.protection.outlook.com [52.101.48.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4FC37AA77;
	Mon,  3 Aug 2026 13:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763594; cv=fail; b=XvnLUMojBCjG994nQ5a9WcETT0IExvmntv96BpBqbE4liTsSXlaBD74WJNx4s5Q5ur+tdTwZwOLnYrTOAdmTWNZwr0yu3q/Nj0c8SRDxWeXrIqFHmIfN7qQQ+jAMOj+L5k6BMTtirM7Npz4GzEHpXTIEoYX9a5rgZGKVOp1FMTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763594; c=relaxed/simple;
	bh=xmLYMWL/23p0MWjCjmxUytMgG9Fg5ADWwTixMO3Bl+w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qosK7OVQ2OHjL+/lPJ7FVn/cM6cGdYBRkhVUvON3uRh/2DvhrUX83Aav2jPZL1ieAVQ/yzYqzfxP9rL+1WaOizkqbAqa57DDBP0jTKyyObClBzZS4NHSGhKAu2Do7bsPLdzYhsbJLFobSfUnQvs1Ee50t8TfA43cO17vUWO2cGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XxvCUoKH; arc=fail smtp.client-ip=52.101.48.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XxvCUoKH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nqRPk5OOyagqg7SvP925xpMZFBRRJc1ozdiz6ONl9BJoAqKEXFk5E9AiPnzLN1CIFW3JliL/Bl33MeHdHQtjekr9zI+EUnroKMQ+XnuMTWca8cKGuV7yF1ccG2GMIVVn+tvvptcMcBsn+7z53NP6QAf+wBLVqGXgyd762xF9zkdbEeE9m0z0vpNnYOyIFhGmCEAcvvvDsnUCALo1Hiu+q2XPJ1ZttQYeA1z2FA9a+VvDl5ILkqbKv05/Dc6jlSMUuIIGFtI7Xhc8jy7Faf6jNFEvoLr59plmli3usP45L3kHIZ1MGFAtYTmtD3q5uZw6Z8CtuWOZT6pf+TBMb4/CZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0zuYFDvOaoaTOldoH5nRlVia8qUnP3j0a0jj1I2Axg4=;
 b=lPVQmsJjOnYxb5kIRoqVqXxc/gjJ6k+7Hw6twKFLffoCdIctguFin1F/tQb+B4Kmywz6XekdMNJ3CGKhRocKthXzhq7dvYYsJANh+q8HHMNK6wJFY+8sBUbEYS51tyJAW06ld78ey5xE7835cs+QgtzBcpS025wuI0mu9kthejBrzqmZ5OnhHv0XTRwIXBF3QwABYU14cjtmVEbZaE/iF8pA8jnbvBqfaTsHqvxGzhzQkCasE+GuEj5d8qrc5uoAwqzTilDm6EsrZRtbjSmrm4k0uEXLL1YU+9g4G6bA0ogW0CBK4DQ6sk2O22acwMvhWYzMwIXUA9F6sEPG+c3M6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zuYFDvOaoaTOldoH5nRlVia8qUnP3j0a0jj1I2Axg4=;
 b=XxvCUoKH7SDmZOdjkcnvAvDspfFsqC5d9YixHEiOK1dUTqg/qambidCvD99hd4ED6QmC5skbq5IZm4yDPH1oLTdUKTlDOp4gw9PP3xFgwpLoU1z9b+byBkGJ8zqnywSbNRQYB1g6zeSwrWmTzKbGHkNOpmdv96mwNdRuvytHxfVw3L0MqtpgVzMLwz0jNxjbr1tJYNYMQMvvsr8gSbOnONWFDcnQ2s7kTHS8I4+w957opc/4y5rgmR3rCkEdz0CU3Y4HkOHCqCn3xwoC+uPaR08Stw/MDgsAcEtUvUrfGYsgKn/ouKUm6Tl1k1mDhSnCc95lb/ukfpV5Y63a/erfmw==
Received: from BN9PR03CA0379.namprd03.prod.outlook.com (2603:10b6:408:f7::24)
 by MN0PR12MB5954.namprd12.prod.outlook.com (2603:10b6:208:37d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 13:26:15 +0000
Received: from BL02EPF0001A105.namprd05.prod.outlook.com
 (2603:10b6:408:f7:cafe::80) by BN9PR03CA0379.outlook.office365.com
 (2603:10b6:408:f7::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Mon, 3
 Aug 2026 13:26:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A105.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Mon, 3 Aug 2026 13:26:14 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 3 Aug
 2026 06:25:57 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 3 Aug 2026 06:25:57 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 3 Aug 2026 06:25:53 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Nimrod Oren
	<noren@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next V2 2/3] net/mlx5: allocate doorbells from dma pools
Date: Mon, 3 Aug 2026 16:25:19 +0300
Message-ID: <20260803132520.2891860-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260803132520.2891860-1-tariqt@nvidia.com>
References: <20260803132520.2891860-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A105:EE_|MN0PR12MB5954:EE_
X-MS-Office365-Filtering-Correlation-Id: 22668ea5-f24b-413d-b5c9-08def162caf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|376014|1800799024|36860700016|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wbacp2VeJv/1oKGcx741fCBY3nW1wMs+ccbDQnPSx5gabkqsB/c1P+a3nEgmdXisUWiLygZdxIJX1ndIoMZ+QQO4vhMI82+hwigUksHnW8JCpSCvE+G5FMV4YrS9eijRWEQzkd3wamI52bXhQembvsn9Bjly8sCcquTI3OpiSuqPaZRwA1mGx+HkmlYGfaZPngrQv7uswsGRqM5uFuIJcv8543OE1zIPVBzppG6hWBQioGJFt3yOBSEXhJXCaxYQaxPWBc5PFsW8iqr9nr7iYo4JrOAX/QN3ascQiG01SR29q8+g9aXXgIjYqvPnnHEUjysJwq4FJAbatr2J6bMNZ9OFXt1lQwzuvd7CUuzvPtLkZgAoy4Zr11J5sdJ7cFBbnHjRl4bcSVHuRstCmHrzT6WP3wuwK45YEkSWajVI0HvC6qgerqXzFkChS4hNI9irXq/uJ7qEZgrrZ50Pk95aADS12j0HcYGThrqFQFGjyQCGQD/1pQ8oMAfpOXmPbRJ1drjq1W+oNH4pSuBFjo4neHBa85ObP+PfQHKItVCsTzpwM2SHce/9GZzaZCvye6xp6Y+bUGIjjhEL74+ruPKCLQXM792ZM0/dpAlRex5fuzKKdIosyyc9CjyEo7a5TS22gUWCJnv5PEhw3dW3b2xwIKOx58jjZ9RTCcC82PzFCuaP07nhJye5+7khtFKHwfAq4pwtoq2oxRAbfCCq2Ygf7Q==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(376014)(1800799024)(36860700016)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FHS8V72HDExLMJ1nuYp2tDrxDdbNh8JDecs2OmPpWI5QCSHYKWB4jrdVjHQ3Ay+HQSZy2aImj4y8I1CIztL3hUgF48f0JmPp3Flyu6MVZR3v6jvWZubDNkdyFB/8jPXudCSXX7fZiytOmhPj27U9VcsRL3yBOh0U0SI44BZUEsN68FWcKL2iQ3S6rB03xLfxrbCnUIPeTUDnHvriEBZGnQ1Ymsr+us2oncDX5ilLWiMwugH91F/P4D+vWuEF4FDLMLI02A792eaMhpA/SN/CCtJjCgfWlvF6PG6NTi4AqljBdVpNsgXgNEWmQrjjq9odT7lfxMqJbcT23k83O4W1gi31E3zS4p8AHB8PEuOp5Z93pjKunc5V7G/MF9IK31mX4UNTgcXemZj3CFzIWI1QGMWSsyXA24K2GPl1lGyZI4oWQZmSr7cFUfIsHQqThmc+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 13:26:14.5176
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22668ea5-f24b-413d-b5c9-08def162caf0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A105.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5954

From: Nimrod Oren <noren@nvidia.com>

Allocate doorbells from dma pools instead of the pgdir allocator.
Doorbell records remain cache-line sized coherent DMA allocations, but
their sub-allocation is now handled by the common mlx5 DMA pool
infrastructure.

This also makes doorbell allocation honor the requested NUMA node when
reusing existing backing pages. The old pgdir allocator used the
requested node only when allocating a new pgdir page; later
allocations scanned one global pgdir list and could take any pgdir with
a free entry, even if that page had been allocated for a different
NUMA node. Selecting the per-node DMA pool before sub-allocation keeps
reused doorbell records on pages allocated for the requested node.

Signed-off-by: Nimrod Oren <noren@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/alloc.c   | 111 +++---------------
 .../net/ethernet/mellanox/mlx5/core/main.c    |   4 -
 include/linux/mlx5/driver.h                   |   5 +-
 3 files changed, 18 insertions(+), 102 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
index 3c9938068c56..3975c726d35c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
@@ -48,13 +48,6 @@
 #define MLX5_FRAG_BUF_POOLS_NUM \
 	(PAGE_SHIFT - MLX5_FRAG_BUF_POOL_MIN_BLOCK_SHIFT + 1)
 
-struct mlx5_db_pgdir {
-	struct list_head	list;
-	unsigned long	       *bitmap;
-	__be32		       *db_page;
-	dma_addr_t		db_dma;
-};
-
 struct mlx5_dma_pool {
 	/* Protects page_list and per-page allocation bitmaps. */
 	struct mutex lock;
@@ -481,106 +474,36 @@ int mlx5_db_pools_init(struct mlx5_core_dev *dev)
 	return 0;
 }
 
-static struct mlx5_db_pgdir *mlx5_alloc_db_pgdir(struct mlx5_core_dev *dev,
-						 int node)
-{
-	u32 db_per_page = PAGE_SIZE / cache_line_size();
-	struct mlx5_db_pgdir *pgdir;
-
-	pgdir = kzalloc_node(sizeof(*pgdir), GFP_KERNEL, node);
-	if (!pgdir)
-		return NULL;
-
-	pgdir->bitmap = bitmap_zalloc_node(db_per_page, GFP_KERNEL, node);
-	if (!pgdir->bitmap) {
-		kfree(pgdir);
-		return NULL;
-	}
-
-	bitmap_fill(pgdir->bitmap, db_per_page);
-
-	pgdir->db_page = mlx5_dma_zalloc_coherent_node(dev, PAGE_SIZE,
-						       &pgdir->db_dma, node);
-	if (!pgdir->db_page) {
-		bitmap_free(pgdir->bitmap);
-		kfree(pgdir);
-		return NULL;
-	}
-
-	return pgdir;
-}
-
-static int mlx5_alloc_db_from_pgdir(struct mlx5_db_pgdir *pgdir,
-				    struct mlx5_db *db)
+int mlx5_db_alloc_node(struct mlx5_core_dev *dev, struct mlx5_db *db, int node)
 {
-	u32 db_per_page = PAGE_SIZE / cache_line_size();
+	struct mlx5_dma_pool_page *page;
+	struct mlx5_dma_pool *pool;
+	unsigned long idx;
 	int offset;
-	int i;
-
-	i = find_first_bit(pgdir->bitmap, db_per_page);
-	if (i >= db_per_page)
-		return -ENOMEM;
 
-	__clear_bit(i, pgdir->bitmap);
+	node = node == NUMA_NO_NODE ? numa_mem_id() : node;
 
-	db->u.pgdir = pgdir;
-	db->index   = i;
-	offset = db->index * cache_line_size();
-	db->db      = pgdir->db_page + offset / sizeof(*pgdir->db_page);
-	db->dma     = pgdir->db_dma  + offset;
+	pool = dev->priv.db_node_pools[node];
+	page = mlx5_dma_pool_alloc(pool, &idx);
+	if (!page)
+		return -ENOMEM;
 
-	db->db[0] = 0;
-	db->db[1] = 0;
+	offset = idx << pool->block_shift;
+	db->u.pool_page = page;
+	db->index = idx;
+	db->db = (__be32 *)((u8 *)page->buf + offset);
+	db->dma = page->dma + offset;
 
 	return 0;
 }
-
-int mlx5_db_alloc_node(struct mlx5_core_dev *dev, struct mlx5_db *db, int node)
-{
-	struct mlx5_db_pgdir *pgdir;
-	int ret = 0;
-
-	mutex_lock(&dev->priv.pgdir_mutex);
-
-	list_for_each_entry(pgdir, &dev->priv.pgdir_list, list)
-		if (!mlx5_alloc_db_from_pgdir(pgdir, db))
-			goto out;
-
-	pgdir = mlx5_alloc_db_pgdir(dev, node);
-	if (!pgdir) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	list_add(&pgdir->list, &dev->priv.pgdir_list);
-
-	/* This should never fail -- we just allocated an empty page: */
-	WARN_ON(mlx5_alloc_db_from_pgdir(pgdir, db));
-
-out:
-	mutex_unlock(&dev->priv.pgdir_mutex);
-
-	return ret;
-}
 EXPORT_SYMBOL_GPL(mlx5_db_alloc_node);
 
 void mlx5_db_free(struct mlx5_core_dev *dev, struct mlx5_db *db)
 {
-	u32 db_per_page = PAGE_SIZE / cache_line_size();
-
-	mutex_lock(&dev->priv.pgdir_mutex);
-
-	__set_bit(db->index, db->u.pgdir->bitmap);
-
-	if (bitmap_full(db->u.pgdir->bitmap, db_per_page)) {
-		dma_free_coherent(mlx5_core_dma_dev(dev), PAGE_SIZE,
-				  db->u.pgdir->db_page, db->u.pgdir->db_dma);
-		list_del(&db->u.pgdir->list);
-		bitmap_free(db->u.pgdir->bitmap);
-		kfree(db->u.pgdir);
-	}
+	struct mlx5_dma_pool_page *page = db->u.pool_page;
+	struct mlx5_dma_pool *pool = page->pool;
 
-	mutex_unlock(&dev->priv.pgdir_mutex);
+	mlx5_dma_pool_free(pool, page, db->index);
 }
 EXPORT_SYMBOL_GPL(mlx5_db_free);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index b3cb090b5677..5f28d906c35b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1819,8 +1819,6 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	INIT_LIST_HEAD(&priv->bfregs.wc_head.list);
 
 	mutex_init(&priv->alloc_mutex);
-	mutex_init(&priv->pgdir_mutex);
-	INIT_LIST_HEAD(&priv->pgdir_list);
 
 	priv->numa_node = dev_to_node(mlx5_core_dma_dev(dev));
 	priv->dbg.dbg_root = debugfs_create_dir(dev_name(dev->device),
@@ -1900,7 +1898,6 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	mlx5_frag_buf_pools_cleanup(dev);
 err_frag_buf_pools_init:
 	debugfs_remove(dev->priv.dbg.dbg_root);
-	mutex_destroy(&priv->pgdir_mutex);
 	mutex_destroy(&priv->alloc_mutex);
 	mutex_destroy(&priv->bfregs.wc_head.lock);
 	mutex_destroy(&priv->bfregs.reg_head.lock);
@@ -1926,7 +1923,6 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 	mlx5_db_pools_cleanup(dev);
 	mlx5_frag_buf_pools_cleanup(dev);
 	debugfs_remove_recursive(dev->priv.dbg.dbg_root);
-	mutex_destroy(&priv->pgdir_mutex);
 	mutex_destroy(&priv->alloc_mutex);
 	mutex_destroy(&priv->bfregs.wc_head.lock);
 	mutex_destroy(&priv->bfregs.reg_head.lock);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 4246d6d904ba..2c56bb1d676d 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -599,9 +599,6 @@ struct mlx5_priv {
 	struct mutex            alloc_mutex;
 	int                     numa_node;
 
-	struct mutex            pgdir_mutex;
-	struct list_head        pgdir_list;
-
 	struct mlx5_frag_buf_node_pools **frag_buf_node_pools;
 	struct mlx5_dma_pool **db_node_pools;
 	/* end: alloc stuff */
@@ -808,7 +805,7 @@ struct mlx5_core_dev {
 struct mlx5_db {
 	__be32			*db;
 	union {
-		struct mlx5_db_pgdir		*pgdir;
+		struct mlx5_dma_pool_page	*pool_page;
 		struct mlx5_ib_user_db_page	*user_page;
 	}			u;
 	dma_addr_t		dma;
-- 
2.44.0

