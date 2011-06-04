From: Greg Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Subject: librdma_cm and PSNs
Date: Sat, 4 Jun 2011 17:37:16 -0400
Message-ID: <201106041737.16482.kerr.g@husky.neu.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I am attempting to probe information about how librdma_cm interacts with 
libibverbs by using a "wrapper" library that I wrote. It is LD_PRELOAD-ed 
before libibverbs, which allows me to examine the function calls librdma is 
making before then passing control to the "real" verbs function call.

While doing this I have noticed that in a simple RDMA application, librdma 
does not seem to configure the PSNs between the two nodes to match each other; 
not through calls to ibv_modify_qp anyhow. The arguments given to 
ibv_modify_qp by librdma_cm seem to be (for example):

Node 1:
RQ_PSN is 464684127
SQ_PSN is 2204625

Node 2:
RQ_PSN is 1327604689
SQ_PSN is 11699295

If I use ibv_query_qp() to query the PSNs they will prove to match (SQ -> RQ 
on the opposite nodes), as they should. If not through ibv_modify_qp, how is 
librdma_cm configuring the PSNs?

Thanks in advance for any assistance,

Greg Kerr
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
