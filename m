From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 1/8] IB/srpt: Do not accept invalid initiator port names
Date: Wed, 11 Oct 2017 10:27:22 -0700
Message-ID: <20171011172729.16984-2-bart.vanassche@wdc.com>
References: <20171011172729.16984-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011172729.16984-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Make srpt_parse_i_port_id() return a negative value if hex2bin()
fails.

Fixes: commit a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9e8e9220f816..95178b4e3565 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2777,7 +2777,7 @@ static int srpt_parse_i_port_id(u8 i_port_id[16], const char *name)
 {
 	const char *p;
 	unsigned len, count, leading_zero_bytes;
-	int ret, rc;
+	int ret;
 
 	p = name;
 	if (strncasecmp(p, "0x", 2) == 0)
@@ -2789,10 +2789,9 @@ static int srpt_parse_i_port_id(u8 i_port_id[16], const char *name)
 	count = min(len / 2, 16U);
 	leading_zero_bytes = 16 - count;
 	memset(i_port_id, 0, leading_zero_bytes);
-	rc = hex2bin(i_port_id + leading_zero_bytes, p, count);
-	if (rc < 0)
-		pr_debug("hex2bin failed for srpt_parse_i_port_id: %d\n", rc);
-	ret = 0;
+	ret = hex2bin(i_port_id + leading_zero_bytes, p, count);
+	if (ret < 0)
+		pr_debug("hex2bin failed for srpt_parse_i_port_id: %d\n", ret);
 out:
 	return ret;
 }
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
