From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/ib_types.h: Fix some commentary typos
Date: Fri, 6 Nov 2009 09:06:24 -0500
Message-ID: <20091106140624.GA19678@comcast.net>
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
diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib_types.h
index 677166b..f6a1cf4 100644
--- a/opensm/include/iba/ib_types.h
+++ b/opensm/include/iba/ib_types.h
@@ -5339,7 +5339,7 @@ ib_port_info_set_client_rereg(IN ib_port_info_t * const p_pi,
 *	ib_port_info_set_mcast_pkey_trap_suppress
 *
 * DESCRIPTION
-*	Sets the encoded multicast pkey trap suppresion enabled bit value
+*	Sets the encoded multicast pkey trap suppression enabled bit value
 *	in the PortInfo attribute.
 *
 * SYNOPSIS
@@ -5359,7 +5359,7 @@ ib_port_info_set_mcast_pkey_trap_suppress(IN ib_port_info_t * const p_pi,
 *		[in] Pointer to a PortInfo attribute.
 *
 *	trap_suppress
-*		[in] Multicast pkey trap suppresion enabled value to set
+*		[in] Multicast pkey trap suppression enabled value to set
 *		     (either 1 or 0).
 *
 * RETURN VALUES
@@ -5431,7 +5431,7 @@ ib_port_info_get_client_rereg(IN ib_port_info_t const *p_pi)
 *	ib_port_info_get_mcast_pkey_trap_suppress
 *
 * DESCRIPTION
-*	Gets the encoded multicast pkey trap suppresion enabled bit value
+*	Gets the encoded multicast pkey trap suppression enabled bit value
 *	in the PortInfo attribute.
 *
 * SYNOPSIS
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
