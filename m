From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: crash on device removal
Date: Wed, 13 Jul 2016 13:06:01 +0300
Message-ID: <57861289.5020404@grimberg.me>
References: <00cb01d1dc5b$51c05970$f5410c50$@opengridcomputing.com>
 <1468356054.5426.1.camel@ssi>
 <010201d1dc81$9f59cf10$de0d6d30$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <010201d1dc81$9f59cf10$de0d6d30$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Ming Lin' <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> We actually missed a kref_get in nvme_get_ns_from_disk().
>>
>> This should fix it. Could you help to verify?
>>
>> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
>> index 4babdf0..b146f52 100644
>> --- a/drivers/nvme/host/core.c
>> +++ b/drivers/nvme/host/core.c
>> @@ -183,6 +183,8 @@ static struct nvme_ns *nvme_get_ns_from_disk(struct
>> gendisk *disk)
>>   	}
>>   	spin_unlock(&dev_list_lock);
>>
>> +	kref_get(&ns->ctrl->kref);
>> +
>>   	return ns;
>>
>>   fail_put_ns:
>
> Hey Ming.  This avoids the crash in nvme_rdma_free_qe(), but now I see another crash:
>
> [  975.633436] nvme nvme0: new ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery", addr 10.0.1.14:4420
> [  978.463636] nvme nvme0: creating 32 I/O queues.
> [  979.187826] nvme nvme0: new ctrl: NQN "testnqn", addr 10.0.1.14:4420
> [  987.778287] nvme nvme0: Got rdma device removal event, deleting ctrl
> [  987.882202] BUG: unable to handle kernel paging request at ffff880e770e01f8
> [  987.890024] IP: [<ffffffffa03a1a46>] __ib_process_cq+0x46/0xc0 [ib_core]
>
> This looks like another problem with freeing the tag sets before stopping the QP.  I thought we fixed that once and for all, but perhaps there is some other path we missed. :(

The fix doesn't look right to me. But I wander how you got this crash
now? if at all, this would delay the controller removal...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
