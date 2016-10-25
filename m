From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v3 4/6] nvme-rdma: use rdma connection reject helper
 functions
Date: Tue, 25 Oct 2016 20:04:50 +0300
Message-ID: <97a0459f-6a4f-67d5-d9bc-f704f6ccf281@grimberg.me>
References: <cover.1477336045.git.swise@opengridcomputing.com>
 <55638a1d2a9f79af8b9a19eb444c5d0a41691352.1477336045.git.swise@opengridcomputing.com>
 <7191d136-aef4-9fed-223e-f2a9c1d958e5@grimberg.me>
 <20161025170238.GE9732@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161025170238.GE9732-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> On Tue, Oct 25, 2016 at 07:36:25PM +0300, Sagi Grimberg wrote:
>> I think it'd be better to move them to include/linux/nvme-rdma.h
>> and use them for logging on the target side too.
>
> Hmm, that would mean they get compiled into every source file.

"every source file" is exactly two...

> Also on the target side we can have free-form messages for whatever
> the exact rejection reason was, no need to limit us to the enum.

Thought it'd be nice to use the same verbosity on both ends, just a
suggestion though...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
