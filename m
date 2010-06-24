From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: When IBoE will be merged to upstream?
Date: Thu, 24 Jun 2010 14:37:01 -0600
Message-ID: <20100624203701.GA4630@obsidianresearch.com>
References: <AANLkTikXzoaRl61ivsc7fm8EdO9Ucz4iGGfclFOQl3kK@mail.gmail.com> <adabpb1s58c.fsf@roland-alpha.cisco.com> <E113D394D7C5DB4F8FF691FA7EE9DB4439A78AFE88@MTLMAIL.mtl.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF259E7DE3D0@orsmsx501.amr.corp.intel.com> <E113D394D7C5DB4F8FF691FA7EE9DB4439A78AFF16@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB4439A78AFF16-WQlSmcKwN8Te+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The current behavior of ibv_create_ah() requires that the caller
> provide the L2, and if needed, L3 addressing.  Any translation
> between the L3 and L2 addressing must be done before the call is
> made.  E.g. ibv_create_ah does not use the GID to query the SA to
> obtain LIDs.  Why doesn't IBoE follow this same model?
> 
> LL: because of the RoCE spec, which states that only GID addressing
> is used at the Verbs level. The address handle fields are unchanged,
> and the L2 fields (e.g., lid) are reserved.  Note that in Ethernet,
> you normally don't specify L2 addresses at the transport level
> (i.e., sockets).

We do not have to lavishly follow the IBTA spec in the Linux
implementation, especially if it makes no sense.

I think Sean is on the right track here, the AH should take the L2 as
input just like for IB, and the resolution is done in librdmacm, or
somehow manually.

The verbs layer is not really analogous to sockets anyhow, the
librdmacm is much closer to a socket like interface, and it having
a GID go into rdmacm and a full AH with L2/L3 info come out seems
entirely reasonable.

BTW, what ever was decided about vlans tagging? Is that part of the AH
or do you use seperate RDMA devices per vlan? Seems like a point worth
considering now.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
