From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Sun, 31 May 2015 15:00:27 -0400
Message-ID: <1433098827.114391.179.camel@redhat.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-uzG0N8neJNEpRxV9eP84"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433074457-26437-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-uzG0N8neJNEpRxV9eP84
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2015-05-31 at 15:14 +0300, Or Gerlitz wrote:
> Hi Doug,
>=20
> This patchset adds completion timestamping supports for verbs consumers.=
=20
>=20
> Reviewing the weekend threads, we've changed the flag time to reflect
> that this is completion time-stamp and folded the mlx4 actual support=20
> into one patch.
>=20
> Regarding the related user-space support, it's possible to add what you
> were suggesting, ibv_get_raw_cqe_timestamp() -- returns ts in cycles and=
=20
> ibv_get_cqe_timestamp() -- returns ts in ns, this makes the value returne=
d
> by the poll cq verb an opaque one that must go through one of  the conver=
tors.
>=20
> We would to go for one helper ibv_get_timestamp(uint64_t raw_time, flag) =
which=20
> could get the raw time-stamp and one of the following flags: RAW_TIME, RA=
W_NS_TIME.

I'm theoretically OK with something similar to the above.  However, the
NS time should not be raw.  It should be cooked and should be able to be
valid to compare between different adapters.  Right now, the cycle
counter that you are exposing is only useful for ordering between
packets received on a single adapter where the cycle counter is the same
on all packets.  Throw in a different vendor's card, or two of your own
cards, and the issue gets much more complex.  The cooked value should be
an actual, real time that can be used across these more complex
environments.  Because of that, it really shouldn't be called RAW.

So, if you want a single entry point, I would suggest something like
this:

enum ib_timestamp_flags {
	IB_TIMESTAMP_COMPLETION =3D (1 << 0), // specify on create_cq
	IB_TIMESTAMP_WQE_BEGIN =3D  (1 << 1), // specify on create qp?
	IB_TIMESTAMP_WQE_END =3D    (1 << 2), // specify on create qp?
	IB_TIMESTAMP_RAW =3D        (1 << 31)
};

enum ib_cq_creation_flags {
	IB_CQ_FLAGS_TIMESTAMP_COMPLETION =3D (1 << 0)
};

/**
 * ibv_get_timestamp - Return the requested timestamp for the given wc
 * @wc - work completion to get timestamp results from
 * @ts - struct timespec to return timestamp in
 * @flags - which timestamp to return and in what form
 *
 * Depending on the flags used to create the queue pair/completion
 * queue, different timestamps might be available.  Callers should
 * specify which timestamp they are interested in using the flags
 * element, and if they wish either a cooked or raw timestamp.  A
 * raw timestamp is implementation defined and will be passed back
 * in the tv_nsec portion of the struct timespec.  A raw timestamp
 * can not be relied upon to have any ordering value between more
 * than one HCA or driver.  A cooked timestamp will return a valid
 * struct timespec normalized as closely as possible to the return
 * value for CLOCK_MONOTONIC of clock_gettime at the time of the
 * timestamp.
 */
int ibv_get_timestamp(struct ibv_wc *wc, struct timespec *ts, int
flags);

> We think this would address the reviewer comments for the kernel submissi=
on.
>=20
> The user-space code is in (still uses IB_CQ_FLAGS_TIMESTAMP and miss the=
=20
> conversion functions)=20
>=20
>  https://github.com/matanb10/libibverbs timestamp-v1
>  https://github.com/matanb10/libmlx4 timestamp-v1
>=20
> Timestamping is used by applications in order to know when a WQE was=20
> received/transmitted by the HW. The value is given is HCA hardware cycles=
,
> but could be easily converted as the hardware's core clock frequecny is=
=20
> available through extension of query device.=20
>=20
> Moreover, we add an ability to read the HCA's current clock. This could b=
e=20
> useful on order to synchronize events to the wall clock.
>=20
> This functionality is achieved by adding/extending the following verbs:
>=20
> create_cq - create_cq is extended in order to allow passing creation flag=
s
> to the CQ creation function. We change IB/core --> vendors API
> to be easily extendible by passing a struct which contains
> comp_vectors, cqe and the new flags parameter. In order to create
> CQ which supports timestamping, IB_CQ_FLAGS_TIMESTAMP_COMPLETION should b=
e given.
>=20
> query_device - We extend query_device uverb further by giving the hardwar=
e's
> clock frequency and the timestamp mask (the number of timestamp
> bits which are supported). If timestamp isn't supported, 0 is returned.
>=20
> In order to read the timestamp in the WQE, the user needs to query the de=
vice=20
> for support, create an appropriate CQ (using the extanded uverb with
> IB_CQ_FLAGS_TIMESTAMP_COMPLETION) and poll the CQ with an extended poll_c=
q verb (currently,
> only implemented in user-space).
>=20
> In mlx4, allowing the user to read the core clock efficiently involves ma=
pping
> this area of the hardware to user-space (being done by using a mmap comma=
nd)
> and reading the clock from the correct offset of the page.=20
>=20
> This offset is returned in the vendor's specific data from mlx4's kernel =
driver=20
> to the mlx4's user-space driver. query_device is modified in order to sup=
port
> passing this vendor specific data. A user-space application could use a n=
ew
> verb in order to read the hardware's clock.
>=20
> Translating the hardware's clock into ms could be done by dividing this
> value by hca_core_clock (which is returned by the extended version of
> query_device uverb).
>=20
> A user-space application could get the current HW's clock by executing
>=20
> ibv_query_values_ex(struct ibv_context *context, uint32_t q_values,
>                     struct ibv_values_ex *values)
>=20
> The function gets a mask of the values to query and return their values.
> Vendors could either implement this as a uverb command or use their=20
> user-space driver to return those values directly from the HW (the mlx4 w=
ay).
>=20
> Matan and Or.
>=20
> Changes from V1:
>  (1) fixed lustre IB's code build
>  (2) squashed mlx4 V1 9-11 patches into one
>  (3) changed IB_CQ_FLAGS_TIMESTAMP --> IB_CQ_FLAGS_TIMESTAMP_COMPLETION
>=20
> Changes from V0:
> (1) Pass ib_cq_init_attr instead of cqe and comp_vector.
> (2) Fix unneeded indentation.
> (3) Change flags to u32.
> (4) Add const to create_cq's ib_cq_init_attr argument in vendor implement=
ation.
>=20
> Matan Barak (9):
>   IB/core: Change provider's API of create_cq to be extendible
>   IB/core: Change ib_create_cq to use struct ib_cq_init_attr
>   IB/core: Add CQ creation time-stamping flag
>   IB/core: Extend ib_uverbs_create_cq
>   IB/core: Add timestamp_mask and hca_core_clock to query_device
>   IB/core: Pass hardware specific data in query_device
>   IB/mlx4: Add mmap call to map the hardware clock
>   IB/mlx4: Support extended create_cq and query_device uverbs
>   IB/mlx4: Add support for CQ time-stamping
>=20
>  drivers/infiniband/core/device.c                   |    6 +-
>  drivers/infiniband/core/mad.c                      |    5 +-
>  drivers/infiniband/core/uverbs.h                   |    1 +
>  drivers/infiniband/core/uverbs_cmd.c               |  188 ++++++++++++++=
++----
>  drivers/infiniband/core/uverbs_main.c              |    1 +
>  drivers/infiniband/core/verbs.c                    |    4 +-
>  drivers/infiniband/hw/amso1100/c2_provider.c       |   14 ++-
>  drivers/infiniband/hw/cxgb3/iwch_provider.c        |   19 ++-
>  drivers/infiniband/hw/cxgb4/cq.c                   |    9 +-
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |    8 +-
>  drivers/infiniband/hw/cxgb4/provider.c             |    8 +-
>  drivers/infiniband/hw/ehca/ehca_cq.c               |    7 +-
>  drivers/infiniband/hw/ehca/ehca_hca.c              |    6 +-
>  drivers/infiniband/hw/ehca/ehca_iverbs.h           |    6 +-
>  drivers/infiniband/hw/ehca/ehca_main.c             |    6 +-
>  drivers/infiniband/hw/ipath/ipath_cq.c             |    9 +-
>  drivers/infiniband/hw/ipath/ipath_verbs.c          |    7 +-
>  drivers/infiniband/hw/ipath/ipath_verbs.h          |    3 +-
>  drivers/infiniband/hw/mlx4/cq.c                    |   13 ++-
>  drivers/infiniband/hw/mlx4/mad.c                   |    5 +-
>  drivers/infiniband/hw/mlx4/main.c                  |   67 +++++++-
>  drivers/infiniband/hw/mlx4/mlx4_ib.h               |   19 ++-
>  drivers/infiniband/hw/mlx5/cq.c                    |   10 +-
>  drivers/infiniband/hw/mlx5/main.c                  |   19 ++-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h               |    5 +-
>  drivers/infiniband/hw/mthca/mthca_provider.c       |   15 ++-
>  drivers/infiniband/hw/nes/nes_verbs.c              |   17 ++-
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   13 ++-
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h        |    9 +-
>  drivers/infiniband/hw/qib/qib_cq.c                 |   11 +-
>  drivers/infiniband/hw/qib/qib_verbs.c              |    6 +-
>  drivers/infiniband/hw/qib/qib_verbs.h              |    5 +-
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   16 ++-
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.h       |   10 +-
>  drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |    9 +-
>  drivers/infiniband/ulp/iser/iser_verbs.c           |    6 +-
>  drivers/infiniband/ulp/isert/ib_isert.c            |    6 +-
>  drivers/infiniband/ulp/srp/ib_srp.c                |   10 +-
>  drivers/infiniband/ulp/srpt/ib_srpt.c              |    5 +-
>  drivers/net/ethernet/mellanox/mlx4/main.c          |   19 ++
>  .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    7 +-
>  include/linux/mlx4/device.h                        |    9 +
>  include/rdma/ib_verbs.h                            |   25 ++-
>  include/uapi/rdma/ib_user_verbs.h                  |   19 ++
>  net/9p/trans_rdma.c                                |    5 +-
>  net/rds/ib_cm.c                                    |    8 +-
>  net/rds/iw_cm.c                                    |    8 +-
>  net/sunrpc/xprtrdma/svc_rdma_transport.c           |   10 +-
>  net/sunrpc/xprtrdma/verbs.c                        |   10 +-
>  49 files changed, 564 insertions(+), 139 deletions(-)
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-uzG0N8neJNEpRxV9eP84
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVa1pLAAoJELgmozMOVy/d6CQP/RVW/hnsNrTLMMa/cEJ12vx1
NT1jr54KkPLNl6H0UtK4KecOMIAa9T0sc9aVqiMUpVhjGEQwdBE05Dkm/mevYdMC
lNK9x54she0iRGNvNAyZotqypAVDyJO0w2FGbg13VDcquvgiP3T6d4ieQZCdwssp
78aKP9VqGF0BDpQPJVFypOPCivhESBsEBKmPOHQvVNFW1rBb1YULooGPP3y8i+kZ
iXgNJgWinD78f9aPDjsg0xcoLQRp1VdYk/tuSZFsNprO4CHOgxxjBjg0t8TuET0u
maJXkgqQ+9EiXsT5uz8HtJcO6mc+P8FMV6EfRe/O9vLJmde9S30G/zG82P1TgOng
7hZGZadtU2uQ6/oerM37c47T4DaBCpOYP15hhiTrpWKc4aIx3TKzaeMT6uVfrUrs
cbDLuUSgE7CIL4uKGb5n87l5eTMZzv6cLx7UJkw0mTfPVr1KIGxu4C1EzZTDn+fC
uf8Ew3GUUcAQiRuOxxmQB0tDW3V6v98GdVA91JfCURb2VSx5GcbYm7W/KIfK2MQd
BtezN1Q78xmIxwSd9JMjBSZQiHDWTy+TZo9CbeaYZ7Km8pPmKYSJgKOwQq0WUEl+
3Zo9D230ImSNZfhoj5ha5Bgzq+/orImQHUObTDcxRgaorCAxRSst8Klmifs9g+gW
PWWu3cA83ExPOZUabvMk
=MR6V
-----END PGP SIGNATURE-----

--=-uzG0N8neJNEpRxV9eP84--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
