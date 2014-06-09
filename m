From: Devesh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sharma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: [PATCH for-next 0/2] Bug fixes for nfs-rdma support
Date: Mon, 9 Jun 2014 10:52:36 +0530
Message-ID: <530c3deb-5384-41ae-83f7-affbdd1fef9a@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

This series fixes the improper frmr-page-list-len size reported
by query_device and a bug in CQ arming logic.

Devesh Sharma (2):
  RDMA/ocrdma: Report actual value of max_fast_reg_page_list_len
  RDMA/ocrdma: do not skip setting deffered_arm

 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
