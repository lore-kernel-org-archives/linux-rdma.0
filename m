From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/netlink: Remove export of
 ibnl_chk_listeners function
Date: Tue, 9 May 2017 08:39:23 +0300
Message-ID: <20170509053922.GA2117@yuval-lap>
References: <20170508121343.3213-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170508121343.3213-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 08, 2017 at 03:13:43PM +0300, Leon Romanovsky wrote:
> The ibnl_chk_listeners() function is called in the code
> located at the same module, hence no need to be exported.

Do you think it's declaration should move from include/rdma/ to local
header file also?

> 
> Remove EXPORT_SYMBOL from it.
> 
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/netlink.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
> index 10469b0088b5..ebd16885cfce 100644
> --- a/drivers/infiniband/core/netlink.c
> +++ b/drivers/infiniband/core/netlink.c
> @@ -55,7 +55,6 @@ int ibnl_chk_listeners(unsigned int group)
>  		return -1;
>  	return 0;
>  }
> -EXPORT_SYMBOL(ibnl_chk_listeners);
> 
>  int ibnl_add_client(int index, int nops,
>  		    const struct ibnl_client_cbs cb_table[])
> --
> 2.12.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
