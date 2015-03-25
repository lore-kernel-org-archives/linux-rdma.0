From: kbuild test robot <fengguang.wu@intel.com>
Subject: [amirv:for-upstream 115/141]
 drivers/infiniband/ulp/ipoib/ipoib_ib.c:424:5: sparse: symbol
 'ipoib_tx_poll' was not declared. Should it be static?
Date: Thu, 26 Mar 2015 00:04:15 +0800
Message-ID: <201503260000.pSiGcDdD%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Erez Shitrit <erezsh@mellanox.com>
Cc: kbuild-all@01.org, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Doug Ledford <dledford@redhat.com>, Alex Estrin <alex.estrin@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

tree:   git://flatbed.openfabrics.org/~amirv/linux.git for-upstream
head:   fbf635aeba2bba8091d58dc9d4180c04e9dd01f0
commit: c87f933e10ff036c0e13a9cbccd5f5c4671bcd01 [115/141] IB/ipoib: Use napi api in TX flow [ib-next:ipoib-s1]
reproduce:
  # apt-get install sparse
  git checkout c87f933e10ff036c0e13a9cbccd5f5c4671bcd01
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/infiniband/ulp/ipoib/ipoib_ib.c:378:5: sparse: symbol 'ipoib_rx_poll' was not declared. Should it be static?
>> drivers/infiniband/ulp/ipoib/ipoib_ib.c:424:5: sparse: symbol 'ipoib_tx_poll' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
