From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb routines
Date: Thu, 16 Jun 2011 21:12:45 +0300
Message-ID: <BANLkTimwTs4EK19PiTq6yMzPCQrLt0bALw@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237302123C@ORSMSX101.amr.corp.intel.com>
	<4DFA1DDD.5020508@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A823730217E1@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823730217E1-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> I'm trying to understand the way the user/kernel way of adding verbs
>> is implemented... I wasn't sure, if/which specific kernel patch out
>> of this series is matching this one?

> There are no matching kernel patches to this patch. =A0This does not =
try to provide any
> direct support for out of tree kernel patches.

Sean, maybe I wasn't clear here, I was referring to the XRC kernel
patch series you were just sending yesterday for upstream
review/acceptance... isn't that series + libibverbs/libmlx4/librdmacm
compose a complete solution for XRC for (say) new applications (forget
about apps written to other XRC APIs)? I'm trying to understand
if/what is the framework you suggest to add new user space verbs.

Basically, I wasn't referring to such new verbs as vendor extensions,
but rather as new verbs we want to add at this and/or future points of
time which didn't exist at the time the IB stack and specifically its
kernel/user ABIs/APIs were written (couple of years ago...).

I hope to better spell out my question now, is this section below
still relevant as the answer?

Or.

> The closest this comes is reserving the upper 8-bits of any enum or o=
ther value, which can be used to indicate vendor specific support. =A0F=
or example, an out of tree kernel patch could define a new QP type and =
ABI command with one of the higher bits set (rather than the next in se=
ries). =A0An upstream patch would remove these bits. =A0This should mak=
e it possible for a vendor to continue to support their out of tree cha=
nges even after that feature was added to the mainline. =A0Hopefully th=
is makes sense.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
