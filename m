From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: 4.5-rc iser issues
Date: Mon, 15 Feb 2016 09:45:13 +0200
Message-ID: <56C18209.7090903@dev.mellanox.co.il>
References: <20160214074119.GA24558@infradead.org>
 <56C04294.3090701@dev.mellanox.co.il> <56C05000.1040001@dev.mellanox.co.il>
 <56C066AF.6050901@dev.mellanox.co.il> <56C088EA.1050901@dev.mellanox.co.il>
 <20160214152223.GA5323@infradead.org>
 <CACVXFVNAkf5+XFyf2JkcfeEPO2sv9bqHMR+N+=kKFzrtXpFEnA@mail.gmail.com>
 <56C0AB84.9040004@dev.mellanox.co.il>
 <CACVXFVOBjT43CkzfG1gRz1A27BQRSJ2qKOZ91oU16ZbzUh7ejQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACVXFVOBjT43CkzfG1gRz1A27BQRSJ2qKOZ91oU16ZbzUh7ejQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ming Lin-SSI <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> I can reproduce the issue now, and it is easy to trigger it via your test
> code on scsi device, but a bit difficult to get it on null_blk.
>
> Turns out it is a block core issue, and it is in bio_will_gap() which gets
> the last bvec via 'bi_io_vec[prev->bi_vcnt - 1]' directly.  I have posted
> out one patchset for fixing the issue:
>
> http://marc.info/?l=linux-kernel&m=145551975429092&w=2

Thanks Ming!

I'll give it a shot...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
