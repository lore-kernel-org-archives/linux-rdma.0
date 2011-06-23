From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] [OFED] libibverbs: Translate OFED verbs to ibverbs
Date: Thu, 23 Jun 2011 17:31:16 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373029EEF@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373029C29@ORSMSX101.amr.corp.intel.com>
 <20110623064502.GA8258@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110623064502.GA8258-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Once you create a new linkable symbol you may as well un-inline the
> bulk of this emulation..

yep

> You could go like:
> 
> verbs.h:
> 
> #define ibv_send_wr _real_ibv_send_wr
> // rest of verbs.h
> 
> #undef ibv_send_wr
> 
> #include "ofed-verbs.h"
> 
> ofed-verbs.h:
> 
> struct ibv_send_wr
> {
>  // ofa version
> }
> 
> Then you don't need the #define to get to the correct version.

Thanks - I'll give this a try.

- Sean 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
