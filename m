From: "Brown, Aaron F" <aaron.f.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [Intel-wired-lan] [PATCH 01/27] timecounter: Make cyclecounter
 struct part of timecounter struct
Date: Mon, 8 Jan 2018 22:20:35 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B8C734DF8@ORSMSX101.amr.corp.intel.com>
References: <1513323522-15021-1-git-send-email-sagar.a.kamble@intel.com>
 <1513323522-15021-2-git-send-email-sagar.a.kamble@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1513323522-15021-2-git-send-email-sagar.a.kamble-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org" <alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "intel-wired-lan-qjLDD68F18P21nG7glBr7A@public.gmane.org" <intel-wired-lan-qjLDD68F18P21nG7glBr7A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Kamble, Sagar A" <sagar.a.kamble-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Intel-wired-lan [mailto:intel-wired-lan-bounces-CJG/fkoVOTIdnm+yROfE0A@public.gmane.org] On
> Behalf Of Sagar Arun Kamble
> Sent: Thursday, December 14, 2017 11:38 PM
> To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>;
> Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>; Chris Wilson <chris@chris-
> wilson.co.uk>; John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>; intel-wired-
> lan-qjLDD68F18P21nG7glBr7A@public.gmane.org; Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>; Kamble, Sagar A
> <sagar.a.kamble-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org; linux-arm-
> kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> Subject: [Intel-wired-lan] [PATCH 01/27] timecounter: Make cyclecounter
> struct part of timecounter struct
> 
> There is no real need for the users of timecounters to define cyclecounter
> and timecounter variables separately. Since timecounter will always be
> based on cyclecounter, have cyclecounter struct as member of timecounter
> struct.
> 
> v2: Rebase.
> 
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
> Acked-by: Jeff Kirsher <jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> (Intel drivers)
> ---
>  arch/microblaze/kernel/timer.c                     | 20 ++++++------
>  drivers/clocksource/arm_arch_timer.c               | 19 ++++++------
>  drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |  3 +-
>  drivers/net/ethernet/amd/xgbe/xgbe-ptp.c           |  9 +++---
>  drivers/net/ethernet/amd/xgbe/xgbe.h               |  1 -
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |  1 -
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   | 20 ++++++------
>  drivers/net/ethernet/freescale/fec.h               |  1 -
>  drivers/net/ethernet/freescale/fec_ptp.c           | 30 +++++++++---------
>  drivers/net/ethernet/intel/e1000e/e1000.h          |  1 -
>  drivers/net/ethernet/intel/e1000e/netdev.c         | 27 ++++++++--------
>  drivers/net/ethernet/intel/e1000e/ptp.c            |  2 +-
>  drivers/net/ethernet/intel/igb/igb.h               |  1 -
>  drivers/net/ethernet/intel/igb/igb_ptp.c           | 25 ++++++++-------
>  drivers/net/ethernet/intel/ixgbe/ixgbe.h           |  1 -
>  drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       | 17 +++++-----
>  drivers/net/ethernet/mellanox/mlx4/en_clock.c      | 28 ++++++++---------
>  drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |  1 -
>  .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 34 ++++++++++----------
>  drivers/net/ethernet/qlogic/qede/qede_ptp.c        | 20 ++++++------
>  drivers/net/ethernet/ti/cpts.c                     | 36 ++++++++++++----------
>  drivers/net/ethernet/ti/cpts.h                     |  1 -
>  include/linux/mlx5/driver.h                        |  1 -
>  include/linux/timecounter.h                        |  4 +--
>  include/sound/hdaudio.h                            |  1 -
>  kernel/time/timecounter.c                          | 28 ++++++++---------
>  sound/hda/hdac_stream.c                            |  7 +++--
>  virt/kvm/arm/arch_timer.c                          |  6 ++--
>  28 files changed, 163 insertions(+), 182 deletions(-)
> 

For Intel e1000e and igb drivers:
Tested-by: Aaron Brown <aaron.f.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
