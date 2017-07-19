From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Convert pr_info to pr_warn
Date: Wed, 19 Jul 2017 10:51:19 +0300
Message-ID: <20170719075119.GO3259@mtr-leonro.local>
References: <20170718203539.6777-1-yuval.shaia@oracle.com>
 <20170719060908.GN3259@mtr-leonro.local>
 <CAG9sBKNXfndf8Lxa97Z8Cc=Ntg+=NoZ9-35CbY0X=0f2aXRx8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6cMF9JLEeZkfJjkP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKNXfndf8Lxa97Z8Cc=Ntg+=NoZ9-35CbY0X=0f2aXRx8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--6cMF9JLEeZkfJjkP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 19, 2017 at 10:11:50AM +0300, Moni Shoua wrote:
> > How this code can be executed? IB/core ensures that port_num is in range.
> > You can remove this check.
> >
> In this case ah_attr can come from the application and a validity
> check is necessary.

It is a bug if it comes directly without rdma_is_port_valid() check in the
IB/core. Currently modify_qp and create_ah are checking it and ensuring that
user won't provide illegal port number.

Thanks

--6cMF9JLEeZkfJjkP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllvD3cACgkQ5GN7iDZy
WKeqURAAmTNdrofEP2pClwbDyyoMUFH1uzzTpdJhRr4+t8lwxBkZ/zla1p2dPPyR
YZf3d9QP7ZpsSzswcuFH9XKAAQpk00De/QqC5BekzwZnp2FVlVL7pDapHNv2LOW0
VjmMl+F4AJ0bale6EcLh31anFFyGXRCkx17dLTOOqGWGKGXk89Zav/mKLkf9KkGm
eyIfr4vU0hUiXcwarY0oebEO74jUZn2d6T6J9vUI9oQq82zRtPgr3qVsQl5xe3b0
66qG7vNQyn0urXBn5TSDHDS7YnULdwL1KzgRnibaip5yyc56FU1cr8REdbTL8SiR
y9MkVzMrc9fnQ6Lxth+pojDgJOyjWts9RulLUwk4kwQLuCFcnzPwAMlbSOyDZiVI
R4tMKeaGUPAHnM+7bWSQENsrupt+V5W5y7DGf8ehW3aVvtJZJL0Yb6HXay6smRQq
IOyfWhQ/OpzHqCBzWd7b0jqa5ZLz0GXcinNP8NfJ72ZRHZx06ACr8U7umREsD3pH
ao4EIvpkcC21nsA6jqlsDII5mpnOcJyQMS9Q8bOX3iGhRIzNNGhSA0TrxfeppYGy
/bueEEd8si4kT6MxWVQ0ZD+2zTr6I9NfJ5sPGKO+bg2Oqcnul/N1tmCgMbvxAkIp
+XHR/UcyadKbaFhXcsr041ccQoIQ35DGvJUpE1HdoYduCitRng8=
=r6Nd
-----END PGP SIGNATURE-----

--6cMF9JLEeZkfJjkP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
