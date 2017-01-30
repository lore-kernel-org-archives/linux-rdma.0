From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: any suggested configuration for rxe?
Date: Mon, 30 Jan 2017 11:35:52 +0200
Message-ID: <CAG9sBKPj9wJhwZOFDXoOwH0=tBZR1pWdS6chYn_VK6SLdDQ7Xg@mail.gmail.com>
References: <CAJ-uSQZcnQ+Mqj1XGuMSzP54WQi6KofDyp11dCog+bqGmL3MWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ-uSQZcnQ+Mqj1XGuMSzP54WQi6KofDyp11dCog+bqGmL3MWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: feu tche <feutche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 30, 2017 at 3:05 AM, feu tche <feutche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi guys,
>
> Is there any configuration (distro/kernel/rdma-core branch) you can
> suggest to try out software rdma (rxe)?
>
> I'm trying to get software rdma working to enable local testing on the
> vm (vmware) without going proper hardware and so far can't get
> pingpong tool working.
> I've tried CentOS 7.2 first by building vanilla 4.9.5 with rxe enabled
> Now I've tried Ubuntu 16.04.1, using built ubuntu 4.9.5 build with
> rxe. I've noticed that rxe is actually enabled by default as module so
> now tried just released 4.9.6 as well.
> I've tried linux-rdma/rdma-core master and rdma-core-12 tag and lately
> rleon/rdma-core debian-fixes-last
>
> What I get is (in all the cases I've tried) that module is loaded and
> looks ok, however serverside ibv_rc_pingpong fails when client
> connects with:
>
> root@xdev:~/rdma-core-rleon# ibv_rc_pingpong -d rxe0 -g 0 -i 1
>   local address:  LID 0x0000, QPN 0x000012, PSN 0xaa7393, GID
> fe80::20c:29ff:fe87:5082
>   remote address: LID 0x0000, QPN 0x000013, PSN 0xf70e00, GID
> fe80::20c:29ff:fe87:5082
> Completion for unknown wr_id 0
> parse WC failed 2
>
> Below is output of other checks, all looks good as far as I understand.
>
> If you can suggest anything, please let me know.
>
> Thanks!
>
> Fedor
>
> root@xdev:~# uname -a
> Linux xdev 4.9.6-040906-generic #201701260330 SMP Thu Jan 26 08:32:10
> UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>
> root@xdev:~# lsmod | grep rxe
> rdma_rxe              114688  1
> ip6_udp_tunnel         16384  1 rdma_rxe
> udp_tunnel             16384  1 rdma_rxe
> ib_core               204800  6 rdma_rxe,ib_cm,rdma_cm,ib_uverbs,iw_cm,rdma_ucm
>
> root@xdev:~# lsmod | grep ib_uverbs
> ib_uverbs              65536  4 rdma_ucm
> ib_core               204800  6 rdma_rxe,ib_cm,rdma_cm,ib_uverbs,iw_cm,rdma_ucm
>
> root@xdev:~# rxe_cfg status
>   Name   Link  Driver  Speed  NMTU  IPv4_addr        RDEV  RMTU
>   ens33  yes   e1000          1500  192.168.237.132  rxe0  1024  (3)
>
> root@xdev:~# ibv_devices
>     device                 node GUID
>     ------              ----------------
>     rxe0                020c29fffe875082
>
> root@xdev:~# ibv_devinfo -d rxe0
> hca_id: rxe0
>         transport:                      InfiniBand (0)
>         fw_ver:                         0.0.0
>         node_guid:                      020c:29ff:fe87:5082
>         sys_image_guid:                 0000:0000:0000:0000
>         vendor_id:                      0x0000
>         vendor_part_id:                 0
>         hw_ver:                         0x0
>         phys_port_cnt:                  1
>                 port:   1
>                         state:                  PORT_ACTIVE (4)
>                         max_mtu:                4096 (5)
>                         active_mtu:             1024 (3)
>                         sm_lid:                 0
>                         port_lid:               0
>                         port_lmc:               0x00
>                         link_layer:             Ethernet
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

please try ibv_rc_pingpong with -g 1 and not g 0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
