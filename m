From: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 0/8] infiniband: Remove semaphores
Date: Tue, 25 Oct 2016 17:31:51 +0530
Message-ID: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

These are a set of patches [v2] which removes semaphores from infiniband.
These are part of a bigger effort to eliminate all semaphores from the
linux kernel.

v1 -> v2:

IB/hns   : Use wait_event instead of open coding counting semaphores
IB/mthca : Use wait_event instead of open coding counting semaphores
IB/mthca : Remove mutex_[un]lock from *_cmd_use_events/*_cmd_use_polling
IB/mlx5  : Cleanup, add helper mlx5_ib_post_send_wait

Thanks,
Binoy

Binoy Jayan (8):
  IB/core: iwpm_nlmsg_request: Replace semaphore with completion
  IB/core: Replace semaphore sm_sem with completion
  IB/hns: Replace semaphore poll_sem with mutex
  IB/mthca: Replace semaphore poll_sem with mutex
  IB/isert: Replace semaphore sem with completion
  IB/hns: Replace counting semaphore event_sem with wait_event
  IB/mthca: Replace counting semaphore event_sem with wait_event
  IB/mlx5: Add helper mlx5_ib_post_send_wait

 drivers/infiniband/core/iwpm_msg.c          |  8 +--
 drivers/infiniband/core/iwpm_util.c         |  7 +--
 drivers/infiniband/core/iwpm_util.h         |  3 +-
 drivers/infiniband/core/user_mad.c          | 14 +++--
 drivers/infiniband/hw/hns/hns_roce_cmd.c    | 48 ++++++++++-----
 drivers/infiniband/hw/hns/hns_roce_device.h |  5 +-
 drivers/infiniband/hw/mlx5/mr.c             | 96 +++++++++--------------------
 drivers/infiniband/hw/mthca/mthca_cmd.c     | 47 +++++++++-----
 drivers/infiniband/hw/mthca/mthca_cmd.h     |  1 +
 drivers/infiniband/hw/mthca/mthca_dev.h     |  5 +-
 drivers/infiniband/ulp/isert/ib_isert.c     |  6 +-
 drivers/infiniband/ulp/isert/ib_isert.h     |  3 +-
 12 files changed, 119 insertions(+), 124 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
