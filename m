From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 0/3] new ib_drain_qp() API
Date: Wed, 10 Feb 2016 06:08:57 -0800
Message-ID: <56BB4479.8090009@sandisk.com>
References: <cover.1454969695.git.swise@chelsio.com>
 <010901d16375$1a023210$4e069630$@opengridcomputing.com>
 <011601d1637b$8c01a3e0$a404eba0$@opengridcomputing.com>
 <56BA540B.4040405@sandisk.com>
 <011901d1637d$b5286400$1f792c00$@opengridcomputing.com>
 <012801d16384$f68884f0$e3998ed0$@opengridcomputing.com>
 <56BB11F0.9090203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BB11F0.9090203-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/10/16 02:33, Sagi Grimberg wrote:
>
>>>> Hello Steve,
>>>>
>>>> How about creating three functions - one that drains the receive queue,
>>>> one that drains the send queue and a third function that drains both ?
>>>> The latter function then can call the two former functions. And since
>>>> only one of these three functions will have a user in your patch series
>>>> (the function that drains the RQ), how about only introducing only that
>>>> function now and to wait with introducing the two other functions until
>>>> these have a user ?
>>>
>>> That sounds reasonable.  Simpler too perhaps.  We'll see if anyone else
>>> has an opinion.
>>
>> Another option is for ib_drain_qp() to just skip queues with IB_POLL_DIRECT CQ processing.
>
> I'd rather not skip silently anything. ib_drain_qp() semantics is that
> it drains all the pending posts on the queue-pair (i.e. both send and
> receive queues).
>
> We can split to send and receive, but the fact that srp uses direct
> polling CQ is not sufficient for that, most if not all will benefit from
> both.
>
> I'd suggest to look at the CQ context and act accordingly, something
> like:
>
> 	if (cq->poll_ctx == IB_POLL_DIRECT) {
> 		while (!wait_for_completion_timeout(&sdrain.done,
> 				mescs_to_jiffies(100))
> 			ib_process_cq_direct(cq, 1024)
> 	} else {
> 		wait_for_completion(&sdrain.done);
> 	}
>
> Thoughts?

Hello Sagi,

The above code will only work as expected if the caller won't call 
ib_process_cq_direct() for the same queue from another context. This 
needs to be documented clearly and all drivers in which a call to that 
code is introduced have to be verified to see whether that assumption holds.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
