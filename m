From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/16] Flow counters support
Date: Thu, 2 Nov 2017 08:50:22 +0200
Message-ID: <CAFgAxU8GNEiyzwHqrYyxs8J7T0TUqmN7JrZukkA0JgYSgY8FoA@mail.gmail.com>
References: <20171025151734.GA15557@obsidianresearch.com> <AM6PR0502MB3783A1186AA0ABDCCD5359AEBD5A0@AM6PR0502MB3783.eurprd05.prod.outlook.com>
 <20171027155955.GA15922@obsidianresearch.com> <CAFgAxU-UcRapsoRn3hNUn27xgY370gUJ+WWE4URBq84ufkCXtA@mail.gmail.com>
 <20171029180019.GE4488@ziepe.ca> <CAFgAxU_CMxQ616wBd-vkvyJ905ndLHrabmWtJ-Ye_hgSwWqiag@mail.gmail.com>
 <20171101181807.GJ1030@ziepe.ca> <CAFgAxU-DsOr9T9P6gqvZ9AviE45_34vZ1WUgUehmF-kb2j8JtQ@mail.gmail.com>
 <20171101190119.GL1030@ziepe.ca> <CAFgAxU9FZQC3JC6sEjB9W3YqHyF5StJ8_=mDQsF0eCWr9010hw@mail.gmail.com>
 <20171101211629.GA18874@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171101211629.GA18874-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 1, 2017 at 11:16 PM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
> On Wed, Nov 1, 2017 at 1:46 PM, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> Then I think my proposed API makes the most sense overall since it
>>> captures this use model as well, even if mlx currently does not support
>>> this use model for flow counters.
>
>> it will force the kernel syscall on each modify, which is something
>> that will limit the usage at scale.
>
> No, it doesn't force that. As we've talked about the driver should
> book-keep in user space as required.
>
>> doing the bookkeeping in user space will require a trigger to commit
>> this to kernel/HW, which can be the modify() or an additional API.
>
> The trigger to push things to the kernel is something like creating a
> flow steering object.

I'm referring to reducing the kernel calls when supporting the on the
fly modification for counter and QP pair updates.
if user wants to add/remove a sampling point on an already operational
QP of flow, calling ibv_add_sampling_point_qp will have to go to
kernel each time, unless we allow multiple add_sampling_point followed
by a ibv_modify_qp(qp, {attr{counter}}) or add some 'flush' flag/API,
or 'more to come' flag until final add_sampling_poing_qp call.

> The driver can bundle the create of the counter object, and the send
> of the counters to add, in with the syscall for creating the flow
> steering object.
>
> Same argument for QP, similar argument for attaching to an existing
> QP.

totally agree about the atomic create of counter with verbs object.
this is well defined with the ibv_create_flow/qp()

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
