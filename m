From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH/libmlx4] Return failure if asked to resize CQ to fewer
 than outstanding entries
Date: Tue, 6 Sep 2016 17:00:25 +0300
Message-ID: <f2ea433f-8714-1438-1978-723e266baede@dev.mellanox.co.il>
References: <87wpirxyqs.fsf@digitalvampire.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87wpirxyqs.fsf-ukP65eMp1S23Y08NHXK2NB2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/4/2016 10:15 PM, Roland Dreier wrote:
> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>
> Don't silently return 0 (success) but not resize the CQ when the number of
> outstanding entries is smaller than the size requested.  Instead return
> EINVAL so the consumer knows the CQ wasn't resized.
>
> This is one of the fixes in kernel commit 8ab9406a41c8 ("IB/mlx4: Bug fixes
> in mlx4_ib_resize_cq") from Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>.
>
> Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> ---
>  src/verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/src/verbs.c b/src/verbs.c
> index 43853c0c6532..5cc82cf38763 100644
> --- a/src/verbs.c
> +++ b/src/verbs.c
> @@ -392,7 +392,7 @@ int mlx4_resize_cq(struct ibv_cq *ibcq, int cqe)
>  	/* Can't be smaller then the number of outstanding CQEs */
>  	outst_cqe = mlx4_get_outstanding_cqes(cq);
>  	if (cqe < outst_cqe + 1) {
> -		ret = 0;
> +		ret = EINVAL;
>  		goto out;
>  	}
>

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
