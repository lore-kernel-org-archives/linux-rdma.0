From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/9] Dead Code Removal
Date: Sun, 2 Oct 2016 08:58:39 -0400
Message-ID: <eb3a5c2e-58de-c5c5-9fbc-31fea4bd8b57@redhat.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0Nn0lSRvBfnoi3H46AeUKhJDdLJa3KSE5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475182076-5411-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0Nn0lSRvBfnoi3H46AeUKhJDdLJa3KSE5
Content-Type: multipart/mixed; boundary="SpC6R05XMjc7TwFg9wU5dg432khivMWgS";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <eb3a5c2e-58de-c5c5-9fbc-31fea4bd8b57-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/9] Dead Code Removal
References: <1475182076-5411-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <1475182076-5411-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--SpC6R05XMjc7TwFg9wU5dg432khivMWgS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/29/2016 4:47 PM, Jason Gunthorpe wrote:
> This removes various #ifdef type stuff that no longer makes any sense.
> cmake is arranged in a way that avoids alot of the ifdefs around header=
 files.
>=20
> The BYTE_ORDER patch is more substantial and consolidates everything ar=
ound
> glibc's endian.h
>=20
> See
>=20
> https://github.com/linux-rdma/rdma-core/pull/10
>=20
> Jason Gunthorpe (9):
>   Remove HAVE_CONFIG_H
>   Remove HAVE_VALGRIND_MEMCHECK_H/INCLUDE_VALGRIND
>   Remove HAVE_IBV_*
>   Do not use IBV_CMD_(REG_MR|RESIZE_CQ)_HAS_RESP_PARAMS
>   Remove HAVE_SYMVER_SUPPORT
>   Remove old compat definitions of wmb/rmb/etc
>   Remove old MADV_DONTFORK/DOFORK compat
>   Remove most checks of __BYTE_ORDER
>   nes: Remove code guarded by HAVE_DECL_IBV_QPT_RAW_ETH

Thanks, series applied.  Jason, you hadn't pushed your updated comments
regarding the t4.h file and PCI byte swapping, so that will need to be
updated when you get comments back about what the mlx drivers do in
regard to this.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--SpC6R05XMjc7TwFg9wU5dg432khivMWgS--

--0Nn0lSRvBfnoi3H46AeUKhJDdLJa3KSE5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8QSFAAoJELgmozMOVy/dU8wP/1KkEP/U5Gezu1UGhEHRvTMN
Qh11cAOmvzb7QGa6vS5Tr7S20b6UCvrZcSxCE/ZtzwjZlxxi41/XZwRl4XTYXzLA
BTrVyPC6ulWvU3YTtxUktlFpm0YWd85utqNCVmhoMvcr849wwx6bLul+FYXFmqgt
O97CoWmXbP1T7Hx8TF1bVTIgIfASGOM5BiVju8/NsJHFy6GnM/xMKrXaGHC8m1qe
kF3FMy5UWzfxXTugS4w0ZNR9OaUfWGokpWiG7fQtzASayWwxE9jLAgxx1V+B3jB6
hvj+DJaTIREKMwPGp5RJw7t2BUEEnd7qx3513fGqQGQxFFs6J8YgUbP9XBZfWJC5
ooMKOJAwbz0TRpIVqW9HFvfLV5+FLC3xAcI1CprOMctJaU+0zLS6wMdPgyeQ35TY
setKFhVgue4676a+6QMotke5pdDwzL60RSEJWdo8lbVmnffhzSIJu/JZrX6sNcdT
Oycb8qkOwl5cNbQKARS1IPFACbbe36Jjboo0NHpcPmHF6SGHaRJ1Aes6Zp30NAoo
MmxTb2nwZl1Bx4Xy6RgmOxMwW+5Xcx8oS4DhqxJKE4F4rXSnFY4CCT/+TTpzGbu5
3pzZjZcHfFSlvcBJFOG/GVlJ/CmvnB9ncq8HLMNlKnjNPclC/2PM/+w+M6SxRDgg
D2p5phoQMwdgM2hhrGJq
=ycwE
-----END PGP SIGNATURE-----

--0Nn0lSRvBfnoi3H46AeUKhJDdLJa3KSE5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
