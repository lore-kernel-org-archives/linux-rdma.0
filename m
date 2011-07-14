From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC v2] [OFED] libibverbs: Support both OFED verbs and ibverbs
Date: Thu, 14 Jul 2011 15:33:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237302E0B6@ORSMSX101.amr.corp.intel.com>
References: <FD32F2C0-80E1-4F66-9613-0BB7A604BB12@cisco.com>
 <Pine.GSO.4.40.1107140929480.314-100000@xi.cse.ohio-state.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.GSO.4.40.1107140929480.314-100000-KjjseYmyXVzgWg7noJOsSdXUKCiYXWp1@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dhabaleswar Panda <panda-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Both MVAPICH1 and MVAPICH2 have XRC support for many years and are being
> used by many large-scale production clusters.

To clarify my comment:

> > >> --with-rdma=gen2 CFLAGS='-DOFED_VERBS -D_ENABLE_XRC_
> > >>
> > >> It didn't appear that mvapichs ever used XRC

I only meant that mvapich2 didn't invoke any XRC calls in my testing.  The portion of my patch which converted the ofed xrc calls to the new format weren't being tested, so this was a statement about my testing, not mvapich.
 
> The runtime flag is VIADEV_USE_XRC
> 
> Class: Run Time
> Applicable device(s): Gen2
> When MVAPICH is compiled with the XRC CFLAGS, this parameter enables use
> of the XRC transport of InfiniBand available on certain adapters. Enabling
> XRC automatically enables Shared Receive Queue and on-demand connection
> management.
> 
> The hybrid (UD-RC/XRC) interface automatically selects the appropriate
> interface at run time.
> 
> Not sure which interface (gen2 or hybrid you are using). If you are using
> the gen2 interface, looks like you are not using the correct runtime flag
> to enable XRC with MVAPICH1.

FYI - I was running in loopback on the same system.  I'll try using the run time flag mentioned above if xrc can be used in that configuration (with shared memory disabled).  Thanks.
 
- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
