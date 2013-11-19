From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: drivers/infiniband/core/uverbs_main.c:683:17: sparse: Using
 plain integer as NULL pointer
Date: Tue, 19 Nov 2013 14:13:01 +0100
Message-ID: <1384866781.20207.7.camel@localhost.localdomain>
References: <528b3984.SVGs20ZWpcuR/Jls%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <528b3984.SVGs20ZWpcuR/Jls%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,=20

Just received this warning[1] report:

Le mardi 19 novembre 2013 =C3=A0 18:12 +0800, kbuild test robot a =C3=A9=
crit :
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.=
git master
> head:   801a76050bcf8d4e500eb8d048ff6265f37a61c8
> commit: f21519b23c1b6fa25366be4114ccf7fcf1c190f9 IB/core: extended co=
mmand: an improved infrastructure for uverbs commands
> date:   2 days ago
> reproduce: make C=3D1 CF=3D-D__CHECK_ENDIAN__
>=20
>=20
> sparse warnings: (new ones prefixed by >>)
>=20
> >> drivers/infiniband/core/uverbs_main.c:683:17: sparse: Using plain =
integer as NULL pointer
> >> drivers/infiniband/core/uverbs_main.c:689:17: sparse: Using plain =
integer as NULL pointer
>=20
> vim +683 drivers/infiniband/core/uverbs_main.c
>=20
>    677					return -EINVAL;
>    678			} else {
>    679				if (hdr.out_words || ex_hdr.provider_out_words)
>    680					return -EINVAL;
>    681			}
>    682=09
>  > 683			INIT_UDATA(&ucore,
>    684				   (hdr.in_words) ? buf : 0,
>    685				   (unsigned long)ex_hdr.response,
>    686				   hdr.in_words * 8,
>    687				   hdr.out_words * 8);
>    688=09
>  > 689			INIT_UDATA(&uhw,
>    690				   (ex_hdr.provider_in_words) ? buf + ucore.inlen : 0,
>    691				   (ex_hdr.provider_out_words) ? (unsigned long)ex_hdr.resp=
onse + ucore.outlen : 0,
>    692				   ex_hdr.provider_in_words * 8,
>=20

This warning is not reported by compiler (gcc) since an explicit cast i=
s
present in INIT_UDATA(): see drivers/infiniband/core/uverbs.h[2]:

#define INIT_UDATA(udata, ibuf, obuf, ilen, olen)		\
	do {							\
		(udata)->inbuf  =3D (void __user *) (ibuf);	\
		(udata)->outbuf =3D (void __user *) (obuf);	\
		(udata)->inlen  =3D (ilen);			\
		(udata)->outlen =3D (olen);			\
	} while (0)


I'm going to submit a patch to fix the sparse warning by removing
implicit cast, adding explicit casts where appropriate and replace
0 by NULL in uverbs_main.c

[1] kbuild-all archives
https://lists.01.org/pipermail/kbuild-all/2013-November/002120.html

[2] uverbs.h
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/infiniband/core/uverbs.h#n50

> ---
> 0-DAY kernel build testing backend              Open Source Technolog=
y Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Cor=
poration

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
