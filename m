From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v3 03/13] Attach/detach SoftiWarp to/from network and
 RDMA subsystem
Date: Tue, 23 Jan 2018 10:05:17 -0700
Message-ID: <20180123170517.GE30670@ziepe.ca>
References: <20180114223603.19961-1-bmt@zurich.ibm.com>
 <20180114223603.19961-4-bmt@zurich.ibm.com>
 <00ff01d39467$f1f31b60$d5d95220$@opengridcomputing.com>
 <20180123164316.GC30670@ziepe.ca>
 <011801d3946b$53ef0060$fbcd0120$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <011801d3946b$53ef0060$fbcd0120$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Bernard Metzler' <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 23, 2018 at 10:58:01AM -0600, Steve Wise wrote:

> From: https://tools.ietf.org/html/rfc5041#section-5.2
> 
> "At the Data Source, the DDP layer MUST segment the data contained in
>    a ULP message into a series of DDP Segments, where each DDP Segment
>    contains a DDP Header and ULP Payload, and MUST be no larger than the
>    MULPDU value Advertised by the LLP."
> 
> Where MULDPDU is the maximum ULP PDU that will fit in the TCP MSS...

But exceeding the MULPDU has nothing to do with the netstack GSO
function.. right? GSO is entirely a local node optimization that
should not be detectable on the wire.

> > > Jason, would configfs be a reasonable way to allow tweaking these
> globals?
> > 
> > Why would we ever even bother to support a mode that is non-conformant
> > on the wire? Just remove it..
> 
> For soft iwarp, the throughput is greatly increased with allowing these
> iWARP protocol PDUs to span many TCP segments.  So there could be an
> argument for leaving it as a knob for soft iwarp <-> soft iwarp
> configurations.  But IMO it needs to default to RFC compliance and
> interoperability with hw implementations.

IMHO the purpose of things like rxe and siw is not maximum raw
performance (certainly not during the initial kernel accept phase), so
it should not include any non-conformant cruft..

Jsaon
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
