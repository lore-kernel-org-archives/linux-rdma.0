From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] complib/cl_fleximap: add cl_fmap_match() function
Date: Fri, 13 Nov 2009 22:38:56 +0200
Message-ID: <20091113203856.GT7192@me>
References: <20091113061948.GJ7192@me>
 <20091113062104.GK7192@me>
 <20091113201144.GS7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091113201144.GS7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add cl_fmap_match() function - it is similar for cl_fmap_get() (getting
fleximap item by key) with difference that instead of using the map's
default comparison routine custom compare function can be passed there
as a parameter.

This can be useful for matching map item by a key pattern.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---

This function is used in IPv6 SNM MGID compression patch.

 opensm/complib/cl_map.c              |   14 ++++++++++--
 opensm/complib/libosmcomp.map        |    1 +
 opensm/include/complib/cl_fleximap.h |   36 ++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/opensm/complib/cl_map.c b/opensm/complib/cl_map.c
index d851bf8..f5fb1f3 100644
--- a/opensm/complib/cl_map.c
+++ b/opensm/complib/cl_map.c
@@ -1144,8 +1144,9 @@ void cl_fmap_init(IN cl_fmap_t * const p_map, IN cl_pfn_fmap_cmp_t pfn_compare)
 	cl_fmap_remove_all(p_map);
 }
 
-cl_fmap_item_t *cl_fmap_get(IN const cl_fmap_t * const p_map,
-			    IN const void *const p_key)
+cl_fmap_item_t *cl_fmap_match(IN const cl_fmap_t * const p_map,
+			      IN const void *const p_key,
+			      IN cl_pfn_fmap_cmp_t pfn_compare)
 {
 	cl_fmap_item_t *p_item;
 	int cmp;
@@ -1156,7 +1157,8 @@ cl_fmap_item_t *cl_fmap_get(IN const cl_fmap_t * const p_map,
 	p_item = __cl_fmap_root(p_map);
 
 	while (p_item != &p_map->nil) {
-		cmp = p_map->pfn_compare(p_key, p_item->p_key);
+		cmp = pfn_compare ? pfn_compare(p_key, p_item->p_key) :
+			p_map->pfn_compare(p_key, p_item->p_key);
 
 		if (!cmp)
 			break;	/* just right */
@@ -1170,6 +1172,12 @@ cl_fmap_item_t *cl_fmap_get(IN const cl_fmap_t * const p_map,
 	return (p_item);
 }
 
+cl_fmap_item_t *cl_fmap_get(IN const cl_fmap_t * const p_map,
+			    IN const void *const p_key)
+{
+	return cl_fmap_match(p_map, p_key, p_map->pfn_compare);
+}
+
 cl_fmap_item_t *cl_fmap_get_next(IN const cl_fmap_t * const p_map,
 				 IN const void *const p_key)
 {
diff --git a/opensm/complib/libosmcomp.map b/opensm/complib/libosmcomp.map
index 788eb2a..52410cc 100644
--- a/opensm/complib/libosmcomp.map
+++ b/opensm/complib/libosmcomp.map
@@ -66,6 +66,7 @@ OSMCOMP_2.3 {
 		cl_map_merge;
 		cl_map_delta;
 		cl_fmap_init;
+		cl_fmap_match;
 		cl_fmap_get;
 		cl_fmap_get_next;
 		cl_fmap_apply_func;
diff --git a/opensm/include/complib/cl_fleximap.h b/opensm/include/complib/cl_fleximap.h
index ec008cf..b74040f 100644
--- a/opensm/include/complib/cl_fleximap.h
+++ b/opensm/include/complib/cl_fleximap.h
@@ -619,6 +619,42 @@ cl_fmap_item_t *cl_fmap_insert(IN cl_fmap_t * const p_map,
 *	Flexi Map, cl_fmap_remove, cl_fmap_item_t
 *********/
 
+/****f* Component Library: Flexi Map/cl_fmap_match
+* NAME
+*	cl_fmap_get
+*
+* DESCRIPTION
+*	The cl_fmap_match function returns the map item matching a key.
+*
+* SYNOPSIS
+*/
+cl_fmap_item_t *cl_fmap_match(IN const cl_fmap_t * const p_map,
+			      IN const void *const p_key,
+			      IN cl_pfn_fmap_cmp_t pfn_compare);
+/*
+* PARAMETERS
+*	p_map
+*		[in] Pointer to a cl_fmap_t structure from which to retrieve the
+*		item with the specified key.
+*
+*	p_key
+*		[in] Pointer to a key value used to search for the desired map item.
+*
+*	pfn_compare
+*		[in] Pointer to a compare function to invoke to compare the
+*		keys of items in the map. Passing NULL here makes such call
+*		to be equivalent to using cl_fmap_get().
+*
+* RETURN VALUES
+*	Pointer to the map item matching the desired key value.
+*
+*	Pointer to the map end if there was no item matching the desired key
+*	value stored in the flexi map.
+*
+* SEE ALSO
+*	Flexi Map, cl_fmap_remove, cl_fmap_get
+*********/
+
 /****f* Component Library: Flexi Map/cl_fmap_get
 * NAME
 *	cl_fmap_get
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
