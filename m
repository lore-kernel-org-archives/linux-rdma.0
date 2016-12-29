From: Kenneth Lee <liguozhu@hisilicon.com>
Subject: [PATCH] ib umem: bugfix: mixed put_pid()s in ib_umem_get()
Date: Thu, 29 Dec 2016 10:24:43 +0800
Message-ID: <1482978283-201678-1-git-send-email-liguozhu@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: robin.murphy@arm.com, jroedel@suse.de, egtvedt@samfundet.no, vgupta@synopsys.com, liguozhu@hisilicon.com, dave.hansen@linux.intel.com, lstoakes@gmail.com, krzk@kernel.org, sebott@linux.vnet.ibm.com, markb@mellanox.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

There are two bugfixes in this patch:

1. When the execution go to the ib_umem_odp_get() path, pid should be put
   back.
2. When the memory allocation fail, the pid also should be put back before
   exit.

Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
---
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
