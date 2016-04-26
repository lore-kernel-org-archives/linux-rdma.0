From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] IB/core: Don't drain the receive queue for srq attached
 queue-pair
Date: Tue, 26 Apr 2016 22:24:01 +0300
Message-ID: <571FC051.7020009@grimberg.me>
References: <1461682538-19647-1-git-send-email-sagi@grimberg.me>
 <571F841D.3010909@opengridcomputing.com>
 <CAB5WxwfAGL2qCe7w6A=mKQ65mwjbKKbp_8qFJFRF6Aj7tE+tLQ@mail.gmail.com>
 <20160426154328.GA12398@lst.de>
 <912C9E71-05E3-4ED9-9B41-137E131E3A71@oracle.com>
 <571F9084.2040506@opengridcomputing.com> <571F917C.40008@sandisk.com>
 <571F972B.6030904@opengridcomputing.com> <571FA4E5.2030501@sandisk.com>
 <571FA6D5.2060607@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571FA6D5.2060607-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Actually, after thinking more about this, posting anything to the SRQ
> will not force it to complete.  The only reason that works for a QP with
> an RQ is that the QP is in ERR state and thus the RECV WR gets completed
> with FLUSHED status.

Exactly...

> So SRQ drain would require some other method...

I still don't understand the meaning of draining a SRQ.
There are no QP associated post recvs, the QP and contexts
(wc->qp) are assigned at completion processing time. When
we have a SRQ the recv contexts are not bound to a
session/connection/QP...

Can you well-define what are you trying to do?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
