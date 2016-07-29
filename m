From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH 0/5] Some fabrics fixes
Date: Fri, 29 Jul 2016 22:57:17 +0300
Message-ID: <1469822242-3477-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A set of fixes to the nvme-rdma host driver. First two patches relate
to bug reports from Steve Wise on dervice removal handling (and go
together with Steve's iwcm patch set).

Third patch fixes the host behavior that it never shutdown the
controller (wrong check on the controller state).

Last two patches remove redundant calls to nvme_remove_namespaces
which is called from nvme_uninit_ctrl.

Sagi Grimberg (5):
  nvme-rdma: Fix device removal handling
  nvme-rdma: Free the I/O tags when we delete the controller
  nvme-rdma: Make sure to shutdown the controller if we can
  nvme-rdma: Remove duplicate call to nvme_remove_namespaces
  nvme-loop: Remove duplicate call to nvme_remove_namespaces

 drivers/nvme/host/rdma.c   | 62 ++++++++++++++++++++++++----------------------
 drivers/nvme/target/loop.c |  4 +--
 2 files changed, 34 insertions(+), 32 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
