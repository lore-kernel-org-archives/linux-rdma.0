From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Wed, 21 Oct 2009 19:19:39 -0600
Message-ID: <20091022011939.GW14520@obsidianresearch.com>
References: <1255992430.12075.7.camel@wilder.ibm.com> <20091019234329.GC9643@obsidianresearch.com> <676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com> <20091020003344.GA14520@obsidianresearch.com> <1256164230.12075.31.camel@wilder.ibm.com> <9D257695083141E79685CB2B260D7D7C@amr.corp.intel.com> <20091021233639.GS14520@obsidianresearch.com> <BFF5CD71FFA74BF09A2EED5F3319F370@amr.corp.intel.com> <20091022002846.GU14520@obsidianresearch.com> <4803112A5B7A4953B62ABAFD1BBD9881@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4803112A5B7A4953B62ABAFD1BBD9881-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2009 at 05:40:30PM -0700, Sean Hefty wrote:

> >Even so, it still seems OK to me:
> >
> >Path:
> > addr4_resolve_remote
> >  $ ip route get 10.0.0.11 from 192.168.122.1
> >    local 10.0.0.11 from 192.168.122.1 dev lo
> >  srcIP = 192.168.122.1
> >  rdma_translate_ip(dst_ip = 10.0.0.11)
> >   rdma_copy_addr("eth0");
> >    src_dev_addr = eth0.dev_addr  (ie GID of 10.0.0.11)
> >  memcpy(dst_dev_addr = src_dev_addr) (ie GID of 10.0.0.11)
> >
> >So everthing is bound to the GID of 10.0.0.11 which matches the listen
> >of 10.0.0.11, which seems OK.
> 
> The source could have called rdma_bind_addr(192.168.122.1) prior to calling
> rdma_resolve_addr().  (DAPL does this.)  This would have returned a different
> RDMA device than binding to 10.0.0.11.  The client app could have allocated
> resources on that device, but the CM REQ will carry the gid/lid of the other
> device.  The endpoints won't be able to communicate.

That is very difficult to fit into the semantics the IP routing
model uses :( And it looks like an API problem in DAPL :(

So, I see now, you are proposing that in this case the connection
attempt to be routed through the network and not looped back..  I
actually have a big problem with that, ignoring a 'lo' entry in a
routing table is very much not IP like and not a good idea. That
should be respected..

I guess I'd much rather see that one situation return EHOSTUNREACH or
something.

But, I suppose you are going to tell me that Intel MPI uses DAPL to
loopback connect to other processes on the same node, and relies on
this? :( :( :(

Sigh. Anyhow, lets not get side tracked. It seems to me, the easy way
out for David's approach is to simply check if the device is already
bound via rdma_bind() and if so force it to that device no matter what
the routing table lookup returns. Can you suggest a reliable way to
make that check?

[What happens now if I do this:
 rdma_bind(10.0.0.11)
 rdma_resolve_addr(src = 192.168.122.1 dst = 10.0.0.11)
Does the cma_bind path check that it is already bound and give out an
error? too late for me to check]

Once the cma_bind for rdma_resolve_addr is moved into the
addr_resolve_remote function then people using the API without calling
bind on the client path will get sane IP-like behavior.

> Yes, it's weird, and may not be optimal, but if a source address is
> explicitly given, then its mapping to a specific RDMA device should
> be honored.

Remember, on Linux the IP is *not* attached to a device, it is part of
the host itself. So the idea that a source address somehow specifies a
RDMA device does not fit into the Linux IP networking model.

Unfortunately the definition of rdma_bind kinda bakes this mismatched
model into the API :(

Truth be told, to fit the Linux IP model, the RDMA CM should have
provided exactly only two ways to bind a cm_id to a specific device -
rdma_accept and rdma_resolve_addr.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
