From: Roland Dreier <rdreier@cisco.com>
Subject: [GIT PULL] consider pulling infiniband.git
Date: Thu, 08 Jul 2010 13:37:43 -0700
Message-ID: <adafwztzp48.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Linus, please consider pulling from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will extract the SD7220 firmware blob from the new qib driver.
This is a big change at this stage but on the other hand it seems
better to use external firmware from the first release with qib.

However I'm sending this as a separate pull request to let you make the call.

Ben Hutchings (1):
      IB/qib: Use request_firmware() to load SD7220 firmware

 drivers/infiniband/hw/qib/Makefile         |    2 +-
 drivers/infiniband/hw/qib/qib_7220.h       |    7 -
 drivers/infiniband/hw/qib/qib_sd7220.c     |   56 ++-
 drivers/infiniband/hw/qib/qib_sd7220_img.c | 1081 ----------------------------
 firmware/Makefile                          |    1 +
 firmware/WHENCE                            |   40 +
 6 files changed, 87 insertions(+), 1100 deletions(-)
 delete mode 100644 drivers/infiniband/hw/qib/qib_sd7220_img.c

-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
