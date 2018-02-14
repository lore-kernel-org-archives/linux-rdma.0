From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 11/14] RDMA/uverbs: Refactor the header
 validation logic
Date: Wed, 14 Feb 2018 16:46:35 -0700
Message-ID: <20180214234635.GD1718@ziepe.ca>
References: <20180214123844.30321-1-leon@kernel.org>
 <20180214123844.30321-12-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180214123844.30321-12-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 14, 2018 at 02:38:41PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Move all header validation logic to be performed before SRCU read lock.
> 
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  drivers/infiniband/core/uverbs_main.c | 90 ++++++++++++++++++-----------------
>  1 file changed, 47 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
> index f8f2182ab86b..e07326139ce9 100644
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -677,6 +677,42 @@ static ssize_t process_hdr(struct ib_uverbs_cmd_hdr *hdr,
>  	return 0;
>  }
>  
> +static ssize_t verify_hdr(struct ib_uverbs_cmd_hdr *hdr,
> +			  struct ib_uverbs_ex_cmd_hdr *ex_hdr,
> +			  size_t count, bool extended)
> +{
> +	if (extended) {
> +		count -= sizeof(*hdr) + sizeof(*ex_hdr);
> +
> +		if ((hdr->in_words + ex_hdr->provider_in_words) * 8 != count)
> +			return -EINVAL;
> +
> +		if (ex_hdr->cmd_hdr_reserved)
> +			return -EINVAL;
> +
> +		if (ex_hdr->response) {
> +			if (!hdr->out_words && !ex_hdr->provider_out_words)
> +				return -EINVAL;
> +
> +			if (!access_ok(VERIFY_WRITE,
> +				       u64_to_user_ptr(ex_hdr->response),
> +				       (hdr->out_words + ex_hdr->provider_out_words) * 8))
> +				return -EFAULT;
> +		} else {
> +			if (hdr->out_words || ex_hdr->provider_out_words)
> +				return -EINVAL;
> +		}
> +
> +		return 0;
> +	}
> +
> +	/* not extended command */
> +	if (hdr->in_words * 4 != count)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +

I think you should squish this with the prior two patches

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
