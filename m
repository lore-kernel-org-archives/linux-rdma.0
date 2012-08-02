From: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: FDR HCA only doing QDR?
Date: Thu, 2 Aug 2012 10:18:51 +0200
Message-ID: <CALfB72AFcWfrvRHfh0fRu_0iLt0wdapgwPef6RFe3KockzxeEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello all

I have a single machine setup with a dual port Mellanox FDR controller
with a cable marked "FDR" connected between the two ports.

OpenSM is running on the machine to make the ports active.

However, as far as I can read the ibv_devinfo output, it seems to
report that I'm only getting QDR speeds.

Software versions:

kernel-3.4.4-4.fc16.x86_64
libibverbs-1.1.6-1.fc16.x86_64
libibverbs-utils-1.1.6-1.fc16.x86_64
libmlx4-1.0.2-3.fc16.x86_64
libibumad-1.3.7-1.fc16.x86_64
opensm-3.3.13-2.fc16.x86_64
libibmad-1.3.8-1.fc16.x86_64

As far as I can tell from the changelogs, these versions should have
all the FDR bits. Any suggestions on how to debug this further?

Regards

Albert

hca_id: mlx4_0
        transport:                      InfiniBand (0)
        fw_ver:                         2.10.600
        node_guid:                      0002:c903:00f9:ecc0
        sys_image_guid:                 0002:c903:00f9:ecc3
        vendor_id:                      0x02c9
        vendor_part_id:                 4099
        hw_ver:                         0x0
        board_id:                       MT_1090120019
        phys_port_cnt:                  2
        max_mr_size:                    0xffffffffffffffff
        page_size_cap:                  0xfffffe00
        max_qp:                         131008
        max_qp_wr:                      16384
        device_cap_flags:               0x007c9c76
        max_sge:                        32
        max_sge_rd:                     0
        max_cq:                         65408
        max_cqe:                        4194303
        max_mr:                         524272
        max_pd:                         32764
        max_qp_rd_atom:                 16
        max_ee_rd_atom:                 0
        max_res_rd_atom:                2096128
        max_qp_init_rd_atom:            128
        max_ee_init_rd_atom:            0
        atomic_cap:                     ATOMIC_HCA (1)
        max_ee:                         0
        max_rdd:                        0
        max_mw:                         0
        max_raw_ipv6_qp:                0
        max_raw_ethy_qp:                0
        max_mcast_grp:                  8192
        max_mcast_qp_attach:            248
        max_total_mcast_qp_attach:      2031616
        max_ah:                         0
        max_fmr:                        0
        max_srq:                        65472
        max_srq_wr:                     16383
        max_srq_sge:                    31
        max_pkeys:                      128
        local_ca_ack_delay:             15
                port:   1
                        state:                  PORT_ACTIVE (4)
                        max_mtu:                4096 (5)
                        active_mtu:             4096 (5)
                        sm_lid:                 1
                        port_lid:               1
                        port_lmc:               0x00
                        link_layer:             InfiniBand
                        max_msg_sz:             0x40000000
                        port_cap_flags:         0x0251486a
                        max_vl_num:             8 (4)
                        bad_pkey_cntr:          0x0
                        qkey_viol_cntr:         0x0
                        sm_sl:                  0
                        pkey_tbl_len:           128
                        gid_tbl_len:            128
                        subnet_timeout:         18
                        init_type_reply:        0
                        active_width:           4X (2)
                        active_speed:           10.0 Gbps (8)
                        phys_state:             LINK_UP (5)
                        GID[  0]: fe80:0000:0000:0000:0002:c903:00f9:ecc1

                port:   2
                        state:                  PORT_ACTIVE (4)
                        max_mtu:                4096 (5)
                        active_mtu:             4096 (5)
                        sm_lid:                 1
                        port_lid:               2
                        port_lmc:               0x00
                        link_layer:             InfiniBand
                        max_msg_sz:             0x40000000
                        port_cap_flags:         0x02514868
                        max_vl_num:             8 (4)
                        bad_pkey_cntr:          0x0
                        qkey_viol_cntr:         0x0
                        sm_sl:                  0
                        pkey_tbl_len:           128
                        gid_tbl_len:            128
                        subnet_timeout:         18
                        init_type_reply:        0
                        active_width:           4X (2)
                        active_speed:           10.0 Gbps (8)
                        phys_state:             LINK_UP (5)
                        GID[  0]: fe80:0000:0000:0000:0002:c903:00f9:ecc2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
