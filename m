From: Jeff Kirsher <jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Intel-wired-lan] [PATCH 1/1] timecounter: Make cyclecounter
 struct part of timecounter struct
Date: Wed, 06 Dec 2017 08:24:56 -0800
Message-ID: <1512577496.8693.0.camel@intel.com>
References: <1512189095-28654-1-git-send-email-sagar.a.kamble@intel.com>
Reply-To: jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-AYN6I3A77kR9u855MsqY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1512189095-28654-1-git-send-email-sagar.a.kamble-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagar Arun Kamble <sagar.a.kamble-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, intel-wired-lan-qjLDD68F18P21nG7glBr7A@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-AYN6I3A77kR9u855MsqY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2017-12-02 at 10:01 +0530, Sagar Arun Kamble wrote:
> There is no real need for the users of timecounters to define
> cyclecounter
> and timecounter variables separately. Since timecounter will always
> be
> based on cyclecounter, have cyclecounter struct as member of
> timecounter
> struct.
>=20
> Suggested-by: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
> Signed-off-by: Sagar Arun Kamble <sagar.a.kamble-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
> Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: intel-wired-lan-qjLDD68F18P21nG7glBr7A@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org
> Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org

Acked-by: Jeff Kirsher <jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

For the changes to the Intel drivers.

> ---
>  arch/microblaze/kernel/timer.c                     | 20 ++++++------
>  drivers/clocksource/arm_arch_timer.c               | 19 ++++++------
>  drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |  3 +-
>  drivers/net/ethernet/amd/xgbe/xgbe-ptp.c           |  9 +++---
>  drivers/net/ethernet/amd/xgbe/xgbe.h               |  1 -
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |  1 -
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   | 20 ++++++------
>  drivers/net/ethernet/freescale/fec.h               |  1 -
>  drivers/net/ethernet/freescale/fec_ptp.c           | 30 +++++++++---
> ------
>  drivers/net/ethernet/intel/e1000e/e1000.h          |  1 -
>  drivers/net/ethernet/intel/e1000e/netdev.c         | 27 ++++++++--
> ------
>  drivers/net/ethernet/intel/e1000e/ptp.c            |  2 +-
>  drivers/net/ethernet/intel/igb/igb.h               |  1 -
>  drivers/net/ethernet/intel/igb/igb_ptp.c           | 25 ++++++++--
> -----
>  drivers/net/ethernet/intel/ixgbe/ixgbe.h           |  1 -
>  drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       | 17 +++++-----
>  drivers/net/ethernet/mellanox/mlx4/en_clock.c      | 28 ++++++++--
> -------
>  drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |  1 -
>  .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 34 ++++++++++
> ----------
>  drivers/net/ethernet/qlogic/qede/qede_ptp.c        | 20 ++++++------
>  drivers/net/ethernet/ti/cpts.c                     | 36
> ++++++++++++----------
>  drivers/net/ethernet/ti/cpts.h                     |  1 -
>  include/linux/mlx5/driver.h                        |  1 -
>  include/linux/timecounter.h                        |  4 +--
>  include/sound/hdaudio.h                            |  1 -
>  kernel/time/timecounter.c                          | 28 ++++++++--
> -------
>  sound/hda/hdac_stream.c                            |  7 +++--
>  virt/kvm/arm/arch_timer.c                          |  6 ++--
>  28 files changed, 163 insertions(+), 182 deletions(-)
--=-AYN6I3A77kR9u855MsqY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAlooGdgACgkQ5W/vlVpL
7c7J0Q/9HHk6upECLnqxfft9A4opsw2bj4joMDVrmj4+wvdSrNvrbzQAJPwEl3El
fWwGBKNKmNyGjNa9dpEnactZ2xBtTLk9I9j1RvhdCS8JbQ8DYwxtlb9hAw6dk60z
/gn5M+pcYi7is5wNvZqMA81Ocek0QSi8Egnz3TLh+voV5g5opi7u/VdlsiczBAUo
fH+lqWPTSL4i19swopOjZdAYNKLqWMDeP40L8Zsbb5ZtNrib+8YAb82YuP1Tw+eQ
6jbHZFp5iB+WBRHo8xZ3QzENh9XdHoTmcX3tAUPRcqy9dJozsmXdIEJiJk7qNjgz
6XwtGJIle6jDXg9HOzkV8/2dv2v1J6CR0UAK0KsXQWhYKVBSN2Uj4gqxWuLczpcI
mHJ7MKWU9QnvcQEcVfQwO1b2y+reSjGyz9ABz5J6VwnvT+8Pcn2oPAIsOuVvRuJs
6tIRAinKealwOv8oRZ97zhoPTM+Sf4OC803GxHtwZ56jNRId6nSUbq2+qyJBwK1R
a7QLLkNdDIN6nt2VP6yywd+HrYtBo9CtJgS+mVNm6QhsTC4/wHGNeMLnjZ5i0LEW
J7gDCG78Wgrd6UoaZx6afq1S8rXvWBzFt9LEnHrcEezlMehbmYHdWajSWLZ6d7YD
Bq+D+QpbdGhyKIWEfspq1unwyw8CNCPAzKvb6w+hEdebk0Ia9Fc=
=rvB5
-----END PGP SIGNATURE-----

--=-AYN6I3A77kR9u855MsqY--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
