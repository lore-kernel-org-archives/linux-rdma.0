From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] opensm - use portable macro definition for tmp file path
Date: Fri, 21 May 2010 09:48:36 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E192562EBBAF6@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Use defined macro for tmp file path.

signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/opensm/opensm/osm_db_files.c b/opensm/opensm/osm_db_files.c
index dd9f772..5771e6e 100644
--- a/opensm/opensm/osm_db_files.c
+++ b/opensm/opensm/osm_db_files.c
@@ -615,7 +615,7 @@ int main(int argc, char **argv)
        cl_list_construct(&keys);
        cl_list_init(&keys, 10);

-       osm_log_init_v2(&log, TRUE, 0xff, "/var/log/osm_db_test.log", 0, FALSE);
+       osm_log_init_v2(&log, TRUE, 0xff, OSM_DEFAULT_TMP_DIR "osm_db_test.log", 0, FALSE);

        osm_db_construct(&db);
        if (osm_db_init(&db, &log)) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
