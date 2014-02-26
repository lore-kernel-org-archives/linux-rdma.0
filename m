From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] saquery.c: In query_sa_cpi, make error message
 consistent
Date: Wed, 26 Feb 2014 10:25:43 -0500
Message-ID: <530E0777.1060606@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


with similar message in get_any_records

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/saquery.c b/src/saquery.c
index 837d8ae..0f39064 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -1432,7 +1432,7 @@ static int query_sa_cpi(struct sa_handle *h, struct query_params *query_params)
 	int ret = sa_query(h, IB_MAD_METHOD_GET, CLASS_PORT_INFO, 0, 0,
 		       ibd_sakey, NULL, 0, &result);
 	if (ret) {
-		fprintf(stderr, "ERROR: Query SA failed: %s\n", strerror(ret));
+		fprintf(stderr, "Query SA failed: %s\n", strerror(ret));
 		return ret;
 	}
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
