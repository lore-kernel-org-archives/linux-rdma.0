From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Fork safe clarification
Date: Wed, 07 Apr 2010 10:13:54 -0700
Message-ID: <adak4sj2njh.fsf@roland-alpha.cisco.com>
References: <s2pbb8be6ca1004010709hf5d0fe3cr2a76f28eaab97373@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <s2pbb8be6ca1004010709hf5d0fe3cr2a76f28eaab97373-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Matthew Small's message of "Thu, 1 Apr 2010 10:09:48 -0400")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Small <matthewtsmall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Are PDs, QPs and CQs created before a fork shared by the parent and =
child
 > after fork() has returned (ie. both can submit WRs, poll CQ, etc.)?

no, QPs and CQs are accessible only in the parent.  The child can still
use the uverbs file descriptor to do things, but libibverbs will
probably get very confused in this case.  More userspace development
would probably be required to make this really work.  Since the PD is
attached to the FD, it could be shared.

 > What about MRs registered before the fork? =C2=A0Even though the chi=
ld doesn't
 > have access to the parent's memory, can he sill submit WRs on a QP w=
ith an
 > MR created before the fork?

yes.

 > What if the MR pages in the above scenario are accessible in both pa=
rent and
 > child (shared memory)? =C2=A0Are there complications with registerin=
g shared
 > memory?

shouldn't make a difference.

 > In general, are pointers returned by libibverbs pointer to user/proc=
ess
 > address space (as ibv_mr pointers must be) or kernel space (eg. =C2=A0=
if an
 > unrelated process had another process's QP pointer, lkey, and a virt=
ual
 > address could it post (almost certainly unsafely) a WR to the other
 > process's QP?

Not sure I understand this.  All the pointers from libibverbs are of
course userspace pointers.  What could a userspace process do with a
kernel pointer?  Processes own all their resources and can't access
other resources.

 - R.
--=20
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go=
 to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
