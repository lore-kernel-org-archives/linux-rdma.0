From: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] contain pthreads defs with ifdef  HAVE_LIBPTHREAD
Date: Wed, 4 Nov 2009 12:58:33 -0800
Message-ID: <5C9312DA0BBF40CCBD2AA7437CECC6AE@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Contain pthread defs with HAVE_LIBPTHREAD

Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/opensm/libvendor/osm_vendor_ibumad.c b/opensm/libvendor/osm_vendor_ibumad.c
index 0f5a7ae..6cafc00 100644
--- a/opensm/libvendor/osm_vendor_ibumad.c
+++ b/opensm/libvendor/osm_vendor_ibumad.c
@@ -90,7 +90,11 @@ typedef struct _osm_umad_bind_info {
 } osm_umad_bind_info_t;
 
 typedef struct _umad_receiver {
+#ifdef HAVE_LIBPTHREAD
 	pthread_t tid;
+#else
+	cl_thread_t tid;
+#endif
 	osm_vendor_t *p_vend;
 	osm_log_t *p_log;
 } umad_receiver_t;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
