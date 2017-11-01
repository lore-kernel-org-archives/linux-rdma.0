From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 0/3] Fix request completion holes
Date: Wed, 1 Nov 2017 19:31:39 +0200
Message-ID: <5f3955d2-9116-5f18-2299-cc697947d599@grimberg.me>
References: <1509440122-1190-1-git-send-email-sagi@grimberg.me>
 <8abcde91-9150-2982-3900-078619bcdac0@mellanox.com>
 <a950a671-22a1-432c-555e-8309c8a64a88@grimberg.me>
 <d9dcdb05-d001-53d8-7ed7-5fafc1709f4a@mellanox.com>
 <20171101165036.GD1030@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171101165036.GD1030-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, idanb <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> (3) No send signal with invalidation signal w/o moderation 5.2M / 8.3M
> 
> Actually, isn't this valid and reasonable? You don't need to see the
> SEND completion, the only thing that matters is the invalidate
> completion, and the invalidate will naturally order after the send
> is finished, yes?

the default mode utilize remote invalidation, so no, its not valid.

Without remote invalidate I'm not sure, don't remember the ordering
rules from the top of my head. Idan, does a local invalidate completion
guarantee a prior send completion (of a non-related buffer)? I vaguely
remember that explicit fencing is required to guarantee that.

I guess we could not signal send completions if we are in a local
invalidate mode, but I'm liking this less and less...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
