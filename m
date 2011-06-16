From: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: compile ofed 1.5.3 against lustre kernel
Date: Wed, 15 Jun 2011 21:16:52 -0400
Message-ID: <BANLkTimaev0HUN+o9HytavWQK+o7QA=8TA@mail.gmail.com>
References: <BANLkTin1Pg3e0S=2Hb3=0W=M_qo_TiqRrw@mail.gmail.com>
	<4DF7C80D.1060408@opengridcomputing.com>
	<alpine.DEB.2.00.1106151610040.4224@router.home>
	<382A478CAD40FA4FB46605CF81FE39F4F92EC95C@orsmsx507.amr.corp.intel.com>
	<BANLkTimz3h0C1Z9SUSXx3=LWqpt=T4v10g@mail.gmail.com>
	<382A478CAD40FA4FB46605CF81FE39F4F92EC987@orsmsx507.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <382A478CAD40FA4FB46605CF81FE39F4F92EC987-osO9UTpF0URzLByeVOV5+bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 15, 2011 at 7:50 PM, Woodruff, Robert J
<robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Michael wrote,
>>For those of us that are not hardcore kernel developers can you
>>explain what this change would actually do? =A0I'm not sure i underst=
and
>>how having a source tree with the patches already applied is any
>>different then taking the base kernel and applying a patch tree. =A0B=
ut
>>then again i probably don't understand what your talking about at all
>>(me =3D=3D admin not developer).
>
> Well what I would like to understand is what would you like to see ?
>
> A tar ball or complete patch with the OFED drivers for each kernel th=
at OFED supports
> that can be applied to the kernel tree so that the kernel can be buil=
t using
> the normal kernel build process ?
>
> Or
>
> A complete kernel tree with all of the OFED drivers already included =
that could be
> downloaded via tar balls or git ?
>
> Other ?
>

I'm not sure I'm really qualified to answer such a question (nor
whether i can write what i want to say legibly), but I'll take a stab
at it.

=46irst off you should note i can only speak to redhat and rpmbuild
processes, we don't use sles or any other distro where i work (so my
answer is definitely biased).

=46or me personally, the only time I rebuild the kernel is when I have
to build a lustre server, which is not all that often.

The steps i take (in brevity) are:

unpack kernel source from redhat
edit spec file to include lustre patches
rebuild kernel rpms using rpmbuild (redhat process)
install new kernel
reboot into new kernel
use ofed install.pl -s /<lustre kernel tree>
install ofed rpms
reboot
make lustre source using --with-linux=3D<lustre kernel tree>
--with-o2ib=3D/usr/src/ofa_kernel

Even though I'm not really answering your question, I'm not sure the
change really makes any difference to me.  I can't really foresee a
need where i would want a full kernel tree versus patches.  I'm sure
scenario's exist where it would be beneficial to have one method over
the other, but for me i can't think of one.  I would hazard a guess
that the majority of people are in the same boat as me with kernel
rebuilds

nope, even sitting here racking my brain some more, i can't see a need
for a full kernel tree for me.  even if i was rebuilding the kernel
and kernel-ib sections i'd still want to use the redhat rpmbuild
process, which will patch vanilla 2.6.18 to 2.6.18-238, and then i'd
add whatever patches i needed to the end of rhel's patch tree just
like i did with lustre and let the spec file do all the work

i guess if i was an IB developer though, having a git tree of 2.6.18
with all the RHEL and IB patches applied to it would probably be handy
though.  i can only guess that having full git trees might make
porting patches to other kernel versions easier (not a dev don't
really know).  how do ports get created today? does each developer
have to basically create a kernel dev tree and test their patch
against it and see what breaks?

dunno if i helped or wasted everyone's time, but that's my two cents...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
