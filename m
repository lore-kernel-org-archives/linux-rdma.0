From: "Stan C. Smith" <stan.smith@intel.com>
Subject: [PATCH] remove unnecessary leading '/' from filename
Date: Wed, 7 Oct 2009 16:46:43 -0700
Message-ID: <784A3771E5D143179461A7D5151AE78C@amr.corp.intel.com>
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


In osm_db_domain_init() the filename is appended to a path string 'db_dir_name' which contains a trailing '/'.
Remove extra '/'.

Signed-off-by: stan smith <stan.smith@intel.com>

diff --git a/opensm/opensm/osm_lid_mgr.c b/opensm/opensm/osm_lid_mgr.c
index 947fe7a..1704054 100644
--- a/opensm/opensm/osm_lid_mgr.c
+++ b/opensm/opensm/osm_lid_mgr.c
@@ -239,7 +239,7 @@ ib_api_status_t osm_lid_mgr_init(IN osm_lid_mgr_t * p_mgr, IN osm_sm_t * sm)
 	p_mgr->p_lock = sm->p_lock;
 
 	/* we initialize and restore the db domain of guid to lid map */
-	p_mgr->p_g2l = osm_db_domain_init(p_mgr->p_db, "/guid2lid");
+	p_mgr->p_g2l = osm_db_domain_init(p_mgr->p_db, "guid2lid");
 	if (!p_mgr->p_g2l) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR, "ERR 0316: "
 			"Error initializing Guid-to-Lid persistent database\n");
