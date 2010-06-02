From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH 2/2] infiniband-diags/libibnetdisc/chassis.c: In
	group_nodes, set fabric->chassis
Date: Wed, 2 Jun 2010 09:04:15 -0400
Message-ID: <20100602130415.GB4715@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


when grouping by SystemImageGUID

Without doing this, find_chassisguid will always return without
finding the already discovered chassis so no grouping occurs
when it should

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/chassis.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/chassis.c b/infiniband-diags/libibnetdisc/src/chassis.c
index f5f683e..25d7473 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.c
+++ b/infiniband-diags/libibnetdisc/src/chassis.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
  * Copyright (c) 2007 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2008 Lawrence Livermore National Lab.  All rights reserved.
+ * Copyright (c) 2010 HNR Consulting.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -1074,6 +1075,8 @@ int group_nodes(ibnd_fabric_t * fabric)
 				chassis_scan.current_chassis->chassisguid =
 				    get_chassisguid(node);
 				chassis_scan.current_chassis->nodecount = 1;
+				if (!fabric->chassis)
+					fabric->chassis = chassis_scan.first_chassis;
 			}
 		}
 	}
@@ -1107,5 +1110,6 @@ cleanup:
 		free(ch);
 		ch = ch_next;
 	}
+	fabric->chassis = NULL;
 	return -1;
 }
-- 
1.5.6.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
