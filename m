From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RE-RESEND V2 for-next 5/5] IB/core: Fix deadlock on uverbs
 modify_qp error flow
Date: Wed, 18 Feb 2015 00:03:58 -0500
Message-ID: <54E41D3E.6020809@mellanox.com>
References: <1423137232-24587-1-git-send-email-ogerlitz@mellanox.com> <1423137232-24587-6-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423137232-24587-6-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/5/2015 6:53 AM, Or Gerlitz wrote:
> From: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> The deadlock occurs on __uverbs_modify_qp, we take a lock (idr_read_qp)
> and in case of failure in ib_resolve_eth_l2_attrs we don't release
> it (put_qp_read). Fix that.
>
> Issue: 355606
> Fixes: ed4c54e5b4ba ("IB/core: Resolve Ethernet L2 addresses when modifying QP")
> Signed-off-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Roland, can you please pick this one too, it's a bug fix and no comments 
were raised against it.
I just failed to remove the Gerrit Issue: XXX line,  so if you can do 
that, will be great

> ---
>   drivers/infiniband/core/uverbs_cmd.c |    9 +++++----
>   1 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index ecb6430..a602ce9 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2097,20 +2097,21 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
>   	if (qp->real_qp == qp) {
>   		ret = ib_resolve_eth_l2_attrs(qp, attr, &cmd.attr_mask);
>   		if (ret)
> -			goto out;
> +			goto release_qp;
>   		ret = qp->device->modify_qp(qp, attr,
>   			modify_qp_mask(qp->qp_type, cmd.attr_mask), &udata);
>   	} else {
>   		ret = ib_modify_qp(qp, attr, modify_qp_mask(qp->qp_type, cmd.attr_mask));
>   	}
>   
> -	put_qp_read(qp);
> -
>   	if (ret)
> -		goto out;
> +		goto release_qp;
>   
>   	ret = in_len;
>   
> +release_qp:
> +	put_qp_read(qp);
> +
>   out:
>   	kfree(attr);
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
