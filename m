From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] IB/hfi1: Improve J_KEY generation
Date: Tue, 16 Aug 2016 13:26:12 -0700
Message-ID: <20160816202539.24004.76306.stgit@scvm10.sc.intel.com>
References: <20160816202133.24004.31487.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160816202133.24004.31487.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Previously, J_KEY generation was based on the lower 16 bits
of the user's UID. While this works, it was not good enough
as a non-root user could collide with a root user given a
sufficiently large UID.

This patch attempt to improve the J_KEY generation by using
the following algorithm:

The 16 bit J_KEY space is partitioned into 3 separate spaces
reserved for different user classes:
   * all users with administtor privileges (including 'root')
     will use J_KEYs in the range of 0 to 31,
   * all kernel protocols, which use KDETH packets will use
     J_KEYs in the range of 32 to 63, and
   * all other users will use J_KEYs in the range of 64 to
     65535.

The above separation is aimed at preventing different user levels
from sending packets to each other and, additionally, separate
kernel protocols from all other types of users. The later is meant
to prevent the potential corruption of kernel memory by any other
type of user.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 1000e0f..ceccf78 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1272,9 +1272,26 @@ static inline int hdr2sc(struct hfi1_message_header *hdr, u64 rhf)
 	       ((!!(rhf_dc_info(rhf))) << 4);
 }
 
+#define HFI1_JKEY_WIDTH       16
+#define HFI1_JKEY_MASK        (BIT(16) - 1)
+#define HFI1_ADMIN_JKEY_RANGE 32
+
+/*
+ * J_KEYs are split and allocated in the following groups:
+ *   0 - 31    - users with administrator privileges
+ *  32 - 63    - kernel protocols using KDETH packets
+ *  64 - 65535 - all other users using KDETH packets
+ */
 static inline u16 generate_jkey(kuid_t uid)
 {
-	return from_kuid(current_user_ns(), uid) & 0xffff;
+	u16 jkey = from_kuid(current_user_ns(), uid) & HFI1_JKEY_MASK;
+
+	if (capable(CAP_SYS_ADMIN))
+		jkey &= HFI1_ADMIN_JKEY_RANGE - 1;
+	else if (jkey < 64)
+		jkey |= BIT(HFI1_JKEY_WIDTH - 1);
+
+	return jkey;
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
