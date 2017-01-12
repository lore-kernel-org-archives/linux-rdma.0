From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband/qib: drop qib_pci_link_reset()
Date: Thu, 12 Jan 2017 12:07:53 -0500
Message-ID: <1484240873.123135.6.camel@redhat.com>
References: <1482129996-19255-1-git-send-email-caoj.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-egd75D7OqUwDBN8lj39W"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482129996-19255-1-git-send-email-caoj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cao jin <caoj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-egd75D7OqUwDBN8lj39W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-12-19 at 14:46 +0800, Cao jin wrote:
> In AER recovery, pci_error_handlers.link_reset() is never called,
> drop it now.
>=20
> Signed-off-by: Cao jin <caoj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
>=C2=A0

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-egd75D7OqUwDBN8lj39W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYd7fpAAoJELgmozMOVy/dTigP/RPgLguOfZ2F/qN7yTeiI9Cq
BwH64aQMG2B1FJQNADKnEq3zENrjUPbgBh+G7716/jM8I1U9oijm9/OFEGJldA6e
JojDGmD5ROnbzIxK5gqErkpSJigrb6geEvLxGPHQ+bT/GLR/nia1evIjXBzdmr0I
MsdmiPfu9GEI5efkaT170ODxrR8ikmE0RTbA3cqtlFZGgQxRdaeqOL51X+B+WDSo
iL82NcDHmuoTNIRCtipiWz52fHCYN+TmyntHrjD9WSWqLxpBddJwVEkKNMWqK8JE
1pTjS18Cd3efxWRRxDXi7uBS5aRsv0jK6hm9UD1DuyRiW6u3Z2/8n8x4FakBze14
l7ku2hDLPM639yVQqFbI/PpXEhiAh1olv9rxVd4o1SiX6TTEwdHzzOljbzZOVLmK
Aw3YbEXQvm496V7Car1kcpltRKV8hulXzDujG8nzSIKnkFZZxCYWbZVdZ/hAo9Cr
VxBPnn3WX0Eta/4uhMc3osIYdIPvaGKQXJ0rWjQ8e9mV0z18jCa1pYnbGvsxI7zl
NJfliJuGfupDIu+H3IuCOc+BpH4tHxwcxBIXp1CTwXLt74Q7H75pnIhJucMgtPXP
12Ry8silG8c7wxWDeB4oIG7XIfCl4/IaAV37EHquWiBAnccyQ9qqSn88Vd0rZtnn
eo6/HARmxPUwms0Mz26X
=oTVj
-----END PGP SIGNATURE-----

--=-egd75D7OqUwDBN8lj39W--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
