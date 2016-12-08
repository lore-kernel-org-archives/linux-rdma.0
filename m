From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/23] IB/hfi1: Remove definition of unused hfi1_affinity
 struct
Date: Wed, 07 Dec 2016 19:33:06 -0800
Message-ID: <20161208033305.21135.25383.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The struct hfi1_affinity is not used anymore.
We use the struct hfi1_affinity_node and hfi1_affinity_node_list
instead.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/affinity.h |    8 --------
 drivers/infiniband/hw/hfi1/hfi.h      |    1 -
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/affinity.h b/drivers/infiniband/hw/hfi1/affinity.h
index 42e6331..28eac98 100644
--- a/drivers/infiniband/hw/hfi1/affinity.h
+++ b/drivers/infiniband/hw/hfi1/affinity.h
@@ -70,14 +70,6 @@ struct cpu_mask_set {
 	uint gen;
 };
 
-struct hfi1_affinity {
-	struct cpu_mask_set def_intr;
-	struct cpu_mask_set rcv_intr;
-	struct cpumask real_cpu_mask;
-	/* spin lock to protect affinity struct */
-	spinlock_t lock;
-};
-
 struct hfi1_msix_entry;
 
 /* Initialize non-HT cpu cores mask */
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 1707334..9723b4c 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1162,7 +1162,6 @@ struct hfi1_devdata {
 	atomic_t aspm_disabled_cnt;
 	/* Keeps track of user space clients */
 	atomic_t user_refcount;
-	struct hfi1_affinity *affinity;
 	/* Used to wait for outstanding user space clients before dev removal */
 	struct completion user_comp;
 	bool eprom_available;	/* true if EPROM is available for this device */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
