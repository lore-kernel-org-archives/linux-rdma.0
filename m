From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [BUG] mellanox IB driver fails to load on large config
Date: Tue, 21 Jul 2015 17:21:19 +0300
Message-ID: <CAAKD3BB_2E+U4O8fO=uBTOqrahbwRR_o+rPUKRi1aRfMurNRBg@mail.gmail.com>
References: <20150710191506.GA52396@asylum.americas.sgi.com>
	<CAJ3xEMj82OtHcs+kDG_xrQZ4+x3Eih=YSNFR4+W-AoPNA=4jTw@mail.gmail.com>
	<20150714182234.GD17920@asylum.americas.sgi.com>
	<20150714184820.GB58053@asylum.americas.sgi.com>
	<CAJ3xEMig=GzROAea7qe0YO11DM6pc4wXyG8VB=kq5Hf5uw2ZXQ@mail.gmail.com>
	<20150714202848.GD58053@asylum.americas.sgi.com>
	<55A74E61.1080403@mellanox.com>
	<20150720162803.GL58053@asylum.americas.sgi.com>
	<20150721025639.GX58053@asylum.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150721025639.GX58053-UiYq4lDBhggTG1waqwXmH7Cf4lofQVJ7@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, andrew banman <abanman-sJ/iWh9BUns@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 21, 2015 at 5:56 AM, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org> wrote:
> On Mon, Jul 20, 2015 at 11:28:03AM -0500, Alex Thorlton wrote:
>> I've got some time on the large machine later today.  I'll give this a
>> try then.
>
> I ran a boot with this patch applied:
>
> diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
> index 83e80ab..c84aea0 100644
> --- a/include/linux/mlx4/device.h
> +++ b/include/linux/mlx4/device.h
> @@ -45,7 +45,7 @@
>  #include <linux/timecounter.h>
>
>  #define MAX_MSIX_P_PORT                17
> -#define MAX_MSIX               64
> +#define MAX_MSIX               8192
>  #define MSIX_LEGACY_SZ         4
>  #define MIN_MSIX_P_PORT                5
>
> I went for a max of 8192, since I was actually booting the machine with
> 6144 cores (not 4096) for this run.  It doesn't look like this fixed the
> problem.  I still saw the same errors during boot.
>
> FWIW, the module does appear to still successfully load:
>
> 8<---
> # lsmod | grep mlx
> mlx4_ib               151552  0
> ib_sa                  32768  1 mlx4_ib
> ib_mad                 49152  2 ib_sa,mlx4_ib
> ib_core               102400  3 ib_sa,mlx4_ib,ib_mad
> mlx4_core             278528  1 mlx4_ib
> --->8
>
> If the module loading is good enough, and we should just ignore the
> errors, then I'm fine with that.  Just wanting to make sure that
> everything is behaving correctly.

It shouldn't be a problem,  as all unused/erroneous EQs get "-1".
We'll try to reproduce the problem here, it might take awhile though.

Thanks for checking this,
Matan

>
> - Alex
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
