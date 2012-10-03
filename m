From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Problem running rping over Intel adapters
Date: Wed, 03 Oct 2012 17:57:44 -0400
Message-ID: <506CB4D8.4010604@redhat.com>
References: <506CB0E9.90201@redhat.com> <1828884A29C6694DAF28B7E6B8A8237346A98E58@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5125CAAB0B91F80D663FF15A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A98E58-Q3cL8pyY+6ukrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5125CAAB0B91F80D663FF15A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/3/2012 5:50 PM, Hefty, Sean wrote:
>> 1) rping, on the client side, clears the conn_params for the newly to =
be
>> attempted connection, then sets:
>>
>> 	conn_param.responder_resources =3D 1;
>> 	conn_param.initiator_depth =3D 1;
>> 	conn_param.retry_count =3D 10;
>=20
>=20
>> 2) the qib driver enforces a maximum of 7 for retry_count.  I don't se=
e
>> anything in the spec that specifies a maximum for this entry, and in
>> particular I know it doesn't call out for 7 to mean infinite retries
>> like it does for rnr_retry_count.
>=20
> On IB, retry count is a 3-bit value.  See the CM REQ message.
>=20
> The kernel rdma cm should probably check for a valid value and reduce i=
t accordingly.

Then it's also fair to say that right now rping passes a known invalid
value and needs fixed ;-)


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig5125CAAB0B91F80D663FF15A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQbLTYAAoJELgmozMOVy/dBmwP/1Mmi3qeTiHo6TjuSKjCkIue
5h6M0PvttgH5qz2uWORpQIA3PqqA95d4g2Cp4D6AQazS/AU2b/ZK2+Nzhla4AJgx
TY+g5KOfnM6U6gDmF1cO5Q3IdjnPUFpC8Y2bj8E0IQM1URNYjG+bRa+2oyrd8Ush
pKFyQnw652zsU2wd3XoiW0uxKDqk0c+tJv/9fbZ9CdssW+LU+UZXne6elKiNFHK4
v49APVnx8e0YyFabQ6GbxhmITX5mLlI9DVhHqFHNaPi2EqpESzejitvTPXTNWfBb
uL9yZ811DZdQHBoAmOtZbxLrxaLBYM1qrdPPxEYn95rPc0AeZtHRJuKdBsclGdWd
hv/eu6WySuPzNJZHBK8Ih5p13hWkXfz/VoBsgyZ2KaawqV0GP+Xf4M0P8W/RuEqf
QvrdTcFVXeVu+vDS7McRxBza4AKX9ytMUWkA3vesmt9PEtEbh8osbg7Pl1S5y4eY
/FmDaq4H/EoiWA64k3VNg3waA/23EgYbD6h4iOQa9UaZeRM89bST/UKp32JU5BP4
z/uJvtZcR89Iyee2deh94IqND0Ck0KUSAtENOnqaw9KxxToTW23y8sLdIFpxgeGR
xQu9t26bRc77oRH+GRSPgJFdfud7oGN1H4Y4Lii9oE6U0bB2Lq/PSnlXNPWD3XKG
yNlrMV5FYA5fekBcpw1V
=+dFw
-----END PGP SIGNATURE-----

--------------enig5125CAAB0B91F80D663FF15A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
