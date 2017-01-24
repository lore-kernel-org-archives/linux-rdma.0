From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/core: add the function ib_mtu_int_to_enum
Date: Tue, 24 Jan 2017 15:09:20 -0500
Message-ID: <1485288560.43764.59.camel@redhat.com>
References: <1482734458-32131-1-git-send-email-Ram.Amrani@cavium.com>
         <1482734458-32131-2-git-send-email-Ram.Amrani@cavium.com>
         <1828884A29C6694DAF28B7E6B8A82373AB0CE4E4@ORSMSX109.amr.corp.intel.com>
         <SN1PR07MB2207C1F332D441FECD65C3F8F8610@SN1PR07MB2207.namprd07.prod.outlook.com>
         <1828884A29C6694DAF28B7E6B8A82373AB0CE998@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-etIEfmvLo27GM3SCNbxJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0CE998-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-etIEfmvLo27GM3SCNbxJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-04 at 17:40 +0000, Hefty, Sean wrote:
> >=20
> > You'll still be required to convert it to/from enum when
> > building/parsing CM messages, for example.
> > Also, why should it be an int if only specific values are allowed?
>=20
> The enum values are IB specification specific, and are incomplete
> (note the lack of Ethernet mtu sizes).=C2=A0=C2=A0Let the IB centric code=
 deal
> with the conversion, and let the rest of the API be reasonable.=C2=A0=C2=
=A0The
> IB CM uses the mtu value in the path record, which is fine.=C2=A0=C2=A0Th=
en
> maybe someday userspace can get access to the real mtu sizes as
> well...

Hi Sean,

While I don't disagree with your thoughts on the API change, the
original patch as it stands is a reasonable cleanup patch. =C2=A0I'm not
going to condition one on the other as a result.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-etIEfmvLo27GM3SCNbxJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh7RwAAoJELgmozMOVy/dbbsP/iph8mf+i4h35dRZKvMtinFz
C3NHwHP1H75mGv8UIEdHNbqeI6OoalmKpccTtCxyGsVdyglBdFtTV1rdKzRcBqPZ
EHa/k8c44aD2QEEWvTx3msTwbFiTuB2X+el9+OVrmK6mP152u4GXgD5ZfJ1CDBUc
T29955WRRlZEnbM+sg0+tdkKCbvNZhlD1vDOJcy98fi6CYMQ5laSdk27mDG3i8r7
DmCbpighNZnbLISwwJid5Hxpbqs03g1WfZ48GtidkKZlMEq7Qtseyit6Oto+9g8t
vuLUvo1ecZDFfYoC3VaZcx8XOjM95QO3UP6ctf/ObLbUGtKsCUFh5eEKaOrwSYn7
URgWru9Aa8uXHKUdL+Cze+zW+y6Og57W7whJ1SFjhs1De2Ie0km5vS9Lu2d2Riuh
aH0fwMgucdQ1wqfQu0inkCzUN722xHmZw06ctaKgLemUr+xwfc6WV4i+618NoBLF
B7nqOUQ+da/GJTJfBqBY3/e2ClXSO2uOmt9X1xPrvUzK02wNSHWis0G5V0T4+i5I
Yl2kaGTMld1F3pj4uzLL9IYq48mntErsGHw5z/i59vAaNtEIf/BnuPkfDCZ1M5ZM
H5rNRtH2GgqyqMOfyWEeyac6lU20ZFPNGdkexE8XiZXVyGu1AZPJIqNiRPnJ9MMu
BTE2fcdHzkinuCHlA7+1
=/fq+
-----END PGP SIGNATURE-----

--=-etIEfmvLo27GM3SCNbxJ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
