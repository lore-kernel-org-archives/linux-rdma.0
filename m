From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: Need help with strange mlx4_core error
Date: Fri, 28 Feb 2014 22:24:13 +0400
Message-ID: <CACaajQtKvihFu6X-+9N3VvVKK4Jw3eADBOENhuM+-4s8s=PsUQ@mail.gmail.com>
References: <CACaajQtQGZSepA8VLK1K20OspNa_WTv1DQ8SWYV7O9y6QV-Tgg@mail.gmail.com>
 <CAJZOPZJmdGutUQZ4icBrKRq-YPwD8TqtoLH9SgqNVx_CDjL0TQ@mail.gmail.com>
 <CACaajQtHzF9g2kp9MrAaQsvKUQdr10YVa+Np1danmAcR_rvLqg@mail.gmail.com>
 <CAJZOPZKydkaoru0XyT1nHQ5t9BGJQxbq1r4RcGZ0Gq9E9VGs=A@mail.gmail.com>
 <CACaajQs9ANqLX7m=TcR2wT6wkiS-M5uVvAnQrvGWPmukZnLqcg@mail.gmail.com> <CACaajQuRzBy3oV+-3+NjyE9muGKPN3YQUd5wnkkcoak0GSP=uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQuRzBy3oV+-3+NjyE9muGKPN3YQUd5wnkkcoak0GSP=uw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2014-02-04 18:19 GMT+04:00 Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>:
> 2014-02-04 Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>:
>>> This is pretty much very old firmware, could you update it please with
>>> the latest GA from the mellanox site and see if things smile back?
>>> also send the "lspci | grep -i Mellanox"
>
>
> I'm update firmware to 2.7.200 (that is the latest from ftp
> supermicro). Now i'm try to test it.

Sorry for bumping old thread. Now i again have this error:
ibstat:
CA 'mlx4_0'
        CA type: MT26428
        Number of ports: 1
        Firmware version: 2.7.5558
        Hardware version: a0
        Node GUID: 0x003048ffff9dc9d8
        System image GUID: 0x003048ffff9dc9db
        Port 1:
                State: Active
                Physical state: LinkUp
                Rate: 40
                Base lid: 7
                LMC: 0
                SM lid: 6
                Capability mask: 0x02510868

dmesg:
[1067167.780266] <mlx4_ib> destroy_qp_common: modify QP 00110e to RESET failed.
[1068708.243893] <mlx4_ib> destroy_qp_common: modify QP 001118 to RESET failed.
[1174994.897394] mlx4_core 0000:03:00.0: Internal error detected:
[1174994.897484] mlx4_core 0000:03:00.0:   buf[00]: 001805a5
[1174994.897516] mlx4_core 0000:03:00.0:   buf[01]: 00000000
[1174994.897544] mlx4_core 0000:03:00.0:   buf[02]: 200715b6
[1174994.897577] mlx4_core 0000:03:00.0:   buf[03]: 00000000
[1174994.897607] mlx4_core 0000:03:00.0:   buf[04]: 0018050c
[1174994.897637] mlx4_core 0000:03:00.0:   buf[05]: 00000001
[1174994.897666] mlx4_core 0000:03:00.0:   buf[06]: 00002fd8
[1174994.897697] mlx4_core 0000:03:00.0:   buf[07]: 00000084
[1174994.897727] mlx4_core 0000:03:00.0:   buf[08]: 0000db9f
[1174994.897756] mlx4_core 0000:03:00.0:   buf[09]: 00004000
[1174994.897786] mlx4_core 0000:03:00.0:   buf[0a]: 00000000
[1174994.897815] mlx4_core 0000:03:00.0:   buf[0b]: 00000000
[1174994.897845] mlx4_core 0000:03:00.0:   buf[0c]: 00000000
[1174994.897874] mlx4_core 0000:03:00.0:   buf[0d]: 00000000
[1174994.897904] mlx4_core 0000:03:00.0:   buf[0e]: 00000000
[1174994.897934] mlx4_core 0000:03:00.0:   buf[0f]: 00000000
[1174994.897963] mlx4_en 0000:03:00.0: Internal error detected,
restarting device
[1175000.294830] <mlx4_ib> destroy_qp_common: modify QP 001eca to RESET failed.
[1175000.352029] bonding: bond1: releasing active interface ib0
[1175000.352072] bonding: bond1: Warning: clearing HW address of bond1
while it still has VLANs.
[1175000.352182] bonding: bond1: When re-adding slaves, make sure the
bond's HW address matches its VLANs'.
[1175000.352517] bonding: bond1: destroying bond bond1.
[1175000.354034] bonding: bond1: released all slaves
[1175000.354694] ib0: ib_cq_destroy (recv) failed
[1175000.354721] ib0: ib_destroy_srq failed: -16
[1175000.355780] ib0: ib_dealloc_pd failed




-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
