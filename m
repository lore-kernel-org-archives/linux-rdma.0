From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Thu, 12 May 2016 08:34:41 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1605120832480.26014@east.gentwo.org>
References: <20160506225523.GA21309@obsidianresearch.com> <alpine.DEB.2.20.1605090926440.6128@east.gentwo.org> <20160509163537.GA15479@obsidianresearch.com> <20160509191613.GS29160@leon.nu> <20160509195734.GA22669@obsidianresearch.com> <20160510044107.GU29160@leon.nu>
 <20160510170739.GA2879@obsidianresearch.com> <alpine.DEB.2.20.1605101928280.2103@east.gentwo.org> <20160511020429.GA32766@obsidianresearch.com> <alpine.DEB.2.20.1605110920490.8588@east.gentwo.org> <20160511172745.GA18517@obsidianresearch.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160511172745.GA18517-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 11 May 2016, Jason Gunthorpe wrote:

> You basically want to attach a dpdk pmd to something other than
> ethernet hardware. Eg a IB UD QP using ipoib. At the end of the day
> that is just a few more parameters when starting the pmd, and a
> different hwaddress length. To me that sounds much simpler than
> squeezing all of this endless stuff into libibverbs.

DPDK handles all network traffic for a nic. What we have with the raw
ethernet QPs is the ability to offload individual Ethernet data streams to
user space. That is not possible with DPDK and very much a QP based
feature.

> Overall, dpdk looks alot better for building IP centric apps - it has
> more support utilities to work with IP packets, more optimization, and
> more device support for this kind of function. libibverbs always seemed
> like a poor fit to me..

It does not allow the kernel to handle the ethernet traffic in general but
requires a full implementation of an IP stack with all the extras.

> Well, then you need multiple vendors to agree they could potentially
> build hardware that matches these proposed uAPIs. Which is more or less
> what I've been more or less asking for :)

I did not see disagreement from the other vendors.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
