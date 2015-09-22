From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 32/32] IB/rxe: TODO file while in staging
Date: Tue, 22 Sep 2015 10:31:15 +0300
Message-ID: <1442907075-13228-33-git-send-email-kamalh@mellanox.com>
References: <1442907075-13228-1-git-send-email-kamalh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442907075-13228-1-git-send-email-kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Things todo in order to get out of staging subtree.

Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/staging/rxe/TODO | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 drivers/staging/rxe/TODO

diff --git a/drivers/staging/rxe/TODO b/drivers/staging/rxe/TODO
new file mode 100644
index 0000000..b3cb8a4
--- /dev/null
+++ b/drivers/staging/rxe/TODO
@@ -0,0 +1,18 @@
+Aug, 2015
+
+- Remove software processing of IB protocol and place in library for use
+  by qib, ipath (if still present), hfi1, and soft-roce
+- Do not use tasklet in completion flow
+- Need to free resources if user space didn't.
+- Share structures from ib_user_verbs.h instead of copying in ib_rxe.h
+- Move IBA header types and methods from rxe_hdr.h into IB core
+- Cleanup members of rxe_pkt_info that already exists in packet header
+- Refactor post_send_one function to get better performance.
+- Refactor rxe_mem struct to be clear what is type of memory that it's holding.
+- Use single reference count from the pool to the device, instead of having a single
+  reference on the device kept by each element in the pool.
+- Calculate ICRC for incoming packets.
+- Use hash table to hold net_info instead of fixed size array used now.
+
+Sep, 2015
+- Support work request interface memory registration.
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
