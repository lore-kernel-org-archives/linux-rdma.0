From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] rdma cm + XRC
Date: Wed, 11 Aug 2010 17:10:17 -0600
Message-ID: <20100811231017.GD10271@obsidianresearch.com>
References: <4C5331DC.9080109@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com> <4C618334.7010106@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C0C2@orsmsx501.amr.corp.intel.com> <20100810171405.GM11306@obsidianresearch.com> <4C61BF26.9060003@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601BE4@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601BE4-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 11, 2010 at 03:22:45PM -0700, Hefty, Sean wrote:
> > It seems the new API has too many constraints for XRC. There are a couple
> > things that don't fit:
> > 
> > - XRC needs a domain, which must be created before creating the QP, but
> > after we know
> >   the device to use. In addition it also needs a file descriptor. The
> > application may
> >   want to use a different fd depending on the device. Currently the domain
> > can only
> >   be created in the middle of rdma_create_ep().
 
> This looks like a gap in the APIs.  There's no easy way to associate
> the data returned by rdma_addrinfo to a specific ibv_device.  Part of
> the issue is that rdma_addrinfo may not have an ai_src_addr.
> gurgle...

This is why I liked the notion of passing in the pd. This restricts
getaddrinfo to doing something that is compatible with the PD and when
the rdma_cm_id is created and bound it is bound to a device, selected
by getaddrinfo, or the kernel, that is compatible with the given PD.

[** I looked at this for a bit, and I couldn't convince myself the
 current imeplementation doesn't have this gap either. The rdma_cm_id
 is bound to a device based on IP addresses, but it can be bound
 without specifying a PD - so there really is no guarentee that the PD
 you want to use will be compatible with the device the kernel
 selects - I bet this means most RDMA CM using apps will explode if you
 do something like IPoIB bond to HCAs..]

[The other view is that exporting per device domains to userspace
 means the kernel has walked away from its role as HW resource
 virtualizer. Why can't a PD be global and the kernel swap it into
 HW as necessary? Makes much of this API mess instantly disappear.]

Ditto for XRC domains.

I think the flow works best for apps, generally apps are being written
that can handle only one domain - so they should get the domain
through a 0 call to getaddrinfo and then re use that domain in all
future calls for secondary connections.

> I agree with Jason that we can still change the newer calls.  In
> this case, the problem isn't limited to XRC.  The user will have
> issues just trying to specify the CQs that should be associated with
> the QP.  Maybe the 'fix' here is to remove rdma_create_qp() from
> rdma_create_ep() -- which basically replaces that API with
> rdma_create_id2(**id, *res).

Maybe 3 functions, since you already have create_ep:
create_id_ep - takes rdma_addrinfo, allocates PD/XRC, rdma_cm_id
create_qp_ep - takes rdma_addrinfo, allocates QP, CQ, etc
create_ep - just calls both the above. Very simplified
(not sure on the names)

Flow is then:

// First QP
hints = 0;
rdma_getaddrinfo(..,&hints,&res);
rdma_create_id_ep(&id,&res)
// id->verbs, id->pd, id->xrcdomain are valid now
rdma_create_qp_ep(id,res,&attrs);

// Second QP
hints.pd = first_id->pd;
hints.xrcdomain = first_id->xrcdomain;
rdma_getaddrinfo(...,&hints,&res);
res->pd/xrcdomain are == first_id
// No pd is allocated
rdma_create_ep(&second_id,&res,&attrs);

How do you keep track of the lifetime of the pd though?

This also cleans up the confusing half-state of the rdma_cm_id with
the legacy API where id->verbs can be 0.

> > - The server side of the connection also needs an SRQ. It's not obvious
> > whether it's
> >   the application or rdma cm to create that SRQ. And that SRQ number must
> > be
> >   given to the client side, presumably in the private data.
> 
> The desired mapping of XRC to the librdmacm isn't clear to me.  For
> example, after 'connecting' is two-way communication possible
> (setting up INI/TGT pairs on both nodes), or is a connection only
> one-way (setup local INI to remote TGT)?  Also, as you point out,
> how are SRQ values exchanged?  Does private data carry one SRQ
> value, all SRQ values for remote processes, none?

Well, I think RDMACM should do the minimum above what is defined for
the CM protocol, so for XRC that is a unidirectional connect and it
only creates INI/TGT pairs. The required SRQ(s) will have to be setup
by the user - I expect the typical use would be SRQs shared by
multiple TGT QPs.

It looks to me like the main use model for this is peer-peer, so each
side would establish their send half independently and message routing
would be app specific. This means the CM initiator side should be the
side that has the INI QP and the CM target side should be the side
with TGT - ?

Absent any standards, private data SRQ number exchange is protocol
specific..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
