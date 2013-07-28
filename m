From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 4/4] Declare 'server_port' as an unsigned variable
Date: Sun, 28 Jul 2013 11:20:54 +0200
Message-ID: <51F4E276.2090800@acm.org>
References: <51F4E1B2.7070203@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51F4E1B2.7070203-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Change the data type of the 'server_port' variable from signed to
unsigned such that the cast in the fscanf() call can be removed.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 src/acm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 49bda48..33379cf 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -35,6 +35,7 @@
 #endif /* HAVE_CONFIG_H */
 
 #include <stdio.h>
+#include <inttypes.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <netdb.h>
@@ -113,7 +114,7 @@ struct acm_msg {
 
 static pthread_mutex_t acm_lock = PTHREAD_MUTEX_INITIALIZER;
 static int sock = -1;
-static short server_port;
+static uint16_t server_port;
 
 struct ib_connect_hdr {
 	uint8_t  cma_version;
@@ -132,7 +133,7 @@ static int ucma_set_server_port(void)
 	FILE *f;
 
 	if ((f = fopen("/var/run/ibacm.port", "r" STREAM_CLOEXEC))) {
-		fscanf(f, "%hu", (unsigned short *) &server_port);
+		fscanf(f, "%" SCNu16, &server_port);
 		fclose(f);
 	}
 	return server_port;
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
