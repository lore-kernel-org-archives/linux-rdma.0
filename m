From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] iw_cxgb4: use wildcard mapping for getting remote
 addr info
Date: Mon, 11 May 2015 17:06:47 -0400
Message-ID: <1431378407.2407.527.camel@redhat.com>
References: <20150507213423.30446.25092.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-JA8Zf8GMt8zdnfxroNy7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150507213423.30446.25092.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-JA8Zf8GMt8zdnfxroNy7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-07 at 16:34 -0500, Steve Wise wrote:
> For listening endpoints bound to the wildcard address, we need to pass
> the wildcard address mapping to iwpm_get_remote_info() instead of the
> mapped address of the new child connection.
>=20
> Without this fix, and with iwarp port mapping enabled, each iw_cxgb4
> connection that is spawned from a listening endpoint bound to the wildcar=
d
> address, will generate an annoying dmesg entry about failing to find
> the remote address mapping info, and the connection state displayed in
> debugfs under /sys/kernel/debug/iw_cxgb4/<pci-slot-no>/eps  will not have
> the peer's address/port mapping info.  The connection still works though.
>=20
> Fixes: 5b6b8fe ("RDMA/cxgb4: Report the actual address of the remote conn=
ecting peer")
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>=20
> ---
>=20
> This should be included in 4.1-rc which is where 5b6b8fe was introduced.

Applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-JA8Zf8GMt8zdnfxroNy7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVURnnAAoJELgmozMOVy/dZIEQAMPwlWu6ORUkGtja1+7gIL0p
9MS7GbdyRFLe1aHkJ74EuRl1ilqmn7xUQSFKEXSL4luTyrChaRKHUgNv1xDOIyCA
oxPEkYa6PoF2nO8e880UY5Bp1b2y95SPK0iGXdSiancBK85HGH+crleN2Gd0OLLz
5BnJIk4HjQ/9UhE7dy2jEHn8J38Q+B+yz6dE84GdQAvdkesIyepm0XJcmy5+rFEJ
VNedg+3uoZLvjJmbdzbtC8BPfCsMMWX11di4vHwUp3KLGMDi5ubQBLNucRxXuPLe
zIQBBzpK6LjGflroJSkKnVWEDlwGeojrcg5ARY8u7qi6hoHfkZ1UN+PzyV682TO4
bzWjy0HHT+MLQ/euY2acQVNzI+9HEiEhpGoyuRPPjE17d+yAGpeGbnnzOq7AVJuB
KjpguCWPbCBAvPaGMTh+szeRHq0ala1n1mVaV5tt/Nh23QC2zP/A1xOgt5B/Xelo
PCEGqSHt8EfqztAr0HXpyEs3QA7yvO02Ipls5DmKsrZJkV3CT2so30sA+0WrO1RP
N/4BoyVg/h7/Y1ir0jFOTDRbn5MR4b5+YP6QX4ekQirveP6t7AI9PRWOTIInOfHH
UMnBS9q6/h8JYztQx+ggZ1KfZe7YguaHnygHqoOyIYEfac5WWqQNBWHjRpSpNtCO
DXs083McQxEfsfq0n90v
=z9we
-----END PGP SIGNATURE-----

--=-JA8Zf8GMt8zdnfxroNy7--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
