From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address resolution
 module into core
Date: Tue, 17 May 2016 05:00:03 +0000
Message-ID: <VI1PR05MB1391FBF91190C84744581DB8D2480@VI1PR05MB1391.eurprd05.prod.outlook.com>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
 <20160516185434.GC4662@leon.nu>
 <82b21da8-8bec-a7ed-fc48-b7570c0aa4ce@redhat.com>
 <20160516210327.GB10945@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160516210327.GB10945-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Tuesday, May 17, 2016 12:03 AM
> To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
> resolution module into core
> 
> > and things are broken for some period of time.  If the change to ib_addr
> > actually solved a problem that couldn't be solved otherwise, that would
> > be one thing.  But it doesn't.  It's a complete no-op.
> 
> The original patches had a horrible dynamic registration scheme for
> the netlink dispatch that only served to work around the pointless
> module split. The issue is that the dispatch needs to have function
> relocations from both modules to follow the usual netlink idioms.
Are you talking about  the changes in ibnl_add_client?
Those changes were because of a different module (ib_sa.ko)
In sa_query.c we register a ibnl client for RDMA_NL_LS and
we use that for getting path records (ibacm runs in userspace and listens 
on that netlink socket). If we look at the definition of RDMA_NS_LS
it is defined as a  rdma local service operations, so naturedly
I feel  ip->gid should be added to that family.

It means we have two modules (ib_sa.ko and ib_core/ib_addr depends if we integrate them or not)
Needing to use different operations which are part of the same family.

The approach I've chosen is the easiest to implement because I'm not sure we
need all the complexity other solutions impose. I think Ira suggested to introduce "add operation"
it's an idea I've thought about, but it raises the issue of ibnl needing to manage each family.
This idea has the benefit if we want to have an overlap between clients, can you think
of a use case where different clients need to support the same operation?

I should also mention the option of adding a new family RDMA_NL_LS_IP or something 
like that. I didn't do that because we are using ibacm to answer the ip->gid requests.
Ibacm already listens on a netlink socket for RDMA_NS_LS, so it makes adding
Ip->gid to ibacm much easier and nicer if it needs to listen on only one netlink socket.

> It is unfortunate that distro scripts have become such that they break
> if the kernel changes even something small like dependencies.
> 
> Another alternative is to move only the parts of ib_addr that touch
> netlink into ib_core. Hopefully that doesn't create an empty module.
> 
> Jason

Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
