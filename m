From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 4/5] nvmet-rdma: add a NVMe over Fabrics RDMA target driver
Date: Fri, 8 Jul 2016 08:51:48 -0500
Message-ID: <003a01d1d91f$df60ed60$9e22c820$@opengridcomputing.com>
References: <1467809752-31320-1-git-send-email-hch@lst.de> <1467809752-31320-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467809752-31320-5-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, 'Armen Baloyan' <armenx.baloyan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jay Freyensee' <james.p.freyensee-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Ming Lin' <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This patch implements the RDMA transport for the NVMe over Fabrics target,
> which allows exporting NVMe over Fabrics functionality over RDMA fabrics
> (Infiniband, RoCE, iWARP).
> 
> All NVMe logic is in the generic target and this module just provides a
> small glue between it and the generic code in the RDMA subsystem.
> 
> Signed-off-by: Armen Baloyan <armenx.baloyan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
> Signed-off-by: Jay Freyensee <james.p.freyensee-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Looks good.

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
