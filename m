From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: When IBoE will be merged to upstream?
Date: Thu, 1 Jul 2010 17:20:05 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A1002175@orsmsx501.amr.corp.intel.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB4439BA54B70E-WQlSmcKwN8Te+A/uUDamNg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> There are also good reasons why the RoCE standard left the syntax of
> address handles.
> First, it keeps the Verbs unchanged. Even if you are using rdmacm to make
> connections, you still have to inspect address handles when "connecting" to
> UD QPs or joining multicast addresses.

Verbs isn't an API, and the verbs usage changed anyway - the L2 is no longer provided by the user.  The spec is wrong to make the L3 to L2 mapping device specific, if that was the intent.  ARP or neighbor discovery should not be hidden under create AH or modify QP.

> Second, making Ethernet L2 fields explicit has implications beyond the
> address handle and CQE formats. Specifically, a lot of the IBTA defined
> MADs must be modified as well.

Specifically, which MADs and why?

> The most evident example is the CM protocol, which has L2 fields in its
> payloads.

How does moving the L3 to L2 mapping from outside create AH result in the CM protocol needing to change?  Why is hiding this under modify QP desirable?

> Third, RoCE is not IB; its all about making RDMA user-friendly to Ethernet
> users.

Then why is it part of the IBTA?

> Most importantly, we don't want to change the way Ethernet networks are
> managed.
> This means that admins configure their normal network interfaces, define
> VLAN sub-interfaces, assign IP addresses (or use DHCP), and then work with
> RoCE using IP-mapped addresses, which reference the same IP addresses they
> use for their Ethernet interfaces.
> So, regarding our VLAN discussion:
> - RoCE gids are L3 addresses, which are not (necessarily) of link-local
> scope; people will mostly use IP-mapped gids of global scope.
> - These gids will map to an IP address, which then can resolve to an
> outgoing vlan device exactly as in Ethernet.
> 
> We have a specification, we have an implementation, and we have clean way
> of passing RoCE L2 information to user-space via address handles.
> I don't see any substantial reason to change the basic approach.

All feedback on this has been discarded since the initial patches were submitted, and I still don't see a substantial reason why L3 to L2 mappings are device specific, or why significant network protocols should be hidden under verbs calls.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
