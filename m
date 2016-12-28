From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/3] srp/srpt - some useful patches
Date: Wed, 28 Dec 2016 13:00:10 +0200
Message-ID: <1482922813-8392-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bvanassche-HInyCGIudOg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No bug fixes, but few improvements that might help.

Max Gurtovoy (3):
  IB/srp: allocate ib_qp_attr on the stack
  IB/srpt: allocate ib_qp_attr on the stack
  IB/srpt: fix compilation warning

 drivers/infiniband/ulp/srp/ib_srp.c   |   51 ++++++++++++--------------------
 drivers/infiniband/ulp/srpt/ib_srpt.c |   20 +++++--------
 2 files changed, 27 insertions(+), 44 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
