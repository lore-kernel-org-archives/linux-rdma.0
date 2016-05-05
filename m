From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Thu, 5 May 2016 12:14:23 -0600
Message-ID: <20160505181423.GB5957@obsidianresearch.com>
References: <5721C3AD.8050407@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB046FD8@ORSMSX109.amr.corp.intel.com>
 <d8f8d6bf-9fad-fcc9-5a15-2b2423349c26@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0480DB@ORSMSX109.amr.corp.intel.com>
 <20160502175011.GB32096@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB04816A@ORSMSX109.amr.corp.intel.com>
 <20160502190619.GB32613@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB048E47@ORSMSX109.amr.corp.intel.com>
 <20160504181135.GA15355@obsidianresearch.com>
 <21d9307f-766e-9aaa-54d3-207a4a4d5d8c@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <21d9307f-766e-9aaa-54d3-207a4a4d5d8c-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 05, 2016 at 11:21:29AM +0300, Matan Barak wrote:
> >This should probably be done after creating the QP (and AH?), as a NIC
> >may not be able to do certain LSO rules with certain QP/AH
> >configurations.
> >
> 
> So I guess we want something that after a user creates a QP, he can query
> which protocols (IP, TCP, etc) could be used in the NIC's segmentation
> offload mechanism.

This is where I get upset with the process we are following here,
without input from other hardware architects in other companies, it is
hard to design something truly common.

> >I'd probably also use the driver-specific channel to communicate the
> >NIC's capability and prototype some kind of API in libibverbs.
> 
> If we would like to expose this feature in the uAPI, why would we want to
> use the vendor specific channel instead of the standard core channel?

Because we don't really know what we are doing, we have only one
example of hardware that implements this and we can change libibverbs
with alot less pain than changing the kernel's uAPI.

If you use the driver channel, and are smart about it, you can
generically expose everything the card can do and can stop churning
the kernel every time a new QP feature comes up. How is that not
better for everyone?

When multiple vendors actually implement a verbs feature (or agree to
implement one via IBTA/IETF/etc) then it becomes much safer to
enshrine it forever in a common kernel uAPI.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
