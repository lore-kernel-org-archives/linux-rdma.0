From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/complib/cl_atomic_osd.h: Fix long standing bug in
 cl_atomic_sub
Date: Wed, 24 Oct 2012 09:42:01 -0400
Message-ID: <5087F029.7070200@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Should subtract rather than add decrement
Routine was same as cl_atomic_add other than parameter name
being decrement instead of increment so assume this is
cut 'n paste error
Nothing in opensm used this routine up to now

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/complib/cl_atomic_osd.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/complib/cl_atomic_osd.h b/include/complib/cl_atomic_osd.h
index 4df9618..822c19d 100644
--- a/include/complib/cl_atomic_osd.h
+++ b/include/complib/cl_atomic_osd.h
@@ -96,7 +96,7 @@ cl_atomic_sub(IN atomic32_t * const p_value, IN const int32_t decrement)
 	int32_t new_val;
 
 	cl_spinlock_acquire(&cl_atomic_spinlock);
-	new_val = *p_value + decrement;
+	new_val = *p_value - decrement;
 	*p_value = new_val;
 	cl_spinlock_release(&cl_atomic_spinlock);
 	return (new_val);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
