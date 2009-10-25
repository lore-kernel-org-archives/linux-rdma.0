From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Sun, 25 Oct 2009 14:03:32 -0600
Message-ID: <20091025200332.GN26003@obsidianresearch.com>
References: <1256164230.12075.31.camel@wilder.ibm.com> <9D257695083141E79685CB2B260D7D7C@amr.corp.intel.com> <20091021233639.GS14520@obsidianresearch.com> <BFF5CD71FFA74BF09A2EED5F3319F370@amr.corp.intel.com> <20091022002846.GU14520@obsidianresearch.com> <4803112A5B7A4953B62ABAFD1BBD9881@amr.corp.intel.com> <20091022011939.GW14520@obsidianresearch.com> <60E9443821EE4FFA90448DF5CC1368A8@amr.corp.intel.com> <20091022062531.GB26003@obsidianresearch.com> <4AE43BED.3090405@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AE43BED.3090405-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 25, 2009 at 01:52:13PM +0200, Or Gerlitz wrote:

> Jason,  Have you even looked into or tested any of the bonding 
> load-balancing modes with ipoib? some/most of them are not applicable to 
> IPoIB and I don't think that the ones which may be such were ever 
> tested.

I was saying that point in the rdmacm where the rdma_cm_id is bound to
a local RDMA device should have only been rdma_resolve_addr and
rdma_accept.

Overloading rdma_bind_addr to both bind to an IP and bind to an RDMA
device was a bad API choice.

Sean is right, there may be special cases that require an early
binding, but a seperate API - like IP's SO_BINDTODEVICE - would has
been better - and users are forewarned that calling it restricts the
environments their app will support :(

As it stands we have several impossible situations. Sean, Dave, and I
were disucssing the trades offs of what this means relative to IP
route resolution - but it affects bonding too.

If you rdma_bind_addr to the IP of a bonding device, the stack must
pick one of the local RDMA ports immediately. If you then call
rdma_listen there is a problem: incoming connections may target either
RDMA device, but you are only bound to one of them.

An app cannot say 'I want to listen on this IP, any RDMA device'
with the current API, as you can in IP, and that is a shame.

> Next, multiple interfaces with the same ip address isn't
> something I see very useful for production environment (but I'd be happy 
> to get educated what L3 bonding is and where it can play), next,

Traditionally with ethernet the L2 bonding is really only used for
link aggregation, L1 failure, and a simple multi-switch HA scheme. It
is not deployed if you have multiple ethernet domains. Some people
prefer to have dual, independent ethernet fabrics, and in that case
you rely on routing features to get the multipath, and HA features of
bonding.

Go back on the list and look up the posts from Leo who first
discovered this, what he was trying to do is kinda the L3 bonding
approach.

> and more important, from comments made by Sean in the past, I don't 
> think it fits the rdma-cm spirit.

I think multi-port APM can be fit into the API we have, but yes, there
are some unfortunate design choices in verbs that make it a little
awkward.

> All in all, someone comes here and suggests some fixes to the rdma-cm 
> address resolution code to have IPv6 work. I don't think Dave should 
> carry on his back/patch all your proposed future enhancements.  Let him 
> fix things and following that you can work on the patches to support all 
> these nice/nitch features starting with IPv4 and then IPv6.

David has been doing a good job and I am glad he is working on the
IPv6 support. My comments are only intended to clarify how this is all
supposed to work and why the IP flow is actually still relevant
to RDMA connections.

This (now quite long) discussion about RDMA device binding I really
think has clarified what everyone expects from the API, and I've
certainly found Sean's comments about early device binding quite
interesting.

Unfortunately to make sin6_scope_id, and the loopback cases work
properly does kinda require confronting these issues. The IPv6 notion
of scope is new and it conflicts with the RDMA CM notion of 'scope'
created by the local RDMA device binding. This is very different from
how IP works. Reconciling the two ideas in a sane way is a big source
of trouble.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
