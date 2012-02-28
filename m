From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] ib_ehca: fix compile failure on ppc64
Date: Mon, 27 Feb 2012 21:18:35 -0800
Message-ID: <CAL1RGDXjF-Y-UABiondu6y9k9HRoxgE9oVAbp-BJ4x+iuRjiWg@mail.gmail.com>
References: <20120227220255.GE29211@redacted.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120227220255.GE29211-nxOev/eQj6CGu0OVIAPS5KfLeoKvNuZc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kyle McMartin <kmcmartin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 27, 2012 at 2:02 PM, Kyle McMartin <kmcmartin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
> =A0static u64 ehca_get_max_hwpage_size(struct ehca_shca *shca)
> =A0{
> - =A0 =A0 =A0 return 1UL << ilog2(shca->hca_cap_mr_pgsize);
> + =A0 =A0 =A0 u32 pgsize =3D shca->hca_cap_mr_pgsize;
> + =A0 =A0 =A0 return 1UL << ilog2(pgsize);
> =A0}

How about using rounddown_pow_of_two(shca->hca_cap_mr_pgsize)?
Does that build?  Because that seems to me to be a cleaner way of
expressing this anyway...

Something about that ilog2() implementation seems to trigger gcc
bugs, I seem to remember some other bogus compile failure on
sparc involving it as well...

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
