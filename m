From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 0/5] Device hot plug support
Date: Mon, 10 Jul 2017 19:23:12 +0300
Message-ID: <20170710162312.GP1528@mtr-leonro.local>
References: <1499699137-29037-1-git-send-email-yishaih@mellanox.com>
 <20170710155832.GM1528@mtr-leonro.local>
 <985e4646-0afa-f0f1-2c0e-e5757e839765@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CLLB+19uC8aeq76E"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <985e4646-0afa-f0f1-2c0e-e5757e839765-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--CLLB+19uC8aeq76E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 10, 2017 at 07:05:12PM +0300, Yishai Hadas wrote:
> On 7/10/2017 6:58 PM, Leon Romanovsky wrote:
> > On Mon, Jul 10, 2017 at 06:05:32PM +0300, Yishai Hadas wrote:
> > > This patch set from Maor adds support for device hot plug.
> > > Sending V1 to handle some cleanup note came on github from Jason, details
> > > below.
> > >
> > > Hot plug is the method in which a new hardware becomes available in the system
> > > or is being removed from it.
> > >
> > > The IB device list is returned by ibv_get_device_list() from libibverbs.
> > > Today, this list is created once by scanning /sys/class/infiniband_verbs, the
> > > list is cached and never updated, no matter if there were hardware changes in
> > > the system.
> > >
> > > libibverbs must be able to provide the application access to new ibv_device
> > > objects, according to the recent system hardware changes.
> > >
> > > For this purpose, the device scanning logic, should be separated from the
> > > libibverbs singleton initialization step, an updated list should be returned
> > > upon any call to ibv_get_device_list().
> > >
> > > User can call ibv_open_device() while holding this list (see man pages) and once
> > > ibv_free_device_list() is called libibverbs can release the unused ibv_device
> > > objects. Later, upon a call to ibv_close_device() the ibv_device object should
> > > be released.
> > >
> > > Currently, on ibv_free_device_list(), only the array is freed, while the
> > > ibv_device objects are never freed.
> > >
> > > This series comes to handle the above notes based on the discussion that followed
> > > an RFC on that.
> > >
> > > The solution:
> > > - The initialization part was separated from ibv_get_device_list().
> > > - Upon a call to ibv_get_device_list() the sysfs is scanned to look for
> > >   new/removed entries.
> > > - Same device is recognized based on name and timestamp creation.
> > > - libibverbs will maintain a ref count for each verbs_device object, once
> > >   it became zero, it calls the provider library to release the 'strcut
> > >   verbs_device' which it allocated before. For this purpose each provider library
> > >   provide a function to release the verbs_device.
> > >
> > > Further details exist in the commit logs of the series.
> > >
> > > Pull request was sent:
> > > https://github.com/linux-rdma/rdma-core/pull/157
> > >
> > > Changes from V0:
> > > #Patch #3: Use the introduced mutex also for the initialization step, dropping
> > >            the pthread_once usage.
> > >
> > > Yishai
> > > Maor Gottlieb (5):
> > >   utils: Add timespec compare utility
> > >   verbs: Split ibverbs_init functionality
> > >   verbs: Refresh cahced ibv_device list
> > >   verbs: Avoid ibv_device memory leak
> > >   providers: Add support for uninit_device for all providers
> > >
> > >  debian/libibverbs1.symbols         |   2 +-
> > >  libibverbs/device.c                |  50 +++++++----
> > >  libibverbs/driver.h                |   6 ++
> > >  libibverbs/ibverbs.h               |   5 +-
> > >  libibverbs/init.c                  | 166 ++++++++++++++++++++++++-------------
> > >  libibverbs/libibverbs.map          |   2 +-
> > >  providers/cxgb3/iwch.c             |  10 ++-
> > >  providers/cxgb4/dev.c              |  10 ++-
> > >  providers/hfi1verbs/hfiverbs.c     |  10 ++-
> > >  providers/hns/hns_roce_u.c         |  10 ++-
> > >  providers/i40iw/i40iw_umain.c      |  10 ++-
> > >  providers/ipathverbs/ipathverbs.c  |  10 ++-
> > >  providers/mlx4/mlx4.c              |   8 ++
> > >  providers/mlx5/mlx5.c              |   8 ++
> > >  providers/mthca/mthca.c            |  10 ++-
> > >  providers/nes/nes_umain.c          |   9 +-
> > >  providers/ocrdma/ocrdma_main.c     |  10 ++-
> > >  providers/qedr/qelr_main.c         |  10 ++-
> > >  providers/rxe/rxe.c                |   8 ++
> > >  providers/vmw_pvrdma/pvrdma_main.c |  10 ++-
> > >  srp_daemon/srp_daemon.h            |   7 +-
> > >  util/util.h                        |   6 ++
> > >  22 files changed, 284 insertions(+), 93 deletions(-)
> >
> > Shouldn't man pages be updated too?
> >
>
> The man pages are up-to-date with current solution and now the code really
> behaves as described to return the currently available devices.
>
> From man page:
> "ibv_get_device_list()  returns  a  NULL-terminated array of RDMA devices
> *currently* available"
>

Excellent, thanks

>
>

--CLLB+19uC8aeq76E
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlljqfAACgkQ5GN7iDZy
WKeWuRAAo5+VYfbcvhpfVGV2eZUSr4bb2idle4i1bHTGeBgy1Qi2R6P5NOELAXnT
swy03+4OTPoazpUQCN4ovLmuICC5v59hkGzc3xAr3nrIGdcV3gZ1E0tY8Gy0HQOq
toszisXAR8ByAYTYRJA+bSxz+JWacxHPiM3448lPG9AgcpB3WOdRZrERPmISUeyJ
olrkaT/toRAq5fcEkuuC8nT43gUkCJZB7LaaLfRkYAlss3hSIa6S4Wc4F/Trnd4H
vh4ERewWwti/4QnaXeDMziVtM2CP/EqS4c9sTlCHhINwZLUkiGV5V0q3ELJEnJOe
6hW4BTcsxOeMvK88GTjtZP6CLp2tl7c0ucxNskA4B5+jtSNcoEHEtK0AoZW1gPrL
fxP6S3UFWPz0+DeKRAhljt0ssaSEk4fKSXRmqdVioo4rmT5Q7OEnLbF2VVjzC06c
yAqflw/r2vuyi0618qpmfKn6NR1v0Dy0sAeFQvVTL9hkbx6+G5UgqgV6Aiju9MQx
QOV+OpAfB4P2mJClLHiFTexzlJXOe2Pj0g7cJnxbSifje+byhLEDgbqBydCbcocx
V/umKwHB6lqw1+CFQ0ML/y0unLPjGFYExhZTXjTEJ29ArQXRSnLXW2RgDGqd1z66
45vXYIw7rjGQv1SOPqurhSg3w0+VTF+JmRedag8AKqTp8qeKDus=
=K8wQ
-----END PGP SIGNATURE-----

--CLLB+19uC8aeq76E--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
