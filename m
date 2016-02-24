From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 00/12] iser target patches for 4.6
Date: Wed, 24 Feb 2016 19:23:57 +0200
Message-ID: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Nic,

This patchset targets 4.6 merge window, it passed
our nightly regression tests.

The set consists of:
- Several patches for error flow fixes and rework from Jenny
- Several much needed cleanups from HCH
- Conversion to the recently introduced CQ and QP drain APIs

As usual, more review and testing are welcome!

Christoph Hellwig (5):
  iser-target: Remove ISER_RECV_DATA_SEG_LEN
  iser-target: Split and properly type the login buffer
  iser-target: Convert to new CQ API
  iser-target: Kill struct isert_rdma_wr
  iser-target: Kill the ->isert_cmd back pointer in struct iser_tx_desc

Jenny Derzhavetz (6):
  iser-target: Fix identification of login rx descriptor type
  iser-target: Add new state ISER_CONN_BOUND to isert_conn
  iser-target: Separate flows for np listeners and connections cma
    events
  iser-target: Rework connection termination
  iser-target: Remove redundant wait in release_conn
  iser-target: Remove impossible condition from isert_wait_conn

Sagi Grimberg (1):
  iser-target: Use ib_drain_qp

 drivers/infiniband/ulp/isert/ib_isert.c | 819 ++++++++++++++------------------
 drivers/infiniband/ulp/isert/ib_isert.h |  74 +--
 2 files changed, 385 insertions(+), 508 deletions(-)

-- 
1.8.4.3
