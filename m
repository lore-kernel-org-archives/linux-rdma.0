From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: ibv_rc_pingpong, rping, and other tools hang with Linux 4.10.0
 and rdma-core 13
Date: Sun, 26 Feb 2017 18:09:34 +0200
Message-ID: <4e077022-5e5f-6ba8-530c-b86d2f09313e@mellanox.com>
References: <CABQspYbv7j58pdLLbPegE8Bc3qhwb-3+4E8SQ2U9jObkeTbrzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABQspYbv7j58pdLLbPegE8Bc3qhwb-3+4E8SQ2U9jObkeTbrzw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: GAFBlizzard <gtschemer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Youngjae Lee <dhrkaeh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/25/2017 5:27 AM, GAFBlizzard wrote:
> Hello,
>
> I have Linux 4.10.0 stable running on two at91 ARM machines.  I have
> rdma-core 13 installed on both.
>
> "rxe_cfg status" shows normal information, e.g.:
>   Name  Link  Driver  Speed  NMTU  IPv4_addr     RDEV  RMTU
>   eth0  yes   macb           1500  192.168.0.12  rxe0  1024  (3)
>
> "ibv_devinfo" likewise shows normal information, e.g.:
> hca_id: rxe0
>  transport:   InfiniBand (0)
>  fw_ver:    0.0.0
>  node_guid:   1034:56ff:fe84:1952
>  sys_image_guid:   0000:0000:0000:0000
>  vendor_id:   0x0000
>  vendor_part_id:   0
>  hw_ver:    0x0
>  phys_port_cnt:   1
>   port: 1
>    state:   PORT_ACTIVE (4)
>    max_mtu:  4096 (5)
>    active_mtu:  1024 (3)
>    sm_lid:   0
>    port_lid:  0
>    port_lmc:  0x00
>    link_layer:  Ethernet
>
>
> Every communication tool I have tried hangs after printing remote
> address information.  No errors are printed or logged in dmesg.
> Example:
>
> ## This is system A
> # ibv_rc_pingpong -d rxe0 -g 1 -i 1 192.168.0.12
>   local address:  LID 0x0000, QPN 0x000011, PSN 0xd1d8a8, GID
> ::ffff:192.168.0.11
>   remote address: LID 0x0000, QPN 0x000011, PSN 0xc55eed, GID
> ::ffff:192.168.0.12
>
> ## This is system B
> # ibv_rc_pingpong -d rxe0 -g 1 -i 1
>   local address:  LID 0x0000, QPN 0x000011, PSN 0xc55eed, GID
> ::ffff:192.168.0.12
>   remote address: LID 0x0000, QPN 0x000011, PSN 0xd1d8a8, GID
> ::ffff:192.168.0.11
>
>
>
> If it makes a difference, I have a 10/100 switch connected at the
> moment.  I am merely trying to verify functionality, not reach high
> speeds.
>
> I have found previous message(s) with similar problems on mailing
> lists and online but no resolution to date.  Is there any
> configuration option I might have missed?  I have no iptables
> firewall, and have even tried directly connecting the two systems
> instead of using the Ethernet switch.
>
Hi all,

I succeeded to reproduce the issue on my x86 setup.
The last time my user-space libraries weren't up to date and thus it passed.

I bisected the rdma-core library and figured out that the following 
commit introduced this regression:
6b26a9e24739 Use C11 atomics instead of wmb/rmb macros for CPU-only atomics

I haven't debugged this yet and would appreciate Jason's input.

Can you confirm that reverting the previous commit solves the issues on 
ARM as well?

Thanks

> Thanks,
> G
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
