From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibqueryerrors.c: changed the behavior when
 guid/DR-path not found
Date: Wed, 20 Feb 2013 13:52:10 +0200
Message-ID: <20130220115210.GB20018@r-ufm5-17.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Wed, 13 Feb 2013 11:05:42 +0200
Subject: [PATCH] infiniband-diags/ibqueryerrors.c: changed the behavior when guid/DR-path not found

If we use G or D options and we can't find the guid (sm is down or the
guid is wrong), we'll get an error instead of the result for all the
ports in the fabric.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/ibqueryerrors.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 076327c..6320972 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -935,16 +935,18 @@ int main(int argc, char **argv)
 	if (dr_path) {
 		if ((resolved =
 		     resolve_portid_str(ibd_ca, ibd_ca_port, &portid, dr_path,
-					IB_DEST_DRPATH, NULL, ibmad_port)) < 0)
-			IBWARN("Failed to resolve %s; attempting full scan",
-			       dr_path);
+					IB_DEST_DRPATH, NULL, ibmad_port)) < 0) {
+			IBWARN("Failed to resolve %s;",dr_path);
+			goto close_port;
+		}
 	} else if (port_guid_str) {
 		if ((resolved =
 		     resolve_portid_str(ibd_ca, ibd_ca_port, &portid,
 					port_guid_str, IB_DEST_GUID, ibd_sm_id,
-					       ibmad_port)) < 0)
-			IBWARN("Failed to resolve %s; attempting full scan",
-			       port_guid_str);
+					       ibmad_port)) < 0) {
+			IBWARN("Failed to resolve %s;",port_guid_str);
+			goto close_port;
+		}
 	}
 
 	if (load_cache_file) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
