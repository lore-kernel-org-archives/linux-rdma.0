From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/complib/cl_ptr_vector.c: fix bug/compiler warning
Date: Tue, 02 Feb 2010 15:29:26 +0200
Message-ID: <4B6828B6.5050005@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

Fixing a bug in cl_ptr_vector_find_from_end(), discovered
by compiler's warning:

cl_ptr_vector.c: In function 'cl_ptr_vector_find_from_end':
cl_ptr_vector.c:305: warning: operation on 'i' may be undefined

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/complib/cl_ptr_vector.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/opensm/complib/cl_ptr_vector.c b/opensm/complib/cl_ptr_vector.c
index 8ccb9f0..36db4db 100644
--- a/opensm/complib/cl_ptr_vector.c
+++ b/opensm/complib/cl_ptr_vector.c
@@ -302,7 +302,8 @@ size_t cl_ptr_vector_find_from_end(IN const cl_ptr_vector_t * const p_vector,

 	while (i) {
 		/* Invoke the callback for the current element. */
-		if (pfn_callback(i, (void *)p_vector->p_ptr_array[--i],
+		i--;
+		if (pfn_callback(i, (void *)p_vector->p_ptr_array[i],
 				 (void *)context) == CL_SUCCESS) {
 			return (i);
 		}
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
