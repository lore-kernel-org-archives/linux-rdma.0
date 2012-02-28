From: Kyle McMartin <kmcmartin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ib_ehca: fix compile failure on ppc64
Date: Tue, 28 Feb 2012 10:15:46 -0500
Message-ID: <20120228151545.GF29211@redacted.bos.redhat.com>
References: <20120227220255.GE29211@redacted.bos.redhat.com>
 <CAL1RGDXjF-Y-UABiondu6y9k9HRoxgE9oVAbp-BJ4x+iuRjiWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDXjF-Y-UABiondu6y9k9HRoxgE9oVAbp-BJ4x+iuRjiWg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 27, 2012 at 09:18:35PM -0800, Roland Dreier wrote:
> On Mon, Feb 27, 2012 at 2:02 PM, Kyle McMartin <kmcmartin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=
 wrote:
> > =A0static u64 ehca_get_max_hwpage_size(struct ehca_shca *shca)
> > =A0{
> > - =A0 =A0 =A0 return 1UL << ilog2(shca->hca_cap_mr_pgsize);
> > + =A0 =A0 =A0 u32 pgsize =3D shca->hca_cap_mr_pgsize;
> > + =A0 =A0 =A0 return 1UL << ilog2(pgsize);
> > =A0}
>=20
> How about using rounddown_pow_of_two(shca->hca_cap_mr_pgsize)?
> Does that build?  Because that seems to me to be a cleaner way of
> expressing this anyway...
>=20

Yeah, that works too, good catch, I should have noticed that sooner.

> Something about that ilog2() implementation seems to trigger gcc
> bugs, I seem to remember some other bogus compile failure on
> sparc involving it as well...
>=20

I suspect it's the 64 deep trinary operators ;-) (It seems to trip up o=
n
the __builtin_constant_p and hit the second ____ilog2_NaN) It's a prett=
y
weird .config dependent bug, I'm very confused by it.

Suggested-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Signed-off-by: Kyle McMartin <kmcmarti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -112,7 +112,7 @@ static u32 ehca_encode_hwpage_size(u32 pgsize)
=20
 static u64 ehca_get_max_hwpage_size(struct ehca_shca *shca)
 {
-	return 1UL << ilog2(shca->hca_cap_mr_pgsize);
+	return rounddown_pow_of_two(shca->hca_cap_mr_pgsize);
 }
=20
 static struct ehca_mr *ehca_mr_new(void)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
