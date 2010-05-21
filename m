From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] use macro for tmp file path
Date: Fri, 21 May 2010 09:51:29 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E192562EBBB00@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Use defined macro for tmp file path

signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/opensm/opensm/st.c b/opensm/opensm/st.c
index ea76038..2d39117 100644
--- a/opensm/opensm/st.c
+++ b/opensm/opensm/st.c
@@ -174,7 +174,7 @@ static int init_st = 0;

 static void stat_col()
 {
-       FILE *f = fopen("/var/log/osm_st_col", "w");
+       FILE *f = fopen( OSM_DEFAULT_TMP_DIR "osm_st_col", "w");
        fprintf(f, "collision: %d\n", collision);
        fclose(f);
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
