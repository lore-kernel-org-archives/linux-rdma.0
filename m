From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V5 7/8] IB/uverbs: Resolve Ethernet L2 addresses when
 modifying QP
Date: Wed, 11 Dec 2013 19:45:49 +0200
Message-ID: <CAJZOPZLVuznb2O8ORUcFNnsXjnL9iGu2UQYwH4F3E8Y0Xx56mA@mail.gmail.com>
References: <1384381792-2023-1-git-send-email-ogerlitz@mellanox.com>
	<1384381792-2023-8-git-send-email-ogerlitz@mellanox.com>
	<CAG4TOxOUFfPMU+q1yKy6S7v3QiLVgMQwxNC-_vw-7UeUb7LoBg@mail.gmail.com>
	<CAJZOPZ+5UJCAObzFjK5w=bnnSjRM102vR5Ft1nd4nO48Lr2HOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+5UJCAObzFjK5w=bnnSjRM102vR5Ft1nd4nO48Lr2HOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ali Ayoub <ali-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 19, 2013 at 10:48 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Nov 19, 2013 at 8:08 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> Existing user space applications provide only IBoE L3 address attributes
>>> to the kernel when they issue QP modify. To comply with them and let such
>>> apps to keep work transparently under the IBoE GID IP addressing changes,
>>> added Eth L2 address resolution in the user-kernel linking piece - uverbs.
>
>> I don't get why this belongs in uverbs.  In the current design serves
>> as a transport between userspace and kernel and the kernel verbs are
>> the same as user verbs.  The only exception to this that introduces
>> complexity is the stuff related to sharing XRCs and that makes sense
>> because multiple processes etc. is definitely a userspace-only concern.
>
>> However in this case I don't see why address resolution is something
>> only userspace cares about.  Wouldn't it make sense to put this
>> resolution in core verbs?
>
> Basically, we've put it into uverbs b/c for kernel consumers that use
> the rdma-cm the problem doesn't exist, since the Ethernet L2
> attributes are filled into the qp attributes used by the rdma-cm
> throughout the address resolution process.
>
> Since currently there are no in-tree non rdma-cm cosumer ULPs that are
>  applicable to RoCE, the kernel is done deal in that respect.
>
> If it helps or/and make more sense, sure we can move the reslution to
> be done @ the core verbs, e.g in core/verbs.c :: ib_modify_qp,
> anything else expect for this feedback?

Hi Roland,

-- waiting for a month to get your feedback if V5 + the above fix you
asked is enough
or more changes / review is needed. We'l respin the series and make V6
with this change
and few minor fixes for issues we came across while doing more
regression tests, but need
your response, else we're clueless on the actual status. As I wrote
you http://marc.info/?l=linux-rdma&m=138488191903193&w=2
this is pre-step for RoCE SRIOV support, so we needs head up so we
don't loose again more kernel cycles.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
