From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Allow to always block UD multicast loopback
Date: Thu, 1 May 2014 10:59:42 -0500 (CDT)
Message-ID: <alpine.DEB.2.10.1405011059240.11342@gentwo.org>
References: <alpine.DEB.2.10.1404211308140.29240@gentwo.org> <5361871e.c793420a.67de.2282SMTPIN_ADDED_BROKEN@mx.google.com> <alpine.DEB.2.10.1405010907570.10334@gentwo.org> <53626915.25fc420a.01b7.7ebbSMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53626915.25fc420a.01b7.7ebbSMTPIN_ADDED_BROKEN-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 1 May 2014, Doug Ledford wrote:

> Indeed.  The non-invasive approach is the wrong one for upstream, it's
> really only suited for being a bandaid out of tree.  For upstream, it
> needs to be done right.

Can we get the bandaid into RH7 for now?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
