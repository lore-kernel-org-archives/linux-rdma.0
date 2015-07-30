From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V6 0/5] HW Device hot-removal support
Date: Thu, 30 Jul 2015 12:46:52 -0400
Message-ID: <55BA54FC.8060905@redhat.com>
References: <1435659967-27173-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8glbWiGAweidxUF7kBo95DQ2Jne2StOGH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435659967-27173-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8glbWiGAweidxUF7kBo95DQ2Jne2StOGH
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/30/2015 06:26 AM, Yishai Hadas wrote:
> Currently, if there is any user space application using an IB device,
> it is impossible to unload the HW device driver for this device.
>=20
> Similarly, if the device is hot-unplugged or reset, the device driver
> hardware removal flow blocks until all user contexts are destroyed.
>=20
> This patchset removes the above limitations from both uverbs and ucma.
>=20
> The IB-core and uverbs layers are still required to remain loaded as
> long as there are user applications using the verbs API. However, the
> hardware device drivers are not blocked any more by the user space
> activity.
>=20
> To support this, the hardware device needs to expose a new kernel API
> named 'disassociate_ucontext'. The device driver is given a ucontext
> to detach from, and it should block this user context from any future
> hardware access. In the IB-core level, we use this interface to
> deactivate all ucontext that address a specific device when handling a
> remove_one callback for it.
>=20
> In the RDMA-CM layer, a similar change is needed in the ucma module,
> to prevent blocking of the remove_one operation. This allows for
> hot-removal of devices with RDMA-CM users in the user space.
>=20
> The first two patches are preparation for this series.
> The first patch fixes a reference counting issue pointed by Jason Gunth=
orpe.
> The second patch is a preparation step for deploying RCU for the device=

> removal flow.
>=20
> The third patch introduces the new API between the HW device driver and=

> the IB core. For devices which implement the functionality, IB core
> will use it in remove_one, disassociating any active ucontext from the
> hardware device. Other drivers that didn't implement it will behave as
> today, remove_one will block until all ucontexts referring the device
> are destroyed before returning.
>=20
> The fourth patch provides implementation of this API for the mlx4
> driver.
>=20
> The last patch extends ucma to avoid blocking remove_one operation in
> the cma module. When such device removal event is received, ucma is
> turning all user contexts to zombie contexts. This is done by
> releasing all underlying resources and preventing any further user
> operations on the context.
>=20
> Changes from V5:
> Addressed Jason's comments for below patches:
> patch #1: Improve kref usage.
> patch #3: Use 2 different krefs for complete and memory, improve some c=
omments.
>=20
> Changes from V4:
> patch #1,#3 - addressed Jason's comments.
> patch #2, #4 - rebased upon last stuff.
>=20
> Changes from V3:
> Add 2 patches as a preparation for this series, details above.
> patch #3: Change the locking schema based on Jason's comments.
>=20
> Changes from V2:
> patch #1: Rebase over ODP patches.
>=20
> Changes from V1:
> patch #1: Use uverbs flags instead of disassociate support, drop fatal_=
event_raised flag.
> patch #3: Add support in ucma for handling device removal.
>=20
> Changes from V0:
> patch #1: ib_uverbs_close, reduced mutex scope to enable tasks run in p=
arallel.
> Yishai Hadas (5):
>   IB/uverbs: Fix reference counting usage of event files
>   IB/uverbs: Explicitly pass ib_dev to uverbs commands
>   IB/uverbs: Enable device removal when there are active user space
>     applications
>   IB/mlx4_ib: Disassociate support
>   IB/ucma: HW Device hot-removal support
>=20
>  drivers/infiniband/core/ucma.c        |  130 +++++++++-
>  drivers/infiniband/core/uverbs.h      |   16 +-
>  drivers/infiniband/core/uverbs_cmd.c  |  114 ++++++----
>  drivers/infiniband/core/uverbs_main.c |  438 +++++++++++++++++++++++++=
++------
>  drivers/infiniband/hw/mlx4/main.c     |  139 ++++++++++-
>  drivers/infiniband/hw/mlx4/mlx4_ib.h  |   13 +
>  include/rdma/ib_verbs.h               |    1 +
>  7 files changed, 714 insertions(+), 137 deletions(-)
>=20

I've pulled this series in for 4.3.  There were some additional items in
some of Jason's comments that ought to be looked into, but I think this
patch set has reached the point where it's no worse than existing in
terms of locking, there were just some existing issues that should be
addressed too.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--8glbWiGAweidxUF7kBo95DQ2Jne2StOGH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVulT8AAoJELgmozMOVy/dg04P/ieCiGFL6kLa/XX3EtvjW8Dy
58/kaYE5rD5S72B+Ba9MloQRczFMzuTXok9vag9qCdjS6e2Ai/oQpqJC8mqvJGxW
n6pZl73LvqduUsuW/7vnhrQCd/qtpGtyKIsroYhqCdIyCxLDS5+/Gr73azFzHGq5
pUzRo8blw9xIRsmihupapN+yMaSSeKWKkL6mZBjqfxZkrCunC7o4qQf3LhFFTdJ7
t09l1YuVRe1nJbqy0xdEvx8oBE0KzYv8/yEa1tEvpvpH4muEnyrQA4wS8YKxkDZY
uE0ITsDYRVWQZPbjlNiPICv+wGiU38UoIt0akARGR+KP3HsKnBScauQ2L1h2N7rI
8kOV7T1fuVXsRcSqVTN4ZB/WH92qmLJHsYKHkI+neDVljyMQq4iarUr8GovhGWAv
UJjGkYf1Ou9FecwQ6eMimPsgu6Iv2w0TwMMwI3UgyyyhhHeEJ01LJU8sOWbfJJ3d
AROlIOR1jOrCXixWQMvSeJ34XS3gpDDPMnofPfXVX0IniWdxQBzTtEK8tvRNxOza
clTYgPwwy4FUdWfi6RJxdQ4zpFLlnSwzNnSu634lJ8Jc7gE4ziNLBqX5Lspe0+CS
PbLWam9U3ksDVAqt0WDECUkL1t3zarnXIpyS4sjvUk5ysVh6DzvXNW6cgrQe5Cux
Im0Kn+cvrNiHpusH1cxB
=KkLs
-----END PGP SIGNATURE-----

--8glbWiGAweidxUF7kBo95DQ2Jne2StOGH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
