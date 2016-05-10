From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH] IB/mlx5: set correct gid_tbl_len for MAD_IFC
Date: Wed, 11 May 2016 00:09:05 +0300
Message-ID: <20160510210904.GA135142@x-vnc01.mtx.labs.mlnx>
References: <1462912922.23006.3.camel@ssi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462912922.23006.3.camel@ssi>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 10, 2016 at 01:42:02PM -0700, Ming Lin wrote:
> Here is a bug with mlx5_ib.
> 
> commit d603c809ef91fa2d211bde5e95be417847410379
> Author: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date:   Fri Mar 11 22:58:35 2016 +0200
> 
>     IB/mlx5: Fix decision on using MAD_IFC
> 
> 
> This commit causes below WARN. The "ix" returns -1
> 
>  658 void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u8 port,
> ...
> 
>  693                 /* Coudn't find default GID location */
>  694                 WARN_ON(ix < 0);
>  695 
> 
> 
> WARNING: CPU: 1 PID: 2651 at /home/mlin/linux/drivers/infiniband/core/cache.c:717 ib_cache_gid_set_default_gid+0x2f8/0x340 [ib_core]
> 

Can you tell if the link layer you're using is Ethernet or IB?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
