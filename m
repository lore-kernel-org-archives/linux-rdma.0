From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: ib_core: Init subsys if compiled to vmlinuz-core
Date: Fri, 1 Dec 2017 17:02:12 -0700
Message-ID: <20171202000212.GD20454@ziepe.ca>
References: <20171127133905.8231-1-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171127133905.8231-1-dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 27, 2017 at 01:39:05PM +0000, Dmitry Monakhov wrote:
> Once infiniband was compiled as core component it's subsystem must be
> enabled before device initialization. Otherwise this result NULL pointer
> dereference during mlx4_core init, calltrace:
> ->device_add
>   if (dev->class) {
>      deref  dev->class->p =>NULLPTR
> 
> #Config
> CONFIG_NET_DEVLINK=y
> CONFIG_MAY_USE_DEVLINK=y
> CONFIG_MLX4_EN=y
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  drivers/infiniband/core/device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-rc, thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
