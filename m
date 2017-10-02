From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 5/8] IB/core: Use __be32 for LIDs in
 opa_is_extended_lid
Date: Mon, 02 Oct 2017 11:04:33 -0700
Message-ID: <20171002180431.31117.33069.stgit@scvm10.sc.intel.com>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171002180204.31117.12254.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The LIDs passed to opa_extended_lid are in __be32 format,
change function signature accordingly.

This fixes the following sparse warnings:
  drivers/infiniband/core/cm.c:1181:60: warning: incorrect type in
	argument 1 (different ba
  drivers/infiniband/core/cm.c:1182:60: warning: incorrect type in
	argument 2 (different ba
  drivers/infiniband/core/cm.c:1242:68: warning: incorrect type in
	argument 1 (different ba
  drivers/infiniband/core/cm.c:1243:68: warning: incorrect type in
	argument 2 (different ba
  drivers/infiniband/core/cm.c:2922:66: warning: incorrect type in
	argument 1 (different ba
  drivers/infiniband/core/cm.c:2923:66: warning: incorrect type in
	argument 2 (different ba
  include/rdma/opa_addr.h:102:14: warning: cast to restricted __be32

Fixes: e92aa00a5189 ("IB/CM: Add OPA Path record support to CM")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/opa_addr.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/rdma/opa_addr.h b/include/rdma/opa_addr.h
index e6e90f1..f68fca2 100644
--- a/include/rdma/opa_addr.h
+++ b/include/rdma/opa_addr.h
@@ -97,15 +97,15 @@ static inline u32 opa_get_lid_from_gid(const union ib_gid *gid)
  * @dlid: The DLID
  * @slid: The SLID
  */
-static inline bool opa_is_extended_lid(u32 dlid, u32 slid)
+static inline bool opa_is_extended_lid(__be32 dlid, __be32 slid)
 {
 	if ((be32_to_cpu(dlid) >=
 	     be16_to_cpu(IB_MULTICAST_LID_BASE)) ||
 	    (be32_to_cpu(slid) >=
 	     be16_to_cpu(IB_MULTICAST_LID_BASE)))
 		return true;
-	else
-		return false;
+
+	return false;
 }
 
 /* Get multicast lid base */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
