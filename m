From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] librdmacm/mcraw: Add a new test application for
 user-space IBV_QPT_RAW_ETH QP type
Date: Wed, 16 Jun 2010 16:14:35 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801E87423E@irsmsx503.ger.corp.intel.com>
References: <BE2BFE91933D1B4089447C64486040801E7635F7@irsmsx503.ger.corp.intel.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF259E0EB554@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF259E0EB554-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No, no more changes are necessary. It is a standalone application.

Mirek

-----Original Message-----
From: Hefty, Sean 
Sent: Monday, June 14, 2010 6:33 PM
To: Walukiewicz, Miroslaw
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: [PATCH] librdmacm/mcraw: Add a new test application for user-space IBV_QPT_RAW_ETH QP type

> The patch adds a new test application describing a usage of the
> IBV_QPT_RAW_ETH
> for IPv4 multicast acceleration on iWARP cards.

Are any changes still needed to the kernel or libibverbs to make this work?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
