From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 0/4] Add network namespace support in the RDMA-CM
Date: Wed, 28 Oct 2015 12:33:35 -0400
Message-ID: <5630F8DF.60203@redhat.com>
References: <1445516411-17327-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5MKpPTKvinLD7pwmDJ0IxgRD84hgWFgR9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445516411-17327-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5MKpPTKvinLD7pwmDJ0IxgRD84hgWFgR9
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/22/2015 08:20 AM, Haggai Eran wrote:
> Hi Doug,
>=20
> I've rebased the network namespaces patches over your 4.4 tree.

Thanks, it went in cleanly this time.  Applied.

> Regards,
> Haggai
>=20
> Changes from v6:
> - rebased over k.o/for-4.4
> - use init_net when no netdev is found (RoCE and AF_IB)
>=20
> Changes from v5:
> - removed patches that got in as part of the cleanup series.
>=20
> RDMA-CM uses IP based addressing and routing to setup RDMA connections =
between
> hosts. Currently, all of the IP interfaces and addresses used by the RD=
MA-CM
> must reside in the init_net namespace. This restricts the usage of cont=
ainers
> with RDMA to only work with host network namespace (aka the kernel init=
_net NS
> instance).
>=20
> This patchset allows using network namespaces with the RDMA-CM.
>=20
> Each RDMA-CM id keeps a reference to a network namespace.
>=20
> This reference is based on the process network namespace at the time of=
 the
> creation of the object or inherited from the listener.
>=20
> This network namespace is used to perform all IP and network related
> operations. Specifically, the local device lookup, as well as the remot=
e GID
> address resolution are done in the context of the RDMA-CM object's name=
space.
> This allows outgoing connections to reach the right target, even if the=
 same
> IP address exists in multiple network namespaces. This can happen if ea=
ch
> network namespace resides on a different P_Key.
>=20
> Additionally, the network namespace is used to split the listener port =
space
> tables. From the user point of view, each network namespace has a uniqu=
e,
> completely independent tables for its port spaces. This allows running =
multiple
> instances of a single service on the same machine, using containers.=20
>=20
> The functionality introduced by this series would come into play when t=
he
> transport is InfiniBand and IPoIB interfaces are assigned to each names=
pace.
> Multiple IPoIB interfaces can be created and assigned to different RDMA=
-CM
> capable containers, for example using pipework [1].
>=20
> The patches apply against Doug's for-4.4 tree.
>=20
> The patchset is structured as follows:
>=20
> Patch 1 is a relatively trivial API extension, requiring the callers
> of certain ib_addr functions to provide a network namespace, as needed.=

>=20
> Patches 2-4 add proper namespace support to the RDMA-CM module. This
> includes adding multiple port space tables, adding a network namespace
> parameter, and finally retrieving the namespace from the creating proce=
ss.
>=20
> [1] https://github.com/jpetazzo/pipework/
>=20
> Guy Shapiro (3):
>   IB/addr: Pass network namespace as a parameter
>   IB/cma: Add support for network namespaces
>   IB/ucma: Take the network namespace from the process
>=20
> Haggai Eran (1):
>   IB/cma: Separate port allocation to network namespaces
>=20
>  drivers/infiniband/core/addr.c                     |  17 +--
>  drivers/infiniband/core/cma.c                      | 129 +++++++++++++=
++------
>  drivers/infiniband/core/ucma.c                     |   4 +-
>  drivers/infiniband/ulp/iser/iser_verbs.c           |   2 +-
>  drivers/infiniband/ulp/isert/ib_isert.c            |   2 +-
>  .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h    |   4 +-
>  include/rdma/ib_addr.h                             |  16 ++-
>  include/rdma/rdma_cm.h                             |   6 +-
>  net/9p/trans_rdma.c                                |   4 +-
>  net/rds/ib.c                                       |   2 +-
>  net/rds/ib_cm.c                                    |   2 +-
>  net/rds/iw.c                                       |   2 +-
>  net/rds/iw_cm.c                                    |   2 +-
>  net/rds/rdma_transport.c                           |   4 +-
>  net/sunrpc/xprtrdma/svc_rdma_transport.c           |   4 +-
>  net/sunrpc/xprtrdma/verbs.c                        |   3 +-
>  16 files changed, 142 insertions(+), 61 deletions(-)
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--5MKpPTKvinLD7pwmDJ0IxgRD84hgWFgR9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWMPjfAAoJELgmozMOVy/dP/EQAJjSrmfWt9zfei6t9hYvGiH8
SO5El5OnCJcnLsnCRoNBXiagLGj37UEPek84QFmLwbOaFvb8r9dpKLDd+C8Qb4Z8
89LjXEUCYzd7qDjTFnQojGDq8FDl/RvbYmRGiKisg9TeOyx25IucQIfyKcHl6WFB
xrqKEgQusGirV143ytBVFTw4s2fAbb0THm/Kjfv5QpN0Jkp7A5TQ5CqzPWXqY3OS
Dn7gPA14ULWDBN/TwAVaLXk8DOW3G6I5W669J/kOeQb4tvZP44qyCi/7D0g+rWHM
ag7ciw2m+oruRP4mKuKlf3Ofszj4M3iS78qqY9XKxlDuFHrj0lMGJvCLFj3xHT07
foNoayJQatsOezCuU5Vr9feJxl5zXeYtWlf32HEkLsNPXc1/T544CtppRs+Rlha8
1ve6tJdPlZgnIEkL8ilmqvNXy6Z6YMHeIyOPjZgvf8qm8gdvJtZ9ea8MoLMWooMS
w5B43pryVWZoRhA/lFauoK8pb0nUrPIM6pqrNJoYpcGa09NY/IG+5E1IkrFmCAjs
5Zpw48TyHXBQNqbml4ODVKSezEYcrKaVxD57kEts++TYMl9q21Q/2V3XfN4KOgaH
2MLpkwOfvzpI8iit8o7jRTxDEbdi17bvpz8UTmXWMwiJZVJMpXLqPL0Wc2eH6Df+
65mZcx2T2QuwX/F5qDXy
=KC3J
-----END PGP SIGNATURE-----

--5MKpPTKvinLD7pwmDJ0IxgRD84hgWFgR9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
