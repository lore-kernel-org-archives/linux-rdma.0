From: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] opensm - address windows env issues
Date: Tue, 25 May 2010 09:03:16 -0700
Message-ID: <4A4BD5F425D5495387BA92964E2873C8@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Add a Windows version of truncate_log_file().
Use the Windows flavor of vsprintf().

Would you prefer items of this nature as two separate patches?

thanks,

stan.

Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--- a/opensm/osm_log.c	2010-05-22 05:49:24.000000000 -0700
+++ b/opensm/osm_log.c	2010-05-24 11:40:07.823895800 -0700
@@ -96,8 +96,14 @@
 
 static void truncate_log_file(osm_log_t * p_log)
 {
-	fprintf(stderr,
-		"truncate_log_file: cannot truncate on windows system (yet)\n");
+	int fd = _fileno(p_log->out_port);
+	HANDLE hFile = (HANDLE) _get_osfhandle(fd);
+
+	if (_lseek(fd, 0, SEEK_SET) < 0)
+		fprintf(stderr, "truncate_log_file: cannot rewind: %s\n",
+			strerror(errno));
+	SetEndOfFile(hFile);
+	p_log->count = 0;
 }
 #endif				/* ndef __WIN__ */
 
@@ -123,12 +129,21 @@
 		return;
 
 	va_start(args, p_str);
+#ifndef __WIN__
 	if (p_log->log_prefix == NULL)
 		vsprintf(buffer, p_str, args);
 	else {
 		int n = snprintf(buffer, sizeof(buffer), "%s: ", p_log->log_prefix);
 		vsprintf(buffer + n, p_str, args);
 	}
+#else
+	if (p_log->log_prefix == NULL)
+		_vsnprintf(buffer, 1024, (LPSTR)p_str, args);
+	else {
+		int n = snprintf(buffer, sizeof(buffer), "%s: ", p_log->log_prefix);
+		_vsnprintf(buffer + n, (1024 - n), (LPSTR)p_str, args);
+	}
+#endif
 	va_end(args);
 
 	/* this is a call to the syslog */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
