From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs v3 0/3] SIF related libibverbs patches
Date: Tue, 20 Sep 2016 08:22:23 +0200
Message-ID: <cover.b0b7418bec346c028215053b3e58e097aa822563.1474352400.git-series.knut.omang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is the initial patch series for the work of upstreaming the driver and
user level library for SIF, the new Oracle HCA.

These patches are needed to support SIF - Oracle's new Infiniband HCA stack
from user mode. A corresponding patch set for the kernel is needed.

Patch 1 introduces a new ibv_cmd_create_ah_ex under a new .so file version
IBVERBS_1.3 in order to preserve backward binary compatibility with older
provider builds.

We need patch 2 because we need a provider specific extension to the ibv_reg_mr response,
which breaks if alignment criterias are violated.

Patch 3 is similar to patch 2 except that no provider libs uses this code path
(kernel supported XRC send) until now, so no extra backward compatibility measures
are needed.

Changes since v2:
  - Rebase to latest libibverbs (3b39733)
  - Use IBVERBS_1.4 instead of 1.3 in map file

Changes since v1:
  - Introduce the new ibv_cmd_create_ah_ex as a new version IBVERBS_1.3 in the
    map file.

Knut Omang (3):
  Add new call ibv_cmd_create_ah_ex which supports extra parameters
  Add padding to get proper end alignment of ibv_reg_mr_resp
  Provide remote XRC SRQ number in kernel post_send.

 include/infiniband/driver.h   |  4 +++-
 include/infiniband/kern-abi.h |  2 +-
 src/cmd.c                     | 55 +++++++++++++++++++++---------------
 src/libibverbs.map            |  6 +++-
 4 files changed, 44 insertions(+), 23 deletions(-)

base-commit: 3b3973377f0dbccb11323b86e267308052cc4458
-- 
git-series 0.8.10
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
