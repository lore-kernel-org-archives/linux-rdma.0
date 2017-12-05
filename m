From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/cxgb4: Add a sanity check in process_work()
Date: Tue, 5 Dec 2017 17:36:54 +0300
Message-ID: <20171205143654.n5ybdhj3ga2tp7t4@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The story is that Smatch marks skb->data as untrusted so it generates
a warning message here:

    drivers/infiniband/hw/cxgb4/cm.c:4100 process_work()
    error: buffer overflow 'work_handlers' 241 <= 255

In other places which handle this such as t4_uld_rx_handler() there is
some checking to make sure that the function pointer is not NULL.  I
have added bounds checking and a check for NULL here as well.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 21db3b48a617..844c9e78df8b 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -4097,9 +4097,15 @@ static void process_work(struct work_struct *work)
 		dev = *((struct c4iw_dev **) (skb->cb + sizeof(void *)));
 		opcode = rpl->ot.opcode;
 
-		ret = work_handlers[opcode](dev, skb);
-		if (!ret)
+		if (opcode >= ARRAY_SIZE(work_handlers) ||
+		    !work_handlers[opcode]) {
+			pr_err("No handler for opcode 0x%x.\n", opcode);
 			kfree_skb(skb);
+		} else {
+			ret = work_handlers[opcode](dev, skb);
+			if (!ret)
+				kfree_skb(skb);
+		}
 		process_timedout_eps();
 	}
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
