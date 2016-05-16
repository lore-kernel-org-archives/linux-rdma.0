From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address resolution
 module into core
Date: Mon, 16 May 2016 11:09:44 -0400
Message-ID: <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hJlIVoQn0ObJAoxxpdQgmpvSqmjJlKwS8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR05MB1391AD099C536541E79A09F9D2760-79XLn2atqDP8GeyK7vyn2tqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hJlIVoQn0ObJAoxxpdQgmpvSqmjJlKwS8
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/15/2016 06:51 AM, Mark Bloch wrote:

>> But, just as importantly, after reading addr.c to see how it uses the =
ibnl
>> infrastructure, I don't even see what the original problem can be.
> As it stands today:
> - ibnl is part of ib_core.
> - ib_core needs ib_addr.
>=20
> So if we add ibnl usage to ib_addr it means ib_addr will need ib_core,
> which causes a dependency cycle.

Right, but in that case, this patch needs to be part of the series that
adds the ibnl support into the ib_addr functionality.  Because you split
them into separate series, this was a patch looking for a problem to
solve and it wasn't clear what it was.  If I had taken the other series
and not this series, it would have broken things.  So please keep
patches like this together with the other patches that depend on it.

That said, I also don't want to redo modules if we don't have to.  As my
previous email points out, changing modules breaks init scripts and
systemd unit files.  It is to be avoided when possible.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--hJlIVoQn0ObJAoxxpdQgmpvSqmjJlKwS8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXOeK4AAoJELgmozMOVy/dTzMP/3j2zPuRy6NFyCyc5YyVcbkJ
X1h+calpOiod4TY7QBMAWspPar1TqnBLs4ZWlH6cOQ5pO3FKeCef4w0mj7KGwMIL
1I7Ldkdd3SYpt2mQnpq0wCRrEGYX4vjTLIDuEaUG2Dx9oB1Qz1tAhsK6b5mHNCUz
oWpSKlC206fDv2cuuz8eApt6UsqqMXfwzeKxGWEHJ5kwevsbVJK8aPuSS2p4B0iJ
j7OU6n8VP30n5yesmsGqzY3qvH+mKeJHgtdaqyTpXGBO7u3XRrLqodMLDLyDHXH+
h9rbPPOHkZiYjJDoH9iAOC2/0HXgpbwbPX0dy2qQ6fa77cFYbsKIPQp+RXbrgC++
N80K/L34UGQHph2u48GbDR0QjycbxeI388rt5jDJ2X9pOukTBbl9LBnCRcET+VIU
pnKHLXx6W1DzOJALedrl103UuiJEeEwSIeh3YU8xlrZnd4Y97kZzJLbCUeQqZMXz
jscRE3M+v7ithc8zYEWAhWVZLnzmyWnDa7wlRMHtbnnN6mKTlQ+f5e+b1/F4hq6Q
MMw7BM60EtX2AFm/00tyuEy5x++YvIy1fIsdHh3NZidMaZ53+axjE2a+Xx/ONfcX
qIT2LNEEHDtl2O4M084gvi5tcYoo98biE5FpJ/D4AKba4YnxRRYP2gaKmbALStOy
37DPr4Pc98RCmDA/obLS
=VWjY
-----END PGP SIGNATURE-----

--hJlIVoQn0ObJAoxxpdQgmpvSqmjJlKwS8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
