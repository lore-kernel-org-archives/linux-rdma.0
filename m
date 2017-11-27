From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH 0/3] RDMA/hns: Bug fixes in hns RoCE driver
Date: Mon, 27 Nov 2017 10:41:21 +0800
Message-ID: <1511750484-102395-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: xavier.huwei@huawei.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, xavier_huwei@163.com, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

This patch-set introduces three patches to fix about the memory
related issues.

Wei Hu (Xavier) (3):
  RDMA/hns: Fix the issue of IOVA not page continuous in hip08
  RDMA/hns: Get rid of virt_to_page and vmap calls after
    dma_alloc_coherent
  RDMA/hns: Get rid of page operation after dma_alloc_coherent

 drivers/infiniband/hw/hns/hns_roce_alloc.c  | 23 -----------------------
 drivers/infiniband/hw/hns/hns_roce_device.h |  4 +---
 drivers/infiniband/hw/hns/hns_roce_hem.c    | 25 +++++++++++++------------
 drivers/infiniband/hw/hns/hns_roce_hem.h    |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 22 +++++++++++++++-------
 5 files changed, 30 insertions(+), 45 deletions(-)

-- 
1.9.1
