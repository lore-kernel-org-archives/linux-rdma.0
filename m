From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: IWARP Valgrind Issue
Date: Mon, 26 Jun 2017 15:45:44 -0500
Message-ID: <006801d2eebd$2e54ba60$8afe2f20$@opengridcomputing.com>
References: <CY4PR19MB12215AF6E7225113294CF8DB8BDF0@CY4PR19MB1221.namprd19.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR19MB12215AF6E7225113294CF8DB8BDF0-48YGSBrqCmz95OYN2XvIqNvXXbHMiUzJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Dan Coombs' <dcoombs-LmJBtNfl/RVO0n7uQEQMm4CZgX+1HZI1@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 'Michael Chen' <mchen-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Dan:

> 
> Hello,
> 
> I'm getting a valgrind error when using the cxgb4/iw_cxgb4 drivers for a
Chelsio
> IWARP card.
> 
> System info:
> Distribution: Ubuntu 16.04.2 LTS
> Kernel: 4.4.0-79-generic
> Hardware: Chelsio T420-BT
> Drivers:
> Chelsio T4/T5/T6 Offload Network Driver - version 3.2.0.0
> Chelsio T420-BT rev 2
> iw_cxgb4:Chelsio T4/T5/T6 RDMA Driver - version 3.2.0.0
> 

This is Chelsio's Unified Wire package, yes?

> 
> Bug:
> 
> Running with sudo valgrind --leak-check=full --undef-value-errors=no
> 
> 12,720 bytes in 1 blocks are definitely lost in loss record 146 of 150
> 
> 
> Call stack:
> 
> ibv_create_cq (verbs.c:328)
> c4iw_create_cq (verbs.c:245)
> calloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
> 
> Code simply opens the device, creates a completion channel and a completion
> queue with ibv_create_*, then destroys the completion queue and completion
> channel with ibv_destroy_*.
> 

That looks like a bug in Chelsio's Unified Wire libcxgb4 core (ie not in the
upstream rdma-core libcxgb4 code).  I See the leak.  Something like this should
probably fix it.

diff -r fbf715bf1eb7 linux_libs/libcxgb4/src/verbs.c
--- a/linux_libs/libcxgb4/src/verbs.c   Fri Jun 23 13:44:07 2017 -0700
+++ b/linux_libs/libcxgb4/src/verbs.c   Mon Jun 26 13:43:52 2017 -0700
@@ -304,6 +304,7 @@ int c4iw_destroy_cq(struct ibv_cq *ibcq)
        dev->cqid2ptr[chp->cq.cqid] = NULL;
        pthread_spin_unlock(&dev->lock);

+       free(chp->cq.swiq_queue);
        free(chp->cq.sw_queue);
        free(chp);
        return 0;


Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
