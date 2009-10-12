From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] osmtest: initialize attr_array[] on declaration
Date: Mon, 12 Oct 2009 23:36:31 +0200
Message-ID: <20091012213631.GF13830@me>
References: <F7FAC243E7364BC582B7FCDBE42FB384@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F7FAC243E7364BC582B7FCDBE42FB384-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Initialize attr_array[] arrays on declaration.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/osmtest/main.c    |   14 ++------------
 opensm/osmtest/osmtest.c |    8 +-------
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/opensm/osmtest/main.c b/opensm/osmtest/main.c
index 11bb0c8..4cead91 100644
--- a/opensm/osmtest/main.c
+++ b/opensm/osmtest/main.c
@@ -213,14 +213,9 @@ static void print_all_guids(IN osmtest_t * p_osmt)
 {
 	ib_api_status_t status;
 	uint32_t num_ports = MAX_LOCAL_IBPORTS;
-	ib_port_attr_t attr_array[MAX_LOCAL_IBPORTS];
+	ib_port_attr_t attr_array[MAX_LOCAL_IBPORTS] = { {0} };
 	uint32_t i;
 
-	for (i = 0; i < num_ports; i++) {
-		attr_array[i].num_pkeys = 0;
-		attr_array[i].p_pkey_table = NULL;
-	}
-
 	/*
 	   Call the transport layer for a list of local port
 	   GUID values.
@@ -246,14 +241,9 @@ ib_net64_t get_port_guid(IN osmtest_t * p_osmt, uint64_t port_guid)
 {
 	ib_api_status_t status;
 	uint32_t num_ports = MAX_LOCAL_IBPORTS;
-	ib_port_attr_t attr_array[MAX_LOCAL_IBPORTS];
+	ib_port_attr_t attr_array[MAX_LOCAL_IBPORTS] = { {0} };
 	uint32_t i;
 
-	for (i = 0; i < num_ports; i++) {
-		attr_array[i].num_pkeys = 0;
-		attr_array[i].p_pkey_table = NULL;
-	}
-
 	/*
 	   Call the transport layer for a list of local port
 	   GUID values.
diff --git a/opensm/osmtest/osmtest.c b/opensm/osmtest/osmtest.c
index a1457b8..9dd1117 100644
--- a/opensm/osmtest/osmtest.c
+++ b/opensm/osmtest/osmtest.c
@@ -7236,16 +7236,10 @@ osmtest_bind(IN osmtest_t * p_osmt,
 	uint32_t port_index;
 	ib_api_status_t status;
 	uint32_t num_ports = MAX_LOCAL_IBPORTS;
-	ib_port_attr_t attr_array[MAX_LOCAL_IBPORTS];
-	uint32_t i;
+	ib_port_attr_t attr_array[MAX_LOCAL_IBPORTS] = { {0} };
 
 	OSM_LOG_ENTER(&p_osmt->log);
 
-	for (i = 0; i < num_ports; i++) {
-		attr_array[i].num_pkeys = 0;
-		attr_array[i].p_pkey_table = NULL;
-	}
-
 	/*
 	 * Call the transport layer for a list of local port
 	 * GUID values.
-- 
1.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
