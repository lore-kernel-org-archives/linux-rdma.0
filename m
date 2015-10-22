From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next v2 00/10] Add RoCE GID cache usage in verbs/cma
Date: Wed, 21 Oct 2015 23:52:25 -0400
Message-ID: <56285D79.8080405@redhat.com>
References: <1444923534-10882-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9T1WrdOrxIwJwIoBaTj7QJESKE183FNJt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444923534-10882-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9T1WrdOrxIwJwIoBaTj7QJESKE183FNJt
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/15/2015 11:38 AM, Matan Barak wrote:
> Hi Doug,
>=20
> This purpose of this series is to add usage of the GID cache to
> the CMA and IB stack. Instead of passing Ethernet L2 attributes
> via QP attributes, we could just use the GID cache that's already
> points to a ndev and thus to all required L2 attributes.
>=20
> The first five patches query the GID table to find only GIDs which
> are related to the bounded net-device of the specific used port. This
> extra information is carried via ib_sa_path_rec (extending it to
> include the namespace and ifindex). Querying the ndev and port
> is achieved by adding a gid_attr argument to ib_query_gid, add a
> ndev argument to ib_find_cached_gid and add a new
> ib_find_cached_gid_by_port. This usage of the GID table replaces
> the usage of QP attributes.
>=20
> The sixth patch adds an ib_cache_gid_find_by_filter function.
> This allows the user to query the cache by a specific filter.
> ib_cache_gid_find_by_filter is used by the seventh patch. Instead
> of storing the smac and vid on the AH, we could just resolve
> them from the net-device which the sgid index is assigned to.
> This change means that instead of resolving all L2 attributes,
> the server, we get the dgid and vlan and searches the GID cache
> in order to find a matching GID index.
>=20
> The last three patches removed unused fields and attributes.
>=20
> Matan
>=20
> Changes from V1:
>  - Rebased patches against Doug's latest k.o/for-4.4 tree.

Most of this code seemed like pretty straight forward prepatory word for
the follow on patch series.  However, I did note that this patch set
extends the per-element locking of the GID tables.  I've taken this
patch set in spite of that fact.  Please prioritize changing that
locking to something more reasonable.  I would prefer if those changes
landed prior to the 4.4 merge window closing.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--9T1WrdOrxIwJwIoBaTj7QJESKE183FNJt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWKF15AAoJELgmozMOVy/dyGYQALKCX6z9saCgWbgJ9SigjZIK
gW4kN3gAd/Reae4jZp5NXV0B6GvjuP1eY1nn3f9KFpYP1s5weONMt4xba9c7QYSV
g/oUEDpi9+nqx8xBoNwDvdvINjaaP5rxtAdq8CGPLPI5/qxqaCs7i1ytbIhnjcGU
VeQG+OVvPt5KEI60rqIxHgUTLOqtz4S19k4PVcS83tXhO02t/sRfJV7W4TsZKNx2
NtSVyiO+2SPmOVtEt1PPCrIXuwUc2c4zM9vSaS9HUOt6r8TluBP2Com/+c3gq14L
eyNjd8d4FU59REHmAkF8YKmAXl8p6M6kZ8019qPcQuSRHtYS4AzKtZxslq+oWYZb
2y6FMoVFrz2lW3yhYqgiokDqrM4uij+NRRKx0Me/atEfNavHLP8+mjOlTHtOXlm+
XW2EXNGrMK6u6bCuFXF1in2/fbrwqig8FC+o/ib6tUmoll833Gv+TKy7KjeJdM+G
wYkYgd03KsvFwB1LQSmbwbkhhWEJBKa6YqOWVvJDuTXXqe9pPZiC6VfO/jtg8kuN
WPoEXTrQH8iY8GAh+GWxsdfsKwTQjwzumlqMSUkcYdWkmnmSm272ozGkRqX2VXek
cqIYeD633UWbXUJlAWQbL7LaNDZw9v6nQ7fjoNeO4W2YpEDVC4fQ27/mW9cTYcTz
XJfWzXjmiHVUdh1vFw0v
=P49v
-----END PGP SIGNATURE-----

--9T1WrdOrxIwJwIoBaTj7QJESKE183FNJt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
