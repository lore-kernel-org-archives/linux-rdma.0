From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] RDMA/nldev: missing error code in nldev_res_get_doit()
Date: Thu, 1 Feb 2018 13:01:48 +0300
Message-ID: <20180201100148.GA8959@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Steve Wise <swise@opengridcomputing.com>, Mark Bloch <markb@mellanox.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We should return -ENOMEM if the allocation fails.  The current code
accidentally returns success.

Fixes: bf3c5a93c523 ("RDMA/nldev: Provide global resource utilization")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index fa8655e3b3ed..5326a684555f 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -499,8 +499,10 @@ static int nldev_res_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EINVAL;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
+	if (!msg) {
+		ret = -ENOMEM;
 		goto err;
+	}
 
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_RES_GET),
