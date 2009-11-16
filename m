From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_vendor_api.h: Fix commentary typo
Date: Mon, 16 Nov 2009 13:43:43 -0500
Message-ID: <20091116184343.GC2417@comcast.net>
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
index 5bf2abc..39ee33e 100644
--- a/opensm/include/vendor/osm_vendor_api.h
+++ b/opensm/include/vendor/osm_vendor_api.h
@@ -370,7 +370,7 @@ osm_vendor_send(IN osm_bind_handle_t h_bind,
 *
 * NOTES
 *   1. Only mads that expect a response are tracked for transaction competion.
-*   2. A mad that does not expect a response is being put back immediatly after
+*   2. A mad that does not expect a response is being put back immediately after
 *      being sent.
 *
 * SEE ALSO
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
