From: "Davis, Arlin R" <arlin.r.davis@intel.com>
Subject: [PATCH 3/5] dapltest: set default limit max to 1000
Date: Thu, 13 Mar 2014 17:05:00 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F972E0C8FA@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc: "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>, "ewg@lists.openfabrics.org" <ewg@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Arlin Davis <arlin.r.davis@intel.com>
---
 test/dapltest/cmd/dapl_limit_cmd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/test/dapltest/cmd/dapl_limit_cmd.c b/test/dapltest/cmd/dapl_limit_cmd.c
index e59707e..77e1ae4 100644
--- a/test/dapltest/cmd/dapl_limit_cmd.c
+++ b/test/dapltest/cmd/dapl_limit_cmd.c
@@ -36,7 +36,7 @@ void DT_Limit_Cmd_Init(Limit_Cmd_t * cmd)
 	memset((void *)cmd, 0, sizeof(Limit_Cmd_t));
 	cmd->ReliabilityLevel = DAT_QOS_BEST_EFFORT;
 	cmd->width = 1;
-	cmd->maximum = ~0U;
+	cmd->maximum = 1000;
 	cmd->port = SERVER_PORT_NUMBER;
 }
 
@@ -197,6 +197,7 @@ void DT_Limit_Cmd_Usage(void)
 	DT_Mdep_printf("USAGE:              [-d] : debug (zero)\n");
 	DT_Mdep_printf("USAGE:              [-w <width_of_resource_sets>]\n");
 	DT_Mdep_printf("USAGE:              [-m <maximum_for_exhaustion_tests>]\n");
+	DT_Mdep_printf("USAGE:                  (1000 - Default)\n");
 	DT_Mdep_printf("USAGE:              [-R <service reliability>]\n");
 	DT_Mdep_printf("USAGE:                  (BE == QOS_BEST_EFFORT - Default)\n");
 	DT_Mdep_printf("USAGE:                  (HT == QOS_HIGH_THROUGHPUT)\n");
-- 
1.7.3
