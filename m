From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/complib/cl_[ptr_]vector.h: Commentary change
 for consistency
Date: Tue, 17 Apr 2012 07:49:45 -0400
Message-ID: <4F8D58D9.4060403@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/complib/cl_ptr_vector.h b/include/complib/cl_ptr_vector.h
index d4af0fe..c767f31 100644
--- a/include/complib/cl_ptr_vector.h
+++ b/include/complib/cl_ptr_vector.h
@@ -254,7 +254,7 @@ cl_ptr_vector_init(IN cl_ptr_vector_t * const p_vector,
 *	p_vector
 *		[in] Pointer to a cl_ptr_vector_t structure to inititalize.
 *
-*	initial_size
+*	min_size
 *		[in] Initial number of elements.
 *
 *	grow_size
diff --git a/include/complib/cl_vector.h b/include/complib/cl_vector.h
index 11c45f8..f66172b 100644
--- a/include/complib/cl_vector.h
+++ b/include/complib/cl_vector.h
@@ -393,7 +393,7 @@ cl_vector_init(IN cl_vector_t * const p_vector,
 *	p_vector
 *		[in] Pointer to a cl_vector_t structure to inititalize.
 *
-*	initial_size
+*	min_size
 *		[in] Initial number of elements.
 *
 *	grow_size
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
