From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] libcxgb4: set *bad_wr in post_send/recv error paths
Date: Wed, 7 Dec 2016 20:15:41 +0200
Message-ID: <20161207181541.GA3709@yuval-lap>
References: <20161206210403.71E59E08C5@smtp.ogc.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161206210403.71E59E08C5-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Looks like same fix should be applied to cxgb4 driver, right?

Yuval

On Tue, Dec 06, 2016 at 11:49:32AM -0800, Steve Wise wrote:
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  providers/cxgb4/qp.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/providers/cxgb4/qp.c b/providers/cxgb4/qp.c
> index 376a00a..3b448dd 100644
> --- a/providers/cxgb4/qp.c
> +++ b/providers/cxgb4/qp.c
> @@ -303,11 +303,13 @@ int c4iw_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
>  	pthread_spin_lock(&qhp->lock);
>  	if (t4_wq_in_error(&qhp->wq)) {
>  		pthread_spin_unlock(&qhp->lock);
> +		*bad_wr = wr;
>  		return -EINVAL;
>  	}
>  	num_wrs = t4_sq_avail(&qhp->wq);
>  	if (num_wrs == 0) {
>  		pthread_spin_unlock(&qhp->lock);
> +		*bad_wr = wr;
>  		return -ENOMEM;
>  	}
>  	while (wr) {
> @@ -403,12 +405,14 @@ int c4iw_post_receive(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
>  	pthread_spin_lock(&qhp->lock);
>  	if (t4_wq_in_error(&qhp->wq)) {
>  		pthread_spin_unlock(&qhp->lock);
> +		*bad_wr = wr;
>  		return -EINVAL;
>  	}
>  	INC_STAT(recv);
>  	num_wrs = t4_rq_avail(&qhp->wq);
>  	if (num_wrs == 0) {
>  		pthread_spin_unlock(&qhp->lock);
> +		*bad_wr = wr;
>  		return -ENOMEM;
>  	}
>  	while (wr) {
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
