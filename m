From: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 0/8] RDMA/qedr: Add iWARP support for QL4xxxx
Date: Wed, 26 Jul 2017 14:41:49 +0300
Message-ID: <1501069317-16601-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: michal.kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: yuval.mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patch series adds iWARP support to our QL4xxxx networking adapters.

The first 6 patches of this series were previously sent as an RFC
(patches 13-18): https://www.spinics.net/lists/linux-rdma/msg51416.html
The qed part of the RFC has already been accepted as part of 4.13:
https://www.spinics.net/lists/netdev/msg443224.html

Changes from RFC:
-----------------
* Functions rdma_protocol_iwarp/roce, are used instead of IS_IWARP/IS_ROCE
macros when differentiating flows after device registration.
Pointed out by Leon
* Additional patch is added for user space iWARP support.
* Additional maintainer added for qedr for MAINTAINERS.

This series was tested and built against:
git://github.com/dledford/linux.git, branch: k.o/for-next

Michal Kalderon (8):
  RDMA/qedr: Add additional maintainer to MAINTAINERS file
  RDMA/qedr: Rename the qedr_cm file as a preparation for iWARP support
  RDMA/qedr: Add support for registering an iWARP device
  RDMA/qedr: Add iWARP support in existing verbs
  RDMA/qedr: Add support for read with invalidate, supported in iWARP
  RDMA/qedr: Add iWARP connection management qp related callbacks
  RDMA/qedr: Add iWARP connection management functions
  RDMA/qedr: Add support for iWARP in user space

 MAINTAINERS                                        |   1 +
 drivers/infiniband/hw/qedr/Makefile                |   2 +-
 drivers/infiniband/hw/qedr/main.c                  | 105 ++-
 drivers/infiniband/hw/qedr/qedr.h                  |  31 +-
 drivers/infiniband/hw/qedr/qedr_hsi_rdma.h         |   6 +-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c            | 746 +++++++++++++++++++++
 drivers/infiniband/hw/qedr/qedr_iw_cm.h            |  49 ++
 .../hw/qedr/{qedr_cm.c => qedr_roce_cm.c}          |   2 +-
 .../hw/qedr/{qedr_cm.h => qedr_roce_cm.h}          |   0
 drivers/infiniband/hw/qedr/verbs.c                 | 350 +++++++---
 drivers/infiniband/hw/qedr/verbs.h                 |   2 +
 11 files changed, 1203 insertions(+), 91 deletions(-)
 create mode 100644 drivers/infiniband/hw/qedr/qedr_iw_cm.c
 create mode 100644 drivers/infiniband/hw/qedr/qedr_iw_cm.h
 rename drivers/infiniband/hw/qedr/{qedr_cm.c => qedr_roce_cm.c} (99%)
 rename drivers/infiniband/hw/qedr/{qedr_cm.h => qedr_roce_cm.h} (100%)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
