From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v2 0/3] Fix request completion holes
Date: Wed,  8 Nov 2017 12:06:13 +0200
Message-ID: <20171108100616.26605-1-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We have two holes in nvme-rdma when completing request.

1. We never wait for send work request to complete before completing
a request. It is possible that the HCA retries a send operation (due
to dropped ack) after the nvme cqe has already arrived back to the host.
If we unmap the host buffer upon reception of the cqe, the HCA might
get iommu errors when attempting to access an unmapped host buffer.
We must wait also for the send completion before completing a request,
most of the time it will be before the nvme cqe has arrived back so
we pay only for the extra cq entry processing.

2. We don't wait for the request memory region to be fully invalidated
in case the target didn't invalidate remotely. We must wait for the local
invalidation to complete before completing the request.

Note that we might face two concurrent completion processing contexts for
a single request. One is the ib_cq irq-poll context and the second is
blk_mq_poll which is invoked from IOCB_HIPRI requests. Thus we need the
completion flags updates (send/receive) to be atomic. A new request
lock is introduced to guarantee the mutual exclusion of the completion
flags updates.

Note that we could have used a per-queue lock for these updates (which
would have generated less locks as we have less queues), but given that
we access the request in the completion handlers we might benefit by having
the lock local in the request. I'm open to suggestions though.

Changes from v1:
- Added atomic send/resp_completed updated (via per-request lock)

Sagi Grimberg (3):
  nvme-rdma: don't suppress send completions
  nvme-rdma: don't complete requests before a send work request has
    completed
  nvme-rdma: wait for local invalidation before completing a request

 drivers/nvme/host/rdma.c | 125 ++++++++++++++++++++++++++---------------------
 1 file changed, 70 insertions(+), 55 deletions(-)

-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
