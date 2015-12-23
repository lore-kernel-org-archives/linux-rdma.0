From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V3 00/11] Add RoCE v2 support
Date: Wed, 23 Dec 2015 10:51:59 -0500
Message-ID: <567AC31F.4040504@redhat.com>
References: <1450875417-19262-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2mJ9Cj4V3IW7gcUFKJR41q8ndlRMR38qH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450875417-19262-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2mJ9Cj4V3IW7gcUFKJR41q8ndlRMR38qH
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/23/2015 07:56 AM, Matan Barak wrote:
> Hi Doug,
>=20
> This series adds the support for RoCE v2. In order to support RoCE v2,
> we add gid_type attribute to every GID. When the RoCE GID management
> populates the GID table, it duplicates each GID with all supported type=
s.
> This gives the user the ability to communicate over each supported
> type.

Thanks for rebasing Matan.  Applied for 4.5.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--2mJ9Cj4V3IW7gcUFKJR41q8ndlRMR38qH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWesMfAAoJELgmozMOVy/dYAEP/jqgThbEJXUClbnnRN0hfuB2
0AFuwaNmnQBGEdv9gLuqtZqyr9BXavUZWb+aN9aUFtIOGfSv+dZeUQ1OlIX8Menj
xJztDjQhWwvhayrFo5g2wS5x4CQo8lfiyqTQEVfC0KO/mIHGHEVMiHZ3SIpoa5qW
UU54TJii16EynprRLk0gxCy1McrtOwQufFlsDcl887JoniCDOBffLEhYj8K+Yy09
ZJYHP5fdrIxWgeqlMVBQRMi8u9ymdwkkXvj2WDaSFt+55sllPyESUiodXFlN5SB0
Ybu0U5qjutWSQKHpqNElI1s40AKkYIJGbPNE5prIDZjvZY8n2oE5Zus5f5EXJB76
oKiha1M8hgfyHGj1qeTeiCuhAvXcLRSY9vxPpxI4lHanPBKhL8jqTppLZihKLMK/
mlbjuGLE1Fi7zPIhZbTUfEA+BgMvm+yL9DraTJkzWIJBux3Kj+kkRvJiGsSgUquw
R3uW9mLKDMdaUySBCtbAuNAUrz16qn4YkNJ1VzdjsgPZEVw28RerqzM++k0kpSJH
W2Ln9zy9S7jBEK56FdVsD/H1v/XZsGEgBkNxlSqDIe6Xcu6iEuUA3nPknbIqdOhl
cse+UZ/NHfm3R9Q3txgZqYbXWGCYN7BnH4gjeSC/ZOEoQOH6EdjKPDfh9lyotMw0
upzKaPXqfrKRh+btDX9k
=Hozq
-----END PGP SIGNATURE-----

--2mJ9Cj4V3IW7gcUFKJR41q8ndlRMR38qH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
