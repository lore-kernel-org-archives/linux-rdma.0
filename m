From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Subject: [RFC PATCH 0/4] ibverbs: new verbs for registering I/O memory
Date: Thu, 29 Jul 2010 11:24:58 -0500
Message-ID: <20100729162339.14674.15788.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org, tom-/Yg/VP3ZvrM@public.gmane.org, swise-/Yg/VP3ZvrM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following patches add verbs for registering I/O memory from user-space.

This capability allows device memory to be registered. More specifically,
any VM_PFNMAP vma can be registered.

The mmap service is used to obtain the address of this memory and provide it
to user space. This is where any security policy would be implemented.

The ib_iomem_get service requires that any address provided by the service
be in a VMA owned by the process. This precludes providing 'random' addresses
to the service to acquire access to arbitrary memory locations.
---

Tom Tucker (4):
      mthca: Add support for reg_io_mr and unreg_io_mr
      uverbs_cmd: Add uverbs command definitions for reg_io_mr
      uverbs: Add common ib_iomem_get service
      ibverbs: Add new provider verb for I/O memory registration


 drivers/infiniband/core/umem.c               |  248 +++++++++++++++++++++++++-
 drivers/infiniband/core/uverbs.h             |    2 
 drivers/infiniband/core/uverbs_cmd.c         |  140 +++++++++++++++
 drivers/infiniband/core/uverbs_main.c        |    2 
 drivers/infiniband/hw/mthca/mthca_provider.c |  111 ++++++++++++
 include/rdma/ib_umem.h                       |   14 +
 include/rdma/ib_user_verbs.h                 |   24 ++-
 include/rdma/ib_verbs.h                      |    5 +
 8 files changed, 534 insertions(+), 12 deletions(-)

-- 
Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
