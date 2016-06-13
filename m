From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: generic NVMe over Fabrics library support V2
Date: Mon, 13 Jun 2016 16:45:20 +0200
Message-ID: <1465829128-22993-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set adds the necessary infrastructure for the NVMe over
Fabrics functionality and the NVMe over Fabrics library itself.

First we add some needed parameters to NVMe request allocation such as flags
(for reserved commands - connect and keep-alive), also support tag
allocation of a given queue ID (for connect to be executed per-queue)
and allow request to be queued at the head of the request queue (so
reconnects can pass in flight I/O).

Second, we add support for additional sysfs attributes that are needed
or useful for the Fabrics driver.

Third we add the NVMe over Fabrics related header definitions and the
Fabrics library itself which is transport independent and handles
Fabrics specific commands and variables.

Last, we add support for periodic keep-alive mechanism which is mandatory
for Fabrics.

Changes from V1:
 - don't directly free host->opts on connect failure (Sagi)
 - blk_mq_alloc_request_hctx improvements (Ming and me)
 - keep alive should not use blk_mq_alloc_request_hctx (me)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
