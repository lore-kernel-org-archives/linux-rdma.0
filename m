From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v3 2/5] IB/srp: Use kstrtoull() instead of simple_strtoull()
Date: Mon,  8 Jan 2018 15:14:33 -0800
Message-ID: <20180108231436.19750-3-bart.vanassche@wdc.com>
References: <20180108231436.19750-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108231436.19750-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use kstrtoull() since simple_strtoull() is deprecated. This patch
improves error checking but otherwise does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 62d88212c1b0..39b3e43efbbe 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3111,6 +3111,7 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 	char *options, *sep_opt;
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
+	unsigned long long ull;
 	int opt_mask = 0;
 	int token;
 	int ret = -EINVAL;
@@ -3135,7 +3136,13 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 				ret = -ENOMEM;
 				goto out;
 			}
-			target->id_ext = cpu_to_be64(simple_strtoull(p, NULL, 16));
+			ret = kstrtoull(p, 16, &ull);
+			if (ret) {
+				pr_warn("invalid id_ext parameter '%s'\n", p);
+				kfree(p);
+				goto out;
+			}
+			target->id_ext = cpu_to_be64(ull);
 			kfree(p);
 			break;
 
@@ -3145,7 +3152,13 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 				ret = -ENOMEM;
 				goto out;
 			}
-			target->ioc_guid = cpu_to_be64(simple_strtoull(p, NULL, 16));
+			ret = kstrtoull(p, 16, &ull);
+			if (ret) {
+				pr_warn("invalid ioc_guid parameter '%s'\n", p);
+				kfree(p);
+				goto out;
+			}
+			target->ioc_guid = cpu_to_be64(ull);
 			kfree(p);
 			break;
 
@@ -3181,7 +3194,13 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 				ret = -ENOMEM;
 				goto out;
 			}
-			target->service_id = cpu_to_be64(simple_strtoull(p, NULL, 16));
+			ret = kstrtoull(p, 16, &ull);
+			if (ret) {
+				pr_warn("bad service_id parameter '%s'\n", p);
+				kfree(p);
+				goto out;
+			}
+			target->service_id = cpu_to_be64(ull);
 			kfree(p);
 			break;
 
@@ -3235,7 +3254,13 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 				ret = -ENOMEM;
 				goto out;
 			}
-			target->initiator_ext = cpu_to_be64(simple_strtoull(p, NULL, 16));
+			ret = kstrtoull(p, 16, &ull);
+			if (ret) {
+				pr_warn("bad initiator_ext value '%s'\n", p);
+				kfree(p);
+				goto out;
+			}
+			target->initiator_ext = cpu_to_be64(ull);
 			kfree(p);
 			break;
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
