From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 4/5] rxe_cfg: Remove dead code from show_module_status()
Date: Fri, 7 Oct 2016 11:39:17 -0700
Message-ID: <beb18346-316e-5d71-dce2-091d700797d6@sandisk.com>
References: <bf5dba39-7e14-23ee-4aa1-2a276d629fe9@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bf5dba39-7e14-23ee-4aa1-2a276d629fe9-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 providers/rxe/rxe_cfg | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/providers/rxe/rxe_cfg b/providers/rxe/rxe_cfg
index a4e9c0407a8b..0a3dcf16957c 100755
--- a/providers/rxe/rxe_cfg
+++ b/providers/rxe/rxe_cfg
@@ -300,23 +300,7 @@ sub check_module_status {
 
 # print driver load status and ethertype for rdma_rxe and rdma_rxe_net
 sub show_module_status {
-    my $rxe_loaded = 1;
-
-    if (!(-e $sys)) {
-	$rxe_loaded = 0;
-    }
-
-    if ($rxe_loaded) {
-	return 0;
-    }
-    elsif (!$rxe_loaded) {
-	print "rxe modules not loaded\n";
-	return 1;
-    }
-    else {
-	print "Configuration does not make sense\n";
-	return 1;
-    }
+    print "rdma_rxe module not loaded\n" if (!(-e $sys));
 }
 
 # print rxe status
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
