From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: linux-next: Tree for Mar 23 (infiniband: mlx5)
Date: Wed, 23 Mar 2016 10:26:35 -0700
Message-ID: <56F2D1CB.8080600@infradead.org>
References: <20160323132208.54ba0c1a@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160323132208.54ba0c1a-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/22/16 19:22, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add any v4.7 related material to your linux-next included
> trees until after v4.6-rc1 is released.
> 
> Changes since 20160322:
> 

on i386 or x86_64:

../drivers/infiniband/hw/mlx5/main.c: In function 'mlx5_ib_add':
../drivers/infiniband/hw/mlx5/main.c:2358:31: error: 'mlx5_ib_get_vf_config' undeclared (first use in this function)
   dev->ib_dev.get_vf_config = mlx5_ib_get_vf_config;
                               ^
../drivers/infiniband/hw/mlx5/main.c:2358:31: note: each undeclared identifier is reported only once for each function it appears in
../drivers/infiniband/hw/mlx5/main.c:2359:35: error: 'mlx5_ib_set_vf_link_state' undeclared (first use in this function)
   dev->ib_dev.set_vf_link_state = mlx5_ib_set_vf_link_state;
                                   ^
../drivers/infiniband/hw/mlx5/main.c:2360:30: error: 'mlx5_ib_get_vf_stats' undeclared (first use in this function)
   dev->ib_dev.get_vf_stats = mlx5_ib_get_vf_stats;
                              ^
../drivers/infiniband/hw/mlx5/main.c:2361:30: error: 'mlx5_ib_set_vf_guid' undeclared (first use in this function)
   dev->ib_dev.set_vf_guid  = mlx5_ib_set_vf_guid;
                              ^



-- 
~Randy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
