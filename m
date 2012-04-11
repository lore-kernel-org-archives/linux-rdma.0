From: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: =?UTF-8?Q?ib=5Fsrpt=20and=20mellanox=20mthca=20device?=
Date: Wed, 11 Apr 2012 23:13:19 +0300
Message-ID: <fa3a67e9423946c0bbd23abb3f60921a@omrb.pnpi.spb.ru>
References: <5f95768153388b91a2ffa0cd118d7ad8@omrb.pnpi.spb.ru>
 <CAL1RGDWNqMdQGrXbh2gj==_KvVRF1mUQw2D3NqEhjvuq2q2+6Q@mail.gmail.com>
 <97cccba5ba7ddc74e87b0791050fa755@omrb.pnpi.spb.ru>
 <CAL1RGDVbqOQP+AH4f9cs+mEngXVTOy7r7gRjJ=SU_rMmvCg3Qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVbqOQP+AH4f9cs+mEngXVTOy7r7gRjJ=SU_rMmvCg3Qg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland!

Actual IB HBA is
store ~ # lspci -v  -s 4b:00.0
4b:00.0 InfiniBand: Mellanox Technologies MT25208 InfiniHost III Ex=20
(Tavor compatibility mode) (rev 20)
         Subsystem: Mellanox Technologies MT25208 InfiniHost III Ex=20
(Tavor compatibility mode)
         Physical Slot: 2-1
         Flags: bus master, fast devsel, latency 0, IRQ 16
         Memory at fdf00000 (64-bit, non-prefetchable) [size=3D1M]
         Memory at f7800000 (64-bit, prefetchable) [size=3D8M]
         Memory at e8000000 (64-bit, prefetchable) [size=3D128M]
         Capabilities: [40] Power Management version 2
         Capabilities: [48] Vital Product Data
         Capabilities: [90] MSI: Enable- Count=3D1/32 Maskable- 64bit+
         Capabilities: [84] MSI-X: Enable+ Count=3D32 Masked-
         Capabilities: [60] Express Endpoint, MSI 00
         Kernel driver in use: ib_mthca

It have  latest available firmware image

store tmp # ibv_devinfo -v
hca_id: mthca0
         transport:                      InfiniBand (0)
         fw_ver:                         4.8.930
         node_guid:                      001e:0bff:ff4c:0d30
         sys_image_guid:                 001e:0bff:ff4c:0d33
         vendor_id:                      0x1708
         vendor_part_id:                 25208
         hw_ver:                         0x20
         board_id:                       HP_0060000001
         phys_port_cnt:                  2
         max_mr_size:                    0xffffffffffffffff
         page_size_cap:                  0xfffff000
         max_qp:                         64512
         max_qp_wr:                      65535
         device_cap_flags:               0x00001c76
         max_sge:                        59
         max_sge_rd:                     0
         max_cq:                         65408
         max_cqe:                        131071
         max_mr:                         131056
         max_pd:                         32768
         max_qp_rd_atom:                 4
         max_ee_rd_atom:                 0
         max_res_rd_atom:                258048
         max_qp_init_rd_atom:            128
         max_ee_init_rd_atom:            0
         atomic_cap:                     ATOMIC_HCA (1)
         max_ee:                         0
         max_rdd:                        0
         max_mw:                         0
         max_raw_ipv6_qp:                0
         max_raw_ethy_qp:                0
         max_mcast_grp:                  8192
         max_mcast_qp_attach:            56
         max_total_mcast_qp_attach:      458752
         max_ah:                         0
         max_fmr:                        0
         max_srq:                        960
         max_srq_wr:                     65535
         max_srq_sge:                    31
         max_pkeys:                      64
         local_ca_ack_delay:             15
                 port:   1
                         state:                  PORT_INIT (2)
                         max_mtu:                2048 (4)
                         active_mtu:             512 (2)
                         sm_lid:                 0
                         port_lid:               0
                         port_lmc:               0x00
                         link_layer:             IB
                         max_msg_sz:             0x80000000
                         port_cap_flags:         0x02510a68
                         max_vl_num:             8 (4)
                         bad_pkey_cntr:          0x0
                         qkey_viol_cntr:         0x0
                         sm_sl:                  0
                         pkey_tbl_len:           64
                         gid_tbl_len:            32
                         subnet_timeout:         0
                         init_type_reply:        0
                         active_width:           4X (2)
                         active_speed:           5.0 Gbps (2)
                         phys_state:             LINK_UP (5)
                         GID[  0]:              =20
fe80:0000:0000:0000:001e:0bff:ff4c:0d31

                 port:   2
                         state:                  PORT_DOWN (1)
                         max_mtu:                2048 (4)
                         active_mtu:             512 (2)
                         sm_lid:                 0
                         port_lid:               0
                         port_lmc:               0x00
                         link_layer:             IB
                         max_msg_sz:             0x80000000
                         port_cap_flags:         0x02510a68
                         max_vl_num:             8 (4)
                         bad_pkey_cntr:          0x0
                         qkey_viol_cntr:         0x0
                         sm_sl:                  0
                         pkey_tbl_len:           64
                         gid_tbl_len:            32
                         subnet_timeout:         0
                         init_type_reply:        0
                         active_width:           4X (2)
                         active_speed:           2.5 Gbps (1)
                         phys_state:             POLLING (2)
                         GID[  0]:              =20
fe80:0000:0000:0000:001e:0bff:ff4c:0d32


Roland Dreier =D0=BF=D0=B8=D1=81=D0=B0=D0=BB 2012-04-11 23:06:
> On Wed, Apr 11, 2012 at 2:21 AM, Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>=20
> wrote:
>> I made tracing for srpt_add_one function. Trace log attached to mail
>
> It looks like the call to ib_create_srq() is failing.
>
> What specific HCA type do you have?  Do you have up-to-date firmware?
> I thought all mthca hardware is SRQ-capable, but you may need new=20
> enough
> firmware.
>
> What does "ibv_devinfo -v" show with ib_mthca and ib_uverbs loaded?
>
>  - R.

--=20
Best Regards,
Alexey 'Alexxy' Shvetsov
Petersburg Nuclear Physics Institute, Russia
Department of Molecular and Radiation Biophysics
Gentoo Team Ru
Gentoo Linux Dev
mailto:alexxyum-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
mailto:alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org
mailto:alexxy-heEE5zn7HfaV8fSEjHp0FA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
