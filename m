From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/usnic: Improve a failure message
Date: Wed, 23 Dec 2015 11:12:02 -0500
Message-ID: <567AC7D2.6080001@redhat.com>
References: <1449686539-29959-1-git-send-email-neescoba@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1QMMiiQoONEVSJ6ASLAcLX2FegEV6rS1p"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449686539-29959-1-git-send-email-neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1QMMiiQoONEVSJ6ASLAcLX2FegEV6rS1p
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/09/2015 01:42 PM, Nelson Escobar wrote:
> Signed-off-by: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/usnic/usnic_debugfs.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/usnic/usnic_debugfs.c b/drivers/infi=
niband/hw/usnic/usnic_debugfs.c
> index 5e55b8b..92dc66c 100644
> --- a/drivers/infiniband/hw/usnic/usnic_debugfs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_debugfs.c
> @@ -157,8 +157,9 @@ void usnic_debugfs_flow_add(struct usnic_ib_qp_grp_=
flow *qp_flow)
>  							qp_flow,
>  							&flowinfo_ops);
>  	if (IS_ERR_OR_NULL(qp_flow->dbgfs_dentry)) {
> -		usnic_err("Failed to create dbg fs entry for flow %u\n",
> -				qp_flow->flow->flow_id);
> +		usnic_err("Failed to create dbg fs entry for flow %u with error %ld\=
n",
> +				qp_flow->flow->flow_id,
> +				PTR_ERR(qp_flow->dbgfs_dentry));
>  	}
>  }
> =20
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--1QMMiiQoONEVSJ6ASLAcLX2FegEV6rS1p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWesfSAAoJELgmozMOVy/dDJsQAIj0UaqaooOkNqSUh9LL6uYZ
HVeFT0awOVg3xJWSeZD705cpCuXYj4YSDEBttjuJ2IerBOamICkfa6cwmJO0n9+6
0Vf6aAvuRk/qSJdmlOxfH18e9oFYZCf92OvvDxrDR1BUIjJeMm+MhtnAIuisW7rB
OEpfMFHo9sYwJ4vgdBDMcD8jgrLOIeP9iIRO+0q9bCProVplMOMqcfll8rxRj/kg
lDfSDWS2h/lmzsNHASUNiy1kK1lLapmvirzchYWtPvL69KU1OyiIGxVRb/9Wd/om
Vev81KG8bZ55DwdMRd65dJOUPNzJsHC/XZYh7WqwXan7hT4u6ZslbfFiYp3hGzJt
P6inybR4VNXSgbwqNbJ5KKmpWRW/0f7M8l50glodwOC2kayBEuCbNi4ZQRtcR4xA
YswzJUimUjjtT4aMUCI1QnuwFLsCHJO8gE5DUmd0C2Mai0QdU6+CsnsMLsHxDlAY
3xX/I+acV02wQZdOKZNbSJgayuYX91Uwdco6YmKVdP7aMNgU01jE2zd6VFzAdjvC
+HrX5G6rnxxsHD9iW26VFd/AsrQWSV4WW7EigzvuGIt5m7wMN0l/PolESzwhyy5C
cpLJ7H/lcZOjhK0yGt/cZsx0QGJCOttUEtghkNxJmCEXuF4qYBfRKS0CWoJ3nJTy
6gUkWTl1tnS/SABETSFr
=bj7F
-----END PGP SIGNATURE-----

--1QMMiiQoONEVSJ6ASLAcLX2FegEV6rS1p--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
