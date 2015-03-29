From: Sagi Grimberg <sagig@mellanox.com>
Subject: iser target fixes for kernel 4.1
Date: Sun, 29 Mar 2015 15:52:02 +0300
Message-ID: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi Nic,

This set consists of:
- Bug fixes (1-2)
- Performance Optimization (3)
- Code refactoring (3-10,13-16)
- Renaming (11-12,17)
- Version bump (18)

Sagi Grimberg (18):
  iser-target: Fix session hang in case of an rdma read DIF error
  iser-target: Fix possible deadlock in RDMA_CM connection error
  iser-target: Use a single DMA MR and PD per device
  iser-target: Remove redundant check on recv completion
  iser-target: Remove dead code
  iser-target: Remove redundant local variable
  iser-target: Remove redundant casting on void pointers
  iser-target: Split isert_setup_qp
  iser-target: Introduce isert_[alloc|free]_comps
  iser-target: Remove redundant assignment to local variable
  iser-target: Rename rend/recv completion routines
  iser-target: Rename device find/release routines
  iser-target: Split some logic in isert_connect_request to routines
  iser-target: Get rid of redundant max_accept
  iser-target: Remove redundant check on the device
  iser-target: Remove un-needed rdma_listen backlog
  iser-target: Remove conn_ prefix from struct isert_conn members
  iser-target: Bump version to 1.0

 drivers/infiniband/ulp/isert/ib_isert.c |  691 +++++++++++++++++--------------
 drivers/infiniband/ulp/isert/ib_isert.h |   37 +-
 2 files changed, 398 insertions(+), 330 deletions(-)
