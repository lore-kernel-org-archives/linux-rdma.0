From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/include/complib/cl_packon.h: Fix some commentary
 typos
Date: Mon, 07 Jan 2013 14:50:53 -0500
Message-ID: <50EB271D.7080407@dev.mellanox.co.il>
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
diff --git a/include/complib/cl_packon.h b/include/complib/cl_packon.h
index ffc8e11..e2e45b4 100644
--- a/include/complib/cl_packon.h
+++ b/include/complib/cl_packon.h
@@ -55,14 +55,14 @@
 *	not align properly for some platforms. Care must be taken when creating
 *	packed structures that the alignment rules for all platforms are followed.
 *
-*	To pack a structure, include ipackon.h before defining the structure, and
-*	include ipackoff.h after the structure definition.  Multiple structures
+*	To pack a structure, include cl_packon.h before defining the structure, and
+*	include cl_packoff.h after the structure definition.  Multiple structures
 *	can be packed between the two include statements if desired.
 *
 *	The structure definition itself must use the PACK_SUFFIX keyword.
 *
 * EXAMPLE
-*	#include <complib/ipackon.h>
+*	#include <complib/cl_packon.h>
 *
 *	typedef _my_struct_t
 *	{
@@ -71,7 +71,7 @@
 *	    uint16 small;
 *
 *	} PACK_SUFFIX my_struct_t;
-*	#include <complib/ipackoff.h>
+*	#include <complib/cl_packoff.h>
 *********/
 
 #ifndef PACK_SUFFIX
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
