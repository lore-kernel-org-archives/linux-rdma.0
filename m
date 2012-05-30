From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/complib/cl_fleximap.h: Cosmetic changes
Date: Wed, 30 May 2012 10:43:01 -0400
Message-ID: <4FC631F5.4020100@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Fix typo and some formatting changes

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/complib/cl_fleximap.h b/include/complib/cl_fleximap.h
index 7390a14..89bc7c0 100644
--- a/include/complib/cl_fleximap.h
+++ b/include/complib/cl_fleximap.h
@@ -462,8 +462,8 @@ static inline cl_fmap_item_t *cl_fmap_head(IN const cl_fmap_t * const p_map)
 /*
 * PARAMETERS
 *	p_map
-*		[in] Pointer to a cl_fmap_t structure whose item with the lowest key
-*		is returned.
+*		[in] Pointer to a cl_fmap_t structure whose item with the lowest
+*		key is returned.
 *
 * RETURN VALUES
 *	Pointer to the map item with the lowest key in the flexi map.
@@ -601,7 +601,7 @@ cl_fmap_item_t *cl_fmap_insert(IN cl_fmap_t * const p_map,
 *		[in] Pointer to the key value to assign to the item.  Storage
 *		for the key must be persistant, as only the pointer is stored.
 *		Users are responsible for maintaining the validity of key
-*		 pointers while they are in use.
+*		pointers while they are in use.
 *
 *	p_item
 *		[in] Pointer to a cl_fmap_item_t stucture to insert into the flexi map.
@@ -693,8 +693,8 @@ cl_fmap_item_t *cl_fmap_get(IN const cl_fmap_t * const p_map,
 *	cl_fmap_get_next
 *
 * DESCRIPTION
-*	The cl_fmap_get_next function returns the first map item associated with a
-*	key > the key specified.
+*	The cl_fmap_get_next function returns the first map item associated with
+*	a key > the key specified.
 *
 * SYNOPSIS
 */
@@ -744,7 +744,7 @@ cl_fmap_remove_item(IN cl_fmap_t * const p_map,
 *	This function does not return a value.
 *
 *	In a debug build, cl_fmap_remove_item asserts that the item being
-*	removed es in the specified map.
+*	removed is in the specified map.
 *
 * NOTES
 *	Removes the map item pointed to by p_item from its flexi map.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
