From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] nvmet-rdma: Fix missing dma sync to nvme data structures
Date: Fri, 13 Jan 2017 22:01:23 +0200
Message-ID: <45c8815c-d9a1-4a74-8a70-0a0ea11d8201@grimberg.me>
References: <1484261109-3316-1-git-send-email-parav@mellanox.com>
 <20170113074420.GA25814@lst.de>
 <VI1PR0502MB30086F641A07262801C02A28D1780@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <1f8d3db6-03b7-6c8f-8010-4ab964a87f3c@grimberg.me>
 <CAG53R5XGW-up2JtB_X29nPwbEGW14mvRBjnao8yOHczYUvvPgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG53R5XGW-up2JtB_X29nPwbEGW14mvRBjnao8yOHczYUvvPgg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Hi Sagi,

> If we keep the patch as it is in 4.10-rc, than I think IB/rxe will
> break with plays with virtual addresses.

I've been seeing reports that nvme-rdma is not
useable with rxe as it crashes pretty consistently.

In any event, we can either add this with 'ib_' prefix
into 4.10-rc and add a patch to Bart's series or
we can send a dedicated patch for stable.

Christoph, whats your preference?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
