From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH REPOST for-next 0/5] iser initiator updates
Date: Tue,  1 Apr 2014 16:28:37 +0300
Message-ID: <1396358922-20599-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

-- fixed some minor errors, missing cover-letter, removed some leftovers 
   that were sent by mistake, sorry for the spam!!

Hi Roland,

This series contains a fix from Roi to a nasty race, cleanup of purely 
redundant strcutre from Ariel, and updates of copyright and version.

This update was queued internally behind the large T10 patch set and hence 
arrives a bit late, still, taking into account it's relatively small volume, 
we'd like to get it in for 3.15. 

Or.

Ariel Nahum (1):
  IB/iser: Remove struct iscsi_iser_conn

Or Gerlitz (3):
  IB/iser: Print QP information once connection is established
  IB/iser: Update Mellanox copyright note
  IB/iser: Bump driver version to 1.3

Roi Dayan (1):
  IB/iser: Drain the tx cq once before looping on the rx cq

 drivers/infiniband/ulp/iser/iscsi_iser.c     |   47 +++++++++-------------
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   14 ++-----
 drivers/infiniband/ulp/iser/iser_initiator.c |   56 ++++++++++++--------------
 drivers/infiniband/ulp/iser/iser_memory.c    |   22 +++++-----
 drivers/infiniband/ulp/iser/iser_verbs.c     |   29 ++++++++-----
 5 files changed, 78 insertions(+), 90 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
