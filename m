From: Raju Rangoju <rajur@chelsio.com>
Subject: [rdma-rc PATCH 0/2] iw_cxgb4: Adjust the cq/qp mask
Date: Thu, 14 Feb 2019 17:40:52 +0530
Message-ID: <20190214121054.11693-1-rajur@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: jgg@mellanox.com, davem@davemloft.net, linux-rdma@vger.kernel.org
Cc: netdev@vger.kernel.org, swise@opengridcomputing.com, rajur@chelsio.com
List-Id: linux-rdma@vger.kernel.org

Export the LLD sge_host_page_size field to ULDs via
cxgb4_lld_info, so that iw_cxgb4 can adjust the cq/qp
mask based on no.of bar2 pages in a host page.

This series has both net(cxgb4) and rdma(iw_cxgb4) changes,
and I would request this merge via rdma repo.

I have made sure this series applies cleanly on both net-next
and rdma-for-rc and doesn't cause any merge conflicts.

Raju Rangoju (2):
  cxgb4: export sge_host_page_size to ulds
  iw_cxgb4: cq/qp mask depends on bar2 pages in a host page

 drivers/infiniband/hw/cxgb4/device.c           | 15 +++++++++++++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c |  1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h |  1 +
 3 files changed, 15 insertions(+), 2 deletions(-)

-- 
2.13.0
