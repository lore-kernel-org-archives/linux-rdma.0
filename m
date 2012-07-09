From: Philipp Thomas <pth-l3A5Bk7waGM@public.gmane.org>
Subject: Behaviour when specifying '-g 0 -B'
Date: Mon, 9 Jul 2012 15:00:18 +0200
Message-ID: <20120709130018.GD15468@paradies.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently opensm will silently fail if you pass '-g0 -B'. As you can't ask
for a port, how about exiting with failure in daemonize. That way the user
would see the reason for opensm's failure.

Index: main.c
===================================================================
--- main.c.orig	2010-09-04 12:04:59.000000000 +0200
+++ main.c	2012-07-09 13:42:56.757934702 +0200
@@ -464,6 +464,11 @@ static int daemonize(osm_opensm_t * osm)
 	pid_t pid;
 	int fd;
 
+    if ( INVALID_GUID == opt.gui ) {
+        fputs(stderr, "opensm: Invalid GUID specified: exiting because of daemon mode");
+        return -1;
+    }
+
 	fd = open("/dev/null", O_WRONLY);
 	if (fd < 0) {
 		perror("open");

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
