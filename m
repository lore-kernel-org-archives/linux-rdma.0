From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] IB/core: Don't drain the receive queue for srq attached
 queue-pair
Date: Tue, 26 Apr 2016 22:15:05 +0300
Message-ID: <571FBE39.4020700@grimberg.me>
References: <1461682538-19647-1-git-send-email-sagi@grimberg.me>
 <571F841D.3010909@opengridcomputing.com>
 <CAB5WxwfAGL2qCe7w6A=mKQ65mwjbKKbp_8qFJFRF6Aj7tE+tLQ@mail.gmail.com>
 <20160426154328.GA12398@lst.de>
 <912C9E71-05E3-4ED9-9B41-137E131E3A71@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <912C9E71-05E3-4ED9-9B41-137E131E3A71-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> Just curious: what takes care of draining SRQs when we unregister them
>> after all queues are gone?
>
> Conversely, I would think that a consumer that uses SRQ
> would want a similar drain mechanism to guarantee there
> are no more posted Receives for the associated QP, and
> thus it is safe to destroy it.

Umm, not sure if that is completely true.

The consumer that uses a SRQ will usually detach the recv buffers and
contexts from the session/connection so I'm not sure if the consumer
will want/need a similar drain mechanism.

Also, there is no draining a SRQ, it doesn't move to ERROR state
and the (shared) receive completions are coming only from incoming
receives (no FLUSH errors).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
