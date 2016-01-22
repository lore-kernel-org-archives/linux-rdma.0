From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 1/6] IB/rdmavt: Remove unused variable from Queue Pair
Date: Fri, 22 Jan 2016 13:04:32 -0800
Message-ID: <20160122210430.9932.68371.stgit@scvm10.sc.intel.com>
References: <20160122210251.9932.46251.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122210251.9932.46251.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

s_sde should be in the low level driver QP private data.

Remove the definition from rvt_qp.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdmavt_qp.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index a97b95b..f0e2426 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -304,7 +304,6 @@ struct rvt_qp {
 	struct rvt_swqe *s_wqe;
 	struct rvt_sge_state s_sge;     /* current send request data */
 	struct rvt_mregion *s_rdma_mr;
-	struct sdma_engine *s_sde; /* current sde */
 	u32 s_cur_size;         /* size of send packet in bytes */
 	u32 s_len;              /* total length of s_sge */
 	u32 s_rdma_read_len;    /* total length of s_rdma_read_sge */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
