From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 1/3] IB: new common API for draining a queue pair
Date: Mon, 8 Feb 2016 09:53:00 -0600
Message-ID: <010f01d16288$c9ba5040$5d2ef0c0$@opengridcomputing.com>
References: <cover.1454709317.git.swise@chelsio.com> <2da1db58d642789e8df154e34d622a37295d1ba3.1454709317.git.swise@chelsio.com> <CANjDDBjFY+u=8UXVCkKkK0LKSWiRcfZYnP9035m5owAYZnfn6w@mail.gmail.com> <56B73049.5040901@dev.mellanox.co.il> <CANjDDBiGVxmMn7H-__z48hS93mHoqejiZgsry0DmLwJKxZ=MqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBiGVxmMn7H-__z48hS93mHoqejiZgsry0DmLwJKxZ=MqQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Devesh Sharma' <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> On Sun, Feb 7, 2016 at 5:23 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> >
> >>> +/*
> >>> + * Post a WR and block until its completion is reaped for both the RQ
> >>> and SQ.
> >>> + */
> >>> +static void __ib_drain_qp(struct ib_qp *qp)
> >>> +{
> >>> +       struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
> >>> +       struct ib_drain_cqe rdrain, sdrain;
> >>> +       struct ib_recv_wr rwr = {}, *bad_rwr;
> >>> +       struct ib_send_wr swr = {}, *bad_swr;
> >>> +       int ret;
> >>> +
> >>> +       rwr.wr_cqe = &rdrain.cqe;
> >>> +       rdrain.cqe.done = ib_drain_qp_done;
> >>> +       init_completion(&rdrain.done);
> >>> +
> >>> +       swr.wr_cqe = &sdrain.cqe;
> >>> +       sdrain.cqe.done = ib_drain_qp_done;
> >>> +       init_completion(&sdrain.done);
> >>> +
> >>> +       ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
> >>> +       if (ret) {
> >>> +               WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
> >>> +               return;
> >>> +       }
> >>
> >>
> >> I was thinking if we really need this modify_qp here. generally
> >> drain_qp is called on
> >> an error'ed out QP. In a graceful tear down rdma_disconnect takes care
> >> to modify-qp
> >> to error. while in error state qp is already in error state.
> >
> >
> > We could get it conditional, but I don't see any harm done
> > in having it as it would mean a passed in flag.
> >
> 
> Since Spec allows this, I would say okay let it be there.
> 
> > It would be better to have the modify_qp implementers do
> > nothing for a ERROR -> ERROR modify...
> 
> Driver implementer has a choice here which is okay.

Ok, I'll leave it as-is then.  Thanks for the reviews!



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
