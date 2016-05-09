From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Mon, 9 May 2016 20:35:08 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB04A40A@ORSMSX109.amr.corp.intel.com>
References: <20160502190619.GB32613@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB048E47@ORSMSX109.amr.corp.intel.com>
 <20160504181135.GA15355@obsidianresearch.com>
 <21d9307f-766e-9aaa-54d3-207a4a4d5d8c@mellanox.com>
 <20160505181423.GB5957@obsidianresearch.com>
 <alpine.DEB.2.20.1605052116570.1091@east.gentwo.org>
 <20160506225523.GA21309@obsidianresearch.com>
 <alpine.DEB.2.20.1605090926440.6128@east.gentwo.org>
 <20160509163537.GA15479@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB04A390@ORSMSX109.amr.corp.intel.com>
 <20160509200507.GA23911@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160509200507.GA23911-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> We need to decide as a community what we want to do here, because this
> uncertain process is getting tiring for everyone.

Agree greatly

> The Collab Summit discussions ended with a general consensus that some
> things would go to the driver-specific channel, while hardware
> behavior related to the common uAPI would go through at least a
> multi-vendor sign off process - like IBTA.

I agree with this approach.

> We didn't talk about how to expose them to apps in userspace once they
> were exposed through the kernel.

I think this will end up being vendor specific, and I'm not sure each vendor knows what they want to do.

> It is pretty obvious the current 'process' isn't working. This new
> idea that the common uAPI should just be a union of every vendor's
> unique hardware ideas has not resulted in patches being merged any
> faster; and I think the quality of the API is not as good now..

IMO, crafting a common API means a higher level of abstraction.  The lower the API, the more it needs to be driver specific.  I prefer a method that: allows vendors to stay out of each other's way, and quickly allows vendors to export their features to user space.  Either of these options can work for that.  I don't see that a low-level, common API is suitable.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
