From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Fix double free of allocated_buffer
Date: Wed, 24 Aug 2016 11:34:20 -0400
Message-ID: <86944d68-f07e-bf63-663b-aa88b05ecba4@redhat.com>
References: <1471989013-70432-1-git-send-email-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TJiT6H6wVT7vWgohrGvtt1rrG9rifEdNJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471989013-70432-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TJiT6H6wVT7vWgohrGvtt1rrG9rifEdNJ
Content-Type: multipart/mixed; boundary="rw3TK5Q7QiFCwIjGixvmlrFPRXUoDnphk"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
 Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <86944d68-f07e-bf63-663b-aa88b05ecba4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Fix double free of allocated_buffer
References: <1471989013-70432-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1471989013-70432-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--rw3TK5Q7QiFCwIjGixvmlrFPRXUoDnphk
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/23/2016 5:50 PM, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Memory allocated for iwqp; iwqp->allocated_buffer is freed twice in
> the create_qp error path. Correct this by having it freed only once in
> i40iw_free_qp_resources().
>=20
> Fixes: d37498417947 ("i40iw: add files for iwarp interface")
>=20
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--rw3TK5Q7QiFCwIjGixvmlrFPRXUoDnphk--

--TJiT6H6wVT7vWgohrGvtt1rrG9rifEdNJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvb58AAoJELgmozMOVy/dXMwQALgpRcEJ9SN7RQkZTZvxd7N1
ywMV+Vop/brFxrq6aT5S7BF7enoyFMWuG2DFK8s4vch9GSvK5JQKbcum+6eH4I6J
3GBjTX+d6Q7BfuQ1EoFcNNxPFy/TTl1b2T8S6ri9t6rHPgoqadJLQ++nas4v3t1u
irjbqfgbxxmbJQ7wloMsOuPu1Aug8arxRW6QxfvMiniIoENZETmyzzKtyMyOjNWG
ez5cU9ieQ8ff7zpvEbpDAer4rLqC6znIbwwbopBZz1QydvL8j8V5FErnzA7yCAx8
KRmMTyKQVAuegllNDMB6++G1Y3kg97/BdeFlYuSlXMHQ+Z3SImM/wBL/5sWei5Bc
qu+3TRrcBmrnupV2i6BOSNbk6ELCWI5/ODDTUdgwikwMOh+m6XtZM0QRlzLyHXyS
9H++0smTCAtyBKXWQLiXvLg536RKiVBd4a5kt2gqi0lDSEthQOw4aPKQIZAr1j13
kMGQ/nW6eBUVS3RClAE1dhP+jBZQRJ9aloaIktJB8h6qkyD9uqEELnByTlPi2VMi
WTQ2OXEHha/shcbkOFfGaxB59jLMJEZoaxezn4dBzoGIXFQSxwtErdQvCjy8I4K8
rwVprDy9ToU6GpJ/KVd/XunfiVu1lYf7ilnZN7ma7RqycF5oYi0BJc8REIhtXFdI
6dxjMLgUCPwUD+wNtaRJ
=Agwc
-----END PGP SIGNATURE-----

--TJiT6H6wVT7vWgohrGvtt1rrG9rifEdNJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
