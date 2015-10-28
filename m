From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 0/2] Handle mlx4 max_sge_rd correctly
Date: Wed, 28 Oct 2015 13:28:14 +0200
Message-ID: <1446031696-19022-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This addresses a specific mlx4 issue where the max_sge_rd
is actually smaller than max_sge (rdma reads with max_sge
entries completes with error).

The second patch removes the explicit work-around from the
iser target code.

Changes from v1:
- Fixed driver rdma segment size to be 16 bytes

Changes from v0:
- Used a dedicated enumeration MLX4_MAX_SGE_RD and added
  a root cause analysis to patch change log.

- Fixed isert qp creation to be max_sge but construct rdma
  work request with the minimum of max_sge and max_sge_rd
  as non-rdma sends (login rsp) take 2 sges (and some devices
  have max_sge_rd = 1.

Sagi Grimberg (2):
  mlx4: Expose correct max_sge_rd limit
  iser-target: Remove explicit mlx4 work-around

 drivers/infiniband/hw/mlx4/main.c       |    2 +-
 drivers/infiniband/ulp/isert/ib_isert.c |   13 +++----------
 include/linux/mlx4/device.h             |   11 +++++++++++
 3 files changed, 15 insertions(+), 11 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
