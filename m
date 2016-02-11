From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 0/7] Peer-direct memory
Date: Thu, 11 Feb 2016 18:12:50 +0200
Message-ID: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-Dj0/KMMU01E@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following set of patches implements Peer-Direct support
over RDMA stack.

Peer-Direct technology allows RDMA operations to directly target memory
in external hardware devices, such as GPU cards, SSD based storage,
dedicated ASIC accelerators, etc.

This technology allows RDMA-based (over InfiniBand/RoCE) application to avoid
unneeded data copying when sharing data between peer hardware devices.

Recently introduced ZONE_DEVICE patch [1] allows to register devices as
providers of "device memory" regions, making RDMA operation with them
transparantly available. This patch is intended for scenarios which not fit
into ZONE_DEVICE infrastrcture, but device still want to exposure it's
IO regions to RDMA access.

To implement this technology, we defined an API to securely expose the memory
of a hardware device (peer memory) to an RDMA hardware device.

This cover letter describes the API defined for Peer-Direct.
It also details the required implementation for a hardware device to expose
memory buffers over Peer-Direct.

In addition, it describes the flow and the API that IB core and low level IB hardware
drivers implement to support the technology

Flow:
-----------------
Each peer memory should register itself into the IB core (ib_core) module, and
provide a set of callbacks to manage its memory basic functionality.

The required functionality includes getting pages descriptors based upon user space
virtual address, dma mapping these pages, getting the memory page size,
removing the DMA mapping of the pages and releasing page descriptors.
Those callbacks are quite similar to the kernel API used to pin normal host memory
and exposed it to the hardware.
Detailed description of the API is included later in this cover letter.

The peer direct controller, implemented as part of the IB core services, provides registry
and brokering services between peer memory providers and low level IB hardware drivers.
This makes the usage of peer-direct almost completely transparent to the individual hardware drivers.
The only changes required in the low level IB hardware drivers is supporting an interface
for immediate invalidation of registered memory regions.

The IB hardware driver should use ib_umem_get with an extra signaling
that the requested memory may reside on a peer memory. When a given
user space virtual memory address found to belong to a peer memory
client, an ib_umem is built using the callbacks provided by the peer
memory client. In case the IB hardware driver supports invalidation
on that ib_umem it must be signaled as part of ib_umem_get, otherwise
if the peer memory requires invalidation support the registration will
be rejected.

After getting the ib_umem, if it is residing on a peer memory that requires
invalidation support, the low level IB hardware driver must register the
invalidation callback for this ib_umem.
If this callback is called, the driver should ensure that no access to
the memory mapped by the umem will happen once the callback returns.

===============================================================================
Peer memory API
===============================================================================

Peer client structure:
-------------------------------------------------------------------------------
struct peer_memory_client {
       int (*acquire) (unsigned long addr, size_t size, void **client_context);
       int (*get_pages) (unsigned long addr, size_t size, int write, int force,
			 struct sg_table *sg_head,
			 void *client_context, void *core_context);
       int (*dma_map) (struct sg_table *sg_head, void *client_context,
		       struct device *dma_device, int dmasync, int *nmap);
       int (*dma_unmap) (struct sg_table *sg_head, void *client_context,
			 struct device  *dma_device);
       void (*put_pages) (struct sg_table *sg_head, void *client_context);
       unsigned long (*get_page_size) (void *client_context);
       void (*release) (void *client_context);

};

A detailed description of above callbacks is defined as part of the first patch
in peer_mem.h header file.
-----------------------------------------------------------------------------------
void *ib_register_peer_memory_client(struct peer_memory_client *peer_client,
				     int (**invalidate_callback)
				     (void *reg_handle, u64 core_context));

Description:
Each peer memory should use this function to register as an available
peer memory client during its initialization. The callbacks provided
as part of the peer_client may be used later on by the IB core when
registering and unregistering its memory. When the invalidation callback
returns, the user of the allocation is guaranteed not to access it.

----------------------------------------------------------------------------------

void ib_unregister_peer_memory_client(void *reg_handle);

Description:
On unload, the peer memory client must unregister itself, to prevent
any additional callbacks to the unloaded module.

----------------------------------------------------------------------------------

The structure of the patchset

Patches 1-3:
This set of patches introduces the API, adds the required support to the IB core layer,
allowing Peers to be registered and be part of the flow. The first
patch introduces the API, the next two patches add the infrastructure to manage peer client
and use its registration callbacks.

Patches 4-5,7:
Those patches add the required functionality for peers to notify IB core that
a specific registration should be invalidated.

Patch 6:
This patch adds kernel module allowing RDMA transfers with various types of memory
like mmaped devices (that create PFN mappings) and mmaped files from DAX
filesystems.

[1] https://lkml.org/lkml/2015/8/25/841

Artemy Kovalyov (7):
  IB/core: Introduce peer client interface
  IB/core: Get/put peer memory client
  IB/core: Umem tunneling peer memory APIs
  IB/core: Infrastructure to manage peer core context
  IB/core: Invalidation support for peer memory
  IB/core: Peer memory client for IO memory
  IB/mlx5: Invalidation support for MR over peer memory

 drivers/infiniband/Kconfig            |  19 ++
 drivers/infiniband/core/Makefile      |   5 +
 drivers/infiniband/core/io_peer_mem.c | 332 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/peer_mem.c    | 304 +++++++++++++++++++++++++++++++
 drivers/infiniband/core/umem.c        | 138 +++++++++++++-
 drivers/infiniband/hw/mlx5/cq.c       |  15 +-
 drivers/infiniband/hw/mlx5/doorbell.c |   6 +-
 drivers/infiniband/hw/mlx5/main.c     |   3 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h  |  12 ++
 drivers/infiniband/hw/mlx5/mr.c       | 166 +++++++++++++----
 drivers/infiniband/hw/mlx5/qp.c       |   3 +-
 drivers/infiniband/hw/mlx5/srq.c      |   4 +-
 include/rdma/ib_peer_mem.h            |  76 ++++++++
 include/rdma/ib_umem.h                |  61 ++++++-
 include/rdma/ib_verbs.h               |   5 +
 include/rdma/peer_mem.h               | 238 ++++++++++++++++++++++++
 16 files changed, 1330 insertions(+), 57 deletions(-)
 create mode 100644 drivers/infiniband/core/io_peer_mem.c
 create mode 100644 drivers/infiniband/core/peer_mem.c
 create mode 100644 include/rdma/ib_peer_mem.h
 create mode 100644 include/rdma/peer_mem.h

-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
