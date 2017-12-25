From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 13/15] IB/mlx5: Use correct mdev for vport
 queries in ib_virt
Date: Mon, 25 Dec 2017 09:25:34 +0200
Message-ID: <20171225072534.GX2942@mtr-leonro.local>
References: <20171224125741.25464-1-leon@kernel.org>
 <20171224125741.25464-14-leon@kernel.org>
 <CAJ3xEMgyD693JPtu_vag-q3kVP=Nyag=dPEp15AZcyX62FwkPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="45kFsbCJmK9J4C/8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMgyD693JPtu_vag-q3kVP=Nyag=dPEp15AZcyX62FwkPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--45kFsbCJmK9J4C/8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 25, 2017 at 12:14:00AM +0200, Or Gerlitz wrote:
> On Sun, Dec 24, 2017 at 2:57 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > When using dual port RoCE mode vport queries should be routed to the
> > respective port mlx5_core_dev instead of the IB devices master mdev.
>
> isn't this code dealing only with IB (== Infiniband) virtualization?
>
> what role the modified code has over Eth (== RoCE)?

I think that you are right and it is not needed change.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--45kFsbCJmK9J4C/8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpAp+0ACgkQ5GN7iDZy
WKfFKg/9FPcMVxjAGCmZRUnZPM7Va315iKMeRncYTmat8nrpIc5Mgo+P4WIkyY3h
J4ZgzejcrvFprdOFIasAtbqk/nj6GZ/dqZ1bgzbj3PlDMtByCCkBr67SEfNzYQGg
pL9CWKWZTQICAEsy8YOy0kQ98FkuGLovayHczQWSQmqxxPDedeym/61XX+MN0hYH
z+etgt2vias/x6WUCwSRux1A7Qk3yFrndu0fMMUPIzQGbGpZ1627u0bbFnrIT2e9
XDu1n3k8BUaucrUz/hEJ9oU/RHhQSeoRiT8yHyKXdlu0qzMHZXYE1MxAmjlWt4UR
i9BGBRwFcDYVj7BgfTXIP2kTL1EDanoTHmVYD1zZ4xBoglOD700BRCrXzq3VMrwX
ygF6vk3SpgyIKhZtAhZUK2Jb7fhqxp1CcfRBPf/0zxSZAIZOaizvPqtmu7zLmdyG
G1ltJT0EOwGaEqieAvcCTs0G7XKSHbBePjU34mSMN+bcQ1lciJ0xsvt/UtxaTZny
sj0zPAWs7TPxi9j6sMLuNyG/oq2mnepGYXS+3Lzwx0lAkgrB6KWkJxGHWHhNOeXV
6dG6iFbuiNWHzfNiE8QrNYUK9p6+TS57f1zm9SAkVvMZRdW0a+SeowmaMO7J6kpQ
T2xKlgX02OYyXOw4LzWkP6NZ8/70h11Hr4Va0jKc2Zqvg/PcQvo=
=NLdi
-----END PGP SIGNATURE-----

--45kFsbCJmK9J4C/8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
