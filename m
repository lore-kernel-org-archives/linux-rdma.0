From: "Stan C. Smith" <stan.smith@intel.com>
Subject: [PATCH] osmtest - fix signed unsigned comparisons
Date: Mon, 12 Oct 2009 10:21:29 -0700
Message-ID: <F7FAC243E7364BC582B7FCDBE42FB384@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: 'Sasha Khapyorsky' <sashak@voltaire.com>
Cc: ofw@lists.openfabrics.org, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


Make for loop index match loop termination comparison type.

Signed-off-by: stan smith <stan.smith@intel.com>

diff --git a/opensm/osmtest/main.c b/opensm/osmtest/main.c
index 4bb9f82..588a477 100644
--- a/opensm/osmtest/main.c
+++ b/opensm/osmtest/main.c
@@ -214,7 +214,7 @@ static void print_all_guids(IN osmtest_t * p_osmt)
 	ib_api_status_t status;
 	uint32_t num_ports = MAX_LOCAL_IBPORTS;
 	ib_port_attr_t attr_array[MAX_LOCAL_IBPORTS];
-	int i;
+	uint32_t i;
 
 	for (i = 0; i < num_ports; i++) {
 		attr_array[i].num_pkeys = 0;
@@ -247,7 +247,7 @@ ib_net64_t get_port_guid(IN osmtest_t * p_osmt, uint64_t port_guid)
 	ib_api_status_t status;
 	uint32_t num_ports = MAX_LOCAL_IBPORTS;
 	ib_port_attr_t attr_array[MAX_LOCAL_IBPORTS];
-	int i;
+	uint32_t i;
 
 	for (i = 0; i < num_ports; i++) {
 		attr_array[i].num_pkeys = 0;
diff --git a/opensm/osmtest/osmtest.c b/opensm/osmtest/osmtest.c
index c6ec955..a1457b8 100644
--- a/opensm/osmtest/osmtest.c
+++ b/opensm/osmtest/osmtest.c
@@ -7237,7 +7237,7 @@ osmtest_bind(IN osmtest_t * p_osmt,
 	ib_api_status_t status;
 	uint32_t num_ports = MAX_LOCAL_IBPORTS;
 	ib_port_attr_t attr_array[MAX_LOCAL_IBPORTS];
-	int i;
+	uint32_t i;
 
 	OSM_LOG_ENTER(&p_osmt->log);
