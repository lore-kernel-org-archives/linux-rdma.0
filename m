From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 07/12] IB/srpt: Use the IPv6 format for GIDs in log messages
Date: Mon,  8 Jan 2018 11:00:46 -0800
Message-ID: <20180108190051.32008-8-bart.vanassche@wdc.com>
References: <20180108190051.32008-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108190051.32008-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make the ib_srpt driver use the IPv6 format for GIDs in log messages
to improve consistency of this driver with other RDMA kernel drivers.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index c5efe0afa2c8..25c5e188c740 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2010,17 +2010,9 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 
 	it_iu_len = be32_to_cpu(req->req_it_iu_len);
 
-	pr_info("Received SRP_LOGIN_REQ with i_port_id 0x%llx:0x%llx,"
-		" t_port_id 0x%llx:0x%llx and it_iu_len %d on port %d"
-		" (guid=0x%llx:0x%llx)\n",
-		be64_to_cpu(*(__be64 *)&req->initiator_port_id[0]),
-		be64_to_cpu(*(__be64 *)&req->initiator_port_id[8]),
-		be64_to_cpu(*(__be64 *)&req->target_port_id[0]),
-		be64_to_cpu(*(__be64 *)&req->target_port_id[8]),
-		it_iu_len,
-		param->port,
-		be64_to_cpu(*(__be64 *)&sdev->port[param->port - 1].gid.raw[0]),
-		be64_to_cpu(*(__be64 *)&sdev->port[param->port - 1].gid.raw[8]));
+	pr_info("Received SRP_LOGIN_REQ with i_port_id %pI6, t_port_id %pI6 and it_iu_len %d on port %d (guid=%pI6)\n",
+		req->initiator_port_id, req->target_port_id, it_iu_len,
+		param->port, &sport->gid);
 
 	rsp = kzalloc(sizeof(*rsp), GFP_KERNEL);
 	rej = kzalloc(sizeof(*rej), GFP_KERNEL);
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
