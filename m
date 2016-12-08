From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH, RFC 0/5] IB: Optimize DMA mapping
Date: Thu, 8 Dec 2016 08:51:34 -0800
Message-ID: <6dbaf73f-91d7-eb0f-68a7-cdb8b1ab1d26@sandisk.com>
References: <07c07529-4636-fafb-2598-7358d8a1460d@sandisk.com>
 <CAJ3xEMi4HY9Ehp-V4rP5UieAk=GjAu0X4uEnP-yMDomcFDpHkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMi4HY9Ehp-V4rP5UieAk=GjAu0X4uEnP-yMDomcFDpHkA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/07/2016 10:48 PM, Or Gerlitz wrote:
> On Thu, Dec 8, 2016 at 3:10 AM, Bart Van Assche
> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>> The DMA mapping operations are in the hot path so it is important that the
>> overhead of these operations is as low as possible. There has been a reason
>> in the past to have DMA mapping operations that are specific to the IB
>> subsystem but that reason no longer exists today.
> 
> can you elaborate on that a little further... I recall it was
> something with the ipath and Co
> drivers and memory extensions on 32 bit systems?
> 
>> An additional benefit is that the size of HW and SW
>> drivers that do not use DMA is reduced by switching to dma_noop_ops.
> 
> few words on that?

Hello Or,

The following two patches removed the dma_address and dma_len callback
functions from struct ib_dma_mapping_ops:

commit 446bf432a9b084d9f3471eca309cc53fa434ccc7
Author: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri Mar 28 13:26:42 2014 -0400

    IB/qib: Remove ib_sg_dma_address() and ib_sg_dma_len() overloads

commit ea58a595657db88f55b5159442fdf0e34e1b4d95
Author: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri Mar 28 13:26:59 2014 -0400

    IB/core: Remove overload in ib_sg_dma*

Regarding your second question: all the struct ib_dma_mapping_ops
instances that exist today have the same functionality as the functions
in dma_noop_ops but with slightly different calling conventions. Hence
the switch to dma_noop_ops.

In case anyone would like to see the diffstat for the entire patch
series, it is as follows:

 b/arch/alpha/include/asm/dma-mapping.h                     |    4 
 b/arch/alpha/kernel/pci-noop.c                             |    4 
 b/arch/alpha/kernel/pci_iommu.c                            |    4 
 b/arch/arc/include/asm/dma-mapping.h                       |    4 
 b/arch/arc/mm/dma.c                                        |    2 
 b/arch/arm/common/dmabounce.c                              |    2 
 b/arch/arm/include/asm/device.h                            |    1 
 b/arch/arm/include/asm/dma-mapping.h                       |   23 
 b/arch/arm/include/asm/xen/hypervisor.h                    |    2 
 b/arch/arm/mm/dma-mapping.c                                |   22 
 b/arch/arm/xen/mm.c                                        |    4 
 b/arch/arm64/include/asm/device.h                          |    1 
 b/arch/arm64/include/asm/dma-mapping.h                     |   14 
 b/arch/arm64/mm/dma-mapping.c                              |   14 
 b/arch/avr32/include/asm/dma-mapping.h                     |    4 
 b/arch/avr32/mm/dma-coherent.c                             |    2 
 b/arch/blackfin/include/asm/dma-mapping.h                  |    4 
 b/arch/blackfin/kernel/dma-mapping.c                       |    2 
 b/arch/c6x/include/asm/dma-mapping.h                       |    4 
 b/arch/c6x/kernel/dma.c                                    |    2 
 b/arch/cris/arch-v32/drivers/pci/dma.c                     |    2 
 b/arch/cris/include/asm/dma-mapping.h                      |    6 
 b/arch/frv/include/asm/dma-mapping.h                       |    4 
 b/arch/frv/mb93090-mb00/pci-dma-nommu.c                    |    2 
 b/arch/frv/mb93090-mb00/pci-dma.c                          |    2 
 b/arch/h8300/include/asm/dma-mapping.h                     |    4 
 b/arch/h8300/kernel/dma.c                                  |    2 
 b/arch/hexagon/include/asm/dma-mapping.h                   |    7 
 b/arch/hexagon/kernel/dma.c                                |    4 
 b/arch/ia64/hp/common/hwsw_iommu.c                         |    4 
 b/arch/ia64/hp/common/sba_iommu.c                          |    4 
 b/arch/ia64/include/asm/dma-mapping.h                      |    7 
 b/arch/ia64/include/asm/machvec.h                          |    4 
 b/arch/ia64/kernel/dma-mapping.c                           |    4 
 b/arch/ia64/kernel/pci-dma.c                               |   10 
 b/arch/ia64/kernel/pci-swiotlb.c                           |    2 
 b/arch/m68k/include/asm/dma-mapping.h                      |    4 
 b/arch/m68k/kernel/dma.c                                   |    2 
 b/arch/metag/include/asm/dma-mapping.h                     |    4 
 b/arch/metag/kernel/dma.c                                  |    2 
 b/arch/microblaze/include/asm/dma-mapping.h                |    4 
 b/arch/microblaze/kernel/dma.c                             |    2 
 b/arch/mips/cavium-octeon/dma-octeon.c                     |    4 
 b/arch/mips/include/asm/device.h                           |    5 
 b/arch/mips/include/asm/dma-mapping.h                      |    9 
 b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h |    2 
 b/arch/mips/include/asm/netlogic/common.h                  |    2 
 b/arch/mips/loongson64/common/dma-swiotlb.c                |    2 
 b/arch/mips/mm/dma-default.c                               |    4 
 b/arch/mips/netlogic/common/nlm-dma.c                      |    2 
 b/arch/mips/pci/pci-octeon.c                               |    2 
 b/arch/mn10300/include/asm/dma-mapping.h                   |    4 
 b/arch/mn10300/mm/dma-alloc.c                              |    2 
 b/arch/nios2/include/asm/dma-mapping.h                     |    4 
 b/arch/nios2/mm/dma-mapping.c                              |    2 
 b/arch/openrisc/include/asm/dma-mapping.h                  |    4 
 b/arch/openrisc/kernel/dma.c                               |    2 
 b/arch/parisc/include/asm/dma-mapping.h                    |    8 
 b/arch/parisc/kernel/drivers.c                             |    2 
 b/arch/parisc/kernel/pci-dma.c                             |    4 
 b/arch/powerpc/include/asm/device.h                        |    4 
 b/arch/powerpc/include/asm/dma-mapping.h                   |   19 
 b/arch/powerpc/include/asm/pci.h                           |    4 
 b/arch/powerpc/include/asm/ps3.h                           |    2 
 b/arch/powerpc/include/asm/swiotlb.h                       |    2 
 b/arch/powerpc/kernel/dma-swiotlb.c                        |    2 
 b/arch/powerpc/kernel/dma.c                                |    8 
 b/arch/powerpc/kernel/ibmebus.c                            |    4 
 b/arch/powerpc/kernel/pci-common.c                         |    6 
 b/arch/powerpc/kernel/vio.c                                |    2 
 b/arch/powerpc/platforms/cell/iommu.c                      |    6 
 b/arch/powerpc/platforms/pasemi/iommu.c                    |    2 
 b/arch/powerpc/platforms/pasemi/setup.c                    |    2 
 b/arch/powerpc/platforms/powernv/npu-dma.c                 |    2 
 b/arch/powerpc/platforms/ps3/system-bus.c                  |    8 
 b/arch/s390/include/asm/device.h                           |    1 
 b/arch/s390/include/asm/dma-mapping.h                      |    6 
 b/arch/s390/pci/pci.c                                      |    2 
 b/arch/s390/pci/pci_dma.c                                  |    2 
 b/arch/sh/include/asm/dma-mapping.h                        |    4 
 b/arch/sh/kernel/dma-nommu.c                               |    2 
 b/arch/sh/mm/consistent.c                                  |    2 
 b/arch/sparc/include/asm/dma-mapping.h                     |   10 
 b/arch/sparc/kernel/iommu.c                                |    4 
 b/arch/sparc/kernel/ioport.c                               |    8 
 b/arch/sparc/kernel/pci_sun4v.c                            |    2 
 b/arch/tile/include/asm/device.h                           |    3 
 b/arch/tile/include/asm/dma-mapping.h                      |   20 
 b/arch/tile/kernel/pci-dma.c                               |   24 -
 b/arch/unicore32/include/asm/dma-mapping.h                 |    4 
 b/arch/unicore32/mm/dma-swiotlb.c                          |    2 
 b/arch/x86/include/asm/device.h                            |    5 
 b/arch/x86/include/asm/dma-mapping.h                       |   11 
 b/arch/x86/include/asm/iommu.h                             |    2 
 b/arch/x86/kernel/amd_gart_64.c                            |    2 
 b/arch/x86/kernel/pci-calgary_64.c                         |    6 
 b/arch/x86/kernel/pci-dma.c                                |    4 
 b/arch/x86/kernel/pci-nommu.c                              |    2 
 b/arch/x86/kernel/pci-swiotlb.c                            |    2 
 b/arch/x86/pci/common.c                                    |    2 
 b/arch/x86/pci/sta2x11-fixup.c                             |   10 
 b/arch/x86/xen/pci-swiotlb-xen.c                           |    2 
 b/arch/xtensa/include/asm/device.h                         |    4 
 b/arch/xtensa/include/asm/dma-mapping.h                    |    9 
 b/arch/xtensa/kernel/pci-dma.c                             |    2 
 b/drivers/infiniband/core/mad.c                            |   28 -
 b/drivers/infiniband/core/rw.c                             |   30 -
 b/drivers/infiniband/core/umem.c                           |    4 
 b/drivers/infiniband/core/umem_odp.c                       |    6 
 b/drivers/infiniband/hw/mlx4/cq.c                          |    2 
 b/drivers/infiniband/hw/mlx4/mad.c                         |   28 -
 b/drivers/infiniband/hw/mlx4/mr.c                          |    4 
 b/drivers/infiniband/hw/mlx4/qp.c                          |   10 
 b/drivers/infiniband/hw/mlx5/mr.c                          |    4 
 b/drivers/infiniband/hw/qib/qib_keys.c                     |    2 
 b/drivers/infiniband/sw/rdmavt/Makefile                    |    2 
 b/drivers/infiniband/sw/rdmavt/mr.c                        |    4 
 b/drivers/infiniband/sw/rdmavt/vt.c                        |    4 
 b/drivers/infiniband/sw/rdmavt/vt.h                        |    1 
 b/drivers/infiniband/sw/rxe/Makefile                       |    1 
 b/drivers/infiniband/sw/rxe/rxe_loc.h                      |    2 
 b/drivers/infiniband/sw/rxe/rxe_verbs.c                    |    2 
 b/drivers/infiniband/ulp/ipoib/ipoib_cm.c                  |   20 
 b/drivers/infiniband/ulp/ipoib/ipoib_ib.c                  |   22 
 b/drivers/infiniband/ulp/iser/iscsi_iser.c                 |    6 
 b/drivers/infiniband/ulp/iser/iser_initiator.c             |   38 -
 b/drivers/infiniband/ulp/iser/iser_memory.c                |   12 
 b/drivers/infiniband/ulp/iser/iser_verbs.c                 |    2 
 b/drivers/infiniband/ulp/isert/ib_isert.c                  |   54 +-
 b/drivers/infiniband/ulp/srp/ib_srp.c                      |   50 +-
 b/drivers/infiniband/ulp/srpt/ib_srpt.c                    |   12 
 b/drivers/iommu/amd_iommu.c                                |   10 
 b/drivers/misc/mic/bus/mic_bus.c                           |    4 
 b/drivers/misc/mic/bus/scif_bus.c                          |    4 
 b/drivers/misc/mic/bus/scif_bus.h                          |    2 
 b/drivers/misc/mic/bus/vop_bus.c                           |    2 
 b/drivers/misc/mic/host/mic_boot.c                         |    4 
 b/drivers/nvme/host/rdma.c                                 |   22 
 b/drivers/nvme/target/rdma.c                               |   20 
 b/drivers/parisc/ccio-dma.c                                |    2 
 b/drivers/parisc/sba_iommu.c                               |    2 
 b/drivers/pci/host/vmd.c                                   |    2 
 b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h      |   14 
 b/include/linux/device.h                                   |    2 
 b/include/linux/dma-mapping.h                              |   54 +-
 b/include/linux/mic_bus.h                                  |    2 
 b/include/rdma/ib_verbs.h                                  |  310 -------------
 b/lib/dma-noop.c                                           |    2 
 b/net/9p/trans_rdma.c                                      |   12 
 b/net/rds/ib.h                                             |   14 
 b/net/rds/ib_cm.c                                          |   12 
 b/net/rds/ib_fmr.c                                         |   10 
 b/net/rds/ib_frmr.c                                        |    8 
 b/net/rds/ib_rdma.c                                        |    6 
 b/net/rds/ib_recv.c                                        |   14 
 b/net/rds/ib_send.c                                        |   26 -
 b/net/sunrpc/xprtrdma/fmr_ops.c                            |    6 
 b/net/sunrpc/xprtrdma/frwr_ops.c                           |    6 
 b/net/sunrpc/xprtrdma/rpc_rdma.c                           |   14 
 b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c               |    4 
 b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c                  |    8 
 b/net/sunrpc/xprtrdma/svc_rdma_sendto.c                    |   14 
 b/net/sunrpc/xprtrdma/svc_rdma_transport.c                 |    8 
 b/net/sunrpc/xprtrdma/verbs.c                              |    8 
 drivers/infiniband/hw/hfi1/dma.c                           |  183 -------
 drivers/infiniband/hw/qib/qib_dma.c                        |  169 -------
 drivers/infiniband/sw/rdmavt/dma.c                         |  198 --------
 drivers/infiniband/sw/rdmavt/dma.h                         |   53 --
 drivers/infiniband/sw/rxe/rxe_dma.c                        |  183 -------
 169 files changed, 553 insertions(+), 1712 deletions(-)

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
