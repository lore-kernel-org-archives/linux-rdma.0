From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] libocrdma bug fixes
Date: Wed, 14 Jan 2015 12:23:50 +0530
Message-ID: <1df19a18-809c-474e-8ecd-a703fbc42ee4@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series has a major bug fix related to
retuning the correct error codes whenever any
immediate error is encounterd.

Devesh Sharma (1):
  RDMA/libocrdma: update libocrdma version string

Padmanabh Ratnakar (1):
  RDMA/libocrdma: return positive error codes

 configure.in       |    4 ++--
 src/ocrdma_verbs.c |   32 ++++++++++++++++----------------
 2 files changed, 18 insertions(+), 18 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
