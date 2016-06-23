From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Implements disassociate_ucontext API
Date: Thu, 23 Jun 2016 09:56:54 -0400
Message-ID: <34b6fb63-a3e3-f0c2-6f91-c995030f13ea@redhat.com>
References: <1466164604-30273-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LHUpERvKhVjdLKRCHOWx5edT8lXmwLdQN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466164604-30273-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LHUpERvKhVjdLKRCHOWx5edT8lXmwLdQN
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/17/2016 07:56 AM, Leon Romanovsky wrote:
> From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Implements the IB core disassociate_ucontext API.
> The driver detaches the HW resources for a given user context to
> prevent a dependency between application termination and device
> disconnect. This is done by managing the VMAs that were mapped
> to the HW bars such as doorbell and blueflame. When need to detach,
> remap them to an arbitrary kernel page returned by the zap API.
>=20
> Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

This has been accepted for 4.8, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--LHUpERvKhVjdLKRCHOWx5edT8lXmwLdQN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXa+qtAAoJELgmozMOVy/drHoP/1hfz55G1xdlED1aGMFUQx3b
iSdOtJ3vJzs0HclUCFnOLlURZuW0KvHh6CKbwOEqVIk5entKEJKpxVRRxzpI6XeW
5lx8DMufLDH1YgrMzbQR2AdaJKaw2k5TSPA52/6RR9Jtf/yjGo3p8EnK9q0oB40P
sJ7S902Xyf1e+8tNHbmDzhHQyx+HuMp7Czh2PJBBtPO/eOPrbt6hDbf3qxndAKav
394/31P3pRBJl67a+G1ZL0l+Pw9QFGL1iWMmuFaA26P2E4CPob/CCbtLMPujpGV8
QuhbKj0g0R+N02ByxDYQNGISUGSpC5A8/3+Igo/QDS5cyiNbsL+YY7txofAU8V+q
5C41kNXla482S/fPPitONR7QBaD/D2ZHsWzUuLHxSdFNrGfJgo9SxWpJIu/7vYoZ
SdHGntJmEPLMTLt3jqGwIcBUqfm21DOtqVMk0lCMq6RS+8z1xbJ6wTaa9mtZjdus
Q+lbv1ujSgIL3zQq1ov2jruggoE8y1VP++OknmTxoGcnym2eG2MMpDk3TWinPguA
r8Um7WS/tgPJRO9gu5t+zEVjqXm7l7LGBktP7hZljof6adBs1q9qB5jUT9ygpxru
fMGUcWva6VLydfoIkeo78TdzNz5fAib8opZTQsjOkaswQQAZelZNKWFyeAkGJIqh
RuMgnd8UEHezMVX+BrjC
=ruBc
-----END PGP SIGNATURE-----

--LHUpERvKhVjdLKRCHOWx5edT8lXmwLdQN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
