From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Thu, 28 May 2015 14:47:49 -0600
Message-ID: <20150528204749.GA12780@obsidianresearch.com>
References: <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com>
 <20150527222108.GA7855@obsidianresearch.com>
 <5566BDE4.50709@mellanox.com>
 <alpine.DEB.2.11.1505280908001.16142@east.gentwo.org>
 <20150528162416.GA6515@obsidianresearch.com>
 <alpine.DEB.2.11.1505281212330.1711@east.gentwo.org>
 <20150528175043.GA10966@obsidianresearch.com>
 <alpine.DEB.2.11.1505281325150.1794@east.gentwo.org>
 <20150528195034.GA11182@obsidianresearch.com>
 <alpine.DEB.2.11.1505281522020.2703@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1505281522020.2703-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 28, 2015 at 03:34:00PM -0500, Christoph Lameter wrote:
> On Thu, 28 May 2015, Jason Gunthorpe wrote:
> 
> > Second: What about wrap around? Does it even make sense to expose less
> > than 64 bits to userspace? Should the driver manage wrap around to
> > create a flat 64 bit space?
> 
> The wrap around is given by the mask. Cycle registers are often shorter
> than 64 bits.

I am aware of how cycle counters work.

My point was exposing raw wrapping counters is a horrible UAPI.

Shouldn't the driver software extend smaller counters to 64 bits?
That would take a single or and an unlikely branch, so don't say
'performance' :)

> through a complete cycle. But that is the nature of these counters. And
> thats what you see when you look into the kernel timer subsystem for
> example.

Very little in the kernel is exposed to that wrapping, the timer
subsystem takes care of it. Certainly, userspace never sees it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
