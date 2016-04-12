From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RDMA PATCH 13/16] i40iw: Add base memory management extensions
Date: Tue, 12 Apr 2016 13:13:57 -0500
Message-ID: <20160412181357.GA16748@mustafai-MOBL>
References: <1460046664-552-1-git-send-email-mustafa.ismail@intel.com>
 <1460046664-552-14-git-send-email-mustafa.ismail@intel.com>
 <20160412140739.GA23302@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160412140739.GA23302-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 12, 2016 at 07:07:39AM -0700, Christoph Hellwig wrote:
> > @@ -4570,6 +4629,7 @@ static struct i40iw_priv_qp_ops iw_priv_qp_ops = {
> >  	i40iw_sc_send_lsmm_nostag,
> >  	i40iw_sc_send_rtt,
> >  	i40iw_sc_post_wqe0,
> > +	i40iw_sc_mr_fast_register,
> 
> Just noticed this while looking for an implementation of your
> iw_mr_fast_register method:
> 
> please always use named initializers for structs that have meaning
> outside a single file, it makes grepping so much easier.
> 
> >  static struct i40iw_priv_cq_ops iw_priv_cq_ops = {
> > diff --git a/drivers/infiniband/hw/i40iw/i40iw_type.h b/drivers/infiniband/hw/i40iw/i40iw_type.h
> > index 5b6a491..c926198 100644
> > --- a/drivers/infiniband/hw/i40iw/i40iw_type.h
> > +++ b/drivers/infiniband/hw/i40iw/i40iw_type.h
> > @@ -1041,6 +1041,9 @@ struct i40iw_priv_qp_ops {
> >  	void (*qp_send_lsmm_nostag)(struct i40iw_sc_qp *, void *, u32);
> >  	void (*qp_send_rtt)(struct i40iw_sc_qp *, bool);
> >  	enum i40iw_status_code (*qp_post_wqe0)(struct i40iw_sc_qp *, u8);
> > +	enum i40iw_status_code (*iw_mr_fast_register)(struct i40iw_sc_qp *,
> > +						      struct i40iw_fast_reg_stag_info *,
> > +						      bool);
> >  };
> 
> And while we're at it: what's the point of the indirection to start
> with?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks. We will correct in V2 of patch series.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
