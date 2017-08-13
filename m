From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Flush warning
Date: Sun, 13 Aug 2017 02:14:58 -0700
Message-ID: <90ada4f5-d6a1-2b93-5164-c593955c20cf@grimberg.me>
References: <016301d30c86$e7034ae0$b509e0a0$@opengridcomputing.com>
 <9bc142de-b8ba-acb6-5ea1-2ccdbb578655@grimberg.me>
 <003401d30f91$c7e2a3f0$57a7ebd0$@opengridcomputing.com>
 <00ff01d3112b$94142350$bc3c69f0$@opengridcomputing.com>
 <20170809162749.GA4069@obsidianresearch.com>
 <011601d3112d$fa305b70$ee911250$@opengridcomputing.com>
 <20170813064651.GR24282@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813064651.GR24282-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>>> Does anyone else know?
>>>
>>> Consider that the ib_core can be used to back storage. Ie consider a
>>> situation where iSER/NFS/SRP needs to reconnect to respond to kernel
>>> paging/reclaim.
>>>
>>> On the surface it seems reasonable to me that these are on a reclaim
>>> path?

I'm pretty sure that ULP connect will trigger memory allocations, which
will fail under memory pressure... Maybe I'm missing something.

>> hmm.  That seems reasonable.  Then I would think the nvme_rdma would also need
>> to be using a reclaim workqueue.
>>
>> Sagi, Do you think I should add a private workqueue with WQ_MEM_RECLAIM to
>> nvme_rdma vs using the system_wq?  nvme/target probably needs one also...

I'm not sure, being unable to flush system workqueue from CM context is
somewhat limiting... We could use a private workqueue for nvmet
teardowns but I'm not sure we want to do that.

> The workqueue which frees the memory and doesn't allocate memory during execution
> is supposed to be marked as WQ_MEM_RECLAIM. This flag will cause to priority increase
> for such workqueue during low memory conditions.

Which to my understanding means that CM workqueue should not use it as
on each CM connect, by definition the ULP allocates memory (qp, cq etc).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
