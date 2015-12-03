From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 2/5] IB/core: Add ib_is_udata_cleared
Date: Thu,  3 Dec 2015 17:44:20 +0200
Message-ID: <1449157463-25313-3-git-send-email-matanb@mellanox.com>
References: <1449157463-25313-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449157463-25313-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Extending core and vendor verb commands require us to check that the
unknown part of the user's given command is all zeros.
Adding ib_is_udata_cleared in order to do so.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 31fb409..0ad89e3 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1947,6 +1947,73 @@ static inline int ib_copy_to_udata(struct ib_udata *udata, void *src, size_t len
 	return copy_to_user(udata->outbuf, src, len) ? -EFAULT : 0;
 }
 
+#define IB_UDATA_ELEMENT_CLEARED(type, ptr, len, expected)		\
+		({type v;						\
+		  typeof(ptr) __ptr = ptr;				\
+									\
+		  ptr = (void *)ptr + sizeof(type);			\
+		  len -= sizeof(type);					\
+		  !copy_from_user(&v, __ptr, sizeof(v)) && (v == expected); })
+
+static inline bool ib_is_udata_cleared(struct ib_udata *udata,
+				       u8 cleared_char,
+				       size_t offset,
+				       size_t len)
+{
+	const void __user *p = udata->inbuf + offset;
+#ifdef CONFIG_64BIT
+	u64 expected = cleared_char;
+#else
+	u32 expected = cleared_char;
+#endif
+
+	if (len > USHRT_MAX)
+		return false;
+
+	if (len && (uintptr_t)p & 1)
+		if (!IB_UDATA_ELEMENT_CLEARED(u8, p, len, expected))
+			return false;
+
+	expected = expected << 8 | expected;
+	if (len >= 2 && (uintptr_t)p & 2)
+		if (!IB_UDATA_ELEMENT_CLEARED(u16, p, len, expected))
+			return false;
+
+	expected = expected << 16 | expected;
+#ifdef CONFIG_64BIT
+	if (len >= 4 && (uintptr_t)p & 4)
+		if (!IB_UDATA_ELEMENT_CLEARED(u32, p, len, expected))
+			return false;
+
+	expected = expected << 32 | expected;
+#define IB_UDATA_CLEAR_LOOP_TYPE	u64
+#else
+#define IB_UDATA_CLEAR_LOOP_TYPE	u32
+#endif
+	while (len >= sizeof(IB_UDATA_CLEAR_LOOP_TYPE))
+		if (!IB_UDATA_ELEMENT_CLEARED(IB_UDATA_CLEAR_LOOP_TYPE, p, len,
+					      expected))
+			return false;
+
+#ifdef CONFIG_64BIT
+	expected = expected >> 32;
+	if (len >= 4 && (uintptr_t)p & 4)
+		if (!IB_UDATA_ELEMENT_CLEARED(u32, p, len, expected))
+			return false;
+#endif
+	expected = expected >> 16;
+	if (len >= 2 && (uintptr_t)p & 2)
+		if (!IB_UDATA_ELEMENT_CLEARED(u16, p, len, expected))
+			return false;
+
+	expected = expected >> 8;
+	if (len)
+		if (!IB_UDATA_ELEMENT_CLEARED(u8, p, len, expected))
+			return false;
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
