From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ibacm: Handle EP expiration time
Date: Mon, 19 Sep 2016 10:25:04 +0300
Message-ID: <20160919072504.GA3571@yuval-lap.uk.oracle.com>
References: <1473948862-7461-1-git-send-email-yuval.shaia@oracle.com>
 <1828884A29C6694DAF28B7E6B8A82373AB08CA2E@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB08CA2E-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 16, 2016 at 07:38:29PM +0000, Hefty, Sean wrote:
> > +static inline is_dest_ready(struct acmp_dest *dest)
> > +{
> > +	return dest->state == ACMP_READY &&
> > +	       dest->addr_timeout != 0xFFFFFFFFFFFFFFFF;
> > +}
> 
> I found including the timeout check here to be confusing.

Checking state is not enough as there are places where add_timeout is not
set while state still is.

> 
> > +
> >  static struct acmp_dest *
> >  acmp_acquire_dest(struct acmp_ep *ep, uint8_t addr_type, const uint8_t
> > *addr)
> >  {
> > @@ -366,6 +382,15 @@ acmp_acquire_dest(struct acmp_ep *ep, uint8_t
> > addr_type, const uint8_t *addr)
> >  	acm_log(2, "%s\n", log_data);
> >  	lock_acquire(&ep->lock);
> >  	dest = acmp_get_dest(ep, addr_type, addr);
> > +	if (dest && is_dest_ready(dest)) {
> 
> I think it would be clearer to just perform the state check here and either avoid the timeout check or merge it with the if statement below.

As stated above, i cannot ignore the timeout so will merge it here.

> 
> > +		acm_log(2, "Record valid for the next %ld minute(s)\n",
> > +			dest->addr_timeout - time_stamp_min());
> > +		if (time_stamp_min() >= dest->addr_timeout) {
> > +			acm_log(2, "Record expiered\n");
> 
> Nit: misspelled expired.

Oops, thanks!

> 
> > +			acmp_remove_dest(ep, dest);
> > +			dest = 0;
> 
> Please use NULL in place of 0.

Will do.

> 
> > +		}
> > +	}
> >  	if (!dest) {
> >  		dest = acmp_alloc_dest(addr_type, addr);
> >  		if (dest) {
> > @@ -378,15 +403,6 @@ acmp_acquire_dest(struct acmp_ep *ep, uint8_t
> > addr_type, const uint8_t *addr)
> >  	return dest;
> >  }
> > 
> > -/* Caller must hold ep lock. */
> > -//static void
> > -//acmp_remove_dest(struct acmp_ep *ep, struct acmp_dest *dest)
> > -//{
> > -//	acm_log(2, "%s\n", dest->name);
> > -//	tdelete(dest->address, &ep->dest_map[dest->addr_type - 1],
> > acmp_compare_dest);
> > -//	acmp_put_dest(dest);
> > -//}
> > -
> >  static struct acmp_request *acmp_alloc_req(uint64_t id, struct acm_msg
> > *msg)
> >  {
> >  	struct acmp_request *req;
> 
> I'm fine with the email posting of the patch, but it's easier for me to deal with a github pull request.  If you could add a PR as well, I'd appreciate it.

Sure, will post v1 also as PR.

> 
> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
