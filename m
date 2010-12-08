From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] ibacm: write port to /var/run/ibacm.port
Date: Wed, 8 Dec 2010 12:40:42 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8C1ECAD@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Write used port data to /var/run/ibacm.port.  This will allow
librdmacm and other libraries and applications to find the
ibacm service when it has been moved from its default port.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c    |    8 ++++++++
 src/libacm.c |   11 +++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index e035741..d9a81d9 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -1597,6 +1597,7 @@ static void CDECL_FUNC acm_retry_handler(void *context)
 
 static void acm_init_server(void)
 {
+	FILE *f;
 	int i;
 
 	for (i = 0; i < FD_SETSIZE - 1; i++) {
@@ -1605,6 +1606,13 @@ static void acm_init_server(void)
 		client[i].sock = INVALID_SOCKET;
 		atomic_init(&client[i].refcnt);
 	}
+
+	if (!(f = fopen("/var/run/ibacm.port", "w"))) {
+		acm_log(0, "notice - cannot publish ibacm port number\n");
+		return;
+	}
+	fprintf(f, "%hu\n", server_port);
+	fclose(f);
 }
 
 static int acm_listen(void)
diff --git a/src/libacm.c b/src/libacm.c
index 9d56cd2..3ce0cd0 100644
--- a/src/libacm.c
+++ b/src/libacm.c
@@ -57,6 +57,16 @@ extern lock_t lock;
 static SOCKET sock = INVALID_SOCKET;
 static short server_port = 6125;
 
+static void acm_set_server_port(void)
+{
+	FILE *f;
+
+	if ((f = fopen("/var/run/ibacm.port", "r"))) {
+		fscanf(f, "%hu", (unsigned short *) &server_port);
+		fclose(f);
+	}
+}
+
 int libacm_init(void)
 {
 	struct sockaddr_in addr;
@@ -66,6 +76,7 @@ int libacm_init(void)
 	if (ret)
 		return ret;
 
+	acm_set_server_port();
 	sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
 	if (sock == INVALID_SOCKET) {
 		ret = socket_errno();


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
