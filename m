From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Tue,  3 Feb 2015 13:42:55 -0800
Message-ID: <1422999775-32111-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------
Last minute InfiniBand/RDMA changes for 3.19:
 - Revert IPoIB driver back to 3.18 state.  We had a number of fixes go
   into 3.19, but they introduced regressions.  We tried to get everything
   fixed up but ran out of time, so we'll try again for 3.20.
 - Similarly, turn off the new "extended query port" verb.  Late in the
   cycle we realized the ABI is not quite right, and rather than freeze
   something in a rush and make a mistake, we'll take a bit more time
   and get it right in 3.20.

----------------------------------------------------------------
Haggai Eran (1):
      IB/core: Temporarily disable ex_query_device uverb

Roland Dreier (9):
      Revert "IPoIB: No longer use flush as a parameter"
      Revert "IPoIB: Make ipoib_mcast_stop_thread flush the workqueue"
      Revert "IPoIB: Use dedicated workqueues per interface"
      Revert "IPoIB: change init sequence ordering"
      Revert "IPoIB: fix mcast_dev_flush/mcast_restart_task race"
      Revert "IPoIB: fix MCAST_FLAG_BUSY usage"
      Revert "IPoIB: Make the carrier_on_task race aware"
      Revert "IPoIB: Consolidate rtnl_lock tasks in workqueue"
      Merge branches 'ipoib' and 'odp' into for-next

 drivers/infiniband/core/uverbs_main.c          |   1 -
 drivers/infiniband/ulp/ipoib/ipoib.h           |  19 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  18 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  27 +--
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  49 ++---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 239 +++++++++----------------
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |  22 +--
 7 files changed, 134 insertions(+), 241 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
