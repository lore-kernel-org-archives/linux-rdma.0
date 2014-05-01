From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Allow to always block UD multicast loopback
Date: Thu, 1 May 2014 11:32:31 -0400 (EDT)
Message-ID: <13401.7242388383$1398958370@news.gmane.org>
References: <alpine.DEB.2.10.1404211308140.29240@gentwo.org> <5361871e.c793420a.67de.2282SMTPIN_ADDED_BROKEN@mx.google.com> <alpine.DEB.2.10.1405010907570.10334@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1405010907570.10334-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

----- Original Message -----
> On Wed, 30 Apr 2014, Doug Ledford wrote:
> 
> > > Add a module param to the mlx4_ib driver which allows to force
> > > all QP
> > > attachements to be carried out with multicast loopback prevented.
> >
> > This seems like driving a thumb tack with a sledge hammer.  No
> > doubt
> > the correct path here is to get the proper flag added to verbs
> > multicast
> > attach command.  Or, do you still have a patch that does this the
> > right way?  Did the one from 2008 do it the right way or this way?
> 
> This is the least invasive approach to do what we need and this
> approach
> has been a part of OFED for long years.

I get that it's non-invasive and when doing something to get around the
fact that it doesn't exist upstream, that makes sense.

> The 2008 approach would be cleaner but it depends on an
> infrastructure
> change. I really would like to see that patch brought up to date and
> discussed.

Indeed.  The non-invasive approach is the wrong one for upstream, it's
really only suited for being a bandaid out of tree.  For upstream, it
needs to be done right.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
