From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/2] IB/core fixes for kernel v4.11-rc
Date: Mon, 6 Mar 2017 16:35:47 -0800
Message-ID: <20170307003549.3872-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sebastian Ott <sebott@linux.vnet.ibm.com>, Parav Pandit <parav@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-rdma@vger.kernel.org

Hello Doug,

The following bugs have been reported against kernel v4.11-rc1:
* I/O MMU support for PCIe RDMA drivers is broken.
* s390 support for RDMA drivers is broken.

The two patches in this series address this. Please consider
these patches for kernel v4.11-rc.

Thanks,

Bart.

Bart Van Assche (2):
  device: Stop requiring that struct device is embedded in struct
    pci_dev
  IB/core: Restore I/O MMU, s390 and powerpc support

 drivers/infiniband/core/device.c | 10 +++++++++-
 drivers/pci/probe.c              |  1 +
 include/linux/device.h           |  5 +++++
 include/linux/pci.h              |  5 ++++-
 4 files changed, 19 insertions(+), 2 deletions(-)

-- 
2.12.0
