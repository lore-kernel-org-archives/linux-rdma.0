From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/4] IB/core: Add ib_is_udata_cleared
Date: Mon,  9 Nov 2015 18:30:55 +0200
Message-ID: <1447086657-15358-3-git-send-email-matanb@mellanox.com>
References: <1447086657-15358-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447086657-15358-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Extending core and vendor verb commands require us to check that the
unknown part of the user's given command is all zeros.
Adding ib_is_udata_cleared in order to do so.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e4cc389..43f3cf2 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1855,6 +1855,26 @@ static inline int ib_copy_to_udata(struct ib_udata *udata, void *src, size_t len
 	return copy_to_user(udata->outbuf, src, len) ? -EFAULT : 0;
 }
 
+static inline bool ib_is_udata_cleared(struct ib_udata *udata,
+				       char cleared_char,
+				       size_t offset,
+				       size_t len)
+{
+	short i;
+
+	for (i = 0; i < len; i++) {
+		char c;
+
+		if (copy_from_user(&c, udata->inbuf + offset + i, sizeof(c)))
+			return false;
+
+		if (c != cleared_char)
+			return false;
+	}
+
+	return true;
+}
+
 /**
  * ib_modify_qp_is_ok - Check that the supplied attribute mask
  * contains all required attributes and no attributes not allowed for
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
