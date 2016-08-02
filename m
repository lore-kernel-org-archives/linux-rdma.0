From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v3] nvmet-rdma: Correctly handle RDMA device hot removal
Date: Tue, 2 Aug 2016 09:39:48 +0300
Message-ID: <dc6286c3-a5c0-48a8-284d-f53b6830da22@grimberg.me>
References: <1469967347-20466-1-git-send-email-sagi@grimberg.me>
 <20160801111530.GB16474@lst.de>
 <307087d1-88af-5244-38e8-5b9786285488@grimberg.me>
 <20160801155054.GD22771@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160801155054.GD22771-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> How is ->remove_port synchronized vs the RDMA/CM even handler?
>>
>> Easy, it isn't :)
>>
>> So we have three choices here:
>> 1. Add a lock in nvmet_port that only rdma will use for now (don't like
>> it)
>> or
>> 2. Add nvmet_rdma_port as nvmet_port->priv with a lock (don't like it)
>> or
>> 3. take the global nvmet_config_sem (hate it)
>>
>> Any preferences?
>
> (4) use cmpxchg?

I'm not exactly sure what you mean. Do you mean placing
cmpxchg in nvmet_rdma_device_removal()? To what we cmp
when we want to xchg?

Care to explain in a bit more detail?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
