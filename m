From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_vendor_ibumad.c: Fix explicit null derefenced
 issue found by coverity
Date: Tue, 30 Jul 2013 11:12:55 -0400
Message-ID: <51F7D7F7.3080004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

p_req_madw could be NULL before calling mad_recv_callback().
In CC and PM managers added ASSERTs to validate p_madw/p_req_madw
pointers.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_congestion_control.c |    5 +++++
 opensm/osm_perfmgr.c            |    3 +++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_congestion_control.c
b/opensm/osm_congestion_control.c
index ae8e3bb..1ab7307 100644
--- a/opensm/osm_congestion_control.c
+++ b/opensm/osm_congestion_control.c
@@ -626,6 +626,11 @@ static void cc_mad_recv_callback(osm_madw_t *
p_madw, void *bind_context,
  	OSM_LOG_ENTER(p_cc->log);
 +	CL_ASSERT(p_madw);
+
+	/* HACK - should be extended when supporting CC traps */
+	CL_ASSERT(p_req_madw != NULL);
+
 	osm_madw_copy_context(p_madw, p_req_madw);
 	osm_mad_pool_put(p_cc->mad_pool, p_req_madw);
 diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index a9b4c40..67cf187 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -175,6 +175,9 @@ static void perfmgr_mad_recv_callback(osm_madw_t *
p_madw, void *bind_context,
  	OSM_LOG_ENTER(pm->log);
 +	CL_ASSERT(p_madw);
+	CL_ASSERT(p_req_madw != NULL);
+
 	osm_madw_copy_context(p_madw, p_req_madw);
 	osm_mad_pool_put(pm->mad_pool, p_req_madw);
 -- 1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
