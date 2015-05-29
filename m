From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Fri, 29 May 2015 07:59:38 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FE1F36@ORSMSX109.amr.corp.intel.com>
References: <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com>
 <20150527222108.GA7855@obsidianresearch.com> <5566BDE4.50709@mellanox.com>
 <alpine.DEB.2.11.1505280908001.16142@east.gentwo.org>
 <20150528162416.GA6515@obsidianresearch.com>
 <alpine.DEB.2.11.1505281212330.1711@east.gentwo.org>
 <20150528175043.GA10966@obsidianresearch.com>
 <alpine.DEB.2.11.1505281325150.1794@east.gentwo.org>
 <20150528195034.GA11182@obsidianresearch.com>
 <alpine.DEB.2.11.1505281522020.2703@east.gentwo.org>
 <20150528204749.GA12780@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150528204749.GA12780-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > Second: What about wrap around? Does it even make sense to expose less
> > > than 64 bits to userspace? Should the driver manage wrap around to
> > > create a flat 64 bit space?
> >
> > The wrap around is given by the mask. Cycle registers are often shorter
> > than 64 bits.
> 
> I am aware of how cycle counters work.
> 
> My point was exposing raw wrapping counters is a horrible UAPI.
> 
> Shouldn't the driver software extend smaller counters to 64 bits?
> That would take a single or and an unlikely branch, so don't say
> 'performance' :)

It's one thing to time stamp a frame or packet.  But this is assigning a time stamp to a work completion.  I don't even know what that's supposed to mean when considering 2 GB (or larger) transfers, RDMA read operations, XRC, dynamic connections, out of order retransmissions, shared receive queues, and other exotic features.  IMO, this is currently vendor specific functionality, and not obviously applicable as a generic feature.  It is certainly poorly defined and exposed in a very implementation specific way.

The use case given by Christoph only speaks of packet level time stamps.  One could argue that such a use case would place the stamp near the packet (similar to the GRH), rather than embedded into a work completion.  This would allow time stamps even in the absence of a work completion.

IMO, vendors already have ways to expose vendor specific features to user space.  I would mark this as vendor specific and keep it out of the core.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
