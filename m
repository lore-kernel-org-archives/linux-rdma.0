From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v2 0/3] new ib_drain_qp() API
Date: Wed, 10 Feb 2016 09:55:05 -0600
Message-ID: <00fb01d1641b$68a0d380$39e27a80$@opengridcomputing.com>
References: <cover.1454969695.git.swise@chelsio.com> <010901d16375$1a023210$4e069630$@opengridcomputing.com> <011601d1637b$8c01a3e0$a404eba0$@opengridcomputing.com> <56BA540B.4040405@sandisk.com> <011901d1637d$b5286400$1f792c00$@opengridcomputing.com> <012801d16384$f68884f0$e3998ed0$@opengridcomputing.com> <56BB11F0.9090203@dev.mellanox.co.il> <00ca01d16417$9e9fc030$dbdf4090$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00ca01d16417$9e9fc030$dbdf4090$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > I'd suggest to look at the CQ context and act accordingly, something
> > like:
> >
> > 	if (cq->poll_ctx == IB_POLL_DIRECT) {
> > 		while (!wait_for_completion_timeout(&sdrain.done,
> > 				mescs_to_jiffies(100))
> > 			ib_process_cq_direct(cq, 1024)
> > 	} else {
> > 		wait_for_completion(&sdrain.done);
> > 	}
> >
> > Thoughts?
> 
> I don't like the forced 100ms block.  You could call ib_process_cq_direct() first and check the return code, then block if needed.

My bad:  there is no forced 100ms block.  If the completion is ready, then it will not wait...



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
