From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/3] Change per-entry locks in GID cache to table lock
Date: Wed, 28 Oct 2015 16:52:38 +0200
Message-ID: <1446043961-17667-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

During the RoCE GID cache changes, we used a per-entry rwlock. This could cause
a major overhead when traversing the GID table. We could spend thousands of
cycles just by locking and unlocking entries. This change was requested by
Doug.

In order to solve that, we moved to one table lock. find_gid is also optimized
to find an empty slot while traversing the GID table (when needed).

Regards,
Matan

Matan Barak (3):
  IB/core: Refactor GID cache's ib_dispatch_event
  IB/core: Change per-entry lock in RoCE GID table to one lock
  IB/core: Find gid searches for empty slot while traversing the GID
    table

 drivers/infiniband/core/cache.c | 209 ++++++++++++++++++++++++++--------------
 1 file changed, 134 insertions(+), 75 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
