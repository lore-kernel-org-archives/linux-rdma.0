From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 5/8] RDMA/core: Provide locked variant of
 device name to index function
Date: Wed, 27 Dec 2017 16:02:27 -0700
Message-ID: <20171227230227.GK25436@ziepe.ca>
References: <20171224134328.17398-1-leon@kernel.org>
 <20171224134328.17398-6-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171224134328.17398-6-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 24, 2017 at 03:43:25PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Add self-contained with locks device name to index function.
> 
> Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  drivers/infiniband/core/core_priv.h |  1 +
>  drivers/infiniband/core/device.c    | 16 ++++++++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
> index ded3850721e0..e71dd1814bf0 100644
> +++ b/drivers/infiniband/core/core_priv.h
> @@ -301,6 +301,7 @@ static inline int ib_mad_enforce_security(struct ib_mad_agent_private *map,
>  #endif
>  
>  struct ib_device *__ib_device_get_by_index(u32 ifindex);
> +struct ib_device *ib_device_get_by_index(u32 ifindex);
>  /* RDMA device netlink */
>  void nldev_init(void);
>  void nldev_exit(void);
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index cb69357a1909..adf3a4ca038b 100644
> +++ b/drivers/infiniband/core/device.c
> @@ -150,6 +150,22 @@ struct ib_device *__ib_device_get_by_index(u32 index)
>  	return NULL;
>  }
>  
> +/*
> + * Caller is responsible to return refrerence count by calling put_device()
> + */
> +struct ib_device *ib_device_get_by_index(u32 index)
> +{
> +	struct ib_device *device;
> +
> +	down_write(&lists_rwsem);
> +	device = __ib_device_get_by_index(index);
> +	if (device)
> +		get_device(&device->dev);
> +
> +	up_write(&lists_rwsem);
> +	return device;
> +}

If you hold the write side of lists_rwsem you must also hold
device_mutex.

But the write side is only needed if the code mutates the device_list
or client list, and this does neither, so it should be the read lock, right?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
