From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] ibsim: Fix typo in help
Date: Wed, 15 Feb 2012 15:36:54 -0800
Message-ID: <1329349014.4779.1168.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 ibsim/ibsim.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ibsim/ibsim.c b/ibsim/ibsim.c
index e720f0d..e671175 100644
--- a/ibsim/ibsim.c
+++ b/ibsim/ibsim.c
@@ -704,7 +704,7 @@ void usage(char *prog_name)
 {
 	fprintf(stderr,
 		"Usage: %s [-f outfile -d(ebug) -p(arse_debug) -s(tart) -v(erbose) "
-		"-I(gnore_duplicate) -N nodes -S switchs -P ports -L linearcap"
+		"-I(gnore_duplicate) -N nodes -S switches -P ports -L linearcap"
 		" -M mcastcap -r(emote_mode) -l(isten_to_port) <port>] <netfile>\n",
 		prog_name);
 	fprintf(stderr, "%s %s\n", prog_name, IBSIM_VERSION);
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
