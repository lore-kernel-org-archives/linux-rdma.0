From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma cm + XRC
Date: Wed, 11 Aug 2010 17:04:00 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601D3C@orsmsx501.amr.corp.intel.com>
References: <4C5331DC.9080109@systemfabricworks.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com>
 <4C618334.7010106@systemfabricworks.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C0C2@orsmsx501.amr.corp.intel.com>
 <20100810171405.GM11306@obsidianresearch.com>
 <4C61BF26.9060003@systemfabricworks.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601BE4@orsmsx501.amr.corp.intel.com>
 <20100811231017.GD10271@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100811231017.GD10271-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Maybe 3 functions, since you already have create_ep:
> create_id_ep - takes rdma_addrinfo, allocates PD/XRC, rdma_cm_id
> create_qp_ep - takes rdma_addrinfo, allocates QP, CQ, etc
> create_ep - just calls both the above. Very simplified
> (not sure on the names)

This is similar to what I was thinking, except I would just use the existing create_qp.

I need to give adding PDs to rdma_addrinfo more thought.  It seems that if AF_IB were ever accepted, then device specific addressing could be used, rather than relying on mapped values.  As an alternative, we could define a function like:

struct ibv_context *rdma_get_device(rdma_addrinfo *res);

Internally, this would just end up doing a lot of the same work that create_id_ep mentioned above would do.

> How do you keep track of the lifetime of the pd though?

The librdmacm obtains the list of devices during initialization.  It allocates a PD per device, which exist while the library is loaded.  This can be optimized to release the PDs when nothing is left that references the devices, but that's not done now.  If the user specifies the PD, it's up to them to track it.

> Well, I think RDMACM should do the minimum above what is defined for
> the CM protocol, so for XRC that is a unidirectional connect and it
> only creates INI/TGT pairs. The required SRQ(s) will have to be setup
> by the user - I expect the typical use would be SRQs shared by
> multiple TGT QPs.
> 
> It looks to me like the main use model for this is peer-peer, so each
> side would establish their send half independently and message routing
> would be app specific. This means the CM initiator side should be the
> side that has the INI QP and the CM target side should be the side
> with TGT - ?

This is why I questioned what the desired behavior should be (from an API perspective).  If the main usage model is peer-peer, then the librdmacm _could_ allocate and connect XRC INI and TGT QPs as pairs, so that bidirectional traffic was possible.  (For example, the rdma_cm could respond to a CM REQ with a CM REP and a CM REQ for the return path.)

I'm not saying this wouldn't end up in an implementation mess.  The easiest thing to do is just perform a unidirectional connect and leave the SRQs up to the user.  XRC just seems hideous to use from an application programmer viewpoint, but it seems worth exploring if an app could make use of it without significant changes from what they would do for RC QPs.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
