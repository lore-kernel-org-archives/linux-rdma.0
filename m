From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Mon, 01 Jun 2015 07:25:04 -0400
Message-ID: <1433157904.114391.188.camel@redhat.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
	 <1433098827.114391.179.camel@redhat.com>
	 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-xLY8SNhi4LQlM60ZKWMA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-xLY8SNhi4LQlM60ZKWMA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-06-01 at 12:30 +0300, Matan Barak wrote:
> On Sun, May 31, 2015 at 10:00 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > On Sun, 2015-05-31 at 15:14 +0300, Or Gerlitz wrote:
> >> Hi Doug,
> >>
> >> This patchset adds completion timestamping supports for verbs consumer=
s.
> >>
> >> Reviewing the weekend threads, we've changed the flag time to reflect
> >> that this is completion time-stamp and folded the mlx4 actual support
> >> into one patch.
> >>
> >> Regarding the related user-space support, it's possible to add what yo=
u
> >> were suggesting, ibv_get_raw_cqe_timestamp() -- returns ts in cycles a=
nd
> >> ibv_get_cqe_timestamp() -- returns ts in ns, this makes the value retu=
rned
> >> by the poll cq verb an opaque one that must go through one of  the con=
vertors.
> >>
> >> We would to go for one helper ibv_get_timestamp(uint64_t raw_time, fla=
g) which
> >> could get the raw time-stamp and one of the following flags: RAW_TIME,=
 RAW_NS_TIME.
> >
> > I'm theoretically OK with something similar to the above.  However, the
> > NS time should not be raw.  It should be cooked and should be able to b=
e
> > valid to compare between different adapters.  Right now, the cycle
> > counter that you are exposing is only useful for ordering between
> > packets received on a single adapter where the cycle counter is the sam=
e
> > on all packets.  Throw in a different vendor's card, or two of your own
> > cards, and the issue gets much more complex.  The cooked value should b=
e
> > an actual, real time that can be used across these more complex
> > environments.  Because of that, it really shouldn't be called RAW.
> >
>=20
> Thanks for the feedback Doug.
> We wanted to add RAW_NS in order to free the user from calculating it by =
himself
> (dividing the cycles value in the core_clock).

What's the point?  If it's raw, it's raw.  It's not coordinated between
adapters.  Whether it's in ns or ps or flipflops doesn't matter, it's a
flat number that has no reference to anything else, so the only thing
that matters is < another version of itself or not.

> In addition to this, it's possible to implement a future NS_TIME
> (without the "raw"), which
> will convert the opaque time to system wide ns.
>=20
> > So, if you want a single entry point, I would suggest something like
> > this:
> >
> > enum ib_timestamp_flags {
> >         IB_TIMESTAMP_COMPLETION =3D (1 << 0), // specify on create_cq
> >         IB_TIMESTAMP_WQE_BEGIN =3D  (1 << 1), // specify on create qp?
> >         IB_TIMESTAMP_WQE_END =3D    (1 << 2), // specify on create qp?
> >         IB_TIMESTAMP_RAW =3D        (1 << 31)
> > };
> >
> > enum ib_cq_creation_flags {
> >         IB_CQ_FLAGS_TIMESTAMP_COMPLETION =3D (1 << 0)
> > };
> >
> > /**
> >  * ibv_get_timestamp - Return the requested timestamp for the given wc
> >  * @wc - work completion to get timestamp results from
> >  * @ts - struct timespec to return timestamp in
> >  * @flags - which timestamp to return and in what form
> >  *
> >  * Depending on the flags used to create the queue pair/completion
> >  * queue, different timestamps might be available.  Callers should
> >  * specify which timestamp they are interested in using the flags
> >  * element, and if they wish either a cooked or raw timestamp.  A
> >  * raw timestamp is implementation defined and will be passed back
> >  * in the tv_nsec portion of the struct timespec.  A raw timestamp
> >  * can not be relied upon to have any ordering value between more
> >  * than one HCA or driver.  A cooked timestamp will return a valid
> >  * struct timespec normalized as closely as possible to the return
> >  * value for CLOCK_MONOTONIC of clock_gettime at the time of the
> >  * timestamp.
> >  */
> > int ibv_get_timestamp(struct ibv_wc *wc, struct timespec *ts, int
> > flags);
> >
>=20
> We wanted to divide the flow here:
> In create_cq, the user notifies the kernel/HCA which timestamp he
> would like to get.

Correction, which timestamp*s*.

> It could be a completion timestamp, a start of WQE timestamp or
> whatever he wants.
> The timestamp the user gets in the WQE is opaque. Every vendor could
> implement it
> as it wants - in order to have minimal implication in performance.

Again, timestamp(s).

> The second part is ibv_get_timestamp. It gets an opaque timestamp

No.  As you've already pointed out, how each vendor implements returning
the timestamp(s) could be totally different.  There are no timestamp
entries in the existing wc struct.  Expecting the user to pass the raw
value to the ibv_get_timestamp function makes no sense and violates the
attempted abstraction of ibverbs.  Passing in the wc struct allows the
driver to internally allocate a wc struct with extra private elements
and pass that back to the user, when the user passes it back to
ibv_get_timestamp the elements are there in the private portion of the
struct.

>  and
> outputs a converted value in respect to the time the user wanted to get.
> For example, if IB_TIMESTAMP_NS_TIME is given, the function should output
> a system-wide NS value (we would like to implement this only in the futur=
e).
> Currently, only RAW and RAW_NS will be supported, while RAW gives the tim=
e
> in cycles and RAW_NS gives a NS value with an unknown time reference.

Raw is raw.  Converting from raw yogurt to raw purple makes no sense,
it's raw.

> We think ibv_get_timestamp shouldn't get a wqe but a 64bit opaque value.
> The reason for this is that it could be used in order to translate query_=
values
> current time to different types of timestamp.
> What do you think?

See above.  It needs to be a wc struct unless you plan to identify every
timestamp we might concurrently enable and publicly change the wc struct
to include all of them so that the user can get the opaque value to pass
to the conversion function.

> >> We think this would address the reviewer comments for the kernel submi=
ssion.
> >>
> >> The user-space code is in (still uses IB_CQ_FLAGS_TIMESTAMP and miss t=
he
> >> conversion functions)
> >>
> >>  https://github.com/matanb10/libibverbs timestamp-v1
> >>  https://github.com/matanb10/libmlx4 timestamp-v1
> >>
> >> Timestamping is used by applications in order to know when a WQE was
> >> received/transmitted by the HW. The value is given is HCA hardware cyc=
les,
> >> but could be easily converted as the hardware's core clock frequecny i=
s
> >> available through extension of query device.
> >>
> >> Moreover, we add an ability to read the HCA's current clock. This coul=
d be
> >> useful on order to synchronize events to the wall clock.
> >>
> >> This functionality is achieved by adding/extending the following verbs=
:
> >>
> >> create_cq - create_cq is extended in order to allow passing creation f=
lags
> >> to the CQ creation function. We change IB/core --> vendors API
> >> to be easily extendible by passing a struct which contains
> >> comp_vectors, cqe and the new flags parameter. In order to create
> >> CQ which supports timestamping, IB_CQ_FLAGS_TIMESTAMP_COMPLETION shoul=
d be given.
> >>
> >> query_device - We extend query_device uverb further by giving the hard=
ware's
> >> clock frequency and the timestamp mask (the number of timestamp
> >> bits which are supported). If timestamp isn't supported, 0 is returned=
.
> >>
> >> In order to read the timestamp in the WQE, the user needs to query the=
 device
> >> for support, create an appropriate CQ (using the extanded uverb with
> >> IB_CQ_FLAGS_TIMESTAMP_COMPLETION) and poll the CQ with an extended pol=
l_cq verb (currently,
> >> only implemented in user-space).
> >>
> >> In mlx4, allowing the user to read the core clock efficiently involves=
 mapping
> >> this area of the hardware to user-space (being done by using a mmap co=
mmand)
> >> and reading the clock from the correct offset of the page.
> >>
> >> This offset is returned in the vendor's specific data from mlx4's kern=
el driver
> >> to the mlx4's user-space driver. query_device is modified in order to =
support
> >> passing this vendor specific data. A user-space application could use =
a new
> >> verb in order to read the hardware's clock.
> >>
> >> Translating the hardware's clock into ms could be done by dividing thi=
s
> >> value by hca_core_clock (which is returned by the extended version of
> >> query_device uverb).
> >>
> >> A user-space application could get the current HW's clock by executing
> >>
> >> ibv_query_values_ex(struct ibv_context *context, uint32_t q_values,
> >>                     struct ibv_values_ex *values)
> >>
> >> The function gets a mask of the values to query and return their value=
s.
> >> Vendors could either implement this as a uverb command or use their
> >> user-space driver to return those values directly from the HW (the mlx=
4 way).
> >>
> >> Matan and Or.
> >>
> >> Changes from V1:
> >>  (1) fixed lustre IB's code build
> >>  (2) squashed mlx4 V1 9-11 patches into one
> >>  (3) changed IB_CQ_FLAGS_TIMESTAMP --> IB_CQ_FLAGS_TIMESTAMP_COMPLETIO=
N
> >>
> >> Changes from V0:
> >> (1) Pass ib_cq_init_attr instead of cqe and comp_vector.
> >> (2) Fix unneeded indentation.
> >> (3) Change flags to u32.
> >> (4) Add const to create_cq's ib_cq_init_attr argument in vendor implem=
entation.
> >>
> >> Matan Barak (9):
> >>   IB/core: Change provider's API of create_cq to be extendible
> >>   IB/core: Change ib_create_cq to use struct ib_cq_init_attr
> >>   IB/core: Add CQ creation time-stamping flag
> >>   IB/core: Extend ib_uverbs_create_cq
> >>   IB/core: Add timestamp_mask and hca_core_clock to query_device
> >>   IB/core: Pass hardware specific data in query_device
> >>   IB/mlx4: Add mmap call to map the hardware clock
> >>   IB/mlx4: Support extended create_cq and query_device uverbs
> >>   IB/mlx4: Add support for CQ time-stamping
> >>
> >>  drivers/infiniband/core/device.c                   |    6 +-
> >>  drivers/infiniband/core/mad.c                      |    5 +-
> >>  drivers/infiniband/core/uverbs.h                   |    1 +
> >>  drivers/infiniband/core/uverbs_cmd.c               |  188 +++++++++++=
+++++----
> >>  drivers/infiniband/core/uverbs_main.c              |    1 +
> >>  drivers/infiniband/core/verbs.c                    |    4 +-
> >>  drivers/infiniband/hw/amso1100/c2_provider.c       |   14 ++-
> >>  drivers/infiniband/hw/cxgb3/iwch_provider.c        |   19 ++-
> >>  drivers/infiniband/hw/cxgb4/cq.c                   |    9 +-
> >>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |    8 +-
> >>  drivers/infiniband/hw/cxgb4/provider.c             |    8 +-
> >>  drivers/infiniband/hw/ehca/ehca_cq.c               |    7 +-
> >>  drivers/infiniband/hw/ehca/ehca_hca.c              |    6 +-
> >>  drivers/infiniband/hw/ehca/ehca_iverbs.h           |    6 +-
> >>  drivers/infiniband/hw/ehca/ehca_main.c             |    6 +-
> >>  drivers/infiniband/hw/ipath/ipath_cq.c             |    9 +-
> >>  drivers/infiniband/hw/ipath/ipath_verbs.c          |    7 +-
> >>  drivers/infiniband/hw/ipath/ipath_verbs.h          |    3 +-
> >>  drivers/infiniband/hw/mlx4/cq.c                    |   13 ++-
> >>  drivers/infiniband/hw/mlx4/mad.c                   |    5 +-
> >>  drivers/infiniband/hw/mlx4/main.c                  |   67 +++++++-
> >>  drivers/infiniband/hw/mlx4/mlx4_ib.h               |   19 ++-
> >>  drivers/infiniband/hw/mlx5/cq.c                    |   10 +-
> >>  drivers/infiniband/hw/mlx5/main.c                  |   19 ++-
> >>  drivers/infiniband/hw/mlx5/mlx5_ib.h               |    5 +-
> >>  drivers/infiniband/hw/mthca/mthca_provider.c       |   15 ++-
> >>  drivers/infiniband/hw/nes/nes_verbs.c              |   17 ++-
> >>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   13 ++-
> >>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h        |    9 +-
> >>  drivers/infiniband/hw/qib/qib_cq.c                 |   11 +-
> >>  drivers/infiniband/hw/qib/qib_verbs.c              |    6 +-
> >>  drivers/infiniband/hw/qib/qib_verbs.h              |    5 +-
> >>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   16 ++-
> >>  drivers/infiniband/hw/usnic/usnic_ib_verbs.h       |   10 +-
> >>  drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |    9 +-
> >>  drivers/infiniband/ulp/iser/iser_verbs.c           |    6 +-
> >>  drivers/infiniband/ulp/isert/ib_isert.c            |    6 +-
> >>  drivers/infiniband/ulp/srp/ib_srp.c                |   10 +-
> >>  drivers/infiniband/ulp/srpt/ib_srpt.c              |    5 +-
> >>  drivers/net/ethernet/mellanox/mlx4/main.c          |   19 ++
> >>  .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    7 +-
> >>  include/linux/mlx4/device.h                        |    9 +
> >>  include/rdma/ib_verbs.h                            |   25 ++-
> >>  include/uapi/rdma/ib_user_verbs.h                  |   19 ++
> >>  net/9p/trans_rdma.c                                |    5 +-
> >>  net/rds/ib_cm.c                                    |    8 +-
> >>  net/rds/iw_cm.c                                    |    8 +-
> >>  net/sunrpc/xprtrdma/svc_rdma_transport.c           |   10 +-
> >>  net/sunrpc/xprtrdma/verbs.c                        |   10 +-
> >>  49 files changed, 564 insertions(+), 139 deletions(-)
> >>
> >
> >
> > --
> > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >               GPG KeyID: 0E572FDD
> >
>=20
> Thanks for taking a look.
>=20
> Matan


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-xLY8SNhi4LQlM60ZKWMA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVbEEQAAoJELgmozMOVy/dKoEQAK24sB40lTtk7UodOnv34SBn
VN3HBdpELCidUVOHc3I2k/aLYT1RWNF2w73XNMN9i4j2EnEObUa757jXmIjHfIJH
7WhUHFpJbq5IfHiJfU3O1WZqxN9GZmUOAgNpLmv/sE4ubcuWCcNIlcjey7mcM0KI
R94n9cl5KIhTrqNED34e/Kv3H9Si4//xe+PjveBsSFy2DAPrmQCQt5Pu1FBYwFvt
hecZaqsPsmNCJJ6VCxqMEgmLc9KLNT3aZQcWFemSsJR+nG5/fkYNhTnNhzMpGh2K
5FwA4so8EcccFG/a9g8LET3dNnmlJqwbZ+weph2YZvo0/mzQaswBeblSeKLeGcDq
UUY0NsiOPnBw34ELx9v4PA6v2nV13rHO8tHTVnJi02AE0EkZObFhNGAh3YbOnTC1
w8R5oPfHK5Zx/f3Hyyovyi8xEO6mYdRGu1ZfE8CN9iHNaFI+MyUWRFz3JZunqk5+
/aL599yazqGvVDmVkhySIzMsFNqN6LgWqY48Ot4Egn+do74DE7rD/+AzHamSKuwE
emWZNFauAuGBrAzXUpxjFN0uBwDJ3xx0upgEkmigZWFz2t0Ly/6ckU+znhJDa7Og
oEKX16RXRY+yFnq/iJagq/c7bpecu3YGquoHmRwDPSijnklLXrqKRmf39GASy5S/
FCg1ZoLXiPn0YP5Hg14J
=tk3h
-----END PGP SIGNATURE-----

--=-xLY8SNhi4LQlM60ZKWMA--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
