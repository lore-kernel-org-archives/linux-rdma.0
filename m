From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ibacm: Handle EP expiration time
Date: Mon, 19 Sep 2016 19:40:58 +0300
Message-ID: <20160919164057.GA28264@yuval-lap.uk.oracle.com>
References: <1473948862-7461-1-git-send-email-yuval.shaia@oracle.com>
 <1828884A29C6694DAF28B7E6B8A82373AB08CA2E@ORSMSX109.amr.corp.intel.com>
 <20160919072504.GA3571@yuval-lap.uk.oracle.com>
 <1828884A29C6694DAF28B7E6B8A82373AB08D0BC@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB08D0BC-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 19, 2016 at 03:51:22PM +0000, Hefty, Sean wrote:
> > > >  static struct acmp_dest *
> > > >  acmp_acquire_dest(struct acmp_ep *ep, uint8_t addr_type, const
> > uint8_t
> > > > *addr)
> > > >  {
> > > > @@ -366,6 +382,15 @@ acmp_acquire_dest(struct acmp_ep *ep, uint8_t
> > > > addr_type, const uint8_t *addr)
> > > >  	acm_log(2, "%s\n", log_data);
> > > >  	lock_acquire(&ep->lock);
> > > >  	dest = acmp_get_dest(ep, addr_type, addr);
> > > > +	if (dest && is_dest_ready(dest)) {
> > >
> > > I think it would be clearer to just perform the state check here and
> > either avoid the timeout check or merge it with the if statement below.
> > 
> > As stated above, i cannot ignore the timeout so will merge it here.
> > 
> > >
> > > > +		acm_log(2, "Record valid for the next %ld minute(s)\n",
> > > > +			dest->addr_timeout - time_stamp_min());
> > > > +		if (time_stamp_min() >= dest->addr_timeout) {
> 
> We also check addr_timeout here.  (Sorry, it's been a long while since I've looked at this code.)  My question regarding timeouts are around why do we need two checks?

First one is for log only.
If you think it is not needed then i'll remove it, otherwise i will take it
out to an helper variable and use it in both.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
