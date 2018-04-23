From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 06/14] PCI/P2PDMA: Add P2P DMA driver writer's documentation
Date: Mon, 23 Apr 2018 17:30:38 -0600
Message-ID: <20180423233046.21476-7-logang@deltatee.com>
References: <20180423233046.21476-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180423233046.21476-1-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a restructured text file describing how to write drivers
with support for P2P DMA transactions. The document describes
how to use the APIs that were added in the previous few
commits.

Also adds an index for the PCI documentation tree even though this
is the only PCI document that has been converted to restructured text
at this time.

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
---
 Documentation/PCI/index.rst             |  14 +++
 Documentation/driver-api/pci/index.rst  |   1 +
 Documentation/driver-api/pci/p2pdma.rst | 166 ++++++++++++++++++++++++++++++++
 Documentation/index.rst                 |   3 +-
 4 files changed, 183 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/PCI/index.rst
 create mode 100644 Documentation/driver-api/pci/p2pdma.rst

diff --git a/Documentation/PCI/index.rst b/Documentation/PCI/index.rst
new file mode 100644
index 000000000000..2fdc4b3c291d
--- /dev/null
+++ b/Documentation/PCI/index.rst
@@ -0,0 +1,14 @@
+==================================
+Linux PCI Driver Developer's Guide
+==================================
+
+.. toctree::
+
+   p2pdma
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/driver-api/pci/index.rst b/Documentation/driver-api/pci/index.rst
index 03b57cbf8cc2..d12eeafbfc90 100644
--- a/Documentation/driver-api/pci/index.rst
+++ b/Documentation/driver-api/pci/index.rst
@@ -10,6 +10,7 @@ The Linux PCI driver implementer's API guide
    :maxdepth: 2
 
    pci
+   p2pdma
 
 .. only::  subproject and html
 
diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
new file mode 100644
index 000000000000..49a512c405b2
--- /dev/null
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -0,0 +1,166 @@
+============================
+PCI Peer-to-Peer DMA Support
+============================
+
+The PCI bus has pretty decent support for performing DMA transfers
+between two endpoints on the bus. This type of transaction is
+henceforth called Peer-to-Peer (or P2P). However, there are a number of
+issues that make P2P transactions tricky to do in a perfectly safe way.
+
+One of the biggest issues is that PCI Root Complexes are not required
+to support forwarding packets between Root Ports. To make things worse,
+there is no simple way to determine if a given Root Complex supports
+this or not. (See PCIe r4.0, sec 1.3.1). Therefore, as of this writing,
+the kernel only supports doing P2P when the endpoints involved are all
+behind the same PCIe root port as the spec guarantees that all
+packets will always be routable but does not require routing between
+root ports.
+
+The second issue is that to make use of existing interfaces in Linux,
+memory that is used for P2P transactions needs to be backed by struct
+pages. However, PCI BARs are not typically cache coherent so there are
+a few corner case gotchas with these pages so developers need to
+be careful about what they do with them.
+
+
+Driver Writer's Guide
+=====================
+
+In a given P2P implementation there may be three or more different
+types of kernel drivers in play:
+
+* Providers - A driver which provides or publishes P2P resources like
+  memory or doorbell registers to other drivers.
+* Clients - A driver which makes use of a resource by setting up a
+  DMA transaction to or from it.
+* Orchestrators - A driver which orchestrates the flow of data between
+  clients and providers
+
+In many cases there could be overlap between these three types (ie.
+it may be typical for a driver to be both a provider and a client).
+
+For example, in the NVMe Target Copy Offload implementation:
+
+* The NVMe PCI driver is both a client, provider and orchestrator
+  in that it exposes any CMB (Controller Memory Buffer) as a P2P memory
+  resource (provider), it accepts P2P memory pages as buffers in requests
+  to be used directly (client) and it can also make use the CMB as
+  submission queue entries.
+* The RDMA driver is a client in this arrangement so that an RNIC
+  can DMA directly to the memory exposed by the NVMe device.
+* The NVMe Target driver (nvmet) can orchestrate the data from the RNIC
+  to the P2P memory (CMB) and then to the NVMe device (and vice versa).
+
+This is currently the only arrangement supported by the kernel but
+one could imagine slight tweaks to this that would allow for the same
+functionality. For example, if a specific RNIC added a BAR with some
+memory behind it, its driver could add support as a P2P provider and
+then the NVMe Target could use the RNIC's memory instead of the CMB
+in cases where the NVMe cards in use do not have CMB support.
+
+
+Provider Drivers
+----------------
+
+A provider simply needs to register a BAR (or a portion of a BAR)
+as a P2P DMA resource using :c:func:`pci_p2pdma_add_resource()`.
+This will register struct pages for all the specified memory.
+
+After that it may optionally publish all of its resources as
+P2P memory using :c:func:`pci_p2pmem_publish()`. This will allow
+any orchestrator drivers to find and use the memory. When marked in
+this way, the resource must be regular memory with no side effects.
+
+For the time being this is fairly rudimentary in that all resources
+are typically going to be P2P memory. Future work will likely expand
+this to include other types of resources like doorbells.
+
+
+Client Drivers
+--------------
+
+A client driver typically only has to conditionally change its DMA map
+routine to use the mapping functions :c:func:`pci_p2pdma_map_sg()` and
+:c:func:`pci_p2pdma_unmap_sg()` instead of the usual :c:func:`dma_map_sg()`
+functions.
+
+The client may also, optionally, make use of
+:c:func:`is_pci_p2pdma_page()` to determine when to use the P2P mapping
+functions and when to use the regular mapping functions. In some
+situations, it may be more appropriate to use a flag to indicate a
+given request is P2P memory and map appropriately (for example the
+block layer uses a flag to keep P2P memory out of queues that do not
+have P2P client support). It is important to ensure that struct pages that
+back P2P memory stay out of code that does not have support for them.
+
+
+Orchestrator Drivers
+--------------------
+
+The first task an orchestrator driver must do is compile a list of
+all client drivers that will be involved in a given transaction. For
+example, the NVMe Target driver creates a list including all NVMe drives
+and the RNIC in use. The list is stored as an anonymous struct
+list_head which must be initialized with the usual INIT_LIST_HEAD.
+The following functions may then be used to add to, remove from and free
+the list of clients with the functions :c:func:`pci_p2pdma_add_client()`,
+:c:func:`pci_p2pdma_remove_client()` and
+:c:func:`pci_p2pdma_client_list_free()`.
+
+With the client list in hand, the orchestrator may then call
+:c:func:`pci_p2pmem_find()` to obtain a published P2P memory provider
+that is supported (behind the same root port) as all the clients. If more
+than one provider is supported, the one nearest to all the clients will
+be chosen first. If there are more than one provider is an equal distance
+away, the one returned will be chosen at random. This function returns the PCI
+device to use for the provider with a reference taken and therefore
+when it's no longer needed it should be returned with pci_dev_put().
+
+Alternatively, if the orchestrator knows (via some other means)
+which provider it wants to use it may use :c:func:`pci_has_p2pmem()`
+to determine if it has P2P memory and :c:func:`pci_p2pdma_distance()`
+to determine the cumulative distance between it and a potential
+list of clients.
+
+With a supported provider in hand, the driver can then call
+:c:func:`pci_p2pdma_assign_provider()` to assign the provider
+to the client list. This function returns false if any of the
+clients are unsupported by the provider.
+
+Once a provider is assigned to a client list via either
+:c:func:`pci_p2pmem_find()` or :c:func:`pci_p2pdma_assign_provider()`,
+the list is permanently bound to the provider such that any new clients
+added to the list must be supported by the already selected provider.
+If they are not supported, :c:func:`pci_p2pdma_add_client()` will return
+an error. In this way, orchestrators are free to add and remove devices
+without having to recheck support or tear down existing transfers to
+change P2P providers.
+
+Once a provider is selected, the orchestrator can then use
+:c:func:`pci_alloc_p2pmem()` and :c:func:`pci_free_p2pmem()` to
+allocate P2P memory from the provider. :c:func:`pci_p2pmem_alloc_sgl()`
+and :c:func:`pci_p2pmem_free_sgl()` are convenience functions for
+allocating scatter-gather lists with P2P memory.
+
+Struct Page Caveats
+-------------------
+
+Driver writers should be very careful about not passing these special
+struct pages to code that isn't prepared for it. At this time, the kernel
+interfaces do not have any checks for ensuring this. This obviously
+precludes passing these pages to userspace.
+
+P2P memory is also technically IO memory but should never have any side
+effects behind it. Thus, the order of loads and stores should not be important
+and ioreadX(), iowriteX() and friends should not be necessary.
+However, as the memory is not cache coherent, if access ever needs to
+be protected by a spinlock then :c:func:`mmiowb()` must be used before
+unlocking the lock. (See ACQUIRES VS I/O ACCESSES in
+Documentation/memory-barriers.txt)
+
+
+P2P DMA Support Library
+=====================
+
+.. kernel-doc:: drivers/pci/p2pdma.c
+   :export:
diff --git a/Documentation/index.rst b/Documentation/index.rst
index 3b99ab931d41..e7938b507df3 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -45,7 +45,7 @@ the kernel interface as seen by application developers.
 .. toctree::
    :maxdepth: 2
 
-   userspace-api/index	      
+   userspace-api/index
 
 
 Introduction to kernel development
@@ -89,6 +89,7 @@ needed).
    sound/index
    crypto/index
    filesystems/index
+   PCI/index
 
 Architecture-specific documentation
 -----------------------------------
-- 
2.11.0
