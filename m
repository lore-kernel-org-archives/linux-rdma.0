From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/IPoIB: Fix kernel panic on multicast flow
Date: Tue, 19 Jan 2016 13:03:24 -0500
Message-ID: <569E7A6C.5040004@redhat.com>
References: <1452151688-7695-1-git-send-email-erezsh@mellanox.com>
 <alpine.DEB.2.20.1601071002220.28791@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ULLeAa121xrVuMO0eOKbHEPeQp8jWVhrA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1601071002220.28791-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ULLeAa121xrVuMO0eOKbHEPeQp8jWVhrA
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/07/2016 11:03 AM, Christoph Lameter wrote:
> On Thu, 7 Jan 2016, Erez Shitrit wrote:
>=20
>> ipoib_mcast_restart_task calls ipoib_mcast_remove_list with the
>> parameter mcast->dev. That mcast is a temporary (used as an iterator)
>> variable that may be uninitialized.
>> There is no need to send the variable dev to the function, as each mca=
st
>> has its dev as a member in the mcast struct.
>=20
> Reviewed-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--ULLeAa121xrVuMO0eOKbHEPeQp8jWVhrA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnnpsAAoJELgmozMOVy/dpqQP/2rz+ZcjS9KML5bab6qBLSjG
XTwcO9nAX2hSllK+xtmiyo0Q8oLzY175+DvSxFapFxYjmeCuQY41bg0B2d9O5l/q
mfbM48zoP89NCht0XIzDq0mUSUNhu3KERg7f0fPcaosRxjG/jl6QXaiSf9eDxcpD
QICDVZuoEDSSj3FfnNE5evnZBKvf1Evwuazp3KsC1yZ9XLEpeEaHug5fnomhhkzI
dkgobEOmsHYxFWm7g10M9rfYMhhdFFYgVwiFfDHtmaLhwJ6oKbAbxmuvONulcNJi
YS6cEHG0q2ZseZBSZiZW6oIfL+OVEnjA5aKV7GfP5zsVPQZMmU5d19qn1HhiNHUY
vQOz4ys4WCVNlx5EPngDXmDiS7WZT8iyMFgbATBLXWbWH6wSxwdhtNhAM9p8jFi7
UD8z/TKbUGDM32b93EPr8GTDD+sLOYdQyPgoSN4Q+LnPL2o2z67m6pkwJmPfxG39
pDSeIzt51Gk2tVkZEtNFSiQbBln9BAEq7JijsEPlfDhjjGJp6eFiIsbI1GkjCS5x
8qzMsKfcdkqbbYV6TypR/6yEFK0SdU06p+6rvtWwBqHk90Qr8KMHsq1Q/ARVDt8T
bkpGux3HnMtuBZeskaWaWevrIh++szEvDc2OPGzOKJOGOCq1MWq6aOwqcHp6e0xA
UEaafoeJ+TwnCdSiQ+T8
=3Odk
-----END PGP SIGNATURE-----

--ULLeAa121xrVuMO0eOKbHEPeQp8jWVhrA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
