From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 0/5] Device hot plug support
Date: Mon, 10 Jul 2017 18:58:32 +0300
Message-ID: <20170710155832.GM1528@mtr-leonro.local>
References: <1499699137-29037-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sTC4Ri5uc2u6z9Yo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499699137-29037-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--sTC4Ri5uc2u6z9Yo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 10, 2017 at 06:05:32PM +0300, Yishai Hadas wrote:
> This patch set from Maor adds support for device hot plug.
> Sending V1 to handle some cleanup note came on github from Jason, details
> below.
>
> Hot plug is the method in which a new hardware becomes available in the system
> or is being removed from it.
>
> The IB device list is returned by ibv_get_device_list() from libibverbs.
> Today, this list is created once by scanning /sys/class/infiniband_verbs, the
> list is cached and never updated, no matter if there were hardware changes in
> the system.
>
> libibverbs must be able to provide the application access to new ibv_device
> objects, according to the recent system hardware changes.
>
> For this purpose, the device scanning logic, should be separated from the
> libibverbs singleton initialization step, an updated list should be returned
> upon any call to ibv_get_device_list().
>
> User can call ibv_open_device() while holding this list (see man pages) and once
> ibv_free_device_list() is called libibverbs can release the unused ibv_device
> objects. Later, upon a call to ibv_close_device() the ibv_device object should
> be released.
>
> Currently, on ibv_free_device_list(), only the array is freed, while the
> ibv_device objects are never freed.
>
> This series comes to handle the above notes based on the discussion that followed
> an RFC on that.
>
> The solution:
> - The initialization part was separated from ibv_get_device_list().
> - Upon a call to ibv_get_device_list() the sysfs is scanned to look for
>   new/removed entries.
> - Same device is recognized based on name and timestamp creation.
> - libibverbs will maintain a ref count for each verbs_device object, once
>   it became zero, it calls the provider library to release the 'strcut
>   verbs_device' which it allocated before. For this purpose each provider library
>   provide a function to release the verbs_device.
>
> Further details exist in the commit logs of the series.
>
> Pull request was sent:
> https://github.com/linux-rdma/rdma-core/pull/157
>
> Changes from V0:
> #Patch #3: Use the introduced mutex also for the initialization step, dropping
>            the pthread_once usage.
>
> Yishai
> Maor Gottlieb (5):
>   utils: Add timespec compare utility
>   verbs: Split ibverbs_init functionality
>   verbs: Refresh cahced ibv_device list
>   verbs: Avoid ibv_device memory leak
>   providers: Add support for uninit_device for all providers
>
>  debian/libibverbs1.symbols         |   2 +-
>  libibverbs/device.c                |  50 +++++++----
>  libibverbs/driver.h                |   6 ++
>  libibverbs/ibverbs.h               |   5 +-
>  libibverbs/init.c                  | 166 ++++++++++++++++++++++++-------------
>  libibverbs/libibverbs.map          |   2 +-
>  providers/cxgb3/iwch.c             |  10 ++-
>  providers/cxgb4/dev.c              |  10 ++-
>  providers/hfi1verbs/hfiverbs.c     |  10 ++-
>  providers/hns/hns_roce_u.c         |  10 ++-
>  providers/i40iw/i40iw_umain.c      |  10 ++-
>  providers/ipathverbs/ipathverbs.c  |  10 ++-
>  providers/mlx4/mlx4.c              |   8 ++
>  providers/mlx5/mlx5.c              |   8 ++
>  providers/mthca/mthca.c            |  10 ++-
>  providers/nes/nes_umain.c          |   9 +-
>  providers/ocrdma/ocrdma_main.c     |  10 ++-
>  providers/qedr/qelr_main.c         |  10 ++-
>  providers/rxe/rxe.c                |   8 ++
>  providers/vmw_pvrdma/pvrdma_main.c |  10 ++-
>  srp_daemon/srp_daemon.h            |   7 +-
>  util/util.h                        |   6 ++
>  22 files changed, 284 insertions(+), 93 deletions(-)

Shouldn't man pages be updated too?

Thanks

>
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--sTC4Ri5uc2u6z9Yo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlljpCgACgkQ5GN7iDZy
WKcbOQ/6AyfNSX7tvHmNbYZFgQjsFMbZGCQlkB41Zbetc1cM1vD4YjA9uc4Yfw02
MHHeDuT8wBy9T5oIq7ft5vW3+52EuE69wIIbtVbAflo5EUcNPRdFIllZtyuAmg5q
okLHQIv4aQza6qhpZ86QNYFUswLAmTnRS0v1cb2B9fUDuyp89HA0QklkzSkwpn2R
VSwgvz8ijTMtCYZzXz/QFJ3OE/hsLOtjQUCJiRMKE8f4WCaDhTpLbLnMmLmtzDlB
us7UaoTzj5xQ9yzt3Ih2a4euv7x8IEdhjbfUh21n/n1qZdze6FwCGCyq9mvVSFPP
nQszG5eyYMZbHe+Qj2qFJ+f886ON6SrymvJQ1exL7+MpWe+bV5xS4RjzI/Tg/YvB
erDldtWY/ZO48kQx6eDqJbbuQ8ByAtu0412qJ8lsctcMeRYwr8kb02EZsfCMLaAn
OIiWvAWS9H+QWFflLXZ05p9ysO/m9Fy/8vC7+pg98aZbhwb8hbLF1jgZuTpF2Klh
+LxczZt6Pp7ONqDaFTnvDrRqLtyLqRcc4D945bN63vUC419edAwe5D79MnYNuCRl
T4WNU8ErUP2VG5vYVJ0RmvPb/tmsDEqQwJVCr+OCzuMycH22PMBS5vSXOPm/nwKK
Z3oIDvztMVFtcB9D6Zc4F8KtLgiLS0Shci7hOUuD5AaJn88FO50=
=gexT
-----END PGP SIGNATURE-----

--sTC4Ri5uc2u6z9Yo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
