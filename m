From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: When IBoE will be merged to upstream?
Date: Sat, 03 Jul 2010 13:34:15 -0700
Message-ID: <adak4pcnw3c.fsf@roland-alpha.cisco.com>
References: <AANLkTikXzoaRl61ivsc7fm8EdO9Ucz4iGGfclFOQl3kK@mail.gmail.com>
	<adabpb1s58c.fsf@roland-alpha.cisco.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439A78AFE88@MTLMAIL.mtl.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF259E7DE3D0@orsmsx501.amr.corp.intel.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439A78AFF16@MTLMAIL.mtl.com>
	<20100624203701.GA4630@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439A78B0042@MTLMAIL.mtl.com>
	<20100625155755.GC4630@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439BA54B70E@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB4439BA54B70E-WQlSmcKwN8Te+A/uUDamNg@public.gmane.org>
	(Liran Liss's message of "Thu, 1 Jul 2010 14:50:55 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis@voltaire.com" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys@voltaire.com" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs@voltaire.com" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr@voltaire.com" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Third, RoCE is not IB; its all about making RDMA user-friendly to Ethernet users.

This is utter nonsense.  RoCE (or IBoE as I prefer ;) is absolutely
IB-over-Ethernet and it is all about making minimal changes to IB and IB
applications to run on Ethernet.

 > Most importantly, we don't want to change the way Ethernet networks are managed.

That makes sense.  However let's be honest with ourselves -- the
fraction of Ethernet networks using IPv6 as their only or even main
address scheme is pretty small.  Of course having a migration path to
work with IPv6 is important, but for the moment users want to use IPv4
addresses to specify destinations.

 > - RoCE gids are L3 addresses, which are not (necessarily) of link-local
 >   scope; people will mostly use IP-mapped gids of global scope.
 > - These gids will map to an IP address, which then can resolve to an
 >   outgoing vlan device exactly as in Ethernet.

At that level it all makes sense, but the problem is the specifics of
where, when and how the mapping is done.

 > We have a specification, we have an implementation, and we have clean
 > way of passing RoCE L2 information to user-space via address handles.

We may have an implementation but we absolutely don't have a
specification.  Or at least the IBA annex has nothing beyond this:

    A16.5.1 ADDRESS ASSIGNMENT AND RESOLUTION

    Layer 2 local addresses (i.e. SMAC, DMAC), and the methods by which
    those addresses are assigned, are outside the scope of this annex.

    The means for resolving a GID to a local port address (i.e. SMAC or
    DMAC) are outside the scope of this annex. It is assumed that
    standard Ethernet mechanisms, such as ARP or Neighbor Discovery are
    used to maintain an appropriate address cache for RoCE ports.

which was really pretty unfortunate, since it means the exact point
we're talking about is completely unspecified.  Or is there some other
spec you can point to?

(This also means it's pretty important that we get this right, since
every future implementation is going to have a lot of pressure to follow
what Linux does)

 > I don't see any substantial reason to change the basic approach.

I don't really even know what the basic approach is.  For example what's
the plan for handling GIDs that aren't derived from a MAC address?  For
a long time we've assumed that the create_ah verb can't sleep, so where
are you going to do neighbor discovery?

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
