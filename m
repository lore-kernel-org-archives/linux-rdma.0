From: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [patch v2 00/37] add rxe (soft RoCE)
Date: Wed, 05 Sep 2012 12:36:08 +0200
Message-ID: <50472B18.4050306@samba.org>
References: <20110724194300.421253331@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEAB3FBA4A4F597D711A4BD3E"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724194300.421253331-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEAB3FBA4A4F597D711A4BD3E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Bob,

Am 24.07.2011 21:43, schrieb
rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org:
> Changes in v2 include:
>=20
> 	- Updated to Roland's tree as of 7/24/2011
>=20
> 	- Moved the crc32 algorithm into a patch (slice-by-8-for_crc32.c.diff)=

> 	  that goes into the mainline kernel. It has been submitted upstream
> 	  but is also included in here since it is required to build the drive=
r.
>=20
> 	- renamed rxe_sb8.c rxe_icrc.c since that is all it now does.
>=20
> 	- Cleaned up warnings from checkpatch, C=3D2 and __CHECK_ENDIAN__.
>=20
> 	- moved small .h files into rxe_loc.h
>=20
> 	- rewrote the Kconfig text to be a little friendlier
>=20
> 	- Changed the patch names to make them easier to handle.
>=20
> 	- the quilt patch series is online at:
> 	  http://support.systemfabricworks.com/downloads/rxe/patches-v2.tgz
>=20
> 	- librxe is online at:
> 	  http://support.systemfabricworks.com/downloads/rxe/librxe-1.0.0.tar.=
gz
>=20
> 	Thanks to Roland Dreier, Bart van Assche and David Dillow for helpful
> 	suggestions.

I'm wondering what the status of this patchset is?

It would be very good if the rxe modules could be
included in the mainline kernel.

Hopefully Samba will get support for SMB-Direct (SMB2 over RDMA) support
in future. And having RDMA support without hardware support would be very=

good for testing and also for usage on the client side against a server
which has hardware RDMA support.

Are there git repositories yet (for the kernel and userspace)?

metze


--------------enigEAB3FBA4A4F597D711A4BD3E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBHKxsACgkQm70gjA5TCD/0/QCgxK7YuCs4tAyeGNpklScsOz8m
3ZkAnjqovBz+ju7z7ugJsRu04fawBP2u
=i6z9
-----END PGP SIGNATURE-----

--------------enigEAB3FBA4A4F597D711A4BD3E--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
