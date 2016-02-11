From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 1/7] IB/core: Introduce peer client interface
Date: Thu, 11 Feb 2016 18:12:51 +0200
Message-ID: <1455207177-11949-2-git-send-email-artemyko@mellanox.com>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455207177-11949-1-git-send-email-artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-Dj0/KMMU01E@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduces an API between IB core to peer memory clients,(e.g. GPU cards)
to provide access for the HCA to read/write GPU memory.

As a result it allows RDMA-based application to use GPU computing power,
and RDMA interconnect at the same time w/o copying the data between the
P2P devices.

Each peer memory client should register with IB core. In the registration
request, it should supply callbacks to its memory basic functionality such
as get/put pages, get_page_size, dma map/unmap.

The client can optionally require the ability to invalidate memory it
provided, by requesting an invalidation callback details.

Upon successful registration, IB core will provide the client with a unique
registration handle and an invalidate callback function in case required by
the peer.

The handle should be used when unregistering the client, the callback
function can be used by the client in later patches, for a request from
the client to immediately release pinned pages.

Each peer must be able to recognize whether it's the owner of a specific
virtual address range. In case the answer is YES, further calls for memory
functionality will be tunneled to that peer.

The recognition is done via the 'acquire' call. The call arguments provide
the address and size of the memory requested.  Upon recognition, the
acquire call returns a peer direct client specific context. The context
will be provided by the peer direct controller to the peer direct client
callbacks when referring the specific address range.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/Kconfig         |  10 ++
 drivers/infiniband/core/Makefile   |   1 +
 drivers/infiniband/core/peer_mem.c |  82 +++++++++++++
 include/rdma/ib_peer_mem.h         |  44 +++++++
 include/rdma/peer_mem.h            | 238 +++++++++++++++++++++++++++++++++++++
 5 files changed, 375 insertions(+)
 create mode 100644 drivers/infiniband/core/peer_mem.c
 create mode 100644 include/rdma/ib_peer_mem.h
 create mode 100644 include/rdma/peer_mem.h

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 8a8440c..2837d66 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -64,6 +64,16 @@ config INFINIBAND_ADDR_TRANS_CONFIGFS
 	  This allows the user to config the default GID type that the CM
 	  uses for each device, when initiaing new connections.
 
+config INFINIBAND_PEER_MEM
+	bool "InfiniBand Peer memory access"
+	depends on INFINIBAND_USER_MEM
+	depends on MMU_NOTIFIER
+	default y
+	---help---
+	  Peer memory access feature allows RDMA operations to directly target
+	  memory in external hardware devices, such as GPU cards, SSD based
+	  storage, dedicated ASIC accelerators, etc.
+
 source "drivers/infiniband/hw/mthca/Kconfig"
 source "drivers/infiniband/hw/qib/Kconfig"
 source "drivers/infiniband/hw/cxgb3/Kconfig"
diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index f818538..9882d00 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -13,6 +13,7 @@ ib_core-y :=			packer.o ud_header.o verbs.o cq.o sysfs.o \
 				roce_gid_mgmt.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
+ib_core-$(CONFIG_INFINIBAND_PEER_MEM) += peer_mem.o
 
 ib_mad-y :=			mad.o smi.o agent.o mad_rmpp.o
 
diff --git a/drivers/infiniband/core/peer_mem.c b/drivers/infiniband/core/peer_mem.c
new file mode 100644
index 0000000..2c26a39
--- /dev/null
+++ b/drivers/infiniband/core/peer_mem.c
@@ -0,0 +1,82 @@
+/*
+ * Copyright (c) 2016,  Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <rdma/ib_peer_mem.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_umem.h>
+
+static DEFINE_MUTEX(peer_memory_mutex);
+static LIST_HEAD(peer_memory_list);
+
+static int ib_invalidate_peer_memory(void *reg_handle, u64 core_context)
+{
+	return -ENOSYS;
+}
+
+void *ib_register_peer_memory_client(struct peer_memory_client *peer_client,
+				     int (**invalidate_callback)
+				     (void *reg_handle, u64 core_context))
+{
+	struct ib_peer_memory_client *ib_peer_client;
+
+	ib_peer_client = kzalloc(sizeof(*ib_peer_client), GFP_KERNEL);
+	if (!ib_peer_client)
+		return NULL;
+
+	ib_peer_client->peer_mem = peer_client;
+	/* Once peer supplied a non NULL callback it's an indication that
+	 * invalidation support is required for any memory owning.
+	 */
+	if (invalidate_callback) {
+		*invalidate_callback = ib_invalidate_peer_memory;
+		ib_peer_client->invalidation_required = 1;
+	}
+
+	mutex_lock(&peer_memory_mutex);
+	list_add_tail(&ib_peer_client->core_peer_list, &peer_memory_list);
+	mutex_unlock(&peer_memory_mutex);
+
+	return ib_peer_client;
+}
+EXPORT_SYMBOL(ib_register_peer_memory_client);
+
+void ib_unregister_peer_memory_client(void *reg_handle)
+{
+	struct ib_peer_memory_client *ib_peer_client = reg_handle;
+
+	mutex_lock(&peer_memory_mutex);
+	list_del(&ib_peer_client->core_peer_list);
+	mutex_unlock(&peer_memory_mutex);
+
+	kfree(ib_peer_client);
+}
+EXPORT_SYMBOL(ib_unregister_peer_memory_client);
diff --git a/include/rdma/ib_peer_mem.h b/include/rdma/ib_peer_mem.h
new file mode 100644
index 0000000..cbe928e
--- /dev/null
+++ b/include/rdma/ib_peer_mem.h
@@ -0,0 +1,44 @@
+/*
+ * Copyright (c) 2016,  Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#if !defined(IB_PEER_MEM_H)
+#define IB_PEER_MEM_H
+
+#include <rdma/peer_mem.h>
+
+struct ib_peer_memory_client {
+	const struct peer_memory_client *peer_mem;
+	struct list_head	core_peer_list;
+	int invalidation_required;
+};
+
+#endif
diff --git a/include/rdma/peer_mem.h b/include/rdma/peer_mem.h
new file mode 100644
index 0000000..1ec96ea
--- /dev/null
+++ b/include/rdma/peer_mem.h
@@ -0,0 +1,238 @@
+/*
+ * Copyright (c) 2016,  Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#if !defined(PEER_MEM_H)
+#define PEER_MEM_H
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/scatterlist.h>
+
+/**
+ *  struct peer_memory_client - registration information for peer client.
+ *  @acquire:	callback function to be used by IB core to detect whether a
+ *		virtual address in under the responsibility of a specific
+ *		peer client.
+ *  @get_pages: callback function to be used by IB core asking the peer client
+ *		to pin the physical pages of the given address range and returns
+ *		that information. It equivalents to the kernel API of
+ *		get_user_pages(), but targets peer memory.
+ *  @dma_map:	callback function to be used by IB core asking the peer client
+ *		to fill	the dma address mapping for a given address range.
+ *  @dma_unmap:	callback function to be used by IB core asking the peer client
+ *		to take relevant actions to unmap the memory.
+ *  @put_pages:	callback function to be used by IB core asking the peer client
+ *		to remove the pinning from the given memory.
+ *		It's the peer-direct equivalent of the kernel API put_page.
+ *  @get_page_size: callback function to be used by IB core to query the peer
+ *		client for the page size for the given allocation.
+ *  @release:	callback function to be used by IB core asking peer client to
+ *		release all resources associated with previous acquire call.
+ *		The call will be performed only for contexts that have been
+ *		successfully acquired (i.e. acquire returned a non-zero value).
+ *		Additionally, IB core guarentees that there will be no pages
+ *		pinned through this context when the callback is called.
+ *
+ *  The subsections in this description contain detailed description
+ *  of the callback arguments and expected return values for the
+ *  callbacks defined in this struct.
+ *
+ *	acquire:
+ *
+ *		Callback function to be used by IB core to detect
+ *		whether a virtual address in under the responsibility
+ *		of a specific peer client.
+ *
+ *		addr	[IN] - virtual address to be checked whether belongs
+ *			       to peer.
+ *
+ *		size	[IN] - size of memory area starting at addr.
+ *
+ *		client_context	      [OUT] - peer opaque data which holds
+ *					      a peer context for the acquired
+ *					      address range, will be provided
+ *					      back to the peer memory in
+ *					      subsequent calls for that given
+ *					      memory.
+ *
+ *		If peer takes responsibility on the given address range further
+ *		calls for memory management will be directed to the callbacks
+ *		of this peer client.
+ *
+ *		Return - 1 in case peer client takes responsibility on that
+ *			 range, negative value if error
+ *			 happens during process, 0 otherwise.
+ *
+ *	get_pages:
+ *
+ *		Callback function to be used by IB core asking the
+ *		peer client to pin the physical pages of the given
+ *		address range and returns that information.  It
+ *		equivalents to the kernel API of get_user_pages(), but
+ *		targets peer memory.
+ *
+ *		addr	       [IN] - start virtual address of that given
+ *				      allocation.
+ *
+ *		size	       [IN] - size of memory area starting at addr.
+ *
+ *		write	       [IN] - indicates whether the pages will be
+ *				      written to by the caller. Same meaning
+ *				      as of kernel API get_user_pages, can be
+ *				      ignored if not relevant.
+ *
+ *		force	       [IN] - indicates whether to force write access
+ *				      even if user mapping is read only. Same
+ *				      meaning as of kernel API get_user_pages,
+ *				      can be ignored if not relevant.
+ *
+ *		sg_head        [IN/OUT] - pointer to head of struct sg_table.
+ *					  The peer client should allocate a
+ *					  table big enough to store all of the
+ *					  required entries. This function should
+ *					  fill the table with physical addresses
+ *					  and sizes of the memory segments
+ *					  composing this memory mapping. The
+ *					  table allocation can be done using
+ *					  sg_alloc_table. Filling in the
+ *					  physical memory addresses and size can
+ *					  be done using sg_set_page.
+ *
+ *		client_context [IN] - peer context for the given allocation, as
+ *				      received from the acquire call.
+ *
+ *		core_context   [IN] - IB core context. If the peer client wishes
+ *				      to invalidate any of the pages pinned
+ *				      through this API, it must provide this
+ *				      context as an argument to the invalidate
+ *				      callback.
+ *
+ *		Return - 0 success, otherwise errno error code.
+ *
+ *	dma_map:
+ *
+ *		Callback function to be used by IB core asking the peer client
+ *		to fill the dma address mapping for a given address range.
+ *
+ *		sg_head        [IN/OUT] - pointer to head of struct sg_table.
+ *					  The peer memory should fill the
+ *					  dma_address and dma_length for each
+ *					  scatter gather entry in the table.
+ *
+ *		client_context [IN] - peer context for the allocation mapped.
+ *
+ *		dma_device     [IN] - the RDMA capable device which
+ *				      requires access to the peer memory.
+ *
+ *		dmasync        [IN] - flush in-flight DMA when the memory region
+ *				      is written. Same meaning as with host
+ *				      memory mapping, can be ignored
+ *				      if not relevant.
+ *
+ *		nmap	       [OUT] - number of mapped/set entries.
+ *
+ *		Return - 0 success, otherwise errno error code.
+ *
+ *	dma_unmap:
+ *
+ *		Callback function to be used by IB core asking the peer client
+ *		to take	relevant actions to unmap the memory.
+ *
+ *		sg_head        [IN] - pointer to head of struct sg_table.
+ *				      The peer memory should release the
+ *				      dma_address and dma_length for each
+ *				      scatter gather entry in the table.
+ *
+ *		client_context [IN] - peer context for the allocation mapped.
+ *
+ *		dma_device     [IN] - the RDMA capable device which requires
+ *				      access to the peer memory.
+ *
+ *		Return -  0 success, otherwise errno error code.
+ *
+ *	put_pages:
+ *
+ *		Callback function to be used by IB core asking the peer client
+ *		to remove the pinning from the given memory.
+ *		It's the peer-direct equivalent of the kernel API put_page.
+ *
+ *		sg_head        [IN] - pointer to head of struct sg_table.
+ *
+ *		client_context [IN] - peer context for that given allocation.
+ *
+ *	get_page_size:
+ *
+ *		Callback function to be used by IB core to query the
+ *		peer client for the page size for the given
+ *		allocation.
+ *
+ *		client_context [IN] - peer context for that given allocation.
+ *
+ *		Return -  Page size in bytes
+ *
+ *	release:
+ *
+ *		Callback function to be used by IB core asking peer
+ *		client to release all resources associated with
+ *		previous acquire call. The call will be performed only
+ *		for contexts that have been successfully acquired
+ *		(i.e. acquire returned a non-zero value).
+ *		Additionally, IB core guarentees that there will be no
+ *		pages pinned through this context when the callback is
+ *		called.
+ *
+ *		client_context [IN] - peer context for the given allocation.
+ *
+ **/
+struct peer_memory_client {
+	int (*acquire)(unsigned long addr, size_t size, void **client_context);
+	int (*get_pages)(unsigned long addr, size_t size, int write, int force,
+			 struct sg_table *sg_head,
+			 void *client_context, u64 core_context);
+	int (*dma_map)(struct sg_table *sg_head, void *client_context,
+		       struct device *dma_device, int dmasync, int *nmap);
+	int (*dma_unmap)(struct sg_table *sg_head, void *client_context,
+			 struct device  *dma_device);
+	void (*put_pages)(struct sg_table *sg_head, void *client_context);
+	unsigned long (*get_page_size)(void *client_context);
+	void (*release)(void *client_context);
+};
+
+void *ib_register_peer_memory_client(struct peer_memory_client *peer_client,
+				     int (**invalidate_callback)
+				     (void *reg_handle, u64 core_context));
+void ib_unregister_peer_memory_client(void *reg_handle);
+
+#endif
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
