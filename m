From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] libibmad: Fix trace table response
Date: Thu, 28 Apr 2011 16:16:43 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F416D@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Alex Netes (alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A response to a get trace table request is a get table response.
There is no 'get trace table response'.  See IB spec 1.2.1,
section 15.4.9.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/mad.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
index 2efa2a7..e630974 100755
--- a/include/infiniband/mad.h
+++ b/include/infiniband/mad.h
@@ -102,7 +102,7 @@ enum MAD_METHODS {
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
