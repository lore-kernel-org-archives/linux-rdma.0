From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] More SRP target patches for kernel v4.15
Date: Mon, 13 Nov 2017 15:26:17 -0500
Message-ID: <1510604777.3735.32.camel@redhat.com>
References: <20171103232056.30614-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-GCyA0fQmjVkeggT57QVg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171103232056.30614-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-GCyA0fQmjVkeggT57QVg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-11-03 at 16:20 -0700, Bart Van Assche wrote:
> Hello Doug,
>=20
> Recently Mike Marciniszyn discovered that ib_srpt non-SRQ mode does not w=
ork
> on Intel adapters and also that switching dynamically between non-SRQ and=
 SRQ
> mode does not work. This patch series addresses these two issues. Please
> consider this patch series for kernel v4.15.
>=20
> Thanks,
>=20
> Bart.
>=20
> Bart Van Assche (4):
>   IB/srpt: Introduce helper functions for SRQ allocation and freeing
>   IB/srpt: Introduce srpt_disconnect_ch_sync()
>   IB/srpt: Wait until channel release has finished during module unload
>   IB/srpt: Ensure that modifying the use_srq configfs attribute works
>=20
> Mike Marciniszyn (1):
>   IB/srpt: Post receive work requests after qp transition to INIT state
>=20
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 229 +++++++++++++++++++++-------=
------
>  1 file changed, 143 insertions(+), 86 deletions(-)

Thanks Bart.  I reworded git message to the first patch, and then
applied the set.  Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-GCyA0fQmjVkeggT57QVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloJ/+kACgkQuCajMw5X
L92qfQ//Zfc99nb1K9B7VRhEX+TJ2b5KvaFJozT4iPeKEfO4ACl7fOWtSGzMmCDh
/dKM7+Mf0U254iAnw9noDBSNhup4EgY3cfdw5R84H6qQUiBaHpzY17qC40KQN8Mb
6YwWRNIbqvaAcbBKP6ciVr8PTFSEwGHtD8NMxSWEbeVjAcv4+3y8bGjXq6bjMSVJ
28GaLreWuo2p+NrbcR/yYRMyqtzhxrLI3OBffq5f8NU0wkQ9QOeoQ3cRvjxam8C9
QcISjxA/nwMv2R0FyX/PzSshPv1pyDfE970SXD7rWLudDYg2kbqskeeUHYcLuW3t
3s3djkxgvW1K4PvHYepZxFsJWMJwvAj40uIWhZJOK+oOhhzaQT8jZ0gsCtPD67Fk
SpXT0MQu+84LnBBJPyeRFQ5o+LvkGJL6cIoa4NnvrwpJpERQiOjURXLsdN+NZHI5
j76uuDOVQ0cvziFc0tUywoMUNqf3l1j7YMvtEwxifa5aAbmkAoJGXx46544AoH9a
/I3amBhBiR7QldjNrZLGugccDcI5iZho37yrdcFfPLFSuiSmY155kQqxZ9k4AuyM
arG8jXq1f9AjdQjxba4wL9tZOc63IsMB98XTffrrsyQe0moqlSRgvOUjR1AnDZ0/
wYi87/J06Vc6900d9tAGBujaKIqMUt5K7vvcCgdRUl2u/vzva04=
=iQAR
-----END PGP SIGNATURE-----

--=-GCyA0fQmjVkeggT57QVg--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
