From: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: When IBoE will be merged to upstream?
Date: Sun, 4 Jul 2010 20:03:28 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443A8E048000@MTLMAIL.mtl.com>
References: <AANLkTikXzoaRl61ivsc7fm8EdO9Ucz4iGGfclFOQl3kK@mail.gmail.com>
	<adabpb1s58c.fsf@roland-alpha.cisco.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439A78AFE88@MTLMAIL.mtl.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF259E7DE3D0@orsmsx501.amr.corp.intel.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439A78AFF16@MTLMAIL.mtl.com>
	<20100624203701.GA4630@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439A78B0042@MTLMAIL.mtl.com>
	<20100625155755.GC4630@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439BA54B70E@MTLMAIL.mtl.com>
	<adak4pcnw3c.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adak4pcnw3c.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

S.B.
--Liran

-----Original Message-----
From: Roland Dreier [mailto:rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org] 
Sent: Saturday, July 03, 2010 11:34 PM
To: Liran Liss
Cc: Jason Gunthorpe; Hefty, Sean; Aleksey Senin; linux-rdma; monis-smomgflXvOZWk0Htik3J/w@public.gmane.org; alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org; yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org; Tziporet Koren; alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org
Subject: Re: When IBoE will be merged to upstream?

 > Third, RoCE is not IB; its all about making RDMA user-friendly to Ethernet users.

This is utter nonsense.  RoCE (or IBoE as I prefer ;) is absolutely IB-over-Ethernet and it is all about making minimal changes to IB and IB applications to run on Ethernet.
LL: ??? IBoE has a completely different management plane (no SM, no SA), and we want this management plane to be "as Ethernet as possible" - this is what I mean by "not IB".
Otherwise, we are in full agreement: the changes to the IB transport should indeed be minimal.

 > Most importantly, we don't want to change the way Ethernet networks are managed.

That makes sense.  However let's be honest with ourselves -- the fraction of Ethernet networks using IPv6 as their only or even main address scheme is pretty small.  Of course having a migration path to work with IPv6 is important, but for the moment users want to use IPv4 addresses to specify destinations.

LL: I wasn't referring only to IPv6 networks; there are standard ways to represent IPv4 addresses in the IPv6 (and thus, iboe GID) namespace - IPv4 mapped addresses (::ffff<ipv4>).
Any mapped ipv4 address can be resolved according to ipv4.

 > - RoCE gids are L3 addresses, which are not (necessarily) of link-local
 >   scope; people will mostly use IP-mapped gids of global scope.
 > - These gids will map to an IP address, which then can resolve to an
 >   outgoing vlan device exactly as in Ethernet.

At that level it all makes sense, but the problem is the specifics of where, when and how the mapping is done.

 > We have a specification, we have an implementation, and we have clean  > way of passing RoCE L2 information to user-space via address handles.

We may have an implementation but we absolutely don't have a specification.  Or at least the IBA annex has nothing beyond this:

    A16.5.1 ADDRESS ASSIGNMENT AND RESOLUTION

    Layer 2 local addresses (i.e. SMAC, DMAC), and the methods by which
    those addresses are assigned, are outside the scope of this annex.

    The means for resolving a GID to a local port address (i.e. SMAC or
    DMAC) are outside the scope of this annex. It is assumed that
    standard Ethernet mechanisms, such as ARP or Neighbor Discovery are
    used to maintain an appropriate address cache for RoCE ports.

which was really pretty unfortunate, since it means the exact point we're talking about is completely unspecified.  Or is there some other spec you can point to?

(This also means it's pretty important that we get this right, since every future implementation is going to have a lot of pressure to follow what Linux does)

LL: the ibxoe working group has recommended using both IP-mapped and link-local addresses (http://www.t11.org/ftp/t11/pub/fc/study/09-543v0.pdf).
Other than that, there is no comprehensive spec so I am afraid you are right.
It seems natural to base iboe addressing on ipv6 practices:
- map ipv6 addresses in a straight forward manner.
- map ipv4 addresses using ipv4-mapped addresses.

 > I don't see any substantial reason to change the basic approach.

I don't really even know what the basic approach is.  For example what's the plan for handling GIDs that aren't derived from a MAC address?  For a long time we've assumed that the create_ah verb can't sleep, so where are you going to do neighbor discovery?

LL: by basic approach, I mean: without modifying IB L2 fields in address handles, CQEs, or in MAD payloads.
Iboe doesn't need to do discovery on its own; it can inherit the IP addresses, macs and vlans of the eth interface it is associated with.
GIDs that aren't derived from MAC addresses are IP-mapped addresses, which can be resolved according to their associated IP addresses.
So, from an admin's perspective, iboe address resolution matches whatever was configured for the eth interfaces; no new scheme.

Regarding the implementation, there is no inherent issue that prevents create_ah() from sleeping:
- Change a few spinlocks to mutexes in the cma (which sleeps a lot anyway because is modifies QP states)
- Trivial for user-space calls...



 - R.
--
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
