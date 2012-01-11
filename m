From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Send with immediate data completion
Date: Wed, 11 Jan 2012 15:35:58 -0800
Message-ID: <CAL1RGDVDR_yNmGyCpFKpH39PF5NG90qo7bBDV+DbGmh7FySiZQ@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A82373256758E5@ORSMSX101.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A823732567591B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823732567591B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 11, 2012 at 2:22 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
> The intent is for immediate data only to be provided on receive work =
completions. =A0The IBTA will clarify the spec on this. =A0I'll submit =
patches that remove setting the wc flag, which may help avoid this conf=
usion some.

The unfortunate thing is that we never defined enum values like

IBV_WC_RDMA_WRITE_WITH_IMM

to go along with

IBV_WR_RDMA_WRITE_WITH_IMM

If there was a good reason for that, I've long since forgotten it.

But in any case we don't have a good way to return the opcode
in the completion queue entry for an RDMA write with immediate
request, except the way we do it now.

Perhaps the only way forward is with a documentation update?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
