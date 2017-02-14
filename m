From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/11] Expanding raw packet capabilities
Date: Tue, 14 Feb 2017 11:30:15 -0500
Message-ID: <1487089815.86943.77.camel@redhat.com>
References: <20170118134004.5380-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-JoyIB+J7TZ1kCAe2CpRV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118134004.5380-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-JoyIB+J7TZ1kCAe2CpRV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-18 at 15:39 +0200, Leon Romanovsky wrote:
> Hi Doug,
>=20
> Please find the following patchset from Noa.
>=20
> This series unifies all existing raw packet capabilities under a new
> field in ib_device_attr named raw_packet_caps. This field is defined
> by the ib_raw_packet_caps enum. Such change makes it easier to report
> those capabilities back to the user.
>=20
> The existing IP csum and scatter FCS capabilities were added to the
> enum and a new capability was introduced - cvlan stripping offload.
>=20
> Cvlan stripping is the device's capability to remove the cvlan from
> an incoming raw packet and provide the data in the matching work
> completion.
>=20
> This series also:
> - Allows creation of WQ and raw Ethernet QP with cvlan stripping
> capability.
> =C2=A0 This is done by setting the IBV_WQ_FLAGS_CVLAN_STRIPPING bit of th=
e
> =C2=A0 create_flags field in ibv_wq_init_attr struct.
> - Allows setting and unsetting of cvlan stripping capability for an
> existing WQ.
> =C2=A0 This is done by setting the following fields of the ibv_wq_attr
> struct:
> =C2=A0=C2=A0=C2=A0 - Setting IBV_WQ_ATTR_FLAGS bit of the attr_mask field=
.
> =C2=A0=C2=A0=C2=A0 - Setting the IBV_RAW_PACKET_CAP_CVLAN_STRIPPING bit o=
f the
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 flags_mask field.
> =C2=A0=C2=A0=C2=A0 - Either setting or unsetting the
> IBV_RAW_PACKET_CAP_CVLAN_STRIPPING
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bit of the flags field.
> - Allows creation of WQ with scatter FCS offload.
> =C2=A0 This is done by setting the IBV_WQ_FLAGS_SCATTER_FCS bit of the
> =C2=A0 create_flags field in ibv_wq_init_attr struct.
>=20
> Thanks,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Noa

This is a fairly straightforward expansion of the raw ethernet QP
options. =C2=A0Series applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-JoyIB+J7TZ1kCAe2CpRV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYozCXAAoJELgmozMOVy/dAm0P/2O4rTpGNtf1drJDj7l6epV/
2VgP5exKFve0AX2iDa5jitRixzwiVSYVWe9AK9qeY882XEklPNgzc2BQGl9grTb6
IJXG0dXr+jEamxr2y84kvenCWV83gd8plB+TjmiQjF9Tl02H1os3a++3fpMAujCg
/haCXZXoh7TFGun2sBPYKmGvtSyOFf3uLppNOvZqxdTk5BfN7JLxXALsPZtDzxpg
Zv01nNHDq0wLvDRo6FBz6Aqw1yL6uWwnO0DtCkszGWIOLH5qD/YIR0Q6/L3sPS+K
flWMhe3qcg/qowV+2PqRt9tVCr8w+M2KznyUeD9kuVnZ5qJ9+b30S2+/qNLKO6OS
4bU+fojSUXLg4kW52L8vUEeshdyApPQ/AutSTEbAZ+Hy9L0oGR9VxzxkNcKJhk0C
Wkig5jeWXZN2JTtbCLqNrDLWa58J8X4R02PXL5cU0rpC6OdtitfdhKw+m4Cjcjwh
0fZMfoAu75yfTtqE0eKLVRp41AAumlgtMjSyHgakf7gY4pDtPWfri3PNxgR/YoIl
CYakTr1sn8ngFoo34ekppZeNovlIl3mTwAFlVWPEryMVsHbhbBKYmalnj6k5cOtc
FVWME+kkIPIbEIqilkGGh6RFds6pw49p94GXOClWoaJ+7WUSdjvQ99b+4mBxzi/3
hHL19pDwadsruti1l9kZ
=fTSX
-----END PGP SIGNATURE-----

--=-JoyIB+J7TZ1kCAe2CpRV--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
