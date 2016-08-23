From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Change mem_resources pointer to a u8
Date: Tue, 23 Aug 2016 12:45:01 -0400
Message-ID: <1575a38c-23a3-2ef1-64fe-b2b94bb78757@redhat.com>
References: <1471907354-82408-1-git-send-email-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TbxWU5rWKCoUiDAt4kixou5KacjEfFIjr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471907354-82408-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TbxWU5rWKCoUiDAt4kixou5KacjEfFIjr
Content-Type: multipart/mixed; boundary="G8DpEuE16pD3hEqEgR10MVgCkQ9PRVVDG"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Message-ID: <1575a38c-23a3-2ef1-64fe-b2b94bb78757-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Change mem_resources pointer to a u8
References: <1471907354-82408-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1471907354-82408-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--G8DpEuE16pD3hEqEgR10MVgCkQ9PRVVDG
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/22/2016 7:09 PM, Shiraz Saleem wrote:
> iwdev->mem_resources is incorrectly defined as an unsigned
> long instead of u8. As a result, the offset into the dynamic
> allocated structures in i40iw_initialize_hw_resources() is
> incorrectly calculated and would lead to writing of memory
> regions outside of the allocated buffer.
>=20
> Fixes: 8e06af711bf2 ("i40iw: add main, hdr, status")
>=20
> Reported-by: Stefan Assmann <sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Applied, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--G8DpEuE16pD3hEqEgR10MVgCkQ9PRVVDG--

--TbxWU5rWKCoUiDAt4kixou5KacjEfFIjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvH2NAAoJELgmozMOVy/dpYkQAJncQlzSzgCTrWQanSKhcPzg
gKW0Y2ucL5/zVkDeY4kREfz/k4igTV7Aus464GevYawBR9LP1QV8t9j3OM9mzkfk
RM2Sk1uAkyRRayON6uLUy4JY9ywgrEABkW3cKHPsXLMR8kbjP2BxzY93hyfZjO5t
lKh3X52Zn/gnq0qO1R0Bc3j+B5wP2ANI/Ia9HwIiOZuaVhkmdzxJjeDcdkzQPesj
tG4O2D9PH2+P/BlDLn8LJJKlD5e+7Yay72B6BV8kN7oXsA4sXf0rjRbc6wJ0ZDth
+R8wUVQUI4fZPUByGMUJ63VlDWd6LTleyfAv+eSVYmp8x0YUY1ejiQ2BA3yNKeRL
bKDYAI/vJt64sMIlPgFRndBUu0uA4FRiwxG8Dl27eLErPINobkKyV3YZK56wf6VK
Q56Eky/3nO2pCAS8qZunfPNawRT0xNibMOCTPcNeNhmbRPMFPGq4kb2DPvlEMquV
UBJrc9YMMNfaCbHbcqpc/ju/zJafzP4Iu6CER8uKJUIt6EFuWDVW6WR8TCAA0UlP
gQV7GCHYbegzk/0RGgIOmStmd/uERuzDAR61e+NC85V4WbJG04WksJqcirkaDRVG
h5FWzx1VPWYwhKKIA827Qvbqb2EULKkvpewKzyhfouujvOzvLCsouSeBhjVvnIFU
ATm2KVRLVjXM2P86HQYV
=DyEd
-----END PGP SIGNATURE-----

--TbxWU5rWKCoUiDAt4kixou5KacjEfFIjr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
