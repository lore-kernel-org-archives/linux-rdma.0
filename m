From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 0/2] infiniband: trivial header search path fixups
Date: Fri, 25 Jan 2019 13:39:29 +0900
Message-ID: <1548391171-6407-1-git-send-email-yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Jason Gunthorpe <jgg@ziepe.ca>, Somnath Kotur <somnath.kotur@broadcom.com>, Sagi Grimberg <sagi@grimberg.me>, Nelson Escobar <neescoba@cisco.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Parvi Kaustubhi <pkaustub@cisco.com>, linux-kernel@vger.kernel.org, Lijun Ou <oulijun@huawei.com>, Steve Wise <swise@chelsio.com>, target-devel@vger.kernel.org, Christian Benvenuti <benve@cisco.com>, Faisal Latif <faisal.latif@intel.com>, Bart Van Assche <bvanassche@acm.org>, Shiraz Saleem <shiraz.saleem@intel.com>, Selvin Xavier <selvin.xavier@broadcom.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Devesh Sharma <devesh.sharma@broadcom.com>
List-Id: linux-rdma@vger.kernel.org

My main motivation is to get rid of crappy header search path manipulation
from Kbuild core.

Before that, I want to do as many treewide cleanups as possible.

If you are interested in the big picture of this work,
the full patch set is available at:

git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git build-test



Masahiro Yamada (2):
  infiniband: remove unneeded header search paths
  infiniband: prefix header search paths with $(srctree)/

 drivers/infiniband/hw/bnxt_re/Makefile | 2 +-
 drivers/infiniband/hw/cxgb3/Makefile   | 2 +-
 drivers/infiniband/hw/cxgb4/Makefile   | 4 ++--
 drivers/infiniband/hw/hns/Makefile     | 2 +-
 drivers/infiniband/hw/i40iw/Makefile   | 2 +-
 drivers/infiniband/hw/ocrdma/Makefile  | 2 +-
 drivers/infiniband/hw/usnic/Makefile   | 2 +-
 drivers/infiniband/ulp/isert/Makefile  | 1 -
 drivers/infiniband/ulp/srpt/Makefile   | 1 -
 9 files changed, 8 insertions(+), 10 deletions(-)

-- 
2.7.4
