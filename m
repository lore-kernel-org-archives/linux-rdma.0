From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 20/37] librdmacm: define options to set IB route directly
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <9E55E480A2414125B50EB8C7D7A0ED81@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add the definitions needed to set IB path record data using set_option.
This will be used by rdma_create_ep().

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cma.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index 89013a0..391c35c 100644
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -588,12 +588,14 @@ const char *rdma_event_str(enum rdma_cm_event_type event);
 
 /* Option levels */
 enum {
-	RDMA_OPTION_ID		= 0
+	RDMA_OPTION_ID		= 0,
+	RDMA_OPTION_IB		= 1
 };
 
 /* Option details */
 enum {
-	RDMA_OPTION_ID_TOS	= 0	/* uint8_t: RFC 2474 */
+	RDMA_OPTION_ID_TOS	= 0,	/* uint8_t: RFC 2474 */
+	RDMA_OPTION_IB_PATH	= 1	/* struct ib_path_data[] */
 };
 
 /**



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
