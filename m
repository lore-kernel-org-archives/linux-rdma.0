From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] Adding memory re-registration for mlx5
Date: Thu, 3 Mar 2016 10:48:27 -0500
Message-ID: <56D85CCB.5050704@redhat.com>
References: <1456757211-8112-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="btnEe2seeOxtNE8hlfq5exSQMmANhmdkk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456757211-8112-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--btnEe2seeOxtNE8hlfq5exSQMmANhmdkk
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/29/2016 09:46 AM, Matan Barak wrote:
> From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Hi Doug,
>=20
> This series adds memory re-registration support for the mlx5 driver.
> Re-registration of memory region uses UMR if the current MKey is large
> enough to encompass the requested length. When this is not possible,
> a new MKey is created using the firmware command interface. In this
> case, new LKey and RKey are created and must be communicated to
> remote peers by the user.
>=20
> The MR's umem is kept only through a PD-only change. Otherwise, it is
> replaced as well.
>=20
> The series contains 2 patches:
> The first patch refactors the register and deregister MR flow so that
> some code parts could be shared later on with the re-registration
> flow.
> The second patch introduces the actual re-registration flow.
>=20
> Thanks,
> Noa and Matan
>=20
> Noa Osherovich (2):
>   IB/mlx5: Refactoring register MR code
>   IB/mlx5: Added support for re-registration of MRs
>=20
>  drivers/infiniband/hw/mlx5/main.c    |   2 +
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |   9 +
>  drivers/infiniband/hw/mlx5/mr.c      | 375 +++++++++++++++++++++++++++=
+-------
>  drivers/infiniband/hw/mlx5/qp.c      |  51 ++++-
>  4 files changed, 359 insertions(+), 78 deletions(-)
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--btnEe2seeOxtNE8hlfq5exSQMmANhmdkk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2FzMAAoJELgmozMOVy/dr0sP/jdlztW7hNQVNFGWueJG+/wm
5pO4ZQdA4aewsEMfj4Vjb9krrGWhby2gGLVBKqHtPxYGN4tLNqDt96oK3ZNuFXW7
txJrzcMpKUt8htufDn5eBrheXRU7/TK9Li5kjkj1O7hWpmnGQiA1oYdfC6tfbE5L
pT/YyUxcohGeztDcPxIpi72XtZ7wWhKMD+VtoPgvvOmKiZxh3/WNo4cnW4Yz6lqi
TuYusby85uYWaLsEsnd+4pzP/XvctEUXGy+/aD91VolFy5O4T1+viCwil8IasdJP
FIj/z3kGz9zef+0mZWZkTAdVubuaN5t/r3Uh5/162RfBUTP67ZHwBW5eFBY2CdEg
WZIcrEQB4h6zjuwU8uYvGQAFBn5MVdJVIklZjzi3KbjN196QH9o253za/NyMmkYY
i5MghQd3SZucYQtZdrIp+5zGISU/fERBWWW9ICB21WsFiDM6ktuSjSvQWPkDx9jD
KosgvrmmW2vXcx69w90vaP0XKLltMQj+b4PwfsTiwjn73Uijle9GtnUGDHunSxT2
rpEoQfGO40FSoNkmkDgaf6wQynVy1KuIPRoOqVubLlJktdD8lPtZW0mdtnq+jKI0
KTyfwaB1n/9G1z2nSdPjXzplifctyXA8eVChavXbQEZVq5pEOtwV0DT6F9Z1ltK2
L3CRKRAkjaYU8nEcRzz9
=ujiR
-----END PGP SIGNATURE-----

--btnEe2seeOxtNE8hlfq5exSQMmANhmdkk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
