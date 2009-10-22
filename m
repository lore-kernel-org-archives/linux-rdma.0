From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Thu, 22 Oct 2009 00:25:31 -0600
Message-ID: <20091022062531.GB26003@obsidianresearch.com>
References: <676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com> <20091020003344.GA14520@obsidianresearch.com> <1256164230.12075.31.camel@wilder.ibm.com> <9D257695083141E79685CB2B260D7D7C@amr.corp.intel.com> <20091021233639.GS14520@obsidianresearch.com> <BFF5CD71FFA74BF09A2EED5F3319F370@amr.corp.intel.com> <20091022002846.GU14520@obsidianresearch.com> <4803112A5B7A4953B62ABAFD1BBD9881@amr.corp.intel.com> <20091022011939.GW14520@obsidianresearch.com> <60E9443821EE4FFA90448DF5CC1368A8@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <60E9443821EE4FFA90448DF5CC1368A8-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2009 at 10:24:29PM -0700, Sean Hefty wrote:
> >That is very difficult to fit into the semantics the IP routing
> >model uses :( And it looks like an API problem in DAPL :(
> 
> This depends on if your view is that the rdma cm is trying to match IP routing,
> trying to use IP addresses as convenient names for RDMA ports, or something in
> between that may lean more one way or the other depending on the device type.
> IMO, the primary reason for using IP addressing over IB is more for convenience,
> than compliance.

I more or less agree for IB, but iWarp really should match exactly,
and TBH I'm disappointed that no iWarp folks ever reviewed this stuff
for consistency with the IP stack, it goes to show that netdev wasn't
far off their criticisms I guess :(

> >[What happens now if I do this:
> > rdma_bind(10.0.0.11)
> > rdma_resolve_addr(src = 192.168.122.1 dst = 10.0.0.11)
> >Does the cma_bind path check that it is already bound and give out an
> >error? too late for me to check]
> 
> rdma_resolve_addr only calls bind if the rdma id is not already bound.  The
> src_addr simply gets ignored in this case, and the bound address is used
> instead.

This should get updated to return -EINVAL for this case I think, since
it is nonsense. Either src = null or src == bind addr
 
> >Truth be told, to fit the Linux IP model, the RDMA CM should have
> >provided exactly only two ways to bind a cm_id to a specific device -
> >rdma_accept and rdma_resolve_addr.
> 
> I think this is more restrictive than things need to be.

You get somethings and you loose somethings.. The Linux IP model is
not choosen arbitarily, there are solid reasons why it works like that.

Mainly for RDMA what you get is more kernel flexability, IP like
capabilities, better bonding, and better support of IB APM semantics:
 - bind() + listen() actually works properly if more than one
   interface is bound to the same IP - the cm_id returned by accept is
   bound to the hca and port that accepted the connection
   [ This is a L3 form of bonding Linux supports ]

   This is actually something of a mandatory notion to implement the
   full generality of the IB CM protocol which allows the CM REP to
   contain a port GUID of another port on the same node (multi-port
   APM is an IB feature). So you never know what port the accept()
   result will get bound to.

   BTW: I suppose ideally AF_IB would have a way to say 'CM accept REPs on
   any port on this node' Hmm, reserved GID prefix perhaps? Hmm.

   When used with bonding this would also afford the kernel with the
   ability to accept incoming connections across all the redundant
   RDMA devices - and still have correct bound-to-IP semantics.

 - rdma_resolve_addr more or less as the inverse of all the above
   * multiple interfaces with same IP case works, kernel and routing
     table can distribute outgoing connections
   * multi-port APM works, kernel and user space can choose primary
     and backup port for the IP addy
   * bonding works, kernel can balance outgoing connections across the
     bond slaves.

These are all useful features.

Could we have had the above and still had pretty much enough
flexability? Yes, I think so. The main stumbling block, IMHO, seems to
have been the tying of PDs and a few other non QP verbs objects to a
ibv_context, it should have been the other way around - a PD, comp
channel, etc are fist class kernel objects that exist across all
ports and devices. When a QP is connected to them then the kernel
would setup the HW to match the PD, MRs, etc.

CQs and SRQs would still have to be created after an accpt/route_addr,
but that seems pretty mild <shrug>

But that is of course not how things worked out, it would be possible
to get there from here, but I doubt there is any interest..
It is late, I'm just musing what could have been :)

Still, it must be a total nightmare to write a daemon that listens on
INADDR_ANY, works correctly with multiple devices plus hotplug, and
dosn't leak PDs or something silly - and that is a shame.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
