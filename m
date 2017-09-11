From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 1/3] verbs: Enable creating QP with a given
 source QP number
Date: Mon, 11 Sep 2017 10:28:54 -0600
Message-ID: <20170911162854.GE32117@obsidianresearch.com>
References: <1504786327-820-1-git-send-email-yishaih@mellanox.com>
 <1504786327-820-2-git-send-email-yishaih@mellanox.com>
 <20170907151641.GC20644@obsidianresearch.com>
 <CAFgAxU8QqEQwCMnu=_1hjRVMHJ_242pXykxHuJ9PftxTV77TUw@mail.gmail.com>
 <20170907192909.GA5364@obsidianresearch.com>
 <CAFgAxU8bkhb6tvB=1GUzqW2Dg-43Y+pZkDaXvFOE+5CEMLs6Mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFgAxU8bkhb6tvB=1GUzqW2Dg-43Y+pZkDaXvFOE+5CEMLs6Mg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 10, 2017 at 09:54:45AM +0300, Alex Rosenbaum wrote:
> On Thu, Sep 7, 2017 at 10:29 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Thu, Sep 07, 2017 at 09:46:39PM +0300, Alex Rosenbaum wrote:
> >> On Thu, Sep 7, 2017 at 6:16 PM, Jason Gunthorpe
> >> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> >> > On Thu, Sep 07, 2017 at 03:12:05PM +0300, Yishai Hadas wrote:
> >> >> +uint32_t                source_qpn;     /* Source QP number, creation flag IBV_QP_CREATE_SOURCE_QPN should be set */
> >> >
> >> > I think more discussion in the man page is required for this
> >> > feature. Eg that it is a SEND ONLY QP and only works for UD.
> >>
> >> Verbs UD QP can handle receive of ingress packets sent with
> >> BTH.DestQPN = ibv_qp->qp_num. This is applicable also in this case.
> >>
> >> Also, future implementation might include RC source qpn use case. This
> >> can be accomplished by setting the HCA's QPN to be the same as the
> >> 'source qpn' value, and returning that to the user.
> >>
> >> We prefer not to limit the API definition in the man page.
> >
> > Well, you have to define what the API does, specifically.
> >
> > If you expect it to RX then you need to specify that.
> 
> Like any other QP, this too can have a max_recv_wr defined by user. I
> don't think we need to specifically mention it, because it is not a
> limition.

You need to mention what impact source_qpn has on the RX, assuming the
user does nothing else.

>From what I can gather, without flow steering, RX should not be
possible.

This needs to be described.

> > There is nothing wrong with specifying the API limit that exist today,
> > it helps people understand what the feature is and how to use it.
> 
> RC is currently not supported. Do you prefer we update the man page
> with the UD limitation? and once RC or other limitation are removed we
> update it again?

Yes. Describe what it does. The man page is not a spec, it documents
what the software actually does.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
