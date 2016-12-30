From: Kenneth Lee <liguozhu@hisilicon.com>
Subject: [PATCH v3] IB/umem: Release pid in error and ODP flow
Date: Fri, 30 Dec 2016 18:18:29 +0800
Message-ID: <1483093109-188428-1-git-send-email-liguozhu@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: robin.murphy@arm.com, jroedel@suse.de, egtvedt@samfundet.no, vgupta@synopsys.com, liguozhu@hisilicon.com, dave.hansen@linux.intel.com, lstoakes@gmail.com, krzk@kernel.org, sebott@linux.vnet.ibm.com, markb@mellanox.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

There are two bugfixes in this patch:

Fixes: 87773dd56d54 ("IB: ib_umem_release() should decrement mm->pinned_vm from ib_umem_get")
	This patch introduce the get_task_pid but not put it back on all error
	path

Fixes: 8ada2c1c0c1d ("IB/core: Add support for on demand paging regions")
	This patch introduce a ODP flow without release pid before enter it


Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
Reviewed-by: Haggai Eran <haggaie@mellanox.com>
---
Change from v1 to v2:
  Correcting the patch title and description
Change from v2 to v3:
  Update the title and add "Fixes" fields in the description

 drivers/infiniband/core/umem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 1e62a5f..4609b92 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -134,6 +134,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 		 IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_MW_BIND));
 
 	if (access & IB_ACCESS_ON_DEMAND) {
+		put_pid(umem->pid);
 		ret = ib_umem_odp_get(context, umem);
 		if (ret) {
 			kfree(umem);
@@ -149,6 +150,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 
 	page_list = (struct page **) __get_free_page(GFP_KERNEL);
 	if (!page_list) {
+		put_pid(umem->pid);
 		kfree(umem);
 		return ERR_PTR(-ENOMEM);
 	}
-- 
1.9.1
