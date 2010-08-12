From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] rdma cm + XRC
Date: Wed, 11 Aug 2010 19:55:31 -0600
Message-ID: <20100812015531.GA22548@obsidianresearch.com>
References: <4C5331DC.9080109@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com> <4C618334.7010106@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C0C2@orsmsx501.amr.corp.intel.com> <20100810171405.GM11306@obsidianresearch.com> <4C61BF26.9060003@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601BE4@orsmsx501.amr.corp.intel.com> <20100811231017.GD10271@obsidianresearch.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601D3C@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9601D3C-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 11, 2010 at 05:04:00PM -0700, Hefty, Sean wrote:
> > Maybe 3 functions, since you already have create_ep:
> > create_id_ep - takes rdma_addrinfo, allocates PD/XRC, rdma_cm_id
> > create_qp_ep - takes rdma_addrinfo, allocates QP, CQ, etc
> > create_ep - just calls both the above. Very simplified
> > (not sure on the names)
> 
> This is similar to what I was thinking, except I would just use the
> existing create_qp.
> 
> I need to give adding PDs to rdma_addrinfo more thought.  It seems
> that if AF_IB were ever accepted, then device specific addressing
> could be used, rather than relying on mapped values.  As an
> alternative, we could define a function like:

Even so, the point of passing it into rdma_getaddrinfo is to restrict
the device rdma_getaddrinfo selects, it doesn't matter that you can get
back to the PD from the addrinfo if that PD doesn't have the resources
you need attached to it. Again, I'm thinking from the app perspective
where juggling multiple PDs isn't really done, and thus multiple
connections on different HCAs are not supported by the app. This model
should be supportable without introducing random failures when
rdma_getaddrinfo returns things that use other devices.

> struct ibv_context *rdma_get_device(rdma_addrinfo *res);
> 
> Internally, this would just end up doing a lot of the same work that
> create_id_ep mentioned above would do.

Indeed - so why bother? create_id_ep gets you the ID, bound to a
device with a verbs handle. Follow-up calls can use the convetion that
0 for the PD means 'use the global default PD' otherwise an app can
allocate a new PD, or find an existing one using the verbs handle
provided.

> > It looks to me like the main use model for this is peer-peer, so each
> > side would establish their send half independently and message routing
> > would be app specific. This means the CM initiator side should be the
> > side that has the INI QP and the CM target side should be the side
> > with TGT - ?
 
> This is why I questioned what the desired behavior should be (from
> an API perspective).  If the main usage model is peer-peer, then the
> librdmacm _could_ allocate and connect XRC INI and TGT QPs as pairs,
> so that bidirectional traffic was possible.  (For example, the
> rdma_cm could respond to a CM REQ with a CM REP and a CM REQ for the
> return path.)

If the model is peer-peer having half duplex connections is ideal -
peer-peer would mean that either side could start setting things up at
any time, dealing with the inherent races is a huge messy
problem. Having each side control when its half of the connection
starts up cleans things up tremendously.

> I'm not saying this wouldn't end up in an implementation mess.  The
> easiest thing to do is just perform a unidirectional connect and
> leave the SRQs up to the user.  XRC just seems hideous to use from
> an application programmer viewpoint, but it seems worth exploring if
> an app could make use of it without significant changes from what
> they would do for RC QPs.

Well.. I admit I can't think of many uses for XRC - but I can think of
two reasonable approached for non peer-peer apps:
 - Create a RC QP and build the XRC QPs by exchanging messages within
   the RC QP - avoid the CM protocol entirely. XRC would then be a
   secondary channel to the RC channel, probably for buffer size sorting
   purposes
 - Create the TGT QP on the initiator side and pass its info in the
   private message and do a double QP setup. More complex - does
   rdmacm provide hooks to do this?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
