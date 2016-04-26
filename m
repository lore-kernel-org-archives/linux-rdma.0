From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/core: Don't drain the receive queue for srq attached
 queue-pair
Date: Tue, 26 Apr 2016 09:04:12 -0700
Message-ID: <571F917C.40008@sandisk.com>
References: <1461682538-19647-1-git-send-email-sagi@grimberg.me>
 <571F841D.3010909@opengridcomputing.com>
 <CAB5WxwfAGL2qCe7w6A=mKQ65mwjbKKbp_8qFJFRF6Aj7tE+tLQ@mail.gmail.com>
 <20160426154328.GA12398@lst.de>
 <912C9E71-05E3-4ED9-9B41-137E131E3A71@oracle.com>
 <571F9084.2040506@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571F9084.2040506-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: sagi grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/26/2016 09:00 AM, Steve Wise wrote:
> On 4/26/2016 10:55 AM, Chuck Lever wrote:
>>> On Apr 26, 2016, at 11:43 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>>>
>>> Just curious: what takes care of draining SRQs when we unregister them
>>> after all queues are gone?
>>
>> Conversely, I would think that a consumer that uses SRQ
>> would want a similar drain mechanism to guarantee there
>> are no more posted Receives for the associated QP, and
>> thus it is safe to destroy it.
> 
> I don't think there is anything now that handles draining an SRQ, nor 
> ensuring a QP's RQEs are completed/consumed from its SRQ when draining 
> the QP.  Sounds like work is needed here.
> 
> But are there any kernel SRQ consumers at this point?

I think the following two:

$ git grep -nHE '(ib|rdma)_create_srq' drivers/infiniband/ulp
drivers/infiniband/ulp/ipoib/ipoib_cm.c:1521:	priv->cm.srq = ib_create_srq(priv->pd, &srq_init_attr);
drivers/infiniband/ulp/srpt/ib_srpt.c:2723:	sdev->srq = ib_create_srq(sdev->pd, &srq_attr);

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
