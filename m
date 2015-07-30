From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] libibverbs init.c: conditionally emit warning if no
 userspace driver found
Date: Thu, 30 Jul 2015 12:47:18 -0400
Message-ID: <55BA5516.7040206@redhat.com>
References: <1431440068-19037-1-git-send-email-jsquyres@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QdhIk5etpD59k2BsR1hMOhR5o8D0OJ51I"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431440068-19037-1-git-send-email-jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QdhIk5etpD59k2BsR1hMOhR5o8D0OJ51I
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/12/2015 10:14 AM, Jeff Squyres wrote:
> It's not a warning or an error if libibverbs cannot find a userspace
> driver for kernel devices.  Indeed, returning a num_devices of is
> sufficient -- the middleware shouldn't be unconditionally printing out
> stderr message; let the upper layer application do that (if it wants
> to).
>=20
> For debugging purposes, if the environment variable IBV_SHOW_WARNINGS
> is set (to any value), warnings will be emitted to stderr if a
> corresponding userspace driver cannot be found for a kernel device.
>=20
> Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> ---
>  man/ibv_get_device_list.3 | 6 ++++++
>  src/init.c                | 2 +-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/man/ibv_get_device_list.3 b/man/ibv_get_device_list.3
> index 16cc1a0..96de554 100644
> --- a/man/ibv_get_device_list.3
> +++ b/man/ibv_get_device_list.3
> @@ -50,6 +50,12 @@ Client code should open all the devices it intends t=
o use with
>  Once it frees the array with
>  .B ibv_free_device_list()\fR,
>  it will be able to use only the open devices; pointers to unopened dev=
ices will no longer be valid.
> +.P
> +Setting the environment variable
> +.BR IBV_SHOW_WARNINGS
> +will cause warnings to be emitted to stderr if a kernel verbs device
> +is discovered, but no corresponding userspace driver can be found for
> +it.
>  .SH "SEE ALSO"
>  .BR ibv_fork_init (3),
>  .BR ibv_get_device_name (3),
> diff --git a/src/init.c b/src/init.c
> index d0e4b1c..dbdd795 100644
> --- a/src/init.c
> +++ b/src/init.c
> @@ -561,7 +561,7 @@ out:
>  		     next_dev =3D sysfs_dev ? sysfs_dev->next : NULL;
>  	     sysfs_dev;
>  	     sysfs_dev =3D next_dev, next_dev =3D sysfs_dev ? sysfs_dev->next=
 : NULL) {
> -		if (!sysfs_dev->have_driver) {
> +		if (!sysfs_dev->have_driver && getenv("IBV_SHOW_WARNINGS")) {
>  			fprintf(stderr, PFX "Warning: no userspace device-specific "
>  				"driver found for %s\n", sysfs_dev->sysfs_path);
>  			if (statically_linked)
>=20

This has been applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--QdhIk5etpD59k2BsR1hMOhR5o8D0OJ51I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVulUWAAoJELgmozMOVy/dWRQQALIjqh5/75t+XvvpcocV3bUd
cahcLL4vftgkWKiMiXbKDwUUbC+Lrwo1R7qxn3jgAFXNMfIcl0IxxQ581mJ+9Vfp
RJE5kmfuLbIVlAzZa83Lq4ZMpfn4LF5WhvC2IV0v3c8aHBf8uNGfYW/x19Vo80FQ
kGsMefySou49pEOIOwszpuj32gf1T+bD/jKOg6LtXepIPWZLkeHmtaT8iHbxgG11
k2irlqxgwQfkgwX+6AWK+wBfSLSUGr/i2+GvgQRsHINb1R3z2JX3A0tY1dJEBA96
KZQ1wOP4adOUHKYfBiDudsvR5jKH6l2QRWna/1mSK77Q46u/L+V2W3NPXV9gVvCA
iYIXSut+lSWcfs0V6epYc4yL7o1AFxkcNobvB88/m1KRw3lpO2kg65fPWCymA+RY
aoABFDZorEa1sFzfWwMbPzy3DYferWAg+c6bSWeozim09X9NLfnsoS/Di5fLvDVV
c/lkpvuSrgd8GEO79cbUST5Rah+FGQl3nAMVoZ1O3P5mm0akV8nXHEoBQYbz1Yrc
oIpjyzfPUOJlnqDwXF/xFDioj49pJ/hNnLMR3wPBSe/6wUYnRccAP5mLiTdu2QLB
PuG1ltZ0zsmxEWCb4IpGzrAJupPdFQEIKqZ20ThoJmnf98NCUMLg726SgBE30J30
1UopLSzuuT9vfLq7qgLh
=9iG/
-----END PGP SIGNATURE-----

--QdhIk5etpD59k2BsR1hMOhR5o8D0OJ51I--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
