From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] Please pull infiniband.git
Date: Thu, 05 Aug 2010 14:37:44 -0700
Message-ID: <adak4o43fmf.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the 2.6.36 merge window pile, which actually does not
include anything big this time around.

Aleksey Senin (1):
      IB: Rename RAW_ETY to RAW_ETHERTYPE

Alexander Schmidt (3):
      IB/ehca: Fix bitmask handling for lock_hcalls
      IB/ehca: Catch failing ioremap()
      IB/ehca: Init irq tasklet before irq can happen

Arnd Bergmann (1):
      IB/qib: Use generic_file_llseek

Bart Van Assche (3):
      IB/srp: Use print_hex_dump()
      IB/srp: Make receive buffer handling more robust
      IB/srp: Export req_lim via sysfs

Ben Hutchings (1):
      IB/ipath: Fix probe failure path

Chien Tung (1):
      RDMA/nes: Store and print eeprom version

Dan Carpenter (2):
      RDMA/cxgb4: Remove unneeded assignment
      RDMA/cxgb3: Clean up signed check of unsigned variable

Dave Olson (1):
      IB/qib: Allow PSM to select from multiple port assignment algorithms

David Miller (1):
      IB/qib: Add missing <linux/slab.h> include

David Rientjes (1):
      RDMA/cxgb4: Remove dependency on __GFP_NOFAIL

Faisal Latif (1):
      RDMA/nes: Fix hangs on ifdown

Ira Weiny (1):
      IB/qib: Allow writes to the diag_counters to be able to clear them

Julia Lawall (1):
      IB/ehca: Drop unnecessary NULL test

Miroslaw Walukiewicz (1):
      RDMA/nes: Read firmware version from correct place

Or Gerlitz (3):
      IB/iser: Make needlessly global iser_alloc_rx_descriptors() static
      RDMA/cxgb3: Make needlessly global iwch_l2t_send() static
      RDMA/nes: Fix two sparse warnings

Peter Huewe (1):
      RDMA/nes: Convert pci_table entries to PCI_VDEVICE

Ralph Campbell (5):
      IB/qib: Avoid variable-length array
      IB/qib: Turn off IB latency mode
      IB/qib: Set cfgctxts to number of CPUs by default
      IB/qib: Limit the number of packets processed per interrupt
      IB/qib: Fix race between qib_error_qp() and receive packet processing

Roland Dreier (8):
      IB/umad: Remove unused-but-set variable 'already_dead'
      RDMA/nes: Rewrite expression to avoid undefined semantics
      RDMA/cxgb4: Remove unneeded NULL check
      RDMA/nes: Get rid of "set but not used" variables
      RDMA/nes: Fix showing wqm_quanta
      RDMA/nes: Fix misindented code
      RDMA/nes: Fix confusing if statement indentation
      Merge branches 'cxgb3', 'cxgb4', 'ehca', 'ipath', 'misc', 'nes', 'qib' and 'srp' into for-next

Sean Hefty (1):
      IB/cm: Check LAP state before sending an MRA

Steve Wise (6):
      RDMA/cxgb4: Add module option to tweak delayed ack
      RDMA/cxgb4: Support variable sized work requests
      RDMA/cxgb4: Fix race in fini path
      RDMA/cxgb4: Use correct control txq
      RDMA/cxgb4: Set/reset the EP timer inside EP lock
      RDMA/cxgb4: Add timeouts when waiting for FW responses

 drivers/infiniband/core/cm.c                 |   10 +-
 drivers/infiniband/core/user_mad.c           |    2 -
 drivers/infiniband/core/verbs.c              |    4 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c        |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c        |    4 +-
 drivers/infiniband/hw/cxgb4/cm.c             |   91 ++++++-----
 drivers/infiniband/hw/cxgb4/cq.c             |    4 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h       |    1 +
 drivers/infiniband/hw/cxgb4/mem.c            |    2 +-
 drivers/infiniband/hw/cxgb4/qp.c             |  240 +++++++++++++------------
 drivers/infiniband/hw/cxgb4/t4.h             |   32 ++--
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h    |   10 +
 drivers/infiniband/hw/ehca/ehca_eq.c         |    8 +-
 drivers/infiniband/hw/ehca/ehca_main.c       |    3 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c       |    5 -
 drivers/infiniband/hw/ehca/ehca_qp.c         |    2 +-
 drivers/infiniband/hw/ehca/hcp_if.c          |   32 +++-
 drivers/infiniband/hw/ehca/hcp_phyp.c        |   11 +-
 drivers/infiniband/hw/ehca/hcp_phyp.h        |    2 +-
 drivers/infiniband/hw/ipath/ipath_driver.c   |   13 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c      |    2 +-
 drivers/infiniband/hw/nes/nes.c              |   37 ++---
 drivers/infiniband/hw/nes/nes.h              |    2 +
 drivers/infiniband/hw/nes/nes_cm.c           |   10 +-
 drivers/infiniband/hw/nes/nes_hw.c           |   23 ++-
 drivers/infiniband/hw/nes/nes_hw.h           |    3 +-
 drivers/infiniband/hw/nes/nes_nic.c          |   15 +-
 drivers/infiniband/hw/nes/nes_utils.c        |    5 +
 drivers/infiniband/hw/nes/nes_verbs.c        |   21 ++-
 drivers/infiniband/hw/qib/qib.h              |    4 +
 drivers/infiniband/hw/qib/qib_common.h       |   16 ++-
 drivers/infiniband/hw/qib/qib_driver.c       |    2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c     |  203 +++++++++++-----------
 drivers/infiniband/hw/qib/qib_fs.c           |   18 +-
 drivers/infiniband/hw/qib/qib_iba7322.c      |    4 +-
 drivers/infiniband/hw/qib/qib_init.c         |    2 +-
 drivers/infiniband/hw/qib/qib_qp.c           |    2 +-
 drivers/infiniband/hw/qib/qib_rc.c           |   47 ++----
 drivers/infiniband/hw/qib/qib_sdma.c         |    2 +
 drivers/infiniband/hw/qib/qib_sysfs.c        |   21 ++-
 drivers/infiniband/hw/qib/qib_tx.c           |    2 +-
 drivers/infiniband/hw/qib/qib_uc.c           |    6 -
 drivers/infiniband/hw/qib/qib_ud.c           |   17 +--
 drivers/infiniband/hw/qib/qib_verbs.c        |    7 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c          |  118 +++++++------
 include/rdma/ib_verbs.h                      |    2 +-
 47 files changed, 576 insertions(+), 495 deletions(-)

-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
