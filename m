From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: net/mlx5e: Allocate DMA coherent memory on reader NUMA node
Date: Tue, 28 Jul 2015 19:59:35 +0300
Message-ID: <20150728165934.GC21317@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

[ You didn't introduce this, you just renamed the function so now it
  shows up as a new warning.  - dan ]


Hello Saeed Mahameed,

The patch 311c7c71c9bb: "net/mlx5e: Allocate DMA coherent memory on
reader NUMA node" from Jul 23, 2015, leads to the following static
checker warning:

	drivers/net/ethernet/mellanox/mlx5/core/alloc.c:156 mlx5_db_alloc_node()
	warn: missing error code here? 'mlx5_alloc_db_from_pgdir()' failed. 'ret' = '0'

drivers/net/ethernet/mellanox/mlx5/core/alloc.c
   147  int mlx5_db_alloc_node(struct mlx5_core_dev *dev, struct mlx5_db *db, int node)
   148  {
   149          struct mlx5_db_pgdir *pgdir;
   150          int ret = 0;
   151  
   152          mutex_lock(&dev->priv.pgdir_mutex);
   153  
   154          list_for_each_entry(pgdir, &dev->priv.pgdir_list, list)
   155                  if (!mlx5_alloc_db_from_pgdir(pgdir, db))
   156                          goto out;

There should probably be a "ret = -ENOMEM;" here.

   157  
   158          pgdir = mlx5_alloc_db_pgdir(dev, node);
   159          if (!pgdir) {
   160                  ret = -ENOMEM;
   161                  goto out;
   162          }
   163  
   164          list_add(&pgdir->list, &dev->priv.pgdir_list);
   165  
   166          /* This should never fail -- we just allocated an empty page: */
   167          WARN_ON(mlx5_alloc_db_from_pgdir(pgdir, db));
   168  
   169  out:
   170          mutex_unlock(&dev->priv.pgdir_mutex);
   171  
   172          return ret;
   173  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
