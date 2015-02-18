From: kbuild test robot <fengguang.wu@intel.com>
Subject: [next:master 10113/10230]
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c:253:5: sparse: symbol
 'ocrdma_sysfs_rcv_pkts' was not declared. Should it be static?
Date: Wed, 18 Feb 2015 11:45:53 +0800
Message-ID: <201502181128.AqJYFmKG%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Mitesh Ahuja <mitesh.ahuja@emulex.com>
Cc: kbuild-all@01.org, Roland Dreier <roland@purestorage.com>, Devesh Sharma <devesh.sharma@emulex.com>, Selvin Xavier <selvin.xavier@emulex.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Duan Jiong <duanj.fnst@cn.fujitsu.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   c26de6d26435059245babb016acb840d9e0e5d12
commit: 8b528884f901757fb21c5900151fc294344d78f6 [10113/10230] RDMA/ocrdma: Add support for IB stack compliant stats in sysfs.
reproduce:
  # apt-get install sparse
  git checkout 8b528884f901757fb21c5900151fc294344d78f6
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/infiniband/hw/ocrdma/ocrdma_stats.c:253:5: sparse: symbol 'ocrdma_sysfs_rcv_pkts' was not declared. Should it be static?
>> drivers/infiniband/hw/ocrdma/ocrdma_stats.c:264:5: sparse: symbol 'ocrdma_sysfs_rcv_data' was not declared. Should it be static?
>> drivers/infiniband/hw/ocrdma/ocrdma_stats.c:317:5: sparse: symbol 'ocrdma_sysfs_xmit_pkts' was not declared. Should it be static?
>> drivers/infiniband/hw/ocrdma/ocrdma_stats.c:332:5: sparse: symbol 'ocrdma_sysfs_xmit_data' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
