From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/12] IB/rdmavt: Remove signal_supported and comments
Date: Sun, 14 Feb 2016 12:11:12 -0800
Message-ID: <20160214201108.1410.15721.stgit@scvm10.sc.intel.com>
References: <20160214200613.1410.63195.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214200613.1410.63195.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Initially it was intended that rdmavt would support some signaling
between the underlying driver and itself. However this turned out to be
unnecessary for qib and hfi1. If we need to add something like this in
later to support another driver we should do it then. As of now this
essentially dead code so remove it.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdma_vt.h |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 264c514..4c50bbb 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -138,24 +138,6 @@ struct rvt_driver_params {
 	struct ib_device_attr props;
 
 	/*
-	 * Drivers will need to support a number of notifications to rvt in
-	 * accordance with certain events. This structure should contain a mask
-	 * of the supported events. Such events that the rvt may need to know
-	 * about include:
-	 * port errors
-	 * port active
-	 * lid change
-	 * sm change
-	 * client reregister
-	 * pkey change
-	 *
-	 * There may also be other events that the rvt layers needs to know
-	 * about this is not an exhaustive list. Some events though rvt does not
-	 * need to rely on the driver for such as completion queue error.
-	 */
-	 int rvt_signal_supported;
-
-	/*
 	 * Anything driver specific that is not covered by props
 	 * For instance special module parameters. Goes here.
 	 */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
