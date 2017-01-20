From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 00/37] IB: Optimize DMA mapping
Date: Fri, 20 Jan 2017 13:04:00 -0800
Message-ID: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Doug,

As you know there are two sets of DMA mapping operations in the Linux
kernel:
- One set of DMA mapping operations that is used by most drivers.
- Another set of DMA mapping operations that is only used by the RDMA
  drivers.
Having two types of DMA mapping operations is not only a source of
confusion but also a source of unnecessary overhead. The DMA mapping
operations are in the hot path so it is important that the overhead
of these operations is as low as possible. Hence this patch series
that converts the RDMA code to the standard DMA mapping operations
and thereby eliminates the if (dev->dma_ops) test from the hot path.

The changes compared to version 2 of this patch series are:
- Left out the inlining of the ib_dma_map_*() functions to keep the
  number of patches in this patch series reasonable.
- Reworked this patch series such that (hopefully) the hfi1 and qib
  drivers keep working.

The changes compared to version 1 of this patch series are:
- Patch "Move dma_ops from archdata into struct device" has been
  split into three patches.
- Patch "treewide: Inline ib_dma_map_*() functions" has been split
  into 15 patches (one per driver).
- A patch has been added that builds dma_noop_ops only for the
  architectures that need it.
- The new dma_virt_ops is only built if it is used by a driver.
- In these last 15 patches indentation has been adjusted to keep
  the arguments aligned with the opening parenthesis.

Bart Van Assche (37):
  treewide: Constify most dma_map_ops structures
  treewide: Move dma_ops from struct dev_archdata into struct device
  treewide: Consolidate set_dma_ops() implementations
  treewide: Consolidate get_dma_ops() implementations
  lib/dma-noop: Clarify a comment
  lib/dma-noop: Only build dma_noop_ops for s390 and m32r
  lib/dma-virt: Add dma_virt_ops
  IB/core: Remove ib_dma_*map_single_attrs()
  RDS: IB: Remove an unused structure member
  IB/core: Change the type of an ib_dma_alloc_coherent() argument
  IB/hf1: Remove DMA mapping code
  IB/qib: Remove DMA mapping code
  IB/core: Initialize ib_device.dev.parent earlier
  IB/core: Use dev.parent instead of dma_device
  IB/cxgb3: Set dev.parent instead of dma_device
  IB/cxgb4: Set dev.parent instead of dma_device
  IB/hfi1: Switch from dma_device to dev.parent
  IB/hns: Switch from dma_device to dev.parent
  IB/i40iw: Remove a superfluous assignment statement
  IB/mlx4: Switch from dma_device to dev.parent
  IB/mlx5: Switch from dma_device to dev.parent
  IB/mthca: Switch from dma_device to dev.parent
  IB/nes: Remove a superfluous assignment statement
  IB/ocrdma: Switch from dma_device to dev.parent
  IB/qedr: Switch from dma_device to dev.parent
  IB/qib: Switch from dma_device to dev.parent
  IB/usnic: Switch from dma_device to dev.parent
  IB/vmw_pvrdma: Switch from dma_device to dev.parent
  IB/rxe: Switch from dma_device to dev.parent
  IB/IPoIB: Switch from dma_device to dev.parent
  IB/iser: Switch from dma_device to dev.parent
  IB/srp: Switch from dma_device to dev.parent
  IB/srpt: Modify a debug statement
  RDS: net: Switch from dma_device to dev.parent
  nvme-rdma: Switch from dma_device to dev.parent
  IB/core: Remove ib_device.dma_device
  IB/rxe, IB/rdmavt: Use dma_virt_ops instead of duplicating it

 arch/alpha/include/asm/dma-mapping.h               |   4 +-
 arch/alpha/kernel/pci-noop.c                       |   4 +-
 arch/alpha/kernel/pci_iommu.c                      |   4 +-
 arch/arc/include/asm/dma-mapping.h                 |   4 +-
 arch/arc/mm/dma.c                                  |   2 +-
 arch/arm/common/dmabounce.c                        |   2 +-
 arch/arm/include/asm/device.h                      |   1 -
 arch/arm/include/asm/dma-mapping.h                 |  20 +--
 arch/arm/mm/dma-mapping.c                          |  22 +--
 arch/arm/xen/mm.c                                  |   4 +-
 arch/arm64/include/asm/device.h                    |   1 -
 arch/arm64/include/asm/dma-mapping.h               |  12 +-
 arch/arm64/mm/dma-mapping.c                        |  14 +-
 arch/avr32/include/asm/dma-mapping.h               |   4 +-
 arch/avr32/mm/dma-coherent.c                       |   2 +-
 arch/blackfin/include/asm/dma-mapping.h            |   4 +-
 arch/blackfin/kernel/dma-mapping.c                 |   2 +-
 arch/c6x/include/asm/dma-mapping.h                 |   4 +-
 arch/c6x/kernel/dma.c                              |   2 +-
 arch/cris/arch-v32/drivers/pci/dma.c               |   2 +-
 arch/cris/include/asm/dma-mapping.h                |   6 +-
 arch/frv/include/asm/dma-mapping.h                 |   4 +-
 arch/frv/mb93090-mb00/pci-dma-nommu.c              |   2 +-
 arch/frv/mb93090-mb00/pci-dma.c                    |   2 +-
 arch/h8300/include/asm/dma-mapping.h               |   4 +-
 arch/h8300/kernel/dma.c                            |   2 +-
 arch/hexagon/include/asm/dma-mapping.h             |   7 +-
 arch/hexagon/kernel/dma.c                          |   4 +-
 arch/ia64/hp/common/hwsw_iommu.c                   |   4 +-
 arch/ia64/hp/common/sba_iommu.c                    |   4 +-
 arch/ia64/include/asm/dma-mapping.h                |   7 +-
 arch/ia64/include/asm/machvec.h                    |   4 +-
 arch/ia64/kernel/dma-mapping.c                     |   4 +-
 arch/ia64/kernel/pci-dma.c                         |  10 +-
 arch/ia64/kernel/pci-swiotlb.c                     |   2 +-
 arch/m32r/Kconfig                                  |   1 +
 arch/m32r/include/asm/device.h                     |   1 -
 arch/m32r/include/asm/dma-mapping.h                |   4 +-
 arch/m68k/include/asm/dma-mapping.h                |   4 +-
 arch/m68k/kernel/dma.c                             |   2 +-
 arch/metag/include/asm/dma-mapping.h               |   4 +-
 arch/metag/kernel/dma.c                            |   2 +-
 arch/microblaze/include/asm/dma-mapping.h          |   4 +-
 arch/microblaze/kernel/dma.c                       |   2 +-
 arch/mips/cavium-octeon/dma-octeon.c               |   4 +-
 arch/mips/include/asm/device.h                     |   5 -
 arch/mips/include/asm/dma-mapping.h                |   9 +-
 .../include/asm/mach-cavium-octeon/dma-coherence.h |   2 +-
 arch/mips/include/asm/netlogic/common.h            |   2 +-
 arch/mips/loongson64/common/dma-swiotlb.c          |   2 +-
 arch/mips/mm/dma-default.c                         |   4 +-
 arch/mips/netlogic/common/nlm-dma.c                |   2 +-
 arch/mips/pci/pci-octeon.c                         |   2 +-
 arch/mn10300/include/asm/dma-mapping.h             |   4 +-
 arch/mn10300/mm/dma-alloc.c                        |   2 +-
 arch/nios2/include/asm/dma-mapping.h               |   4 +-
 arch/nios2/mm/dma-mapping.c                        |   2 +-
 arch/openrisc/include/asm/dma-mapping.h            |   4 +-
 arch/openrisc/kernel/dma.c                         |   2 +-
 arch/parisc/include/asm/dma-mapping.h              |   8 +-
 arch/parisc/kernel/drivers.c                       |   2 +-
 arch/parisc/kernel/pci-dma.c                       |   4 +-
 arch/powerpc/include/asm/device.h                  |   4 -
 arch/powerpc/include/asm/dma-mapping.h             |  14 +-
 arch/powerpc/include/asm/pci.h                     |   4 +-
 arch/powerpc/include/asm/ps3.h                     |   2 +-
 arch/powerpc/include/asm/swiotlb.h                 |   2 +-
 arch/powerpc/kernel/dma-swiotlb.c                  |   2 +-
 arch/powerpc/kernel/dma.c                          |   8 +-
 arch/powerpc/kernel/pci-common.c                   |   6 +-
 arch/powerpc/platforms/cell/iommu.c                |   6 +-
 arch/powerpc/platforms/pasemi/iommu.c              |   2 +-
 arch/powerpc/platforms/pasemi/setup.c              |   2 +-
 arch/powerpc/platforms/powernv/npu-dma.c           |   2 +-
 arch/powerpc/platforms/ps3/system-bus.c            |   8 +-
 arch/powerpc/platforms/pseries/ibmebus.c           |   4 +-
 arch/powerpc/platforms/pseries/vio.c               |   2 +-
 arch/s390/Kconfig                                  |   1 +
 arch/s390/include/asm/device.h                     |   1 -
 arch/s390/include/asm/dma-mapping.h                |   6 +-
 arch/s390/pci/pci.c                                |   2 +-
 arch/s390/pci/pci_dma.c                            |   2 +-
 arch/sh/include/asm/dma-mapping.h                  |   4 +-
 arch/sh/kernel/dma-nommu.c                         |   2 +-
 arch/sh/mm/consistent.c                            |   2 +-
 arch/sparc/include/asm/dma-mapping.h               |  10 +-
 arch/sparc/kernel/iommu.c                          |   4 +-
 arch/sparc/kernel/ioport.c                         |   8 +-
 arch/sparc/kernel/pci_sun4v.c                      |   2 +-
 arch/tile/include/asm/device.h                     |   3 -
 arch/tile/include/asm/dma-mapping.h                |  20 +--
 arch/tile/kernel/pci-dma.c                         |  24 +--
 arch/unicore32/include/asm/dma-mapping.h           |   4 +-
 arch/unicore32/mm/dma-swiotlb.c                    |   2 +-
 arch/x86/include/asm/device.h                      |   5 +-
 arch/x86/include/asm/dma-mapping.h                 |  11 +-
 arch/x86/include/asm/iommu.h                       |   2 +-
 arch/x86/kernel/amd_gart_64.c                      |   2 +-
 arch/x86/kernel/pci-calgary_64.c                   |   6 +-
 arch/x86/kernel/pci-dma.c                          |   4 +-
 arch/x86/kernel/pci-nommu.c                        |   2 +-
 arch/x86/kernel/pci-swiotlb.c                      |   2 +-
 arch/x86/pci/common.c                              |   2 +-
 arch/x86/pci/sta2x11-fixup.c                       |  10 +-
 arch/x86/xen/pci-swiotlb-xen.c                     |   2 +-
 arch/xtensa/include/asm/device.h                   |   4 -
 arch/xtensa/include/asm/dma-mapping.h              |   9 +-
 arch/xtensa/kernel/pci-dma.c                       |   2 +-
 drivers/infiniband/core/device.c                   |   9 +
 drivers/infiniband/core/sysfs.c                    |   2 +-
 drivers/infiniband/core/ucm.c                      |   2 +-
 drivers/infiniband/core/user_mad.c                 |   4 +-
 drivers/infiniband/core/uverbs_main.c              |   2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |   2 +-
 drivers/infiniband/hw/cxgb4/provider.c             |   2 +-
 drivers/infiniband/hw/hfi1/dma.c                   | 183 -------------------
 drivers/infiniband/hw/hfi1/mad.c                   |   2 +-
 drivers/infiniband/hw/hfi1/verbs.c                 |   2 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   2 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          |   1 -
 drivers/infiniband/hw/mlx4/main.c                  |   2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   2 +-
 drivers/infiniband/hw/mlx4/mr.c                    |   6 +-
 drivers/infiniband/hw/mlx5/main.c                  |   2 +-
 drivers/infiniband/hw/mlx5/mr.c                    |  14 +-
 drivers/infiniband/hw/mthca/mthca_provider.c       |   2 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |   1 -
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |   2 +-
 drivers/infiniband/hw/qedr/main.c                  |   2 +-
 drivers/infiniband/hw/qib/qib_dma.c                | 169 ------------------
 drivers/infiniband/hw/qib/qib_keys.c               |   5 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |   2 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c        |   2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c     |   2 +-
 drivers/infiniband/sw/rdmavt/Kconfig               |   1 +
 drivers/infiniband/sw/rdmavt/Makefile              |   2 +-
 drivers/infiniband/sw/rdmavt/dma.c                 | 198 ---------------------
 drivers/infiniband/sw/rdmavt/dma.h                 |  53 ------
 drivers/infiniband/sw/rdmavt/mr.c                  |   8 +-
 drivers/infiniband/sw/rdmavt/vt.c                  |   4 +-
 drivers/infiniband/sw/rdmavt/vt.h                  |   1 -
 drivers/infiniband/sw/rxe/Kconfig                  |   1 +
 drivers/infiniband/sw/rxe/Makefile                 |   1 -
 drivers/infiniband/sw/rxe/rxe_dma.c                | 183 -------------------
 drivers/infiniband/sw/rxe/rxe_loc.h                |   2 -
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   9 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c       |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   2 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c           |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   4 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   3 +-
 drivers/iommu/amd_iommu.c                          |  10 +-
 drivers/misc/mic/bus/mic_bus.c                     |   4 +-
 drivers/misc/mic/bus/scif_bus.c                    |   4 +-
 drivers/misc/mic/bus/scif_bus.h                    |   2 +-
 drivers/misc/mic/bus/vop_bus.c                     |   2 +-
 drivers/misc/mic/host/mic_boot.c                   |   4 +-
 drivers/nvme/host/rdma.c                           |   2 +-
 drivers/parisc/ccio-dma.c                          |   2 +-
 drivers/parisc/sba_iommu.c                         |   2 +-
 drivers/pci/host/vmd.c                             |   2 +-
 include/linux/device.h                             |   1 +
 include/linux/dma-mapping.h                        |  55 +++---
 include/linux/mic_bus.h                            |   2 +-
 include/rdma/ib_verbs.h                            | 143 ++-------------
 include/xen/arm/hypervisor.h                       |   2 +-
 lib/Kconfig                                        |  10 ++
 lib/Makefile                                       |   3 +-
 lib/dma-noop.c                                     |   4 +-
 lib/dma-virt.c                                     |  72 ++++++++
 net/rds/ib.h                                       |   8 +-
 net/rds/ib_mr.h                                    |   1 -
 173 files changed, 437 insertions(+), 1298 deletions(-)
 delete mode 100644 drivers/infiniband/hw/hfi1/dma.c
 delete mode 100644 drivers/infiniband/hw/qib/qib_dma.c
 delete mode 100644 drivers/infiniband/sw/rdmavt/dma.c
 delete mode 100644 drivers/infiniband/sw/rdmavt/dma.h
 delete mode 100644 drivers/infiniband/sw/rxe/rxe_dma.c
 create mode 100644 lib/dma-virt.c

-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
