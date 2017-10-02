From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 04/18] IB/mlx5: Use ARRAY_SIZE
Date: Mon, 2 Oct 2017 07:38:48 +0300
Message-ID: <20171002043848.GH2031@mtr-leonro.local>
References: <20171001193101.8898-1-jeremy.lefaure@lse.epita.fr>
 <20171001193101.8898-5-jeremy.lefaure@lse.epita.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="X+8siUETKMkW99st"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171001193101.8898-5-jeremy.lefaure-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?iso-8859-1?B?Suly6W15?= Lefaure <jeremy.lefaure-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--X+8siUETKMkW99st
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 01, 2017 at 03:30:42PM -0400, J=E9r=E9my Lefaure wrote:
> Using the ARRAY_SIZE macro improves the readability of the code.
>
> Found with Coccinelle with the following semantic patch:
> @r depends on (org || report)@
> type T;
> T[] E;
> position p;
> @@
> (
>  (sizeof(E)@p /sizeof(*E))
> |
>  (sizeof(E)@p /sizeof(E[...]))
> |
>  (sizeof(E)@p /sizeof(T))
> )
>
> Signed-off-by: J=E9r=E9my Lefaure <jeremy.lefaure-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/odp.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>

Thanks J=E9r=E9my,
I took this into my tree and will forward it to Doug L. during this
cycle.

--X+8siUETKMkW99st
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnRwtgACgkQ5GN7iDZy
WKc+tQ/+KtPpL6Dj0TaoRD1f4TDbV4OpVrhSkPX45R4zcWHWe/Z0Y4yYyYC2YLdQ
nlYPfONpJjwRBLenm/J9UE+6s7GQmR+TW+NY1m6CXdcc7xyC4wBk9+sF6TPIEwaQ
fI6WQSiRTAJke1Rz49BFQ9/SIv6AJXW8xJMILiR61TUgomOQC9zthRN+mRronRlc
cA9PxYNfquOZ85kHSU1qiM9NDz1zqhvhYGSPy1YfnatWmjhQ/Iq0Jz8Xe9ZD5hFd
y3I4ePg7S7XOJuUoqh7gE/zZPSLmOm/KV0CJEdlCqpU3EfWmJpTE3NYpjCAw0G91
erdG5EW1zq2wFsTLo3BZww5hJZ7hOOFbdO1hBhCNcOYlN87n04rhLHIPMykXlowf
WJC9HVPYnzEHYLVlXf3r/3JpGBc8HBqu3iLfQ890rM4qDXd3wYp1oQeefRixoBoj
uABauGtowXTxgRt4gMg0gC/hkeW3ZVUiRs+LBwi19rvSKaqGhvAtMR8Ge2TX30cV
ddJaoW1oXUa5FuWr9OdZ0czbBr76JHkwBxuKq9isQK7jaFFdFNc/jE4dq7A7brzG
LklQWs9qlhSN6D3S0VQi7zCnY/5VjRXNh+RwMLGdadl/xB1Z5A+EnJTz9sswvzfc
VcY2nIXUyJScCQ1knWgaX4heRbrLD2UqOQt68X/oGOj3E6nDVsU=
=Tp+2
-----END PGP SIGNATURE-----

--X+8siUETKMkW99st--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
