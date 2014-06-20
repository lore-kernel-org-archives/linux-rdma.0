From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: rmmod mlx4_core panic 3.16-rc1
Date: Fri, 20 Jun 2014 09:17:04 +0300
Message-ID: <CAJZOPZJaStV41bbj-qHZVfTi2m__9J_TqNcYJ1kkc=X12cJWPw@mail.gmail.com>
References: <53A259F3.3040203@oracle.com>
	<CAJZOPZK__Qo2LcTpL3R0=WOzsLKY2FYT_7VkKXThGiPWF8wv_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZK__Qo2LcTpL3R0=WOzsLKY2FYT_7VkKXThGiPWF8wv_g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wei Yang <weiyang-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 20, 2014 at 6:34 AM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Jun 19, 2014 at 6:33 AM, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>> 1. Whether IB VFs is supported in ConnectX-2 (mlx4 driver)?
>> I tried to num_vfs={port1,port2,port1+2} when loading mlx4_core module, it failed with mlx4_core 0000:40:00.0: Invalid syntax of num_vfs/probe_vfs with IB port - single port VFs syntax is only supported when all ports are configured as ethernet

> What do you mean by "port1" and "port2" -- can you give the exact
> command line you used?

> Single ported VFs are currently supported for Ethernet only
> configuration, that is not for only IB nor for VPI, that is only if
> you use port_type_arrary=2,2

Note that you can still use dual-ported VFs, for both IB, Ethernet and
VPI, that is
num_vfs=N will create N dual-ported VFs, are you on IB?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
