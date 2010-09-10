From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.37 02/11] RDMA/cxgb4: Zero out ISGL padding.
Date: Fri, 10 Sep 2010 11:14:53 -0500
Message-ID: <20100910161453.6829.14456.stgit@build.ogc.int>
References: <20100910161442.6829.91594.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100910161442.6829.91594.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The HW design requires zering any pad in SGLs.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/qp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 05aa20b..c92259f 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -263,6 +263,9 @@ static int build_immd(struct t4_sq *sq, struct fw_ri_immd *immdp,
 			rem -= len;
 		}
 	}
+	len = roundup(plen + sizeof *immdp, 16) - (plen + sizeof *immdp);
+	if (len)
+		memset(dstp, 0, len);
 	immdp->op = FW_RI_DATA_IMMD;
 	immdp->r1 = 0;
 	immdp->r2 = 0;
@@ -292,6 +295,7 @@ static int build_isgl(__be64 *queue_start, __be64 *queue_end,
 		if (++flitp == queue_end)
 			flitp = queue_start;
 	}
+	*flitp = (__force __be64)0;
 	isglp->op = FW_RI_DATA_ISGL;
 	isglp->r1 = 0;
 	isglp->nsge = cpu_to_be16(num_sge);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
