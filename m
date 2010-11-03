From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 8/13] IB-mgmt: Fix trace table response
Date: Wed, 3 Nov 2010 16:11:57 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B37B@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A response to a get trace table request is a get table response.
There is no 'get trace table response'.  See IB spec 1.2.1,
section 15.4.9.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Submitting as a separate patch, so the change doesn't get lost in the noise.

 libibmad/include/infiniband/mad.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libibmad/include/infiniband/mad.h b/libibmad/include/infiniband/mad.h
index 4a29c98..f3733a2 100755
--- a/libibmad/include/infiniband/mad.h
+++ b/libibmad/include/infiniband/mad.h
@@ -100,7 +100,7 @@ enum MAD_METHODS {
 	IB_MAD_METHOD_GET_TABLE = UMAD_SA_METHOD_GET_TABLE,
 	IB_MAD_METHOD_GET_TABLE_RESPONSE = UMAD_SA_METHOD_GET_TABLE_RESP,
 	IB_MAD_METHOD_GET_TRACE_TABLE = UMAD_SA_METHOD_GET_TRACE_TABLE,
-	IB_MAD_METHOD_GET_TRACE_TABLE_RESPONSE = 0x93, /* Not in spec */
+	IB_MAD_METHOD_GET_TRACE_TABLE_RESPONSE = UMAD_SA_METHOD_GET_TABLE_RESP,
 	IB_MAD_METHOD_GETMULTI = UMAD_SA_METHOD_GET_MULTI,
 	IB_MAD_METHOD_GETMULTI_RESPONSE = UMAD_SA_METHOD_GET_MULTI_RESP,
 	IB_MAD_METHOD_DELETE = UMAD_SA_METHOD_DELETE,


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
