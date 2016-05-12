From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Thu, 12 May 2016 10:54:35 -0600
Message-ID: <20160512165435.GA12248@obsidianresearch.com>
References: <20160509163537.GA15479@obsidianresearch.com>
 <20160509191613.GS29160@leon.nu>
 <20160509195734.GA22669@obsidianresearch.com>
 <20160510044107.GU29160@leon.nu>
 <20160510170739.GA2879@obsidianresearch.com>
 <alpine.DEB.2.20.1605101928280.2103@east.gentwo.org>
 <20160511020429.GA32766@obsidianresearch.com>
 <alpine.DEB.2.20.1605110920490.8588@east.gentwo.org>
 <20160511172745.GA18517@obsidianresearch.com>
 <alpine.DEB.2.20.1605120832480.26014@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1605120832480.26014-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 12, 2016 at 08:34:41AM -0500, Christoph Lameter wrote:
> On Wed, 11 May 2016, Jason Gunthorpe wrote:
> 
> > You basically want to attach a dpdk pmd to something other than
> > ethernet hardware. Eg a IB UD QP using ipoib. At the end of the day
> > that is just a few more parameters when starting the pmd, and a
> > different hwaddress length. To me that sounds much simpler than
> > squeezing all of this endless stuff into libibverbs.
> 
> DPDK handles all network traffic for a nic.

Eh? The DPDK documentation for the mlx4 PMD disagrees:

 This capability allows the PMD to coexist with kernel network
 interfaces which remain functional, although they stop receiving
 unicast packets as long as they share the same MAC address.

The mlx4 PMD *is* QP based, clearly there is no fundamental obstacle
to providing the dpdk API over a flow-steering QP hardware model.

>From that point it becomes a problem of configuring the QP's flow
steering to get the exact split you need, which is exactly the same as
what is being done with verbs today.

Don't be confused that the typical example of dpdk uses a sr-iov
hardware driver, that is just reflecting a limitation of the NIC
hardware available, better hardware like mlx4 can and does use a QP
model to steer the packets instead.

> > build hardware that matches these proposed uAPIs. Which is more or less
> > what I've been more or less asking for :)
> 
> I did not see disagreement from the other vendors.

You don't find Steve's remarks troubling then?

I view Chelsio as one the vendors that could actually implement the
hardware side of these proposed APIs with a firmware update and he
hasn't even looked at them, and has yet to understand what they even
do..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
