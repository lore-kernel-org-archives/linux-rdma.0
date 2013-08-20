From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: Move COUNTER_MASK definition within qib_mad.h
 header guards
Date: Tue, 20 Aug 2013 08:25:08 -0700
Message-ID: <20130820082508.53d97c8831b6ee38648c8440@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Commit 36a8f01c ("IB/qib: Add congestion control agent implementation") caused statements to leak pass the header guard.

Correct with this update.

Reviewed-by: Marciniszyn, Mike <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_mad.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.h b/drivers/infiniband/hw/qib/qib_mad.h
index 57bd3fa..28874f8 100644
--- a/drivers/infiniband/hw/qib/qib_mad.h
+++ b/drivers/infiniband/hw/qib/qib_mad.h
@@ -415,7 +415,6 @@ struct cc_table_shadow {
 	struct ib_cc_table_entry_shadow entries[CC_TABLE_SHADOW_MAX];
 } __packed;
 
-#endif				/* _QIB_MAD_H */
 /*
  * The PortSamplesControl.CounterMasks field is an array of 3 bit fields
  * which specify the N'th counter's capabilities. See ch. 16.1.3.2.
@@ -428,3 +427,5 @@ struct cc_table_shadow {
 		    COUNTER_MASK(1, 2) | \
 		    COUNTER_MASK(1, 3) | \
 		    COUNTER_MASK(1, 4))
+
+#endif				/* _QIB_MAD_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
