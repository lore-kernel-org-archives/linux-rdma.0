From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Wed, 11 May 2016 11:27:45 -0600
Message-ID: <20160511172745.GA18517@obsidianresearch.com>
References: <20160506225523.GA21309@obsidianresearch.com>
 <alpine.DEB.2.20.1605090926440.6128@east.gentwo.org>
 <20160509163537.GA15479@obsidianresearch.com>
 <20160509191613.GS29160@leon.nu>
 <20160509195734.GA22669@obsidianresearch.com>
 <20160510044107.GU29160@leon.nu>
 <20160510170739.GA2879@obsidianresearch.com>
 <alpine.DEB.2.20.1605101928280.2103@east.gentwo.org>
 <20160511020429.GA32766@obsidianresearch.com>
 <alpine.DEB.2.20.1605110920490.8588@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1605110920490.8588-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 11, 2016 at 09:23:30AM -0500, Christoph Lameter wrote:
> On Tue, 10 May 2016, Jason Gunthorpe wrote:
> 
> > I still don't understand why this is being forced into
> > libibverbs. dpdk would seem to be the prefered way to access these
> > sorts of features and there is no technical reason why the mlx
> > dpdk provider needs to use libibverbs. Talk directly to /dev/uverbs0
> > and use udata to enable the universe of nic specific features.
> 
> Well then the trouble is how to integrate that into QPs and the rest of
> the RDMA infrastructure.

Granted, yes, dpdk obviously hasn't had much work in that area,
but it also doesn't seem all that complex.

You basically want to attach a dpdk pmd to something other than
ethernet hardware. Eg a IB UD QP using ipoib. At the end of the day
that is just a few more parameters when starting the pmd, and a
different hwaddress length. To me that sounds much simpler than
squeezing all of this endless stuff into libibverbs.

Assuming that could be done, the dpdk community seems to have a much
better handle on how to design and expose these IP acceleration
features. All we need to do in RDMA land is just let the mlx4 pmd and
mlx4 kernel driver communicate privately to do the special
setup. We've already largely done that with udata. I don't think it
would be contentious at all if mlx4 developed some 'dpdk'
driver-specific calls. Much like how hfi1 has psm driver specific
calls.

Overall, dpdk looks alot better for building IP centric apps - it has
more support utilities to work with IP packets, more optimization, and
more device support for this kind of function. libibverbs always seemed
like a poor fit to me..

.. and having something micro-optimized to only do IP would certainly
speed up wr and wc processing in the pmd, code paths and structure
members to support other opcodes can just be purged entirely. That is
the cache line efficiency you were talking about in the other thread.

> Our software is based on raw ethernet frame processing through QPs. Thus
> the desire to have the extras that the hardware can provide. And yes we
> want to have an API that can be used to interface with hardware from
> multiple vendors.

Well, then you need multiple vendors to agree they could potentially
build hardware that matches these proposed uAPIs. Which is more or less
what I've been more or less asking for :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
