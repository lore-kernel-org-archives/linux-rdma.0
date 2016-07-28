From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH libi40iw] fix remaining potential leaks of info arrays
 and iwuqp
Date: Thu, 28 Jul 2016 21:10:07 +0000
Message-ID: <748B799B6A00724488C603FD7E5E7EB94C9942EB@FMSMSX114.amr.corp.intel.com>
References: <1469732963-58257-1-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469732963-58257-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jarod,

Thank you for the patch, just a couple of things.  Please send a V2 and we will include it.

> diff --git a/src/i40iw_uverbs.c b/src/i40iw_uverbs.c index ec5f77e..e5753e0
> 100644
> --- a/src/i40iw_uverbs.c
> +++ b/src/i40iw_uverbs.c
> @@ -698,6 +698,7 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd,
> struct ibv_qp_init_attr *attr
>  	info.rq_wrid_array = calloc(rqdepth, sizeof(*info.rq_wrid_array));
>  	if (!info.rq_wrid_array) {
>  		fprintf(stderr, PFX "%s: failed to allocate memory for RQ work
> array\n", __func__);
> +		free(iwuqp);
[Chien] Not needed, see changes below.

>  		goto err_free_sq_wrtrk;
>  	}
> 
> @@ -707,6 +708,7 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd,
> struct ibv_qp_init_attr *attr
> 
>  	if (!status) {
>  		fprintf(stderr, PFX "%s: failed to map QP\n", __func__);
> +		free(iwuqp);
[Chien] Not needed, see changes below.

>  		goto err_free_rq_wrid;
>  	}
>  	info.qp_id = resp.qp_id;
> @@ -728,12 +730,12 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd,
> struct ibv_qp_init_attr *attr
> 
>  err_destroy_qp:
>  	i40iw_udestroy_qp(&iwuqp->ibv_qp);
> -	return NULL;
> -
>  err_free_rq_wrid:
>  	free(info.rq_wrid_array);
>  err_free_sq_wrtrk:
>  	free(info.sq_wrtrk_array);
> +	return NULL;
[Chien] Need to remove this.  We don't want to return when unwinding resources
Same issue as the return NULL I missed.

> +
>  err_destroy_lock:
>  	if (pthread_spin_destroy(&iwuqp->lock))
>  		return NULL;
[Chien] Not sure why I would bother with the if statement here.
Remove the if check and return NULL. Now everything should flow correctly in the error path.
> --
> 1.8.3.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
