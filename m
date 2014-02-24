From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 0/3] SRP initiator fixes for kernel 3.15
Date: Mon, 24 Feb 2014 16:30:15 +0200
Message-ID: <1393252218-30638-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bvanassche-HInyCGIudOg@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Bart,

Here are three more fixes for kernel 3.15. These are the patches
Sebastian was referring to.

Changes from v0:
- Fix typos in commit message

Sagi Grimberg (2):
  IB/srp: Fix crash when unmapping data loop
  IB/srp: Check ib_query_gid return value

Vu Pham (1):
  IB/srp: Protect free_tx iu list from concurrent flows

 drivers/infiniband/ulp/srp/ib_srp.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
