From: Sagi Grimberg <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] nvmet-rdma: add a NVMe over Fabrics RDMA target
 driver
Date: Wed, 15 Jun 2016 21:32:30 +0300
Message-ID: <57619F3E.6070903@gmail.com>
References: <1465248215-18186-1-git-send-email-hch@lst.de>
 <1465248215-18186-5-git-send-email-hch@lst.de>
 <5756B75C.9000409@lightbits.io>
 <057a01d1c2a3$3082eec0$9188cc40$@opengridcomputing.com>
 <00f501d1c657$483a74e0$d8af5ea0$@opengridcomputing.com>
 <00f701d1c658$efd720d0$cf856270$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00f701d1c658$efd720d0$cf856270$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Sagi Grimberg' <sagi-ImC7XgPzLAfvYQKSrp0J2Q@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Armen Baloyan' <armenx.baloyan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jay Freyensee' <james.p.freyensee-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Ming Lin' <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> Looking at rdma_destroy_id(), I think it is invalid to call it from the event
> handler:

...

>
> So I withdraw my comment about nvmet.  I think the code is fine as-is.  The 2nd
> reject results in a no-op since the connection request was rejected by nvmet.

I was just catching up on this after a short vacation, just what I was
about to comment, thanks Steve :)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
