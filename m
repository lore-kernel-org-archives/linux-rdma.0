From: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5 0/9] infiniband: Remove semaphores
Date: Mon, 21 Nov 2016 11:38:07 +0530
Message-ID: <1479708496-9828-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tatyana E Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Hi,

These are a set of patches [v5] which removes semaphores from infiniband.
These are part of a bigger effort to eliminate all semaphores from the
linux kernel.

v4 --> v5
---------
IB/isert: Replace semaphore sem with completion
  - Modified changelog to support use of completion
IB/mlx5: Simplify completion into a wait_event
  - Avoid this patch.
    As umr_context is on the stack, and we are waiting
    for it to be fully done, it really should be a completion.

v3 -> v4:
---------

IB/mlx5: Added patch - Replace semaphore umr_common:sem with wait_event
IB/mlx5: Fixed a bug pointed out by Leon Romanovsky

v2 -> v3:
---------

IB/mlx5: Move '&umr_context' into helper fn
IB/mthca: Restructure mthca_cmd.c to manage free_head
IB/hns: Restructure hns_roce_cmd.c to manage free_head
IB/core: Convert completion to wait_event
IB/mlx5: Simplify completion into a wait_event

v1 -> v2:
---------

IB/hns   : Use wait_event instead of open coding counting semaphores
IB/mthca : Use wait_event instead of open coding counting semaphores
IB/mthca : Remove mutex_[un]lock from *_cmd_use_events/*_cmd_use_polling
IB/mlx5  : Cleanup, add helper mlx5_ib_post_send_wait

v1
---------
  IB/core: iwpm_nlmsg_request: Replace semaphore with completion
  IB/core: Replace semaphore sm_sem with completion
  IB/hns: Replace semaphore poll_sem with mutex
  IB/mthca: Replace semaphore poll_sem with mutex
  IB/isert: Replace semaphore sem with completion
  IB/hns: Replace counting semaphore event_sem with wait condition
  IB/mthca: Replace counting semaphore event_sem with wait condition
  IB/mlx5: Replace counting semaphore sem with wait condition

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
  IB/mlx5: Replace semaphore umr_common:sem with wait_event

 drivers/infiniband/core/iwpm_msg.c          |   8 +-
 drivers/infiniband/core/iwpm_util.c         |   7 +-
 drivers/infiniband/core/iwpm_util.h         |   3 +-
 drivers/infiniband/core/user_mad.c          |  20 +++--
 drivers/infiniband/hw/hns/hns_roce_cmd.c    |  57 +++++++++-----
 drivers/infiniband/hw/hns/hns_roce_device.h |   5 +-
 drivers/infiniband/hw/mlx5/main.c           |   6 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h        |   7 +-
 drivers/infiniband/hw/mlx5/mr.c             | 117 ++++++++--------------------
 drivers/infiniband/hw/mthca/mthca_cmd.c     |  57 ++++++++------
 drivers/infiniband/hw/mthca/mthca_cmd.h     |   1 +
 drivers/infiniband/hw/mthca/mthca_dev.h     |   5 +-
 drivers/infiniband/ulp/isert/ib_isert.c     |   6 +-
 drivers/infiniband/ulp/isert/ib_isert.h     |   3 +-
 14 files changed, 147 insertions(+), 155 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
