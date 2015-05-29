From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and hca_core_clock
 to query_device
Date: Fri, 29 May 2015 08:55:01 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1505290846480.8178@east.gentwo.org>
References: <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com> <20150527222108.GA7855@obsidianresearch.com> <5566BDE4.50709@mellanox.com> <alpine.DEB.2.11.1505280908001.16142@east.gentwo.org> <20150528162416.GA6515@obsidianresearch.com>
 <alpine.DEB.2.11.1505281212330.1711@east.gentwo.org> <20150528175043.GA10966@obsidianresearch.com> <alpine.DEB.2.11.1505281325150.1794@east.gentwo.org> <20150528195034.GA11182@obsidianresearch.com> <alpine.DEB.2.11.1505281522020.2703@east.gentwo.org>
 <20150528204749.GA12780@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A8FE1F36@ORSMSX109.amr.corp.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FE1F36-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 29 May 2015, Hefty, Sean wrote:

> > Shouldn't the driver software extend smaller counters to 64 bits?
> > That would take a single or and an unlikely branch, so don't say
> > 'performance' :)
>
> It's one thing to time stamp a frame or packet.  But this is assigning a ti=
> me stamp to a work completion.  I don't even know what that's supposed to m=
> ean when considering 2 GB (or larger) transfers, RDMA read operations, XRC,=
>  dynamic connections, out of order retransmissions, shared receive queues, =
> and other exotic features.  IMO, this is currently vendor specific function=

What is the issue here? The timestamp is created when the processing is
finished by the nic and the completion entry becomes available.

> ality, and not obviously applicable as a generic feature.  It is certainly =
> poorly defined and exposed in a very implementation specific way.

It is exactly defined like any other cycle counters in hardware and it is
exposed using an API that allows multiple vendors to use these cycle
counters without regard to a particular vendors implementation.

I sure wish that Intel would be supporting a feature like this. Please
come up with a better alternative if there is one. This is likely going to
be a differentiator for the vendor used in our industry.

> The use case given by Christoph only speaks of packet level time stamps.  O=
> ne could argue that such a use case would place the stamp near the packet (=
> similar to the GRH), rather than embedded into a work completion.  This wou=
> ld allow time stamps even in the absence of a work completion.
>
> IMO, vendors already have ways to expose vendor specific features to user s=
> pace.  I would mark this as vendor specific and keep it out of the core.

How exactly would that work? How can we attach vendor specific extension
to a completion structure?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
