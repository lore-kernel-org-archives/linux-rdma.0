From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] lockdep warning fixes
Date: Wed, 08 Jul 2015 18:36:25 -0400
Message-ID: <559DA5E9.5050500@redhat.com>
References: <1436280313-21451-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1G0gtmN4hWEd2ATT8C0oulCj94nr0Wo2X"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436280313-21451-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1G0gtmN4hWEd2ATT8C0oulCj94nr0Wo2X
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/07/2015 10:45 AM, Haggai Eran wrote:
> Hi,
>=20
> These two patches fix a couple of lockdep warnings I ran into, in IPoIB=
 and
> RDMA CM.
>=20
> Regards,
> Haggai
>=20
> Haggai Eran (2):
>   IB/ucma: Fix lockdep warning in ucma_lock_files
>   IB/ipoib: Prevent lockdep warning in __ipoib_ib_dev_flush
>=20
>  drivers/infiniband/core/ucma.c          |  4 ++--
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c | 13 +++++++------
>  2 files changed, 9 insertions(+), 8 deletions(-)
>=20

Thanks, both applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--1G0gtmN4hWEd2ATT8C0oulCj94nr0Wo2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnaXpAAoJELgmozMOVy/dlPwP/2tX4fx+xtkhW/2KlEIBi8ob
DWxg7o7S26fLVbKXxsG+US6vvYBdtXAU4xiyW7J9/TcojqXG7o80X4KelYxqHFg0
ywQ761ebXTLf0Fzr9mWTO9xMFCA9QlFihgSAc4eu4jwJaHDxXwxQcMtcgaThF0sz
FME/jEBPX/2DVjEjZFjsih5QZ2faJ9KdJIEuXZKFi7cvX19LZI6Df1Zo5fjty7BV
aKBeWdFG/aj5ZTVPCigMQR34YcZcetb1jeLNAECC1/4ijCCOUWiFOtdDmJ1gCp8y
elFYil8Ux6os9TfC6MWJ66Nu1lpLzMVQvb8nCCfpYGSmlN8uNsIPGcnLeTt0M7L6
qiOH6tBgooB1BSUez8XorYHjPE6l0OWLh/qEA4SzPfeX+kocrtpBKOB7gAXt4cUJ
x13fJ+8N1MdiXXArnkcqDA2Dfz3KkWAeAzM9lX4ELQtxJjF4To2yJsutBAU46v7q
K20cSIpFd6stewpxN7nS0Oizp95D6GEOGH+2uIMpJgLuxRx3VZrySC8MMZy3eHhz
iXlhDRRrqnG+0+i9gL3EBBR8sNqDwZqKMRGRsJuRagIkB7Cljltb3M+MdraC6Jw9
GzxMO1+HXCW04qDOIuTbt/ud2JDkefIPUH2trNHuZApRtNJTGzMHSeDIkF83JEl8
IGlGJBneG5kHXsCH+S3h
=u0iu
-----END PGP SIGNATURE-----

--1G0gtmN4hWEd2ATT8C0oulCj94nr0Wo2X--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
