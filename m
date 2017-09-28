From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 28 Sep 2017 12:06:03 -0400
Message-ID: <1506614763.2927.17.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Both Mellanox and Intel had a series of -rc fixes that landed this
week.  The Mellanox bunch is spread throughout the stack and not just
in their driver, where as the Intel bunch was mostly in the hfi1
driver.  And, several of the fixes in the hfi1 driver were more than
just simple 5 line fixes.  As a result, the hfi1 driver fixes has a
sizable LOC count.  Everything else is as one would expect in an RC
cycle in terms of LOC count.  One item that might jump out and make you
think "That's not an rc item" is the fix that corrects a typo.  But,
that change fixes a typo in a user visible API that was just added in
this merge window, so if we fix it now, we can fix it.  If we don't,
the typo is in the API forever.  Another that might not appear to be a
fix at first glance is the Simplify mlx5_ib_cont_pages patch, but the
simplification allows them to fix a bug in the existing function
whenever the length of an SGE exceeded page size.  We also had to
revert one patch from the merge window that was wrong.  Anyway, here's
the boilerplate:

The following changes since commit e19b205be43d11bff638cad4487008c48d21c103:

  Linux 4.14-rc2 (2017-09-24 16:38:56 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git tags/for-linus

for you to fetch changes up to 828bcbdc975fbcfb27946c33d4b1d1bfab70789b:

  IB/hfi1: Unsuccessful PCIe caps tuning should not fail driver load (2017-09-27 11:10:36 -0400)

----------------------------------------------------------------
Second -rc update for 4.14 kernel

- a few core fixes
- a few ipoib fixes
- a few mlx5 fixes
- a 7 patch hfi1 related series

----------------------------------------------------------------
Alex Estrin (1):
      Revert "IB/ipoib: Update broadcast object if PKey value was changed in index 0"

Alex Vesker (1):
      IB/ipoib: Fix inconsistency with free_netdev and free_rdma_netdev

Harish Chegondi (1):
      IB/hfi1: Unsuccessful PCIe caps tuning should not fail driver load

Ilya Lesokhin (2):
      IB/mlx5: Simplify mlx5_ib_cont_pages
      IB/mlx5: Fix NULL deference on mlx5_ib_update_xlt failure

Jan Sokolowski (1):
      IB/hfi1: Check eeprom config partition validity

Kamenee Arumugam (1):
      IB/hfi1: Return correct value in general interrupt handler

Leon Romanovsky (1):
      IB/core: Fix typo in the name of the tag-matching cap struct

Michael J. Ruhl (1):
      IB/hfi1: On error, fix use after free during user context setup

Parav Pandit (2):
      IB/core: Fix qp_sec use after free access
      IB: Correct MR length field to be 64-bit

Sebastian Sanchez (2):
      IB/hfi1: Turn off AOC TX after offline substates
      IB/hfi1: Only reset QSFP after link up and turn off AOC TX

Shalom Lagziel (1):
      IB/ipoib: Fix sysfs Pkey create<->remove possible deadlock

 drivers/infiniband/core/security.c        |   4 +-
 drivers/infiniband/core/uverbs_cmd.c      |  14 ++---
 drivers/infiniband/hw/hfi1/chip.c         | 101 +++++++++++++++++++++++-------
 drivers/infiniband/hw/hfi1/chip.h         |   3 +-
 drivers/infiniband/hw/hfi1/eprom.c        |  20 ++++--
 drivers/infiniband/hw/hfi1/file_ops.c     |  41 ++++++------
 drivers/infiniband/hw/hfi1/pcie.c         |  50 +++++++--------
 drivers/infiniband/hw/hfi1/platform.c     |   4 +-
 drivers/infiniband/hw/mlx5/main.c         |  10 +--
 drivers/infiniband/hw/mlx5/mem.c          |  47 +++++---------
 drivers/infiniband/hw/mlx5/mr.c           |  27 +++++---
 drivers/infiniband/hw/nes/nes_verbs.c     |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c   |  13 ----
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  15 +++--
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c |  30 ++++++---
 drivers/infiniband/ulp/iser/iser_memory.c |   2 +-
 include/rdma/ib_verbs.h                   |   6 +-
 include/uapi/rdma/ib_user_verbs.h         |   2 +-
 net/sunrpc/xprtrdma/frwr_ops.c            |   2 +-
 19 files changed, 231 insertions(+), 164 deletions(-)

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
