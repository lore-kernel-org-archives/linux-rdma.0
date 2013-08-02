From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH librdmacm 0/5] Add support and tests for AF_IB
Date: Fri,  2 Aug 2013 15:20:17 -0700
Message-ID: <1375482022-5953-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add support for AF_IB to rsockets and enhance the librdmacm samples
to verify AF_IB operation.

Include one fix for rsetsockopt to return 0 on success when setting
SOL_RDMA.

Sean Hefty (5):
  rsockets: Support native IB addressing on connected rsockets
  examples: Add support for native IB addressing to samples
  rsockets: Add ability to set the IB route directly
  rsocket: Return 0 on success for SOL_RDMA options
  rstream: Use rsocket option to set route directly

 examples/rstream.c     |   75 +++++++++++++++++++++++++++++++++++++++--------
 examples/udaddy.c      |   49 +++++++++++++++++++++---------
 include/rdma/rsocket.h |    3 +-
 src/acm.c              |   12 -------
 src/cma.h              |   12 +++++++
 src/rsocket.c          |   73 ++++++++++++++++++++++++++++++++++++++--------
 6 files changed, 170 insertions(+), 54 deletions(-)

-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
