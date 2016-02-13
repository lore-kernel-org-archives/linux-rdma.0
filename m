From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/3] IB: new common API for draining queues
Date: Sat, 13 Feb 2016 21:11:14 +0530
Message-ID: <CANjDDBhOOsu+4TooBSqQ+mifC=oL1zqAyT83OD4EvevxgHueZw@mail.gmail.com>
References: <cover.1455230646.git.swise@chelsio.com> <3e7261d1436d33320223d365974ff38945f0d558.1455230646.git.swise@chelsio.com>
 <CANjDDBg=B33kRDTZ=NnZ-cZhNwXnpJ950dLy6qY0QZBjDaNisQ@mail.gmail.com> <005801d165a8$7ba4bd00$72ee3700$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <005801d165a8$7ba4bd00$72ee3700$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Steve,


On Fri, Feb 12, 2016 at 8:47 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
>> > +/*
>> > + * Post a WR and block until its completion is reaped for the SQ.
>> > + */
>> > +static void __ib_drain_sq(struct ib_qp *qp)
>> > +{
>> > +       struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
>> > +       struct ib_drain_cqe sdrain;
>> > +       struct ib_send_wr swr = {}, *bad_swr;
>> > +       int ret;
>> > +
>> > +       swr.wr_cqe = &sdrain.cqe;
>> > +       sdrain.cqe.done = ib_drain_qp_done;
>> > +       init_completion(&sdrain.done);
>> > +
>> > +       ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
>> > +       if (ret) {
>> > +               WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
>> > +               return;
>> > +       }
>>
>> Should it query qp-state and then modify if needed? I am not liking the
>> the extra step which is highly unlikely in a normal usage conditions?
>> especially for a shared CQ it is really redundant.
>>
>
> Hey Devesh, on a previous round of reviews for this series, I thought you agreed that this was fine?

Yes, I agreed, I was trying to give it second thought and just posted
what I had. :)

>
> See: http://www.spinics.net/lists/linux-rdma/msg33202.html
>
> My personal opinion is that calling query_qp() and only modifying if needed is as much work as just calling modify since ERR->ERR is basically a noop.

I agree that query_qp() is an overkill.

>
> Steve.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
