From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rdma_rxe: Ensure rdma_rxe module init occurs at correct
 time
Date: Fri, 16 Sep 2016 14:06:01 -0400
Message-ID: <2fa6c4b3-6fcb-b0f1-adaf-94895710827d@redhat.com>
References: <1473975936-9970-1-git-send-email-sbates@raithlin.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2ncclWjq8m5rxw132kd4lgURhdhat26BO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473975936-9970-1-git-send-email-sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2ncclWjq8m5rxw132kd4lgURhdhat26BO
Content-Type: multipart/mixed; boundary="pEQjBtO6E57lbOEUbc4oKH117ABnKXouU";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <2fa6c4b3-6fcb-b0f1-adaf-94895710827d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rdma_rxe: Ensure rdma_rxe module init occurs at correct
 time
References: <1473975936-9970-1-git-send-email-sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1473975936-9970-1-git-send-email-sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>

--pEQjBtO6E57lbOEUbc4oKH117ABnKXouU
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/15/2016 5:45 PM, Stephen Bates wrote:
> When the Soft-RoCE module is built into the kernel there is a
> initialization issue when CONFIG_IPV6 is selected. Use late_initcall
> to ensure the rxe module is loaded later. This fix is based on one
> proposed by Logan Gunthorpe on a much older code base [1].

Your commit message doesn't make sense.  You start by saying that
soft-RoCE is compiled in, then say "the rxe module is loaded later".
Well, which is it?  I'm not sure exactly the problem you are fixing.
However, I know that the series Leon posted for the rxe driver included
a fix specifically for IPv6 tunnel creation issues that result in an
oops.  I suspect that patch might solve your problem.  So, I'm going to
drop this patch.  Once you get a chance to test with the other patch
applied, if your problem still exists, then please repost this patch
with a clearer commit message and we can add this as well.

> [1] https://github.com/sbates130272/qemu-minimal/blob/rdma/patches/\
>   0001-Changes-needed-to-use-rxe-compiled-into-the-kernel.patch
>=20
> Signed-off-by: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rx=
e/rxe.c
> index 08e09d9..97bc74a 100644
> --- a/drivers/infiniband/sw/rxe/rxe.c
> +++ b/drivers/infiniband/sw/rxe/rxe.c
> @@ -392,5 +392,5 @@ static void __exit rxe_module_exit(void)
>  	pr_info("rxe: unloaded\n");
>  }
> =20
> -module_init(rxe_module_init);
> +late_initcall(rxe_module_init);
>  module_exit(rxe_module_exit);
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--pEQjBtO6E57lbOEUbc4oKH117ABnKXouU--

--2ncclWjq8m5rxw132kd4lgURhdhat26BO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX3DSJAAoJELgmozMOVy/dq7kP/jBT89mau44jHpJPvISzdOWG
eRnXo5i6aYdvay3ZT9L541JebjSSrWYkl4ohjHo3Ah8f7Fai+C1pI/CTJI/moZNx
iGs6YdTKXbYJnWjE7UdYZELG9GlD/PObKxxZIWz0s74NowVJiHvZjqL+xR9GWu/z
UiSx3gIt4rxfFS+ZTa87PvWGyROrdJmVC7FGZLyJa7WXXi3GHmlQ6xBnaVR0GB9I
ZCyDYpH8zUfkDC1x0Zx7RwR7OYJ25uQ/GkoZtXTDz3hlGS1TjYkUwfbaA3gkeyI4
pOczM6afqxgWISEEUu2mEFEvyCrIbmcXPBQc2krUOOV2W6HCuFdvMpHgYVtgs0A3
maK0yjjQaHRYjbDpLW+ofUCN6BY1HmYSxTcnrMiLCSY1FdI6uz7Ok2UPrtbeGL/8
uHUlY7HM2zhnN0+aCoyAbOLdwGum+L0yPBuigXObcrqbABpFRLYn5ArvQ7/L7zRB
ZWokMPbHsgPVd78BUuh6SEPvV3d5cTQRc97tr4MhKWodqiVOVLuyE3exvmtlLzZ0
Vg5wO5WBiiRq9siCKeBKRtv/I8sMScnPj+MoVco5uLRMeQKCk8/D9fPinKf0AHG4
cb5F3FOf1qADvcP9CEWgBCUHl+NX7CLUlq5oll5Hp6KFUPACRkeYfXFXj3i4v9vo
Pl1xmq+3qDT0Uk4G4e6T
=jaKl
-----END PGP SIGNATURE-----

--2ncclWjq8m5rxw132kd4lgURhdhat26BO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
