From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: RDMA/bnxt_re: Remove redundant bnxt_qplib_disable_nq() call
Date: Tue, 19 Dec 2017 13:17:56 +0200
Message-ID: <20171219111756.GB2942@mtr-leonro.local>
References: <9fe13af401074304e355c6d1c5138b63e03b8da8.1510663723.git.arvind.yadav.cs@gmail.com>
 <20171213173747.GA13512@ziepe.ca>
 <CANjDDBgR1vcSVvvKPvgeQPsDn3F8LLWA00nreonPyfyvBfvWnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBgR1vcSVvvKPvgeQPsDn3F8LLWA00nreonPyfyvBfvWnw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 19, 2017 at 04:40:42PM +0530, Devesh Sharma wrote:
> However delayed ack but still..thanks for supplying this fix.
>
> Acked-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>

Devesh,

What should we do in order to stop you to answer in top-posting format?

Thanks


>
> On Wed, Dec 13, 2017 at 11:07 PM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
> > On Tue, Nov 14, 2017 at 06:20:56PM +0530, Arvind Yadav wrote:
> >> The bnxt_qplib_disable_nq() call is redundant as it occurs
> >> after 'goto fail' and hence it called twice. Remove it.
> >>
> >> Signed-off-by: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>  drivers/infiniband/hw/bnxt_re/qplib_fp.c | 1 -
> >>  1 file changed, 1 deletion(-)
> >
> > Applied to for-next, thanks
> >
> > Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo49WMACgkQ5GN7iDZy
WKf1OA/+LzY5niElTYlT7aX1OsbkL0oVY1rf2xnA0YWgO2BPWmI5VuokjIDVbOa6
zQ3ErUutE0qg+TzFDVKdIhIqWnew6xHwdEUCvYsAi8vNCHBTl4JDTNPUnQ4mSSTb
PRDkqO1tDJhf1eLcO14FxFQ5vfy1R7RqvLJDZLORGnXHOyZLI7nOZxWZ+Z+KhxmX
O8QAXyT795XuBW0ieJCnaJ46p8jjLP+30cs6KlGi8pFDRRYuuhaR4dDZ80i0tr6q
aVq1gxO9/k2vOKnSqtDqcTlxa98RGgCpe63ud1kDnCAGxSyPyrSrhZOhjys5HHla
pak0PkSM3gBvG46mWd404p1rx/xSaWYnMMrDe+mRtoL2ytDxqfw0P7izLn8PAR+i
kuxUJ3zx/2ODKZALTAloFmZa+bZTzhipOVcRNEHlzXF5Wj85IyTMd8V3ZUTJ9tDl
/WejDK9sTjrHKPGoWfCwjS8hgIKk4pW0iyKaKDNEmW8gRFUYT3rJG1PIQkii1aLM
8z+nEUfSEA9m6sb09/7Xh82O94TPBg1GRK7ysKFNOYdNew8+9KR4glIDnPgiGqYn
j1PBN5XcVnWKx0WInQ/kvp8F2dlSfhqzTxq8bQdwyj+H6046r17L4eF6taRNfxiE
noY0cpgm6amp1Ajd4/WJCZ5q3hhHAHuGVjcnkqMkzCysIwK6p/k=
=6VuC
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
