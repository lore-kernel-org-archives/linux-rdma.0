From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 4/5] nvmet-rdma: add a NVMe over Fabrics RDMA target driver
Date: Tue, 14 Jun 2016 11:10:34 -0500
Message-ID: <00f501d1c657$483a74e0$d8af5ea0$@opengridcomputing.com>
References: <1465248215-18186-1-git-send-email-hch@lst.de> <1465248215-18186-5-git-send-email-hch@lst.de> <5756B75C.9000409@lightbits.io> <057a01d1c2a3$3082eec0$9188cc40$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <057a01d1c2a3$3082eec0$9188cc40$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-ImC7XgPzLAfvYQKSrp0J2Q@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Armen Baloyan' <armenx.baloyan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jay Freyensee' <james.p.freyensee-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Ming Lin' <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> The above nvmet cm event handler, nvmet_rdma_cm_handler(), calls
> nvmet_rdma_queue_connect() for CONNECT_REQUEST events, which calls
> nvmet_rdma_alloc_queue (), which, if it encounters a failure (like creating
> the qp), calls nvmet_rdma_cm_reject () which calls rdma_reject().  The
> non-zero error, however, gets returned back here and this function returns
> the error to the RDMA_CM which will also reject the connection as well as
> destroy the cm_id.  So there are two rejects happening, I think.  Either
> nvmet should reject and destroy the cm_id, or it should do neither and
> return non-zero to the RDMA_CM to reject/destroy.
> 
> Steve.
> 

Hey Sean, 

Am I correct here?  IE: Is it ok for the rdma application to rdma_reject() and
rmda_destroy_id() the CONNECT_REQUEST cm_id _inside_ its event handler as long
as it returns 0? 

Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
