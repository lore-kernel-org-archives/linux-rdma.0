From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [for-2.6.34] rdma/cm: remove unused definition of RDMA_PS_SCTP
Date: Thu, 11 Feb 2010 15:35:55 -0800
Message-ID: <1858987F926C410292BB0768F884BEAF@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The defined SCTP number is incorrect (0x83, rather than 0x84), and
since it is not used anywhere, simply remove the definition.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cm.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index c6b2962..4fae903 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -67,7 +67,6 @@ enum rdma_port_space {
 	RDMA_PS_IPOIB = 0x0002,
 	RDMA_PS_TCP   = 0x0106,
 	RDMA_PS_UDP   = 0x0111,
-	RDMA_PS_SCTP  = 0x0183
 };
 
 struct rdma_addr {



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
