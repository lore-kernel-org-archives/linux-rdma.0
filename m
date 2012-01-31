From: Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] IB/mad: Add MAD error codes per IBTA spec
Date: Tue, 31 Jan 2012 03:11:46 -0500
Message-ID: <20120131081146.9009.64385.stgit@kop-dev-sles11-04.qlogic.org>
References: <20120131081138.9009.33668.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120131081138.9009.33668.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add appropriate MAD error codes so that they can be used
while returning appropriate error responses.

Signed-off-by: Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 include/rdma/ib_mad.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index d3b9401..d9751b7 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -77,6 +77,15 @@
 
 #define IB_MGMT_MAX_METHODS			128
 
+/* MAD Status field bit masks */
+#define IB_MGMT_MAD_STATUS_SUCCESS					0x0000
+#define IB_MGMT_MAD_STATUS_BUSY						0x0001
+#define IB_MGMT_MAD_STATUS_REDIRECT_REQD				0x0002
+#define IB_MGMT_MAD_STATUS_BAD_VERSION					0x0004
+#define IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD			0x0008
+#define IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD_ATTRIB	0x000c
+#define IB_MGMT_MAD_STATUS_INVALID_ATTRIB_VALUE			0x001c
+
 /* RMPP information */
 #define IB_MGMT_RMPP_VERSION			1
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
