From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] osmtest: Make the "-guid" option's argument mandatory
Date: Fri, 28 Jun 2013 01:07:00 -0700
Message-ID: <1372406820-11505-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Currently, the getopt table in osmtest labels the "-guid" option as
taking an optional argument; however, running osmtest with the -guid
option but no argument just leads to:

    $ /usr/sbin/osmtest -guid

    Command Line Arguments
    Segmentation fault

because the handling for the -guid option just passes optarg directly to
strtoull(), and without and argument, optarg is NULL.  Really, the
argument should be mandatory.

This bug was found by the Mayhem tool:
http://www.forallsecure.com/bug-reports/edea01ceefbb188dcc62b3fc4f59dc743d7429c9/

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 osmtest/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/osmtest/main.c b/osmtest/main.c
index 6129674..f48910b 100644
--- a/osmtest/main.c
+++ b/osmtest/main.c
@@ -293,7 +293,7 @@ int main(int argc, char *argv[])
 		{"wait", 1, NULL, 'w'},
 		{"inventory", 1, NULL, 'i'},
 		{"max_lid", 1, NULL, 'm'},
-		{"guid", 2, NULL, 'g'},
+		{"guid", 1, NULL, 'g'},
 		{"port", 0, NULL, 'p'},
 		{"help", 0, NULL, 'h'},
 		{"stress", 1, NULL, 's'},
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
