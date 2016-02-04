From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/6] IB/rdmavt: remove unused qp field
Date: Thu, 04 Feb 2016 11:03:36 -0800
Message-ID: <20160204190333.8378.85068.stgit@scvm10.sc.intel.com>
References: <20160204190024.8378.5080.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160204190024.8378.5080.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The field is a vestige from ipath.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdmavt_qp.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 91f20fd..aed13e1 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -251,7 +251,6 @@ struct rvt_qp {
 	u32 pmtu;		/* decoded from path_mtu */
 	u32 qkey;               /* QKEY for this QP (for UD or RD) */
 	u32 s_size;             /* send work queue size */
-	u32 s_rnr_timeout;      /* number of milliseconds for RNR timeout */
 	u32 s_ahgpsn;           /* set to the psn in the copy of the header */
 
 	u8 state;               /* QP state */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
