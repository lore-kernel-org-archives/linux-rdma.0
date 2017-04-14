From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Common MMIO accessors for rdma-core
Date: Fri, 14 Apr 2017 07:18:46 +0000
Message-ID: <AB1D5E63-2FEA-4486-9CAA-DE3D1E7583DD@mellanox.com>
References: <1492123127-6266-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492123127-6266-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Apr 14, 2017, at 1:39 AM, Jason Gunthorpe <jgunthorpe@obsidianresearch=
.com> wrote:
>=20
> I've been threatening to do this for a while, here is a refactoring of th=
e
> MMIO accessors into a common set of functions that unify all the weird
> options accumulated in the various providers:
>=20
> - Normal 64 bit accessors
> - 32 bit emulation of 64 bit write
> - ia32 XMM support for 64 bit write
> - s390 syscall accessors
>=20
> This is a big complex transformation that has lots of possibility for lit=
tle
> mistakes, it would be good for other people to look closely at this befor=
e we
> merge it.
Hi Jason and Doug,

We are on holidays vacation until next Tuesday and thus we won't be able to=
 review it until then.
Please hold on with merging it until we review/ack it.

Thanks
>=20
> This is available on my github:
>=20
> https://github.com/jgunthorpe/rdma-plumbing/tree/mmio
>=20
> For this starting point I only converted the Mellanox drivers, because th=
ey
> are all basically the same.
>=20
> This fixes one bug in the mlx_read_clock function which attempted to doub=
le
> read a register without telling the compiler, which was miscompiling :(
>=20
> I have another series on top of this:
>=20
> https://github.com/jgunthorpe/rdma-plumbing/tree/sparse4
>=20
> Which does the last few things to make the Mellanox drivers sparse clean.
>=20
> Jason Gunthorpe (5):
>  util: Add common mmio macros
>  mlx4: Use util/mmio.h
>  mlx5: Use util/mmio.h
>  mthca: Use util/mmio.h
>  Add mmio_memcpy_x64
>=20
> CMakeLists.txt                |  16 +++
> buildlib/config.h.in          |   2 +
> buildlib/rdma_functions.cmake |   4 +-
> providers/mlx4/cq.c           |  14 ++-
> providers/mlx4/doorbell.h     |  70 -----------
> providers/mlx4/mlx4.c         |   1 -
> providers/mlx4/mlx4.h         |   1 -
> providers/mlx4/mmio.h         | 116 ------------------
> providers/mlx4/qp.c           |  10 +-
> providers/mlx4/srq.c          |   1 -
> providers/mlx4/verbs.c        |   9 +-
> providers/mlx5/cq.c           |  13 ++-
> providers/mlx5/doorbell.h     |  67 -----------
> providers/mlx5/mlx5.c         |   2 -
> providers/mlx5/mlx5.h         |   1 -
> providers/mlx5/qp.c           |  22 ++--
> providers/mlx5/srq.c          |   1 -
> providers/mlx5/verbs.c        |   9 +-
> providers/mthca/cq.c          |  38 +++---
> providers/mthca/doorbell.h    | 109 +----------------
> providers/mthca/qp.c          |  44 ++++---
> providers/mthca/srq.c         |  14 ++-
> util/CMakeLists.txt           |  20 +++-
> util/dummy.c                  |   0
> util/mmio.c                   |  83 +++++++++++++
> util/mmio.h                   | 265 +++++++++++++++++++++++++++++++++++++=
+++++
> 26 files changed, 480 insertions(+), 452 deletions(-)
> delete mode 100644 providers/mlx4/doorbell.h
> delete mode 100644 providers/mlx4/mmio.h
> delete mode 100644 providers/mlx5/doorbell.h
> create mode 100644 util/dummy.c
> create mode 100644 util/mmio.c
> create mode 100644 util/mmio.h
>=20
> --=20
> 2.7.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
