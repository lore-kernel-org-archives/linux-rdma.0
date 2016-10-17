From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 0/8] infiniband: Remove semaphores
Date: Mon, 17 Oct 2016 22:00:54 +0530
Message-ID: <1476721862-7070-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

These are a set of patches which removes semaphores from infiniband.
These are part of a bigger effort to eliminate all semaphores from the
linux kernel.

NB: A few semaphores which are counting ones are replaced with an open-coded
implementation by introducing a new type in 'include/rdma/ib_sa.h'. Need to
see if this can be programmed in a generic way using wait queues.

Thanks,
Binoy

Binoy Jayan (8):
  IB/core: iwpm_nlmsg_request: Replace semaphore with completion
  IB/core: Replace semaphore sm_sem with completion
  IB/hns: Replace semaphore poll_sem with mutex
  IB/mthca: Replace semaphore poll_sem with mutex
  IB/isert: Replace semaphore sem with completion
  IB/hns: Replace counting semaphore event_sem with wait condition
  IB/mthca: Replace counting semaphore event_sem with wait condition
  IB/mlx5: Replace counting semaphore sem with wait condition

 drivers/infiniband/core/iwpm_msg.c          |  8 ++++----
 drivers/infiniband/core/iwpm_util.c         |  7 +++----
 drivers/infiniband/core/iwpm_util.h         |  3 ++-
 drivers/infiniband/core/user_mad.c          | 14 ++++++++------
 drivers/infiniband/hw/hns/hns_roce_cmd.c    | 28 ++++++++++++++++++----------
 drivers/infiniband/hw/hns/hns_roce_device.h |  6 ++++--
 drivers/infiniband/hw/mlx5/main.c           |  3 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h        |  3 ++-
 drivers/infiniband/hw/mlx5/mr.c             | 28 +++++++++++++++++++---------
 drivers/infiniband/hw/mthca/mthca_cmd.c     | 22 +++++++++++++---------
 drivers/infiniband/hw/mthca/mthca_cmd.h     |  1 +
 drivers/infiniband/hw/mthca/mthca_dev.h     |  5 +++--
 drivers/infiniband/ulp/isert/ib_isert.c     |  6 +++---
 drivers/infiniband/ulp/isert/ib_isert.h     |  3 ++-
 include/rdma/ib_sa.h                        |  5 +++++
 15 files changed, 89 insertions(+), 53 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
