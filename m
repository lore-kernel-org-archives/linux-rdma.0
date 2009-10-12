From: "Stan C. Smith" <stan.smith@intel.com>
Subject: [PATCH] osmtest - clarify assignment operation
Date: Mon, 12 Oct 2009 10:17:12 -0700
Message-ID: <90026838F7CE447FBF3318901EC934FA@amr.corp.intel.com>
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


Clarify assignment & remove WDK compiler warning.

Signed-off-by: stan smith <stan.smith@intel.com>

diff --git a/opensm/osmtest/main.c b/opensm/osmtest/main.c
index 4bb9f82..6bfd7a6 100644
--- a/opensm/osmtest/main.c
+++ b/opensm/osmtest/main.c
@@ -433,7 +433,7 @@ int main(int argc, char *argv[])
 			/*
 			 * Specifies the max LID to search for during exploration.
 			 */
-			max_lid = atoi(optarg);
+			max_lid = (uint16_t) atoi(optarg);
 			printf("\tMAX-LID %u\n", max_lid);
 			break;
