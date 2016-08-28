From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/2] Add port counter support for raw packet QP
Date: Sun, 28 Aug 2016 12:25:51 +0300
Message-ID: <1472376353-632-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

RDMA Counters weren't updated due to raw packet QPs' traffic since
the port counter-id was not associated with the QP. FW support is
required for this feature, without this support raw packet QP
counters will not count. A minor re-factor to the modify raw packet
QP function was needed to pass the  q-counter-id to modify RQ command
function.

Available in the "topic/raw_qp_ctr_supp" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/raw_qp_ctr_supp

Thanks,
  Alex & Leon

Alex Vesker (2):
  IB/mlx5: Refactor raw packet QP modify function
  IB/mlx5: Add port counter support for raw packet QP

 drivers/infiniband/hw/mlx5/qp.c | 68 +++++++++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 16 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
