From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] ipoib mcast sendonly join: Move multicast specific
 code out of ipoib_main.c.
Date: Mon, 14 Dec 2015 10:04:42 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1512141000470.25235@east.gentwo.org>
References: <20151211181652.187735744@linux.com> <20151211181724.290844844@linux.com> <20151211232143.GC7855@phlsvsds.ph.intel.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151211232143.GC7855-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 11 Dec 2015, ira.weiny wrote:

> I think I would rather see this called something like
>
> ipoib_add_to_list_sendonly
>
> Or something...
>
> Calling it iboib_check* sounds like it should return a bool.

Hmm... It only adds the multicast group if the check was successful.

How about

		ipoib_check_and_add_mcast_sendonly()


> > +void ipoib_check_mcast_sendonly(struct ipoib_dev_priv *priv, u8 *mgid,
> > +				struct list_head *remove_list)
> > +{
> > +	/* Is this multicast ? */
> > +	if (*mgid == 0xff) {
>
> Odd to see a mgid variable which is only u8?
>
> How about "gid_prefix"?

That is only used in the qib driver and there it is a field.

mgid is a pointer to the seres of bytes of the MGID and the first byte of
that signifies multicast if 0xff....

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
