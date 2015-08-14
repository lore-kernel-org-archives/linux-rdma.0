From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V1 3/3] IB/core: Fix possible deadlock in
 write_gid
Date: Fri, 14 Aug 2015 17:16:40 -0400
Message-ID: <55CE5AB8.9010301@redhat.com>
References: <1438607342-11964-1-git-send-email-matanb@mellanox.com>
 <1438607342-11964-4-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="W7njktigSMXrgX7JcuTxB4e6cPJ575H6O"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438607342-11964-4-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--W7njktigSMXrgX7JcuTxB4e6cPJ575H6O
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/03/2015 09:09 AM, Matan Barak wrote:
> Fixing the possible deadlock in write_gid:
> write_gid -> write_lock()
> <interrupt>
> 	find_gid -> read_lock_irqsave()
> 		    ** DEAD LOCK **LOCK
>=20
> Fixing it by changing the write_lock to write_lock_irqsave.
>=20
> Squash-into: 'IB/core: Add RoCE GID table management'
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Squashed as requested.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--W7njktigSMXrgX7JcuTxB4e6cPJ575H6O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzlq4AAoJELgmozMOVy/dQCYP/1FUAm1GLyWfUmdSgcXpdRaw
ucnVY+chNZ3dckgpHQwdR3OW5i5Lb7w1T889hKi1xp2J3tl9EqPkbwqmy/RWdM86
4xx8NfibLDWznJwNsJE6+qA5UCfGd4GVzcS4cPZvq3O1ppNU+j/UBMf0+TVKGE7R
ocq60Uwe8VH3x5Wn8YUdjGttOvzGXM0Xw91qN4OyHGISBPk5T/iA14BWBww+CIBc
Ckiqrxq0d+SvczjSuck4bGy92ss74DKBySPvplVm9Y7JaVLYTuDaoAcrlDAp6t9o
nNcI0TYZWtzRpTLNbLRR82YiyUy0cWduAXDbU+rUNs289+toalMSbTWUqBsX/W/2
R+w6UxS2rvJqXuBOAI+jP6ZcTcIGHLF6HFugR8Ml0SrOKCNntMJrk83NCwCeL4ny
x4dRXNj7pOwCFofY9yJzxr1roEt1/O2KKmSup7a6bjE4NcOhRpJBL77XbdMo5oy2
SALyPGoaLkLtTyTWAGkrLYzgZeQ8i255nul5yPQyFDYQb+ZkG7f45Z2D0dW0gEBY
rOhUOAtyAwSjgosW2NwCi8/j7ntSIQNkqCN9UARhIr88GIFQ+GaDUayhmctz+5Gc
8OTNf6l70nfpnH4KQ3A7WtL6DxTjw/q8n8/yQxsFdbNuAS2h6MVB0JM7UNYWYkmE
Dsq+6YdyLuQ9ngJa+i0n
=BuRm
-----END PGP SIGNATURE-----

--W7njktigSMXrgX7JcuTxB4e6cPJ575H6O--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
