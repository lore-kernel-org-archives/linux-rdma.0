From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/4] libocrdma update series
Date: Thu, 25 Feb 2016 02:50:43 -0500
Message-ID: <1456386647-22315-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series includes couple of bug fixes and support for RoCE-v2
for user space applicaitons.

Patch 0001 adds support for RoCE-v2 to userland applications

Patch 0002 and 0003 are bug fixes to avoid build warnings

Patch 0004 updates the version string

Devesh Sharma (4):
  RDMA/libocrdma: Add user space support for RoCE-v2
  RDMA/libocrdma: Fix compile time warnings
  RDMA/libocrdma: Remove async-event hook from context ops
  RDMA/libocrdma: Update libocrdma version string

 configure.in       |  4 +--
 src/ocrdma_abi.h   |  2 +-
 src/ocrdma_main.c  |  1 -
 src/ocrdma_main.h  |  5 +++-
 src/ocrdma_verbs.c | 76 +++++++++++-------------------------------------------
 5 files changed, 22 insertions(+), 66 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
