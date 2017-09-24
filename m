From: Michal Kalderon <Michal.Kalderon@cavium.com>
Subject: [PATCH v2 net-next 0/4] qed: iWARP fixes and enhancements
Date: Sun, 24 Sep 2017 12:09:41 +0300
Message-ID: <1506244185-2129-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net, netdev@vger.kernel.org, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com, Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>
List-Id: linux-rdma@vger.kernel.org

This patch series includes several fixes and enhancements
related to iWARP.

Patch #1 is actually the last of the initial iWARP submission.
It has been delayed until now as I wanted to make sure that qedr
supports iWARP prior to enabling iWARP device detection.

iWARP changes in RDMA tree have been accepted and targeted at
kernel 4.15, therefore, all iWARP fixes for this cycle are
submitted to net-next.

Changes from v1->v2 
  - Added "Fixes:" tag to commit message of patch #3

Signed-off by: Michal.Kalderon@cavium.com
Signed-off-by: Ariel Elior <Ariel.Elior@cavium.com>

Michal Kalderon (4):
  qed: Add iWARP enablement support
  qed: Add iWARP out of order support
  qed: Fix maximum number of CQs for iWARP
  qed: iWARP - Add check for errors on a SYN packet

 drivers/net/ethernet/qlogic/qed/qed_cxt.c         |  6 +++
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c       | 52 +++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_iwarp.h       | 11 ++++-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c         |  1 +
 drivers/net/ethernet/qlogic/qed/qed_mcp.c         | 10 ++---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c        | 24 +++++++----
 drivers/net/ethernet/qlogic/qed/qed_sp_commands.c |  1 +
 include/linux/qed/qed_ll2_if.h                    |  1 +
 8 files changed, 91 insertions(+), 15 deletions(-)

-- 
1.8.3.1
