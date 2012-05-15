From: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: Old SDR IB HBA
Date: Tue, 15 May 2012 22:31:18 +0300
Message-ID: <a5e77072fa7ebef170d9558adaac4ca8@omrb.pnpi.spb.ru>
References: <d004e56b0a274ba55134840a93060de4@omrb.pnpi.spb.ru>
 <CAJZOPZL0MuNnjP8=CyQqL+GC7RDyMGTt_ng+iYbFDOpdrv3ZWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZL0MuNnjP8=CyQqL+GC7RDyMGTt_ng+iYbFDOpdrv3ZWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Affected kernel version 3.3

c-2-1 1 # uname -a
Linux c-2-1.local 3.3.4-gentoo #2 SMP Thu May 3 16:08:32 MSK 2012=20
x86_64 Dual Core AMD Opteron(tm) Processor 280 AuthenticAMD GNU/Linux

PS It doesnt have patches related to ib so its like vanilla =3DD
btw seems like ibv_devinfo reports correct speed
c-2-1 1 # ibv_devinfo -v
hca_id: mthca0
         transport:                      InfiniBand (0)
         fw_ver:                         1.0.800
         node_guid:                      0002:c902:0023:05a0
         sys_image_guid:                 0002:c902:0023:05a3
         vendor_id:                      0x02c9
         vendor_part_id:                 25204
         hw_ver:                         0xA0
         board_id:                       MT_03B0120001
         phys_port_cnt:                  1
         max_mr_size:                    0xffffffffffffffff
         page_size_cap:                  0xfffff000
         max_qp:                         64512
         max_qp_wr:                      16384
         device_cap_flags:               0x00001c76
         max_sge:                        27
         max_sge_rd:                     0
         max_cq:                         65408
         max_cqe:                        131071
         max_mr:                         131056
         max_pd:                         32764
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
         max_srq_wr:                     16384
         max_srq_sge:                    27
         max_pkeys:                      64
         local_ca_ack_delay:             15
                 port:   1
                         state:                  PORT_ACTIVE (4)
                         max_mtu:                2048 (4)
                         active_mtu:             2048 (4)
                         sm_lid:                 15
                         port_lid:               47
                         port_lmc:               0x00
                         link_layer:             IB
                         max_msg_sz:             0x80000000
                         port_cap_flags:         0x02510a68
                         max_vl_num:             4 (3)
                         bad_pkey_cntr:          0x0
                         qkey_viol_cntr:         0x0
                         sm_sl:                  0
                         pkey_tbl_len:           64
                         gid_tbl_len:            32
                         subnet_timeout:         18
                         init_type_reply:        0
                         active_width:           4X (2)
                         active_speed:           2.5 Gbps (1)
                         phys_state:             LINK_UP (5)
                         GID[  0]:              =20
fe80:0000:0000:0000:0002:c902:0023:05a1


Or Gerlitz =D0=BF=D0=B8=D1=81=D0=B0=D0=BB 2012-05-15 22:27:
> On Tue, May 15, 2012 at 10:16 PM, Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>=
=20
> wrote:
>
>> Is it normal that kenrnel reports 8.5G speed on old SDR mellanox=20
>> HBA?
>
> yes, there used to be a bug that could cause that, what kernel
> produced this output?
>
>> c-2-1 1 # ibstatus
>> Infiniband device 'mthca0' port 1 status:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0default gid: =C2=A0 =C2=A0 fe80:0000:0000=
:0000:0002:c902:0023:05a1
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0base lid: =C2=A0 =C2=A0 =C2=A0 =C2=A00x2f
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0sm lid: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0xf
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0state: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 4: ACTIVE
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0phys state: =C2=A0 =C2=A0 =C2=A05: LinkUp
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0rate: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A08.5 Gb/sec (4X)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0link_layer: =C2=A0 =C2=A0 =C2=A0InfiniBan=
d
>
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
=20
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Best Regards,
Alexey 'Alexxy' Shvetsov
Petersburg Nuclear Physics Institute, NRC Kurchatov Institute,=20
Gatchina, Russia
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
