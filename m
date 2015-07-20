From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [BUG] mellanox IB driver fails to load on large config
Date: Mon, 20 Jul 2015 11:28:03 -0500
Message-ID: <20150720162803.GL58053@asylum.americas.sgi.com>
References: <20150710191506.GA52396@asylum.americas.sgi.com> <CAJ3xEMj82OtHcs+kDG_xrQZ4+x3Eih=YSNFR4+W-AoPNA=4jTw@mail.gmail.com> <20150714182234.GD17920@asylum.americas.sgi.com> <20150714184820.GB58053@asylum.americas.sgi.com> <CAJ3xEMig=GzROAea7qe0YO11DM6pc4wXyG8VB=kq5Hf5uw2ZXQ@mail.gmail.com> <20150714202848.GD58053@asylum.americas.sgi.com> <55A74E61.1080403@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55A74E61.1080403-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, andrew banman <abanman-sJ/iWh9BUns@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 16, 2015 at 09:25:37AM +0300, Or Gerlitz wrote:
> On 7/14/2015 11:28 PM, Alex Thorlton wrote:
>>
>> We see the same exact messages on 4.1-rc8.
>>
>>
>
> does this solves the problem?
>
>
> diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
> index ad31e47..c8ae3b9 100644
> --- a/include/linux/mlx4/device.h
> +++ b/include/linux/mlx4/device.h
> @@ -45,7 +45,7 @@
>  #include <linux/timecounter.h>
>
>  #define MAX_MSIX_P_PORT                17
> -#define MAX_MSIX               64
> +#define MAX_MSIX               1024
>  #define MIN_MSIX_P_PORT                5
>  #define MLX4_IS_LEGACY_EQ_MODE(dev_cap) ((dev_cap).num_comp_vectors < \
> (dev_cap).num_ports * MIN_MSIX_P_PORT)
> --
>

I've got some time on the large machine later today.  I'll give this a
try then.

Thanks, Or!

- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
