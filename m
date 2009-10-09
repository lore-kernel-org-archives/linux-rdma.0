From: Roland Dreier <rdreier@cisco.com>
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 09 Oct 2009 10:08:46 -0700
Message-ID: <adaskdsjy01.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933919AbZJIRJ0@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get another small batch of small RDMA/InfiniBand fixes, and
one device ID addition:

Bart Van Assche (1):
      IB: Fix typo in udev rule documentation

David J. Wilder (1):
      RDMA/addr: Fix resolution of local IPv6 addresses

Roland Dreier (1):
      Merge branches 'cxgb3', 'misc' and 'mlx4' into for-next

Steve Wise (2):
      RDMA/iwcm: Don't call provider reject func with irqs disabled
      RDMA/cxgb3: Handle NULL inetdev pointer in iwch_query_port()

Yevgeny Petrilin (1):
      mlx4_core: Add 40GigE device ID

 Documentation/infiniband/user_mad.txt       |    4 ++--
 Documentation/infiniband/user_verbs.txt     |    2 +-
 drivers/infiniband/core/addr.c              |    2 +-
 drivers/infiniband/core/iwcm.c              |    2 ++
 drivers/infiniband/hw/cxgb3/iwch_provider.c |   11 +++++++----
 drivers/net/mlx4/main.c                     |    1 +
 6 files changed, 14 insertions(+), 8 deletions(-)
