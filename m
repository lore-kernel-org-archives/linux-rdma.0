From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] IB/core: off by one in error handling
Date: Tue, 18 Aug 2015 12:23:17 +0300
Message-ID: <20150818092317.GF3965@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a zero offset array.  The current code could try to free random
memory and crash.  Also it leaks the first element.

Fixes: 230145ff8124 ('IB/core: Add RoCE GID table management')
Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index a9d5c70..f5d14a7 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -582,7 +582,7 @@ static int _gid_table_setup_one(struct ib_device *ib_dev)
 	return 0;
 
 rollback_table_setup:
-	for (port = 1; port <= ib_dev->phys_port_cnt; port++)
+	for (port = 0; port < ib_dev->phys_port_cnt; port++)
 		free_gid_table(ib_dev, port, table[port]);
 
 	kfree(table);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
