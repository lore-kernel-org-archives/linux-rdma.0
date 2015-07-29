From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipath: Move ipath driver to staging.
Date: Wed, 29 Jul 2015 10:31:18 -0400
Message-ID: <55B8E3B6.9040201@redhat.com>
References: <1437517366-20691-1-git-send-email-dennis.dalessandro@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vPAoRq2QI5OiAvhU3OMj6wfrTqeNw1Wl9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437517366-20691-1-git-send-email-dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vPAoRq2QI5OiAvhU3OMj6wfrTqeNw1Wl9
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/21/2015 06:22 PM, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> It is now time for the ipath driver to begin to be phased out of the ke=
rnel.
> This patch moves the ipath driver from the Infiniband sub tree to the s=
taging
> area where it will remain until the code is removed from the kernel in =
a few
> releases.

Please resubmit with a proper TODO file in the staging directory that
details when the driver is to be deleted (I suggest the 4.6 merge window)=
=2E

> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  MAINTAINERS                                        |    2 +-
>  drivers/infiniband/Kconfig                         |    1 -
>  drivers/infiniband/hw/Makefile                     |    1 -
>  drivers/staging/Kconfig                            |    2 ++
>  drivers/staging/Makefile                           |    1 +
>  drivers/{infiniband/hw =3D> staging}/ipath/Kconfig   |    4 +++-
>  drivers/{infiniband/hw =3D> staging}/ipath/Makefile  |    0
>  .../hw =3D> staging}/ipath/ipath_common.h            |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_cq.c    |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_debug.h |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_diag.c  |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_dma.c   |    0
>  .../hw =3D> staging}/ipath/ipath_driver.c            |    0
>  .../hw =3D> staging}/ipath/ipath_eeprom.c            |    0
>  .../hw =3D> staging}/ipath/ipath_file_ops.c          |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_fs.c    |    0
>  .../hw =3D> staging}/ipath/ipath_iba6110.c           |    0
>  .../hw =3D> staging}/ipath/ipath_init_chip.c         |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_intr.c  |    0
>  .../hw =3D> staging}/ipath/ipath_kernel.h            |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_keys.c  |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_mad.c   |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_mmap.c  |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_mr.c    |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_qp.c    |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_rc.c    |    0
>  .../hw =3D> staging}/ipath/ipath_registers.h         |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_ruc.c   |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_sdma.c  |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_srq.c   |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_stats.c |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_sysfs.c |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_uc.c    |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_ud.c    |    0
>  .../hw =3D> staging}/ipath/ipath_user_pages.c        |    0
>  .../hw =3D> staging}/ipath/ipath_user_sdma.c         |    0
>  .../hw =3D> staging}/ipath/ipath_user_sdma.h         |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_verbs.c |    0
>  .../{infiniband/hw =3D> staging}/ipath/ipath_verbs.h |    0
>  .../hw =3D> staging}/ipath/ipath_verbs_mcast.c       |    0
>  .../hw =3D> staging}/ipath/ipath_wc_ppc64.c          |    0
>  .../hw =3D> staging}/ipath/ipath_wc_x86_64.c         |    0
>  42 files changed, 7 insertions(+), 4 deletions(-)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/Kconfig (81%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/Makefile (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_common.h (100%=
)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_cq.c (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_debug.h (100%)=

>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_diag.c (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_dma.c (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_driver.c (100%=
)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_eeprom.c (100%=
)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_file_ops.c (10=
0%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_fs.c (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_iba6110.c (100=
%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_init_chip.c (1=
00%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_intr.c (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_kernel.h (100%=
)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_keys.c (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_mad.c (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_mmap.c (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_mr.c (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_qp.c (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_rc.c (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_registers.h (1=
00%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_ruc.c (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_sdma.c (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_srq.c (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_stats.c (100%)=

>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_sysfs.c (100%)=

>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_uc.c (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_ud.c (100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_user_pages.c (=
100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_user_sdma.c (1=
00%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_user_sdma.h (1=
00%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_verbs.c (100%)=

>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_verbs.h (100%)=

>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_verbs_mcast.c =
(100%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_wc_ppc64.c (10=
0%)
>  rename drivers/{infiniband/hw =3D> staging}/ipath/ipath_wc_x86_64.c (1=
00%)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8133cef..b76e8a3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5512,7 +5512,7 @@ IPATH DRIVER
>  M:	Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>  L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>  S:	Maintained
> -F:	drivers/infiniband/hw/ipath/
> +F:	drivers/staging/ipath/
> =20
>  IPMI SUBSYSTEM
>  M:	Corey Minyard <minyard-HInyCGIudOg@public.gmane.org>
> diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
> index b899531..7d6034f 100644
> --- a/drivers/infiniband/Kconfig
> +++ b/drivers/infiniband/Kconfig
> @@ -55,7 +55,6 @@ config INFINIBAND_ADDR_TRANS
>  	default y
> =20
>  source "drivers/infiniband/hw/mthca/Kconfig"
> -source "drivers/infiniband/hw/ipath/Kconfig"
>  source "drivers/infiniband/hw/qib/Kconfig"
>  source "drivers/infiniband/hw/ehca/Kconfig"
>  source "drivers/infiniband/hw/amso1100/Kconfig"
> diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Mak=
efile
> index e900b03..d1212c4 100644
> --- a/drivers/infiniband/hw/Makefile
> +++ b/drivers/infiniband/hw/Makefile
> @@ -1,5 +1,4 @@
>  obj-$(CONFIG_INFINIBAND_MTHCA)		+=3D mthca/
> -obj-$(CONFIG_INFINIBAND_IPATH)		+=3D ipath/
>  obj-$(CONFIG_INFINIBAND_QIB)		+=3D qib/
>  obj-$(CONFIG_INFINIBAND_EHCA)		+=3D ehca/
>  obj-$(CONFIG_INFINIBAND_AMSO1100)	+=3D amso1100/
> diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> index 7f6cae5..ad545a1 100644
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@ -112,4 +112,6 @@ source "drivers/staging/fsl-mc/Kconfig"
> =20
>  source "drivers/staging/wilc1000/Kconfig"
> =20
> +source "drivers/staging/ipath/Kconfig"
> +
>  endif # STAGING
> diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> index 347f647..350c5ea 100644
> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -48,3 +48,4 @@ obj-$(CONFIG_COMMON_CLK_XLNX_CLKWZRD)	+=3D clocking-w=
izard/
>  obj-$(CONFIG_FB_TFT)		+=3D fbtft/
>  obj-$(CONFIG_FSL_MC_BUS)	+=3D fsl-mc/
>  obj-$(CONFIG_WILC1000)		+=3D wilc1000/
> +obj-$(CONFIG_INFINIBAND_IPATH)  +=3D ipath/
> diff --git a/drivers/infiniband/hw/ipath/Kconfig b/drivers/staging/ipat=
h/Kconfig
> similarity index 81%
> rename from drivers/infiniband/hw/ipath/Kconfig
> rename to drivers/staging/ipath/Kconfig
> index 8fe54ff..041ce06 100644
> --- a/drivers/infiniband/hw/ipath/Kconfig
> +++ b/drivers/staging/ipath/Kconfig
> @@ -2,7 +2,7 @@ config INFINIBAND_IPATH
>  	tristate "QLogic HTX HCA support"
>  	depends on 64BIT && NET && HT_IRQ
>  	---help---
> -	This is a driver for the obsolete QLogic Hyper-Transport
> +	This is a driver for the deprecated QLogic Hyper-Transport
>  	IB host channel adapter (model QHT7140),
>  	including InfiniBand verbs support.  This driver allows these
>  	devices to be used with both kernel upper level protocols such
> @@ -12,3 +12,5 @@ config INFINIBAND_IPATH
> =20
>  	If you have this hardware you will need to boot with PAT disabled
>  	on your x86-64 systems, use the nopat kernel parameter.
> +
> +	Note that this driver will soon be removed entirely from the kernel.
> diff --git a/drivers/infiniband/hw/ipath/Makefile b/drivers/staging/ipa=
th/Makefile
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/Makefile
> rename to drivers/staging/ipath/Makefile
> diff --git a/drivers/infiniband/hw/ipath/ipath_common.h b/drivers/stagi=
ng/ipath/ipath_common.h
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_common.h
> rename to drivers/staging/ipath/ipath_common.h
> diff --git a/drivers/infiniband/hw/ipath/ipath_cq.c b/drivers/staging/i=
path/ipath_cq.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_cq.c
> rename to drivers/staging/ipath/ipath_cq.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_debug.h b/drivers/stagin=
g/ipath/ipath_debug.h
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_debug.h
> rename to drivers/staging/ipath/ipath_debug.h
> diff --git a/drivers/infiniband/hw/ipath/ipath_diag.c b/drivers/staging=
/ipath/ipath_diag.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_diag.c
> rename to drivers/staging/ipath/ipath_diag.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_dma.c b/drivers/staging/=
ipath/ipath_dma.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_dma.c
> rename to drivers/staging/ipath/ipath_dma.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/stagi=
ng/ipath/ipath_driver.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_driver.c
> rename to drivers/staging/ipath/ipath_driver.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_eeprom.c b/drivers/stagi=
ng/ipath/ipath_eeprom.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_eeprom.c
> rename to drivers/staging/ipath/ipath_eeprom.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/sta=
ging/ipath/ipath_file_ops.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_file_ops.c
> rename to drivers/staging/ipath/ipath_file_ops.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/staging/i=
path/ipath_fs.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_fs.c
> rename to drivers/staging/ipath/ipath_fs.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_iba6110.c b/drivers/stag=
ing/ipath/ipath_iba6110.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_iba6110.c
> rename to drivers/staging/ipath/ipath_iba6110.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_init_chip.c b/drivers/st=
aging/ipath/ipath_init_chip.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_init_chip.c
> rename to drivers/staging/ipath/ipath_init_chip.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_intr.c b/drivers/staging=
/ipath/ipath_intr.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_intr.c
> rename to drivers/staging/ipath/ipath_intr.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/stagi=
ng/ipath/ipath_kernel.h
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_kernel.h
> rename to drivers/staging/ipath/ipath_kernel.h
> diff --git a/drivers/infiniband/hw/ipath/ipath_keys.c b/drivers/staging=
/ipath/ipath_keys.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_keys.c
> rename to drivers/staging/ipath/ipath_keys.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/staging/=
ipath/ipath_mad.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_mad.c
> rename to drivers/staging/ipath/ipath_mad.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_mmap.c b/drivers/staging=
/ipath/ipath_mmap.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_mmap.c
> rename to drivers/staging/ipath/ipath_mmap.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_mr.c b/drivers/staging/i=
path/ipath_mr.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_mr.c
> rename to drivers/staging/ipath/ipath_mr.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_qp.c b/drivers/staging/i=
path/ipath_qp.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_qp.c
> rename to drivers/staging/ipath/ipath_qp.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_rc.c b/drivers/staging/i=
path/ipath_rc.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_rc.c
> rename to drivers/staging/ipath/ipath_rc.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_registers.h b/drivers/st=
aging/ipath/ipath_registers.h
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_registers.h
> rename to drivers/staging/ipath/ipath_registers.h
> diff --git a/drivers/infiniband/hw/ipath/ipath_ruc.c b/drivers/staging/=
ipath/ipath_ruc.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_ruc.c
> rename to drivers/staging/ipath/ipath_ruc.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_sdma.c b/drivers/staging=
/ipath/ipath_sdma.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_sdma.c
> rename to drivers/staging/ipath/ipath_sdma.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_srq.c b/drivers/staging/=
ipath/ipath_srq.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_srq.c
> rename to drivers/staging/ipath/ipath_srq.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_stats.c b/drivers/stagin=
g/ipath/ipath_stats.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_stats.c
> rename to drivers/staging/ipath/ipath_stats.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_sysfs.c b/drivers/stagin=
g/ipath/ipath_sysfs.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_sysfs.c
> rename to drivers/staging/ipath/ipath_sysfs.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_uc.c b/drivers/staging/i=
path/ipath_uc.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_uc.c
> rename to drivers/staging/ipath/ipath_uc.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_ud.c b/drivers/staging/i=
path/ipath_ud.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_ud.c
> rename to drivers/staging/ipath/ipath_ud.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_user_pages.c b/drivers/s=
taging/ipath/ipath_user_pages.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_user_pages.c
> rename to drivers/staging/ipath/ipath_user_pages.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_user_sdma.c b/drivers/st=
aging/ipath/ipath_user_sdma.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_user_sdma.c
> rename to drivers/staging/ipath/ipath_user_sdma.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_user_sdma.h b/drivers/st=
aging/ipath/ipath_user_sdma.h
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_user_sdma.h
> rename to drivers/staging/ipath/ipath_user_sdma.h
> diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/stagin=
g/ipath/ipath_verbs.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_verbs.c
> rename to drivers/staging/ipath/ipath_verbs.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.h b/drivers/stagin=
g/ipath/ipath_verbs.h
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_verbs.h
> rename to drivers/staging/ipath/ipath_verbs.h
> diff --git a/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c b/drivers/=
staging/ipath/ipath_verbs_mcast.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_verbs_mcast.c
> rename to drivers/staging/ipath/ipath_verbs_mcast.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_wc_ppc64.c b/drivers/sta=
ging/ipath/ipath_wc_ppc64.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_wc_ppc64.c
> rename to drivers/staging/ipath/ipath_wc_ppc64.c
> diff --git a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c b/drivers/st=
aging/ipath/ipath_wc_x86_64.c
> similarity index 100%
> rename from drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
> rename to drivers/staging/ipath/ipath_wc_x86_64.c
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--vPAoRq2QI5OiAvhU3OMj6wfrTqeNw1Wl9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVuOO3AAoJELgmozMOVy/dBJAP/RAgZs15z9J63cNY8Ka+oMXR
pCAHljhQriV5zVTKyPL8c9sTNFZLFD4y9BYaMywMGlZKarTBTKHOukfhD7cJflNN
h6iJe4JPnfd11d7TmojW0RlyOCjgLUlEWuH2Zig5nIf8ProJt8lb3ZZETD2lfZ+B
dXVHWYUazIXSk+wsB0e4YBsZ2+jTrYTZN6cltuAu2JSlyjLdQehkyKswyufkbn4i
gbzuRNkFR+1XnW91P8PrRWN3roqHbNJRdpQL8nE+0utrwddB/FbFSkv08U4Nd7gu
QnGqiX0BD5S+s2Bb0JXMD2EakywQYsfn3kw9lTpKbNVI1+IQYjkXUB5tHDHC6SNR
RfYqGQawgSLTjtEtSLh4Gui3u/EgMG/8JVHcCuP0JXPa4hyl4J4whI0z9ox9t/rs
1fK0cXtz/mV7PVXTlj0aq9bI5WRe4rhW7OGzPzfYWRZdxH6tkk7r8HjrlPgjJlj3
eZNnslrpAZuQk5i3eB46ZK0zB5Qv98foLrDOFhM4BBKCn9OdqQr6PmIx7hgKOot3
8WVA5tv5mx9FrVUKAatdPcA54noZWru0u9Vo4T5R7rpG4j74g1MRSGlgl7E+jawE
1xvaM7Oj+oZnC/EsuA3hhX5papPnmKfRwCDOdSrlkQAwkpwR+fQ6PUxDvj+gWKon
m8rrNu+N0UF9TJ7dDdnj
=+LeT
-----END PGP SIGNATURE-----

--vPAoRq2QI5OiAvhU3OMj6wfrTqeNw1Wl9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
