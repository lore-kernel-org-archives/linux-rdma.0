From: Roland Dreier <rdreier@cisco.com>
Subject: [ofa-general] [GIT PULL] please pull infiniband.git
Date: Thu, 24 Sep 2009 12:45:12 -0700
Message-ID: <ada7hvo160n.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <general-bounces@lists.openfabrics.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, general@lists.openfabrics.org
List-Id: linux-rdma@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the batch of RDMA/InfiniBand changes for the 2.6.32
merge window:

The following changes since commit 86d710146fb9975f04c505ec78caa43d227c1018:
  Linus Torvalds (1):
        Merge git://git.linux-nfs.org/projects/trondmy/nfs-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

Eli Cohen (1):
      mlx4_core: Pass cache line size to device FW

Jack Morgenstein (1):
      IB/mthca: Fix access to freed memory in catastrophic event handling

Julia Lawall (1):
      RDMA/nes: Remove duplicate .ndo_set_mac_address field initialization

Moni Shoua (1):
      IPoIB: Don't turn on carrier for a non-active port

Roland Dreier (2):
      IB/mad: Fix lock-lock-timer deadlock in RMPP code
      Merge branches 'ipoib', 'mad', 'mlx4', 'mthca' and 'nes' into for-linus

 drivers/infiniband/core/mad_rmpp.c             |   17 +++++++++++++----
 drivers/infiniband/hw/mthca/mthca_catas.c      |   11 ++++++++---
 drivers/infiniband/hw/nes/nes_nic.c            |    1 -
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    7 +++++++
 drivers/net/mlx4/fw.c                          |    5 +++++
 5 files changed, 33 insertions(+), 8 deletions(-)
