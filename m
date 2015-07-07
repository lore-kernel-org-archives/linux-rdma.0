From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/2] lockdep warning fixes
Date: Tue,  7 Jul 2015 17:45:11 +0300
Message-ID: <1436280313-21451-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

These two patches fix a couple of lockdep warnings I ran into, in IPoIB and
RDMA CM.

Regards,
Haggai

Haggai Eran (2):
  IB/ucma: Fix lockdep warning in ucma_lock_files
  IB/ipoib: Prevent lockdep warning in __ipoib_ib_dev_flush

 drivers/infiniband/core/ucma.c          |  4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 13 +++++++------
 2 files changed, 9 insertions(+), 8 deletions(-)

-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
