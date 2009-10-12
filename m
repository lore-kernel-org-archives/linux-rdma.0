From: "Stan C. Smith" <stan.smith@intel.com>
Subject: [PATCH] osmtest -code cleanup -  use strncasecmp()
Date: Mon, 12 Oct 2009 11:52:24 -0700
Message-ID: <5BD92B127714460C9672BD9230B397A0@amr.corp.intel.com>
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

diff --git a/opensm/osmtest/osmtest.c b/opensm/osmtest/osmtest.c
index c6ec955..423e836 100644
--- a/opensm/osmtest/osmtest.c
+++ b/opensm/osmtest/osmtest.c
@@ -59,10 +59,6 @@
 #include <complib/cl_debug.h>
 #include "osmtest.h"
 
-#ifndef __WIN__
-#define strnicmp strncasecmp
-#endif
-
 #define POOL_MIN_ITEMS  64
 #define MAX_LOCAL_IBPORTS 64
 
@@ -6169,7 +6165,7 @@ static const osmtest_token_t *str_get_token(IN char *const p_str)
 	p_tok = &token_array[index];
 
 	while (p_tok->val != OSMTEST_TOKEN_UNKNOWN) {
-		if (strnicmp(p_str, p_tok->str, p_tok->str_size) == 0)
+		if (strncasecmp(p_str, p_tok->str, p_tok->str_size) == 0)
 			return (p_tok);
 
 		p_tok = &token_array[++index];
