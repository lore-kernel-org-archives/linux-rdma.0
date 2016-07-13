From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1] IB/ipoib: Skip napi_schedule if ib_poll_cq fails
Date: Wed, 13 Jul 2016 18:15:28 +0300
Message-ID: <20160713151527.GB17563@yuval-lap.uk.oracle.com>
References: <1468405273-25375-1-git-send-email-yuval.shaia@oracle.com>
 <1468405273-25375-2-git-send-email-yuval.shaia@oracle.com>
 <20160713135301.GA94611@x-vnc01.mtx.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160713135301.GA94611-lgQlq6cFzJSjLWYaRI30zHI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks Eli.

We faced a problem that may lead to this kind of error.
Reading the code looks like it needs a fix.

Yuval

On Wed, Jul 13, 2016 at 04:53:01PM +0300, Eli Cohen wrote:
> Reviewd-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> BTW, did you actually hit this or are you sending this based on code
> review?
> 
> On Wed, Jul 13, 2016 at 03:21:13AM -0700, Yuval Shaia wrote:
> > To avoid entering into endless loop when device can't poll CQE from CQ
> > driver should not reschedule if error is not -EAGAIN.
> > 
> > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/ulp/ipoib/ipoib.h       |    5 +++++
> >  drivers/infiniband/ulp/ipoib/ipoib_ib.c    |   13 ++++++++++++-
> >  drivers/infiniband/ulp/ipoib/ipoib_verbs.c |    1 +
> >  3 files changed, 18 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
> > index 4f7d9b4..1946149 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> > @@ -116,6 +116,8 @@ enum {
> >  	IPOIB_NON_CHILD		  = 0,
> >  	IPOIB_LEGACY_CHILD	  = 1,
> >  	IPOIB_RTNL_CHILD	  = 2,
> > +
> > +	IPOIB_MAX_CONSEQ_CQ_ERR	  = 10,
> >  };
> >  
> >  #define	IPOIB_OP_RECV   (1ul << 31)
> > @@ -347,6 +349,7 @@ struct ipoib_dev_priv {
> >  	u16		  pkey_index;
> >  	struct ib_pd	 *pd;
> >  	struct ib_cq	 *recv_cq;
> > +	int		  recv_conseq_cq_errs;
> >  	struct ib_cq	 *send_cq;
> >  	struct ib_qp	 *qp;
> >  	u32		  qkey;
> > @@ -772,6 +775,8 @@ static inline void ipoib_unregister_debugfs(void) { }
> >  	printk(level "%s: " format, ((struct ipoib_dev_priv *) priv)->dev->name , ## arg)
> >  #define ipoib_warn(priv, format, arg...)		\
> >  	ipoib_printk(KERN_WARNING, priv, format , ## arg)
> > +#define ipoib_crit(priv, format, arg...)		\
> > +	ipoib_printk(KERN_CRIT, priv, format , ## arg)
> >  
> >  extern int ipoib_sendq_size;
> >  extern int ipoib_recvq_size;
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> > index dc6d241..9395a24 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> > @@ -449,7 +449,8 @@ int ipoib_poll(struct napi_struct *napi, int budget)
> >  	int t;
> >  	int n, i;
> >  
> > -	done  = 0;
> > +	done = 0;
> > +	n = 0;
> >  
> >  poll_more:
> >  	while (done < budget) {
> > @@ -475,6 +476,16 @@ poll_more:
> >  			break;
> >  	}
> >  
> > +	if (unlikely(n < 0) && (n != -EAGAIN)) {
> > +		if (priv->recv_conseq_cq_errs++ >= IPOIB_MAX_CONSEQ_CQ_ERR) {
> > +			ipoib_crit(priv,
> > +				   "Too many poll_cq errors, last error: %d\n",
> > +				   n);
> > +			return done;
> > +		}
> > +	} else
> > +		priv->recv_conseq_cq_errs = 0;
> > +
> >  	if (done < budget) {
> >  		napi_complete(napi);
> >  		if (unlikely(ib_req_notify_cq(priv->recv_cq,
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> > index 1e7cbba..6ca8bdd 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> > @@ -181,6 +181,7 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
> >  		printk(KERN_WARNING "%s: failed to create receive CQ\n", ca->name);
> >  		goto out_cm_dev_cleanup;
> >  	}
> > +	priv->recv_conseq_cq_errs = 0;
> >  
> >  	cq_attr.cqe = ipoib_sendq_size;
> >  	priv->send_cq = ib_create_cq(priv->ca, ipoib_send_comp_handler, NULL,
> > -- 
> > 1.7.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
