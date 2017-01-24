From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1] IB/mad: Add port_num to error message
Date: Tue, 24 Jan 2017 14:22:57 -0500
Message-ID: <1485285777.43764.46.camel@redhat.com>
References: <1484837311-13206-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-1oi/n6CeYVLgQDS+uPpP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484837311-13206-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-1oi/n6CeYVLgQDS+uPpP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-01-19 at 16:48 +0200, Yuval Shaia wrote:
> Print the invalid port number to ease troubleshooting.
>=20
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v0 -> v1:
> 	* Fix typo in commit header

I chuckled ;-)

Applied to -next area, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-1oi/n6CeYVLgQDS+uPpP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh6mRAAoJELgmozMOVy/d4/4QAJhlCfA42C00+V3omcOIWDT/
01gS9WU+Q3HhZfo3rtvg9AXSlLlAfCb8YnYD0Fy1qvT/esv1cLEIZh1h+Y9m1kUy
Pp+nE+QA6moNWsfiOijuEZGeqUk8t7C5CnpjM88Uh4ICH7HoQHoB7iYadpyyXw7q
nS5BP4RIyZ42eUw+ErlRbvMh4SQdvtTB6PZ+0zPLJfnoJG3FZwACwkP5lCL5FznZ
c1tKvpvXwqjbSE/ypbKrGl00fnbi9gFx7XMcDHpnZfBI/eWM7gmfI6AG+95j1sio
TRlArKNtnMTaXdgyUtSNIxkPxmMIS3w2cf+vjYFALzrbr5ppSv4BJjto3TSHOO4A
2gRx3IZ/vcIspEjswlXvo6dId109ySU2tE6KK0r4sKhK6wnDcUiG3v4yYh0jc8/6
zhtq4T7rfJmC+bXZNlX5uuYy+NS7wjeza/4Qkaj7e75rO6bDJ4UvqR/T8ayQiIUv
Ffo54hFooRPxV0TX7UbUlsIs29/5fApYgvpG6TS0UrnPANw9ro6vtOv2zHBRDdvE
5fbBSVqjAJAnOhQ2QYvMRJdBoazRr6OGmVsAHHR2W3KuaXzxsUHv+J9AR1qzJoEE
78xU1ogGA23byw1kxIyGExDpNNbLyLsgyfevCq5omB3pQKbyqOKKfBqWJSQUg+EO
B0EougxnKHs9GMse5zg/
=xFba
-----END PGP SIGNATURE-----

--=-1oi/n6CeYVLgQDS+uPpP--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
