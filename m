From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Fri,  6 Feb 2015 13:19:12 -0800
Message-ID: <1423257552-3072-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------
One more last-second RDMA change for 3.19:
 - Yann realized that the previous revert of new userspace ABI did not
   go far enough, and we're still exposing a change that we don't want.
   Revert even closer to 3.18 interface to make sure we get things right
   in the long run.

Sorry for sending this at the very end of the release cycle, but we
didn't realize the scope of the required fix until just now.

----------------------------------------------------------------
Yann Droneaud (1):
      Revert "IB/core: Add support for extended query device caps"

 drivers/infiniband/core/uverbs.h     |   1 -
 drivers/infiniband/core/uverbs_cmd.c | 137 +++++++++++------------------------
 drivers/infiniband/hw/mlx5/main.c    |   2 -
 include/rdma/ib_verbs.h              |   5 +-
 include/uapi/rdma/ib_user_verbs.h    |  27 -------
 5 files changed, 42 insertions(+), 130 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
