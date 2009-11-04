From: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] contain pthreads defs with ifdef  HAVE_LIBPTHREAD
Date: Wed, 4 Nov 2009 12:58:16 -0800
Message-ID: <F9EFFFF3BD1D442AB6AA993FD6F0B5D8@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Contain pthread definitions with ifdef HAVE_LIBPTHREAD

Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/opensm/include/vendor/osm_vendor_ibumad.h b/opensm/include/vendor/osm_vendor_ibumad.h
index 0a4692d..d523412 100644
--- a/opensm/include/vendor/osm_vendor_ibumad.h
+++ b/opensm/include/vendor/osm_vendor_ibumad.h
@@ -160,8 +160,13 @@ typedef struct _osm_vendor {
 	char ca_names[OSM_UMAD_MAX_CAS][UMAD_CA_NAME_LEN];
 	vendor_match_tbl_t mtbl;
 	umad_port_t umad_port;
+#ifdef HAVE_LIBPTHREAD
 	pthread_mutex_t cb_mutex;
 	pthread_mutex_t match_tbl_mutex;
+#else
+	cl_mutex_t cb_mutex;
+	cl_mutex_t match_tbl_mutex;
+#endif
 	int umad_port_id;
 	void *receiver;
 	int issmfd;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
