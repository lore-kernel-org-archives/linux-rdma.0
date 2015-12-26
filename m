From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] ocrdma bug fix for linux-4.4-rc
Date: Sat, 26 Dec 2015 13:07:08 -0500
Message-ID: <567ED74C.6090508@redhat.com>
References: <1450980848-18945-1-git-send-email-devesh.sharma@avagotech.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3AdhBv1e3vx1NsikV0ASLFpLTgfMSHAU4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450980848-18945-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3AdhBv1e3vx1NsikV0ASLFpLTgfMSHAU4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/24/2015 01:14 PM, Devesh Sharma wrote:
> This patch series fixes for critical bugs introduced due to recent
> changes in linux Infiniband stack.
>=20
> Patch 0001 fixes a vlan-id assignment issues in presence of PFC.
> This bug was introduced recently got introduced and it fixes
> dbf727de7440 ('IB/core: Use GID table in AH creation and dmac resolutio=
n')
>=20
> Patches 0002 to 0004 fixes a deadlock condition reported by Dough Ledfo=
rd
> while testing linux-4.4-rc5. The deadlock happens when any be2net hook =

> (e.g. open/close) is called in parallel to insmod ocrdma.ko.
>=20
> A. be2net is sending administrative open/close event to ocrdma holding
>    device_list_mutex. It does this from ndo_open/ndo_stop hooks of be2n=
et.
>    So sequence of locks is rtnl_lock---> device_list lock
>=20
> B.  When new ocrdma roce device gets registered, infiniband stack now
>     takes rtnl_lock in ib_register_device() in GID initialization routi=
nes.
>     So sequence of locks in this path is device_list lock ---> rtnl_loc=
k.
>=20
> This improper locking sequence causes deadlock.
>=20
> Patch 0002 removes an unwanted code to force all active-QPs to error st=
ate
> using a management command. It is rather simple to let active-QPs to mo=
ve
> to error on their own due to a completion error after the port error is=

> reported.
>=20
> Patch 0003 makes IB-dispatch-event mechanism independent of administrat=
ive
> open/close events injected from be2net driver. Instead of those events,=
 now
> ocrdma relies on async-events generated from CNA. Thus, solving the pro=
blem
> of keeping device_list_mutex busy under rtnl-lock. Moving from administ=
rative
> events to CNA async-events does not change the functionality of ocrdma =
driver
> in any way.
>=20
> Patch 0004 Removes the dead code from be2net driver.
>=20
> Devesh Sharma (4):
>   RDMA/ocrdma: Fix vlan-id assignment in qp parameters
>   RDMA/ocrdma: Dispatch only port event when port state changes
>   RDMA/ocrdma: Depend on async link events from CNA
>   RDMA/be2net: Remove open and close entry points
>=20
>  drivers/infiniband/hw/ocrdma/ocrdma.h       | 10 +++++
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 49 ++++++++++++++++++++-=
----
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |  4 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c  | 57 +++++++++++++--------=
--------
>  drivers/infiniband/hw/ocrdma/ocrdma_sli.h   | 49 +++++++++++++++++++++=
++--
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  2 +-
>  drivers/net/ethernet/emulex/benet/be.h      |  2 -
>  drivers/net/ethernet/emulex/benet/be_main.c |  4 --
>  drivers/net/ethernet/emulex/benet/be_roce.c | 36 ------------------
>  drivers/net/ethernet/emulex/benet/be_roce.h |  4 +-
>  10 files changed, 124 insertions(+), 93 deletions(-)
>=20

Thanks Devesh, I'll review and test this later today.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--3AdhBv1e3vx1NsikV0ASLFpLTgfMSHAU4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWftdMAAoJELgmozMOVy/ddNUP/jU58/X/wZy38ZmePoApRNEd
Je3K4j6jwFulMDkl4sSY4uwj3AwToCIZHyXwokFKh5RKQTIw5Dl/YbBV0iUZtKGx
PAvKn8veTUqDNGfjdqRUQ3NO0dCRe3Rn/K5jeXq3Fzp6gD5vt9RIc188h7im72yf
pTdAOxFKNvvLa0nAlylifRUEwsbm1YCsNjI/9XwyttkXv7tl6386qIH7k6HtJIkT
PjjSEtDJtWE8VbPb/jz76ZQgQ8FHe8C/JO16RpvnG7IIJkaTOUTnEUGX2mEtQNvh
qwbTHvXMYGGyP/3mP5DcVCRgoyh+XT8YKc3E0E5nVwEwdIYHcP8d/P/ac3uhD1Zo
ReRga627KSnz+Al5RyYHe3pI0wH2GZAPriSzIUk2eQh4Ms3oZyTAW6ndFhbrnrzy
0Zc4aMuKy4DJt9z5nNqo5piX+mWaL9EmtYZra/xf5wo5Su7Pit04CY27NUyoRR9F
XtOu2IL0lEEoiG+KtD5y4A7ZhED/RLSzTiiXU+Ay8pYHXeMGwgPzrGDaQt1AAkTE
gIyTU7WBoZSzuFRzytg2Y9h8N1cf7zLy9M1dSJtvJZbvZRIyTtSSfvp7Y6nPPyCs
2Gzg+Cv1hjNeSgz455JfRqibE9D2Dn3s927XvdGwSG+5AEDziRC7XN837D4XS5CT
8k7APoa/UR73teTMOYBI
=tPkQ
-----END PGP SIGNATURE-----

--3AdhBv1e3vx1NsikV0ASLFpLTgfMSHAU4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
