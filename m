From: Roland Dreier <rdreier@cisco.com>
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 12 Mar 2010 10:56:25 -0800
Message-ID: <adar5np9xnq.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few small fixes:

Chien Tung (2):
      RDMA/nes: Clear stall bit before destroying NIC QP
      RDMA/nes: Fix CX4 link problem in back-to-back configuration

Eli Cohen (1):
      IPoIB: Fix TX queue lockup with mixed UD/CM traffic

Faisal Latif (1):
      RDMA/nes: Set assume_aligned_header bit

Or Gerlitz (1):
      IPoIB: Include return code in trace message for ib_post_send() failures

Roland Dreier (1):
      Merge branches 'cxgb3', 'ipoib', 'misc' and 'nes' into for-next

Steve Wise (2):
      IB/mad: Ignore iWARP devices on device removal
      RDMA/cxgb3: Wait at least one schedule cycle during device removal

 drivers/infiniband/core/mad.c           |    3 +++
 drivers/infiniband/hw/cxgb3/iwch.c      |    2 ++
 drivers/infiniband/hw/nes/nes_hw.c      |    8 ++++++++
 drivers/infiniband/hw/nes/nes_hw.h      |    1 +
 drivers/infiniband/hw/nes/nes_nic.c     |   30 ++++++++++++++++++++++++++++--
 drivers/infiniband/hw/nes/nes_verbs.c   |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |   10 +++++++---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |    9 +++++----
 8 files changed, 55 insertions(+), 9 deletions(-)

-- 
Roland Dreier  <rolandd@cisco.com>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
