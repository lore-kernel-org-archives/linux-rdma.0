From: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 0/9] infiniband: Remove semaphores
Date: Wed, 26 Oct 2016 13:31:05 +0530
Message-ID: <1477468874-16328-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

These are a set of patches [v3] which removes semaphores from infiniband.
These are part of a bigger effort to eliminate all semaphores from the
linux kernel.

v2 -> v3:

IB/mlx5: Move '&umr_context' into helper fn
IB/mthca: Restructure mthca_cmd.c to manage free_head
IB/hns: Restructure hns_roce_cmd.c to manage free_head
IB/core: Convert completion to wait_event
IB/mlx5: Simplify completion into a wait_event


Thanks,
Binoy

Binoy Jayan (9):
  IB/core: iwpm_nlmsg_request: Replace semaphore with completion
  IB/core: Replace semaphore sm_sem with an atomic wait
  IB/hns: Replace semaphore poll_sem with mutex
  IB/mthca: Replace semaphore poll_sem with mutex
  IB/isert: Replace semaphore sem with completion
  IB/hns: Replace counting semaphore event_sem with wait_event
  IB/mthca: Replace counting semaphore event_sem with wait_event
  IB/mlx5: Add helper mlx5_ib_post_send_wait
  IB/mlx5: Simplify completion into a wait_event

 drivers/infiniband/core/iwpm_msg.c          |   8 +-
 drivers/infiniband/core/iwpm_util.c         |   7 +-
 drivers/infiniband/core/iwpm_util.h         |   3 +-
 drivers/infiniband/core/user_mad.c          |  20 +++--
 drivers/infiniband/hw/hns/hns_roce_cmd.c    |  55 ++++++++-----
 drivers/infiniband/hw/hns/hns_roce_device.h |   5 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h        |   2 +-
 drivers/infiniband/hw/mlx5/mr.c             | 120 ++++++++--------------------
 drivers/infiniband/hw/mthca/mthca_cmd.c     |  55 ++++++++-----
 drivers/infiniband/hw/mthca/mthca_cmd.h     |   1 +
 drivers/infiniband/hw/mthca/mthca_dev.h     |   5 +-
 drivers/infiniband/ulp/isert/ib_isert.c     |   6 +-
 drivers/infiniband/ulp/isert/ib_isert.h     |   3 +-
 include/rdma/ib_verbs.h                     |   3 +-
 14 files changed, 140 insertions(+), 153 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
