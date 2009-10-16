From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH]  link-local address fix for rdma_resolve_addr
Date: Fri, 16 Oct 2009 11:54:39 -0700
Message-ID: <1255719280.14675.30.camel@wilder.ibm.com>
References: <1255471781.14513.7.camel@wilder.ibm.com>
	 <20091013231234.GK5191@obsidianresearch.com>
	 <1255537437.14513.28.camel@wilder.ibm.com>
	 <20091014170155.GL5191@obsidianresearch.com>
	 <1255541405.5111.14.camel@wilder.ibm.com>
	 <20091014174017.GM5191@obsidianresearch.com>
	 <1255634841.5111.40.camel@wilder.ibm.com>
	 <20091015213205.GV5191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091015213205.GV5191-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Thu, 2009-10-15 at 15:32 -0600, Jason Gunthorpe wrote:

> 
> The actual fixing to the code is not hard, remove rdma_translate_ip,
> addr_resolve_local, split addr_resolve_remote into a part to resolve
> the route and a part that does the arp/nd. Make the route resolve part
> work almost exactly like addr4_resolve_remote (noting that the v6
> version is wrong, since is doesn't respect unset source addres,
> another bug). Call rdma_copy_addr based on the rt->idev->dev (or
> should it be odev??). Do the ARP.
> 
> The pain is in retesting everything :|
> 
> Jason

There is the wrinkle in this plan.  If you pass ip6_route_output() your
own link-local address (scoped or not) it returns a neighbor entry bound
to the loop back device.

$ ip route get fe80::202:c903:1:28ed oif ib0
local fe80::202:c903:1:28ed from :: via :: dev lo  table local  proto
none  src fe80::202:c903:1:28ed  metric 0  mtu 16436 advmss 16376
hoplimit 4294967295

Thats not going to work as lo has no RDMA support.  I suspect this is
why addr_resolve_local() was added in the first place :)

I will post a patch with our first solution and include the fix to
addr_resolve_local(). 

 Dave.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
