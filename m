From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Why don't we always check that attr->port_num is valid?
Date: Wed, 4 Oct 2017 06:13:35 +0300
Message-ID: <20171004031335.a2zjzhw3tgcj57l2@mwanda>
References: <20171002113431.lqkf4ilmimjfouc7@mwanda>
 <20171002152033.GB12331@obsidianresearch.com>
 <20171003052159.GB26055@mtr-leonro.local>
 <1828884A29C6694DAF28B7E6B8A82373AB19A8A5@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB19A8A5-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 03, 2017 at 07:52:27PM +0000, Hefty, Sean wrote:
> > > > We deliberately allow invalid attr->port_nums if IB_QP_PORT is not
> > set.
> > > > Why must we do that?  From a kernel hardening perspective it would
> > > > be better to ban invalid values all together...
> > >
> > > It is part of the user ABI, so it has to stay that way...
> > 
> > Can we pre-process all invalid parameters at the kernel entry points
> > to ensure that drivers receive clean input?
> > 
> > For example, overwrite attr->port_nums to be zero if IB_QP_PORT is not
> > set.

attr->port_nums is not allowed to be set to zero so that will trigger
another warning.

> 
> I'm not sure this helps much.  The value must still be ignored by the driver, whether it's in range or not.

It would help me a lot to know that the value is always within range
when we call the function.

Smatch is tracking things at the function call level so it says "when
we call this we know that the value comes from the user and is not
trusted".  Which is correct, but not precise.  In an ideal world it
would say, "This comes from the user and is not trusted unless a flag
is set on param 3", but Smatch doesn't break it down that way...

This might be solveable in Smatch...  But generally the problem is that
there is too much data to track the relationships between every variable
in the kernel.  I just break it down at the function call boundaries.
So like, for returns I split them out into success/failure returns and
I say "this is true if the function returns zero", and "these things are
true if the function returns failure".  But for calls I just say "These
things are true when the function is called from this call site".

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
