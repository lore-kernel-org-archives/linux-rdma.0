From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: some warnings seen while building librdmacm 1.0.16
Date: Mon, 5 Nov 2012 20:06:21 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346AC5D2D@ORSMSX101.amr.corp.intel.com>
References: <508E71F4.8080205@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <508E71F4.8080205-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I've added the following patch to eliminate the fscanf warnings:

    rsocket: Remove fscanf build warnings
    
    Cast fscanf return values to (void) to indicate that we don't
    care if the call fails.  In the case of a failure, we simply
    fall back to using default values.
    
    Problem reported by Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    
    Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/src/rsocket.c b/src/rsocket.c
index 74dbcc7..58fcb8e 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -256,12 +256,12 @@ void rs_configure(void)
 		goto out;
 
 	if ((f = fopen(RS_CONF_DIR "/polling_time", "r"))) {
-		fscanf(f, "%u", &polling_time);
+		(void) fscanf(f, "%u", &polling_time);
 		fclose(f);
 	}
 
 	if ((f = fopen(RS_CONF_DIR "/inline_default", "r"))) {
-		fscanf(f, "%hu", &def_inline);
+		(void) fscanf(f, "%hu", &def_inline);
 		fclose(f);
 
 		if (def_inline < RS_MIN_INLINE)
@@ -269,17 +269,17 @@ void rs_configure(void)
 	}
 
 	if ((f = fopen(RS_CONF_DIR "/sqsize_default", "r"))) {
-		fscanf(f, "%hu", &def_sqsize);
+		(void) fscanf(f, "%hu", &def_sqsize);
 		fclose(f);
 	}
 
 	if ((f = fopen(RS_CONF_DIR "/rqsize_default", "r"))) {
-		fscanf(f, "%hu", &def_rqsize);
+		(void) fscanf(f, "%hu", &def_rqsize);
 		fclose(f);
 	}
 
 	if ((f = fopen(RS_CONF_DIR "/mem_default", "r"))) {
-		fscanf(f, "%u", &def_mem);
+		(void) fscanf(f, "%u", &def_mem);
 		fclose(f);
 
 		if (def_mem < 1)
@@ -287,14 +287,14 @@ void rs_configure(void)
 	}
 
 	if ((f = fopen(RS_CONF_DIR "/wmem_default", "r"))) {
-		fscanf(f, "%u", &def_wmem);
+		(void) fscanf(f, "%u", &def_wmem);
 		fclose(f);
 		if (def_wmem < RS_SNDLOWAT)
 			def_wmem = RS_SNDLOWAT << 1;
 	}
 
 	if ((f = fopen(RS_CONF_DIR "/iomap_size", "r"))) {
-		fscanf(f, "%hu", &def_iomap_size);
+		(void) fscanf(f, "%hu", &def_iomap_size);
 		fclose(f);
 
 		/* round to supported values */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
