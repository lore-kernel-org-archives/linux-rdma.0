From: Hariprasad Shenai <hariprasad@chelsio.com>
Subject: [PATCH 0/5] cxgb4: Fix for PCI passthrough and some Misc. fixes
Date: Fri, 27 Jun 2014 19:23:46 +0530
Message-ID: <1403877231-8661-1-git-send-email-hariprasad@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: davem@davemloft.net, roland@purestorage.com, swise@opengridcomputing.com, leedom@chelsio.com, nirranjan@chelsio.com, kumaras@chelsio.com, anish@chelsio.com, Hariprasad Shenai <hariprasad@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

Hi,

This patch series fixes probe failure in VM when PF is exposed through PCI
Passthrough. Adds support to use firmware interface to get BAR0 value.
Replace the backdoor mechanism to access the HW memory with PCIe Window method
which fixes memory I/O. Also adds device ID of few more adapters for cxgb4 and
cxgb4vf driver.

The patches series is created against 'net-next' tree.
And includes patches on cxgb4, cxgb4vf and iw_cxgb4 driver.

Since this patch-series contains mainly cxgb4 related changes, we would like to
request this patch series to get merged via David Miller's 'net-next' tree.

We have included all the maintainers of respective drivers. Kindly review the
change and let us know in case of any review comments.

Thanks

Hariprasad Shenai (5):
  rdma/cxgb4: Fixes cxgb4 probe failure in VM when PF is exposed
    through PCI Passthrough
  cxgb4: Use FW interface to get BAR0 value
  cxgb4: Replaced the backdoor mechanism to access the HW memory with
    PCIe Window method
  cxgb4: Adds device ID for few more Chelsio T4 Adapters
  cxgb4vf: Adds device ID for few more Chelsio T4 Adapters

 drivers/infiniband/hw/cxgb4/cm.c                   |    3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |   20 ++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  168 +++++++++---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |    1 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |  270 +++++++++----------
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h       |    6 +
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |    9 +
 7 files changed, 288 insertions(+), 189 deletions(-)
