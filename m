From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/6] Sparse code changes
Date: Wed, 15 Mar 2017 16:12:01 -0600
Message-ID: <1489615927-12117-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is the rest of the code change stuff from the core libraries that sparse
did not like.

There is one bug fix in here, the missing swap on INADDR_LOOPBACK.

Otherwise it is just small changes to make sparse happier.

The full series is here:

https://github.com/linux-rdma/rdma-core/pull/100

Which is enough hackery to make sparse run automatically from travis without
triggering any sparse warnings, at least over the core libraries.

I think interested parties should look at the entire series on github. It is
so large it probably won't fit on the list.

Bart and I were having an interesting discussion on github on this
approach. It isn't clear to me if a different version of the 'sparse-include'
setup could be designed.. But if someone else can figure out how to get the
same result more robustly that would be great.

For now this actually works, and can run inside travis, which is much better
than where we were..

Someone else(s) will have to sparse cleanup the providers and ibacm, they
scare me.

Jason Gunthorpe (6):
  Use NULL instead of 0 to silence sparse
  INADDR_* needs to be byteswapped before being used
  rstream: Use waitpid instead of wait
  rdmacm: Use C11 stdatomic for all atomics
  rsocket: Fix byte swapping when constructing path records
  verbs: Consistently apply __attribute_const

 iwpmd/iwarp_pm_common.c             |  2 +-
 iwpmd/iwarp_pm_helper.c             |  2 +-
 libibverbs/examples/rc_pingpong.c   |  2 +-
 libibverbs/examples/srq_pingpong.c  |  2 +-
 libibverbs/examples/uc_pingpong.c   |  2 +-
 libibverbs/examples/ud_pingpong.c   |  2 +-
 libibverbs/examples/xsrq_pingpong.c |  2 +-
 libibverbs/verbs.c                  |  8 +++---
 libibverbs/verbs.h                  |  8 +++---
 librdmacm/cma.h                     | 49 ++++---------------------------------
 librdmacm/examples/cmatose.c        |  4 +--
 librdmacm/examples/mckey.c          |  2 +-
 librdmacm/examples/rcopy.c          |  2 +-
 librdmacm/examples/riostream.c      |  2 +-
 librdmacm/examples/rstream.c        |  6 ++---
 librdmacm/examples/udaddy.c         |  2 +-
 librdmacm/preload.c                 | 14 +++++------
 librdmacm/rsocket.c                 | 17 ++++++-------
 rdma-ndd/rdma-ndd.c                 |  6 ++---
 19 files changed, 46 insertions(+), 88 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
