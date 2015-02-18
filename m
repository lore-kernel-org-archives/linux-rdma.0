From: kbuild test robot <fengguang.wu@intel.com>
Subject: [next:master 10115/10230]
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c:1510:6: sparse: symbol
 'ocrdma_free_pd_pool' was not declared. Should it be static?
Date: Wed, 18 Feb 2015 11:49:30 +0800
Message-ID: <201502181113.2969SUKJ%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Mitesh Ahuja <mitesh.ahuja@emulex.com>
Cc: kbuild-all@01.org, Roland Dreier <roland@purestorage.com>, Devesh Sharma <devesh.sharma@emulex.com>, Selvin Xavier <selvin.xavier@emulex.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Jes Sorensen <Jes.Sorensen@redhat.com>, Prarit Bhargava <prarit@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   c26de6d26435059245babb016acb840d9e0e5d12
commit: 72278f474221abd5c09af5d3a4dff39f9d10948f [10115/10230] RDMA/ocrdma: Move PD resource management to driver.
reproduce:
  # apt-get install sparse
  git checkout 72278f474221abd5c09af5d3a4dff39f9d10948f
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/infiniband/hw/ocrdma/ocrdma_hw.c:109:15: sparse: cast to restricted __le32
>> drivers/infiniband/hw/ocrdma/ocrdma_hw.c:1510:6: sparse: symbol 'ocrdma_free_pd_pool' was not declared. Should it be static?
   drivers/infiniband/hw/ocrdma/ocrdma_hw.c:1594:34: sparse: cast from restricted __le32
   drivers/infiniband/hw/ocrdma/ocrdma_hw.c:1595:34: sparse: cast from restricted __le32

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
