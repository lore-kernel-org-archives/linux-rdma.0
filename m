From: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH RFC v2 3/3] nvme-rdma: use rdma_reject_msg() to log
        connection rejects
Date: Mon, 24 Oct 2016 17:09:12 +0200
Message-ID: <20161024150912.GA6866@lst.de>
References: <cover.1477003235.git.swise@opengridcomputing.com> <60243a2ce17e08cdc93600b9998698dbd7f83306.1477003235.git.swise@opengridcomputing.com> <20161021122318.GB17325@lst.de> <005701d22c7f$0c883ed0$2598bc70$@opengridcomputing.com> <011d01d22e06$fd606480$f8212d80$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <011d01d22e06$fd606480$f8212d80$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 24, 2016 at 09:57:50AM -0500, Steve Wise wrote:
> > rdma_reject_msg() - protocol reject reason string

This one sounds useful on it's own.

> > rdma_is_consumer_reject() - true if the peer consumer/ulp rejected
> > rdma_consumer_reject_data() - ptr to any private data

I see why these are conceptually different, but why do we care
if something is a consumer reject except for printing what reject
we got (solved by rdma_reject_msg) or for getting consumer reject
data if there is any (solved by rdma_consumer_reject_data).

So all three helpers are fine with me, but rdma_is_consumer_reject
would be more of a low-level helper that drivers wouldn't use
directly, only through rdma_consumer_reject_data.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
