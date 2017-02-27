From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ibv_rc_pingpong, rping, and other tools hang with Linux 4.10.0
 and rdma-core 13
Date: Mon, 27 Feb 2017 09:29:16 -0700
Message-ID: <20170227162916.GC5891@obsidianresearch.com>
References: <CABQspYbv7j58pdLLbPegE8Bc3qhwb-3+4E8SQ2U9jObkeTbrzw@mail.gmail.com>
 <4e077022-5e5f-6ba8-530c-b86d2f09313e@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4e077022-5e5f-6ba8-530c-b86d2f09313e-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: GAFBlizzard <gtschemer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Youngjae Lee <dhrkaeh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Beavers <josh.beavers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 26, 2017 at 06:09:34PM +0200, Yonatan Cohen wrote:

> I bisected the rdma-core library and figured out that the following commit
> introduced this regression:
> 6b26a9e24739 Use C11 atomics instead of wmb/rmb macros for CPU-only atomics
> 
> I haven't debugged this yet and would appreciate Jason's input.

Oops, I think I typo'd it here:

--- a/providers/rxe/rxe_queue.h
+++ b/providers/rxe/rxe_queue.h
@@ -37,15 +37,16 @@
 #ifndef H_RXE_PCQ
 #define H_RXE_PCQ
 
+#include <stdatomic.h>
+
 /* MUST MATCH kernel struct rxe_pqc in rxe_queue.h */
 struct rxe_queue {
        uint32_t                log2_elem_size;
        uint32_t                index_mask;
        uint32_t                pad_1[30];
-       volatile uint32_t       producer_index;
+       _Atomic(uint32_t)       producer_index;
        uint32_t                pad_2[31];
-       volatile uint32_t       consumer_index;
-       uint32_t                pad_3[31];
+       _Atomic(uint32_t)       consumer_index;


Ie deleted pad_3[31] by mistake!

My bad

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
