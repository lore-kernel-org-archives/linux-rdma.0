From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 00/10] Introduce Signature feature
Date: Thu, 14 Nov 2013 19:03:38 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D0463F@ORSMSX109.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237388D031C4@ORSMSX109.amr.corp.intel.com>
 <52847BF8.60401@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52847BF8.60401-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Nicholas Bellinger <nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>"martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> To begin with T10 DIF **is** industry standard, which is to be used in
> production storage systems, the feature here is T10 DIF acceleration for
> upstream kernel storage drivers such as iSER/SRP/FCoE initiator/targets
> that use RDMA and are included in commercial distributions which are
> used by customers. Note that this/similar feature is supported by some
> FC cards too, so we want RDMA to be competitive.

I wasn't talking about whether T10 DIF is a standard.  I was talking about *how* it is exposed through verbs.  That 'how' is what's vendor specific.  The same is true of flow steering, SRQ is standard but IB specific, the same with XRC - which was vendor specific first then standardized, the IP CSUM send flag is vendor specific, 'fast' registration is vendor specific...

I'm not suggesting that these features shouldn't exist, I'm just questioning if the goal of verbs should simply be to expose every hardware knob that a ULP can fiddle.  Maybe the answer is yes, but let's at least ask the question.

As a random, made up on the spot thought, what if IPoIB were architected so that there was a device specific component to it, instead of it pretending that some vendor feature exposed through verbs was a generic RDMA capability?  IPoIB acceleration features could still be used.

> This work is part of larger efforts which are done nowadays in other
> parts of the kernel such as the block layer, the upstream kernel target
> and more to support T10, its "just" the RDMA part.

How does the RDMA part tie into any of the other work being done in other parts of the kernel?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
