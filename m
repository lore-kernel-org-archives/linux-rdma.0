From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch v2] i40iw: fix some indenting in i40iw_sc_vsi_init()
Date: Tue, 24 Jan 2017 16:29:59 -0500
Message-ID: <1485293399.43764.81.camel@redhat.com>
References: <20170109194127.GA42156@ssaleem-MOBL4.amr.corp.intel.com>
         <20170109201216.GA3055@mwanda>
         <20170109203112.GA42952@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-WNqUor+1v3nd6x5ep6DU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170109203112.GA42952-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-WNqUor+1v3nd6x5ep6DU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-01-09 at 14:31 -0600, Shiraz Saleem wrote:
> On Mon, Jan 09, 2017 at 11:12:16PM +0300, Dan Carpenter wrote:
> >=20
> > The debug printk was indented more than it should have been and we
> > can remove an unnecessary line break.
> >=20
> > Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> > v2: I accidentally had a tab instead of a space.
>=20
> Thank you for the patch Dan.
>=20
> Acked-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Applied v2 of the patch, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-WNqUor+1v3nd6x5ep6DU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8dXAAoJELgmozMOVy/d4vUP/2r9MLV9hMt5maB9XC0/QjhM
0Raer7mRBlyGm9tc5HYmLH9sF1aVH7T1wXVHGH87JeW57CweeEVKBOQ9sBXYAuam
t2aBDbF/lZptBvk419vHGW40q3ys2ndKEoEYwpStpDIW4+6uK83v51KgJ4dH9JFX
eEv0TVARJtfIUGoxUtnuKLGUK/0U61CTFiH52LLv+NS6babFi3U45hnnQPeuMIJr
37z7XJhNVE8MYmKR+3hCnP3zS1x79e/wx7UJ2yLrt8VkK+FShYzSUdFEWWThhaME
MXuGXwhFtzer7KBtZhVIzcfdBMXXTBI4g0LcEhgkWkDyT6567vwgVMjF93NPjVaV
IJoHBjSoLJiAjKKyVz7b8Tx3SBcU5gzEkqqQ2oKe+sq3SYG0Nz7W+5z8fCBZ3Gtp
UCBD593OuTRKmvYd8CvnUSXILoXQjr35d+IO53JtuFzLX9BQfrNBuLrK4bnxR+3j
zT3b4/FkrhmUoyB/EWsBIbj7cjwFzvmZvBjyN/TkAYjOMOC3Mdn0UvBZ/k6ppwfw
QgA1WY0oJC8870h8QzdfbuDTTqBbYsf7kuVeLIziWW/snjrHjmKXySKlZaQE0duV
bHOcsI24Pol27sf77s2StaVsMViaiev5A+hcE60hWrxfJr09Fl+sWaF0wGjGiz4f
I02wmOHxGi3LemdoPihf
=Ch9G
-----END PGP SIGNATURE-----

--=-WNqUor+1v3nd6x5ep6DU--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
