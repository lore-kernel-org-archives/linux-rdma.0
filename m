From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/16] Flow counters support
Date: Wed, 1 Nov 2017 15:16:29 -0600
Message-ID: <20171101211629.GA18874@ziepe.ca>
References: <20171025151734.GA15557@obsidianresearch.com>
 <AM6PR0502MB3783A1186AA0ABDCCD5359AEBD5A0@AM6PR0502MB3783.eurprd05.prod.outlook.com>
 <20171027155955.GA15922@obsidianresearch.com>
 <CAFgAxU-UcRapsoRn3hNUn27xgY370gUJ+WWE4URBq84ufkCXtA@mail.gmail.com>
 <20171029180019.GE4488@ziepe.ca>
 <CAFgAxU_CMxQ616wBd-vkvyJ905ndLHrabmWtJ-Ye_hgSwWqiag@mail.gmail.com>
 <20171101181807.GJ1030@ziepe.ca>
 <CAFgAxU-DsOr9T9P6gqvZ9AviE45_34vZ1WUgUehmF-kb2j8JtQ@mail.gmail.com>
 <20171101190119.GL1030@ziepe.ca>
 <CAFgAxU9FZQC3JC6sEjB9W3YqHyF5StJ8_=mDQsF0eCWr9010hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFgAxU9FZQC3JC6sEjB9W3YqHyF5StJ8_=mDQsF0eCWr9010hw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 1, 2017 at 1:46 PM, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Then I think my proposed API makes the most sense overall since it
>> captures this use model as well, even if mlx currently does not support
>> this use model for flow counters.

> it will force the kernel syscall on each modify, which is something
> that will limit the usage at scale.

No, it doesn't force that. As we've talked about the driver should
book-keep in user space as required.

> doing the bookkeeping in user space will require a trigger to commit
> this to kernel/HW, which can be the modify() or an additional API.

The trigger to push things to the kernel is something like creating a
flow steering object.

The driver can bundle the create of the counter object, and the send
of the counters to add, in with the syscall for creating the flow
steering object.

Same argument for QP, similar argument for attaching to an existing
QP.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
