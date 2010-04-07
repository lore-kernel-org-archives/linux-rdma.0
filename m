From: Matthew Small <matthewtsmall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Fork safe clarification
Date: Wed, 7 Apr 2010 13:09:05 -0400
Message-ID: <j2sbb8be6ca1004071009qf544651ct8825ba443dc9c663@mail.gmail.com>
References: <s2pbb8be6ca1004010709hf5d0fe3cr2a76f28eaab97373@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <s2pbb8be6ca1004010709hf5d0fe3cr2a76f28eaab97373-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I know many of the people here are very busy and these might be
questions that are not about your work at hand, but these intricacies
of libibverbs are hard to figure out without an intimate knowledge of
the drivers (from the user side).  I would really appreciate anyone
who would take the time to respond.

On Thu, Apr 1, 2010 at 10:09 AM, Matthew Small <matthewtsmall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
> wrote:
> I am trying to understand the behavior of the libibverbs after it has=
 been
> set into fork safe mode via a successful call to ibv_fork_init() or s=
etting
> the environmental variable IBV_FORK_SAFE. =A0For my purposes I would =
like to
> know the following :
>
> Are PDs, QPs and CQs created before a fork shared by the parent and c=
hild
> after fork() has returned (ie. both can submit WRs, poll CQ, etc.)?
>
>
> What about MRs registered before the fork? =A0Even though the child d=
oesn't
> have access to the parent's memory, can he sill submit WRs on a QP wi=
th an
> MR created before the fork?
>
>
> What if the MR pages in the above scenario are accessible in both par=
ent and
> child (shared memory)? =A0Are there complications with registering sh=
ared
> memory?
>
>
> In general, are pointers returned by libibverbs pointer to user/proce=
ss
> address space (as ibv_mr pointers must be) or kernel space (eg. =A0if=
 an
> unrelated process had another process's QP pointer, lkey, and a virtu=
al
> address could it post (almost certainly unsafely) a WR to the other
> process's QP?
>
>
> Sorry if the questions seem progressively more goofy and thanks in ad=
vance
> for any clarification.
>
> -Matt
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
