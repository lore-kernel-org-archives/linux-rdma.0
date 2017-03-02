From: Nicolas Dichtel <nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v9 09/11] smc_diag.h: fix include from userland
Date: Thu,  2 Mar 2017 17:56:40 +0100
Message-ID: <1488473802-13354-10-git-send-email-nicolas.dichtel@6wind.com>
References: <20170301045241.GB9156@gondor.apana.org.au>
 <1488473802-13354-1-git-send-email-nicolas.dichtel@6wind.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488473802-13354-1-git-send-email-nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arnd-r2nGTMty4D4@public.gmane.org, mmarek-IBi9RG/b67k@public.gmane.org
Cc: linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, airlied-cv59FeDIM0c@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, slash.tmp-GANU6spQydw@public.gmane.org, daniel.vetter-/w4YWyX8dFk@public.gmane.org, rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jengelh-9+2X+4sQBs8@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org, nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch prepares the uapi export by fixing the following error:

.../linux/smc_diag.h:6:27: fatal error: rdma/ib_verbs.h: No such file or directory
 #include <rdma/ib_verbs.h>

Signed-off-by: Nicolas Dichtel <nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/ib_verbs.h           | 3 +--
 include/uapi/linux/smc_diag.h     | 2 +-
 include/uapi/rdma/ib_user_verbs.h | 2 ++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0f1813c13687..50f276a4afdc 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -61,6 +61,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/uaccess.h>
 #include <linux/cgroup_rdma.h>
+#include <uapi/rdma/ib_user_verbs.h>
 
 extern struct workqueue_struct *ib_wq;
 extern struct workqueue_struct *ib_comp_wq;
@@ -1838,8 +1839,6 @@ enum ib_mad_result {
 	IB_MAD_RESULT_CONSUMED = 1 << 2  /* Packet consumed: stop processing */
 };
 
-#define IB_DEVICE_NAME_MAX 64
-
 struct ib_port_cache {
 	struct ib_pkey_cache  *pkey;
 	struct ib_gid_table   *gid;
diff --git a/include/uapi/linux/smc_diag.h b/include/uapi/linux/smc_diag.h
index 0063919fea34..87712bfaa9dd 100644
--- a/include/uapi/linux/smc_diag.h
+++ b/include/uapi/linux/smc_diag.h
@@ -3,7 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/inet_diag.h>
-#include <rdma/ib_verbs.h>
+#include <rdma/ib_user_verbs.h>
 
 /* Request structure */
 struct smc_diag_req {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 997f904c7692..8edce2b65903 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -1124,4 +1124,6 @@ struct ib_uverbs_ex_destroy_rwq_ind_table  {
 	__u32 ind_tbl_handle;
 };
 
+#define IB_DEVICE_NAME_MAX 64
+
 #endif /* IB_USER_VERBS_H */
-- 
2.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
