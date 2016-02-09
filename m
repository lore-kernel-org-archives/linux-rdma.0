From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v2 0/3] new ib_drain_qp() API
Date: Tue, 9 Feb 2016 15:06:13 -0600
Message-ID: <011801d1637d$b5224980$1f66dc80$@opengridcomputing.com>
References: <cover.1454969695.git.swise@chelsio.com> <010901d16375$1a023210$4e069630$@opengridcomputing.com> <011601d1637b$8c01a3e0$a404eba0$@opengridcomputing.com> <56BA540B.4040405@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BA540B.4040405-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > The problem is SRP creates its SQ CQ with IB_POLL_DIRECT context, so the CQ is never armed for interrupts, and SRP polls the CQ
> > directly.  So the drain logic won't work.
> >
> > I propose ib_drain_qp() takes a new parameter that tells it which queues to drain.  Then the SRP code will only drain the RQ
(which
> > is what it is doing prior to this series).
> 
> Hello Steve,
> 
> How about creating three functions - one that drains the receive queue,
> one that drains the send queue and a third function that drains both ?
> The latter function then can call the two former functions. And since
> only one of these three functions will have a user in your patch series
> (the function that drains the RQ), how about only introducing only that
> function now and to wait with introducing the two other functions until
> these have a user ?

That sounds reasonable.  Simpler too perhaps.  We'll see if anyone else has an opinion.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
