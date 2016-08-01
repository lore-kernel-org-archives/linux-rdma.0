From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 0/7] RDMA subsystem DMA-BUF support
Date: Mon,  1 Aug 2016 09:57:26 +0300
Message-ID: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Bates <stephen.bates-dzo6w/eZyo2tG0bUXCXiUA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Today's PCIe devices are capable of using peer-to-peer transactions to
communicate directly with other devices. This has been shown to improve
latency with communication between a GPU and HCA [1] as well as when
transferring between storage and an HCA [2].

There is some missing functionality in the kernel to support this mode of
operation. The RDMA subsystem uses get_user_pages() to pin user memory for
memory regions used by its devices. There has been some attempts to add
peer-to-peer transaction support to the kernel.

First, some linux-rdma patches that attempted to extend the RDMA subsystem
with a plugin mechanism that would detect user pointers as belonging to a
peer device [3,4] and request the bus address mappings from the plugin.
These has been rejected saying that the RDMA subsystem is not the place to
keep such a plugin mechanism.

Second, in newer kernels the ZONE_DEVICE feature allows persistent memory
devices to describe their pages with a page struct, allowing for example
for a get_user_pages() call from the RDMA stack to succeed. However, the
current ZONE_DEVICE code only supports devices whose memory can be cached
by the CPU, and patches to change that [5] has been rejected so far.

A third, more long term alternative is to use HMM [6]. HMM allows migrating
anonymous memory to a device. It could possibly be extended to allow
requesting a mapping for peer-to-peer access from another device. However,
HMM is complex and it could take a long time until it is accepted.

This patch series attempts to use the existing DMA-BUF mechanism in the
kernel to provide peer-to-peer transaction support for RDMA devices.
DMA-BUF allows one device to attach to a buffer exported by another device.
The series allows an RDMA application to use a new kernel API to create an
RDMA memory region from a DMA-BUF file descriptor handle. The DMA-BUF
object is pinned via the dma_buf_attach() call, and the code then uses
dma_buf_map_attachment to get the mapping to the buffer and registers them
with the RDMA device.

In order to provide an example use of the series, I've added DMA-BUF
support to the NVMe driver. The code adds a ioctl to allocate CMB regions
as DMA-BUF objects. These objects can then be used to register a memory
region with the new API.

The series is structured as follows. The first two patches are preliminary
patches needed for the mlx5_ib driver. They make it easier for the
following patches to post a memory registration request using existing
infrastructure. Patches 3-4 implement helper functions for DMA-BUF
registration in the RDMA subsystem core, and expose a user-space command to
do the registration. Patch 5 implements the new registration command in the
mlx5_ib driver. Finally patches 6-7 add DMA-BUF support to the NVMe driver.

Caveats:
* Without having real NVMe device with CMB support I smoke-tested the
patches with qemu-nvme [7] while assigning a Connect-IB card to the VM.
Naturally this doesn't work. It remains to be tested with real devices on
a system supporting peer to peer.
* GPU devices sometimes require either changing the addresses exposed on
their BARs, or just invalidating them altogether. DMA-BUF however doesn't
have such a mechanism right now, since it assumes cross device accesses
will be short. DMA-BUF would need to be extended with a way to invalidate
an existing attachment and the RDMA stack would need a way to invalidate
existing MRs, similarly to what was done in [3,4].
* It is currently the responsibility of the DMA-BUF exporting code to make
sure the buffer can be mapped for access by the attaching device. It is
not always possible to do that (e.g. when the PCIe topology does not allow
it) or the IOMMU needs to be configured accordingly.
* The scatterlists returned from DMA-BUF in this implementation do not have
a struct page set. This is fine for RDMA as it only needs the DMA
addresses. However, it may cause issues if someone tries to import these
DMA-BUF objects into a driver that tries to use these page structs.

Comments are welcome.

Haggai

[1] Benchmarking GPUDirect RDMA on Modern Server Platforms, Davide Rosetti
    https://devblogs.nvidia.com/parallelforall/benchmarking-gpudirect-rdma-on-modern-server-platforms/
[2] Project Donard: Peer-to-peer Communication with NVM Express Devices,
    Stephen Bates, http://blog.pmcs.com/project-donard-peer-to-peer-communication-with-nvm-express-devices-part-1/
[3] [PATCH V2 for-next 0/9] Peer-Direct support Yishai Hadas,
    https://www.spinics.net/lists/linux-rdma/msg21770.html
[4] [RFC 0/7] Peer-direct memory, Artemy Kovalyov,
    https://www.spinics.net/lists/linux-rdma/msg33294.html
[5] [PATCH RFC 1/1] Add support for ZONE_DEVICE IO memory with struct pages, Stephen Bates
    https://www.spinics.net/lists/linux-rdma/msg34408.html
[6] HMM (Heterogeneous Memory Management), Jérôme Glisse,
    https://lkml.org/lkml/2016/3/8/721
[7] https://github.com/OpenChannelSSD/qemu-nvme

Haggai Eran (7):
  IB/mlx5: Helper for posting work-requests on the UMR QP
  IB/mlx5: Support registration and invalidate operations on the UMR QP
  IB/core: Helpers for mapping DMA-BUF in MRs
  IB/uverbs: Add command to register a DMA-BUF fd
  IB/mlx5: Implement reg_user_dma_buf_mr
  NVMe: Use genalloc to allocate CMB regions
  NVMe: CMB on DMA-BUF

 drivers/infiniband/core/uverbs.h      |   1 +
 drivers/infiniband/core/uverbs_cmd.c  | 111 ++++++++++++
 drivers/infiniband/core/uverbs_main.c |   1 +
 drivers/infiniband/core/verbs.c       |  60 +++++++
 drivers/infiniband/hw/mlx5/main.c     |  10 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h  |   4 +
 drivers/infiniband/hw/mlx5/mr.c       | 149 ++++++++--------
 drivers/infiniband/hw/mlx5/qp.c       |  71 +++++---
 drivers/nvme/host/Makefile            |   2 +-
 drivers/nvme/host/core.c              |  29 ++++
 drivers/nvme/host/dmabuf.c            | 308 ++++++++++++++++++++++++++++++++++
 drivers/nvme/host/nvme-pci.h          |  26 +++
 drivers/nvme/host/nvme.h              |   1 +
 drivers/nvme/host/pci.c               |  60 ++++++-
 include/rdma/ib_verbs.h               |  15 ++
 include/uapi/linux/nvme_ioctl.h       |  11 ++
 include/uapi/rdma/ib_user_verbs.h     |  18 ++
 17 files changed, 778 insertions(+), 99 deletions(-)
 create mode 100644 drivers/nvme/host/dmabuf.c
 create mode 100644 drivers/nvme/host/nvme-pci.h

-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
