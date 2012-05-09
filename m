From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: check_lft_balance.pl remove unused
 options
Date: Wed, 9 May 2012 14:15:26 -0700
Message-ID: <20120509141526.37b96832.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 scripts/check_lft_balance.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/check_lft_balance.pl b/scripts/check_lft_balance.pl
index 395096c..d848cb5 100755
--- a/scripts/check_lft_balance.pl
+++ b/scripts/check_lft_balance.pl
@@ -324,7 +324,7 @@ sub process_host_ports
 	}
 }
 
-if (!getopts("hl:i:evC:P:")) {
+if (!getopts("hl:i:ve")) {
 	usage();
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
