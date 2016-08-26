From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Receive notification events correctly
Date: Fri, 26 Aug 2016 10:02:30 -0400
Message-ID: <6309eec2-6bb2-a0f3-ec0d-1d6c68359bf4@redhat.com>
References: <1472144004-66528-1-git-send-email-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hJ10Hlm5vGeBKWXF7Uj2nOxL0qwThMS2d"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472144004-66528-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hJ10Hlm5vGeBKWXF7Uj2nOxL0qwThMS2d
Content-Type: multipart/mixed; boundary="k9UtjHdGm5pkxN3Be4S5XHID7Bqrnia1V"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
 sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Message-ID: <6309eec2-6bb2-a0f3-ec0d-1d6c68359bf4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Receive notification events correctly
References: <1472144004-66528-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1472144004-66528-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--k9UtjHdGm5pkxN3Be4S5XHID7Bqrnia1V
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/25/2016 12:53 PM, Shiraz Saleem wrote:
> Device notifications are not received after the first interface is
> closed; since there is an unregister for notifications on every
> interface close. Correct this by unregistering for device
> notifications only when the last interface is closed. Also, make
> all operations on the i40iw_notifiers_registered atomic as it
> can be read/modified concurrently.
>=20
> Fixes: 8e06af711bf2 ("i40iw: add main, hdr, status")
>=20
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Applied, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--k9UtjHdGm5pkxN3Be4S5XHID7Bqrnia1V--

--hJ10Hlm5vGeBKWXF7Uj2nOxL0qwThMS2d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXwEv2AAoJELgmozMOVy/dE8QP/iOF8ZCeSylBkPouUJdIhJPF
WryO0uo2Lue0Y2CziSdz6Nl+0aUN5WYmP6xYYcpBVZfe68aItDVy8+5r24kM4mRz
UaGtwsOjnvCgjO/nMxw35F8DOeD9Fzt/Gn36gJ2EzuDossUZeAWZhMh6C4Y7aBxs
YgiZmThLl+1taLNFarTg9kQjp2Jfo+d9zeQpEGp1bwO6I10jHRmsCSW3IzcyjWal
+QaR7i4wEI8D7VFxJKEpu+W9bfW4+ARaKSb1RDptus4j6aCY9Ufi1XbiyW9yvMdG
wT36PH+GeTg36Kq8yuAHsXGp7HC94T4s+VtS5xVVh1d7u67l24gdyJOygOoFFdeh
qpdlxD558gtpyr9pOas8fEju3/9W/u/AUNmrKPAEa2Y7dRHhPz/z7dOqY7xtP81W
6gCAdCrxcUtyzHDS0vBO8rKnmVD77QUR0WVC/VRqHHLhbJIbhJxJlWZ2cQfJLgCr
t2oeMoK2VO7AXdFEgCnZr5msp5Vg1H8gt2HeW5CRGppaElfwEUJQgBvwhKlOdLK4
fxgz/Eka57vJFPEbq9TSAFj6SNnoSo1MxLEy03xX0CSnVXYZGYnco9MZjCc43FXl
CfKNrWF4WPKDGJ/8PnnN+IbvRKazIPVT2z7X4EFM6McFMwKhs90Ff6ZFPHTn0ohL
KlvUZ15flX9ZZHyGb3t+
=Vc+I
-----END PGP SIGNATURE-----

--hJ10Hlm5vGeBKWXF7Uj2nOxL0qwThMS2d--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
