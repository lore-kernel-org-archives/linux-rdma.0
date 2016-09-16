From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rdmavt: free the userspace memory region with kfree
 instead of vfree
Date: Fri, 16 Sep 2016 14:10:11 -0400
Message-ID: <501a2833-c985-a118-4259-f25f934a745f@redhat.com>
References: <20160909071537.18821-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3cW54S2DFP9GBoEfv9CIf9ixBlPgBXapS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160909071537.18821-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3cW54S2DFP9GBoEfv9CIf9ixBlPgBXapS
Content-Type: multipart/mixed; boundary="5jFIoitV33MdK8JuJsKuskvcNr92EQl5X";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>,
 Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock
 <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <501a2833-c985-a118-4259-f25f934a745f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rdmavt: free the userspace memory region with kfree
 instead of vfree
References: <20160909071537.18821-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
In-Reply-To: <20160909071537.18821-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

--5jFIoitV33MdK8JuJsKuskvcNr92EQl5X
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/9/2016 3:15 AM, Colin King wrote:
> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>=20
> The userspace memory region 'mr' is allocated with kzalloc in
> __rvt_alloc_mr  however it is incorrectly being freed with vfree in
> __rvt_free_mr. Fix this by using kfree to free it.
>=20
> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  drivers/infiniband/sw/rdmavt/mr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/=
rdmavt/mr.c
> index 80c4b6b..46b6497 100644
> --- a/drivers/infiniband/sw/rdmavt/mr.c
> +++ b/drivers/infiniband/sw/rdmavt/mr.c
> @@ -294,7 +294,7 @@ static void __rvt_free_mr(struct rvt_mr *mr)
>  {
>  	rvt_deinit_mregion(&mr->mr);
>  	rvt_free_lkey(&mr->mr);
> -	vfree(mr);
> +	kfree(mr);
>  }
> =20
>  /**
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--5jFIoitV33MdK8JuJsKuskvcNr92EQl5X--

--3cW54S2DFP9GBoEfv9CIf9ixBlPgBXapS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX3DWDAAoJELgmozMOVy/dbrgP/2JWj9Lt+/XJckJZLHFhBDgC
RosMyq5KpNF/UHCi5URP+fLXfQ15L+QZthNm1jarN+4/VuTLX4xf/T5VbJFiSkj6
9/Rx1KvtcmJocbWTzceXOglzIerEcaqpeWCjEwz2YF0mwk5lLbp6ZAr6bSLGJfot
uamf0+3fm9nSaX/TCeNBo0eFYkgRxwE1Ryuus65YH29eTVKbz8iWKN/l3+wmcN/i
RVPMT1s/68GOHEueu8JV7UVe3NAEUBDuHdBbYXiHU+Ruq9TAzZxKXkrsn2+uIifb
QKUllvKEwMLFfcEp2l1stJd6cCK0eHHPR3mwHdAyE7q2SpQf6FXR6hIeeaxU6CO0
d2JLD2hmldLXD175xdR1iF1Akep3fasJzqCOhAfKMIID9cnydkN0NYQ3vJjiigui
j/S0QsJ+EZ3Z9AW2JxrvODxOpmwx+rNcUzkoMuRcyTPMs9DsYVsybf6l8JGfIhKZ
IFjSX4WENQKhLySxiqAPqSqHMS/Yaug7031uqMVWsn2wQv2Z22U9148C1M/qtP8M
LYUoqLdRsb20Z/U80wzCpmhxpbfvx+df03QqeuJLdomTPvezlUDe9eCgeJ4PgBT+
ZC+fop+ukoNiy2j6hlnXjp74jpTKJekF5RjdPQ83Jgs8XbfW6kbldsEbLV5JEQFb
Jbl+1zLe+g+TFTh1zkPo
=ALod
-----END PGP SIGNATURE-----

--3cW54S2DFP9GBoEfv9CIf9ixBlPgBXapS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
