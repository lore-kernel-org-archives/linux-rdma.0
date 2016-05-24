From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/10] IB/rdmavt: Max atomic value should be a u8
Date: Tue, 24 May 2016 12:50:34 -0700
Message-ID: <20160524195033.19706.26887.stgit@scvm10.sc.intel.com>
References: <20160524194746.19706.42976.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524194746.19706.42976.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This matches the ib_qp_attr size and
avoids a extremely large value when the lower level
driver registers.

As part of the patch, the u8 ordinals are moved to the
end of the struct to reduce pahole noted excesses.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdma_vt.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index d57ceee..3f12da9 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -149,15 +149,15 @@ struct rvt_driver_params {
 	int qpn_res_end;
 	int nports;
 	int npkeys;
-	u8 qos_shift;
 	char cq_name[RVT_CQN_MAX];
 	int node;
-	int max_rdma_atomic;
 	int psn_mask;
 	int psn_shift;
 	int psn_modify_mask;
 	u32 core_cap_flags;
 	u32 max_mad_size;
+	u8 qos_shift;
+	u8 max_rdma_atomic;
 };
 
 /* Protection domain */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
