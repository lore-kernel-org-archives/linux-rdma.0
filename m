From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v3 03/13] Attach/detach SoftiWarp to/from network and
 RDMA subsystem
Date: Tue, 23 Jan 2018 09:43:16 -0700
Message-ID: <20180123164316.GC30670@ziepe.ca>
References: <20180114223603.19961-1-bmt@zurich.ibm.com>
 <20180114223603.19961-4-bmt@zurich.ibm.com>
 <00ff01d39467$f1f31b60$d5d95220$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00ff01d39467$f1f31b60$d5d95220$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Bernard Metzler' <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 23, 2018 at 10:33:48AM -0600, Steve Wise wrote:

> > +/* Restrict usage of GSO, if hardware peer iwarp is unable to process
> > + * large packets. gso_seg_limit = 1 lets siw send only packets up to
> > + * one real MTU in size, but severly limits maximum bandwidth.
> > + * gso_seg_limit = 0 makes use of GSO (and more than doubles throughput
> > + * for large transfers).
> > + */
> > +const int gso_seg_limit;
> > +
> 
> The GSO configuration needs to default to enable interoperation with all
> vendors (and comply with the RFCs).  So make it 1 please.

The thing we call GSO in the netstack should be totally transparent on
the wire, so at the very least this needs some additional elaboration.

> Jason, would configfs be a reasonable way to allow tweaking these globals?

Why would we ever even bother to support a mode that is non-conformant
on the wire? Just remove it..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
