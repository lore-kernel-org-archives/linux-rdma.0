From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/9] Peer-Direct support
Date: Wed,  1 Oct 2014 18:18:28 +0300
Message-ID: <1412176717-11979-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following set of patches implements Peer-Direct support over RDMA
stack.
    
Peer-Direct technology allows RDMA operations to directly target
memory in external hardware devices, such as GPU cards, SSD based
storage, dedicated ASIC accelerators, etc.
    
This technology allows RDMA-based (over InfiniBand/RoCE) application
to avoid unneeded data copying when sharing data between peer hardware
devices.
    
To implement this technology, we defined an API to securely expose the
memory of a hardware device (peer memory) to an RDMA hardware device.
    
The API defined for Peer-Direct is described in this cover letter.
The required implementation for a hardware device to expose memory
buffers over Peer-Direct is also detailed in this letter.
    
Finally, the cover letter includes a description of the flow and the
API that IB core and low level IB hardware drivers implement to
support the technology

Flow:
-----------------
Each peer memory client should register itself into the IB core (ib_core)
module, and provide a set of callbacks to manage its memory basic
functionality.

The required functionality includes getting pages descriptors based
upon user space virtual address, dma mapping these pages, getting the
memory page size, removing the DMA mapping of the pages and releasing
page descriptors.
Those callbacks are quite similar to the kernel API used to pin normal
host memory and exposed it to the hardware.
Description of the API is included later in this cover
letter.

The peer direct controller, implemented as part of the IB core
services, provides registry and brokering services between peer memory
providers and low level IB hardware drivers.
This makes the usage of peer-direct almost completely transparent to
the individual hardware drivers. The only changes required in the low
level IB hardware drivers is supporting an interface for immediate
invalidation of registered memory regions.

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

Information and statistics regarding the registered peer memory
clients are exported to the user space at:
/sys/kernel/mm/memory_peers/<peer_name>/.
===============================================================================
Peer memory API
===============================================================================
Peer client structure:
-------------------------------------------------------------------------------
struct peer_memory_client {
       char   name[IB_PEER_MEMORY_NAME_MAX];
       char   version[IB_PEER_MEMORY_VER_MAX];
       int (*acquire) (unsigned long addr, size_t size, void *peer_mem_private_data,
                                  char *peer_mem_name, void **client_context);
       int (*get_pages) (unsigned long addr,
                       size_t size, int write, int force,
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
                                    invalidate_peer_memory *invalidate_callback);

Description:
Each peer memory should use this function to register as an available
peer memory client during its initialization. The callbacks provided
as part of the peer_client may be used later on by the IB core when
registering and unregistering its memory.
----------------------------------------------------------------------------------

void ib_unregister_peer_memory_client(void *reg_handle);

Description:
On unload, the peer memory client must unregister itself, to prevent
any additional callbacks to the unloaded module.

----------------------------------------------------------------------------------
typedef int (*invalidate_peer_memory)(void *reg_handle,
                                    void *core_context);

Description:
A callback function to be called by the peer driver when an allocation
should be invalidated. When the invalidation callback returns, the user
of the allocation is guaranteed not to access it.

-------------------------------------------------------------------------------

The structure of the patchset

First, the patches apply against the for-next branch in the
roland/infiniband.git tree, based upon commit ID
3bdad2d13fa62bcb59ca2506e74ce467ea436586 having subject: "Merge
branches 'core', 'ipoib', 'iser', 'mlx4', 'ocrdma' and 'qib' into
for-next"

Patches 1-3:
This set of patches introduces the API, adds the required support to
the IB core layer, allowing Peers to be registered and be part of the
flow. The first patch introduces the API, the next two patches add the
infrastructure to manage peer client and use its registration
callbacks.

Patch 4-5:
Those patches allow peers to notify IB core that a specific
registration should be invalidated.

Patch 6:
This patch exposes some information and statistics for a given peer
memory by using the sysfs mechanism.

Patches 7-8:
Those patches add the required functionality needed by mlx4 & mlx5 to
work with peer clients that require invalidation support.  Currently
that support was added for only MRs.

Patch 9:
This patch is an example peer memory client which uses the HOST
memory, it can serve as very good reference for peer client writers.

Yishai Hadas (9):
  IB/core: Introduce peer client interface
  IB/core: Get/put peer memory client
  IB/core: Umem tunneling peer memory APIs
  IB/core: Infrastructure to manage peer core context
  IB/core: Invalidation support for peer memory
  IB/core: Sysfs support for peer memory
  IB/mlx4: Invalidation support for MR over peer memory
  IB/mlx5: Invalidation support for MR over peer memory
  Samples: Peer memory client example

 drivers/infiniband/core/Makefile             |    3 +-
 drivers/infiniband/core/peer_mem.c           |  530 ++++++++++++++++++++++++++
 drivers/infiniband/core/umem.c               |  118 ++++++-
 drivers/infiniband/core/uverbs_cmd.c         |    2 +
 drivers/infiniband/hw/amso1100/c2_provider.c |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 +-
 drivers/infiniband/hw/cxgb4/mem.c            |    2 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c       |    2 +-
 drivers/infiniband/hw/ipath/ipath_mr.c       |    2 +-
 drivers/infiniband/hw/mlx4/cq.c              |    2 +-
 drivers/infiniband/hw/mlx4/doorbell.c        |    2 +-
 drivers/infiniband/hw/mlx4/main.c            |    3 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |    5 +
 drivers/infiniband/hw/mlx4/mr.c              |   90 ++++-
 drivers/infiniband/hw/mlx4/qp.c              |    2 +-
 drivers/infiniband/hw/mlx4/srq.c             |    2 +-
 drivers/infiniband/hw/mlx5/cq.c              |    5 +-
 drivers/infiniband/hw/mlx5/doorbell.c        |    2 +-
 drivers/infiniband/hw/mlx5/main.c            |    3 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |   10 +
 drivers/infiniband/hw/mlx5/mr.c              |   84 ++++-
 drivers/infiniband/hw/mlx5/qp.c              |    2 +-
 drivers/infiniband/hw/mlx5/srq.c             |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c        |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    2 +-
 drivers/infiniband/hw/qib/qib_mr.c           |    2 +-
 include/rdma/ib_peer_mem.h                   |   58 +++
 include/rdma/ib_umem.h                       |   36 ++-
 include/rdma/ib_verbs.h                      |    5 +-
 include/rdma/peer_mem.h                      |  185 +++++++++
 samples/Kconfig                              |   10 +
 samples/Makefile                             |    3 +-
 samples/peer_memory/Makefile                 |    1 +
 samples/peer_memory/example_peer_mem.c       |  260 +++++++++++++
 35 files changed, 1403 insertions(+), 40 deletions(-)
 create mode 100644 drivers/infiniband/core/peer_mem.c
 create mode 100644 include/rdma/ib_peer_mem.h
 create mode 100644 include/rdma/peer_mem.h
 create mode 100644 samples/peer_memory/Makefile
 create mode 100644 samples/peer_memory/example_peer_mem.c

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
