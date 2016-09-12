From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: RFC: CQ pools and implicit CQ resource allocation
Date: Mon, 12 Sep 2016 23:07:45 +0300
Message-ID: <6dd3ecbd-7109-95ff-9c86-dfea9e515538@grimberg.me>
References: <1473424587-13818-1-git-send-email-hch@lst.de>
 <d0c645eb-3674-2841-bdb7-8b9e6fd46473@grimberg.me>
 <00e001d20d03$ea891100$bf9b3300$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00e001d20d03$ea891100$bf9b3300$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> One other note that I wanted to raise for the folks interested in this
>> is that with the RDMA core owning the completion queue pools, different
>> ULPs can easily share the same completion queue (given that it uses
>> the same poll context). For example, nvme-rdma host, iser and srp
>> initiators can end up using the same completion queues (if running
>> simultaneously on the same machine).
>>
>> Up until now, I couldn't think of anything that can introduce a problem
>> with that but maybe someone else will...
>
> It would be useful to provide details on how many CQs get created and of what
> size for an uber iSER/NVMF/SRP initiator/host and target.

Are you talking about some debugfs layout?

> One concern I have is that cxgb4 CQs require contiguous memory,  So a scheme
> like CQ pooling might cause resource problems on large core systems.

Note that the CQ allocation will never exceed the device max_cqe cap.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
