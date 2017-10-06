From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Fri, 06 Oct 2017 13:25:28 -0400
Message-ID: <1507310728.46071.22.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

This is a pretty small pull request.  Only 6 patches in total.  There
are no outstanding -rc patches on the mailing list after this pull
request, so only if some new issues are discovered in the remainder of
the rc cycles will you here from me again.  Here's the boilerplate:

The following changes since commit 828bcbdc975fbcfb27946c33d4b1d1bfab70789b:

  IB/hfi1: Unsuccessful PCIe caps tuning should not fail driver load (2017-09-27 11:10:36 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git tags/for-linus

for you to fetch changes up to 789f903fd75036f937409a9a1616a5a5e5cc5bae:

  i40iw: Fix port number for query QP (2017-10-04 15:28:49 -0400)

----------------------------------------------------------------
Third -rc update for 4.14 kernel

- a fix for iwpm netlink usage
- a fix for error unwinding in mlx5
- two fixes to vlan handling in qedr
- a couple small i40iw fixes

----------------------------------------------------------------
Amrani, Ram (2):
      RDMA/qedr: Parse VLAN ID correctly and ignore the value of zero
      RDMA/qedr: Parse vlan priority as sl

Mustafa Ismail (2):
      i40iw: Add missing memory barriers
      i40iw: Fix port number for query QP

Parav Pandit (1):
      IB/mlx5: Fix label order in error path handling

Shiraz Saleem (1):
      RDMA/iwpm: Properly mark end of NL messages

 drivers/infiniband/core/iwpm_msg.c        |  8 ++++++++
 drivers/infiniband/core/iwpm_util.c       |  5 +++++
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c  |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_p.h     |  2 ++
 drivers/infiniband/hw/i40iw/i40iw_puda.c  | 11 ++++-------
 drivers/infiniband/hw/i40iw/i40iw_verbs.c |  2 ++
 drivers/infiniband/hw/mlx5/main.c         |  4 ++--
 drivers/infiniband/hw/qedr/qedr.h         |  2 +-
 drivers/infiniband/hw/qedr/qedr_cm.c      | 12 +++++++++---
 9 files changed, 34 insertions(+), 14 deletions(-)


-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
