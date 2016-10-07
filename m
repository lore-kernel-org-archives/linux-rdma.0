From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 5/5] rxe_cfg: Use printf() instead of using a loop
Date: Fri, 7 Oct 2016 11:39:34 -0700
Message-ID: <278745ec-1e31-4379-27d9-40f371d30c29@sandisk.com>
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
 providers/rxe/rxe_cfg | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/providers/rxe/rxe_cfg b/providers/rxe/rxe_cfg
index 0a3dcf16957c..6c414fbda6fd 100755
--- a/providers/rxe/rxe_cfg
+++ b/providers/rxe/rxe_cfg
@@ -241,7 +241,6 @@ sub status_print {
     my @flen = ();
     my $num_fields = 0;
     my $i;
-    my $j;
     my $pad;
     my $line;
 
@@ -281,9 +280,7 @@ sub status_print {
 	    else {
 		print "   ";
 	    }
-	    for ($j = 0; $j < $pad; $j++) {
-		print " ";
-	    }
+	    printf("%*s", $pad, "");
 	}
 	print "\n";
     }
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
