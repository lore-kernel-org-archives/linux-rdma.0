From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Allow to always block UD multicast loopback
Date: Thu, 1 May 2014 09:09:44 -0500 (CDT)
Message-ID: <alpine.DEB.2.10.1405010907570.10334@gentwo.org>
References: <alpine.DEB.2.10.1404211308140.29240@gentwo.org> <5361871e.c793420a.67de.2282SMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5361871e.c793420a.67de.2282SMTPIN_ADDED_BROKEN-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 30 Apr 2014, Doug Ledford wrote:

> > Add a module param to the mlx4_ib driver which allows to force all QP
> > attachements to be carried out with multicast loopback prevented.
>
> This seems like driving a thumb tack with a sledge hammer.  No doubt
> the correct path here is to get the proper flag added to verbs multicast
> attach command.  Or, do you still have a patch that does this the
> right way?  Did the one from 2008 do it the right way or this way?

This is the least invasive approach to do what we need and this approach
has been a part of OFED for long years.

The 2008 approach would be cleaner but it depends on an infrastructure
change. I really would like to see that patch brought up to date and
discussed.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
