From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofw] ib-diags: compatability issue with ibstat
Date: Fri, 23 Sep 2011 09:28:34 -0400
Message-ID: <CAKzyTsyH0rop69rTGUW_+kgfohyN-XiCLV4JsO9NLzyH9KpQAA@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E66F5B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E66F5B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Ira Weiny (weiny2-i2BcT+NCU+M@public.gmane.org)" <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 21, 2011 at 3:06 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
> commit 1344cb3feacafc462440dabfa5997c5205486d83 added support for FDR=
10 in a way that is not compatible with Windows support. =C2=A0Windows =
does not use files to read attribute information.
>
> I will probably need to obtain the necessary information using ibverb=
s on windows by reading port attributes. =C2=A0I don't think FDR10 supp=
ort is available through ibverbs on linux yet, but would this be accept=
able? =C2=A0Is there some other way that you'd like to handle this? =C2=
=A0The other option I can think of is moving is_fdr10() and sys_read_st=
ring() out of ibstat.c and into a linux specific file, so that windows =
can provide its own implementation. =C2=A0Thoughts?

I think there are 2 (related but somewhat separate) issues here:
1. How to obtain is_fdr10
2. Whether ibverbs should be used for this (in windows, linux, both)

The only way to determine whether fdr10 is active or not is via the
vendor proprietary MAD. That info may be reflected in some other API
(and/or file) so that MAD does not need to be reissued. In a separate
thread on linux-rdma, there was discussion on a couple of different
ways to do that from verbs and in this thread that there's no sysfs
equivalent in Windows. You've already stated that the Windows support
is using libibverbs for libibumad support so it seems appropriate to
me to do the same here (in Windows at least).

-- Hal

>
> - Sean
> _______________________________________________
> ofw mailing list
> ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
