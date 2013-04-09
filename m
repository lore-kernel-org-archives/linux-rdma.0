From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: tune ib stack
Date: Tue, 09 Apr 2013 13:43:48 +0200
Message-ID: <5163FEF4.1000507@profitbricks.com>
References: <CACaajQs7RHR9Uz_M46o+1zui8x=HneQFW-09V_XQbo8OQV3eoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQs7RHR9Uz_M46o+1zui8x=HneQFW-09V_XQbo8OQV3eoQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09.04.2013 13:12, Vasiliy Tolstov wrote:
> Hello. I have some servers, with mellanox ConnectX-3 and have some questions:
> Why max_mtu differs with active_mtu?

Because 2048 is the default and 4096 is the max. supported MTU by the
hardware.

> How can i set active mtu?

Something like this:
echo 4096 > /sys/class/infiniband/mlx4_0/device/mlx4_port1_mtu

> Why ibstatus says that i have only 10 Gb/s ?

Could be a bug. Which OFED/Kernel (if using in-tree IB modules) do you use?

Mine says with ConnectX2 QDR: "40 Gb/sec (4X QDR)"

> All cables support 40 Gb/s.
> 
> Thanks for any help.
> 
> Linux xen28 3.8.6-1-xen #1 SMP Fri Apr 5 18:48:02 UTC 2013 (713918b)
> x86_64 x86_64 x86_64 GNU/Linux
> 
> Infiniband device 'mlx4_0' port 1 status:
>         default gid:     fe80:0000:0000:0000:0025:90ff:ff17:9b25
>         base lid:        0x34
>         sm lid:          0x4
>         state:           4: ACTIVE
>         phys state:      5: LinkUp
>         rate:            10 Gb/sec (4X)
>         link_layer:      InfiniBand

You should see "40 Gb/sec (4X QDR)" here. Perhaps the OFED is too old so
that FDR and ConnectX 3 aren't supported, yet. "10 Gb/sec (4X)" seems to
be the default case if a rate isn't supported.

Cheers,
Sebastian

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
