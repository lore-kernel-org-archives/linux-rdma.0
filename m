From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v1] IB/srp: replace custom implementation of hex2bin()
Date: Mon, 11 Dec 2017 15:05:05 +0200
Message-ID: <20171211130505.34631-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

There is no need to have a duplication of the generic library, i.e.
hex2bin().

Replace the open coded variant.

Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 972d4b3c5223..62d88212c1b0 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3110,7 +3110,6 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 {
 	char *options, *sep_opt;
 	char *p;
-	char dgid[3];
 	substring_t args[MAX_OPT_ARGS];
 	int opt_mask = 0;
 	int token;
@@ -3162,16 +3161,10 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 				goto out;
 			}
 
-			for (i = 0; i < 16; ++i) {
-				strlcpy(dgid, p + i * 2, sizeof(dgid));
-				if (sscanf(dgid, "%hhx",
-					   &target->orig_dgid.raw[i]) < 1) {
-					ret = -EINVAL;
-					kfree(p);
-					goto out;
-				}
-			}
+			ret = hex2bin(target->orig_dgid.raw, p, 16);
 			kfree(p);
+			if (ret < 0)
+				goto out;
 			break;
 
 		case SRP_OPT_PKEY:
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
