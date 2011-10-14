From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: rdma: 3.1.0-rc9 breaks UD
Date: Fri, 14 Oct 2011 09:40:00 -0700
Message-ID: <CAL1RGDXTQTwBBt+Lzo2o795giBbt28qW0-omXQVvOGtbmbMHRw@mail.gmail.com>
References: <alpine.DEB.2.00.1110140852210.6411@router.home>
 <1828884A29C6694DAF28B7E6B8A8237316E6AF8E@ORSMSX101.amr.corp.intel.com>
 <alpine.DEB.2.00.1110141131150.6411@router.home> <1828884A29C6694DAF28B7E6B8A8237316E6AFC1@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E6AFC1-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 14, 2011 at 9:36 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
> Actually, mine did too. =A0I wonder if this OFED patch to libibverbs =
is causing the issue:
>
> http://git.openfabrics.org/git?p=3Dofed_1_5/libibverbs.git;a=3Dblob;f=
=3Dfixes/rocee_examples.patch;h=3Deda5a401a3424a104e8100848b5b6bf4e5b63=
bee;hb=3DHEAD

Hmm, yeah, does that change the wire protocol on the TCP setup socket
between the pingpong processes?
But that doesn't explain why UC works and UD doesn't.

I actually pulled that into my libibverbs git tree (haven't release
the IBoE version yet)...

I wonder how important wire compatibilty of the ibv_xx_pingpong
examples is... should I worry about this?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
