From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb
 routines
Date: Tue, 3 Jan 2012 16:40:55 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823732566A072@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237302123C@ORSMSX101.amr.corp.intel.com>
 <201108011508.06521.jackm@dev.mellanox.co.il>
 <20110802053824.GA23512@obsidianresearch.com>
 <201108021053.05311.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373136F935C@ORSMSX101.amr.corp.intel.com>
 <4EFC8A85.4020803@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237325662BCE@ORSMSX102.amr.corp.intel.com>
 <4F03280A.80305@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F03280A.80305-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I'd like to better understand the "allocated by the caller ... are more
> difficult to deal with" part of your response -  for ibv_send_wr - if
> the caller have set a new IBV_WR_NEW_FEATURE value for the wr type, they
> surely aware to the new fields and actually the size of the structure
> can change as of structs allocated by the library. As for ibv_wc, yep,
> looks like we can't change the size unless we want to write a copatility
> layer that also comes into play in fast path calls, specifically
> ibv_poll_cq and translates from the new ibv_wc to the old ibv_wc structure.

You're right.  I was thinking more of ibv_wc, which has issues, since it may be used as an array.  ibv_send_wr is probably okay, since we walk a list using pointers.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
