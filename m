From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: IB softirq race
Date: Fri, 10 Aug 2012 13:51:30 -0700
Message-ID: <CAL1RGDUy3TvqBu+n6g=HertjrhBuVaJ+yDfx7-r1tJf_fbydRg@mail.gmail.com>
References: <502506B8.7080203@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <502506B8.7080203-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ri-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <ri-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 10, 2012 at 6:03 AM, Sebastian Riemer
<sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wrote:
> we've got a gateway machine which is connected to the internet via
> ethernet and is connected with our KVM VMs-providing cloud
> infrastructure via IB.
> There must have been a race with softirqs. We've got a custom kernel
> module ("xt_ETHOIP6_gw") which handles the Ethernet<>IB.

Not sure why you are counting on a race.  The dev_watchdog means that
the netdev has been stuck with a full transmit queue for a long time
(timescale of seconds).  Usually this means completions aren't happening
or aren't being reaped for some reason.

Without really looking at your module code, it's hard to guess what the issue
might be (and indeed you may just be triggering some existing bug).

> The trace looks like that it caused the kernel trace together with the
> tun driver. What does the "(O)" mean?

"(O)" means the module with the flag is an out-of-tree module.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
