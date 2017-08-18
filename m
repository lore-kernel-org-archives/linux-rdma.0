From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Fri, 18 Aug 2017 14:21:12 -0400
Message-ID: <1503080472.2598.38.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

This is all of the -rc fixes that we know of.  I suspect this will be
the last rc pull request, but you never know, I could be wrong.

Nothing major here.  There are the i40iw patches I mentioned in my last
pull request minus one that I pulled out because it wasn't a fix and
not appropriate for the rc cycle.  Then a few other items trickled in
and were added to the pull request.  It's fairly small aside from those
5 i40iw patches.  Here's the boilerplate:
The following changes since commit
48107c4e596c8523d46c7b04f92cf29e7569a01e:

  Merge tag 'rdma-rc-2017-07-26' of
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma into
leon-ipoib (2017-08-07 13:30:40 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to
870201f95fcbd19538aef630393fe9d583eff82e:

  IB/uverbs: Fix NULL pointer dereference during device removal (2017-
08-16 12:53:15 -0400)

----------------------------------------------------------------
Fourth set of -rc fixes for 4.13 cycle

- Set of 5 i40iw fixes (the first of these is rather large by line
  count consideration, but I decided to send it because if fixes a
  legitimate issue and the line count is because it does so by creating
  a new function and using it where needed instead of just patching up
a
  few lines...a smaller fix could probably be done, but the larger fix
  is the better code solution)
- One vmw_pvrdma fix
- One hns_roce fix (this silences a checker warning, but can't actually
  happen, I expect a patch to remove this from all drivers that share
  this same check in for-next)
- One iw_cxgb4 fix
- Two IB core fixes

----------------------------------------------------------------
Bryan Tan (1):
      RDMA/vmw_pvrdma: Report CQ missed events

Chien Tin Tung (1):
      i40iw: Fix parsing of query/commit FPM buffers

Christopher N Bednarz (2):
      i40iw: Use correct alignment for CQ0 memory
      i40iw: Fix potential fcn_id_array out of bounds

Colin Ian King (1):
      IB/hns: fix memory leak on ah on error return path

Maor Gottlieb (1):
      IB/uverbs: Fix NULL pointer dereference during device removal

Mustafa Ismail (2):
      i40iw: Correct variable names
      i40iw: Fix typecast of tcp_seq_num

Shiraz Saleem (1):
      IB/core: Protect sysfs entry on ib_unregister_device

Steve Wise (1):
      iw_cxgb4: fix misuse of integer variable

 drivers/infiniband/core/device.c             |   5 +-
 drivers/infiniband/core/uverbs_main.c        |   2 +-
 drivers/infiniband/hw/cxgb4/mem.c            |   2 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c      |   4 +-
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c     | 123 ++++++++++++++++++-
--------
 drivers/infiniband/hw/i40iw/i40iw_d.h        |   4 +-
 drivers/infiniband/hw/i40iw/i40iw_puda.c     |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_status.h   |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_uk.c       |   8 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c |  17 +++-
 10 files changed, 114 insertions(+), 55 deletions(-)


-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
