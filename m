From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 rdma-core 0/7] libhns: userspace library for hns
Date: Fri, 11 Nov 2016 14:42:40 +0200
Message-ID: <20161111124240.GG28957@leon.nu>
References: <1478781977-116803-1-git-send-email-oulijun@huawei.com>
 <20161110161550.GD28957@leon.nu>
 <5825673A.1050109@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cyV/sMl4KAhiehtf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5825673A.1050109-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--cyV/sMl4KAhiehtf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 11, 2016 at 02:37:46PM +0800, oulijun wrote:
> =E5=9C=A8 2016/11/11 0:15, Leon Romanovsky =E5=86=99=E9=81=93:
> > On Thu, Nov 10, 2016 at 08:46:10PM +0800, Lijun Ou wrote:
> >> This patch series introduces userspace library for hns RoCE driver.
> >>
> >> changes v2 -> v3:
> >> 1. Fix the code style, for example, if (addr =3D=3D NULL)
> >> 2. Fix the bug for hns_roce_u_reg_mr
> >>
> >> changes v1 -> v2:
> >> 1. Delete the min() definition and instead of ccan header
> >> 2. Delete the CHECK_C_SOURCE_COMPILES
> >> 3. sort the c file in rdma_provider()
> >> 4. Delete the unused code in hns_roce_u_db.h
> >>
> >> Lijun Ou (7):
> >>   libhns: Add initial main frame
> >>   libhns: Add verbs of querying device and querying port
> >>   libhns: Add verbs of pd and mr support
> >>   libhns: Add verbs of cq support
> >>   libhns: Add verbs of qp support
> >>   libhns: Add verbs of post_send and post_recv support
> >>   libhns: Add consolidated repo for userspace library of hns
> >
> > Hi Lijun,
> >
> > I tried to take your patch set, but it fails to pass our Travis CI
> > tests.
> >
> > https://github.com/linux-rdma/rdma-core/pull/38
> > https://travis-ci.org/linux-rdma/rdma-core/builds/174815897
> >
> > You need to fix it prior to our acceptance.
> >
> > Thanks
> >
> Hi, Leon
>   I have checked the patches and fixed it and send the patchv4. I think t=
hat
> the patchv4 will not have errors and warnings for travis CI testing, but
> I don't have the Travis CI environment for testing it.
> I have tried to install the test environment according to your test log a=
nd it
> is fail.
> In addtion that, I have tested it for  patchv1/patchv2/patch3 by use the =
following way and it
> is ok
>  1. directly use the default script file build.sh
>     ./build.sh
>  2. use CC=3Daarch64-linux-gnu-gcc build
>     mkdir build
>     cd build
>     CC=3Daarch64-linux-gnu-gcc cmake -Gninja -DENABLE_RESOLVE_NEIGH=3D0 ..

Generally speaking, you have 4 possible ways to check your code prior
your submission:
1. Use Travis CI locally [1].
2. Fork rdma-core to your personal github account which can be connected
to Travis CI for free.
3. Install all required tools and run/compile locally
4. Send pull request to rdma-core via github interface and it will check
automatically.

First 3 options are the best.

[1]
https://docs.travis-ci.com/user/common-build-problems/#Troubleshooting-Loca=
lly-in-a-Docker-Image

>
> lijun Ou
> >
> >>
> >>  CMakeLists.txt                   |   1 +
> >>  MAINTAINERS                      |   6 +
> >>  README.md                        |   1 +
> >>  providers/hns/CMakeLists.txt     |   6 +
> >>  providers/hns/hns_roce_u.c       | 228 +++++++++++
> >>  providers/hns/hns_roce_u.h       | 255 ++++++++++++
> >>  providers/hns/hns_roce_u_abi.h   |  69 ++++
> >>  providers/hns/hns_roce_u_buf.c   |  61 +++
> >>  providers/hns/hns_roce_u_db.h    |  54 +++
> >>  providers/hns/hns_roce_u_hw_v1.c | 839 ++++++++++++++++++++++++++++++=
+++++++++
> >>  providers/hns/hns_roce_u_hw_v1.h | 242 +++++++++++
> >>  providers/hns/hns_roce_u_verbs.c | 525 ++++++++++++++++++++++++
> >>  12 files changed, 2287 insertions(+)
> >>  create mode 100644 providers/hns/CMakeLists.txt
> >>  create mode 100644 providers/hns/hns_roce_u.c
> >>  create mode 100644 providers/hns/hns_roce_u.h
> >>  create mode 100644 providers/hns/hns_roce_u_abi.h
> >>  create mode 100644 providers/hns/hns_roce_u_buf.c
> >>  create mode 100644 providers/hns/hns_roce_u_db.h
> >>  create mode 100644 providers/hns/hns_roce_u_hw_v1.c
> >>  create mode 100644 providers/hns/hns_roce_u_hw_v1.h
> >>  create mode 100644 providers/hns/hns_roce_u_verbs.c
> >>
> >> --
> >> 1.9.1
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

--cyV/sMl4KAhiehtf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYJbzAAAoJEORje4g2clinGxAP/0Ov2pv1sDmf1BZEpIncMGzI
dr9X2lorkfGB/6BcCRxYQJ3hbfUBxKtIuHUxl+Z5qHq0C4zq0xUzF5DdQZpBBb3C
uiFGHskSMnvtFvPRmytHk8a3oNRtym2IveEL8M+WbuH9M3TWUTMJSgKPQWpJTKHc
FV7ZRChI+M6y29jPz0dLYCU7hCqRCb3MTiFzHpmOcsRv8G7G7okPcNxHu1lFGVkx
vy85I6OHJU0Cr6/Y2huWAaVY/KdznwtxYXE36uOq2OOZvY2EJ8vQs44bQE3VJMrI
uAuDpqKbi16BMmTN3OX/d6JKmDKeTzOmz2KJoDtaNLWbsrTItqy9Gy0R9MjpzDJd
ecAm1lNUZCtM2l06Oj9ogO3O6uLqoLUCKpxf/2Di6CKtGmxj4K5gTxELTRGxGPv0
5mTQrReeA2o8kqCQa+5+zHAaalGdVv5I3OQ2dupAfJNbujRPMBQtlpL0Pi+LadvO
PfGNwdiUblFRzx6UYTwGbvnzzXiEv//fjs3u8XssLhxIAGLPB4MauDwbCee2I8nf
D7uuzdVyB/4eSXm4v32uXpE2Gb8YZ0egGeBBtJVNpDr+M2ISV7xgmbIdNV5qV+H7
z7NXeBzrI6hMae/rWPXwzWbdMG4MSoN8q8EFIc27GS9cpViTTbKAmeHqKBRtqG35
SpIz+9MN4mqg/sII8ZcA
=CftW
-----END PGP SIGNATURE-----

--cyV/sMl4KAhiehtf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
