From: "Stan C. Smith" <stan.smith@intel.com>
Subject: [PATCH] remove extraneous Windows include
Date: Tue, 27 Oct 2009 10:36:13 -0700
Message-ID: <B02046EB85824218B605F6B626420A92@amr.corp.intel.com>
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
Cc: linux-rdma@vger.kernel.org, ofw@lists.openfabrics.org
List-Id: linux-rdma@vger.kernel.org


Remove unneeded Windows include.

signed-off-by: stan smith <stan.smith@intel.com>

diff --git a/opensm/opensm/st.c b/opensm/opensm/st.c
index c5a2f53..ea76038 100644
--- a/opensm/opensm/st.c
+++ b/opensm/opensm/st.c
@@ -43,10 +43,6 @@
 #include <string.h>
 #include <opensm/st.h>
 
-#ifdef _WIN32
-#include <malloc.h>
-#endif
-
 typedef struct st_table_entry st_table_entry;
 
 struct st_table_entry {
