From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 0/4] arbitrary sg lists support
Date: Thu, 13 Apr 2017 18:56:13 +0300
Message-ID: <1492098977-5231-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds an arbitrary sg list support to NVMEoF host for
capable devices (such as RDMA CX4/CX5 HCAs).
During the review we decided to add an helper function to ib_core
that will be used by ULPs in order to avoid code duplication.

Changes from V1:
 - added helper function to verbes api
 - use helper in iSER code
 - add reviewrs signatures

Max Gurtovoy (4):
  IB/core: Add inline function to get sg mr type
  IB/iser: Use ib_get_sg_mr_type() helper
  nvme: enable SG gaps support
  nvme-rdma: add support for arbitrary sg lists mapping

 drivers/infiniband/ulp/iser/iser_verbs.c |    8 +-------
 drivers/nvme/host/core.c                 |    5 ++++-
 drivers/nvme/host/nvme.h                 |    1 +
 drivers/nvme/host/rdma.c                 |   11 +++++++----
 include/rdma/ib_verbs.h                  |   17 +++++++++++++++++
 5 files changed, 30 insertions(+), 12 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
