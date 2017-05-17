From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc] IB/uverbs: Declare local function to be static
Date: Wed, 17 May 2017 12:39:14 +0300
Message-ID: <20170517093913.GI2730@yuval-lap>
References: <20170516110727.4733-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170516110727.4733-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 16, 2017 at 02:07:27PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Commit 57520751445b ("IB/SA: Add OPA path record type") introduced
> new local function __ib_copy_path_rec_to_user, but didn't limit its
> scope. This produces the following sparse warning:
> 
> 	drivers/infiniband/core/uverbs_marshall.c:99:6: warning:
> 	symbol '__ib_copy_path_rec_to_user' was not declared. Should it be
> 	static?
> 
> Fixes: 57520751445b ("IB/SA: Add OPA path record type")
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs_marshall.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
> index 8b9587fe2303..94fd989c9060 100644
> --- a/drivers/infiniband/core/uverbs_marshall.c
> +++ b/drivers/infiniband/core/uverbs_marshall.c
> @@ -96,11 +96,11 @@ void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
>  }
>  EXPORT_SYMBOL(ib_copy_qp_attr_to_user);
> 
> -void __ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
> -				struct sa_path_rec *src)
> +static void __ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
> +				       struct sa_path_rec *src)
>  {
> -	memcpy(dst->dgid, src->dgid.raw, sizeof src->dgid);
> -	memcpy(dst->sgid, src->sgid.raw, sizeof src->sgid);
> +	memcpy(dst->dgid, src->dgid.raw, sizeof(src->dgid));
> +	memcpy(dst->sgid, src->sgid.raw, sizeof(src->sgid));

Isn't this change also needs to be documented in commit log?

> 
>  	dst->dlid		= htons(ntohl(sa_path_get_dlid(src)));
>  	dst->slid		= htons(ntohl(sa_path_get_slid(src)));

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

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
