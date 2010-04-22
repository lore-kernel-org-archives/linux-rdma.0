From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/nes: make nesadapter->phy_lock usage consistent
Date: Thu, 22 Apr 2010 06:50:32 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E9047C8CF43D@azsmsx506.amr.corp.intel.com>
References: <20100309215040.GA5912@ctung-MOBL>
	<adak4s0o1ny.fsf@roland-alpha.cisco.com>
 <adafx2oo1gc.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adafx2oo1gc.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>By the way, any problem with me merging the following trivial patch for
>2.6.35?

Please do.  Thank you.

Chien

>RDMA/nes: Make unnecessarily global functions static
>
>This allows the compiler to do a bit better; on my x86-64 build:
>
>add/remove: 0/2 grow/shrink: 1/0 up/down: 2288/-2365 (-77)
>function                                     old     new   delta
>nes_init_phy                                 273    2561   +2288
>nes_init_1g_phy                              469       -    -469
>nes_init_2025_phy                           1896       -   -1896
>
>Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
