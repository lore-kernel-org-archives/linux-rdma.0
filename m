From: "Bob Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: [patch v2 37/37] add Kconfig
Date: Fri, 5 Aug 2011 14:19:47 -0500
Message-ID: <027e01cc53a4$a47f2640$ed7d72c0$@systemfabricworks.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201229.966262587@systemfabricworks.com> <CAO+b5-oFKiAhTkCntAo5_mMCtdg1vb1eM_mTi-8E-T_atHa_3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-oFKiAhTkCntAo5_mMCtdg1vb1eM_mTi-8E-T_atHa_3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Bart Van Assche
> Sent: Friday, August 05, 2011 1:44 PM
> To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [patch v2 37/37] add Kconfig
> 
> On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> +config INFINIBAND_RXE
> +	tristate "Software RDMA over Ethernet (RoCE) driver"
> +	depends on INET && PCI && INFINIBAND
> +	---help---
> +	This driver implements the InfiniBand RDMA transport over
> +	the Linux network stack. It enables a system with a
> 
> Shouldn't that read "an Ethernet network" instead of "the Linux network
> stack" ?

Technically it will run over more than just Ethernet. RXE plugs in at the
same place as IP on top of the netdev core.
There are some assumptions about the size of the L2 address that make it
work better on Ethernet but I used to run it over the loopback device and it
also runs over VLANs.

> 
> +	standard Ethernet adapter to interoperate with a RoCE
> +	adapter or with another system running the RXE driver.
> +	Documentation on InfiniBand and RoCE can be downloaded at
> +	www.infinibandta.org and www.openfabrics.org. (See also
> +	siw which is a similar software driver for iWARP.)
> 
> Isn't RoCE an official IBTA standard ? If so, seems like a good idea
> to me to mention that here.

I'll do that for v3.

> 
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
