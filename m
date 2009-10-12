From: "Stan C. Smith" <stan.smith@intel.com>
Subject: [PATCH] osmtest - Add OSM_CDECL to main() declaration
Date: Mon, 12 Oct 2009 10:10:28 -0700
Message-ID: <41F5872023464A3C8FD5828F037B4D77@amr.corp.intel.com>
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



Signed-off-by: stan smith <stan.smith@intel.com>

diff --git a/opensm/osmtest/main.c b/opensm/osmtest/main.c
index 4bb9f82..287baf3 100644
--- a/opensm/osmtest/main.c
+++ b/opensm/osmtest/main.c
@@ -285,7 +285,7 @@ ib_net64_t get_port_guid(IN osmtest_t * p_osmt, uint64_t port_guid)
 
 /**********************************************************************
  **********************************************************************/
-int main(int argc, char *argv[])
+int OSM_CDECL main(int argc, char *argv[])
 {
 	static osmtest_t osm_test;
 	osmtest_opt_t opt = { 0 };
