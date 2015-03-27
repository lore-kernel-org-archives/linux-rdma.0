From: Jens Domke <jens.domke-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
Subject: [PATCH 1/1] OpenSM: command line option ignore-guids broken
Date: Fri, 27 Mar 2015 10:00:52 +0100
Message-ID: <1427446852-11864-1-git-send-email-jens.domke@tu-dresden.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

this patch changes the documentation (--help and man page) from
--ignore-guids to --ignore_guids, so that it matches the implementation

Signed-off-by: Jens Domke <jens.domke-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
---
 doc/current-routing.txt | 2 +-
 man/opensm.8.in         | 6 +++---
 opensm/main.c           | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/doc/current-routing.txt b/doc/current-routing.txt
index d23ae0d..acfeb56 100644
--- a/doc/current-routing.txt
+++ b/doc/current-routing.txt
@@ -127,7 +127,7 @@ subscription is also equalized with the ability to override based on
 port GUID. The latter is supplied by:
 
 -i <equalize-ignore-guids-file>
--ignore-guids <equalize-ignore-guids-file>
+--ignore_guids <equalize-ignore-guids-file>
           This option provides the means to define a set of ports
           (by guids) that will be ignored by the link load
           equalization algorithm.
diff --git a/man/opensm.8.in b/man/opensm.8.in
index c1092cc..8ea127d 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -37,7 +37,7 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
 [\-\-maxsmps <number>]
 [\-\-console [off | local | socket | loopback]]
 [\-\-console-port <port>]
-[\-i(gnore-guids) <equalize-ignore-guids-file>]
+[\-i | \-\-ignore_guids <equalize-ignore-guids-file>]
 [\-w | \-\-hop_weights_file <path to file>]
 [\-O | \-\-port_search_ordering_file <path to file>]
 [\-O | \-\-dimn_ports_file <path to file>] (DEPRECATED)
@@ -298,7 +298,7 @@ Specify an alternate telnet port for the socket console (default 10000).
 Note that this option only appears if OpenSM was built with
 --enable-console-socket.
 .TP
-\fB\-i\fR, \fB\-\-ignore-guids\fR <equalize-ignore-guids-file>
+\fB\-i\fR, \fB\-\-ignore_guids\fR <equalize-ignore-guids-file>
 This option provides the means to define a set of ports
 (by node guid and port number) that will be ignored by the link load
 equalization algorithm.
@@ -987,7 +987,7 @@ port GUID. The latter is supplied by:
 
 -i <equalize-ignore-guids-file>
 .br
-\-\-ignore-guids <equalize-ignore-guids-file>
+\-\-ignore_guids <equalize-ignore-guids-file>
           This option provides the means to define a set of ports
           (by guid) that will be ignored by the link load
           equalization algorithm. Note that only endports (CA,
diff --git a/opensm/main.c b/opensm/main.c
index 6551a37..8419e68 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -289,7 +289,7 @@ static void show_usage(void)
 	       "          Specify an alternate telnet port for the console (default %d).\n\n",
 	       OSM_DEFAULT_CONSOLE_PORT);
 #endif
-	printf("--ignore-guids, -i <equalize-ignore-guids-file>\n"
+	printf("--ignore_guids, -i <equalize-ignore-guids-file>\n"
 	       "          This option provides the means to define a set of ports\n"
 	       "          (by guid) that will be ignored by the link load\n"
 	       "          equalization algorithm.\n\n");
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
