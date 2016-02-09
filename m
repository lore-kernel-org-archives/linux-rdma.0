From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v2 0/3] new ib_drain_qp() API
Date: Tue, 9 Feb 2016 14:50:45 -0600
Message-ID: <011601d1637b$8c01a3e0$a404eba0$@opengridcomputing.com>
References: <cover.1454969695.git.swise@chelsio.com> <010901d16375$1a023210$4e069630$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <010901d16375$1a023210$4e069630$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > This series creates a new helper API for draining a queue pair.  It is a
> > rework of an original patch created by Christoph Hellwig as part of the CQ
> > API rework and was dropped to be resubmitted by me with iw_cxgb4 support.
> 
> I finally got SRP running to test this series and it isn't working. :(  Anyway, there will be v3 posted once I fix it.
> 
> Steve.

The problem is SRP creates its SQ CQ with IB_POLL_DIRECT context, so the CQ is never armed for interrupts, and SRP polls the CQ
directly.  So the drain logic won't work.  

I propose ib_drain_qp() takes a new parameter that tells it which queues to drain.  Then the SRP code will only drain the RQ (which
is what it is doing prior to this series).

Thoughts?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
