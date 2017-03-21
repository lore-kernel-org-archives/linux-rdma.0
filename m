From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB/cq: Don't process more than the given budget
Date: Tue, 21 Mar 2017 10:42:27 +0200
Message-ID: <20170321084225.GF5970@yuval-lap>
References: <1489683420-28005-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489683420-28005-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 16, 2017 at 06:57:00PM +0200, Sagi Grimberg wrote:
> The caller might not want this overhead.
> 
> Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>  drivers/infiniband/core/cq.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
> index e95510117a6d..b9c4cefe90c1 100644
> --- a/drivers/infiniband/core/cq.c
> +++ b/drivers/infiniband/core/cq.c
> @@ -29,7 +29,13 @@ static int __ib_process_cq(struct ib_cq *cq, int budget)
>  {
>  	int i, n, completed = 0;
>  
> -	while ((n = ib_poll_cq(cq, IB_POLL_BATCH, cq->wc)) > 0) {
> +	/*
> +	 * budget might be (-1) if the caller does not
> +	 * want to bound this call, thus we need unsigned
> +	 * minimum here.
> +	 */
> +	while ((n = ib_poll_cq(cq, min_t(u32, IB_POLL_BATCH,
> +			budget - completed), cq->wc)) > 0) {
>  		for (i = 0; i < n; i++) {
>  			struct ib_wc *wc = &cq->wc[i];

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
