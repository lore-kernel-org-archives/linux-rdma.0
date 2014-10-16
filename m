From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: mlx5_core: Fix PowerPC support
Date: Thu, 16 Oct 2014 14:08:52 +0300
Message-ID: <20141016110852.GA16271@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Eli Cohen,

The patch 05bdb2ab6b09: "mlx5_core: Fix PowerPC support" from Jan 14,
2014, leads to the following static checker warning:

	drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c:225 free_4k()
	warn: right shifting to zero

drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
   214  static void free_4k(struct mlx5_core_dev *dev, u64 addr)
   215  {
   216          struct fw_page *fwp;
   217          int n;
   218  
   219          fwp = find_fw_page(dev, addr & PAGE_MASK);
   220          if (!fwp) {
   221                  mlx5_core_warn(dev, "page not found\n");
   222                  return;
   223          }
   224  
   225          n = (addr & ~PAGE_MASK) >> MLX5_ADAPTER_PAGE_SHIFT;

Maybe n = addr >> MLX5_ADAPTER_PAGE_SHIFT; was intended?  (Totally
random guess).

   226          fwp->free_count++;
   227          set_bit(n, &fwp->bitmask);


regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
