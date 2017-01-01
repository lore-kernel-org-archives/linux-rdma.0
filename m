From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/2 v2] srp/srpt - some useful patches
Date: Sun,  1 Jan 2017 16:17:10 +0200
Message-ID: <1483280232-13826-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bvanassche-HInyCGIudOg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No bug fixes, but few improvements that might help.

changes from v1:
 - update commit messages
 - initialize struct ib_qp_attr to zero in the beginning of function

Max Gurtovoy (2):
  IB/srp: allocate ib_qp_attr on the stack
  IB/srpt: allocate ib_qp_attr on the stack

 drivers/infiniband/ulp/srp/ib_srp.c   |   51 ++++++++++++--------------------
 drivers/infiniband/ulp/srpt/ib_srpt.c |   17 ++++-------
 2 files changed, 25 insertions(+), 43 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
