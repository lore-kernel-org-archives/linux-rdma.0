From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] iw_cxgb4: call dev_put() on l2t allocation failure
Date: Fri, 2 Sep 2016 10:09:06 -0400
Message-ID: <05141088-7c92-daba-1e0b-da1bc5656a75@redhat.com>
References: <c1b639ca7d71ee034e334b4400ff0bae3ba58c47.1472241953.git.swise@opengridcomputing.com>
 <01bf01d2022b$0fc39190$2f4ab4b0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="A6SAmRKN7CXxeNoI8kdTFmlXDjOELL0nC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <01bf01d2022b$0fc39190$2f4ab4b0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A6SAmRKN7CXxeNoI8kdTFmlXDjOELL0nC
Content-Type: multipart/mixed; boundary="CHEsvvlT48UsKsTsTqaX4Kq1D925pn3cd";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <05141088-7c92-daba-1e0b-da1bc5656a75-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] iw_cxgb4: call dev_put() on l2t allocation failure
References: <c1b639ca7d71ee034e334b4400ff0bae3ba58c47.1472241953.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
 <01bf01d2022b$0fc39190$2f4ab4b0$@opengridcomputing.com>
In-Reply-To: <01bf01d2022b$0fc39190$2f4ab4b0$@opengridcomputing.com>

--CHEsvvlT48UsKsTsTqaX4Kq1D925pn3cd
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/29/2016 3:25 PM, Steve Wise wrote:
> Hey Doug, I was hoping these two could make 4.8-rc.  Particularly patch=
 2/2.
>=20
> Steve.
>=20
>=20

Hi Steve,

You've submitted these both individually and as part of a larger nvme
patchset.  You should know that I generally ignore nvme patch sets (I
have enough stuff to review), I just happened to catch it this time.
Submitting these both ways is likely to cause problems down the road,
including getting me yelled at by Linus when the same patches come from
two different places.  Please try to avoid that.

Now, in regards to these two patches, how are you wanting to proceed?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--CHEsvvlT48UsKsTsTqaX4Kq1D925pn3cd--

--A6SAmRKN7CXxeNoI8kdTFmlXDjOELL0nC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXyYgCAAoJELgmozMOVy/d/skP/A0FGSsHRmCsgx2XD8FtgxPh
EmM1PTkqB39OmrtwqxCiPKaJZRa1ChkLKR8R1mfvL+UJh9PlT7RE94xc8g+wr0oJ
P5q/s4VxnzOmkbJHeOJ2dtnwxUhQPIARM3UgcagFF3sxYbGaXz3KOm6k8Nf8fVfK
zZMJVm3sd6cRaDtgeHBrQ7z0uch7ZpXumTv1coFh8Vl/qvQJu96ONHBDxZUqC8OR
/ZagAkvIwlQ4tVkLED6uBGEKKGH1ToeDYs8n/b4saEu7m2C1VZjrgB+8KWrQTWKi
KURh7ACzFgylgU8xUCyNFQOY4KkUK4VWGcNw0PkpwcRp9gO6Kc3YeOWe61ZDD4I4
z2Gv44/oYOYBgCSAhqyYMyuD0FRr/lsf6JXS9z7Xf/3Pv+0XU6+bDKR/i9ItIeQG
2S6/GxwoLzuynOqCWe92VMwio5L425LlpZwlMjpfCvAE8YLdclFMcekamg4gLrWc
gSvNsYwHIg9v5daGSNCpWjZ6gYqBUwhm50DTomw0PcVbEgjPNzpCm0AhVyWx8mQq
MHg43NhmVCJNXnMB9iEQhSCxQZlE6vO4+iF44v1JDxFiwoW8LgfOTyB2tNMKJyL1
2h/s+xb2MFct67kbxIm7rXqHiQryMMbgitLWUerlbeVyPuB9A4wL5vcm2i4WE0QS
SsVNb9TkrpC1ubj16U8G
=8MlS
-----END PGP SIGNATURE-----

--A6SAmRKN7CXxeNoI8kdTFmlXDjOELL0nC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
