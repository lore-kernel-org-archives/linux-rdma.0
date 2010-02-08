From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ewg] rdma/cm: disallow loopback address for iwarp devices
Date: Mon, 8 Feb 2010 15:09:03 -0700
Message-ID: <20100208220903.GW16490@obsidianresearch.com>
References: <B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com> <79BAA34231304F1E84C5A5A53C50A207@amr.corp.intel.com> <4B6FFB1B.40905@mellanox.co.il> <4B701FE6.60302@opengridcomputing.com> <adawrynwtz9.fsf@roland-alpha.cisco.com> <20100208191927.GU16490@obsidianresearch.com> <4B706DED.9080403@opengridcomputing.com> <C8A2C57AD5FA4141860DBFF60BFDE2DC@amr.corp.intel.com> <4B707F2D.3030508@opengridcomputing.com> <41CC15C4-0200-4C9E-9E10-3D2A9B76D16B@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <41CC15C4-0200-4C9E-9E10-3D2A9B76D16B-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Tziporet Koren <tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 08, 2010 at 04:56:23PM -0500, Jeff Squyres wrote:

> DESCRIPTION
>        Associates a source address with an rdma_cm_id.  The  address  may  be
>        wildcarded.   If  binding  to a specific local address, the rdma_cm_id
>        will also be bound to a local RDMA device.
 
> What RDMA device is bound to when you use 127.0.0.1?  I'm not 100%
> sure, but I think that this might be where we got the rationale that
> we didn't need additional LOOPBACK tests in OMPI...  (if anyone else
> agrees with this interpretation, then it's at least one argument
> that allowing binding to LOOPBACK devices *is* a change in
> semantics, and therefore should be treated extremely carefully)

This statement is trying to say that if a source address is given then
the rdma_cm_id will be bound to a device. Designating which APIs bind
the device is important for the API user, once the device is bound you
can allocate resource against it.

It doesn't matter which device is picked, that is up to the kernel.
For instance if the the same IP is assigned to multiple RDMA devices
then the kernel will pick one.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
