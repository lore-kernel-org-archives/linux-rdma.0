From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [for-next 0/4] RDMA/libocrdma: bug fixes for libocrdma
Date: Tue, 1 Jul 2014 11:24:01 +0530
Message-ID: <209cac60-a0d3-40ce-b81a-5236c8d1e4e1@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This Series includes ocrdma library bug fixes to be added in upstream library.

Devesh Sharma (3):
  RDMA/libocrdma: dont skip setting deffer_arm
  RDMA/libocrdma: do not allow RDMA on UD QP
  RDMA/libocrdma: update version string

Selvin Xavier (1):
  RDMA/libocrdma: stop polling when SQ/RQ is empty

 configure.in       |    4 ++--
 src/ocrdma_verbs.c |   21 ++++++++++++++++++---
 2 files changed, 20 insertions(+), 5 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
