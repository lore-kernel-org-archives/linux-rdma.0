From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: mlx5_core: Fix PowerPC support
Date: Sun, 19 Oct 2014 11:09:28 +0300
Message-ID: <20141019080928.GF31103@mtldesk30>
References: <20141016110852.GA16271@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141016110852.GA16271@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 16, 2014 at 02:08:52PM +0300, Dan Carpenter wrote:
> Hello Eli Cohen,
> 
> The patch 05bdb2ab6b09: "mlx5_core: Fix PowerPC support" from Jan 14,
> 2014, leads to the following static checker warning:
> 
> 	drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c:225 free_4k()
> 	warn: right shifting to zero
> 
> drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
>    214  static void free_4k(struct mlx5_core_dev *dev, u64 addr)
>    215  {
>    216          struct fw_page *fwp;
>    217          int n;
>    218  
>    219          fwp = find_fw_page(dev, addr & PAGE_MASK);
>    220          if (!fwp) {
>    221                  mlx5_core_warn(dev, "page not found\n");
>    222                  return;
>    223          }
>    224  
>    225          n = (addr & ~PAGE_MASK) >> MLX5_ADAPTER_PAGE_SHIFT;
> 
> Maybe n = addr >> MLX5_ADAPTER_PAGE_SHIFT; was intended?  (Totally
> random guess).
> 

No, I need to find the index of the 4K fragment within the system page
(64K in the case of PPC) so I need to mask out the higher bits. I
assume you are seeing this when building on x86. When the system page
size is 4K then n will always equal zero but in the case of larger
page sizes (e.g. ppc), n could have non-zero values.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
