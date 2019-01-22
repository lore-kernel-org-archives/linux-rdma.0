From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/8] IB: cleanup debugfs usage
Date: Tue, 22 Jan 2019 16:17:52 +0100
Message-ID: <20190122151800.15092-1-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-rdma@vger.kernel.org

When calling debugfs code, there is no need to ever check the return
value of the call, as no logic should ever change if a call works
properly or not.  Fix up a bunch of infiniband-specific code to not care
about the results of debugfs.

Greg Kroah-Hartman (8):
  infiniband: cxgb4: no need to check return value of debugfs_create functions
  infiniband: hfi1: drop crazy DEBUGFS_SEQ_FILE_CREATE() macro
  infiniband: hfi1: no need to check return value of debugfs_create functions
  infiniband: qib: no need to check return value of debugfs_create functions
  infiniband: mlx5: no need to check return value of debugfs_create functions
  infiniband: ocrdma: no need to check return value of debugfs_create functions
  infiniband: usnic: no need to check return value of debugfs_create functions
  infiniband: ipoib: no need to check return value of debugfs_create functions

 drivers/infiniband/hw/cxgb4/device.c        |  8 +--
 drivers/infiniband/hw/hfi1/debugfs.c        | 52 +++++++---------
 drivers/infiniband/hw/hfi1/debugfs.h        | 12 ----
 drivers/infiniband/hw/hfi1/fault.c          | 53 ++++++----------
 drivers/infiniband/hw/mlx5/cong.c           | 15 ++---
 drivers/infiniband/hw/mlx5/main.c           |  8 +--
 drivers/infiniband/hw/mlx5/mlx5_ib.h        |  8 +--
 drivers/infiniband/hw/mlx5/mr.c             | 51 +++-------------
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 67 +++++++--------------
 drivers/infiniband/hw/qib/qib_debugfs.c     | 26 +++-----
 drivers/infiniband/hw/usnic/usnic_debugfs.c | 26 --------
 drivers/infiniband/ulp/ipoib/ipoib.h        |  4 +-
 drivers/infiniband/ulp/ipoib/ipoib_fs.c     |  7 +--
 drivers/infiniband/ulp/ipoib/ipoib_main.c   |  4 +-
 14 files changed, 94 insertions(+), 247 deletions(-)

-- 
2.20.1
