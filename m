From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Wed,  6 Feb 2013 17:15:38 -0800
Message-ID: <1360199738-13948-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

IB regression fixes for 3.8:
 - Fix mlx4 VFs not working on old guests because of 64B CQE changes
 - Fix ill-considered sparse fix for qib
 - Fix IPoIB crash due to skb double destruct introduced in 3.8-rc1

----------------------------------------------------------------
Mike Marciniszyn (1):
      IB/qib: Fix for broken sparse warning fix

Or Gerlitz (1):
      mlx4_core: Fix advertisement of wrong PF context behaviour

Roland Dreier (1):
      Merge branches 'ipoib', 'mlx4' and 'qib' into for-next

Shlomo Pongratz (1):
      IPoIB: Fix crash due to skb double destruct

 drivers/infiniband/hw/qib/qib_qp.c        | 11 +++--------
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |  6 +++---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c   |  6 +++---
 drivers/net/ethernet/mellanox/mlx4/main.c |  2 +-
 4 files changed, 10 insertions(+), 15 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
