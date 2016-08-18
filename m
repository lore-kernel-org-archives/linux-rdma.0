From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 17/23] perftest_parameters: remove dead code in printf
Date: Thu, 18 Aug 2016 13:32:12 -0400
Message-ID: <1471541538-20270-18-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If we can only get into this block of printf's when tst == BW, there's not
much point in later testing to see if now tst == LAT. Remove pointless code.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/perftest_parameters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/perftest_parameters.c b/src/perftest_parameters.c
index 32ebea9..b18588f 100755
--- a/src/perftest_parameters.c
+++ b/src/perftest_parameters.c
@@ -311,7 +311,7 @@ static void usage(const char *argv0, VerbType verb, TestType tst, int connection
 
 	if (tst == BW) {
 		printf("  -t, --tx-depth=<dep> ");
-		printf(" Size of tx queue (default %d)\n",tst == LAT ? DEF_TX_LAT : DEF_TX_BW);
+		printf(" Size of tx queue (default %d)\n", DEF_TX_BW);
 	}
 
 	printf("  -T, --tos=<tos value> ");
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
