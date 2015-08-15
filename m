From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Make ib_dealloc_pd return void
Date: Fri, 14 Aug 2015 21:05:07 -0400
Message-ID: <55CE9043.1030804@redhat.com>
References: <20150805203431.GB30271@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="L8wTwbDsCisaa5dOwCHWpKWfi1WukidIH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150805203431.GB30271-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L8wTwbDsCisaa5dOwCHWpKWfi1WukidIH
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/05/2015 04:34 PM, Jason Gunthorpe wrote:
> The majority of callers never check the return value, and even if they
> did, they can't do anything about a failure.
>=20
> All possible failure cases represent a bug in the caller, so just
> WARN_ON inside the function instead.
>=20
> This fixes a few random errors:
>  net/rd/iw.c infinite loops while it fails. (racing with EBUSY?)
>=20
> This also lays the ground work to get rid of error return from the
> drivers. Most drivers do not error, the few that do are broken since
> it cannot be handled.
>=20
> Since uverbs can legitimately make use of EBUSY, open code the
> check.
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs_cmd.c       | 22 ++++++++++++++++------=

>  drivers/infiniband/core/verbs.c            | 26 ++++++++++++++++++++--=
----
>  drivers/infiniband/ulp/ipoib/ipoib_verbs.c |  4 +---
>  drivers/infiniband/ulp/iser/iser_verbs.c   |  2 +-
>  include/rdma/ib_verbs.h                    |  6 +-----
>  net/rds/iw.c                               |  5 +----
>  net/sunrpc/xprtrdma/verbs.c                |  2 +-
>  7 files changed, 41 insertions(+), 26 deletions(-)
>=20
> Doug, this applies after the local_dma_lkey cleanup series.
>=20
> Lightly tested with ipoib/uverbs/umad on mlx4.
>=20
> This patch will expose buggy ULPs, I would not be too surprised to see
> a report of the WARN_ON triggering...

I'm not sure I like this patch.  I have my concerns that this will make
debugging and catching problems more difficult.  In particular, in the
recent past when I was working on the IPoIB driver and its
startup/shutdown sequence, I wrote this changelog:

This factoring is needed in preparation for having per-device work
queues.  The original per-device workqueue code resulted in the
following error message:

    <ibdev>: ib_dealloc_pd failed

The change you put in here will make note of the driver that fails to
return a clean return, but the error happens elsewhere.  This obscures
the source of the error.  And it's not out of the question (or even
unlikely) that shifts in how people do transfer engines might result in
lost allocations and this warning popping up.  It serves as a final
check on the ULP, and to me that has value.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--L8wTwbDsCisaa5dOwCHWpKWfi1WukidIH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzpBDAAoJELgmozMOVy/d77YP/2XJOafuCcotGg4ENfyNw+jX
IFpMZohH8Pqz1+zzEtWObNtvT8UaEYjcyAN39cEOc0Rmy7+/CvUkeGpoUGoswMk9
VxXxzX352xzF5IqVRj94fE0cwxoGCFIPvUpCQ7D9lWK2fj5XNwhhUEDyJYvcdZbZ
9wbv95qLzONyvtJBFobcoDitllL3XIsDgmoA0D0I7iIgpFuodVRQc14VCdW49reK
ZBq5dT4zb46KXZZVoszFfWZmyj/Q8ILPRehg/OJ478Pzw5llWZWEZHvokDZsAsmp
fXLLkbRKMBdy89ZGQ6Ev3WUC5ML7nF7DrpJdVeXSJ2xwA7NeNHXVymtozc7K/2CU
ONDpRPqoRn84360tj/koJqWytroDdb1rgvs83vCALE9uMOqtnmkRo/v5nFISbYje
K6gRadotal/5qISGTiR+vzvdrUUvPF4HXxTLIwDtYb1g57J7/5XupnHTSJOhvOOZ
dgQm4ryPl8w7PUqDK8RJMRmfAntYc0YW+XEFCsLinHefePKOKI+21RdMGdy3pcpn
ap/91aHIJDmIhuFQVSUXnNjVPgT74O6FT8V7JDz/OPzPtBw2a4tdXY5N1AH6yC9Y
j3mCgiTkQYD3Vu9PXbkYNURzeaoW+B8lwBOQq3L0UuMJSrmdC4d3uYzxC+98v+iR
/HMym+KCpREqgWe4mHpi
=9mr/
-----END PGP SIGNATURE-----

--L8wTwbDsCisaa5dOwCHWpKWfi1WukidIH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
