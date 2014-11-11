From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 00/17] On demand paging
Date: Tue, 11 Nov 2014 18:36:06 +0200
Message-ID: <1415723783-2138-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Following your comments, we have modified the patch set to eliminate the
possibility of a negative notifiers counter, and removed the atomic accesses
where possible.  The new set have been rebased against upstream, and also
contains some minor fixes detailed below.

We have isolated 5 patches that we think can be taken as a preliminary patches
for the rest of the series. These are the first 5 patches:
	IB/mlx5: Remove per-MR pas and dma pointers
	IB/mlx5: Enhance UMR support to allow partial page table update
	IB/core: Replace ib_umem's offset field with a full address
	IB/core: Add umem function to read data from user-space
	IB/mlx5: Add function to read WQE from user-space

Regards,
Haggai

Changes from V1: http://www.spinics.net/lists/linux-rdma/msg20734.html
- Rebased against latest upstream (3.18-rc2).
- Added patch 1: remove the mr dma and pas fields which are no longer needed.
- Replace extended query device patch 1 with Eli Cohen's recent submission from
  the extended atomic series [1].
- Patch 3: respect umem's page size when calculating offset and start address.
- Patch 8: fix error handling in ib_umem_odp_map_dma_pages
- Patch 9:
  - Add a global mmu notifier counter (per ucontext) to prevent the race that existed in v1.
  - Make accesses to the per-umem notifier counters non-atomic (use ACCESS_ONCE).
  - Rename ucontext->umem_mutex as ucontext->umem_rwsem to reflect it being a semaphore.
- Patch 15: fix error handling in pagefault_single_data_segment
- Patch 17: timeout when waiting for an active mmu notifier to complete
- Add RC RDMA read support to the patch-set.
- Minor fixes.

Changes from V0: http://marc.info/?l=linux-rdma&m=139375790322547&w=2

- Rebased against latest upstream / for-next branch.
- Removed dependency on patches that were accepted upstream.
- Removed pre-patches that were accepted upstream [2].
- Add extended uverb call for querying device (patch 1) and use kernel device
  attributes to report ODP capabilities through the new uverb entry instead of
  having a special verb.
- Allow upgrading page access permissions during page faults.
- Minor fixes to issues that came up during regression testing of the patches.

The following set of patches implements on-demand paging (ODP) support
in the RDMA stack and in the mlx5_ib Infiniband driver.

What is on-demand paging?

Applications register memory with an RDMA adapter using system calls,
and subsequently post IO operations that refer to the corresponding
virtual addresses directly to HW. Until now, this was achieved by
pinning the memory during the registration calls. The goal of on demand
paging is to avoid pinning the pages of registered memory regions (MRs).
This will allow users the same flexibility they get when swapping any
other part of their processes address spaces. Instead of requiring the
entire MR to fit in physical memory, we can allow the MR to be larger,
and only fit the current working set in physical memory.

This can make programming with RDMA much simpler. Today, developers that
are working with more data than their RAM can hold need either to
deregister and reregister memory regions throughout their process's
life, or keep a single memory region and copy the data to it. On demand
paging will allow these developers to register a single MR at the
beginning of their process's life, and let the operating system manage
which pages needs to be fetched at a given time. In the future, we might
be able to provide a single memory access key for each process that
would provide the entire process's address as one large memory region,
and the developers wouldn't need to register memory regions at all.

How does page faults generally work?

With pinned memory regions, the driver would map the virtual addresses
to bus addresses, and pass these addresses to the HCA to associate them
with the new MR. With ODP, the driver is now allowed to mark some of the
pages in the MR as not-present. When the HCA attempts to perform memory
access for a communication operation, it notices the page is not
present, and raises a page fault event to the driver. In addition, the
HCA performs whatever operation is required by the transport protocol to
suspend communication until the page fault is resolved.

Upon receiving the page fault interrupt, the driver first needs to know
on which virtual address the page fault occurred, and on what memory
key. When handling send/receive operations, this information is inside
the work queue. The driver reads the needed work queue elements, and
parses them to gather the address and memory key. For other RDMA
operations, the event generated by the HCA only contains the virtual
address and rkey, as there are no work queue elements involved.

Having the rkey, the driver can find the relevant memory region in its
data structures, and calculate the actual pages needed to complete the
operation. It then uses get_user_pages to retrieve the needed pages back
to the memory, obtains dma mapping, and passes the addresses to the HCA.
Finally, the driver notifies the HCA it can continue operation on the
queue pair that encountered the page fault. The pages that
get_user_pages returned are unpinned immediately by releasing their
reference.

How are invalidations handled?

The patches add infrastructure to subscribe the RDMA stack as an mmu
notifier client [3]. Each process that uses ODP register a notifier client.
When receiving page invalidation notifications, they are passed to the
mlx5_ib driver, which updates the HCA with new, not-present mappings.
Only after flushing the HCA's page table caches the notifier returns,
allowing the kernel to release the pages.

What operations are supported?

Currently only send, receive and RDMA read/write operations are supported on
the RC protocol, and also send operations on the UD protocol. We hope to
implement support for other transports and operations in the future.

The structure of the patchset

Patches 1-5:
These are preliminary patches for IB core and the mlx5 driver that are needed
for the adding paging support. Patch 1 removes unnecessary fields from the
mlx5_ib_mr structs. Patch 2 makes changes to the UMR mechanism (an internal
mechanism used by mlx5 to update device page mappings). The next patch makes
some necessary changes to the ib_umem type. Patches 4-5 add the ability to
read data from a umem, and read a WQE in mlx5_ib, respectively.

Patches 6-9:
The first set of patches adds page fault support to the IB core layer, allowing
MRs to be registered without their pages to be pinned. Patch 6 adds an extended
verb to query device attributes, and patch 7 adds capability bits and
configuration options. Patches 8 and 9 add paging support and invalidation
support respectively.

Patches 10-13:
This set of patches add small size new functionality to the mlx5 driver and
builds toward paging support.  Patch 10 adds infrastructure support for page
fault handling to the mlx5_core module. Patch 11 queries the device for paging
capabilities, and patch 13 adds a function to do partial device page table
updates. 

Patches 14-17:
The final part of this patch set finally adds paging support to the mlx5
driver. Patch 14 adds in mlx5_ib the infrastructure to handle page faults
coming from mlx5_core. Patch 15 adds the code to handle UD send page faults
and RC send and receive page faults. Patch 16 adds support for page faults
caused by RDMA write operations, and patch 17 adds invalidation support to
the mlx5 driver, allowing pages to be unmapped dynamically.

[1] [PATCH v1 for-next 2/5] IB/core: Add support for extended query device caps
    http://www.spinics.net/lists/linux-rdma/msg21958.html

[2] pre-patches that were accepted upstream:
  a74d241 IB/mlx5: Refactor UMR to have its own context struct
  48fea83 IB/mlx5: Set QP offsets and parameters for user QPs and not just for kernel QPs
  b475598 mlx5_core: Store MR attributes in mlx5_mr_core during creation and after UMR
  8605933 IB/mlx5: Add MR to radix tree in reg_mr_callback

[3] Integrating KVM with the Linux Memory Management (presentation),
    Andrea Archangeli
    http://www.linux-kvm.org/wiki/images/3/33/KvmForum2008%24kdf2008_15.pdf

Eli Cohen (1):
  IB/core: Add support for extended query device caps

Haggai Eran (14):
  IB/mlx5: Remove per-MR pas and dma pointers
  IB/mlx5: Enhance UMR support to allow partial page table update
  IB/core: Replace ib_umem's offset field with a full address
  IB/core: Add umem function to read data from user-space
  IB/mlx5: Add function to read WQE from user-space
  IB/core: Implement support for MMU notifiers regarding on demand
    paging regions
  net/mlx5_core: Add support for page faults events and low level
    handling
  IB/mlx5: Implement the ODP capability query verb
  IB/mlx5: Changes in memory region creation to support on-demand
    paging
  IB/mlx5: Add mlx5_ib_update_mtt to update page tables after creation
  IB/mlx5: Page faults handling infrastructure
  IB/mlx5: Handle page faults
  IB/mlx5: Add support for RDMA read/write responder page faults
  IB/mlx5: Implement on demand paging by adding support for MMU
    notifiers

Sagi Grimberg (1):
  IB/core: Add flags for on demand paging support

Shachar Raindel (1):
  IB/core: Add support for on demand paging regions

 drivers/infiniband/Kconfig                   |  11 +
 drivers/infiniband/core/Makefile             |   1 +
 drivers/infiniband/core/umem.c               |  64 ++-
 drivers/infiniband/core/umem_odp.c           | 668 ++++++++++++++++++++++
 drivers/infiniband/core/umem_rbtree.c        |  94 ++++
 drivers/infiniband/core/uverbs.h             |   1 +
 drivers/infiniband/core/uverbs_cmd.c         | 168 ++++--
 drivers/infiniband/core/uverbs_main.c        |   5 +-
 drivers/infiniband/hw/amso1100/c2_provider.c |   2 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c       |   2 +-
 drivers/infiniband/hw/ipath/ipath_mr.c       |   2 +-
 drivers/infiniband/hw/mlx5/Makefile          |   1 +
 drivers/infiniband/hw/mlx5/main.c            |  45 +-
 drivers/infiniband/hw/mlx5/mem.c             |  69 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h         | 116 +++-
 drivers/infiniband/hw/mlx5/mr.c              | 323 +++++++++--
 drivers/infiniband/hw/mlx5/odp.c             | 798 +++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/qp.c              | 199 +++++--
 drivers/infiniband/hw/nes/nes_verbs.c        |   4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |   2 +-
 drivers/infiniband/hw/qib/qib_mr.c           |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c |  39 ++
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 119 ++++
 include/linux/mlx5/device.h                  |  71 ++-
 include/linux/mlx5/driver.h                  |  14 +-
 include/linux/mlx5/qp.h                      |  65 +++
 include/rdma/ib_umem.h                       |  29 +-
 include/rdma/ib_umem_odp.h                   | 160 ++++++
 include/rdma/ib_verbs.h                      |  54 +-
 include/uapi/rdma/ib_user_verbs.h            |  28 +-
 31 files changed, 3008 insertions(+), 161 deletions(-)
 create mode 100644 drivers/infiniband/core/umem_odp.c
 create mode 100644 drivers/infiniband/core/umem_rbtree.c
 create mode 100644 drivers/infiniband/hw/mlx5/odp.c
 create mode 100644 include/rdma/ib_umem_odp.h

-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
