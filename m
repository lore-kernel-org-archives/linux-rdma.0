From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1] ibacm: Handle EP expiration time
Date: Mon, 19 Sep 2016 16:21:38 +0300
Message-ID: <20160919132138.GA21320@yuval-lap.uk.oracle.com>
References: <1474271168-22662-1-git-send-email-yuval.shaia@oracle.com>
 <387b0fc4-949f-b8e2-6ac3-136e5ab2e127@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <387b0fc4-949f-b8e2-6ac3-136e5ab2e127-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 19, 2016 at 07:22:54AM -0400, Hal Rosenstock wrote:
> > +
> >  static struct acmp_dest *
> >  acmp_acquire_dest(struct acmp_ep *ep, uint8_t addr_type, const uint8_t *addr)
> >  {
> > @@ -366,6 +376,16 @@ acmp_acquire_dest(struct acmp_ep *ep, uint8_t addr_type, const uint8_t *addr)
> >  	acm_log(2, "%s\n", log_data);
> >  	lock_acquire(&ep->lock);
> >  	dest = acmp_get_dest(ep, addr_type, addr);
> > +	if (dest && dest->state == ACMP_READY &&
> > +	    dest->addr_timeout != 0xFFFFFFFFFFFFFFFF) {
> 
> Nit related to the timeout check:
> In acmp.c, (uint64_t)~0ULL is used in other places for this. Should this
> addr_timeout check be changed to some infinite or no timeout define
> along with the other occurrences for consistency and better code
> readability ?

Will do.

> 
> -- Hal
> 
> > +		acm_log(2, "Record valid for the next %ld minute(s)\n",
> > +			dest->addr_timeout - time_stamp_min());
> > +		if (time_stamp_min() >= dest->addr_timeout) {
> > +			acm_log(2, "Record expired\n");
> > +			acmp_remove_dest(ep, dest);
> > +			dest = NULL;
> > +		}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
