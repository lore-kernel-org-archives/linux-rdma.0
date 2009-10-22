From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] link-local address fix for rdma_resolve_addr
Date: Wed, 21 Oct 2009 22:24:29 -0700
Message-ID: <60E9443821EE4FFA90448DF5CC1368A8@amr.corp.intel.com>
References: <1255992430.12075.7.camel@wilder.ibm.com> <20091019234329.GC9643@obsidianresearch.com> <676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com> <20091020003344.GA14520@obsidianresearch.com> <1256164230.12075.31.camel@wilder.ibm.com> <9D257695083141E79685CB2B260D7D7C@amr.corp.intel.com> <20091021233639.GS14520@obsidianresearch.com> <BFF5CD71FFA74BF09A2EED5F3319F370@amr.corp.intel.com> <20091022002846.GU14520@obsidianresearch.com> <4803112A5B7A4953B62ABAFD1BBD9881@amr.corp.intel.com> <20091022011939.GW14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091022011939.GW14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>That is very difficult to fit into the semantics the IP routing
>model uses :( And it looks like an API problem in DAPL :(

This depends on if your view is that the rdma cm is trying to match IP routing,
trying to use IP addresses as convenient names for RDMA ports, or something in
between that may lean more one way or the other depending on the device type.
IMO, the primary reason for using IP addressing over IB is more for convenience,
than compliance.

>So, I see now, you are proposing that in this case the connection
>attempt to be routed through the network and not looped back..  I
>actually have a big problem with that, ignoring a 'lo' entry in a
>routing table is very much not IP like and not a good idea. That
>should be respected..

I hesitate comparing RDMA versus IP too closely.

>Sigh. Anyhow, lets not get side tracked. It seems to me, the easy way
>out for David's approach is to simply check if the device is already
>bound via rdma_bind() and if so force it to that device no matter what
>the routing table lookup returns. Can you suggest a reliable way to
>make that check?

I'm not entirely sure of the best way to test this.  Checking the src_dev_addr
is my first thought.

>[What happens now if I do this:
> rdma_bind(10.0.0.11)
> rdma_resolve_addr(src = 192.168.122.1 dst = 10.0.0.11)
>Does the cma_bind path check that it is already bound and give out an
>error? too late for me to check]

rdma_resolve_addr only calls bind if the rdma id is not already bound.  The
src_addr simply gets ignored in this case, and the bound address is used
instead.

>Once the cma_bind for rdma_resolve_addr is moved into the
>addr_resolve_remote function then people using the API without calling
>bind on the client path will get sane IP-like behavior.

I like the approach, I'm just concerned about the case where the app has
requested a specific source address, which today means that a specific RDMA
device should be used.

>Remember, on Linux the IP is *not* attached to a device, it is part of
>the host itself. So the idea that a source address somehow specifies a
>RDMA device does not fit into the Linux IP networking model.

I would say we're extending the linux networking model to incorporate this
concept, while staying in our imposed little RDMA sand box world.  Even iWarp
has these issues.

>Truth be told, to fit the Linux IP model, the RDMA CM should have
>provided exactly only two ways to bind a cm_id to a specific device -
>rdma_accept and rdma_resolve_addr.

I think this is more restrictive than things need to be.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
