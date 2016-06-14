From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 4/5] nvmet-rdma: add a NVMe over Fabrics RDMA target
 driver
Date: Tue, 14 Jun 2016 07:31:32 -0700
Message-ID: <20160614143132.GA17800@infradead.org>
References: <1465248215-18186-1-git-send-email-hch@lst.de>
 <1465248215-18186-5-git-send-email-hch@lst.de>
 <5756B75C.9000409@lightbits.io>
 <057a01d1c2a3$3082eec0$9188cc40$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <057a01d1c2a3$3082eec0$9188cc40$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Sagi Grimberg' <sagi-ImC7XgPzLAfvYQKSrp0J2Q@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, 'Ming Lin' <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Jay Freyensee' <james.p.freyensee-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Armen Baloyan' <armenx.baloyan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 09, 2016 at 06:03:51PM -0500, Steve Wise wrote:
> The above nvmet cm event handler, nvmet_rdma_cm_handler(), calls
> nvmet_rdma_queue_connect() for CONNECT_REQUEST events, which calls
> nvmet_rdma_alloc_queue (), which, if it encounters a failure (like creating
> the qp), calls nvmet_rdma_cm_reject () which calls rdma_reject().  The
> non-zero error, however, gets returned back here and this function returns
> the error to the RDMA_CM which will also reject the connection as well as
> destroy the cm_id.  So there are two rejects happening, I think.  Either
> nvmet should reject and destroy the cm_id, or it should do neither and
> return non-zero to the RDMA_CM to reject/destroy.

Can you just send a patch?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
