From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/7] Bugs found by sparse
Date: Tue, 14 Mar 2017 10:21:07 -0600
Message-ID: <1489508474-16664-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Since Bart got sparse working I took a quick look at what is in the core
libaries, these cases look like bugs to me.

I have another series that adds lots of sparse annotations to send later..

https://github.com/linux-rdma/rdma-core/pull/97

Jason Gunthorpe (7):
  Drop debugging print in CMakeLists.txt
  Fix missing swaps when computing path bits
  Fix various missing swaps in debugging/logging macros
  Add missing statics
  acm: Fix incorrect TID masking
  cmpost: Add missing swap for sin_port
  acm: Fix missing swap in pkey compare

 CMakeLists.txt                      |  1 -
 ibacm/prov/acmp/src/acmp.c          | 19 ++++++++++---------
 ibacm/src/acm.c                     |  8 ++++----
 libibcm/examples/cmpost.c           |  2 +-
 libibverbs/examples/xsrq_pingpong.c |  2 +-
 librdmacm/rsocket.c                 |  2 +-
 providers/qedr/qelr_verbs.c         |  4 ++--
 7 files changed, 19 insertions(+), 19 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
