From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Tue, 06 Oct 2009 10:00:19 +0200
Message-ID: <4ACAF913.3050909@voltaire.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F451C333D8CB45E4B4642C6BD1EDD3C3-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
> Provide an option for user's to manually specify the socket address to DGID mapping on InfiniBand.  Currently, all mappings are done using ipoib, and involve ARP.  This will not work across IP subnets, and alternative mechanisms of resolving the mapping are being explored. The latter can be more efficient if combined with route resolution as well.
Sean, 

If I understand correct your suggested changes are to optionally let an 
application to - instead of the following sequence of calls

rdma_resolve_addr  / addr resolved event
rdma_create_qp
rdma_resolve_route  / route resolved event
rdma_connect / cm events

do

rdma_set_ib_path
rdma_create_qp
rdma_connect / cm events

So in that respect, I am not sure how rdma_set_dest serves you. Further, 
rdma_resolve_addr does three resolutions

1. the local device and source gid
2. the PKEY (VLAN) to use
3. the destination gid

so in that respect, rdma_set_ib_path replaces both rdma_resolve_addr and
rdma_resolve_route?

I would prefer to have a solution where the app flow isn't touched, 
something like the kernel rdma-cm to communicate with the user space ACM 
daemon to get address and route resolutions.  Does such a design makes 
sense to you?


Or

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
