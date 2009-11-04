From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_switch.h: Remove dead osm_switch_get_physp_ptr
	routine
Date: Wed, 4 Nov 2009 09:29:08 -0500
Message-ID: <20091104142908.GA7316@comcast.net>
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
diff --git a/opensm/include/opensm/osm_switch.h b/opensm/include/opensm/osm_switch.h
index bb52e84..205896d 100644
--- a/opensm/include/opensm/osm_switch.h
+++ b/opensm/include/opensm/osm_switch.h
@@ -427,37 +427,6 @@ static inline uint8_t osm_switch_get_port_by_lid(IN const osm_switch_t * p_sw,
 *	Switch object
 *********/
 
-/****f* OpenSM: Switch/osm_switch_get_physp_ptr
-* NAME
-*	osm_switch_get_physp_ptr
-*
-* DESCRIPTION
-*	Gets the Physical Port Object at the specified port number.
-*
-* SYNOPSIS
-*/
-osm_physp_t *osm_switch_get_physp_ptr(IN const osm_switch_t * p_sw,
-				      IN uint32_t port_num);
-/*
-* PARAMETERS
-*	p_sw
-*		[in] Pointer to an osm_switch_t object.
-*
-*	port_num
-*		[in] Port number for which to retrieve the Physical Port Object.
-*
-* RETURN VALUES
-*	Returns a pointer to the Physical Port Object object at the specified
-*	port number.
-*	A return value of zero means the port number was out of range.
-*
-*
-* NOTES
-*
-* SEE ALSO
-*	Switch object
-*********/
-
 /****f* OpenSM: Switch/osm_switch_get_route_by_lid
 * NAME
 *	osm_switch_get_route_by_lid
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
