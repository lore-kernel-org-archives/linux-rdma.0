From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 1/3] IB: new common API for draining a queue pair
Date: Mon, 8 Feb 2016 09:23:05 -0600
Message-ID: <00f301d16284$9b563ba0$d202b2e0$@opengridcomputing.com>
References: <cover.1454709317.git.swise@chelsio.com> <2da1db58d642789e8df154e34d622a37295d1ba3.1454709317.git.swise@chelsio.com> <3AB519EB-3BFE-4A02-A825-F74EECD2CE19@oracle.com> <00e501d1605f$a16c1630$e4444290$@opengridcomputing.com> <53AAECEE-AC46-4E28-9FC0-DB1E567A2A50@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53AAECEE-AC46-4E28-9FC0-DB1E567A2A50-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> >> OK. ib_cqe is what hooks the completion events for these
> >> blank WRs, so those completions are never exposed to the
> >> RDMA consumer.
> >>
> >
> > Right, which means only consumers that use the new style CQ processing can make use of this.
> >
> >> But does a consumer have to bump its SQE and RQE count
> >> when allocating its CQs, or is that done automatically
> >> by ib_alloc_cq() ?
> >>
> >
> > The consumer has to make sure there is room in the SQ, RQ and CQ.
> 
> The documenting comment in front of ib_drain_qp() should
> mention this, and it should also state the requirement to
> use ib_alloc_cq().
>

Will do.
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
