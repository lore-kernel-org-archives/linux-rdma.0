From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDS: suppress incompatible protocol when version is known
Date: Thu, 19 Apr 2012 12:15:29 -0400
Message-ID: <20120419161529.744.17527.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: venkat.x.venkatsubra-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

Add an else to only print the incompatible protocol message
when version hasn't been established.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 net/rds/ib_cm.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index a1e1162..31b74f5 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -434,12 +434,11 @@ static u32 rds_ib_protocol_compatible(struct rdma_cm_event *event)
 		version = RDS_PROTOCOL_3_0;
 		while ((common >>= 1) != 0)
 			version++;
-	}
-	printk_ratelimited(KERN_NOTICE "RDS: Connection from %pI4 using "
-			"incompatible protocol version %u.%u\n",
-			&dp->dp_saddr,
-			dp->dp_protocol_major,
-			dp->dp_protocol_minor);
+	} else
+		printk_ratelimited(KERN_NOTICE "RDS: Connection from %pI4 using incompatible protocol version %u.%u\n",
+				&dp->dp_saddr,
+				dp->dp_protocol_major,
+				dp->dp_protocol_minor);
 	return version;
 }
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
