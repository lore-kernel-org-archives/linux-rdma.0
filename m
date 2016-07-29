From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libi40iw] fix remaining potential leaks of info arrays
 and iwuqp
Date: Thu, 28 Jul 2016 23:24:51 -0400
Message-ID: <20160729032451.GS36313@redhat.com>
References: <1469732963-58257-1-git-send-email-jarod@redhat.com>
 <748B799B6A00724488C603FD7E5E7EB94C9942EB@FMSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <748B799B6A00724488C603FD7E5E7EB94C9942EB-XfjTATA9Em864kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 28, 2016 at 09:10:07PM +0000, Tung, Chien Tin wrote:
> Hi Jarod,
> 
> Thank you for the patch, just a couple of things.  Please send a V2 and we will include it.
> 
> > diff --git a/src/i40iw_uverbs.c b/src/i40iw_uverbs.c index ec5f77e..e5753e0
> > 100644
> > --- a/src/i40iw_uverbs.c
> > +++ b/src/i40iw_uverbs.c
> > @@ -698,6 +698,7 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd,
> > struct ibv_qp_init_attr *attr
> >  	info.rq_wrid_array = calloc(rqdepth, sizeof(*info.rq_wrid_array));
> >  	if (!info.rq_wrid_array) {
> >  		fprintf(stderr, PFX "%s: failed to allocate memory for RQ work
> > array\n", __func__);
> > +		free(iwuqp);
> [Chien] Not needed, see changes below.
> 
> >  		goto err_free_sq_wrtrk;
> >  	}
> > 
> > @@ -707,6 +708,7 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd,
> > struct ibv_qp_init_attr *attr
> > 
> >  	if (!status) {
> >  		fprintf(stderr, PFX "%s: failed to map QP\n", __func__);
> > +		free(iwuqp);
> [Chien] Not needed, see changes below.
> 
> >  		goto err_free_rq_wrid;
> >  	}
> >  	info.qp_id = resp.qp_id;
> > @@ -728,12 +730,12 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd,
> > struct ibv_qp_init_attr *attr
> > 
> >  err_destroy_qp:
> >  	i40iw_udestroy_qp(&iwuqp->ibv_qp);
> > -	return NULL;
> > -
> >  err_free_rq_wrid:
> >  	free(info.rq_wrid_array);
> >  err_free_sq_wrtrk:
> >  	free(info.sq_wrtrk_array);
> > +	return NULL;
> [Chien] Need to remove this.  We don't want to return when unwinding resources
> Same issue as the return NULL I missed.
> 
> > +
> >  err_destroy_lock:
> >  	if (pthread_spin_destroy(&iwuqp->lock))
> >  		return NULL;
> [Chien] Not sure why I would bother with the if statement here.
> Remove the if check and return NULL. Now everything should flow correctly in the error path.

Hm. So one issue I still see, is that if you jump to err_destroy_qp, then
pthread_spin_destroy(&iwuqp->lock) will have already been called by
i40iw_udestroy_qp(), along with free(iwuqp), and I was thinking there
could be a null pointer dereference issue.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
