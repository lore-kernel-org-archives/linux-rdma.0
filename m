From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Tue, 6 Oct 2009 12:05:02 -0700
Message-ID: <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com> <4ACAF913.3050909@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ACAF913.3050909-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>If I understand correct your suggested changes are to optionally let an
>application to - instead of the following sequence of calls
>
>rdma_resolve_addr  / addr resolved event
>rdma_create_qp
>rdma_resolve_route  / route resolved event
>rdma_connect / cm events
>
>do
>
>rdma_set_ib_path
>rdma_create_qp
>rdma_connect / cm events

>From user space, the call sequence does not change.  The user calls
rdma_resolve_addr, rdma_resolve_route, rdma_connect, etc.  It is up to the
librdmacm to perform the resolution.  Today, the resolution request is simply
passed down to the kernel, which restricts how the resolution can be performed.

>So in that respect, I am not sure how rdma_set_dest serves you. Further,
>rdma_resolve_addr does three resolutions
>
>1. the local device and source gid
>2. the PKEY (VLAN) to use
>3. the destination gid
>
>so in that respect, rdma_set_ib_path replaces both rdma_resolve_addr and
>rdma_resolve_route?

I kept resolving the address and route separate.  rdma_set_ib_path, which has
always existed btw, simply sets the route/path.   The new call,
rdma_set_ib_dest, sets the address mapping.  To use rdma_set_ib_dest, the user
must have called rdma_bind_addr first, which covers steps 1 & 2 that you
mentioned above.  The rdma_bind_addr call can be done internally to the
librdmacm as part of the rdma_resolve_addr implementation.  If a user sets the
wrong address mapping or route, they should only affect themselves.

(FYI - I have not yet implemented the librdmacm to call rdma_bind_addr as part
of rdma_resolve_route on linux.  I did not see an easy way to convert a
destination IP address to a source IP address.  If anyone knows how, please let
me know.)

>I would prefer to have a solution where the app flow isn't touched,
>something like the kernel rdma-cm to communicate with the user space ACM
>daemon to get address and route resolutions.  Does such a design makes
>sense to you?

Long term, this is exactly the type of flow that I envision.  I'd like to have
real data to show that the ACM implementation scales first, which is part of my
problem.  I do not have the ability to easily change kernel drivers on any
larger sized clusters.  My approach is to allow user space to perform the
address and route resolution and pass the data to the kernel.  This way, we have
the freedom to test multiple solutions, until we can settle on what works.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
