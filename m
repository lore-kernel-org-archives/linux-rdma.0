From: Matthew Small <matthewtsmall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fork safe clarification
Date: Thu, 1 Apr 2010 10:09:48 -0400
Message-ID: <s2pbb8be6ca1004010709hf5d0fe3cr2a76f28eaab97373@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I am trying to understand the behavior of the libibverbs after it has b=
een
set into fork safe mode via a successful call to ibv_fork_init() or set=
ting
the environmental variable IBV_FORK_SAFE. =A0For my purposes I would li=
ke to
know the following :

Are PDs, QPs and CQs created before a fork shared by the parent and chi=
ld
after fork() has returned (ie. both can submit WRs, poll CQ, etc.)?


What about MRs registered before the fork? =A0Even though the child doe=
sn't
have access to the parent's memory, can he sill submit WRs on a QP with=
 an
MR created before the fork?


What if the MR pages in the above scenario are accessible in both paren=
t and
child (shared memory)? =A0Are there complications with registering shar=
ed
memory?


In general, are pointers returned by libibverbs pointer to user/process
address space (as ibv_mr pointers must be) or kernel space (eg. =A0if a=
n
unrelated process had another process's QP pointer, lkey, and a virtual
address could it post (almost certainly unsafely) a WR to the other
process's QP?


Sorry if the questions seem progressively more goofy and thanks in adva=
nce
for any clarification.

-Matt
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
