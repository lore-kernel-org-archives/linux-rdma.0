From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] [OFED] libibverbs: Translate OFED verbs to ibverbs
Date: Thu, 23 Jun 2011 00:45:02 -0600
Message-ID: <20110623064502.GA8258@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373029C29@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373029C29-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 23, 2011 at 12:45:23AM +0000, Hefty, Sean wrote:

> The idea is that a single version of libibverbs would support
> both ibverbs and ofverbs via macro magic, with full compatibility with
> ibverbs.  An app would need to be compiled with CFLAGS=-DOFED_VERBS to
> pick up the ofverbs.
 
> This doesn't quite work seamlessly.  I downloaded mvapich2 and built it
> with the following options:
> 
> 
> This failed with
> .../reg_cache/avl.h:42: error: conflicting types for VISIT
> /usr/include/search.h:126: note: previous declaration of VISIT was here
 
> This can probably be worked around by moving the use of search.h into
> an ofed-verbs.c file and exporting ofv_open_xrcd().  (I tried to minimize
> the impact to the upstream libibverbs, hoping it would help make this
> more acceptable for merging.)

Once you create a new linkable symbol you may as well un-inline the
bulk of this emulation..

I don't think this has any place in upstream though, the number of
users of XRC seems too tiny to carry this forever.

> fails with
> ch3_progress.c: In function ?cm_send_pending_1sc_msg?:
> ch3_progress.c:877: error: ?struct ibv_send_wr? has no member
> named ?xrc_remote_srq_num?

You could go like:

verbs.h:

#define ibv_send_wr _real_ibv_send_wr
// rest of verbs.h

#undef ibv_send_wr

#include "ofed-verbs.h"

ofed-verbs.h:

struct ibv_send_wr
{
 // ofa version
}

Then you don't need the #define to get to the correct version.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
