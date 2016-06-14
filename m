From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 4/5] nvmet-rdma: add a NVMe over Fabrics RDMA target driver
Date: Tue, 14 Jun 2016 10:23:17 -0500
Message-ID: <00eb01d1c650$ad232520$07696f60$@opengridcomputing.com>
References: <1465248215-18186-1-git-send-email-hch@lst.de> <1465248215-18186-5-git-send-email-hch@lst.de> <5756B75C.9000409@lightbits.io> <057a01d1c2a3$3082eec0$9188cc40$@opengridcomputing.com> <20160614143132.GA17800@infradead.org> <00ea01d1c64f$64db8880$2e929980$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00ea01d1c64f$64db8880$2e929980$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: 'Sagi Grimberg' <sagi-ImC7XgPzLAfvYQKSrp0J2Q@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, 'Ming Lin' <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Jay Freyensee' <james.p.freyensee-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Armen Baloyan' <armenx.baloyan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Either
> > > nvmet should reject and destroy the cm_id, or it should do neither and
> > > return non-zero to the RDMA_CM to reject/destroy.
> >
> > Can you just send a patch?
> 
> Yes, I'll send it out in a separate email.

Before I do, what do you think of this (untested)?

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index b1c6e5b..6f0c335 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1255,7 +1255,8 @@ static int nvmet_rdma_cm_handler(struct rdma_cm_id *cm_id,

        switch (event->event) {
        case RDMA_CM_EVENT_CONNECT_REQUEST:
-               ret = nvmet_rdma_queue_connect(cm_id, event);
+               if (nvmet_rdma_queue_connect(cm_id, event))
+                       rdma_destroy_id(cm_id);
                break;
        case RDMA_CM_EVENT_ESTABLISHED:
                nvmet_rdma_queue_established(queue);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
