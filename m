From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/core: Add encode/decode FDR/EDR rates
Date: Fri, 05 Jan 2018 14:28:52 -0500
Message-ID: <1515180532.3403.33.camel@redhat.com>
References: <20180102135040.5243-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-9fut6fe9t34bAeYSQP5F"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180102135040.5243-1-Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?Q?H=E5kon?= Bugge <Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aron.silverton-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-9fut6fe9t34bAeYSQP5F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-02 at 14:50 +0100, H=C3=A5kon Bugge wrote:
> From: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>=20
> The cases for FDR/EDR signalling speed, were missing in
> ib_rate_to_mult and mult_to_ib_rate giving wrong return values when
> drivers convert static rate to/from inter-packet-delay.
>=20
> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: H=C3=A5kon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-9fut6fe9t34bAeYSQP5F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpP0fQACgkQuCajMw5X
L925lhAAtNste13CsChJ2Fo8IpGeCRBmFfsrdxCyhd4oe9QYs1U/+fhfWIKeewS+
/AKW070UovCDdtrfPYcV9RUr6iZl0U46faB4yyWFDCBXDqV12fkVBZgCTVFay2ZA
cZKnshrd/cRD9wRHhs5aq39ORJqsDvftTPtPizm5X9ZEb3JJVXL3BojVK6DTUwzM
CUz7duDhPmYV6Nrs3E7bD3q1Hyu6U7bVUeu/Pons3infaEajgzL4oWArI30zWWv3
4pTo6NEHGGcNLC6euAFa+Y3ERd/wVCBv96obRgTUW2U8RVSOSdbVb4yUvap3wn/a
2ZmUup/IKfMwKRknw7P8Cim6RHTNPSaiqUn0kImK88JpoqTkKaZabBJ4V1Z/7ilU
sOWwttbh1l7m1hqYVEaz9ws8S0CJrxAjarQak9Q44Y1NaZO7ninadPrhXqOzzyEX
+h0OuY4pyQHVavfTMRWszdQgjTRzY7lYzeBBn1O6MZlRnKI0oX9qQ1C+pH0wwqba
HhVwDq5KadVMwpmlXaY0hBRcFHra7C2ZZ5w4wiKVe3SMwSwDaiA3k/nS8xWkJYa+
dt89lQNGFG0cBZ5ZdeEhkGqu4CKn2vBjFlzDd4vEazsPod58L0L5P+C7yX6I37WT
0XG9wMw7E6ipsP1NTsrgpn9Srj7+zQCJW0B3U3puTUZK6Z9DxfQ=
=gqJH
-----END PGP SIGNATURE-----

--=-9fut6fe9t34bAeYSQP5F--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
