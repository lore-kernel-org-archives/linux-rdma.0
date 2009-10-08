From: "Stan C. Smith" <stan.smith@intel.com>
Subject: [PATCH] opensm - add OSM_CDECL to qsort compare function
	definitions
Date: Thu, 8 Oct 2009 09:46:12 -0700
Message-ID: <6678A2C4663F40F3AC7B364C6ACFCC9F@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: 'Sasha Khapyorsky' <sashak@voltaire.com>
Cc: ofw@lists.openfabrics.org, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


X86 linkage requires __cdecl attribute on qsort() compare function definition; matches Windows qsort() prototype.
Add existing OSM_CDECL to qsort() compare function defintions.
OSM_CDECL defined blank for Linux.

Signed-off-by: stan smith <stan.smith@intel.com>

diff --git a/opensm/opensm/osm_mesh.c b/opensm/opensm/osm_mesh.c
index 9469420..a2a3a12 100644
--- a/opensm/opensm/osm_mesh.c
+++ b/opensm/opensm/osm_mesh.c
@@ -1368,7 +1368,7 @@ static int reorder_links(lash_t *p_lash, mesh_t *mesh)
 /*
  * compare two switches in a sort
  */
-static int compare_switches(const void *p1, const void *p2)
+static int OSM_CDECL compare_switches(const void *p1, const void *p2)
 {
 	const comp_t *cp1 = p1, *cp2 = p2;
 	const sort_ctx_t *ctx = &cp1->ctx;
diff --git a/opensm/opensm/osm_ucast_ftree.c b/opensm/opensm/osm_ucast_ftree.c
index 1defd95..bafe9ce 100644
--- a/opensm/opensm/osm_ucast_ftree.c
+++ b/opensm/opensm/osm_ucast_ftree.c
@@ -225,7 +225,7 @@ typedef struct ftree_fabric_t_ {
  **
  ***************************************************/
 
-static int compare_switches_by_index(IN const void *p1, IN const void *p2)
+static int OSM_CDECL compare_switches_by_index(IN const void *p1, IN const void *p2)
 {
 	ftree_sw_t **pp_sw1 = (ftree_sw_t **) p1;
 	ftree_sw_t **pp_sw2 = (ftree_sw_t **) p2;
@@ -242,7 +242,7 @@ static int compare_switches_by_index(IN const void *p1, IN const void *p2)
 
 /***************************************************/
 
-static int
+static int OSM_CDECL
 compare_port_groups_by_remote_switch_index(IN const void *p1, IN const void *p2)
 {
 	ftree_port_group_t **pp_g1 = (ftree_port_group_t **) p1;
diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast_mgr.c
index be37df9..57cf2ad 100644
--- a/opensm/opensm/osm_ucast_mgr.c
+++ b/opensm/opensm/osm_ucast_mgr.c
@@ -723,7 +723,7 @@ static void sw_count_endport_links(osm_switch_t * sw)
 	}
 }
 
-static int compar_sw_load(const void *s1, const void *s2)
+static int OSM_CDECL compar_sw_load(const void *s1, const void *s2)
 {
 #define get_sw_endport_links(s) (*(osm_switch_t **)s)->endport_links
 	return get_sw_endport_links(s2) - get_sw_endport_links(s1);
