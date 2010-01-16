From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/ibqueryerrors: Add support for
 optional PortRcvErrorDetails counter
Date: Sat, 16 Jan 2010 21:53:26 +0200
Message-ID: <20100116195326.GZ574@me>
References: <20091231191054.GA27874@comcast.net>
 <20100112191420.GJ574@me>
 <f0e08f231001131210r669265fax870cfb4bbaf3c1d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f231001131210r669265fax870cfb4bbaf3c1d-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 15:10 Wed 13 Jan     , Hal Rosenstock wrote:

[snip]

> >> @@ -364,6 +375,10 @@ static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
> >>               performance_reset_via(pc, portid, port, mask, ibd_timeout,
> >>                                     IB_GSI_PORT_XMIT_DISCARD_DETAILS,
> >>                                     ibmad_port);
> >> +             mask = 0x3F;
> >> +             performance_reset_via(pc, portid, port, mask, ibd_timeout,
> >> +                                   IB_GSI_PORT_RCV_ERROR_DETAILS,
> >> +                                   ibmad_port);
> >
> > If 'mask' value is used unconditionally whouldn't it be simpler to just
> > write:
> >
> >                performance_reset_via(pc, portid, port, 0x3f, ibd_timeout,
> >                                      IB_GSI_PORT_RCV_ERROR_DETAILS,
> >                                      ibmad_port);
> >
> > ?
> 
> Yes and that comment also applies to the instance above this for xmit
> discard details reset.

Ok. Both patches are applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
