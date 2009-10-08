From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Thu, 8 Oct 2009 11:21:20 -0600
Message-ID: <20091008172120.GX5191@obsidianresearch.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com> <4ACAF913.3050909@voltaire.com> <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com> <15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com> <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com> <0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com> <20091008005425.GW5191@obsidianresearch.com> <3BA5B96263EC4ACA8FF3C4D8DCF47C69@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3BA5B96263EC4ACA8FF3C4D8DCF47C69-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 07, 2009 at 11:46:24PM -0700, Sean Hefty wrote:
> >Yep, not sure how you handle the listening side without port
> >conflicts?? But that doesn't seem to be a huge problem. TBH - since
> >ACM is kinda its own little world, it could just use a seperate
> >service ID space from RDMA CM?
 
> I'm not sure how to handle the port space yet.  The port space is
> specified when the rdma_cm_id is created.  I don't think there's an
> immediate need to change anything on the listen side, but if we add
> AF_IB, then adding RDMA_PS_IB may make sense.  This could be the
> full 64-bit service ID.  (We can determine the right name for AF_IB
> / AF_GID based on what's actually in the structure.)

RDMA_PS_IB I think is nescessary for this scheme to make sense. If the
listening side continues to use the IP mode to listen then I guess the
client can compute an appropriate service ID, but it seems a bit
strange for one side to use IP and the other side to use the ACM
method? I was imagining you'd configure both sides to use the same
method.

> >> The following information should be known after calling
> >> rdma_resolve_addr: sgid, dgid, pkey, source port/sid, destination
> >> port/sid.  The address structure for AF_IB should be defined to
> >> capture this information.  (The port / service ID needs to be worked
> >> out.)
> >
> >Yes, that seems great..
> 
> On second thought, I'm not sure about _needing_ the pkey.  My first draft of
> this is:
> 
> struct sockaddr_ib {
> 	unsigned short int ib_family;
> 	__u16 reserved;
> 	union ib_gid gid;
> 	__be64 ib_service_id; 
> };
> 
> Although I considered dividing the service id and putting the low
> order bytes where reserved is, or only supporting the RDMA IP CM
> service ID format, possibly using sockaddr_in6 directly.

Well, it seems to me, within the RDMA CM API in GID mode the only
purpose of the sockaddr is to select the device. In APM cases there
may actually be multiple gids on either side.. Doubling up and using
it as a way to pass the service ID seems fine to me. the RDMA CM API
would then ignore the gid portion of the destination address, use the
GID portion of the source address to choose the device and record the
service IDs in both to use in the CM protocol.

IPv6 has the notion of a scope_id which is used to select the device
in ambiguous cases. I don't think that is needed here, the source GID
should be unambiguous and the destination GID isn't used for device
selection.

Also, the naming scheme should probably use sib_ as a prefix for
consistency with POSIX. 

BTW, sockaddrs should also always be accompanied by a socklen_t to
indicate their length (for alignment with POSIX). I noticed the
current CM API doesn't do that..

> >What API would you use to pass the PR data?
> 
> API at which level?

User space librdmacm
 
> >> Would this approach combined with the ability to set the route work for
> >> everyone?
> >
> >'set the route' ?
> 
> Pass the path record to the kernel.  This piece is still missing to
> allow user space to own the policy for obtaining path information.

Right, I think you can reasonably use the option approach to
communicate with the kernel, but I think something more standardized
is needed for the user space API.

If the flow is:
rmda_get_addr_info("foo","123",&hints,&result);
rdma_create_id(chan,&id,result[0].port_space);
rdma_resolve_addr(id,result[0].source,result[0].dest,0);
[..]
rdma_resolve_route(id,0);

Maybe the best approach is to change rdma_resolve_route to:
 rdma_resovle_routex(id,result[0].route_data,result[0].route_data_len,0);

The reason to do this is so that the API is clean, calling an IB
specific option in what should be a protocol neutral code path is not
too nice. The two existing PS's would simply use 0 for the route_data.

route_data would be AF/PS defined structure - for IB it would be the
up to 5 PRs.

Under the covers it can use the existing option API to the kernel,
that is not really too important.

Is there anything else the IB CM API can do that this could not?

[** The other choice I could see is to use the sockaddr_ib to pass the
 PR data. The problem with this is that the existing API doesn't use
 socklen_t and sockaddr_ib with 3 PRs would overflow sockaddr_storage,
 so the resulting API would be 'broken by design' on the Rusty scale
 :( ]

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
