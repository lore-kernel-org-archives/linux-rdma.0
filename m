From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH for-3.11 0/3] rdma/cm: Fixes for AF_IB patch series
Date: Wed, 24 Jul 2013 15:06:06 -0700
Message-ID: <1374703569-16668-1-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Additional testing of the latest AF_IB patch series showed that bugs
were introduced when mixing AF_IB with UD QPs.  Full support for
AF_IB with UD QPs is limited, but we should at least avoid crashing
the kernel!  Please apply two fixes for crashes to 3.11, plus one
minor fix to silence a compiler warning.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Paul Bolle (1):
  [v2] RDMA/cma: silence GCC warning

Sean Hefty (2):
  rdma/cm: Fix accessing invalid private data for UD
  rdma/cm: Only call cma_save_ib_info for CM REQs

 drivers/infiniband/core/cma.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
