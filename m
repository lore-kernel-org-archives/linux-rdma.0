From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 1/6] opensm: Add .gitignore
Date: Tue, 11 Sep 2012 16:15:53 +0200
Message-ID: <504F4799.6020500@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 .gitignore |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..4dea307
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,43 @@
+*.la
+*.lo
+*.o
+.deps
+.libs
+aclocal.m4
+autom4te.cache/
+config.log
+config.status
+config/config.guess
+config/config.sub
+config/depcomp
+config/install-sh
+config/libtool.m4
+config/ltmain.sh
+config/ltoptions.m4
+config/ltsugar.m4
+config/ltversion.m4
+config/lt~obsolete.m4
+config/missing
+config/ylwrap
+configure
+include/config.h
+include/config.h.in
+include/opensm/osm_config.h
+include/opensm/osm_version.h
+include/opensm/stamp-h2
+include/stamp-h1
+libtool
+Makefile
+Makefile.in
+man/opensm.8
+man/torus-2QoS.8
+man/torus-2QoS.conf.5
+opensm.spec
+opensm/opensm
+opensm/osm_qos_parser_l.c
+opensm/osm_qos_parser_y.c
+opensm/osm_qos_parser_y.h
+osmtest/osmtest
+scripts/opensm.init
+scripts/redhat-opensm.init
+scripts/sldd.sh
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
