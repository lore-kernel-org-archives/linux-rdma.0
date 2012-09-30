From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 1/2] libmlx4: Infra-structure changes to support
 verbs extensions
Date: Sun, 30 Sep 2012 15:14:14 -0600
Message-ID: <20120930211414.GA26575@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A981D8@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A981D8-Q3cL8pyY+6ukrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -static struct ibv_device *mlx4_driver_init(const char *uverbs_sys_path,
> -					    int abi_version)
> +static struct verbs_device *mlx4_driver_init(const char *uverbs_sys_path,
> +					     int abi_version)
>  {
>  	char			value[8];
> -	struct mlx4_device    *dev;
> +	struct mlx4_device_ex	*dev;
>  	unsigned		vendor, device;
>  	int			i;

[..]

The allocation of 'dev' needs to be via zero'ing calloc so new
unsupported members of verbs_device are zero'd.

> +++ b/src/mlx4.h
> @@ -135,6 +135,11 @@ struct mlx4_device {
>  	int				page_size;
>  };
>  
> +struct mlx4_device_ex {
> +	struct verbs_device	verbs_dev;
> +	int			page_size;
> +};
> +

This looks wrong to me. offsetof(page_size) will be different on
mlx4_device_ex vs mlx4_device, and mlx4_alloc_cq_buf has no test to
correct for that.

mlx4_device_ex should be removed, and mlx4_device changed to always
use verbs_device, as a provider-allocated structure the provider
assumes the ibv_device * pointers it gets were created by driver_init.

> +#define to_mxxx_ex(xxx, type)						\
> +	((struct mlx4_##type##_ex *)					\
> +	 ((void *) verbs##xxx - offsetof(struct mlx4_##type##_ex, verbs_##xxx)))
> +
> +
> +static inline struct mlx4_device_ex *to_mdev_ex(const struct verbs_device
> +						*verbsdev)
> +{
> +	return to_mxxx_ex(dev, device);
> +}

Dump too..

Maybe make your containerof available to the providers and ditch all
these converters?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
