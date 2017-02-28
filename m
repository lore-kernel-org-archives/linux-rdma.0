From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH v8 09/11] smc_diag.h: fix include from userland
Date: Tue, 28 Feb 2017 21:47:35 +0100
Message-ID: <1488314857-28327-10-git-send-email-nicolas.dichtel@6wind.com>
References: <20170228024844.GA28691@altlinux.org>
 <1488314857-28327-1-git-send-email-nicolas.dichtel@6wind.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1488314857-28327-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, mmarek@suse.com
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, airlied@linux.ie, davem@davemloft.net, linux@armlinux.org.uk, bp@alien8.de, slash.tmp@free.fr, daniel.vetter@ffwll.ch, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, tklauser@distanz.ch, mpe@ellerman.id.au, mingo@kernel.org, tglx@linutronix.de, ldv@altlinux.org, nicolas.dichtel@6wind.com, herbert@gondor.apana.org.au, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patch prepares the uapi export by fixing the following error:

.../linux/smc_diag.h:6:27: fatal error: rdma/ib_verbs.h: No such file or directory
 #include <rdma/ib_verbs.h>

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
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
