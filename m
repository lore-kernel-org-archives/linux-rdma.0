From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 24 Feb 2012 18:32:41 -0800
Message-ID: <1330137161-2314-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git rdma-for-linus

----------------------------------------------------------------
One InfiniBand/RDMA regression fix for 3.3:

 - mlx4 SR-IOV changes added static exported functions, which doesn't
   build on powerpc at least.  Fix from Doug Ledford for this.

----------------------------------------------------------------
Doug Ledford (1):
      mlx4_core: Exported functions can't be static

 drivers/net/ethernet/mellanox/mlx4/fw.c |    2 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
