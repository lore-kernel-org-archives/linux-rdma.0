From: =?UTF-8?q?Ana=20Guerrero=20L=C3=B3pez?= <ana-kLLpUjk7vcnYtjvyW6yDsg@public.gmane.org>
Subject: [infiniband-diags PATCH] rdma-ndd: fix compiler warnings.
Date: Wed, 22 Jul 2015 16:14:03 +0200
Message-ID: <1437574443-12850-1-git-send-email-ana@ekaia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: =?UTF-8?q?Ana=20Guerrero=20L=C3=B3pez?= <ana-kLLpUjk7vcnYtjvyW6yDsg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch fixes -Wformat-security warnings, that in Debian (and Ubuntu=
)
are enabled by default:

src/rdma-ndd.c: In function 'update_node_desc':
src/rdma-ndd.c:149:3: error: format not a string literal and no format =
arguments [-Werror=3Dformat-security]
   fprintf(f, new_nd);
   ^
src/rdma-ndd.c: In function 'udev_log_fn':
src/rdma-ndd.c:247:2: error: format not a string literal and no format =
arguments [-Werror=3Dformat-security]
  syslog(LOG_ERR, msg);

Signed-off-by: Ana Guerrero L=C3=B3pez <ana-kLLpUjk7vcnYtjvyW6yDsg@public.gmane.org>
---
 src/rdma-ndd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/rdma-ndd.c b/src/rdma-ndd.c
index d40e756..94eb3d7 100644
--- a/src/rdma-ndd.c
+++ b/src/rdma-ndd.c
@@ -145,7 +145,7 @@ static int update_node_desc(const char *device, con=
st char *hostname, int force)
 		syslog(LOG_INFO, "%s: change (%s) -> (%s)\n",
 			device, nd, new_nd);
 		rewind(f);
-		fprintf(f, new_nd);
+		fprintf(f, "%s", new_nd);
 	}
=20
 	rc =3D 0;
@@ -242,7 +242,7 @@ static void udev_log_fn(struct udev *ud, int priori=
ty, const char *file, int lin
 			file, line, fn);
 	if (off < MSG_MAX-1)
 		vsnprintf(msg+off, MSG_MAX-off, format, args);
-	syslog(LOG_ERR, msg);
+	syslog(LOG_ERR, "%s", msg);
 }
=20
 static void setup_udev(void)
--=20
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
