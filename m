From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_vendor_api.h: Fix some commentary typos
Date: Mon, 19 Oct 2009 09:02:11 -0400
Message-ID: <20091019130211.GB18483@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/include/vendor/osm_vendor_api.h b/opensm/include/vendor/osm_vendor_api.h
index 70eb6cc..5bf2abc 100644
--- a/opensm/include/vendor/osm_vendor_api.h
+++ b/opensm/include/vendor/osm_vendor_api.h
@@ -172,9 +172,9 @@ void osm_vendor_delete(IN osm_vendor_t ** const pp_vend);
 * SEE ALSO
 *********/
 
-/****f* OpenSM Vendor API/osm_vendor_get_ports
+/****f* OpenSM Vendor API/osm_vendor_get_all_port_attr
 * NAME
-*  osm_vendor_get_ports
+*  osm_vendor_get_all_port_attr
 *
 * DESCRIPTION
 *  Returns an array of available port attribute structures.
@@ -197,7 +197,7 @@ osm_vendor_get_all_port_attr(IN osm_vendor_t * const p_vend,
 *
 *  p_num_ports
 *     [in/out] Pointer to a variable to hold the total number of ports
-*     available on the local machine..
+*     available on the local machine.
 *
 * RETURN VALUES
 *  IB_SUCCESS on success.
@@ -219,8 +219,8 @@ osm_vendor_get_all_port_attr(IN osm_vendor_t * const p_vend,
 * SYNOPSIS
 */
 ib_api_status_t
-osm_vendor_init(IN osm_vendor_t * const p_vend,
-		IN osm_log_t * const p_log, IN const uint32_t timeout);
+osm_vendor_init(IN osm_vendor_t * const p_vend, IN osm_log_t * const p_log,
+		IN const uint32_t timeout);
 /*
 * PARAMETERS
 *  p_vend
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
