Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010032.outbound.protection.outlook.com [52.101.201.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A98F3DAAAD;
	Thu, 23 Jul 2026 07:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791412; cv=fail; b=GDJ3gMEOdd98gC71ZgoLdSVHyr5XuigTHwXnwE5D/9PO3naZN98vKDU0rYodEnIh7ilbkV8cSAMcXshUXOsD7kkMUhBcpLP2bGGAdi6pOaPip0kFloexu8hpuPuOc3j7D2/vTQ3fsv9USfBuGCrrKUqL4zYX+snwR5j1GuU5m68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791412; c=relaxed/simple;
	bh=xmLYMWL/23p0MWjCjmxUytMgG9Fg5ADWwTixMO3Bl+w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GsbOxueZ41egmxNlkZSFwOGTBjchI761vmrM9dG3axOdLaddHX6YGXdOiYZHTp8Tx418Jxz3794ijPV52uYQg40iNdWr8CDEE2Oh8bP7qnpyu1p32BV1AlMvY+VmFDkypCKbrGrDPQDaVr/lX88wDx8meor0pzPbc6+t8NOQ/ew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M6sjl7KP; arc=fail smtp.client-ip=52.101.201.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M6sjl7KP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oij0Fp11YFmlxWsHoowEi8eZlkC+a7Z/o+gdkVnTRX5vTc3Blfozx2X8a/u2CWM7KLdEs5i3QKelxkNPvlSEv1zj4pF69v5xQlLzkTU1QN3c7cigmf3WsaxkHVPdwT+kXMMFvXTR7/j45yaauxrGsAxK4ZX03eAVxmRK/Cvu2QUTaKg72zZPPy74B/gAbnCSe0pAxm6t5ts1MIb9Luf8SDMEODSEoRepmmMeBNntr7LiG59hU/aezdt0ifpPouXcNBwNLERfSGzqAU+taxfJRaMrColn/7VMlF7EJyfagtUuuThHbKxriQzhBM/67kMcmIRqYbgkvRagha+ZD+mGFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0zuYFDvOaoaTOldoH5nRlVia8qUnP3j0a0jj1I2Axg4=;
 b=ttPVf65eCt3Of1JXl/4gptIwm2D/cBLj9WWqVB6/Nwnn3tmgQJGn1oSRZq4btoLE/ABBh2Dt8PLFQFG9gAJn/0Fy20VuacVtrVkAM8CnP6JwkHHNhgpO9i0VZUJGkHOz4d/rq1Nxyx1VHEXZ49mR2CG6giKPAg2hQzWAS0Y9cDWHY1jzJS9A4LYU0WxCguJu6g5mZA/dq1hIJJVHMsuRjeCT6KwNVfSD8Xe2deZddK0YEo7vHQCOqov5jKuaPTRtwlqhVHTuHFJ0Au8VCMxAAcKh1vJMH5r5soUNrG/yd+kLs8rg1QddTZnVg8Ndtdmp+YNu4IeXe7d77elpRZncTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zuYFDvOaoaTOldoH5nRlVia8qUnP3j0a0jj1I2Axg4=;
 b=M6sjl7KPBXLSkSlwiiNp4TlYv+TuvXgLYBx4KyyEbpx198p+Rq2xb9jWsdM0uYFd0wKnjcy/sYA8q5FkJgLfoqCcX6jL5VRcSdMh2WBJVPMRQAvGZdt1iRy9mPnrGGJYnPGtWes4tKnI4UCKlRlLN1zIPzedDFflB45H9kUb7+c/pn8aLUH4f0PeTpWro0r0NeFMiZXr1W2y/s5A+BaGcrSh/sVSYpGH3DTq29cpMzVteMgDOJy3krwrPo/IogHLKZ/uQJvMV6+VhE8cWKvytduWjGM6lbo08G+vEDQM5VXt4HHFlPESSXpelbT20OZWtEBLvAUS03XfeSPsQA/p7A==
Received: from CH2PR11CA0012.namprd11.prod.outlook.com (2603:10b6:610:54::22)
 by CH2PR12MB4263.namprd12.prod.outlook.com (2603:10b6:610:a6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 07:23:19 +0000
Received: from DS2PEPF000061C8.namprd02.prod.outlook.com
 (2603:10b6:610:54:cafe::3f) by CH2PR11CA0012.outlook.office365.com
 (2603:10b6:610:54::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Thu,
 23 Jul 2026 07:23:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF000061C8.mail.protection.outlook.com (10.167.23.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 07:23:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 00:23:03 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 00:23:02 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 00:22:59 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Nimrod Oren
	<noren@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next 2/3] net/mlx5: allocate doorbells from dma pools
Date: Thu, 23 Jul 2026 10:22:21 +0300
Message-ID: <20260723072222.1863558-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260723072222.1863558-1-tariqt@nvidia.com>
References: <20260723072222.1863558-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C8:EE_|CH2PR12MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: 378dadbb-037e-4793-78e7-08dee88b4531
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|82310400026|376014|56012099006|10067099003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	75ITjaRPwPsUpYP9ikwIa3N2Qcrem4VSH0YYQMh2p0HCV9QEViLOZfFEGXGKHVy7YppFq3phOXP36Zix8hWs48+JPjormtyus3y+lWmkHWOdXhl+O9ihf/zjuTaXiA/My9rvPcRsBx98C4IRyMN8F3Rv2jVZtAs5nDcBPvdW4OD4gdxCeU+UQdWRbvn4Dqqq+SBZDk2dIF7fzKbcU9SFUQxc6PinPeBpe5lbVD1Yh9QpAMOn+izAz6xUPeZjGXjNKaU4qHR0MS9JsueWEocpN1kkbU09un9GDKbg1wYj3xvJsqh9BYM5D8OKuQjvQ9zOh5PY3HFIV7w/jq0mvz75g+3fd3+Q6c4kZP93c7x8P+cq3ZHGMgjm6JTdbZLJigHzlDNEt+fRrE4ueaU+NL9ALmWe9XOqHJEadDcRVuX+Tvg1NvRclksFA6v/uz+2ePPpj4UmsHTSmwbxf+fwdoendYeyVwwW6pY7amXfE4rUkFnK8acu7/ruos1le7TRIjiyBw+hyW6GhgCRyaWzBV176vLaF/ytGuxjG96XzT2EnvteJhKV0ZCaK3emKA9gXo7VoRaiILeVVwH7oGrvVq7N2GEnk1nkwcPOllwPQWiULfcnZ5XPGSK7xU53V47p14uD7SvSDVTcMOv9DwpsdPBgHzfL6CavDoM9jq3vQGhCDyni2RZcD4DNFfK8CALJPcGTHAGYrrulO4oKONcHJPpclQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(82310400026)(376014)(56012099006)(10067099003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qi97DQ/X6919C0GbbQv3ow7v/mU6BbURnc2agcD1+NxjUUotEBbhzVu2+6okel4WF3eZ4rQJaXHY1MZZx9lbPlwXGUuKf3AocP4RN5BXK5AmphenE2QdXcA22/Tb2hFTGl3UGtPxJbfiaonqjSuYNCzADmi4fyXG5aRb0ezHOCpwJCCATO0vD4RrAtlKDIJqMGneGgQO9/U4aY5h3/IKH6ldlPgdhthIRsZqHt+FZT38rldIPbG4T9m7CeFaxsCguDgiu3NRpRigmS1p9OpHx0fRsiHw0FTdV9RSBcojtO7ER6E48WKgSRyCkhCjHmM1iB3YcFEHJaKjqmxCrPU6wOF2wXA/g3Z/S03PUL+Pa0IF2ny/pTcsIqRQj5KroGSd/42CVIHlgZz9FAYT+keKCIGtD3Xmr83Qw9OwcEAU434NFly1Yxtrp03xw0MMwQHQ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 07:23:19.0673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 378dadbb-037e-4793-78e7-08dee88b4531
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4263

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

