From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 1/3] nvme-rdma: don't suppress send completions
Date: Thu, 9 Nov 2017 13:08:04 +0200
Message-ID: <921c4331-9456-3783-423a-9c5c5e405131@grimberg.me>
References: <20171108100616.26605-1-sagi@grimberg.me>
 <20171108100616.26605-2-sagi@grimberg.me> <20171109091858.GA16966@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171109091858.GA16966-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> The entire completions suppress mechanism is currently
>> broken because the HCA might retry a send operation
>> (due to dropped ack) after the nvme transaction has completed.
>>
>> In order to handle this, we signal all send completions (besides
>> async event which is not racing anything).
> 
> Oh well, so much for all these unsignalled completion optimizations..
> 
> So in which cases do unsignalled completions work at all?

Probably in cases where no in-capsule data is used we're fine because
the command buffers mappings are long lived, and for non-RPC like
applications.

> Seems like we need to fix up a lot of other ULPs as well.

Probably only those that support in-capsule data (which I hear
SRP does too these days).

>> -	 */
>> -	if (nvme_rdma_queue_sig_limit(queue) || flush)
>> -		wr.send_flags |= IB_SEND_SIGNALED;
>> +	wr.send_flags = IB_SEND_SIGNALED;
> 
> But..  Is there any benefit in just setting IB_SIGNAL_ALL_WR on the QP?

There is one case I still don't want to signal send completion, thats
the AEN request. It doesn't have a request structure, and preferred not
to check on it for every send completion, and its not racing anything
(mentioned this above).

I can change that though if there is a strong desire.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
