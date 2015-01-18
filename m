From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH FIXES for-3.19 0/2] iser initiator fixes for kernel 3.19
Date: Sun, 18 Jan 2015 16:51:05 +0200
Message-ID: <1421592667-4099-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This set consist of two fixes error flows (cleanup resources).

Ariel Nahum (1):
  IB/iser: Release the iscsi endpoint if ep_disconnect wasn't called

Sagi Grimberg (1):
  IB/iser: Fix memory regions possible leak

 drivers/infiniband/ulp/iser/iser_initiator.c |  4 ----
 drivers/infiniband/ulp/iser/iser_verbs.c     | 27 ++++++++++++++++-----------
 2 files changed, 16 insertions(+), 15 deletions(-)

-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
