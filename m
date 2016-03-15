From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/11] IB/hfi1: Adjust default MTU to be 10KB
Date: Tue, 15 Mar 2016 11:20:49 -0700
Message-ID: <20160315181942.29045.74031.stgit@scvm10.sc.intel.com>
References: <20160315174916.613.12254.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160315174916.613.12254.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Increasing the default MTU size to 10KB improves performance
for PSM. Change the default MTU to 10KB but constrain
Verbs MTU to 8KB.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h |    4 ++--
 drivers/infiniband/hw/hfi1/qp.c  |    6 +++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index ac553f1..ff04593 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -455,9 +455,9 @@ struct rvt_sge_state;
 #define HLS_UP (HLS_UP_INIT | HLS_UP_ARMED | HLS_UP_ACTIVE)
 
 /* use this MTU size if none other is given */
-#define HFI1_DEFAULT_ACTIVE_MTU 8192
+#define HFI1_DEFAULT_ACTIVE_MTU 10240
 /* use this MTU size as the default maximum */
-#define HFI1_DEFAULT_MAX_MTU 8192
+#define HFI1_DEFAULT_MAX_MTU 10240
 /* default partition key */
 #define DEFAULT_PKEY 0xffff
 
diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 29a5ad2..e68d08a 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -167,8 +167,12 @@ static inline int opa_mtu_enum_to_int(int mtu)
  */
 static inline int verbs_mtu_enum_to_int(struct ib_device *dev, enum ib_mtu mtu)
 {
-	int val = opa_mtu_enum_to_int((int)mtu);
+	int val;
 
+	/* Constraining 10KB packets to 8KB packets */
+	if (mtu == (enum ib_mtu)OPA_MTU_10240)
+		mtu = OPA_MTU_8192;
+	val = opa_mtu_enum_to_int((int)mtu);
 	if (val > 0)
 		return val;
 	return ib_mtu_enum_to_int(mtu);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
