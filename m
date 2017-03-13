From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/3] Barriers improvements
Date: Mon, 13 Mar 2017 16:53:46 +0200
Message-ID: <1489416829-15467-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series comes to optimize both mlx4 and mlx5 as some follow-up of previous
barrier series that was already merged.

The first patch enables an optimized code on X86 where spinlock can serve also
as a fence, it is used in downstream patches by mlx4 and mlx5 patches.

Next 2 patches are optimizing of current code to prevent degradation in mlx4
and to grub some improvement in mlx5.

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/95

Jason Gunthorpe (1):
  verbs: Add mmio_wc_spinlock barrier

Yishai Hadas (2):
  mlx4: Optimize post_send barriers
  mlx5: Optimize post_send barriers

 providers/mlx4/qp.c   | 19 +++++++------------
 providers/mlx5/mlx5.c |  2 +-
 providers/mlx5/qp.c   |  7 ++++---
 util/udma_barrier.h   | 15 +++++++++++++++
 4 files changed, 27 insertions(+), 16 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
