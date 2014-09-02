From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.17 0/3] iser initiator fixes and version bump
Date: Tue,  2 Sep 2014 15:57:07 +0300
Message-ID: <1409662630-28269-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This series contains two point fixes and version bump to the iSER initiator,
please apply to 3.17

Or.


Or Gerlitz (1):
  IB/iser: Bump version to 1.4.1

Roi Dayan (1):
  IB/iser: Fix RX/TX CQ resource leak on error flow

Sagi Grimberg (1):
  IB/iser: Allow bind only when connection state is UP

 drivers/infiniband/ulp/iser/iscsi_iser.c |   19 ++++++++++++++-----
 drivers/infiniband/ulp/iser/iscsi_iser.h |    2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c |   24 ++++++++++++++----------
 3 files changed, 29 insertions(+), 16 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
