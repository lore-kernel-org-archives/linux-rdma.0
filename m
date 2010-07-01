From: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: When IBoE will be merged to upstream?
Date: Thu, 1 Jul 2010 14:50:55 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB4439BA54B70E@MTLMAIL.mtl.com>
References: <AANLkTikXzoaRl61ivsc7fm8EdO9Ucz4iGGfclFOQl3kK@mail.gmail.com>
	<adabpb1s58c.fsf@roland-alpha.cisco.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439A78AFE88@MTLMAIL.mtl.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF259E7DE3D0@orsmsx501.amr.corp.intel.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439A78AFF16@MTLMAIL.mtl.com>
	<20100624203701.GA4630@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439A78B0042@MTLMAIL.mtl.com>
	<20100625155755.GC4630@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100625155755.GC4630-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason,

There are also good reasons why the RoCE standard left the syntax of address handles.
First, it keeps the Verbs unchanged. Even if you are using rdmacm to make connections, you still have to inspect address handles when "connecting" to UD QPs or joining multicast addresses.
In addition, each incoming packet generates a CQE, whose L2 fields also need to be inspected.

Second, making Ethernet L2 fields explicit has implications beyond the address handle and CQE formats. Specifically, a lot of the IBTA defined MADs must be modified as well.
The most evident example is the CM protocol, which has L2 fields in its payloads.

Third, RoCE is not IB; its all about making RDMA user-friendly to Ethernet users.
Most importantly, we don't want to change the way Ethernet networks are managed.
This means that admins configure their normal network interfaces, define VLAN sub-interfaces, assign IP addresses (or use DHCP), and then work with RoCE using IP-mapped addresses, which reference the same IP addresses they use for their Ethernet interfaces.
So, regarding our VLAN discussion:
- RoCE gids are L3 addresses, which are not (necessarily) of link-local scope; people will mostly use IP-mapped gids of global scope.
- These gids will map to an IP address, which then can resolve to an outgoing vlan device exactly as in Ethernet.

We have a specification, we have an implementation, and we have clean way of passing RoCE L2 information to user-space via address handles.
I don't see any substantial reason to change the basic approach.

Regards,
--Liran


-----Original Message-----
From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org] 
Sent: Friday, June 25, 2010 6:58 PM
To: Liran Liss
Cc: Hefty, Sean; Roland Dreier; Aleksey Senin; linux-rdma; monis-smomgflXvOZWk0Htik3J/w@public.gmane.org; alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org; yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org; Tziporet Koren; alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org
Subject: Re: When IBoE will be merged to upstream?

On Fri, Jun 25, 2010 at 11:04:28AM +0300, Liran Liss wrote:

> VLANs are part of L2 in Ethernet -- when you resolve a destination
> L3 address to an L2 address, you get the outgoing interface, which 
> also determines the VLAN.  I think this approach has an advantage over 
> an RDMA device per VLAN in that you keep the standard OS VLAN 
> management (vconfig).

Except that in RoCE all L3 addresses are link local GIDs, which must be scoped to an interface and cannot be resolved by routing to a specific interface. vconfig creates child ethernet devices, I think you have no choice but to do the same for RDMA. The GID, when it is resolved, must be scoped to the RDMA device it is going to be bound to, which in turn must be bound to a VLAN.

(BTW, Sean, did AF_IB's sockaddr include a scoping field, and did you figure out some way to make that work?)

> I wouldn't judge the RoCE spec so quickly --- it guarantees that rdma 
> application binaries could run on any network.  What do you gain by 
> exposing Eth-specific L2 params in the address handle?

Well, 1) invariably that is how the hardware must work, and verbs is about exposing that interface to userspace 2) You don't suddenly make AH setup require network traffic, and potentitally large time delays 3) it keeps the whole RoCE architecture far more consistent with IB.

You can pose the same question for IB, why doesn't AH resolution resolve the GID? There are lots of good answers :)

Also bear in mind that APM is entirely possible over RoCE and doing that will require a finer touch for managing the data in the AH's.

What do you get by doing all this extra work? I say nothing at all. Users won't even be able to tell the difference as long as they use rdmacm to setup the connections.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
