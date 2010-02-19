From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] libibnetdisc: fix typo in man page for ibnd_show_progress
Date: Thu, 18 Feb 2010 18:09:11 -0800
Message-ID: <20100218180911.31e3ff67.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 2 Feb 2010 17:43:20 -0800
Subject: [PATCH] libibnetdisc: fix typo in man page for ibnd_show_progress


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 .../libibnetdisc/man/ibnd_discover_fabric.3        |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/man/ibnd_discover_fabric.3 b/infiniband-diags/libibnetdisc/man/ibnd_discover_fabric.3
index dfeaf47..e2394b6 100644
--- a/infiniband-diags/libibnetdisc/man/ibnd_discover_fabric.3
+++ b/infiniband-diags/libibnetdisc/man/ibnd_discover_fabric.3
@@ -22,7 +22,7 @@ free all memory and resources associated with the fabric.
 .B ibnd_debug()
 Set the debug level to be printed as library operations take place.
 
-.B ibnd_debug()
+.B ibnd_show_progress()
 Indicate that the library should print debug output which shows it's progress
 through the fabric.
 
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
