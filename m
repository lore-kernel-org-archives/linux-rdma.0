From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/srpt: Accept GUIDs as port names
Date: Fri, 27 Jan 2017 14:32:36 -0500
Message-ID: <1485545556.2432.10.camel@redhat.com>
References: <1b20f44a-0378-7b53-65bd-e079e9fa87ff@sandisk.com>
         <1485293831.43764.89.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-KJp03IiEDhiioV0gUWLy"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1485293831.43764.89.camel@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-KJp03IiEDhiioV0gUWLy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-01-24 at 16:37 -0500, Doug Ledford wrote:
> On Fri, 2016-12-09 at 11:00 -0800, Bart Van Assche wrote:
> >=20
> > Port and ACL information must be configured before an initiator
> > logs in.=C2=A0=C2=A0Make it possible to configure this information befo=
re
> > a subnet prefix has been assigned to a port by not only accepting
> > GIDs as target port and initiator port names but by also accepting
> > port GUIDs.
> >=20
> > Add a 'priv' member to struct se_wwn to allow target drivers to
> > associate their own data with struct se_wwn.
> >=20
> > Reported-by: Doug Ledford <dledford@redhat.com>
> > References: http://www.spinics.net/lists/linux-rdma/msg39505.html
> > Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Nicholas Bellinger <nab@linux-iscsi.org>
>=20
> Ping? =C2=A0Do the target folks have any input on this patch? =C2=A0I'd l=
ike to
> take it for 4.11 as it should resolve an issue we see regularly in
> our
> test lab...

I've pulled this into my for-next area. =C2=A0Thanks Bart.

--=20
Doug Ledford <dledford@redhat.com>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-KJp03IiEDhiioV0gUWLy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYi6BUAAoJELgmozMOVy/dVlIP/i14soDhd3y0SyBpPMMr6T6P
kKvY12PTXRCujCwKC4C86/YIxgZkGHagmR6vZwVWhX3U2cd8Jzpy4pF2w1qCKGgI
LWesa23lRjb9BOrnqvdzqxSW8+LiDUQMwUrBmCGtSlfedXCDpA5IGlY0sx+xhCip
cGCf1mFkZPBeKfbrjb3ogqR0H8DQ0XwA1pdW+VCLlOXThlbLmZyOmEktk3OQ+zrO
1rwolSBJBVZUzyCAK4wJImp6I7gMZ4H6/I62TODRbdWtoIP8x5ZzsDZOUHSfNKAK
Vc4xwTBJ1D13o9AOo4f4LzXJ4bA1Qj0ij5VZCYD3u1bM2qBEs6ClJMqb5dhQF64Q
y5u2KB/ak/pwY6lO9DZeYjzJafQoJ+XiuQKrelJUwM4IZEAJC9reaXrPZ0Xe+Cp6
oEVQkZQKqTMGQsfrBIT8tA3QnVcg5B5dIwXpBv+nE/Mg7MSFdz8WEeGa2rM6txmu
WYj5eSj1dQok4o3etOnsAPDmGrRPulR4flfkEfYwcetVAsXTHOqTXWYAGmen39ny
0J1437Kparl+WLoW2NK8lNmsphW8oQ67m3IxUMVCpyv66jgUfVVujnTTfSh8dQkU
Sujym49krRzjT3oGgZraWrIzglq3gjJL+18XVR6lnXjtmF4Ucfuz32UE53fjsrfc
t5m4zr4aa/FkDefe0tzt
=mRV+
-----END PGP SIGNATURE-----

--=-KJp03IiEDhiioV0gUWLy--
