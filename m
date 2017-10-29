From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 0/6] Expose CQ moderation to user space
Date: Sun, 29 Oct 2017 15:51:34 +0200
Message-ID: <20171029135140.32649-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Changelog v0-v1:
 * Dropped comp_mask, there is already attr_mask
 * Put CQ moderartion into special struct instead of general struct ib_uverbs_ex_modify_cq

---------------------------------------
This patch set exposes CQ moderation. This will allow to moderate
number of CQEs needed to create an event. Such change brings performance
improvement by reducing pressure on application to receive event per-CQE.

The proposed semantics follows the well-established kernel semantics.

 * cq_max_count - defines the number of cookies needed to create an event.
 * cq_period    - defines the timeout between last event and a new one
                  that will occur even if cq_max_count was not reached

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-10-29-1

	Thanks
---------------------------------------

Yonatan Cohen (6):
  IB/uverbs: Allow CQ moderation with modify CQ
  IB/mlx4: Exposing modify CQ callback to uverbs layer
  IB/mlx5: Exposing modify CQ callback to uverbs layer
  IB/uverbs: Add CQ moderation capability to query_device
  IB/mlx4: Add CQ moderation capability to query_device
  IB/mlx5: Add CQ moderation capability to query_device

 drivers/infiniband/core/uverbs.h      |  1 +
 drivers/infiniband/core/uverbs_cmd.c  | 51 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |  1 +
 drivers/infiniband/hw/mlx4/main.c     |  6 +++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h  |  1 +
 drivers/infiniband/hw/mlx5/cq.c       |  3 +++
 drivers/infiniband/hw/mlx5/main.c     | 10 ++++++-
 include/linux/mlx4/cq.h               |  3 +++
 include/linux/mlx5/cq.h               |  3 +++
 include/rdma/ib_verbs.h               | 10 +++++++
 include/uapi/rdma/ib_user_verbs.h     | 22 ++++++++++++++-
 11 files changed, 109 insertions(+), 2 deletions(-)

--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
