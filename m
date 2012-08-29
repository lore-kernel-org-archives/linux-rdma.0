From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: IPoIB performance
Date: Wed, 29 Aug 2012 15:35:13 -0400
Message-ID: <FFD82983-4A73-4A52-B6BE-C63DA16A507C@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi all,

I am benchmarking a sockets based application and I want a sanity check on IPoIB performance expectations when using connected mode (65520 MTU). I am using the tuning tips in Documentation/infiniband/ipoib.txt. The machines have Mellanox QDR cards (see below for the verbose ibv_devinfo output). I am using a 2.6.36 kernel. The hosts have single socket Intel E5520 (4 core with hyper-threading on) at 2.27 GHz.

I am using netperf's TCP_STREAM and binding cores. The best I have seen is ~13 Gbps. Is this the best I can expect from these cards?

What should I expect as a max for ipoib with FDR cards?

Thanks,

Scott



hca_id: mlx4_0
        transport:                      InfiniBand (0)
        fw_ver:                         2.7.626
        node_guid:                      0002:c903:000b:6520
        sys_image_guid:                 0002:c903:000b:6523
        vendor_id:                      0x02c9
        vendor_part_id:                 26428
        hw_ver:                         0xB0
        board_id:                       MT_0D90110009
        phys_port_cnt:                  1
        max_mr_size:                    0xffffffffffffffff
        page_size_cap:                  0xfffffe00
        max_qp:                         65464
        max_qp_wr:                      16384
        device_cap_flags:               0x006c9c76
        max_sge:                        32
        max_sge_rd:                     0
        max_cq:                         65408
        max_cqe:                        4194303
        max_mr:                         131056
        max_pd:                         32764
        max_qp_rd_atom:                 16
        max_ee_rd_atom:                 0
        max_res_rd_atom:                1047424
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
        max_srq:                        65472
        max_srq_wr:                     16383
        max_srq_sge:                    31
        max_pkeys:                      128
        local_ca_ack_delay:             15
                port:   1
                        state:                  PORT_ACTIVE (4)
                        max_mtu:                2048 (4)
                        active_mtu:             2048 (4)
                        sm_lid:                 6
                        port_lid:               8
                        port_lmc:               0x00
                        link_layer:             InfiniBand
                        max_msg_sz:             0x40000000
                        port_cap_flags:         0x02510868
                        max_vl_num:             8 (4)
                        bad_pkey_cntr:          0x0
                        qkey_viol_cntr:         0x0
                        sm_sl:                  0
                        pkey_tbl_len:           128
                        gid_tbl_len:            128
                        subnet_timeout:         18
                        init_type_reply:        0
                        active_width:           4X (2)
                        active_speed:           10.0 Gbps (4)
                        phys_state:             LINK_UP (5)
                        GID[  0]:               fe80:0000:0000:0000:0002:c903:000b:6521

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
