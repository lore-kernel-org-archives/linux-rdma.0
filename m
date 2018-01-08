From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 2/4] IB/srp: Make the path record query error message more informative
Date: Mon,  8 Jan 2018 10:55:47 -0800
Message-ID: <20180108185549.30377-3-bart.vanassche@wdc.com>
References: <20180108185549.30377-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108185549.30377-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Show all path record query parameters if a path record query fails.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 39b3e43efbbe..fec6e800adf4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -702,7 +702,10 @@ static int srp_lookup_path(struct srp_rdma_ch *ch)
 	ret = ch->status;
 	if (ret < 0)
 		shost_printk(KERN_WARNING, target->scsi_host,
-			     PFX "Path record query failed\n");
+			     PFX "Path record query failed: sgid %pI6, dgid %pI6, pkey %#04x, service_id %#16llx\n",
+			     ch->path.sgid.raw, ch->path.dgid.raw,
+			     be16_to_cpu(target->pkey),
+			     be64_to_cpu(target->service_id));
 
 put:
 	scsi_host_put(target->scsi_host);
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
