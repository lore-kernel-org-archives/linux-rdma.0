From: kbuild test robot <fengguang.wu@intel.com>
Subject: [amirv:for-upstream 114/141]
 drivers/infiniband/ulp/ipoib/ipoib_ib.c:378:5: sparse: symbol
 'ipoib_rx_poll' was not declared. Should it be static?
Date: Wed, 25 Mar 2015 23:53:33 +0800
Message-ID: <201503252315.8wVkJr4n%fengguang.wu@intel.com>
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
commit: 94de75f9589d7899b441457e0d2ff9a66d1fa3b4 [114/141] IB/ipoib: Prepare the napi in the RX flow [ib-next:ipoib-s1]
reproduce:
  # apt-get install sparse
  git checkout 94de75f9589d7899b441457e0d2ff9a66d1fa3b4
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/infiniband/ulp/ipoib/ipoib_ib.c:378:5: sparse: symbol 'ipoib_rx_poll' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
