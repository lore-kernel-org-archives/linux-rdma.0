From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs] Allow use of huge pages in multiple calls to
 ibv_fork_init
Date: Wed, 2 Mar 2016 21:44:38 -0500
Message-ID: <56D7A516.5090707@redhat.com>
References: <1454499762-29819-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mB2tqDkLfmIXxgAbDiSIlvhgIG0dJAB1K"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454499762-29819-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mB2tqDkLfmIXxgAbDiSIlvhgIG0dJAB1K
Content-Type: multipart/mixed; boundary="Ah6FcPbwXU4Acnd9aFrtgBqiX6xufGs9E"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <56D7A516.5090707-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs] Allow use of huge pages in multiple calls to
 ibv_fork_init
References: <1454499762-29819-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <1454499762-29819-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>

--Ah6FcPbwXU4Acnd9aFrtgBqiX6xufGs9E
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2/3/2016 6:42 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Setting the environment variable RDMAV_HUGEPAGES_SAFE tells the library=

> to check the underlying page size used by the kernel for memory regions=
=2E
> This is required if an application uses huge pages either directly or
> indirectly via a library such as libhugetlbfs.
>=20
> The check of this variable was performed at the first call to
> ibv_fork_init. This caused to unpredicted behavior in complex
> applications with multiple underlying libraries.
>=20
> The proposed change will allow support of huge pages without relying on=

> ibv_fork_init calls order.

Thanks, applied.

> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  src/memory.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>=20
> diff --git a/src/memory.c b/src/memory.c
> index e9d1eecd9eab..89509c6e356f 100644
> --- a/src/memory.c
> +++ b/src/memory.c
> @@ -140,6 +140,9 @@ int ibv_fork_init(void)
>  	int ret;
>  	unsigned long size;
> =20
> +	if (getenv("RDMAV_HUGEPAGES_SAFE"))
> +		huge_page_enabled =3D 1;
> +
>  	if (mm_root)
>  		return 0;
> =20
> @@ -153,11 +156,6 @@ int ibv_fork_init(void)
>  	if (posix_memalign(&tmp, page_size, page_size))
>  		return ENOMEM;
> =20
> -	if (getenv("RDMAV_HUGEPAGES_SAFE"))
> -		huge_page_enabled =3D 1;
> -	else
> -		huge_page_enabled =3D 0;
> -
>  	if (huge_page_enabled) {
>  		size =3D get_page_size(tmp);
>  		tmp_aligned =3D (void *) ((uintptr_t) tmp & ~(size - 1));
>=20



--Ah6FcPbwXU4Acnd9aFrtgBqiX6xufGs9E--

--mB2tqDkLfmIXxgAbDiSIlvhgIG0dJAB1K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW16UWAAoJELgmozMOVy/dy5gQALldMzY55kUbqUIYZ1kA8VGy
dCeJD2L4hC2EaEHVaj8iC/qX6SLzjL5wL0WwiPMGGS4rzGIaqwAt8FWXdfr/DcwY
7F5dOdWsv+x9mj6BgyufCbbq5G99OABipKjQe5YSGgdmf35X7SMo+t3WpVWHqJ2j
YrF28bZvzdfyUzC+rhLkSMVQoiFj5qfFlIHE6qKekdLsDI/8vgE3GNJpxkC6O97i
EiqpRorjd4B44b5u+HiA4WsYQxL9kCCgA6q7YL6ASjl4KHzYbp4ZFElBVgkrsqAl
79i0RVrghjUVV2CmI+/AibOzEkSIGexBvKexJPhxlbPWHrLdd+7MdQ7nUzpKwyDc
het/p+XTCLWWtVb4ALLaXoQ9mxoJStXACg8+NLYXogZHuV/rjjxa54NPOfOndaAn
nmzG9ZA4MBgENgLvDsxHXOWn2w6fOkBTQThmgkQMeIFoqfXI3vhG147GAH+pP8Hr
JtKwqcWDGpyQGYh1aZbUMPMIIMM14lvz9Dx8NqRrlRHiWCYXMd09Aeib6X46pB8a
hoZlhGBE6vCFecLY8JuY6hh3ZGFlBoKUL7lS0h1cDs6nj2BEY1FKQCyykVaLLqCn
mG8ic+2dCr2wz8E3x4e79FZ9RkbEKZvRYuj35XswEXOTlKW+z8V2fs43eiLNhzwu
syWxuNc6f1t2VASLL4fO
=yOYg
-----END PGP SIGNATURE-----

--mB2tqDkLfmIXxgAbDiSIlvhgIG0dJAB1K--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
