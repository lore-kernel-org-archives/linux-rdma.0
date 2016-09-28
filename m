From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/13] srp_daemon: Add the debian initscripts as an option
Date: Wed, 28 Sep 2016 14:27:01 -0400
Message-ID: <57EC0B75.3000101@redhat.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474658228-5390-12-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="AK1g46IUHSBkUUi44gaNvcUA4P1r5saaM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474658228-5390-12-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AK1g46IUHSBkUUi44gaNvcUA4P1r5saaM
Content-Type: multipart/mixed; boundary="tevNpGx5iljBhk2f2SjS7nWqC6mVs6ltk";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Message-ID: <57EC0B75.3000101-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/13] srp_daemon: Add the debian initscripts as an option
References: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1474658228-5390-12-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <1474658228-5390-12-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--tevNpGx5iljBhk2f2SjS7nWqC6mVs6ltk
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/23/16 3:17 PM, Jason Gunthorpe wrote:
> Necessary to reproduce the Debian packaging.
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  CMakeLists.txt                       |  3 ++
>  srp_daemon/srp_daemon/CMakeLists.txt | 29 ++++++++----
>  srp_daemon/srptools.default          | 14 ++++++
>  srp_daemon/srptools.init             | 89 ++++++++++++++++++++++++++++=
++++++++

Would it be best to have directories for related install files for a
specific OS?  For instance, srp_daemon/debian/ and srp_daemon/redhat/?
It's not that I expect to put a redhat init script for srpd in place,
but the script for debian is likely to not work properly on redhat, so
having it in an OS directory would at least make that clear.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>    GPG Key ID: 0E572FDD
  Red Hat, Inc.
  100 E. Davie St
  Raleigh, NC 27601 USA


--tevNpGx5iljBhk2f2SjS7nWqC6mVs6ltk--

--AK1g46IUHSBkUUi44gaNvcUA4P1r5saaM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJX7At1AAoJELgmozMOVy/dr9EP/0GjXlmZ+z5o/A1vuZqjiB6b
fzGriEzrjjbFqcDM3ySDBkbOA4gUbCac9irJf2bezabfft4Lmj2QaEgZ1fKRyS2Y
a5WFyTYI0Dg0Ug2fzz11/Imq5FtQIJk7l6ZmIUYQuXoM98pP2FZSH5M+4f0ziOQp
A3lg80WxWazXmMOZFOAqLn0oED5vfgbQXHOMyB++4G+KTCm1oKIgahZJhrNVeCVp
cUA4mu6kPa7UXnN98aZUR+Ox6B+rYsql+LiuWD/dnI+C8t/odGiYQML2id7tlu39
6C2g+SwuPvM+Fy8a+wiqUW1EePJ/KvaAjc6iOdEbYJgrOqTWYyzyJ6z4Jqgc+/+3
7HXIbj8E6Lm53y6ZJqFZFdFbKP5hUu2quwf9GAcHWeTAKezsW2isZmMN8Ja0gFeh
P90MnU7lvxxtEISh6zguD+u+L8mWnm3fLzhfM3C8wNR0hlDcCS2oA4EEAPAZVT5u
Dyo4cU4Q2iZvkOnaDziUlhHtjisAAULzMeKavy8Pzs4JltkeqiZylOD+bqUoW27T
Mr5uZWuI8qOphYKjGUfdPEMLSvJKRH/6K5N/LZLDDVBntVP+exZhrN/mwod09RdB
P7vqkBI7JnEJ1R8yHeZbuN/FFnSKfbSN3uO9NPw2M3ALobcTnF4y3/zjFL6/mHXC
ItHu8zWabP9p9hpp+OxU
=5cO0
-----END PGP SIGNATURE-----

--AK1g46IUHSBkUUi44gaNvcUA4P1r5saaM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
