From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: IPv6 SNM update for man page and usage
Date: Thu, 26 Nov 2009 18:37:39 +0200
Message-ID: <20091126163739.GK13817@me>
References: <20091113061948.GJ7192@me>
 <20091113062104.GK7192@me>
 <20091113201144.GS7192@me>
 <20091113203856.GT7192@me>
 <20091113204041.GU7192@me>
 <f0e08f230911160735i69ad3671m9a2667900b933e13@mail.gmail.com>
 <20091126163634.GJ13817@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091126163634.GJ13817@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Update changed functionality of IPv6 SNM consolidation option in OpenSM
man page and the usage message.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/man/opensm.8.in |    4 ++--
 opensm/opensm/main.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/opensm/man/opensm.8.in b/opensm/man/opensm.8.in
index bd8ab4e..0baee7d 100644
--- a/opensm/man/opensm.8.in
+++ b/opensm/man/opensm.8.in
@@ -342,8 +342,8 @@ Specify the sweep time for the performance manager in seconds
 effect if --enable-perfmgr was specified at configure time.
 .TP
 .BI --consolidate_ipv6_snm_req
-Consolidate IPv6 Solicited Node Multicast group join requests into one
-multicast group per MGID PKey.
+Use shared MLID for IPv6 Solicited Node Multicast groups per MGID scope
+and P_Key.
 .TP
 \fB\-v\fR, \fB\-\-verbose\fR
 This option increases the log verbosity level.
diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
index 18efde1..fc002d8 100644
--- a/opensm/opensm/main.c
+++ b/opensm/opensm/main.c
@@ -322,8 +322,8 @@ static void show_usage(void)
 	       "          queries for off-subnet DGIDs.  Default file is:\n"
 	       "              " OSM_DEFAULT_PREFIX_ROUTES_FILE "\n\n");
 	printf("--consolidate_ipv6_snm_req\n"
-	       "          Consolidate IPv6 Solicited Node Multicast group joins\n"
-	       "          into 1 IB multicast group.\n\n");
+	       "          Use shared MLID for IPv6 Solicited Node Multicast groups\n"
+	       "          per MGID scope and P_Key.\n\n");
 	printf("--verbose, -v\n"
 	       "          This option increases the log verbosity level.\n"
 	       "          The -v option may be specified multiple times\n"
-- 
1.6.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
