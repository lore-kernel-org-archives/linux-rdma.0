From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and hca_core_clock
 to query_device
Date: Fri, 29 May 2015 11:59:21 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1505291153180.9179@east.gentwo.org>
References: <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com> <20150527222108.GA7855@obsidianresearch.com> <5566BDE4.50709@mellanox.com> <alpine.DEB.2.11.1505280908001.16142@east.gentwo.org> <20150528162416.GA6515@obsidianresearch.com>
 <alpine.DEB.2.11.1505281212330.1711@east.gentwo.org> <20150528175043.GA10966@obsidianresearch.com> <alpine.DEB.2.11.1505281325150.1794@east.gentwo.org> <20150528195034.GA11182@obsidianresearch.com> <alpine.DEB.2.11.1505281522020.2703@east.gentwo.org>
 <20150528204749.GA12780@obsidianresearch.com> <alpine.DEB.2.11.1505290845040.8178@east.gentwo.org> <1432918170.114391.104.camel@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432918170.114391.104.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 29 May 2015, Doug Ledford wrote:

> > Well this is a kernel bypass API and a lot of raw hardware issues will
> > have to be handled since you do go directly to the device.
>
> No, that's not entirely true, and it *certainly* is not the correct way
> to think about verbs extensions.  Is it kernel bypass?  Yes.  Does it go
> direct to the hardware?  Not as far as the user application is
> concerned.  The direct hardware access is abstracted away in the verbs

There is a compromise here by using the kernel as a administrative
function (setup and configuration of QPs) but using bare metal for the
data path. The structures modified for send/receive are structures that
are directly understood and handled by the hardware. That is the core
benefit of the RDMA API which results in the wanted performance and
latency.

The administrative function / bare metal separation is also reflected in
this patchset. The admin function allows the determination of the cycle
counter freq and size. The bare metal cycle counter exists in the
fastpath.

> library.  Because the verbs library is a hardware abstraction layer, any
> extensions to it need to be well thought out.  And by that I mean if it
> is of general use, then it should be added in a general, abstract way
> that any hardware can implement.  If it is specific to just one vendor's
> hardware, then it can be added in a means that is specific to that
> vendor's hardware.

What is particular here to the vendor?

> Now, as a general rule, I would call timestamps general.  They should be
> added in a fashion that anyone can implement.  They should also be well
> defined.  Sean's questions raise a very valid point.  Exactly what is
> being timestamped, and do we care about different timestamp options?  Is
> it completion of message, start of message, transfer from HCA to main
> system memory completion, etc.  The 00/10 header to this patch series
> was probably answering Sean's question, but just based on the name of
> the TIMESTAMP flag to the CQ creation attr struct it isn't clear that
> this is the case.

Ok then lets answer that.

> > Right but then we are not at the comfortable sockets API here but at the
> > bare metal level.
>
> That's not entirely true.  We still hold to our abstrations, they are
> just intentionally kept very thin and high performing.

Well there is a distinction here.

We provide the comfort of setup and administrative functions through the
kernel API. We still try to isolate the application as much as possible
when we go to the data paths but we need to hit bare metal in the fastpath
in order to accomplish our mission of maximum performance and minimum
latency. This cannot be accomplished with kernel calls and therefore it is
an examplle of kernel bypass. We want this as comfy as possible of course
and well defined.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
